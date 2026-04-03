<?php

namespace App\Jobs;

use App\Models\Song;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;


class GenerateLyricsJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public $songId;
    public $audioPublicId;

    public $tries   = 3;
    public $backoff = [30, 60, 120];
    public $timeout = 300;

    public function __construct($songId, $audioPublicId)
    {
        $this->songId        = $songId;
        $this->audioPublicId = $audioPublicId;
    }

    public function handle(): void
    {
        $tempPath = null;

        try {
            Log::info('GenerateLyricsJob started', [
                'song_id'         => $this->songId,
                'audio_public_id' => $this->audioPublicId,
            ]);

            $song = Song::find($this->songId);
            if (!$song) {
                throw new \Exception("Song not found: {$this->songId}");
            }

            $song->update(['lyrics_status' => 'processing', 'lyrics_error' => null]);

            // Download audio về temp với đuôi .mp3
            $audioUrl = $this->buildAudioUrl($this->audioPublicId);
            $tempPath = $this->downloadAudio($audioUrl);

            // Kiểm tra lyrics hiện tại của bài hát
            $existingLyrics = $this->parseExistingLyrics($song->lyrics);
            $hasManualLyrics = count($existingLyrics) > 0 &&
                               collect($existingLyrics)->contains(fn($l) => !empty(trim($l['text'] ?? '')));

            if ($hasManualLyrics) {
                // ── MODE 1: Admin đã nhập lyrics → Groq chỉ cấp timestamps ──
                Log::info('Manual lyrics found — using Groq for timestamps only', [
                    'song_id'     => $this->songId,
                    'line_count'  => count($existingLyrics),
                ]);
                $formattedLyrics = $this->alignLyricsWithTimestamps($tempPath, $existingLyrics);
            } else {
                // ── MODE 2: Chưa có lyrics → Groq transcribe (admin sẽ sửa text sau) ──
                Log::info('No manual lyrics — running full Groq transcription', [
                    'song_id' => $this->songId,
                ]);
                $formattedLyrics = $this->transcribeOnly($tempPath);
            }

            if (empty($formattedLyrics)) {
                Log::warning('GenerateLyricsJob: empty result', ['song_id' => $this->songId]);
            }

            $song->update([
                'lyrics'              => json_encode($formattedLyrics, JSON_UNESCAPED_UNICODE),
                'lyrics_status'       => 'completed',
                'lyrics_processed_at' => now(),
                'lyrics_error'        => null,
            ]);

            Log::info('GenerateLyricsJob completed', [
                'song_id'  => $this->songId,
                'segments' => count($formattedLyrics),
                'mode'     => $hasManualLyrics ? 'align' : 'transcribe',
            ]);

        } catch (\Exception $e) {
            Log::error('GenerateLyricsJob failed: ' . $e->getMessage(), [
                'song_id' => $this->songId,
                'trace'   => $e->getTraceAsString(),
            ]);

            Song::where('id', $this->songId)->update([
                'lyrics_status' => 'failed',
                'lyrics_error'  => substr($e->getMessage(), 0, 500),
            ]);

            throw $e;

        } finally {
            if ($tempPath) $this->cleanupTempFile($tempPath);
        }
    }

    // ─────────────────────────────────────────────────────────────
    // MODE 1: Align — Groq transcribe lấy timestamps,
    //         ghép với text admin đã nhập theo thứ tự dòng
    // ─────────────────────────────────────────────────────────────
    private function alignLyricsWithTimestamps(string $filePath, array $manualLines): array
    {
        $groqResult = $this->callGroqApi($filePath);
        $segments   = $groqResult['segments'] ?? [];

        if (empty($segments)) {
            Log::warning('Groq returned no segments for alignment — keeping manual text with zero timestamps', [
                'song_id' => $this->songId,
            ]);
            return array_values(array_filter($manualLines, fn($l) => !empty(trim($l['text'] ?? ''))));
        }


        $cleanLines = array_values(
            array_filter($manualLines, fn($l) => !empty(trim($l['text'] ?? '')))
        );

        $totalLines = count($cleanLines);
        $totalSegs  = count($segments);

        $result = [];

        for ($i = 0; $i < $totalLines; $i++) {
            $segIdx = (int) round($i * ($totalSegs - 1) / max($totalLines - 1, 1));
            $segIdx = min($segIdx, $totalSegs - 1);

            $seg = $segments[$segIdx];

            $existingStart = (float) ($cleanLines[$i]['start'] ?? 0);
            $existingEnd   = (float) ($cleanLines[$i]['end']   ?? 0);

            $result[] = [
                'start' => $existingStart > 0 ? $existingStart : (float) ($seg['start'] ?? 0),
                'end'   => $existingEnd   > 0 ? $existingEnd   : (float) ($seg['end']   ?? 0),
                'text'  => trim($cleanLines[$i]['text']),
            ];
        }

        Log::info('Lyrics aligned', [
            'song_id'     => $this->songId,
            'lines_in'    => $totalLines,
            'segments_in' => $totalSegs,
        ]);

        return $result;
    }

    // ─────────────────────────────────────────────────────────────
    // MODE 2: Transcribe only — không có lyrics sẵn
    // ─────────────────────────────────────────────────────────────
    private function transcribeOnly(string $filePath): array
    {
        $groqResult = $this->callGroqApi($filePath);
        $segments   = $groqResult['segments'] ?? [];
        $text       = $groqResult['text']     ?? '';

        $result = [];

        foreach ($segments as $segment) {
            if (!is_array($segment)) continue;
            $segText = trim($segment['text'] ?? '');
            if ($segText === '') continue;

            $result[] = [
                'start' => (float) ($segment['start'] ?? 0),
                'end'   => (float) ($segment['end']   ?? 0),
                'text'  => $segText,
            ];
        }

        if (empty($result) && !empty(trim($text))) {
            $result[] = ['start' => 0, 'end' => 0, 'text' => trim($text)];
        }

        return $result;
    }

    // ─────────────────────────────────────────────────────────────
    // Gọi Groq Whisper API
    // ─────────────────────────────────────────────────────────────
    private function callGroqApi(string $filePath): array
    {
        $apiKey = config('services.groq.api_key');
        if (empty($apiKey)) {
            throw new \Exception('GROQ_API_KEY is not configured');
        }

        $filename = pathinfo($filePath, PATHINFO_EXTENSION) === 'mp3'
            ? basename($filePath)
            : 'audio.mp3';

        Log::info('Calling Groq Whisper', ['filename' => $filename, 'size' => filesize($filePath)]);

        $response = Http::withToken($apiKey)
            ->timeout(180)
            ->retry(3, 2000)
            ->attach('file', fopen($filePath, 'r'), $filename, ['Content-Type' => 'audio/mpeg'])
            ->post('https://api.groq.com/openai/v1/audio/transcriptions', [
                'model'           => 'whisper-large-v3',
                'language'        => 'vi',
                'response_format' => 'verbose_json',
                'temperature'     => '0',
                'prompt'          => 'Bài hát tiếng Việt. Giữ nguyên dấu tiếng Việt đầy đủ.',
            ]);

        if (!$response->successful()) {
            throw new \Exception("Groq API error {$response->status()}: " . $response->body());
        }

        $data = $response->json();

        Log::info('Groq response received', [
            'text_preview'   => mb_substr($data['text'] ?? '', 0, 200),
            'segments_count' => count($data['segments'] ?? []),
        ]);

        return $data;
    }

    // ─────────────────────────────────────────────────────────────
    // Helpers
    // ─────────────────────────────────────────────────────────────

    /**
     * Parse lyrics từ DB — có thể là JSON string hoặc đã là array
     */
    private function parseExistingLyrics(mixed $raw): array
    {
        if (empty($raw)) return [];

        if (is_array($raw)) return $raw;

        if (is_string($raw)) {
            $decoded = json_decode($raw, true);
            if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
                return $decoded;
            }
        }

        return [];
    }

    private function buildAudioUrl(string $publicId): string
    {
        $cloudName = config('cloudinary.cloud_name');

        if (!str_contains($publicId, 'songs/audio/')) {
            $publicId = "songs/audio/{$publicId}";
        }

        return "https://res.cloudinary.com/{$cloudName}/video/upload/{$publicId}.mp3";
    }

    private function downloadAudio(string $url): string
    {
        $tempDir = storage_path('app/temp');
        if (!file_exists($tempDir)) {
            mkdir($tempDir, 0755, true);
        }

        $tempPath = $tempDir . DIRECTORY_SEPARATOR . uniqid('audio_', true) . '.mp3';

        Log::info('Downloading audio', ['url' => $url]);

        $response = Http::timeout(120)->retry(3, 1000)->get($url);

        if (!$response->successful()) {
            throw new \Exception("Failed to download audio: HTTP {$response->status()}");
        }

        file_put_contents($tempPath, $response->body());

        if (!file_exists($tempPath) || filesize($tempPath) === 0) {
            throw new \Exception("Downloaded file is empty or invalid");
        }

        Log::info('Audio downloaded', ['size' => filesize($tempPath)]);

        return $tempPath;
    }

    private function cleanupTempFile(string $path): void
    {
        if (file_exists($path)) {
            @unlink($path);
            Log::info('Temp file deleted', ['path' => $path]);
        }
    }
}
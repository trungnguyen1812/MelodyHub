<?php

namespace App\Jobs;

use App\Models\Song;
use App\Services\LyricsService;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Support\Facades\Log;

class ProcessLyrics implements ShouldQueue
{
    use Queueable;

    protected int $songId;
    protected string $lyricsJson;

    /**
     * Create a new job instance.
     */
    public function __construct(int $songId, string $lyricsJson)
    {
        $this->songId = $songId;
        $this->lyricsJson = $lyricsJson;
    }

    /**
     * Execute the job.
     */
    public function handle(LyricsService $lyricsService): void
    {
        Log::info('ProcessLyrics job started', [
            'song_id' => $this->songId,
            'attempt' => $this->attempts()
        ]);

        $song = Song::find($this->songId);

        if (!$song) {
            Log::error('Song not found for lyrics processing', [
                'song_id' => $this->songId
            ]);
            return;
        }

        // Kiểm tra audio URL đã có chưa
        if (empty($song->song_url)) {
            Log::warning('No audio URL yet, retrying lyrics alignment', [
                'song_id' => $song->id,
                'attempt' => $this->attempts()
            ]);

            // Retry sau 30 giây nếu chưa có audio (tối đa 5 lần)
            if ($this->attempts() < 5) {
                $this->release(30);
            } else {
                $song->update(['lyrics_status' => 'failed']);
                Log::error('Lyrics alignment failed: no audio URL after 5 attempts', [
                    'song_id' => $song->id
                ]);
            }
            return;
        }

        // Lấy raw text từ lyrics JSON
        $lyricsArray = json_decode($this->lyricsJson, true);

        if (!is_array($lyricsArray) || empty($lyricsArray)) {
            Log::warning('Invalid lyrics JSON', [
                'song_id' => $song->id,
                'lyrics_json' => $this->lyricsJson
            ]);
            $song->update(['lyrics_status' => 'failed']);
            return;
        }

        $rawText = collect($lyricsArray)
            ->pluck('text')
            ->filter()
            ->implode("\n");

        if (empty($rawText)) {
            Log::warning('No lyrics text to process', [
                'song_id' => $song->id,
                'line_count' => count($lyricsArray)
            ]);
            $song->update(['lyrics_status' => 'failed']);
            return;
        }

        Log::info('Processing lyrics alignment', [
            'song_id' => $song->id,
            'audio_url' => $song->song_url,
            'line_count' => count($lyricsArray),
            'raw_text_length' => strlen($rawText)
        ]);

        // Gọi service align lyrics
        $success = $lyricsService->alignLyrics($song, $rawText);

        if (!$success) {
            $song->update(['lyrics_status' => 'failed']);
            Log::error('Lyrics alignment failed', [
                'song_id' => $song->id,
                'attempt' => $this->attempts()
            ]);

            // Retry nếu chưa quá 3 lần
            if ($this->attempts() < 3) {
                $this->release(60);
            }
            return;
        }

        Log::info('Lyrics alignment completed successfully', [
            'song_id' => $song->id,
            'lyrics_status' => $song->fresh()->lyrics_status
        ]);
    }

    /**
     * Handle a job failure.
     */
    public function failed(\Throwable $e): void
    {
        Log::error('ProcessLyrics job failed permanently', [
            'song_id' => $this->songId,
            'error' => $e->getMessage(),
            'trace' => $e->getTraceAsString()
        ]);

        $song = Song::find($this->songId);
        if ($song) {
            $song->update(['lyrics_status' => 'failed']);
        }
    }
}
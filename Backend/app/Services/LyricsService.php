<?php

namespace App\Services;

use App\Models\Song;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class LyricsService
{
    private string $serviceUrl;

    public function __construct()
    {
        $this->serviceUrl = config('services.lyric_align.url', 'http://localhost:8001');
    }

    /**
     * Align lyrics với audio thông qua Python service
     * User nhập lyrics thô, service trả về LRC với timestamp
     */
    public function alignLyrics(Song $song, string $rawLyrics): bool
    {
        try {
            // Download audio từ Cloudinary về tạm
            $audioUrl = $song->song_url;

            if (empty($audioUrl)) {
                Log::error('No audio URL on song', ['song_id' => $song->id]);
                return false;
            }

            $audioContent = file_get_contents($audioUrl);
            
            if (!$audioContent) {
                Log::error('Cannot download audio', [
                    'song_id'   => $song->id,
                    'audio_url' => $audioUrl,
                ]);
                return false;
            }

            $tmpAudio = tempnam(sys_get_temp_dir(), 'audio_') . '.mp3';
            file_put_contents($tmpAudio, $audioContent);

            $response = Http::timeout(120)
                ->attach('audio', file_get_contents($tmpAudio), basename($tmpAudio))
                ->post($this->serviceUrl . '/align', [
                    'lyrics' => $rawLyrics,
                ]);

            @unlink($tmpAudio);

            if ($response->failed()) {
                Log::error('Lyric align service failed', [
                    'song_id' => $song->id,
                    'error' => $response->body()
                ]);
                return false;
            }

            $lrc = $response->json('lrc');

            if (!$lrc) {
                Log::error('Empty LRC response', ['song_id' => $song->id]);
                return false;
            }

            // Parse LRC sang array rồi lưu DB
            $parsed = $this->parseLrc($lrc);

            $song->update([
                'lyrics' => json_encode($parsed),
                'lyrics_status' => 'completed',
            ]);

            Log::info('Lyrics aligned successfully', ['song_id' => $song->id]);
            return true;

        } catch (\Exception $e) {
            Log::error('Align lyrics failed', [
                'song_id' => $song->id,
                'error' => $e->getMessage()
            ]);
            return false;
        }
    }

    /**
     * Parse LRC string sang array
     * [00:01.23] Dòng lyrics → [{time: 1.23, text: "Dòng lyrics"}, ...]
     */
    public function parseLrc(string $lrc): array
    {
        $lines = explode("\n", trim($lrc));
        $result = [];

        foreach ($lines as $line) {
            $line = trim($line);
            if (empty($line)) continue;

            if (preg_match('/\[(\d{2}):(\d{2})\.(\d{2,3})\](.*)/', $line, $matches)) {
                $minutes = (int) $matches[1];
                $seconds = (int) $matches[2];
                $cs      = (int) str_pad($matches[3], 3, '0'); // normalize to ms
                $time    = round(($minutes * 60) + $seconds + ($cs / 1000), 2);

                $result[] = [
                    'start' => $time,
                    'end'   => 0,      // fill bên dưới
                    'text'  => trim($matches[4]),
                ];
            }
        }

        // Gán end = start của dòng kế tiếp
        for ($i = 0; $i < count($result) - 1; $i++) {
            $result[$i]['end'] = $result[$i + 1]['start'];
        }
        // Dòng cuối: end = start + 3s
        if (!empty($result)) {
            $last = &$result[count($result) - 1];
            $last['end'] = round($last['start'] + 3, 2);
        }

        return $result;
    }

    /**
     * Kiểm tra trạng thái lyrics của bài hát
     */
    public function getLyricsStatus(Song $song): array
    {
        $hasLyrics = !empty($song->lyrics) && $song->lyrics !== '[]';

        if ($hasLyrics) {
            return [
                'status' => 'completed',
                'has_lyrics' => true,
                'lyrics' => json_decode($song->lyrics, true)
            ];
        }

        if ($song->lyrics_status === 'processing') {
            return [
                'status' => 'processing',
                'has_lyrics' => false,
                'message' => 'Lyrics đang được xử lý'
            ];
        }

        return [
            'status' => 'not_started',
            'has_lyrics' => false,
            'message' => 'Chưa có lyrics'
        ];
    }

    /**
     * Extract public_id từ Cloudinary URL (giữ lại phòng cần dùng)
     */
    public function extractPublicIdFromUrl(string $url): ?string
    {
        try {
            $url = urldecode($url);

            if (!preg_match('/\/upload\/(?:v\d+\/)?(.+?)\.(mp3|m4a|wav|ogg)/i', $url, $matches)) {
                return null;
            }

            return str_replace('songs/audio/', '', $matches[1]);

        } catch (\Exception $e) {
            Log::error('Failed to extract public_id', [
                'url' => $url,
                'error' => $e->getMessage()
            ]);
            return null;
        }
    }
}
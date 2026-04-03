<?php

namespace App\Services;

use App\Models\Song;
use App\Jobs\GenerateLyricsJob;
use Illuminate\Support\Facades\Log;

class LyricsService
{
    /**
     * Dispatch job tạo lyrics cho bài hát
     */
    public function generateLyrics(Song $song): bool
    {
        try {
            // Kiểm tra nếu đã có lyrics rồi thì không tạo lại
            if ($song->lyrics && $song->lyrics !== '[]') {
                Log::info('Lyrics already exists', ['song_id' => $song->id]);
                return false;
            }

            // Lấy audio public_id từ URL
            $audioPublicId = $this->extractPublicIdFromUrl($song->audio_url);
            
            if (!$audioPublicId) {
                Log::error('Cannot extract audio public_id', ['song_id' => $song->id]);
                return false;
            }

            // Dispatch job
            GenerateLyricsJob::dispatch($song->id, $audioPublicId);
            
            Log::info('Lyrics generation job dispatched', [
                'song_id' => $song->id,
                'audio_public_id' => $audioPublicId
            ]);
            
            return true;
            
        } catch (\Exception $e) {
            Log::error('Failed to dispatch lyrics job', [
                'song_id' => $song->id,
                'error' => $e->getMessage()
            ]);
            return false;
        }
    }

    /**
     * Tạo lyrics ngay lập tức (sync, không dùng queue)
     * Dùng cho trường hợp cần kết quả ngay
     */
    public function generateLyricsSync(Song $song): ?array
    {
        try {
            $audioPublicId = $this->extractPublicIdFromUrl($song->audio_url);
            
            if (!$audioPublicId) {
                return null;
            }

            $job = new GenerateLyricsJob($song->id, $audioPublicId);
            $job->handle();
            
            $song->refresh();
            return json_decode($song->lyrics, true);
            
        } catch (\Exception $e) {
            Log::error('Sync lyrics generation failed', [
                'song_id' => $song->id,
                'error' => $e->getMessage()
            ]);
            return null;
        }
    }

    /**
     * Extract public_id từ Cloudinary URL
     */
    private function extractPublicIdFromUrl(string $url): ?string
    {
        try {
            $url = urldecode($url);
            
            if (!preg_match('/\/upload\/(?:v\d+\/)?(.+?)\.(mp3|m4a|wav|ogg)/i', $url, $matches)) {
                return null;
            }
            
            $publicId = $matches[1];
            
            $publicId = str_replace('songs/audio/', '', $publicId);
            
            Log::info('Extracted public_id', ['public_id' => $publicId, 'url' => $url]);
            
            return $publicId;
            
        } catch (\Exception $e) {
            Log::error('Failed to extract public_id', ['url' => $url, 'error' => $e->getMessage()]);
            return null;
        }
    }

    /**
     * Kiểm tra trạng thái lyrics của bài hát
     */
    public function getLyricsStatus(Song $song): array
    {
        $hasLyrics = $song->lyrics && $song->lyrics !== '[]' && $song->lyrics !== null;
        
        if ($hasLyrics) {
            return [
                'status' => 'completed',
                'has_lyrics' => true,
                'lyrics' => json_decode($song->lyrics, true)
            ];
        }
        
        if (property_exists($song, 'lyrics_status') && $song->lyrics_status === 'processing') {
            return [
                'status' => 'processing',
                'has_lyrics' => false,
                'message' => 'Lyrics are being generated'
            ];
        }
        
        return [
            'status' => 'not_started',
            'has_lyrics' => false,
            'message' => 'Lyrics not yet generated'
        ];
    }
}
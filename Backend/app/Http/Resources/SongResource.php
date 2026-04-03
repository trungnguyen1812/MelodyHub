<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SongResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        // ── Kiểm tra user có phải VIP không ──
        // Lấy từ token payload đã được middleware decode
        $adminUser  = $request->get('admin_user');
        $roleFlags  = $adminUser['role_flags'] ?? [];
        $isVip      = ($roleFlags['is_user_vip_yearly'] ?? false)
                   || ($roleFlags['is_user_vip_monthly'] ?? false)
                   || ($roleFlags['is_boss'] ?? false)
                   || ($roleFlags['is_admin'] ?? false);

        return [
            'id'             => $this->id,
            'title'          => $this->title,
            'slug'           => $this->slug,
            'duration'       => $this->duration,
            'duration_format'=> $this->formatDuration($this->duration),
            'year'           => $this->year ? (int) $this->year : null,
            'track_number'   => $this->track_number,
            'disc_number'    => $this->disc_number,
            'isrc'           => $this->isrc,
            'bitrate'        => $this->bitrate,
            'quality'        => $this->quality,
            'file_size'      => $this->file_size,
            // ─── Lyrics fields (fix) ───
            'lyrics'         => $this->getLyricsFormatted(),
            'lyrics_status'  => $this->lyrics_status,
            'lyrics_error'   => $this->lyrics_error,
            'lyrics_processed_at' => $this->lyrics_processed_at?->toISOString(),
            'has_lyrics'     => $this->hasLyrics(),

            'cover_url'      => $this->cover_url,
            'is_premium'     => (bool) $this->is_premium,
            'is_explicit'    => (bool) $this->is_explicit,
            'is_featured'    => (bool) $this->is_featured,
            'allow_download' => (bool) $this->allow_download,
            'status'         => $this->status,
            'copyright_owner' => $this->copyright_owner,
            'license_type'   => $this->license_type,

            // ── Audio URLs theo quyền ──
            'urls' => [
                'low'      => $this->song_url_hq,      // 128kbps — tất cả
                'standard' => $this->song_url,         // 320kbps — tất cả
                'lossless' => $isVip                   // FLAC — chỉ VIP
                    ? $this->song_url_lossless
                    : null,
            ],

            // ── Artist ──
            'artist' => $this->whenLoaded('artist', fn() => [
                'id'         => $this->artist->id,
                'name'       => $this->artist->name,
                'slug'       => $this->artist->slug,
                'avatar_url' => $this->artist->avatar_url ?? null,
            ]),

            // ── Album ──
            'album' => $this->whenLoaded('album', fn() => $this->album ? [
                'id'        => $this->album->id,
                'title'     => $this->album->title,
                'slug'      => $this->album->slug,
                'cover_url' => $this->album->cover_url ?? null,
            ] : null),

            // genres
            'genre' => $this->whenLoaded('genre', fn() => $this->genre ? [
                'id'          => $this->genre->id,
                'name'        => $this->genre->name,
                'slug'        => $this->genre->slug,
                'description' => $this->genre->description,
                'cover_url'   => $this->genre->cover_url ?? null,
                'color'       => $this->genre->color ?? null,
            ] : null),

            // ── Partner ──
            'partner' => $this->whenLoaded('partner', fn() => $this->partner ? [
                'id'           => $this->partner->id,
                'company_name' => $this->partner->company_name,
            ] : null),

            // ── Stats ──
            'stats' => [
                'total_plays'     => $this->total_plays,
                'total_likes'     => $this->total_likes,
                'total_comments'  => $this->total_comments,
                'total_shares'    => $this->total_shares,
                'total_downloads' => $this->total_downloads,
            ],

            'created_at' => $this->created_at?->toISOString(),
            'updated_at' => $this->updated_at?->toISOString(),
        ];
    }

    private function formatDuration(int $seconds): string
    {
        $m = intdiv($seconds, 60);
        $s = $seconds % 60;
        return sprintf('%d:%02d', $m, $s);
    }

    private function getLyricsFormatted()
    {
        // Nếu lyrics là JSON (từ Whisper)
        if ($this->isJson($this->lyrics)) {
            $lyricsArray = json_decode($this->lyrics, true);
            
            // Nếu là dạng có timestamp
            if (isset($lyricsArray[0]['start']) && isset($lyricsArray[0]['text'])) {
                return [
                    'type' => 'timed',
                    'segments' => $lyricsArray,
                    'plain_text' => $this->extractPlainText($lyricsArray),
                ];
            }
            
            return $lyricsArray;
        }
        
        // Nếu lyrics là text thường
        if ($this->lyrics && !empty($this->lyrics)) {
            return [
                'type' => 'plain',
                'text' => $this->lyrics,
            ];
        }
        
        // Chưa có lyrics
        return null;
    }

    /**
     * Extract plain text from timed lyrics segments
     */
    private function extractPlainText(array $segments): string
    {
        return implode("\n", array_column($segments, 'text'));
    }

    /**
     * Check if string is JSON
     */
    private function isJson($string): bool
    {
        if (!is_string($string) || empty($string)) {
            return false;
        }
        
        json_decode($string);
        return json_last_error() === JSON_ERROR_NONE;
    }

}
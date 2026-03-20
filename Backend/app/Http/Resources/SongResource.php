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
            'duration_format' => $this->formatDuration($this->duration),
            'year'           => $this->year ? (int) date('Y', strtotime($this->year)) : null,
            'track_number'   => $this->track_number,
            'disc_number'    => $this->disc_number,
            'isrc'           => $this->isrc,
            'bitrate'        => $this->bitrate,
            'quality'        => $this->quality,
            'file_size'      => $this->file_size,
            'lyrics'         => $this->lyrics,
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
}
<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class AlbumResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'            => $this->id,
            'name'          => $this->name,
            'slug'          => $this->slug,

            'artist' => $this->whenLoaded('artist', function () {
                return [
                    'id'         => $this->artist->id,
                    'name'       => $this->artist->name,
                    'slug'       => $this->artist->slug,
                    'avatar_url' => $this->artist->avatar_url,
                ];
            }),

            'cover_url'     => $this->cover_url,
            'description'   => $this->description,
            'release_date'  => $this->release_date?->format('Y-m-d'),
            'release_year'  => $this->release_date?->year,          

            'album_type'    => $this->album_type,
            'label'         => $this->label,

            'total_tracks'   => $this->total_tracks,
            'total_duration' => $this->total_duration,
            'total_plays'    => $this->total_plays ?? 0,
            'total_likes'    => $this->total_likes ?? 0,

            'is_featured'   => (bool) $this->is_featured,
            'is_premium'    => (bool) $this->is_premium,
            'is_liked'      => (bool) ($this->is_liked ?? false),  
            'status'        => $this->status,
            'published_at'  => $this->published_at?->format('Y-m-d H:i:s'),

            'tracks' => $this->whenLoaded('tracks', function () {
                return $this->tracks->map(function ($track) {
                    return [
                        'id'          => $track->id,
                        'title'       => $track->title,
                        'slug'        => $track->slug ?? null,
                        'track_number'=> $track->pivot?->position ?? null,   
                        'duration'    => (int) $track->duration,
                        'song_url'   => $track->song_url,        
                        'cover_url'   => $track->cover_url ?? $this->cover_url,

                        'is_explicit' => (bool) ($track->is_explicit ?? false),
                        'is_premium'  => (bool) ($track->is_premium ?? false),

                        'total_plays' => (int) ($track->total_plays ?? 0),
                        'like_count'  => (int) ($track->like_count ?? 0),
                        'is_liked'    => (bool) ($track->is_liked ?? false),

                        // Artist của track (hỗ trợ featuring)
                        'artist' => $track->artist ? [
                            'id'   => $track->artist->id,
                            'name' => $track->artist->name,
                        ] : null,
                    ];
                });
            }),

            'created_at' => $this->created_at?->format('Y-m-d H:i:s'),
            'updated_at' => $this->updated_at?->format('Y-m-d H:i:s'),
        ];
    }
}
<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ArtistResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id'                => $this->id,
            'name'              => $this->name,
            'slug'              => $this->slug,
            'bio'               => $this->bio,
            'avatar_url'        => $this->avatar_url,
            'banner_url'        => $this->banner_url,
            'country'           => $this->country,
            'website'           => $this->website,
            'facebook_url'      => $this->facebook_url,
            'instagram_url'     => $this->instagram_url,
            'twitter_url'       => $this->twitter_url,
            'youtube_url'       => $this->youtube_url,
            'verified'          => (bool) $this->verified,
            'is_featured'       => (bool) $this->is_featured,
            'total_followers'   => (int) $this->total_followers,
            'total_plays'       => (int) $this->total_plays,
            'total_songs'       => (int) $this->total_songs,
            'total_albums'      => (int) $this->total_albums,
            'monthly_listeners' => (int) $this->monthly_listeners,
            'status'            => $this->status,
            'seo_title'         => $this->seo_title,
            'seo_description'   => $this->seo_description,
            'seo_keywords'      => $this->seo_keywords,
            'created_at'        => $this->created_at?->toISOString(),
            'updated_at'        => $this->updated_at?->toISOString(),
            'is_followed'       => $this->whenLoaded('artist_followers', fn() => $this->artist_followers->isNotEmpty(), false),
            
            // Relations
            'songs'             => SongResource::collection($this->whenLoaded('songs')),
            'partner'           => $this->whenLoaded('partner'),
        ];
    }
}

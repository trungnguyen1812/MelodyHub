<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Song extends Model
{
    protected $table = 'songs';

    protected $fillable = [
        'title', 'artist_id', 'album_id', 'duration',
        'genre', 'song_url', 'cover_url'
    ];

    public $timestamps = true;

    public function artist()
    {
        return $this->belongsTo(Artist::class);
    }

    public function album()
    {
        return $this->belongsTo(Album::class);
    }

    public function playlists()
    {
        return $this->belongsToMany(Playlist::class, 'playlist_song');
    }

    public function songPlays()
    {
        return $this->hasMany(SongPlay::class);
    }

    public function comments()
    {
        return $this->hasMany(Comment::class);
    }

    public function songLikes()
    {
        return $this->hasMany(SongLike::class);
    }
}


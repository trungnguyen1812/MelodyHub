<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Relations\Pivot;

class PlaylistSong extends Pivot
{
    protected $table = 'playlist_song';

    protected $fillable = ['playlist_id', 'song_id', 'added_at'];

    public $timestamps = false;
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SongPlay extends Model
{
    protected $table = 'song_plays';

    protected $fillable = ['user_id', 'song_id', 'played_at', 'device_info'];

    public $timestamps = false;

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function song()
    {
        return $this->belongsTo(Song::class);
    }
}

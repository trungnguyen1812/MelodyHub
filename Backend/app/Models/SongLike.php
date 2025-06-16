<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SongLike extends Model
{
    protected $table = 'song_likes';

    protected $fillable = ['user_id', 'song_id'];

    public $timestamps = true;

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function song()
    {
        return $this->belongsTo(Song::class);
    }
}


<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

class SongFingerprint extends Model
{
    protected $table = 'song_fingerprints';
    
    public $timestamps = false;
    
    protected $fillable = [
        'song_id',
        'fingerprint_hash',
        'fpcalc_raw_output',
        'duration',
        'fpcalc_version',
        'generated_at'
    ];
    
    protected $casts = [
        'song_id' => 'int',
        'duration' => 'int',
        'generated_at' => 'datetime'
    ];
    
    public function song()
    {
        return $this->belongsTo(Song::class);
    }
}
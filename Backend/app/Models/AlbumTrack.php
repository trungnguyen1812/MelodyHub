<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class AlbumTrack
 * 
 * @property int $id
 * @property int $album_id
 * @property int $track_id
 * @property int $position
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property Album $album
 * @property Song $song
 *
 * @package App\Models
 */
class AlbumTrack extends Model
{
	protected $table = 'album_tracks';

	protected $casts = [
		'album_id' => 'int',
		'track_id' => 'int',
		'position' => 'int',
	];

	protected $fillable = [
		'album_id',
		'track_id',
		'position',
	];

	/**
	 * Get the album that owns this track
	 */
	public function album()
	{
		return $this->belongsTo(Album::class);
	}

	/**
	 * Get the song (track) for this album track
	 */
	public function song()
	{
		return $this->belongsTo(Song::class, 'track_id');
	}
}

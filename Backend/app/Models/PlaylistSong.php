<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class PlaylistSong
 * 
 * @property int $id
 * @property int $playlist_id
 * @property int $song_id
 * @property int $added_by
 * @property int $position
 * @property Carbon $added_at
 * 
 * @property Playlist $playlist
 * @property Song $song
 * @property User $user
 *
 * @package App\Models
 */
class PlaylistSong extends Model
{
	protected $table = 'playlist_songs';
	public $timestamps = false;

	protected $casts = [
		'playlist_id' => 'int',
		'song_id' => 'int',
		'added_by' => 'int',
		'position' => 'int',
		'added_at' => 'datetime'
	];

	protected $fillable = [
		'playlist_id',
		'song_id',
		'added_by',
		'position',
		'added_at'
	];

	public function playlist()
	{
		return $this->belongsTo(Playlist::class);
	}

	public function song()
	{
		return $this->belongsTo(Song::class);
	}

	public function user()
	{
		return $this->belongsTo(User::class, 'added_by');
	}
}

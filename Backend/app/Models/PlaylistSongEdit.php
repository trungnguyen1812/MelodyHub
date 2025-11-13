<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class PlaylistSongEdit
 * 
 * @property int $id
 * @property int $playlist_id
 * @property int $song_id
 * @property int $user_id
 * @property string $action
 * @property Carbon|null $created_at
 * 
 * @property Playlist $playlist
 * @property Song $song
 * @property User $user
 *
 * @package App\Models
 */
class PlaylistSongEdit extends Model
{
	protected $table = 'playlist_song_edits';
	public $timestamps = false;

	protected $casts = [
		'playlist_id' => 'int',
		'song_id' => 'int',
		'user_id' => 'int'
	];

	protected $fillable = [
		'playlist_id',
		'song_id',
		'user_id',
		'action'
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
		return $this->belongsTo(User::class);
	}
}

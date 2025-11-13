<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class PlaylistFollower
 * 
 * @property int $id
 * @property int $playlist_id
 * @property int $user_id
 * @property Carbon $followed_at
 * 
 * @property Playlist $playlist
 * @property User $user
 *
 * @package App\Models
 */
class PlaylistFollower extends Model
{
	protected $table = 'playlist_followers';
	public $timestamps = false;

	protected $casts = [
		'playlist_id' => 'int',
		'user_id' => 'int',
		'followed_at' => 'datetime'
	];

	protected $fillable = [
		'playlist_id',
		'user_id',
		'followed_at'
	];

	public function playlist()
	{
		return $this->belongsTo(Playlist::class);
	}

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

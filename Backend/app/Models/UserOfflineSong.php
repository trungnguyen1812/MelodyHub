<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class UserOfflineSong
 * 
 * @property int $id
 * @property int $user_id
 * @property int $song_id
 * @property Carbon|null $expires_at
 * 
 * @property User $user
 * @property Song $song
 *
 * @package App\Models
 */
class UserOfflineSong extends Model
{
	protected $table = 'user_offline_songs';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'song_id' => 'int',
		'expires_at' => 'datetime'
	];

	protected $fillable = [
		'user_id',
		'song_id',
		'expires_at'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}

	public function song()
	{
		return $this->belongsTo(Song::class);
	}
}

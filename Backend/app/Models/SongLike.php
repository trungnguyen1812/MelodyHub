<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class SongLike
 * 
 * @property int $id
 * @property int $user_id
 * @property int $song_id
 * @property Carbon $created_at
 * 
 * @property Song $song
 * @property User $user
 *
 * @package App\Models
 */
class SongLike extends Model
{
	protected $table = 'song_likes';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'song_id' => 'int'
	];

	protected $fillable = [
		'user_id',
		'song_id'
	];

	public function song()
	{
		return $this->belongsTo(Song::class);
	}

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

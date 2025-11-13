<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class UserQueue
 * 
 * @property int $id
 * @property int $user_id
 * @property int $song_id
 * @property int $position
 * @property Carbon|null $added_at
 * 
 * @property User $user
 * @property Song $song
 *
 * @package App\Models
 */
class UserQueue extends Model
{
	protected $table = 'user_queue';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'song_id' => 'int',
		'position' => 'int',
		'added_at' => 'datetime'
	];

	protected $fillable = [
		'user_id',
		'song_id',
		'position',
		'added_at'
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

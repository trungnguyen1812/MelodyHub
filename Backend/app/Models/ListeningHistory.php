<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class ListeningHistory
 * 
 * @property int $id
 * @property int $user_id
 * @property int $song_id
 * @property Carbon $played_at
 * @property int $play_count
 * @property int|null $last_position
 * 
 * @property Song $song
 * @property User $user
 *
 * @package App\Models
 */
class ListeningHistory extends Model
{
	protected $table = 'listening_history';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'song_id' => 'int',
		'played_at' => 'datetime',
		'play_count' => 'int',
		'last_position' => 'int'
	];

	protected $fillable = [
		'user_id',
		'song_id',
		'played_at',
		'play_count',
		'last_position'
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

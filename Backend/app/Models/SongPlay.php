<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class SongPlay
 * 
 * @property int $id
 * @property int|null $user_id
 * @property int $song_id
 * @property int|null $playlist_id
 * @property int|null $played_duration
 * @property float|null $play_percentage
 * @property bool $is_completed
 * @property Carbon $played_at
 * @property string|null $device_type
 * @property string|null $device_info
 * @property string|null $ip_address
 * @property string|null $country
 * @property string|null $city
 * 
 * @property Song $song
 * @property User|null $user
 *
 * @package App\Models
 */
class SongPlay extends Model
{
	protected $table = 'song_plays';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'song_id' => 'int',
		'playlist_id' => 'int',
		'played_duration' => 'int',
		'play_percentage' => 'float',
		'is_completed' => 'bool',
		'played_at' => 'datetime'
	];

	protected $fillable = [
		'user_id',
		'song_id',
		'playlist_id',
		'played_duration',
		'play_percentage',
		'is_completed',
		'played_at',
		'device_type',
		'device_info',
		'ip_address',
		'country',
		'city'
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

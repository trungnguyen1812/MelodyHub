<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class SongDownload
 * 
 * @property int $id
 * @property int $user_id
 * @property int $song_id
 * @property string $quality
 * @property int|null $file_size
 * @property Carbon $downloaded_at
 * @property string|null $ip_address
 * @property string|null $device_info
 * 
 * @property Song $song
 * @property User $user
 *
 * @package App\Models
 */
class SongDownload extends Model
{
	protected $table = 'song_downloads';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'song_id' => 'int',
		'file_size' => 'int',
		'downloaded_at' => 'datetime'
	];

	protected $fillable = [
		'user_id',
		'song_id',
		'quality',
		'file_size',
		'downloaded_at',
		'ip_address',
		'device_info'
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

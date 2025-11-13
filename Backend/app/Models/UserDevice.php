<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class UserDevice
 * 
 * @property int $id
 * @property int $user_id
 * @property string|null $device_name
 * @property string $device_type
 * @property string $device_id
 * @property string|null $platform
 * @property string|null $browser
 * @property string|null $os
 * @property string|null $app_version
 * @property string|null $push_token
 * @property bool $is_active
 * @property Carbon|null $last_used_at
 * @property Carbon $registered_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class UserDevice extends Model
{
	protected $table = 'user_devices';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'is_active' => 'bool',
		'last_used_at' => 'datetime',
		'registered_at' => 'datetime'
	];

	protected $hidden = [
		'push_token'
	];

	protected $fillable = [
		'user_id',
		'device_name',
		'device_type',
		'device_id',
		'platform',
		'browser',
		'os',
		'app_version',
		'push_token',
		'is_active',
		'last_used_at',
		'registered_at'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

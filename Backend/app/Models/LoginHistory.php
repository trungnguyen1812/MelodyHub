<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class LoginHistory
 * 
 * @property int $id
 * @property int $user_id
 * @property string $ip_address
 * @property string|null $user_agent
 * @property string|null $device_type
 * @property string|null $browser
 * @property string|null $os
 * @property string|null $country
 * @property string|null $city
 * @property string $status
 * @property string|null $fail_reason
 * @property Carbon $logged_in_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class LoginHistory extends Model
{
	protected $table = 'login_history';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'logged_in_at' => 'datetime'
	];

	protected $fillable = [
		'user_id',
		'ip_address',
		'user_agent',
		'device_type',
		'browser',
		'os',
		'country',
		'city',
		'status',
		'fail_reason',
		'logged_in_at'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

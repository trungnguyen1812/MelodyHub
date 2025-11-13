<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class AdImpression
 * 
 * @property int $id
 * @property int $ad_id
 * @property int|null $user_id
 * @property string|null $session_id
 * @property string $impression_type
 * @property int|null $played_duration
 * @property string|null $ip_address
 * @property string|null $user_agent
 * @property string|null $device_type
 * @property string|null $country
 * @property Carbon $created_at
 * 
 * @property Advertisement $advertisement
 * @property User|null $user
 *
 * @package App\Models
 */
class AdImpression extends Model
{
	protected $table = 'ad_impressions';
	public $timestamps = false;

	protected $casts = [
		'ad_id' => 'int',
		'user_id' => 'int',
		'played_duration' => 'int'
	];

	protected $fillable = [
		'ad_id',
		'user_id',
		'session_id',
		'impression_type',
		'played_duration',
		'ip_address',
		'user_agent',
		'device_type',
		'country'
	];

	public function advertisement()
	{
		return $this->belongsTo(Advertisement::class, 'ad_id');
	}

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

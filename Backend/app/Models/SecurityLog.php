<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class SecurityLog
 * 
 * @property int $id
 * @property int|null $user_id
 * @property string $event_type
 * @property string $severity
 * @property string|null $ip_address
 * @property string|null $user_agent
 * @property string|null $description
 * @property string|null $metadata
 * @property Carbon $created_at
 * 
 * @property User|null $user
 *
 * @package App\Models
 */
class SecurityLog extends Model
{
	protected $table = 'security_logs';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int'
	];

	protected $fillable = [
		'user_id',
		'event_type',
		'severity',
		'ip_address',
		'user_agent',
		'description',
		'metadata'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

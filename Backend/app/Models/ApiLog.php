<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class ApiLog
 * 
 * @property int $id
 * @property int|null $user_id
 * @property string $endpoint
 * @property string $method
 * @property string|null $request_headers
 * @property string|null $request_body
 * @property int|null $response_status
 * @property string|null $response_body
 * @property string|null $ip_address
 * @property string|null $user_agent
 * @property float|null $execution_time
 * @property Carbon $created_at
 * 
 * @property User|null $user
 *
 * @package App\Models
 */
class ApiLog extends Model
{
	protected $table = 'api_logs';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'response_status' => 'int',
		'execution_time' => 'float'
	];

	protected $fillable = [
		'user_id',
		'endpoint',
		'method',
		'request_headers',
		'request_body',
		'response_status',
		'response_body',
		'ip_address',
		'user_agent',
		'execution_time'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

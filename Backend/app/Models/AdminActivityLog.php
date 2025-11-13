<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class AdminActivityLog
 * 
 * @property int $id
 * @property int $admin_id
 * @property string $action
 * @property string|null $module
 * @property string|null $target_type
 * @property int|null $target_id
 * @property string|null $old_values
 * @property string|null $new_values
 * @property string|null $ip_address
 * @property string|null $user_agent
 * @property string|null $description
 * @property Carbon $created_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class AdminActivityLog extends Model
{
	protected $table = 'admin_activity_logs';
	public $timestamps = false;

	protected $casts = [
		'admin_id' => 'int',
		'target_id' => 'int'
	];

	protected $fillable = [
		'admin_id',
		'action',
		'module',
		'target_type',
		'target_id',
		'old_values',
		'new_values',
		'ip_address',
		'user_agent',
		'description'
	];

	public function user()
	{
		return $this->belongsTo(User::class, 'admin_id');
	}
}

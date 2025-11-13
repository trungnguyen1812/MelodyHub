<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class UserRole
 * 
 * @property int $id
 * @property int $user_id
 * @property int $role_id
 * @property int|null $assigned_by
 * @property Carbon $assigned_at
 * @property Carbon|null $expires_at
 * @property bool $is_primary
 * 
 * @property Role $role
 * @property User $user
 *
 * @package App\Models
 */
class UserRole extends Model
{
	protected $table = 'user_roles';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'role_id' => 'int',
		'assigned_by' => 'int',
		'assigned_at' => 'datetime',
		'expires_at' => 'datetime',
		'is_primary' => 'bool'
	];

	protected $fillable = [
		'user_id',
		'role_id',
		'assigned_by',
		'assigned_at',
		'expires_at',
		'is_primary'
	];

	public function role()
	{
		return $this->belongsTo(Role::class);
	}

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

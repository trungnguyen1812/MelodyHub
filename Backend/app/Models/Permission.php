<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Permission
 * 
 * @property int $id
 * @property int $module_id
 * @property string $name
 * @property string $display_name
 * @property string|null $description
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property Module $module
 * @property Collection|Role[] $roles
 *
 * @package App\Models
 */
class Permission extends Model
{
	protected $table = 'permissions';

	protected $casts = [
		'module_id' => 'int'
	];

	protected $fillable = [
		'module_id',
		'name',
		'display_name',
		'description'
	];

	public function module()
	{
		return $this->belongsTo(Module::class);
	}

	public function roles()
	{
		return $this->belongsToMany(Role::class, 'role_permissions')
					->withPivot('id');
	}
}

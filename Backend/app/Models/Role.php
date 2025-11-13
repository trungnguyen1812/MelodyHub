<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Role
 * 
 * @property int $id
 * @property string $name
 * @property string $display_name
 * @property string|null $description
 * @property int $level
 * @property bool $is_system
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property Collection|Menu[] $menus
 * @property Collection|Permission[] $permissions
 * @property Collection|User[] $users
 *
 * @package App\Models
 */
class Role extends Model
{
	protected $table = 'roles';

	protected $casts = [
		'level' => 'int',
		'is_system' => 'bool'
	];

	protected $fillable = [
		'name',
		'display_name',
		'description',
		'level',
		'is_system'
	];

	public function menus()
	{
		return $this->belongsToMany(Menu::class, 'menu_roles')
					->withPivot('id');
	}

	public function permissions()
	{
		return $this->belongsToMany(Permission::class, 'role_permissions')
					->withPivot('id');
	}

	public function users()
	{
		return $this->belongsToMany(User::class, 'user_roles')
					->withPivot('id', 'assigned_by', 'assigned_at', 'expires_at', 'is_primary');
	}
}

<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Module
 * 
 * @property int $id
 * @property string $name
 * @property string $display_name
 * @property string|null $description
 * @property string|null $icon
 * @property string|null $route_prefix
 * @property int|null $parent_id
 * @property int $order
 * @property bool $is_active
 * @property bool $is_system
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property Module|null $module
 * @property Collection|Menu[] $menus
 * @property Collection|Module[] $modules
 * @property Collection|Permission[] $permissions
 *
 * @package App\Models
 */
class Module extends Model
{
	protected $table = 'modules';

	protected $casts = [
		'parent_id' => 'int',
		'order' => 'int',
		'is_active' => 'bool',
		'is_system' => 'bool'
	];

	protected $fillable = [
		'name',
		'display_name',
		'description',
		'icon',
		'route_prefix',
		'parent_id',
		'order',
		'is_active',
		'is_system'
	];

	public function module()
	{
		return $this->belongsTo(Module::class, 'parent_id');
	}

	public function menus()
	{
		return $this->hasMany(Menu::class);
	}

	public function modules()
	{
		return $this->hasMany(Module::class, 'parent_id');
	}

	public function permissions()
	{
		return $this->hasMany(Permission::class);
	}
}

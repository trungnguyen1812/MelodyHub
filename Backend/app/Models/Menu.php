<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Menu
 * 
 * @property int $id
 * @property string $name
 * @property string $display_name
 * @property string|null $url
 * @property string|null $icon
 * @property int|null $parent_id
 * @property int|null $module_id
 * @property int $order
 * @property bool $is_active
 * @property bool $is_visible
 * @property string $target
 * @property string|null $css_class
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property Module|null $module
 * @property Menu|null $menu
 * @property Collection|Menu[] $menus
 * @property Collection|Role[] $roles
 *
 * @package App\Models
 */
class Menu extends Model
{
	protected $table = 'menu';

	protected $casts = [
		'parent_id' => 'int',
		'module_id' => 'int',
		'order' => 'int',
		'is_active' => 'bool',
		'is_visible' => 'bool'
	];

	protected $fillable = [
		'name',
		'display_name',
		'url',
		'icon',
		'parent_id',
		'module_id',
		'order',
		'is_active',
		'is_visible',
		'target',
		'css_class'
	];

	public function module()
	{
		return $this->belongsTo(Module::class);
	}

	public function menu()
	{
		return $this->belongsTo(Menu::class, 'parent_id');
	}

	public function menus()
	{
		return $this->hasMany(Menu::class, 'parent_id');
	}

	public function roles()
	{
		return $this->belongsToMany(Role::class, 'menu_roles')
					->withPivot('id');
	}
}

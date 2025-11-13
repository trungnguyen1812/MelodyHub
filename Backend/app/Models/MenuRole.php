<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class MenuRole
 * 
 * @property int $id
 * @property int $menu_id
 * @property int $role_id
 * @property Carbon|null $created_at
 * 
 * @property Menu $menu
 * @property Role $role
 *
 * @package App\Models
 */
class MenuRole extends Model
{
	protected $table = 'menu_roles';
	public $timestamps = false;

	protected $casts = [
		'menu_id' => 'int',
		'role_id' => 'int'
	];

	protected $fillable = [
		'menu_id',
		'role_id'
	];

	public function menu()
	{
		return $this->belongsTo(Menu::class);
	}

	public function role()
	{
		return $this->belongsTo(Role::class);
	}
}

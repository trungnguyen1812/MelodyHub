<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class SystemSetting
 * 
 * @property int $id
 * @property string $key
 * @property string|null $value
 * @property string $type
 * @property string|null $group
 * @property string|null $description
 * @property bool $is_public
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 *
 * @package App\Models
 */
class SystemSetting extends Model
{
	protected $table = 'system_settings';

	protected $casts = [
		'is_public' => 'bool'
	];

	protected $fillable = [
		'key',
		'value',
		'type',
		'group',
		'description',
		'is_public'
	];
}

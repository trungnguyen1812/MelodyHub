<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class TwoFactorAuth
 * 
 * @property int $id
 * @property int $user_id
 * @property string $method
 * @property string|null $secret
 * @property string|null $backup_codes
 * @property bool $is_enabled
 * @property Carbon|null $enabled_at
 * @property Carbon|null $last_used_at
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class TwoFactorAuth extends Model
{
	protected $table = 'two_factor_auth';

	protected $casts = [
		'user_id' => 'int',
		'is_enabled' => 'bool',
		'enabled_at' => 'datetime',
		'last_used_at' => 'datetime'
	];

	protected $hidden = [
		'secret'
	];

	protected $fillable = [
		'user_id',
		'method',
		'secret',
		'backup_codes',
		'is_enabled',
		'enabled_at',
		'last_used_at'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

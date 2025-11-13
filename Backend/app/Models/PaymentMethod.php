<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class PaymentMethod
 * 
 * @property int $id
 * @property int $user_id
 * @property string $type
 * @property string $provider
 * @property string|null $last_four
 * @property string|null $card_brand
 * @property int|null $expiry_month
 * @property int|null $expiry_year
 * @property string|null $holder_name
 * @property bool $is_default
 * @property string|null $token
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class PaymentMethod extends Model
{
	protected $table = 'payment_methods';

	protected $casts = [
		'user_id' => 'int',
		'expiry_month' => 'int',
		'expiry_year' => 'int',
		'is_default' => 'bool'
	];

	protected $hidden = [
		'token'
	];

	protected $fillable = [
		'user_id',
		'type',
		'provider',
		'last_four',
		'card_brand',
		'expiry_month',
		'expiry_year',
		'holder_name',
		'is_default',
		'token'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

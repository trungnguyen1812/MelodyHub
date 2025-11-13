<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class CouponCode
 * 
 * @property int $id
 * @property string $code
 * @property string $type
 * @property float $discount_value
 * @property string|null $currency
 * @property int|null $max_uses
 * @property int $used_count
 * @property int|null $max_uses_per_user
 * @property float|null $min_purchase_amount
 * @property string|null $applicable_plans
 * @property Carbon|null $valid_from
 * @property Carbon|null $valid_until
 * @property bool $is_active
 * @property string|null $description
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 *
 * @package App\Models
 */
class CouponCode extends Model
{
	protected $table = 'coupon_codes';

	protected $casts = [
		'discount_value' => 'float',
		'max_uses' => 'int',
		'used_count' => 'int',
		'max_uses_per_user' => 'int',
		'min_purchase_amount' => 'float',
		'valid_from' => 'datetime',
		'valid_until' => 'datetime',
		'is_active' => 'bool'
	];

	protected $fillable = [
		'code',
		'type',
		'discount_value',
		'currency',
		'max_uses',
		'used_count',
		'max_uses_per_user',
		'min_purchase_amount',
		'applicable_plans',
		'valid_from',
		'valid_until',
		'is_active',
		'description'
	];
}

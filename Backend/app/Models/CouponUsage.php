<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class CouponUsage
 * 
 * @property int $id
 * @property int $coupon_id
 * @property int $user_id
 * @property int|null $payment_id
 * @property float $discount_applied
 * @property Carbon $used_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class CouponUsage extends Model
{
	protected $table = 'coupon_usage';
	public $timestamps = false;

	protected $casts = [
		'coupon_id' => 'int',
		'user_id' => 'int',
		'payment_id' => 'int',
		'discount_applied' => 'float',
		'used_at' => 'datetime'
	];

	protected $fillable = [
		'coupon_id',
		'user_id',
		'payment_id',
		'discount_applied',
		'used_at'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

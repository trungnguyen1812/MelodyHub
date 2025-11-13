<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Payment
 * 
 * @property int $id
 * @property int $user_id
 * @property int|null $subscription_id
 * @property string $payment_type
 * @property string $payment_method
 * @property float $amount
 * @property string $currency
 * @property string $status
 * @property string|null $transaction_id
 * @property string|null $gateway_transaction_id
 * @property string|null $payment_gateway
 * @property string|null $payment_details
 * @property Carbon|null $paid_at
 * @property string|null $failed_reason
 * @property float|null $refunded_amount
 * @property Carbon|null $refunded_at
 * @property string|null $invoice_number
 * @property string|null $notes
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property UserSubscription|null $user_subscription
 * @property User $user
 *
 * @package App\Models
 */
class Payment extends Model
{
	protected $table = 'payments';

	protected $casts = [
		'user_id' => 'int',
		'subscription_id' => 'int',
		'amount' => 'float',
		'paid_at' => 'datetime',
		'refunded_amount' => 'float',
		'refunded_at' => 'datetime'
	];

	protected $fillable = [
		'user_id',
		'subscription_id',
		'payment_type',
		'payment_method',
		'amount',
		'currency',
		'status',
		'transaction_id',
		'gateway_transaction_id',
		'payment_gateway',
		'payment_details',
		'paid_at',
		'failed_reason',
		'refunded_amount',
		'refunded_at',
		'invoice_number',
		'notes'
	];

	public function user_subscription()
	{
		return $this->belongsTo(UserSubscription::class, 'subscription_id');
	}

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

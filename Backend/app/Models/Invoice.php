<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Invoice
 * 
 * @property int $id
 * @property string $invoice_number
 * @property int $user_id
 * @property int|null $payment_id
 * @property int|null $subscription_id
 * @property float $amount
 * @property float|null $tax_amount
 * @property float|null $discount_amount
 * @property float $total_amount
 * @property string $currency
 * @property string $status
 * @property Carbon|null $issued_at
 * @property Carbon|null $due_date
 * @property Carbon|null $paid_at
 * @property string|null $invoice_data
 * @property string|null $notes
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class Invoice extends Model
{
	protected $table = 'invoices';

	protected $casts = [
		'user_id' => 'int',
		'payment_id' => 'int',
		'subscription_id' => 'int',
		'amount' => 'float',
		'tax_amount' => 'float',
		'discount_amount' => 'float',
		'total_amount' => 'float',
		'issued_at' => 'datetime',
		'due_date' => 'datetime',
		'paid_at' => 'datetime'
	];

	protected $fillable = [
		'invoice_number',
		'user_id',
		'payment_id',
		'subscription_id',
		'amount',
		'tax_amount',
		'discount_amount',
		'total_amount',
		'currency',
		'status',
		'issued_at',
		'due_date',
		'paid_at',
		'invoice_data',
		'notes'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

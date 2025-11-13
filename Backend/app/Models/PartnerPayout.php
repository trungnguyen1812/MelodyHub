<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class PartnerPayout
 * 
 * @property int $id
 * @property int $partner_id
 * @property Carbon $payout_period_start
 * @property Carbon $payout_period_end
 * @property string|null $total_revenue_ids
 * @property float $total_amount
 * @property float $fee_amount
 * @property float $net_amount
 * @property string $currency
 * @property string $payment_method
 * @property string|null $transaction_reference
 * @property string|null $bank_name
 * @property string|null $account_number
 * @property string $status
 * @property Carbon|null $processed_at
 * @property int|null $processed_by
 * @property Carbon|null $completed_at
 * @property string|null $failed_reason
 * @property string|null $notes
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property Partner $partner
 *
 * @package App\Models
 */
class PartnerPayout extends Model
{
	protected $table = 'partner_payouts';

	protected $casts = [
		'partner_id' => 'int',
		'payout_period_start' => 'datetime',
		'payout_period_end' => 'datetime',
		'total_amount' => 'float',
		'fee_amount' => 'float',
		'net_amount' => 'float',
		'processed_at' => 'datetime',
		'processed_by' => 'int',
		'completed_at' => 'datetime'
	];

	protected $fillable = [
		'partner_id',
		'payout_period_start',
		'payout_period_end',
		'total_revenue_ids',
		'total_amount',
		'fee_amount',
		'net_amount',
		'currency',
		'payment_method',
		'transaction_reference',
		'bank_name',
		'account_number',
		'status',
		'processed_at',
		'processed_by',
		'completed_at',
		'failed_reason',
		'notes'
	];

	public function partner()
	{
		return $this->belongsTo(Partner::class);
	}
}

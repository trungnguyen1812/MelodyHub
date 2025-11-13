<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class PartnerRevenue
 * 
 * @property int $id
 * @property int $partner_id
 * @property int|null $song_id
 * @property string $period_type
 * @property Carbon $period_start
 * @property Carbon $period_end
 * @property int $total_plays
 * @property int $total_downloads
 * @property float $ad_revenue
 * @property float $subscription_revenue
 * @property float $total_revenue
 * @property float $partner_share_percentage
 * @property float $partner_share_amount
 * @property float $platform_share_amount
 * @property float $tax_amount
 * @property float $net_payout
 * @property string $status
 * @property Carbon|null $calculated_at
 * @property Carbon|null $approved_at
 * @property int|null $approved_by
 * @property Carbon|null $paid_at
 * @property string|null $payment_reference
 * @property string|null $notes
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property Partner $partner
 * @property Song|null $song
 *
 * @package App\Models
 */
class PartnerRevenue extends Model
{
	protected $table = 'partner_revenues';

	protected $casts = [
		'partner_id' => 'int',
		'song_id' => 'int',
		'period_start' => 'datetime',
		'period_end' => 'datetime',
		'total_plays' => 'int',
		'total_downloads' => 'int',
		'ad_revenue' => 'float',
		'subscription_revenue' => 'float',
		'total_revenue' => 'float',
		'partner_share_percentage' => 'float',
		'partner_share_amount' => 'float',
		'platform_share_amount' => 'float',
		'tax_amount' => 'float',
		'net_payout' => 'float',
		'calculated_at' => 'datetime',
		'approved_at' => 'datetime',
		'approved_by' => 'int',
		'paid_at' => 'datetime'
	];

	protected $fillable = [
		'partner_id',
		'song_id',
		'period_type',
		'period_start',
		'period_end',
		'total_plays',
		'total_downloads',
		'ad_revenue',
		'subscription_revenue',
		'total_revenue',
		'partner_share_percentage',
		'partner_share_amount',
		'platform_share_amount',
		'tax_amount',
		'net_payout',
		'status',
		'calculated_at',
		'approved_at',
		'approved_by',
		'paid_at',
		'payment_reference',
		'notes'
	];

	public function partner()
	{
		return $this->belongsTo(Partner::class);
	}

	public function song()
	{
		return $this->belongsTo(Song::class);
	}
}

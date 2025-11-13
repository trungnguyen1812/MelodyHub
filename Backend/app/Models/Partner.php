<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * Class Partner
 * 
 * @property int $id
 * @property int $user_id
 * @property string $company_name
 * @property string $company_email
 * @property string|null $company_phone
 * @property string|null $company_address
 * @property string|null $tax_code
 * @property string|null $website
 * @property string|null $logo_url
 * @property string|null $description
 * @property string|null $contract_number
 * @property string|null $contract_file_url
 * @property Carbon|null $contract_start_date
 * @property Carbon|null $contract_end_date
 * @property float|null $revenue_share_percentage
 * @property float|null $payment_threshold
 * @property string|null $payment_frequency
 * @property string|null $bank_name
 * @property string|null $bank_branch
 * @property string|null $bank_account_number
 * @property string|null $bank_account_name
 * @property int $total_songs
 * @property int $total_artists
 * @property int $total_albums
 * @property float $total_revenue
 * @property float $total_paid
 * @property float $pending_payout
 * @property string $status
 * @property Carbon|null $verified_at
 * @property int|null $verified_by
 * @property string|null $notes
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * @property string|null $deleted_at
 * 
 * @property User $user
 * @property Collection|Copyright[] $copyrights
 * @property Collection|PartnerPayout[] $partner_payouts
 * @property Collection|PartnerRevenue[] $partner_revenues
 * @property Collection|Song[] $songs
 *
 * @package App\Models
 */
class Partner extends Model
{
	use SoftDeletes;
	protected $table = 'partners';

	protected $casts = [
		'user_id' => 'int',
		'contract_start_date' => 'datetime',
		'contract_end_date' => 'datetime',
		'revenue_share_percentage' => 'float',
		'payment_threshold' => 'float',
		'total_songs' => 'int',
		'total_artists' => 'int',
		'total_albums' => 'int',
		'total_revenue' => 'float',
		'total_paid' => 'float',
		'pending_payout' => 'float',
		'verified_at' => 'datetime',
		'verified_by' => 'int'
	];

	protected $fillable = [
		'user_id',
		'company_name',
		'company_email',
		'company_phone',
		'company_address',
		'tax_code',
		'website',
		'logo_url',
		'description',
		'contract_number',
		'contract_file_url',
		'contract_start_date',
		'contract_end_date',
		'revenue_share_percentage',
		'payment_threshold',
		'payment_frequency',
		'bank_name',
		'bank_branch',
		'bank_account_number',
		'bank_account_name',
		'total_songs',
		'total_artists',
		'total_albums',
		'total_revenue',
		'total_paid',
		'pending_payout',
		'status',
		'verified_at',
		'verified_by',
		'notes'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}

	public function copyrights()
	{
		return $this->hasMany(Copyright::class);
	}

	public function partner_payouts()
	{
		return $this->hasMany(PartnerPayout::class);
	}

	public function partner_revenues()
	{
		return $this->hasMany(PartnerRevenue::class);
	}

	public function songs()
	{
		return $this->hasMany(Song::class);
	}
}

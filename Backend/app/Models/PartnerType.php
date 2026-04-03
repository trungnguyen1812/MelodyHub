<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class PartnerType
 * 
 * @property int $id
 * @property string $code
 * @property string $name
 * @property string|null $description
 * @property bool $can_upload_songs
 * @property bool $can_manage_artists
 * @property bool $can_book_ads
 * @property float $default_revenue_share
 * @property string $default_payment_frequency
 * @property float $default_payment_threshold
 * @property bool $is_active
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property Collection|Partner[] $partners
 *
 * @package App\Models
 */
class PartnerType extends Model
{
	protected $table = 'partner_types';

	protected $casts = [
		'can_upload_songs' => 'bool',
		'can_manage_artists' => 'bool',
		'can_book_ads' => 'bool',
		'default_revenue_share' => 'float',
		'default_payment_threshold' => 'float',
		'is_active' => 'bool'
	];

	protected $fillable = [
		'code',
		'name',
		'description',
		'can_upload_songs',
		'can_manage_artists',
		'can_book_ads',
		'default_revenue_share',
		'default_payment_frequency',
		'default_payment_threshold',
		'is_active'
	];

	public function partners()
	{
		return $this->hasMany(Partner::class);
	}
}

<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Advertisement
 * 
 * @property int $id
 * @property int|null $partner_id
 * @property string $name
 * @property string $type
 * @property string $advertiser_name
 * @property string|null $advertiser_url
 * @property string|null $media_url
 * @property string|null $thumbnail_url
 * @property string|null $click_url
 * @property int|null $duration
 * @property int|null $file_size
 * @property int|null $target_age_min
 * @property int|null $target_age_max
 * @property string|null $target_gender
 * @property array|null $target_location
 * @property string|null $target_audience
 * @property array|null $target_genres
 * @property float|null $budget_total
 * @property float|null $budget_spent
 * @property float|null $cost_per_play
 * @property float|null $cost_per_click
 * @property int|null $max_plays_per_user_per_day
 * @property int $priority
 * @property Carbon $start_date
 * @property Carbon|null $end_date
 * @property int $total_impressions
 * @property int $total_plays
 * @property int $total_clicks
 * @property float $total_revenue
 * @property int $total_skips
 * @property string|null $status
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * @property int|null $frequency_cap
 * @property Carbon|null $approved_at
 * @property int|null $approved_by
 * @property string|null $rejected_reason
 * 
 * @property Partner|null $partner
 * @property Collection|AdTracking[] $ad_trackings
 *
 * @package App\Models
 */
class Advertisement extends Model
{
	protected $table = 'advertisements';

	protected $casts = [
		'partner_id' => 'int',
		'duration' => 'int',
		'file_size' => 'int',
		'target_age_min' => 'int',
		'target_age_max' => 'int',
		'target_location' => 'json',
		'target_genres' => 'json',
		'budget_total' => 'float',
		'budget_spent' => 'float',
		'cost_per_play' => 'float',
		'cost_per_click' => 'float',
		'max_plays_per_user_per_day' => 'int',
		'priority' => 'int',
		'start_date' => 'datetime',
		'end_date' => 'datetime',
		'total_impressions' => 'int',
		'total_plays' => 'int',
		'total_clicks' => 'int',
		'total_revenue' => 'float',
		'total_skips' => 'int',
		'frequency_cap' => 'int',
		'approved_at' => 'datetime',
		'approved_by' => 'int'
	];

	protected $fillable = [
		'partner_id',
		'name',
		'type',
		'advertiser_name',
		'advertiser_url',
		'media_url',
		'thumbnail_url',
		'click_url',
		'duration',
		'file_size',
		'target_age_min',
		'target_age_max',
		'target_gender',
		'target_location',
		'target_audience',
		'target_genres',
		'budget_total',
		'budget_spent',
		'cost_per_play',
		'cost_per_click',
		'max_plays_per_user_per_day',
		'priority',
		'start_date',
		'end_date',
		'total_impressions',
		'total_plays',
		'total_clicks',
		'total_revenue',
		'total_skips',
		'status',
		'frequency_cap',
		'approved_at',
		'approved_by',
		'rejected_reason'
	];

	public function partner()
	{
		return $this->belongsTo(Partner::class);
	}

	public function ad_trackings()
	{
		return $this->hasMany(AdTracking::class, 'ad_id');
	}
}

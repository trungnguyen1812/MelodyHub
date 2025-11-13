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
 * @property string $name
 * @property string $type
 * @property string $advertiser_name
 * @property string|null $advertiser_url
 * @property string|null $media_url
 * @property string|null $click_url
 * @property int|null $duration
 * @property int|null $file_size
 * @property string|null $target_audience
 * @property string|null $target_genres
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
 * @property string $status
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property Collection|AdImpression[] $ad_impressions
 *
 * @package App\Models
 */
class Advertisement extends Model
{
	protected $table = 'advertisements';

	protected $casts = [
		'duration' => 'int',
		'file_size' => 'int',
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
		'total_clicks' => 'int'
	];

	protected $fillable = [
		'name',
		'type',
		'advertiser_name',
		'advertiser_url',
		'media_url',
		'click_url',
		'duration',
		'file_size',
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
		'status'
	];

	public function ad_impressions()
	{
		return $this->hasMany(AdImpression::class, 'ad_id');
	}
}

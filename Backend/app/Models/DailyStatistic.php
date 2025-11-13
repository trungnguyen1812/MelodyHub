<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class DailyStatistic
 * 
 * @property int $id
 * @property Carbon $date
 * @property int $total_users
 * @property int $new_users
 * @property int $active_users
 * @property int $total_songs
 * @property int $new_songs
 * @property int $total_plays
 * @property int $total_downloads
 * @property int $total_likes
 * @property int $total_comments
 * @property int $total_shares
 * @property int $vip_subscriptions
 * @property int $new_subscriptions
 * @property int $cancelled_subscriptions
 * @property float $subscription_revenue
 * @property float $ad_revenue
 * @property float $total_revenue
 * @property Carbon|null $created_at
 *
 * @package App\Models
 */
class DailyStatistic extends Model
{
	protected $table = 'daily_statistics';
	public $timestamps = false;

	protected $casts = [
		'date' => 'datetime',
		'total_users' => 'int',
		'new_users' => 'int',
		'active_users' => 'int',
		'total_songs' => 'int',
		'new_songs' => 'int',
		'total_plays' => 'int',
		'total_downloads' => 'int',
		'total_likes' => 'int',
		'total_comments' => 'int',
		'total_shares' => 'int',
		'vip_subscriptions' => 'int',
		'new_subscriptions' => 'int',
		'cancelled_subscriptions' => 'int',
		'subscription_revenue' => 'float',
		'ad_revenue' => 'float',
		'total_revenue' => 'float'
	];

	protected $fillable = [
		'date',
		'total_users',
		'new_users',
		'active_users',
		'total_songs',
		'new_songs',
		'total_plays',
		'total_downloads',
		'total_likes',
		'total_comments',
		'total_shares',
		'vip_subscriptions',
		'new_subscriptions',
		'cancelled_subscriptions',
		'subscription_revenue',
		'ad_revenue',
		'total_revenue'
	];
}

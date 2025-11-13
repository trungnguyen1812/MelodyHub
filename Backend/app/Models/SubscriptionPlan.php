<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class SubscriptionPlan
 * 
 * @property int $id
 * @property string $name
 * @property string $display_name
 * @property string|null $description
 * @property float $price
 * @property float|null $original_price
 * @property string $currency
 * @property int $duration_days
 * @property int $trial_days
 * @property int|null $max_playlists
 * @property int|null $max_songs_per_playlist
 * @property int|null $max_offline_downloads
 * @property int|null $max_devices
 * @property bool $can_download
 * @property string $audio_quality
 * @property bool $ads_free
 * @property bool $can_skip_unlimited
 * @property bool $can_create_collaborative_playlist
 * @property bool $priority_support
 * @property bool $early_access
 * @property bool $is_active
 * @property bool $is_featured
 * @property int $sort_order
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property Collection|UserSubscription[] $user_subscriptions
 *
 * @package App\Models
 */
class SubscriptionPlan extends Model
{
	protected $table = 'subscription_plans';

	protected $casts = [
		'price' => 'float',
		'original_price' => 'float',
		'duration_days' => 'int',
		'trial_days' => 'int',
		'max_playlists' => 'int',
		'max_songs_per_playlist' => 'int',
		'max_offline_downloads' => 'int',
		'max_devices' => 'int',
		'can_download' => 'bool',
		'ads_free' => 'bool',
		'can_skip_unlimited' => 'bool',
		'can_create_collaborative_playlist' => 'bool',
		'priority_support' => 'bool',
		'early_access' => 'bool',
		'is_active' => 'bool',
		'is_featured' => 'bool',
		'sort_order' => 'int'
	];

	protected $fillable = [
		'name',
		'display_name',
		'description',
		'price',
		'original_price',
		'currency',
		'duration_days',
		'trial_days',
		'max_playlists',
		'max_songs_per_playlist',
		'max_offline_downloads',
		'max_devices',
		'can_download',
		'audio_quality',
		'ads_free',
		'can_skip_unlimited',
		'can_create_collaborative_playlist',
		'priority_support',
		'early_access',
		'is_active',
		'is_featured',
		'sort_order'
	];

	public function user_subscriptions()
	{
		return $this->hasMany(UserSubscription::class, 'plan_id');
	}
}

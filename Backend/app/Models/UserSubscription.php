<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class UserSubscription
 * 
 * @property int $id
 * @property int $user_id
 * @property int $plan_id
 * @property string $status
 * @property Carbon $start_date
 * @property Carbon $end_date
 * @property Carbon $canceled_at
 * 
 * @property SubscriptionPlan $subscription_plan
 * @property User $user
 * @property Collection|Payment[] $payments
 *
 * @package App\Models
 */
class UserSubscription extends Model
{
	protected $table = 'user_subscriptions';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'plan_id' => 'int',
		'start_date' => 'datetime',
		'end_date' => 'datetime',
		'canceled_at' => 'datetime'
	];

	protected $fillable = [
		'user_id',
		'plan_id',
		'status',
		'start_date',
		'end_date',
		'canceled_at'
	];

	public function subscription_plan()
	{
		return $this->belongsTo(SubscriptionPlan::class, 'plan_id');
	}

	public function user()
	{
		return $this->belongsTo(User::class);
	}

	public function payments()
	{
		return $this->hasMany(Payment::class, 'subscription_id');
	}
}

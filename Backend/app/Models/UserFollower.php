<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class UserFollower
 * 
 * @property int $id
 * @property int $follower_id
 * @property int $following_id
 * @property Carbon $followed_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class UserFollower extends Model
{
	protected $table = 'user_followers';
	public $timestamps = false;

	protected $casts = [
		'follower_id' => 'int',
		'following_id' => 'int',
		'followed_at' => 'datetime'
	];

	protected $fillable = [
		'follower_id',
		'following_id',
		'followed_at'
	];

	public function user()
	{
		return $this->belongsTo(User::class, 'following_id');
	}
}

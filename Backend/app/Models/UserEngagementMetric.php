<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class UserEngagementMetric
 * 
 * @property int $id
 * @property int $user_id
 * @property Carbon $date
 * @property int $total_plays
 * @property int $total_listening_time
 * @property int $unique_songs_played
 * @property int $playlists_created
 * @property int $songs_liked
 * @property int $comments_posted
 * @property int $shares
 * @property float $engagement_score
 * @property Carbon|null $created_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class UserEngagementMetric extends Model
{
	protected $table = 'user_engagement_metrics';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'date' => 'datetime',
		'total_plays' => 'int',
		'total_listening_time' => 'int',
		'unique_songs_played' => 'int',
		'playlists_created' => 'int',
		'songs_liked' => 'int',
		'comments_posted' => 'int',
		'shares' => 'int',
		'engagement_score' => 'float'
	];

	protected $fillable = [
		'user_id',
		'date',
		'total_plays',
		'total_listening_time',
		'unique_songs_played',
		'playlists_created',
		'songs_liked',
		'comments_posted',
		'shares',
		'engagement_score'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

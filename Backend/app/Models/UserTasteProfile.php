<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class UserTasteProfile
 * 
 * @property int $id
 * @property int $user_id
 * @property string|null $favorite_genres
 * @property string|null $favorite_artists
 * @property string|null $listening_patterns
 * @property string|null $mood_preferences
 * @property string|null $audio_features
 * @property Carbon|null $updated_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class UserTasteProfile extends Model
{
	protected $table = 'user_taste_profile';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int'
	];

	protected $fillable = [
		'user_id',
		'favorite_genres',
		'favorite_artists',
		'listening_patterns',
		'mood_preferences',
		'audio_features'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class UserPreference
 * 
 * @property int $id
 * @property int $user_id
 * @property string|null $theme
 * @property string|null $audio_quality
 * @property bool $autoplay
 * @property bool $crossfade
 * @property int|null $crossfade_duration
 * @property bool $normalize_volume
 * @property bool $show_explicit_content
 * @property string|null $language
 * @property bool $notification_enabled
 * @property bool $email_notification
 * @property bool $push_notification
 * @property bool $private_session
 * @property bool $show_listening_activity
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class UserPreference extends Model
{
	protected $table = 'user_preferences';

	protected $casts = [
		'user_id' => 'int',
		'autoplay' => 'bool',
		'crossfade' => 'bool',
		'crossfade_duration' => 'int',
		'normalize_volume' => 'bool',
		'show_explicit_content' => 'bool',
		'notification_enabled' => 'bool',
		'email_notification' => 'bool',
		'push_notification' => 'bool',
		'private_session' => 'bool',
		'show_listening_activity' => 'bool'
	];

	protected $fillable = [
		'user_id',
		'theme',
		'audio_quality',
		'autoplay',
		'crossfade',
		'crossfade_duration',
		'normalize_volume',
		'show_explicit_content',
		'language',
		'notification_enabled',
		'email_notification',
		'push_notification',
		'private_session',
		'show_listening_activity'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

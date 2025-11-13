<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Notification
 * 
 * @property int $id
 * @property int $user_id
 * @property string $type
 * @property string $title
 * @property string $message
 * @property string|null $icon
 * @property string|null $action_url
 * @property string|null $action_text
 * @property string|null $related_type
 * @property int|null $related_id
 * @property bool $is_read
 * @property Carbon|null $read_at
 * @property string $sent_via
 * @property Carbon|null $created_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class Notification extends Model
{
	protected $table = 'notifications';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'related_id' => 'int',
		'is_read' => 'bool',
		'read_at' => 'datetime'
	];

	protected $fillable = [
		'user_id',
		'type',
		'title',
		'message',
		'icon',
		'action_url',
		'action_text',
		'related_type',
		'related_id',
		'is_read',
		'read_at',
		'sent_via'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class EmailLog
 * 
 * @property int $id
 * @property int|null $user_id
 * @property int|null $template_id
 * @property string $to_email
 * @property string $subject
 * @property string $body
 * @property string $status
 * @property Carbon|null $sent_at
 * @property string|null $failed_reason
 * @property int $opens
 * @property int $clicks
 * @property Carbon|null $created_at
 * 
 * @property EmailTemplate|null $email_template
 * @property User|null $user
 *
 * @package App\Models
 */
class EmailLog extends Model
{
	protected $table = 'email_logs';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'template_id' => 'int',
		'sent_at' => 'datetime',
		'opens' => 'int',
		'clicks' => 'int'
	];

	protected $fillable = [
		'user_id',
		'template_id',
		'to_email',
		'subject',
		'body',
		'status',
		'sent_at',
		'failed_reason',
		'opens',
		'clicks'
	];

	public function email_template()
	{
		return $this->belongsTo(EmailTemplate::class, 'template_id');
	}

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

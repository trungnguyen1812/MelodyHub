<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class ContentReport
 * 
 * @property int $id
 * @property int $reporter_user_id
 * @property string $target_type
 * @property int $target_id
 * @property string $reason
 * @property string|null $status
 * @property Carbon|null $created_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class ContentReport extends Model
{
	protected $table = 'content_reports';
	public $timestamps = false;

	protected $casts = [
		'reporter_user_id' => 'int',
		'target_id' => 'int'
	];

	protected $fillable = [
		'reporter_user_id',
		'target_type',
		'target_id',
		'reason',
		'status'
	];

	public function user()
	{
		return $this->belongsTo(User::class, 'reporter_user_id');
	}
}

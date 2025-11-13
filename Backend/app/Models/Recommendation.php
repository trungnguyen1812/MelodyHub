<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Recommendation
 * 
 * @property int $id
 * @property int $user_id
 * @property string $recommended_type
 * @property int $recommended_id
 * @property string|null $reason
 * @property float $score
 * @property string|null $algorithm
 * @property bool $is_shown
 * @property bool $is_clicked
 * @property Carbon|null $shown_at
 * @property Carbon|null $clicked_at
 * @property Carbon|null $created_at
 * 
 * @property User $user
 *
 * @package App\Models
 */
class Recommendation extends Model
{
	protected $table = 'recommendations';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'recommended_id' => 'int',
		'score' => 'float',
		'is_shown' => 'bool',
		'is_clicked' => 'bool',
		'shown_at' => 'datetime',
		'clicked_at' => 'datetime'
	];

	protected $fillable = [
		'user_id',
		'recommended_type',
		'recommended_id',
		'reason',
		'score',
		'algorithm',
		'is_shown',
		'is_clicked',
		'shown_at',
		'clicked_at'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

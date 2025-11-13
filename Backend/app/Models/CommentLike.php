<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class CommentLike
 * 
 * @property int $id
 * @property int $user_id
 * @property int $comment_id
 * @property Carbon $created_at
 * 
 * @property Comment $comment
 * @property User $user
 *
 * @package App\Models
 */
class CommentLike extends Model
{
	protected $table = 'comment_likes';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'comment_id' => 'int'
	];

	protected $fillable = [
		'user_id',
		'comment_id'
	];

	public function comment()
	{
		return $this->belongsTo(Comment::class);
	}

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

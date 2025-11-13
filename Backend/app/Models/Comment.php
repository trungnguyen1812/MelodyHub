<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * Class Comment
 * 
 * @property int $id
 * @property int $user_id
 * @property int $song_id
 * @property int|null $parent_id
 * @property string $content
 * @property int|null $timestamp
 * @property int $total_likes
 * @property int $total_replies
 * @property bool $is_pinned
 * @property bool $is_edited
 * @property string $status
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * @property string|null $deleted_at
 * 
 * @property Comment|null $comment
 * @property Song $song
 * @property User $user
 * @property Collection|CommentLike[] $comment_likes
 * @property Collection|Comment[] $comments
 *
 * @package App\Models
 */
class Comment extends Model
{
	use SoftDeletes;
	protected $table = 'comments';

	protected $casts = [
		'user_id' => 'int',
		'song_id' => 'int',
		'parent_id' => 'int',
		'timestamp' => 'int',
		'total_likes' => 'int',
		'total_replies' => 'int',
		'is_pinned' => 'bool',
		'is_edited' => 'bool'
	];

	protected $fillable = [
		'user_id',
		'song_id',
		'parent_id',
		'content',
		'timestamp',
		'total_likes',
		'total_replies',
		'is_pinned',
		'is_edited',
		'status'
	];

	public function comment()
	{
		return $this->belongsTo(Comment::class, 'parent_id');
	}

	public function song()
	{
		return $this->belongsTo(Song::class);
	}

	public function user()
	{
		return $this->belongsTo(User::class);
	}

	public function comment_likes()
	{
		return $this->hasMany(CommentLike::class);
	}

	public function comments()
	{
		return $this->hasMany(Comment::class, 'parent_id');
	}
}

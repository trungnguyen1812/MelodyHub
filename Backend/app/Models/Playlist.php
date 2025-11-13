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
 * Class Playlist
 * 
 * @property int $id
 * @property int $user_id
 * @property string $name
 * @property string|null $slug
 * @property string|null $description
 * @property string|null $cover_url
 * @property bool $is_public
 * @property bool $is_collaborative
 * @property bool $is_system
 * @property int $total_songs
 * @property int $total_duration
 * @property int $total_followers
 * @property int $total_plays
 * @property int $play_count_last_30d
 * @property string $status
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * @property string|null $deleted_at
 * 
 * @property User $user
 * @property Collection|PlaylistCollaborator[] $playlist_collaborators
 * @property Collection|PlaylistFollower[] $playlist_followers
 * @property Collection|Song[] $songs
 *
 * @package App\Models
 */
class Playlist extends Model
{
	use SoftDeletes;
	protected $table = 'playlists';

	protected $casts = [
		'user_id' => 'int',
		'is_public' => 'bool',
		'is_collaborative' => 'bool',
		'is_system' => 'bool',
		'total_songs' => 'int',
		'total_duration' => 'int',
		'total_followers' => 'int',
		'total_plays' => 'int',
		'play_count_last_30d' => 'int'
	];

	protected $fillable = [
		'user_id',
		'name',
		'slug',
		'description',
		'cover_url',
		'is_public',
		'is_collaborative',
		'is_system',
		'total_songs',
		'total_duration',
		'total_followers',
		'total_plays',
		'play_count_last_30d',
		'status'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}

	public function playlist_collaborators()
	{
		return $this->hasMany(PlaylistCollaborator::class);
	}

	public function playlist_followers()
	{
		return $this->hasMany(PlaylistFollower::class);
	}

	public function songs()
	{
		return $this->belongsToMany(Song::class, 'playlist_songs')
					->withPivot('id', 'added_by', 'position', 'added_at');
	}
}

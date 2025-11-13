<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class PlaylistCollaborator
 * 
 * @property int $id
 * @property int $playlist_id
 * @property int $user_id
 * @property string $role
 * @property int $invited_by
 * @property Carbon $invited_at
 * @property Carbon|null $accepted_at
 * 
 * @property Playlist $playlist
 * @property User $user
 *
 * @package App\Models
 */
class PlaylistCollaborator extends Model
{
	protected $table = 'playlist_collaborators';
	public $timestamps = false;

	protected $casts = [
		'playlist_id' => 'int',
		'user_id' => 'int',
		'invited_by' => 'int',
		'invited_at' => 'datetime',
		'accepted_at' => 'datetime'
	];

	protected $fillable = [
		'playlist_id',
		'user_id',
		'role',
		'invited_by',
		'invited_at',
		'accepted_at'
	];

	public function playlist()
	{
		return $this->belongsTo(Playlist::class);
	}

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

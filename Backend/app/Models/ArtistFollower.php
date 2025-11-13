<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class ArtistFollower
 * 
 * @property int $id
 * @property int $user_id
 * @property int $artist_id
 * @property Carbon $followed_at
 * 
 * @property Artist $artist
 * @property User $user
 *
 * @package App\Models
 */
class ArtistFollower extends Model
{
	protected $table = 'artist_followers';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'artist_id' => 'int',
		'followed_at' => 'datetime'
	];

	protected $fillable = [
		'user_id',
		'artist_id',
		'followed_at'
	];

	public function artist()
	{
		return $this->belongsTo(Artist::class);
	}

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

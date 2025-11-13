<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class AlbumLike
 * 
 * @property int $id
 * @property int $user_id
 * @property int $album_id
 * @property Carbon $created_at
 * 
 * @property Album $album
 * @property User $user
 *
 * @package App\Models
 */
class AlbumLike extends Model
{
	protected $table = 'album_likes';
	public $timestamps = true;
	protected $hidden = [];


	protected $casts = [
		'user_id' => 'int',
		'album_id' => 'int',
		'created_at' => 'datetime'
	];

	protected $fillable = [
		'user_id',
		'album_id'
	];

	public function album()
	{
		return $this->belongsTo(Album::class , 'album_id', 'id');
	}

	public function user()
	{
		return $this->belongsTo(User::class);
	}
}

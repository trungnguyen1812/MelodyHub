<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class SongArtist
 * 
 * @property int $id
 * @property int $song_id
 * @property int $artist_id
 * @property string $role
 * @property int $order
 * 
 * @property Artist $artist
 * @property Song $song
 *
 * @package App\Models
 */
class SongArtist extends Model
{
	protected $table = 'song_artists';
	public $timestamps = false;

	protected $casts = [
		'song_id' => 'int',
		'artist_id' => 'int',
		'order' => 'int'
	];

	protected $fillable = [
		'song_id',
		'artist_id',
		'role',
		'order'
	];

	public function artist()
	{
		return $this->belongsTo(Artist::class);
	}

	public function song()
	{
		return $this->belongsTo(Song::class);
	}
}

<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Class SongGenre
 * 
 * @property int $id
 * @property int $song_id
 * @property int $genre_id
 * @property bool $is_primary
 * 
 * @property Genre $genre
 * @property Song $song
 *
 * @package App\Models
 */
class SongGenre extends Model
{
	protected $table = 'song_genres';
	public $timestamps = false;

	protected $casts = [
		'song_id' => 'int',
		'genre_id' => 'int',
		'is_primary' => 'bool'
	];

	protected $fillable = [
		'song_id',
		'genre_id',
		'is_primary'
	];

	public function genre()
	{
		return $this->belongsTo(Genre::class);
	}

	public function song()
	{
		return $this->belongsTo(Song::class);
	}
}

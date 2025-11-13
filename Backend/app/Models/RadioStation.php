<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class RadioStation
 * 
 * @property int $id
 * @property int|null $user_id
 * @property int|null $seed_song_id
 * @property int|null $seed_artist_id
 * @property int|null $seed_genre_id
 * @property string|null $mood
 * @property Carbon|null $created_at
 * 
 * @property User|null $user
 * @property Song|null $song
 * @property Artist|null $artist
 * @property Genre|null $genre
 *
 * @package App\Models
 */
class RadioStation extends Model
{
	protected $table = 'radio_stations';
	public $timestamps = false;

	protected $casts = [
		'user_id' => 'int',
		'seed_song_id' => 'int',
		'seed_artist_id' => 'int',
		'seed_genre_id' => 'int'
	];

	protected $fillable = [
		'user_id',
		'seed_song_id',
		'seed_artist_id',
		'seed_genre_id',
		'mood'
	];

	public function user()
	{
		return $this->belongsTo(User::class);
	}

	public function song()
	{
		return $this->belongsTo(Song::class, 'seed_song_id');
	}

	public function artist()
	{
		return $this->belongsTo(Artist::class, 'seed_artist_id');
	}

	public function genre()
	{
		return $this->belongsTo(Genre::class, 'seed_genre_id');
	}
}

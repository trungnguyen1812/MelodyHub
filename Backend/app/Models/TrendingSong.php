<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class TrendingSong
 * 
 * @property int $id
 * @property int $song_id
 * @property int $position
 * @property float $score
 * @property int $plays_24h
 * @property int $plays_7d
 * @property float|null $plays_growth_rate
 * @property int|null $genre_id
 * @property string $country_code
 * @property Carbon $calculated_at
 * 
 * @property Country $country
 * @property Genre|null $genre
 * @property Song $song
 *
 * @package App\Models
 */
class TrendingSong extends Model
{
	protected $table = 'trending_songs';
	public $timestamps = false;

	protected $casts = [
		'song_id' => 'int',
		'position' => 'int',
		'score' => 'float',
		'plays_24h' => 'int',
		'plays_7d' => 'int',
		'plays_growth_rate' => 'float',
		'genre_id' => 'int',
		'calculated_at' => 'datetime'
	];

	protected $fillable = [
		'song_id',
		'position',
		'score',
		'plays_24h',
		'plays_7d',
		'plays_growth_rate',
		'genre_id',
		'country_code',
		'calculated_at'
	];

	public function country()
	{
		return $this->belongsTo(Country::class, 'country_code');
	}

	public function genre()
	{
		return $this->belongsTo(Genre::class);
	}

	public function song()
	{
		return $this->belongsTo(Song::class);
	}
}

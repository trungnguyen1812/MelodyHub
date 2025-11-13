<?php

/**
 * Created by Reliese Model.
 */

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Genre
 * 
 * @property int $id
 * @property string $name
 * @property string $slug
 * @property string|null $description
 * @property string|null $cover_url
 * @property string|null $color
 * @property int|null $parent_id
 * @property int $order
 * @property bool $is_active
 * @property int $total_songs
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * 
 * @property Collection|RadioStation[] $radio_stations
 * @property Collection|Song[] $songs
 * @property Collection|TrendingSong[] $trending_songs
 *
 * @package App\Models
 */
class Genre extends Model
{
	protected $table = 'genres';

	protected $casts = [
		'parent_id' => 'int',
		'order' => 'int',
		'is_active' => 'bool',
		'total_songs' => 'int'
	];

	protected $fillable = [
		'name',
		'slug',
		'description',
		'cover_url',
		'color',
		'parent_id',
		'order',
		'is_active',
		'total_songs'
	];

	public function radio_stations()
	{
		return $this->hasMany(RadioStation::class, 'seed_genre_id');
	}

	public function songs()
	{
		return $this->belongsToMany(Song::class, 'song_genres')
					->withPivot('id', 'is_primary');
	}

	public function trending_songs()
	{
		return $this->hasMany(TrendingSong::class);
	}
}

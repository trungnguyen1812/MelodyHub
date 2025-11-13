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
 * Class Album
 * 
 * @property int $id
 * @property string $name
 * @property string $slug
 * @property int $artist_id
 * @property string|null $cover_url
 * @property string|null $description
 * @property Carbon|null $release_date
 * @property string $album_type
 * @property string|null $label
 * @property int $total_tracks
 * @property int $total_duration
 * @property int $total_plays
 * @property int $total_likes
 * @property bool $is_featured
 * @property bool $is_premium
 * @property int|null $partner_id
 * @property string $status
 * @property Carbon|null $published_at
 * @property string|null $seo_title
 * @property string|null $seo_description
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * @property string|null $deleted_at
 * 
 * @property Collection|AlbumLike[] $album_likes
 * @property Collection|Song[] $songs
 *
 * @package App\Models
 */
class Album extends Model
{
	use SoftDeletes;
	protected $table = 'albums';

	protected $casts = [
		'artist_id' => 'int',
		'release_date' => 'datetime',
		'total_tracks' => 'int',
		'total_duration' => 'int',
		'total_plays' => 'int',
		'total_likes' => 'int',
		'is_featured' => 'bool',
		'is_premium' => 'bool',
		'partner_id' => 'int',
		'published_at' => 'datetime'
	];

	protected $fillable = [
		'name',
		'slug',
		'artist_id',
		'cover_url',
		'description',
		'release_date',
		'album_type',
		'label',
		'total_tracks',
		'total_duration',
		'total_plays',
		'total_likes',
		'is_featured',
		'is_premium',
		'partner_id',
		'status',
		'published_at',
		'seo_title',
		'seo_description'
	];

	public function album_likes()
	{
		return $this->hasMany(AlbumLike::class);
	}

	public function songs()
	{
		return $this->hasMany(Song::class);
	}
}

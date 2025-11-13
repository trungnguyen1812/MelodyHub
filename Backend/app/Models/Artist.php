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
 * Class Artist
 * 
 * @property int $id
 * @property string $name
 * @property int $monthly_listeners
 * @property string $slug
 * @property string|null $bio
 * @property string|null $avatar_url
 * @property string|null $banner_url
 * @property string|null $country
 * @property string|null $website
 * @property string|null $facebook_url
 * @property string|null $instagram_url
 * @property string|null $twitter_url
 * @property string|null $youtube_url
 * @property bool $verified
 * @property bool $is_featured
 * @property int $total_followers
 * @property int $total_plays
 * @property int $total_songs
 * @property int $total_albums
 * @property int|null $partner_id
 * @property string $status
 * @property string|null $seo_title
 * @property string|null $seo_description
 * @property string|null $seo_keywords
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * @property string|null $deleted_at
 * 
 * @property Collection|ArtistFollower[] $artist_followers
 * @property Collection|RadioStation[] $radio_stations
 * @property Collection|Song[] $songs
 *
 * @package App\Models
 */
class Artist extends Model
{
	use SoftDeletes;
	protected $table = 'artists';

	protected $casts = [
		'monthly_listeners' => 'int',
		'verified' => 'bool',
		'is_featured' => 'bool',
		'total_followers' => 'int',
		'total_plays' => 'int',
		'total_songs' => 'int',
		'total_albums' => 'int',
		'partner_id' => 'int'
	];

	protected $fillable = [
		'name',
		'monthly_listeners',
		'slug',
		'bio',
		'avatar_url',
		'banner_url',
		'country',
		'website',
		'facebook_url',
		'instagram_url',
		'twitter_url',
		'youtube_url',
		'verified',
		'is_featured',
		'total_followers',
		'total_plays',
		'total_songs',
		'total_albums',
		'partner_id',
		'status',
		'seo_title',
		'seo_description',
		'seo_keywords'
	];

	public function artist_followers()
	{
		return $this->hasMany(ArtistFollower::class);
	}

	public function radio_stations()
	{
		return $this->hasMany(RadioStation::class, 'seed_artist_id');
	}

	public function songs()
	{
		return $this->hasMany(Song::class);
	}
}

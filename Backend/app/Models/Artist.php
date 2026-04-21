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
		return $this->hasMany(Song::class, 'artist_id', 'id');

	}

	public function scopeSearch($query , $q) {
		if (!$q) return $query;
		return $query->where(function ($sub) use ($q) {
			$sub->where('name' , 'like', "%$q%")
				->orWhere('country', 'like', "%$q%")
				->orWhere('status' , 'like' ,"%$q%");
		});
	}

	public static function getTotalArtists()
    {
        return self::count();
    }

	public static function getNewArtistsThisMonth()
    {
        return self::whereMonth('created_at', Carbon::now()->month)
                    ->whereYear('created_at', Carbon::now()->year)
                    ->count();
    }

	public static function getNewArtistsLastMonth()
    {
        $lastMonth = Carbon::now()->subMonth();
        
        return self::whereMonth('created_at', $lastMonth->month)
                    ->whereYear('created_at', $lastMonth->year)
                    ->count();
    }

	public static function getGrowthPercentage()
    {
        $thisMonth = self::getNewArtistsThisMonth();
        $lastMonth = self::getNewArtistsLastMonth();
        
        if ($lastMonth == 0) {
            return $thisMonth > 0 ? 100 : 0;
        }
        
        $percentage = (($thisMonth - $lastMonth) / $lastMonth) * 100;
        return round($percentage, 2);
    }
    
    public static function getFullStatistics()
    {
        $total = self::getTotalArtists();
        $thisMonth = self::getNewArtistsThisMonth();
        $lastMonth = self::getNewArtistsLastMonth();
        $growthPercentage = self::getGrowthPercentage();
        
        return [
            'total_artists' => $total,
            'new_artists_this_month' => $thisMonth,
            'new_artists_last_month' => $lastMonth,
            'growth_percentage' => $growthPercentage,
            'status' => $growthPercentage >= 0 ? 'increase' : 'decrease'
        ];
    }

    public function partner()
    {
        return $this->belongsTo(Partner::class, 'partner_id', 'id');
    }

	 protected static function boot()
    {
        parent::boot();
        
        static::created(function ($artist) {
            if ($artist->partner_id) {
                Partner::find($artist->partner_id)?->clearCache();
            }
        });
        
        static::deleted(function ($artist) {
            if ($artist->partner_id) {
                Partner::find($artist->partner_id)?->clearCache();
            }
        });
        
        static::updated(function ($artist) {
            if ($artist->isDirty('partner_id')) {
                if ($artist->getOriginal('partner_id')) {
                    Partner::find($artist->getOriginal('partner_id'))?->clearCache();
                }
                if ($artist->partner_id) {
                    Partner::find($artist->partner_id)?->clearCache();
                }
            }
        });
    }
}
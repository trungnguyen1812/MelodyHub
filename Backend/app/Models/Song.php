<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;

/**
 * Class Song
 * 
 * @property int $id
 * @property string $title
 * @property string $slug
 * @property int $artist_id
 * @property int|null $album_id
 * @property int|null $genre_id
 * @property int $duration
 * @property int|null $track_number
 * @property int|null $disc_number
 * @property int|null $year
 * @property string|null $lyrics
 * @property string|null $lyrics_status
 * @property Carbon|null $lyrics_processed_at
 * @property string|null $lyrics_error
 * @property string|null $song_url
 * @property string|null $audio_public_id
 * @property string|null $song_url_hq
 * @property string|null $song_url_lossless
 * @property string|null $cover_url
 * @property string|null $waveform_data
 * @property int|null $file_size
 * @property int|null $bitrate
 * @property string $quality
 * @property string|null $isrc
 * @property bool $is_premium
 * @property bool $is_explicit
 * @property bool $is_featured
 * @property bool $allow_download
 * @property int $total_plays
 * @property int $total_likes
 * @property int $total_comments
 * @property int $total_shares
 * @property int $total_downloads
 * @property int|null $partner_id
 * @property string|null $copyright_owner
 * @property string|null $license_type
 * @property string $status
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * @property string|null $Descriptions
 * 
 * @property Album|null $album
 * @property Artist $artist
 * @property Genre|null $genre
 * @property Partner|null $partner
 * @property Collection|Comment[] $comments
 * @property Collection|Copyright[] $copyrights
 * @property Collection|ListeningHistory[] $listening_histories
 * @property Collection|PartnerRevenue[] $partner_revenues
 * @property Collection|Playlist[] $playlists
 * @property Collection|RadioStation[] $radio_stations
 * @property Collection|Artist[] $artists
 * @property Collection|SongDownload[] $song_downloads
 * @property Collection|SongLike[] $song_likes
 * @property Collection|SongPlay[] $song_plays
 * @property Collection|TrendingSong[] $trending_songs
 * @property Collection|User[] $users
 * @property Collection|UserQueue[] $user_queues
 *
 * @package App\Models
 */
class Song extends Model
{
    protected $table = 'songs';

    protected $casts = [
        'id' => 'int',
        'artist_id' => 'int',
        'album_id' => 'int',
        'genre_id' => 'int',
        'duration' => 'int',
        'track_number' => 'int',
        'disc_number' => 'int',
        'year' => 'int',
        'file_size' => 'int',
        'bitrate' => 'int',
        'quality' => 'string',
        'is_premium' => 'boolean',
        'is_explicit' => 'boolean',
		'audio_processed_at'  => 'datetime',
        'is_featured' => 'boolean',
        'allow_download' => 'boolean',
        'total_plays' => 'int',
        'total_likes' => 'int',
        'total_comments' => 'int',
        'total_shares' => 'int',
        'total_downloads' => 'int',
        'partner_id' => 'int',
        'lyrics_processed_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    protected $fillable = [
        'title',
        'slug',
        'artist_id',
        'album_id',
        'genre_id',
        'duration',
        'track_number',
        'disc_number',
        'year',
        'lyrics',
        'lyrics_status',
        'lyrics_processed_at',
        'lyrics_error',
        'song_url',
        'audio_public_id',
        'song_url_hq',
        'song_url_lossless',
        'cover_url',
        'waveform_data',
        'file_size',
        'bitrate',
        'quality',
        'isrc',
        'is_premium',
        'is_explicit',
        'is_featured',
        'allow_download',
        'total_plays',
        'total_likes',
        'total_comments',
        'total_shares',
        'total_downloads',
        'partner_id',
        'copyright_owner',
        'license_type',
        'status',
		'audio_processing_error',
        'Descriptions'
    ];

    // ============ Relationships ============
    
    public function album()
    {
        return $this->belongsTo(Album::class);
    }

    public function artist()
    {
        return $this->belongsTo(Artist::class);
    }

    public function genre()
    {
        return $this->belongsTo(Genre::class, 'genre_id');
    }

    public function partner()
    {
        return $this->belongsTo(Partner::class);
    }

    // ============ Lyrics Helpers ============
    
    /**
     * Check if lyrics are available
     */
    public function hasLyrics(): bool
    {
        return $this->lyrics && $this->lyrics !== '[]' && $this->lyrics !== null;
    }
    
    /**
     * Get lyrics as array
     */
    public function getLyricsArray(): ?array
    {
        if (!$this->hasLyrics()) {
            return null;
        }
        
        return json_decode($this->lyrics, true);
    }
    
    /**
     * Check if lyrics generation is completed
     */
    public function isLyricsCompleted(): bool
    {
        return $this->lyrics_status === 'completed';
    }
    
    /**
     * Check if lyrics generation is processing
     */
    public function isLyricsProcessing(): bool
    {
        return $this->lyrics_status === 'processing';
    }
    
    /**
     * Check if lyrics generation failed
     */
    public function isLyricsFailed(): bool
    {
        return $this->lyrics_status === 'failed';
    }

    // ============ Other Relationships ============
    
    public function comments()
    {
        return $this->hasMany(Comment::class);
    }

    public function copyrights()
    {
        return $this->hasMany(Copyright::class);
    }

    public function listening_histories()
    {
        return $this->hasMany(ListeningHistory::class);
    }

    public function partner_revenues()
    {
        return $this->hasMany(PartnerRevenue::class);
    }

    public function playlists()
    {
        return $this->belongsToMany(Playlist::class, 'playlist_songs')
                    ->withPivot('id', 'added_by', 'position', 'added_at');
    }

    public function radio_stations()
    {
        return $this->hasMany(RadioStation::class, 'seed_song_id');
    }

    public function artists()
    {
        return $this->belongsToMany(Artist::class, 'song_artists')
                    ->withPivot('id', 'role', 'order');
    }

    public function song_downloads()
    {
        return $this->hasMany(SongDownload::class);
    }

    public function song_likes()
    {
        return $this->hasMany(SongLike::class);
    }

    public function song_plays()
    {
        return $this->hasMany(SongPlay::class);
    }

    public function trending_songs()
    {
        return $this->hasMany(TrendingSong::class);
    }

    public function users()
    {
        return $this->belongsToMany(User::class, 'user_offline_songs')
                    ->withPivot('id', 'expires_at');
    }

    public function user_queues()
    {
        return $this->hasMany(UserQueue::class);
    }
}
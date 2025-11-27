<?php

/**
 * Created by Reliese Model.
 */
namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

/**
 * Class User
 * 
 * @property int $id
 * @property string $name
 * @property string $slug
 * @property string $email
 * @property string|null $phone
 * @property string|null $username
 * @property Carbon|null $email_verified_at
 * @property Carbon|null $phone_verified_at
 * @property string $password
 * @property string|null $avatar_url
 * @property string|null $banner_url
 * @property Carbon|null $date_of_birth
 * @property string|null $gender
 * @property string|null $country
 * @property string|null $language
 * @property string|null $timezone
 * @property string|null $bio
 * @property string $status
 * @property Carbon|null $published_at
 * @property int $play_count_last_24h
 * @property int $play_count_last_7d
 * @property int $play_count_last_30d
 * @property float $trending_score
 * @property string|null $seo_title
 * @property string|null $seo_description
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 * @property string|null $deleted_at
 * @property int $has_used_trial
 * @property bool $is_vip
 * @property Carbon|null $vip_expires_at
 * 
 * @property Collection|AdImpression[] $ad_impressions
 * @property Collection|AdminActivityLog[] $admin_activity_logs
 * @property Collection|AlbumLike[] $album_likes
 * @property Collection|ApiLog[] $api_logs
 * @property Collection|ArtistFollower[] $artist_followers
 * @property Collection|CommentLike[] $comment_likes
 * @property Collection|Comment[] $comments
 * @property Collection|ContentReport[] $content_reports
 * @property Collection|CouponUsage[] $coupon_usages
 * @property Collection|EmailLog[] $email_logs
 * @property Collection|Invoice[] $invoices
 * @property Collection|ListeningHistory[] $listening_histories
 * @property Collection|LoginHistory[] $login_histories
 * @property Collection|Notification[] $notifications
 * @property Collection|Partner[] $partners
 * @property Collection|PaymentMethod[] $payment_methods
 * @property Collection|Payment[] $payments
 * @property Collection|PlaylistCollaborator[] $playlist_collaborators
 * @property Collection|PlaylistFollower[] $playlist_followers
 * @property Collection|PlaylistSongEdit[] $playlist_song_edits
 * @property Collection|PlaylistSong[] $playlist_songs
 * @property Collection|Playlist[] $playlists
 * @property Collection|RadioStation[] $radio_stations
 * @property Collection|Recommendation[] $recommendations
 * @property Collection|SecurityLog[] $security_logs
 * @property Collection|SongDownload[] $song_downloads
 * @property Collection|SongLike[] $song_likes
 * @property Collection|SongPlay[] $song_plays
 * @property TwoFactorAuth|null $two_factor_auth
 * @property Collection|UserDevice[] $user_devices
 * @property Collection|UserEngagementMetric[] $user_engagement_metrics
 * @property Collection|UserFollower[] $user_followers
 * @property Collection|Song[] $songs
 * @property UserPreference|null $user_preference
 * @property Collection|UserQueue[] $user_queues
 * @property Collection|Role[] $roles
 * @property Collection|UserSubscription[] $user_subscriptions
 * @property UserTasteProfile|null $user_taste_profile
 *
 * @package App\Models
 */
class User extends Authenticatable
{
	use HasApiTokens, Notifiable, SoftDeletes;
	use SoftDeletes;
	protected $table = 'users';
	protected $casts = [
		'email_verified_at' => 'datetime',
		'phone_verified_at' => 'datetime',
		'date_of_birth' => 'datetime',
		'published_at' => 'datetime',
		'play_count_last_24h' => 'int',
		'play_count_last_7d' => 'int',
		'play_count_last_30d' => 'int',
		'trending_score' => 'float',
		'has_used_trial' => 'int',
		'is_vip' => 'bool',
		'vip_expires_at' => 'datetime'
	];

	protected $hidden = [
		'password'
	];

	protected $fillable = [
		'name',
		'slug',
		'email',
		'phone',
		'username',
		'email_verified_at',
		'phone_verified_at',
		'password',
		'avatar_url',
		'banner_url',
		'date_of_birth',
		'gender',
		'country',
		'language',
		'timezone',
		'bio',
		'status',
		'published_at',
		'play_count_last_24h',
		'play_count_last_7d',
		'play_count_last_30d',
		'trending_score',
		'seo_title',
		'seo_description',
		'has_used_trial',
		'is_vip',
		'vip_expires_at'
	];

	public function country()
	{
		return $this->belongsTo(Country::class, 'country');
	}

	public function ad_impressions()
	{
		return $this->hasMany(AdImpression::class);
	}

	public function admin_activity_logs()
	{
		return $this->hasMany(AdminActivityLog::class, 'admin_id');
	}

	public function album_likes()
	{
		return $this->hasMany(AlbumLike::class);
	}

	public function api_logs()
	{
		return $this->hasMany(ApiLog::class);
	}

	public function artist_followers()
	{
		return $this->hasMany(ArtistFollower::class);
	}

	public function comment_likes()
	{
		return $this->hasMany(CommentLike::class);
	}

	public function comments()
	{
		return $this->hasMany(Comment::class);
	}

	public function content_reports()
	{
		return $this->hasMany(ContentReport::class, 'reporter_user_id');
	}

	public function coupon_usages()
	{
		return $this->hasMany(CouponUsage::class);
	}

	public function email_logs()
	{
		return $this->hasMany(EmailLog::class);
	}

	public function invoices()
	{
		return $this->hasMany(Invoice::class);
	}

	public function listening_histories()
	{
		return $this->hasMany(ListeningHistory::class);
	}

	public function login_histories()
	{
		return $this->hasMany(LoginHistory::class);
	}

	public function notifications()
	{
		return $this->hasMany(Notification::class);
	}

	public function partners()
	{
		return $this->hasMany(Partner::class);
	}

	public function payment_methods()
	{
		return $this->hasMany(PaymentMethod::class);
	}

	public function payments()
	{
		return $this->hasMany(Payment::class);
	}

	public function playlist_collaborators()
	{
		return $this->hasMany(PlaylistCollaborator::class);
	}

	public function playlist_followers()
	{
		return $this->hasMany(PlaylistFollower::class);
	}

	public function playlist_song_edits()
	{
		return $this->hasMany(PlaylistSongEdit::class);
	}

	public function playlist_songs()
	{
		return $this->hasMany(PlaylistSong::class, 'added_by');
	}

	public function playlists()
	{
		return $this->hasMany(Playlist::class);
	}

	public function radio_stations()
	{
		return $this->hasMany(RadioStation::class);
	}

	public function recommendations()
	{
		return $this->hasMany(Recommendation::class);
	}

	public function security_logs()
	{
		return $this->hasMany(SecurityLog::class);
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

	public function two_factor_auth()
	{
		return $this->hasOne(TwoFactorAuth::class);
	}

	public function user_devices()
	{
		return $this->hasMany(UserDevice::class);
	}

	public function user_engagement_metrics()
	{
		return $this->hasMany(UserEngagementMetric::class);
	}

	public function user_followers()
	{
		return $this->hasMany(UserFollower::class, 'following_id');
	}

	public function songs()
	{
		return $this->belongsToMany(Song::class, 'user_offline_songs')
					->withPivot('id', 'expires_at');
	}

	public function user_preference()
	{
		return $this->hasOne(UserPreference::class);
	}

	public function user_queues()
	{
		return $this->hasMany(UserQueue::class);
	}

	public function roles()
	{
		return $this->belongsToMany(Role::class, 'user_roles')
					->withPivot('id', 'assigned_by', 'assigned_at', 'expires_at', 'is_primary');
	}

	public function user_subscriptions()
	{
		return $this->hasMany(UserSubscription::class);
	}

	public function user_taste_profile()
	{
		return $this->hasOne(UserTasteProfile::class);
	}

	
    public function getRoleFlags(): array
	{
		$allRoles = ['admin','boss','content_manager','partner','moderator','user_vip_yearly','user_vip_monthly','user_free'];
		$userRoles = $this->roles()->pluck('name')->toArray();

		$flags = [];
		foreach($allRoles as $role){
			$flags['is_'.$role] = in_array($role, $userRoles);
		}

		return $flags;
	}


}

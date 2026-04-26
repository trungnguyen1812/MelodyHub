<?php

/**
 * Created by Reliese Model.
 */
namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Facades\DB;


/**
 * Class User
 * 
 * @property int $id
 * @property string $name
 * @property string $slug
 * @property string $email
 * @property string|null $phone
 * @property string|null $username
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
 * @property float $wallet_balance
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
	use HasApiTokens, Notifiable;
	protected $table = 'users';
	protected $casts = [
		'phone_verified_at' => 'datetime',
		'date_of_birth' => 'datetime',
		'published_at' => 'datetime',
		'play_count_last_24h' => 'int',
		'play_count_last_7d' => 'int',
		'play_count_last_30d' => 'int',
		'trending_score' => 'float',
		'has_used_trial' => 'int',
		'is_vip' => 'bool',
		'vip_expires_at' => 'datetime',
		'wallet_balance' => 'decimal:2',
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
		'password',
		'avatar_url',
		'date_of_birth',
		'gender',
		'country',
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
		'vip_expires_at',
		'wallet_balance'
	];

	public function country()
	{
		return $this->belongsTo(Country::class, 'country');
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
		 return $this->belongsToMany(Role::class, 'user_roles', 'user_id', 'role_id')
            ->withPivot('is_primary', 'expires_at', 'assigned_by', 'assigned_at')
			->orderByDesc('user_roles.is_primary');
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

	public function assignRole(string $roleName)
	{
		$role = Role::where('name', $roleName)->first();
		if ($role) {
			$this->roles()->syncWithoutDetaching([$role->id]);
		}
	}

	public function scopeSearch($query , $q) {
		if (!$q) return $query;
		return $query->where(function ($sub) use ($q) {
			$sub->where	('name' , 'like', "%$q%")
            	->orWhere('email', 'like', "%$q%")
            	->orWhere('username', 'like', "%$q%"
			);
		});
	}

	public function subscriptions()
	{
		return $this->hasMany(UserSubscription::class);
	}

	public function activeSubscription()
	{
		return $this->hasOne(UserSubscription::class)
			->where('status', 'active')
			->where('ends_at', '>', now())
			->orderByDesc('ends_at');
	}

	public static function getUserStatistics()
	{
		$currentMonth = Carbon::now()->startOfMonth();
		$lastMonth = Carbon::now()->subMonth()->startOfMonth();
		$endOfLastMonth = $lastMonth->copy()->endOfMonth();
		$twoMonthsAgo = Carbon::now()->subMonths(2)->startOfMonth();
		$endOfTwoMonthsAgo = $twoMonthsAgo->copy()->endOfMonth();

		// Helper function để lấy thống kê với subquery (chính xác cho từng role)
		$getStats = function($dateCondition = null) {
			$query = DB::table('users as u')->whereNull('u.deleted_at');
			
			if ($dateCondition) {
				$query->where('u.created_at', '<=', $dateCondition);
			}
			
			return $query->selectRaw("
				COUNT(DISTINCT u.id) as total_users,
				COUNT(DISTINCT CASE 
					WHEN EXISTS (
						SELECT 1 FROM user_roles ur 
						JOIN roles r ON r.id = ur.role_id 
						WHERE ur.user_id = u.id AND r.name = 'user_free'
					) THEN u.id 
				END) as free_users,
				COUNT(DISTINCT CASE 
					WHEN EXISTS (
						SELECT 1 FROM user_roles ur 
						JOIN roles r ON r.id = ur.role_id 
						WHERE ur.user_id = u.id AND r.name = 'partner'
					) THEN u.id 
				END) as partners,
				COUNT(DISTINCT CASE 
					WHEN EXISTS (
						SELECT 1 FROM user_roles ur 
						JOIN roles r ON r.id = ur.role_id 
						WHERE ur.user_id = u.id AND r.name IN ('boss', 'admin')
					) THEN u.id 
				END) as admins,
				COUNT(DISTINCT CASE 
					WHEN EXISTS (
						SELECT 1 FROM user_roles ur 
						JOIN roles r ON r.id = ur.role_id 
						WHERE ur.user_id = u.id AND r.name IN ('user_vip_yearly', 'user_vip_monthly')
					) THEN u.id 
				END) as vip_users
			")->first();
		};

		// Helper function để lấy thống kê user mới trong khoảng thời gian
		$getNewUsersStats = function($startDate, $endDate = null) {
			$query = DB::table('users as u')->whereNull('u.deleted_at')
				->where('u.created_at', '>=', $startDate);
			
			if ($endDate) {
				$query->where('u.created_at', '<=', $endDate);
			}
			
			return $query->selectRaw("
				COUNT(DISTINCT u.id) as total_users,
				COUNT(DISTINCT CASE 
					WHEN EXISTS (
						SELECT 1 FROM user_roles ur 
						JOIN roles r ON r.id = ur.role_id 
						WHERE ur.user_id = u.id AND r.name = 'user_free'
					) THEN u.id 
				END) as free_users,
				COUNT(DISTINCT CASE 
					WHEN EXISTS (
						SELECT 1 FROM user_roles ur 
						JOIN roles r ON r.id = ur.role_id 
						WHERE ur.user_id = u.id AND r.name = 'partner'
					) THEN u.id 
				END) as partners,
				COUNT(DISTINCT CASE 
					WHEN EXISTS (
						SELECT 1 FROM user_roles ur 
						JOIN roles r ON r.id = ur.role_id 
						WHERE ur.user_id = u.id AND r.name IN ('boss', 'admin')
					) THEN u.id 
				END) as admins,
				COUNT(DISTINCT CASE 
					WHEN EXISTS (
						SELECT 1 FROM user_roles ur 
						JOIN roles r ON r.id = ur.role_id 
						WHERE ur.user_id = u.id AND r.name IN ('user_vip_yearly', 'user_vip_monthly')
					) THEN u.id 
				END) as vip_users
			")->first();
		};

		// Lấy thống kê
		$currentStats = $getStats();
		$lastMonthStats = $getStats($endOfLastMonth);
		$twoMonthsAgoStats = $getStats($endOfTwoMonthsAgo);
		
		$newUsersThisMonth = $getNewUsersStats($currentMonth);
		$newUsersLastMonth = $getNewUsersStats($lastMonth, $endOfLastMonth);

		// Helper function tính growth
		$calculateGrowth = function($current, $previous) {
			if ($previous == 0) {
				return $current > 0 ? 100 : 0;
			}
			return round((($current - $previous) / $previous) * 100, 2);
		};

		$stats = (object)[
			// Current counts
			'total_users' => $currentStats->total_users ?? 0,
			'free_users' => $currentStats->free_users ?? 0,
			'partners' => $currentStats->partners ?? 0,
			'admins' => $currentStats->admins ?? 0,
			'vip_users' => $currentStats->vip_users ?? 0,
			
			// Last month totals
			'total_users_last_month' => $lastMonthStats->total_users ?? 0,
			'free_users_last_month' => $lastMonthStats->free_users ?? 0,
			'partners_last_month' => $lastMonthStats->partners ?? 0,
			'admins_last_month' => $lastMonthStats->admins ?? 0,
			'vip_users_last_month' => $lastMonthStats->vip_users ?? 0,
			
			// GROWTH PERCENTAGES
			'total_growth_percentage' => $calculateGrowth(
				$currentStats->total_users ?? 0, 
				$lastMonthStats->total_users ?? 0
			),
			'free_growth_percentage' => $calculateGrowth(
				$currentStats->free_users ?? 0, 
				$lastMonthStats->free_users ?? 0
			),
			'partner_growth_percentage' => $calculateGrowth(
				$currentStats->partners ?? 0, 
				$lastMonthStats->partners ?? 0
			),
			'admin_growth_percentage' => $calculateGrowth(
				$currentStats->admins ?? 0, 
				$lastMonthStats->admins ?? 0
			),
			'vip_growth_percentage' => $calculateGrowth(
				$currentStats->vip_users ?? 0, 
				$lastMonthStats->vip_users ?? 0
			),
			
			// Growth trends
			'total_growth_trend' => ($currentStats->total_users ?? 0) >= ($lastMonthStats->total_users ?? 0) ? 'up' : 'down',
			'free_growth_trend' => ($currentStats->free_users ?? 0) >= ($lastMonthStats->free_users ?? 0) ? 'up' : 'down',
			'partner_growth_trend' => ($currentStats->partners ?? 0) >= ($lastMonthStats->partners ?? 0) ? 'up' : 'down',
			'admin_growth_trend' => ($currentStats->admins ?? 0) >= ($lastMonthStats->admins ?? 0) ? 'up' : 'down',
			'vip_growth_trend' => ($currentStats->vip_users ?? 0) >= ($lastMonthStats->vip_users ?? 0) ? 'up' : 'down',
			
			// New users this month
			'new_users_this_month' => $newUsersThisMonth->total_users ?? 0,
			'new_free_users_this_month' => $newUsersThisMonth->free_users ?? 0,
			'new_partners_this_month' => $newUsersThisMonth->partners ?? 0,
			'new_admins_this_month' => $newUsersThisMonth->admins ?? 0,
			'new_vip_users_this_month' => $newUsersThisMonth->vip_users ?? 0,
			
			// New users growth (so sánh với tháng trước)
			'new_users_growth_percentage' => $calculateGrowth(
				$newUsersThisMonth->total_users ?? 0,
				$newUsersLastMonth->total_users ?? 0
			),
			'new_partners_growth_percentage' => $calculateGrowth(
				$newUsersThisMonth->partners ?? 0,
				$newUsersLastMonth->partners ?? 0
			),
		];

		return response()->json($stats);
	}

	public static function getUserMonthlyStats()
    {
        $currentMonth = Carbon::now()->startOfMonth();
        $lastMonth = Carbon::now()->subMonth()->startOfMonth();
        
        // Thống kê tháng hiện tại
        $currentMonthStats = self::getUserStatsByMonth($currentMonth);
        
        // Thống kê tháng trước
        $lastMonthStats = self::getUserStatsByMonth($lastMonth);
        
        // Tính phần trăm thay đổi
        return [
            'current_month' => [
                'period' => $currentMonth->format('M Y'),
                'total_users' => $currentMonthStats->total_users ?? 0,
                'free_users' => $currentMonthStats->free_users ?? 0,
                'partners' => $currentMonthStats->partners ?? 0,
                'admins' => $currentMonthStats->admins ?? 0,
                'new_users' => $currentMonthStats->new_users ?? 0,
            ],
            'last_month' => [
                'period' => $lastMonth->format('M Y'),
                'total_users' => $lastMonthStats->total_users ?? 0,
                'free_users' => $lastMonthStats->free_users ?? 0,
                'partners' => $lastMonthStats->partners ?? 0,
                'admins' => $lastMonthStats->admins ?? 0,
                'new_users' => $lastMonthStats->new_users ?? 0,
            ],
            'growth' => [
                'total_users' => self::calculateGrowth(
                    $lastMonthStats->total_users ?? 0, 
                    $currentMonthStats->total_users ?? 0
                ),
                'free_users' => self::calculateGrowth(
                    $lastMonthStats->free_users ?? 0, 
                    $currentMonthStats->free_users ?? 0
                ),
                'partners' => self::calculateGrowth(
                    $lastMonthStats->partners ?? 0, 
                    $currentMonthStats->partners ?? 0
                ),
                'admins' => self::calculateGrowth(
                    $lastMonthStats->admins ?? 0, 
                    $currentMonthStats->admins ?? 0
                ),
                'new_users' => self::calculateGrowth(
                    $lastMonthStats->new_users ?? 0, 
                    $currentMonthStats->new_users ?? 0
                ),
            ]
        ];
    }

    /**
     * Lấy thống kê người dùng theo tháng cụ thể
     */
    private static function getUserStatsByMonth($month)
    {
        $startOfMonth = $month->copy()->startOfMonth();
        $endOfMonth = $month->copy()->endOfMonth();

        return DB::table('users as u')
            ->leftJoin('user_roles as ur', 'ur.user_id', '=', 'u.id')
            ->leftJoin('roles as r', 'r.id', '=', 'ur.role_id')
            ->whereNull('u.deleted_at')
            ->where('u.created_at', '<=', $endOfMonth)
            ->selectRaw("
                COUNT(DISTINCT u.id) as total_users,
                COUNT(DISTINCT CASE WHEN r.name = 'user_free' THEN u.id END) as free_users,
                COUNT(DISTINCT CASE WHEN r.name = 'partner' THEN u.id END) as partners,
                COUNT(DISTINCT CASE WHEN r.name IN ('boss','admin') THEN u.id END) as admins,
                COUNT(DISTINCT CASE WHEN u.created_at BETWEEN ? AND ? THEN u.id END) as new_users
            ", [$startOfMonth, $endOfMonth])
            ->first();
    }

    /**
     * Lấy thống kê 12 tháng gần nhất
     */
    public static function getUserYearlyStats()
    {
        $startDate = Carbon::now()->subMonths(11)->startOfMonth();
        $endDate = Carbon::now()->endOfMonth();

        $results = DB::table('users as u')
            ->leftJoin('user_roles as ur', 'ur.user_id', '=', 'u.id')
            ->leftJoin('roles as r', 'r.id', '=', 'ur.role_id')
            ->whereNull('u.deleted_at')
            ->where('u.created_at', '<=', $endDate)
            ->selectRaw("
                DATE_FORMAT(u.created_at, '%Y-%m') as month,
                COUNT(DISTINCT u.id) as total_users,
                COUNT(DISTINCT CASE WHEN r.name = 'user_free' THEN u.id END) as free_users,
                COUNT(DISTINCT CASE WHEN r.name = 'partner' THEN u.id END) as partners,
                COUNT(DISTINCT CASE WHEN r.name IN ('boss','admin') THEN u.id END) as admins,
                COUNT(DISTINCT CASE WHEN u.created_at >= DATE_FORMAT(u.created_at, '%Y-%m-01') THEN u.id END) as new_users
            ")
            ->where('u.created_at', '>=', $startDate)
            ->groupBy(DB::raw('DATE_FORMAT(u.created_at, "%Y-%m")'))
            ->orderBy('month', 'asc')
            ->get();

        // Điền các tháng thiếu
        $monthlyData = [];
        for ($i = 0; $i < 12; $i++) {
            $date = Carbon::now()->subMonths(11 - $i);
            $monthKey = $date->format('Y-m');
            $monthName = $date->format('M Y');
            
            $found = $results->firstWhere('month', $monthKey);
            
            $monthlyData[] = [
                'month' => $monthName,
                'month_key' => $monthKey,
                'total_users' => $found->total_users ?? 0,
                'free_users' => $found->free_users ?? 0,
                'partners' => $found->partners ?? 0,
                'admins' => $found->admins ?? 0,
                'new_users' => $found->new_users ?? 0,
            ];
        }

        return $monthlyData;
    }

    /**
     * Lấy thống kê theo trạng thái người dùng
     */
    public static function getUserStatusStats()
    {
        return DB::table('users')
            ->whereNull('deleted_at')
            ->selectRaw("
                COUNT(CASE WHEN status = 'active' THEN 1 END) as active_users,
                COUNT(CASE WHEN status = 'inactive' THEN 1 END) as inactive_users,
                COUNT(CASE WHEN status = 'banned' THEN 1 END) as banned_users,
                COUNT(CASE WHEN status = 'pending' THEN 1 END) as pending_users
            ")
            ->first();
    }

    /**
     * Tính phần trăm tăng/giảm
     */
    private static function calculateGrowth($previous, $current)
    {
        if ($previous == 0) {
            return $current > 0 ? 100 : 0;
        }
        
        $growth = (($current - $previous) / $previous) * 100;
        return round($growth, 2);
    }

    /**
     * Lấy tất cả thống kê trong một lần gọi
     */
    public static function getAllStatistics()
    {
        return [
            'overall' => self::getUserStatistics(),
            'monthly_comparison' => self::getUserMonthlyStats(),
            'yearly_trend' => self::getUserYearlyStats(),
            'status_stats' => self::getUserStatusStats(),
        ];
    }


}

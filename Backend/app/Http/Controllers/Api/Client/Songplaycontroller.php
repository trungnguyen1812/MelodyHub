<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\Song;
use App\Models\SongPlay;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Stevebauman\Location\Facades\Location;

class SongPlayController extends Controller
{
    // ─── Ngưỡng hợp lệ để tính 1 lượt play ──────────────────────────────────
    private const MIN_DURATION_SEC  = 30;    // nghe tối thiểu 30 giây
    private const MIN_PERCENTAGE    = 40.00; // hoặc 40% bài
    private const ANTI_SPAM_MINUTES = 5;     // cùng user + song trong 5 phút → bỏ qua

    /**
     * POST /api/songs/{song}/play
     *
     * Ghi nhận 1 lượt nghe. Frontend gọi sau khi đã nghe đủ ngưỡng.
     * Server validate lại để tránh gian lận.
     */
    public function record(Request $request, Song $song): JsonResponse
    {
        $data = $request->validate([
            'played_duration' => ['required', 'integer', 'min:0', 'max:86400'],
            'play_percentage'  => ['required', 'numeric', 'min:0', 'max:100'],
            'is_completed'     => ['boolean'],
            'playlist_id'      => ['nullable', 'integer', 'exists:playlists,id'],
        ]);

        // ── 1. Server-side validation: có đủ ngưỡng không? ──────────────────
        $passedDuration   = $data['played_duration'] >= self::MIN_DURATION_SEC;
        $passedPercentage = $data['play_percentage'] >= self::MIN_PERCENTAGE;

        if (!$passedDuration && !$passedPercentage) {
            return response()->json([
                'message' => 'Play duration does not meet the minimum threshold.',
            ], 422);
        }

        // ── 2. Lấy user_id chính xác ──────────────────────────────────────────
        $userId = null;
        $guard = 'sanctum'; // Hoặc 'api' tùy vào cấu hình của bạn
        
        if (Auth::guard($guard)->check()) {
            $userId = Auth::guard($guard)->id();
        } else {
            // Thử với guard mặc định
            if (Auth::check()) {
                $userId = Auth::id();
            }
        }
        
        $ipAddress = $request->ip();
        $userAgent = $request->userAgent();

        // ── 3. Anti-spam: cải thiện cho cả user và guest ──────────────────────
        $recentExists = SongPlay::where('song_id', $song->id)
            ->where('played_at', '>=', now()->subMinutes(self::ANTI_SPAM_MINUTES))
            ->where(function ($q) use ($userId, $ipAddress, $userAgent) {
                if ($userId) {
                    // Đã đăng nhập: check theo user_id
                    $q->where('user_id', $userId);
                } else {
                    // Guest: check theo IP + UserAgent + session_id (nếu có)
                    $q->whereNull('user_id')
                    ->where('ip_address', $ipAddress)
                    ->where('device_info', $userAgent); // Thêm check UserAgent
                    
                    // Optional: thêm session_id nếu có
                    if (session()->getId()) {
                        $q->where('session_id', session()->getId());
                    }
                }
            })
            ->exists();

        if ($recentExists) {
            return response()->json([
                'message'   => 'Play already recorded recently.',
                'recorded'  => false,
            ]);
        }

        // ── 4. Detect device & location ──────────────────────────────────────
        $deviceType = $this->detectDeviceType($request);
        $location   = $this->detectLocation($ipAddress);

        // ── 5. Ghi vào DB (thêm session_id cho guest) ─────────────────────────
        $playData = [
            'user_id'         => $userId,
            'song_id'         => $song->id,
            'playlist_id'     => $data['playlist_id'] ?? null,
            'played_duration' => $data['played_duration'],
            'play_percentage' => round($data['play_percentage'], 2),
            'is_completed'    => $data['is_completed'] ?? false,
            'played_at'       => now(),
            'device_type'     => $deviceType,
            'device_info'     => $userAgent,
            'ip_address'      => $ipAddress,
            'country'         => $location['country'],
            'city'            => $location['city'],
        ];
        
        // Thêm session_id cho guest để chống spam tốt hơn
        if (!$userId && session()->getId()) {
            $playData['session_id'] = session()->getId();
        }
        
        $play = SongPlay::create($playData);

        // ── 6. Cập nhật counter trên bảng songs ──────────────────────────────
        $song->increment('total_plays');

        return response()->json([
            'message'  => 'Play recorded successfully.',
            'recorded' => true,
            'play_id'  => $play->id,
        ], 201);
    }

    /**
     * GET /api/songs/{song}/plays
     *
     * Thống kê lượt play của 1 bài (dành cho artist dashboard).
     * Require: auth + owner hoặc admin.
     */
    // public function stats(Request $request, Song $song): JsonResponse
    // {
    //     // Chỉ artist sở hữu bài hoặc admin mới xem được
    //     $this->authorize('viewPlays', $song);

    //     $period = $request->query('period', '7d'); // 7d | 30d | 90d | all
    //     $from   = match ($period) {
    //         '30d'  => now()->subDays(30),
    //         '90d'  => now()->subDays(90),
    //         'all'  => null,
    //         default => now()->subDays(7),   // 7d
    //     };

    //     $query = SongPlay::where('song_id', $song->id);
    //     if ($from) {
    //         $query->where('played_at', '>=', $from);
    //     }

    //     $total      = $query->count();
    //     $completed  = (clone $query)->where('is_completed', true)->count();
    //     $unique     = (clone $query)->distinct('user_id')->count('user_id');
    //     $avgDur     = (clone $query)->avg('played_duration');
    //     $avgPct     = (clone $query)->avg('play_percentage');

    //     // Plays theo ngày (cho chart)
    //     $byDay = (clone $query)
    //         ->selectRaw('DATE(played_at) as date, COUNT(*) as plays')
    //         ->groupBy('date')
    //         ->orderBy('date')
    //         ->get();

    //     // Top devices
    //     $byDevice = (clone $query)
    //         ->selectRaw('device_type, COUNT(*) as count')
    //         ->whereNotNull('device_type')
    //         ->groupBy('device_type')
    //         ->orderByDesc('count')
    //         ->get();

    //     // Top countries
    //     $byCountry = (clone $query)
    //         ->selectRaw('country, COUNT(*) as count')
    //         ->whereNotNull('country')
    //         ->groupBy('country')
    //         ->orderByDesc('count')
    //         ->limit(10)
    //         ->get();

    //     return response()->json([
    //         'song_id'          => $song->id,
    //         'period'           => $period,
    //         'total_plays'      => $total,
    //         'unique_listeners' => $unique,
    //         'completed_plays'  => $completed,
    //         'completion_rate'  => $total > 0 ? round($completed / $total * 100, 1) : 0,
    //         'avg_duration_sec' => round($avgDur ?? 0),
    //         'avg_percentage'   => round($avgPct ?? 0, 1),
    //         'by_day'           => $byDay,
    //         'by_device'        => $byDevice,
    //         'by_country'       => $byCountry,
    //     ]);
    // }

    /**
     * GET /api/me/history
     *
     * Lịch sử nghe của user hiện tại (require auth).
     */
    public function history(Request $request): JsonResponse
    {
        $plays = SongPlay::with(['song:id,title,cover_url,artist_id', 'song.artist:id,name'])
            ->where('user_id', Auth::id())
            ->orderByDesc('played_at')
            ->paginate($request->query('per_page', 20));

        return response()->json($plays);
    }

    // ─── Private helpers ──────────────────────────────────────────────────────

    /**
     * Detect device type từ User-Agent.
     * Trả về enum value khớp với cột device_type.
     */
    private function detectDeviceType(Request $request): string
    {
        $ua = strtolower($request->userAgent() ?? '');

        return match (true) {
            str_contains($ua, 'mobile') || str_contains($ua, 'android')
                => 'mobile',
            str_contains($ua, 'tablet') || str_contains($ua, 'ipad')
                => 'tablet',
            str_contains($ua, 'electron') || str_contains($ua, 'tauri')
                => 'desktop',
            default => 'web',
        };
    }

    /**
     * Lấy country + city từ IP.
     * Dùng package stevebauman/location (gọi API ip-api.com hoặc ipinfo.io).
     * Nếu không có package → trả null.
     */
    private function detectLocation(string $ip): array
    {
        // Bỏ qua localhost / private IP
        if (in_array($ip, ['127.0.0.1', '::1']) || !filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE)) {
            return ['country' => null, 'city' => null];
        }

        try {
            // stevebauman/location: composer require stevebauman/location
            $position = Location::get($ip);
            return [
                'country' => $position?->countryName,
                'city'    => $position?->cityName,
            ];
        } catch (\Throwable) {
            return ['country' => null, 'city' => null];
        }
    }
}
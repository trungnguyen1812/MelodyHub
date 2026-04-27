<?php
namespace App\Http\Controllers\Api\admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use App\Models\User;
use App\Models\Partner;
use App\Models\Song;
use App\Models\Artist;
use App\Models\Album;
use Carbon\Carbon;

class AdminController extends Controller
{
    public function dashboard(Request $request)
    {
        /** @var \App\Models\User $user */
        $user = $request->user() ?? \App\Models\User::find($request->input('admin_user.user_id'));

        if (!$user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $now        = Carbon::now();
        $thisMonth  = $now->copy()->startOfMonth();
        $lastMonth  = $now->copy()->subMonth()->startOfMonth();
        $lastMonthEnd = $now->copy()->subMonth()->endOfMonth();

        // ── Users ────────────────────────────────────────────────────────────
        $totalUsers     = User::count();
        $newUsersMonth  = User::where('created_at', '>=', $thisMonth)->count();
        $newUsersLast   = User::whereBetween('created_at', [$lastMonth, $lastMonthEnd])->count();
        $userGrowth     = $newUsersLast > 0
            ? round((($newUsersMonth - $newUsersLast) / $newUsersLast) * 100, 1)
            : ($newUsersMonth > 0 ? 100 : 0);

        // ── Partners ─────────────────────────────────────────────────────────
        $totalPartners   = Partner::count();
        $activePartners  = Partner::where('status', 'active')->count();
        $pendingPartners = Partner::where('status', 'pending')->count();

        // ── Content ──────────────────────────────────────────────────────────
        $totalSongs   = Song::count();
        $totalArtists = Artist::count();
        $totalAlbums  = Album::count();

        // ── Revenue (from payments table) ────────────────────────────────────
        $revenueThisMonth = 0;
        $revenueLastMonth = 0;
        $revenueTotal     = 0;
        try {
            $revenueThisMonth = (float) DB::table('payments')
                ->where('status', 'completed')
                ->where('created_at', '>=', $thisMonth)
                ->sum('amount');

            $revenueLastMonth = (float) DB::table('payments')
                ->where('status', 'completed')
                ->whereBetween('created_at', [$lastMonth, $lastMonthEnd])
                ->sum('amount');

            $revenueTotal = (float) DB::table('payments')
                ->where('status', 'completed')
                ->sum('amount');
        } catch (\Exception $e) {
            // payments table may not exist yet
        }

        $revenueGrowth = $revenueLastMonth > 0
            ? round((($revenueThisMonth - $revenueLastMonth) / $revenueLastMonth) * 100, 1)
            : ($revenueThisMonth > 0 ? 100 : 0);

        // ── Monthly user registrations (last 6 months) ───────────────────────
        $userTrend = [];
        for ($i = 5; $i >= 0; $i--) {
            $month = $now->copy()->subMonths($i);
            $userTrend[] = [
                'month' => $month->format('M'),
                'count' => User::whereYear('created_at', $month->year)
                               ->whereMonth('created_at', $month->month)
                               ->count(),
            ];
        }

        // ── Monthly revenue (last 6 months) ──────────────────────────────────
        $revenueTrend = [];
        try {
            for ($i = 5; $i >= 0; $i--) {
                $month = $now->copy()->subMonths($i);
                $revenueTrend[] = [
                    'month'  => $month->format('M'),
                    'amount' => (float) DB::table('payments')
                        ->where('status', 'completed')
                        ->whereYear('created_at', $month->year)
                        ->whereMonth('created_at', $month->month)
                        ->sum('amount'),
                ];
            }
        } catch (\Exception $e) {
            for ($i = 5; $i >= 0; $i--) {
                $revenueTrend[] = ['month' => $now->copy()->subMonths($i)->format('M'), 'amount' => 0];
            }
        }

        // ── Recent users ─────────────────────────────────────────────────────
        $recentUsers = User::orderByDesc('created_at')
            ->limit(5)
            ->get(['id', 'name', 'email', 'created_at', 'status'])
            ->map(fn($u) => [
                'id'         => $u->id,
                'name'       => $u->name,
                'email'      => $u->email,
                'status'     => $u->status,
                'created_at' => $u->created_at,
            ]);

        // ── Recent partners ──────────────────────────────────────────────────
        $recentPartners = Partner::with('partnerType')
            ->orderByDesc('created_at')
            ->limit(5)
            ->get(['id', 'company_name', 'status', 'created_at', 'partner_type_id'])
            ->map(fn($p) => [
                'id'           => $p->id,
                'company_name' => $p->company_name,
                'status'       => $p->status,
                'type'         => $p->partnerType?->name,
                'created_at'   => $p->created_at,
            ]);

        return response()->json([
            'user' => [
                'id'    => $user->id,
                'name'  => $user->name,
                'email' => $user->email,
                'role'  => $user->getRoleFlags(),
            ],
            'stats' => [
                'total_users'      => $totalUsers,
                'new_users_month'  => $newUsersMonth,
                'user_growth'      => $userGrowth,

                'total_partners'   => $totalPartners,
                'active_partners'  => $activePartners,
                'pending_partners' => $pendingPartners,

                'total_songs'      => $totalSongs,
                'total_artists'    => $totalArtists,
                'total_albums'     => $totalAlbums,

                'revenue_total'      => $revenueTotal,
                'revenue_this_month' => $revenueThisMonth,
                'revenue_last_month' => $revenueLastMonth,
                'revenue_growth'     => $revenueGrowth,
            ],
            'user_trend'     => $userTrend,
            'revenue_trend'  => $revenueTrend,
            'recent_users'   => $recentUsers,
            'recent_partners'=> $recentPartners,
        ]);
    }
}

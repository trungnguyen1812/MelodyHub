<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\AdTracking;
use App\Models\Advertisement;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;

class ClientAdImpressionController extends Controller
{
    /**
     * Track ad events
     */
    public function track(Request $request, $adId)
    {
        try {
            $validated = $request->validate([
                'event_type' => 'required|string|in:impression,click,dismiss,skip,complete',
                'timestamp'  => 'nullable|string'
            ]);

            $ad = Advertisement::find($adId);

            if (!$ad) {
                return response()->json([
                    'message' => 'Ad not found'
                ], 404);
            }

            // Lưu vào bảng ad_tracking
            $tracking = AdTracking::create([
                'ad_id'      => $adId,
                'user_id' => $request->user()?->id,
                'event_type' => $validated['event_type'],
                'session_id' => $request->header('X-Session-Id') 
                                ?? $request->cookie('laravel_session')
                                ?? null,
                'ip_address' => $request->ip(),
                'user_agent' => $request->userAgent(),
                'referrer'   => $request->header('referer'),
                'tracked_at' => $validated['timestamp'] ?? now(),
            ]);

            // Update counters
            match ($validated['event_type']) {
                'impression' => [
                    $ad->increment('total_impressions'),
                    $ad->increment('budget_spent', $ad->cost_per_play),
                    $ad->increment('total_revenue', $ad->cost_per_play),
                ],

                'click' => [
                    $ad->increment('total_clicks'),
                    $ad->increment('budget_spent', $ad->cost_per_click),
                    $ad->increment('total_revenue', $ad->cost_per_click),
                ],

                'complete' => [
                    $ad->increment('total_plays'),
                ],

                'skip' => [
                    $ad->increment('total_skips'),
                ],

                default => null,
            };

            Log::channel('ad_tracking')->info('Ad tracked', [
                'ad_id'      => $adId,
                'ad_name'    => $ad->name,
                'event_type' => $validated['event_type'],
                'user_id'    => $request->user()?->id,
                'ip'         => $request->ip(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Tracked successfully',
                'data'    => $tracking
            ]);

        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors'  => $e->errors()
            ], 422);

        } catch (\Exception $e) {
            Log::error('Tracking failed: ' . $e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Tracking failed'
            ], 200);
        }
    }

    /**
     * Get statistics
     */
    public function statistics(Request $request, $adId)
    {
        try {
            $ad = Advertisement::find($adId);

            if (!$ad) {
                return response()->json([
                    'message' => 'Ad not found'
                ], 404);
            }

            $startDate = $request->get('start_date', now()->subDays(30));
            $endDate   = $request->get('end_date', now());

            $baseQuery = AdTracking::where('ad_id', $adId)
                ->whereBetween('tracked_at', [$startDate, $endDate]);

            $stats = [
                'total_impressions' => (clone $baseQuery)
                    ->where('event_type', 'impression')
                    ->count(),

                'total_clicks' => (clone $baseQuery)
                    ->where('event_type', 'click')
                    ->count(),

                'total_plays' => (clone $baseQuery)
                    ->where('event_type', 'complete')
                    ->count(),

                'total_skips' => (clone $baseQuery)
                    ->where('event_type', 'skip')
                    ->count(),

                'total_dismiss' => (clone $baseQuery)
                    ->where('event_type', 'dismiss')
                    ->count(),

                'unique_users' => (clone $baseQuery)
                    ->whereNotNull('user_id')
                    ->distinct('user_id')
                    ->count('user_id'),

                'unique_ips' => (clone $baseQuery)
                    ->distinct('ip_address')
                    ->count('ip_address'),

                'ctr' => 0,
                'completion_rate' => 0
            ];

            // CTR
            if ($stats['total_impressions'] > 0) {
                $stats['ctr'] = round(
                    ($stats['total_clicks'] / $stats['total_impressions']) * 100,
                    2
                );

                $stats['completion_rate'] = round(
                    ($stats['total_plays'] / $stats['total_impressions']) * 100,
                    2
                );
            }

            $dailyStats = AdTracking::where('ad_id', $adId)
                ->whereBetween('tracked_at', [$startDate, $endDate])
                ->select(
                    DB::raw('DATE(tracked_at) as date'),
                    DB::raw("SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) as impressions"),
                    DB::raw("SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) as clicks"),
                    DB::raw("SUM(CASE WHEN event_type = 'complete' THEN 1 ELSE 0 END) as plays"),
                    DB::raw("SUM(CASE WHEN event_type = 'skip' THEN 1 ELSE 0 END) as skips")
                )
                ->groupBy(DB::raw('DATE(tracked_at)'))
                ->orderBy('date', 'DESC')
                ->get();

            return response()->json([
                'success' => true,
                'data' => [
                    'ad' => [
                        'id' => $ad->id,
                        'name' => $ad->name,
                        'type' => $ad->type,
                        'total_impressions' => $ad->total_impressions,
                        'total_clicks' => $ad->total_clicks,
                        'total_plays' => $ad->total_plays,
                        'total_skips' => $ad->total_skips,
                        'ctr' => $ad->total_impressions > 0
                            ? round(($ad->total_clicks / $ad->total_impressions) * 100, 2)
                            : 0
                    ],
                    'statistics' => $stats,
                    'daily_breakdown' => $dailyStats,
                    'period' => [
                        'start_date' => $startDate,
                        'end_date' => $endDate
                    ]
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Failed to get statistics: ' . $e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Failed to get statistics'
            ], 500);
        }
    }

    /**
     * Fraud detection
     */
    public function fraudDetection(Request $request, $adId)
    {
        try {
            $baseClickQuery = AdTracking::where('ad_id', $adId)
                ->where('event_type', 'click');

            $suspiciousIPs = (clone $baseClickQuery)
                ->select('ip_address', DB::raw('COUNT(*) as click_count'))
                ->groupBy('ip_address')
                ->having('click_count', '>', 10)
                ->get();

            $suspiciousUsers = (clone $baseClickQuery)
                ->whereNotNull('user_id')
                ->select('user_id', DB::raw('COUNT(*) as click_count'))
                ->groupBy('user_id')
                ->having('click_count', '>', 20)
                ->get();

            $suspiciousImpressionIPs = AdTracking::where('ad_id', $adId)
                ->where('event_type', 'impression')
                ->select('ip_address', DB::raw('COUNT(*) as impression_count'))
                ->groupBy('ip_address')
                ->having('impression_count', '>', 50)
                ->get();

            return response()->json([
                'success' => true,
                'data' => [
                    'suspicious_clicks' => [
                        'ips' => $suspiciousIPs,
                        'users' => $suspiciousUsers
                    ],
                    'suspicious_impressions' => [
                        'ips' => $suspiciousImpressionIPs
                    ],
                    'summary' => [
                        'total_clicks' => AdTracking::where('ad_id', $adId)
                            ->where('event_type', 'click')
                            ->count(),

                        'total_impressions' => AdTracking::where('ad_id', $adId)
                            ->where('event_type', 'impression')
                            ->count(),

                        'unique_ips' => AdTracking::where('ad_id', $adId)
                            ->distinct('ip_address')
                            ->count('ip_address'),

                        'unique_users' => AdTracking::where('ad_id', $adId)
                            ->whereNotNull('user_id')
                            ->distinct('user_id')
                            ->count('user_id'),
                    ]
                ]
            ]);

        } catch (\Exception $e) {
            Log::error('Failed to detect fraud: ' . $e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Failed to detect fraud'
            ], 500);
        }
    }
}
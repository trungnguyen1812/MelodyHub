<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Advertisement;
use App\Models\Partner;
use Cloudinary\Cloudinary;
use Cloudinary\Configuration\Configuration;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\DB;

class AdvertisingManagerController extends Controller
{
    protected Cloudinary $cloudinary;

    public function __construct()
    {
        $this->cloudinary = new Cloudinary(
            new Configuration([
                'cloud' => [
                    'cloud_name' => config('cloudinary.cloud_name'),
                    'api_key'    => config('cloudinary.api_key'),
                    'api_secret' => config('cloudinary.api_secret'),
                ],
                'url' => [
                    'secure' => true,
                ],
            ])
        );
    }

    /**
     * Get advertisements for the current partner.
     */
    public function index(Request $request)
    {
        $user = $request->user();
        $partner = Partner::where('user_id', $user->id)->first();

        if (!$partner) {
            return response()->json(['message' => 'Partner profile not found'], 404);
        }

        $ads = Advertisement::where('partner_id', $partner->id)
            ->latest()
            ->get();

        return response()->json($ads);
    }

    /**
     * Toggle the status of an advertisement.
     */
    public function toggleStatus(Request $request, Advertisement $advertisement)
    {
        $user = $request->user();
        $partner = Partner::where('user_id', $user->id)->first();

        if (!$partner || $advertisement->partner_id !== $partner->id) {
            return response()->json(['message' => 'Unauthorized to update this campaign'], 403);
        }

        try {
            $newStatus = $advertisement->status === 'active' ? 'paused' : 'active';
            
            // Basic validation: if resuming, ensure wallet balance isn't zero? 
            // (Optional, budget check usually happens at play time)
            
            $advertisement->status = $newStatus;
            $advertisement->save();

            return response()->json([
                'message' => 'Campaign status updated',
                'status' => $newStatus
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Error updating status', 'error' => $e->getMessage()], 500);
        }
    }

    
    public function show(Request $request, $id)
    {
        $user = $request->user();
        $partner = Partner::where('user_id', $user->id)->first();

        if (!$partner) {
            return response()->json(['message' => 'Partner profile not found'], 404);
        }

        try {
            $ad = Advertisement::where('id', $id)
                ->where('partner_id', $partner->id)
                ->first();

            if (!$ad) {
                return response()->json(['message' => 'Advertisement not found or unauthorized'], 404);
            }

            // Tính toán các thống kê bổ sung
            $budgetRemaining  = $ad->budget_total - $ad->budget_spent;
            $budgetUsedPercent = $ad->budget_total > 0
                ? round(($ad->budget_spent / $ad->budget_total) * 100, 2)
                : 0;

            // Tính số ngày còn lại
            $daysRemaining = null;
            if ($ad->end_date) {
                $daysRemaining = now()->startOfDay()->diffInDays(
                    \Carbon\Carbon::parse($ad->end_date)->startOfDay(),
                    false // false = có thể trả về số âm nếu đã hết hạn
                );
            }

            return response()->json([
                'message' => 'Advertisement detail retrieved successfully',
                'data'    => [
                    // Thông tin cơ bản
                    'id'                         => $ad->id,
                    'name'                       => $ad->name,
                    'type'                       => $ad->type,
                    'status'                     => $ad->status,

                    // Thông tin advertiser
                    'advertiser_name'            => $ad->advertiser_name,
                    'advertiser_url'             => $ad->advertiser_url,

                    // Media
                    'media_url'                  => $ad->media_url,
                    'thumbnail_url'              => $ad->thumbnail_url,
                    'click_url'                  => $ad->click_url,
                    'duration'                   => $ad->duration,       // giây
                    'file_size'                  => $ad->file_size,      // bytes
                    'file_size_readable'         => $ad->file_size
                        ? $this->formatFileSize($ad->file_size)
                        : null,

                    // Budget & Chi phí
                    'budget'                     => [
                        'total'            => $ad->budget_total,
                        'spent'            => $ad->budget_spent,
                        'remaining'        => $budgetRemaining,
                        'used_percent'     => $budgetUsedPercent . '%',
                    ],
                    'cost_per_play'              => $ad->cost_per_play,
                    'cost_per_click'             => $ad->cost_per_click,

                    // Giới hạn & Ưu tiên
                    'max_plays_per_user_per_day' => $ad->max_plays_per_user_per_day,
                    'frequency_cap'              => $ad->frequency_cap,
                    'priority'                   => $ad->priority,

                    // Thời gian chạy
                    'schedule'                   => [
                        'start_date'    => $ad->start_date,
                        'end_date'      => $ad->end_date,
                        'days_remaining'=> $daysRemaining,
                        'is_expired'    => $daysRemaining !== null && $daysRemaining < 0,
                    ],

                    // Targeting
                    'targeting'                  => [
                        'age_min'   => $ad->target_age_min,
                        'age_max'   => $ad->target_age_max,
                        'gender'    => $ad->target_gender,
                        'location'  => $ad->target_location,
                        'genres'    => $ad->target_genres,
                    ],

                    // Timestamps
                    'created_at'                 => $ad->created_at->toDateTimeString(),
                    'updated_at'                 => $ad->updated_at->toDateTimeString(),
                ],
            ], 200);

        } catch (\Exception $e) {
            Log::error('Ad show failed: ' . $e->getMessage());
            return response()->json([
                'message' => 'Internal server error',
                'error'   => $e->getMessage(),
            ], 500);
        }
    }

    // -------------------------------------------------------
    // Helper: Format file size sang dạng đọc được
    // -------------------------------------------------------
    private function formatFileSize(int $bytes): string
    {
        if ($bytes >= 1073741824) {
            return round($bytes / 1073741824, 2) . ' GB';
        } elseif ($bytes >= 1048576) {
            return round($bytes / 1048576, 2) . ' MB';
        } elseif ($bytes >= 1024) {
            return round($bytes / 1024, 2) . ' KB';
        }
        return $bytes . ' B';
    }
}

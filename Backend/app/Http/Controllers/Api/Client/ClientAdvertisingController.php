<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\Advertisement;
use App\Models\Partner;
use Cloudinary\Cloudinary;
use Cloudinary\Configuration\Configuration;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\DB;

class ClientAdvertisingController extends Controller
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
     * Store a new advertisement.
     */
    public function store(Request $request)
    {
        $user = $request->user();
        $partner = Partner::where('user_id', $user->id)->first();

        if (!$partner) {
            return response()->json(['message' => 'Partner profile not found'], 404);
        }

        try {
            $validated = $request->validate([
                'name'               => 'required|string|max:255',
                'type'               => 'required|in:audio,banner,video,sponsored_content',
                'advertiser_name'    => 'required|string|max:255',
                'advertiser_url'     => 'nullable|url',
                'click_url'          => 'required|url',
                'budget_total'       => 'required|numeric|min:1',
                'cost_per_play'      => 'nullable|numeric|min:0.0001',
                'cost_per_click'     => 'nullable|numeric|min:0.0001',
                'start_date'         => 'required|date',
                'end_date'           => 'nullable|date|after_or_equal:start_date',
                'max_plays_per_user_per_day' => 'nullable|integer|min:1',
                'frequency_cap'      => 'nullable|integer|min:1',
                'priority'           => 'nullable|integer|min:0',
                
                // Targeting
                'target_age_min'     => 'nullable|integer|min:1',
                'target_age_max'     => 'nullable|integer|max:100',
                'target_gender'      => 'nullable|string|in:all,male,female',
                'target_location'    => 'nullable|array',
                'target_genres'      => 'nullable|array',

                // Files
                'thumbnail'          => 'nullable|image|max:5120', // 5MB
                'media_file'         => 'nullable|file|max:51200', // 50MB
                'media_url'          => 'nullable|url'
            ]);

            // Handle Thumbnail Upload
            $thumbnailUrl = null;
            if ($request->hasFile('thumbnail')) {
                $file = $request->file('thumbnail');
                $uploaded = $this->cloudinary->uploadApi()->upload($file->getRealPath(), [
                    'folder' => 'ads/thumbnails',
                ]);
                $thumbnailUrl = $uploaded['secure_url'];
            }

            // Handle Media Upload (if provided instead of URL)
            $mediaUrl = $request->media_url;
            $fileSize = null;
            $duration = $request->input('duration'); // Expecting duration if detectible frontend-side

            if ($request->hasFile('media_file')) {
                $file = $request->file('media_file');
                $resourceType = $validated['type'] === 'video' ? 'video' : ($validated['type'] === 'audio' ? 'video' : 'auto');
                
                $uploaded = $this->cloudinary->uploadApi()->upload($file->getRealPath(), [
                    'folder'        => 'ads/media',
                    'resource_type' => $resourceType
                ]);
                
                $mediaUrl = $uploaded['secure_url'];
                $fileSize = $uploaded['bytes'] ?? $file->getSize();
                if (isset($uploaded['duration'])) {
                    $duration = (int)$uploaded['duration'];
                }
            }

            // Verify wallet balance
            if ($user->wallet_balance < $validated['budget_total']) {
                return response()->json([
                    'message' => 'Insufficient wallet balance',
                    'errors' => ['budget_total' => ['Insufficient funds in your wallet.']]
                ], 422);
            }
            $user->wallet_balance -= $validated['budget_total'];
            $user->save();

            $ad = Advertisement::create([
                'partner_id'      => $partner->id,
                'name'            => $validated['name'],
                'type'            => $validated['type'],
                'advertiser_name' => $validated['advertiser_name'],
                'advertiser_url'  => $validated['advertiser_url'],
                'media_url'       => $mediaUrl,
                'thumbnail_url'   => $thumbnailUrl,
                'click_url'       => $validated['click_url'],
                'duration'        => $duration,
                'file_size'       => $fileSize,
                'budget_total'    => $validated['budget_total'],
                'budget_spent'    => 0,
                'cost_per_play'   => $validated['cost_per_play'] ?? 0.002,
                'cost_per_click'  => $validated['cost_per_click'] ?? 0.005,
                'max_plays_per_user_per_day' => $validated['max_plays_per_user_per_day'] ?? 3,
                'frequency_cap'   => $validated['frequency_cap'] ?? 5,
                'priority'        => $validated['priority'] ?? 0,
                'start_date'      => $validated['start_date'],
                'end_date'        => $validated['end_date'],
                'target_age_min'  => $validated['target_age_min']?? null,
                'target_age_max'  => $validated['target_age_max']?? null,
                'target_gender'   => $validated['target_gender'] ?? 'all',
                'target_location' => $validated['target_location'],
                'target_genres'   => $validated['target_genres'] ?? null,
                'status'          => 'pending', // Requires admin approval or start date
            ]);

            return response()->json([
                'message' => 'Advertisement campaign created successfully',
                'data'    => $ad
            ], 201);

        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validation failed',
                'errors'  => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            Log::error('Ad creation failed: ' . $e->getMessage());
            return response()->json([
                'message' => 'Internal server error during ad creation',
                'error'   => $e->getMessage()
            ], 500);
        }
    }


    /**
     * Delete an advertisement.
     */
    public function destroy(Request $request, Advertisement $advertisement)
    {
        $user = $request->user();
        $partner = Partner::where('user_id', $user->id)->first();

        if (!$partner || $advertisement->partner_id !== $partner->id) {
            return response()->json(['message' => 'Unauthorized to delete this campaign'], 403);
        }

        try {
            $advertisement->delete();
            return response()->json(['message' => 'Campaign deleted successfully']);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Error deleting campaign', 'error' => $e->getMessage()], 500);
        }
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

    /**
     * Update an advertisement.
     */
    public function update(Request $request, $id)
    {
        $user = $request->user();
        $partner = Partner::where('user_id', $user->id)->first();

        if (!$partner) {
            return response()->json(['message' => 'Partner profile not found'], 404);
        }

        $ad = Advertisement::where('id', $id)
            ->where('partner_id', $partner->id)
            ->first();

        if (!$ad) {
            return response()->json(['message' => 'Advertisement not found or unauthorized'], 404);
        }

        if (!in_array($ad->status, ['pending', 'paused', 'rejected'])) {
            return response()->json([
                'message' => 'Advertisement cannot be updated in its current status',
                'current_status' => $ad->status
            ], 403);
        }

        try {
            $validated = $request->validate([
                'name'               => 'sometimes|string|max:255',
                'type'               => 'sometimes|in:audio,banner,video,sponsored_content',
                'advertiser_name'    => 'sometimes|string|max:255',
                'advertiser_url'     => 'nullable|url',
                'click_url'          => 'sometimes|url',
                'budget_total'       => 'sometimes|numeric|min:1',
                'cost_per_play'      => 'nullable|numeric|min:0.0001',
                'cost_per_click'     => 'nullable|numeric|min:0.0001',
                'start_date'         => 'sometimes|date',
                'end_date'           => 'nullable|date|after_or_equal:start_date',
                'max_plays_per_user_per_day' => 'nullable|integer|min:1',
                'frequency_cap'      => 'nullable|integer|min:1',
                'priority'           => 'nullable|integer|min:0',

                // Targeting
                'target_age_min'     => 'nullable|integer|min:1',
                'target_age_max'     => 'nullable|integer|max:100',
                'target_gender'      => 'nullable|string|in:all,male,female',
                'target_location'    => 'nullable|array',
                'target_genres'      => 'nullable|array',

                // Files
                'thumbnail'          => 'nullable|image|max:5120',   // 5MB
                'media_file'         => 'nullable|file|max:51200',   // 50MB
                'media_url'          => 'nullable|url'
            ]);

            // -------------------------------------------------------
            // Xử lý thay đổi budget
            // -------------------------------------------------------
            if (isset($validated['budget_total'])) {
                $oldBudget      = $ad->budget_total;
                $newBudget      = $validated['budget_total'];
                $budgetDiff     = $newBudget - $oldBudget;   // dương = tăng, âm = giảm

                if ($budgetDiff > 0) {
                    // Tăng budget → trừ thêm ví
                    if ($user->wallet_balance < $budgetDiff) {
                        return response()->json([
                            'message' => 'Insufficient wallet balance',
                            'errors'  => ['budget_total' => ['Insufficient funds in your wallet.']]
                        ], 422);
                    }
                    $user->wallet_balance -= $budgetDiff;
                } elseif ($budgetDiff < 0) {
                    // Giảm budget → hoàn tiền vào ví
                    // Không cho phép giảm dưới mức đã tiêu
                    if ($newBudget < $ad->budget_spent) {
                        return response()->json([
                            'message' => 'New budget cannot be less than the amount already spent',
                            'errors'  => ['budget_total' => ['Budget cannot be lower than budget already spent: ' . $ad->budget_spent]]
                        ], 422);
                    }
                    $user->wallet_balance += abs($budgetDiff);
                }

                $user->save();
            }

            // -------------------------------------------------------
            // Xử lý Thumbnail Upload
            // -------------------------------------------------------
            $thumbnailUrl = $ad->thumbnail_url; // Giữ nguyên nếu không upload mới
            if ($request->hasFile('thumbnail')) {
                $file     = $request->file('thumbnail');
                $uploaded = $this->cloudinary->uploadApi()->upload($file->getRealPath(), [
                    'folder' => 'ads/thumbnails',
                ]);
                $thumbnailUrl = $uploaded['secure_url'];
            }

            // -------------------------------------------------------
            // Xử lý Media Upload
            // -------------------------------------------------------
            $mediaUrl = $request->has('media_url') ? $request->media_url : $ad->media_url;
            $fileSize = $ad->file_size;
            $duration = $request->input('duration', $ad->duration);

            if ($request->hasFile('media_file')) {
                $file         = $request->file('media_file');
                $resourceType = in_array($validated['type'] ?? $ad->type, ['video', 'audio']) ? 'video' : 'auto';

                $uploaded = $this->cloudinary->uploadApi()->upload($file->getRealPath(), [
                    'folder'        => 'ads/media',
                    'resource_type' => $resourceType,
                ]);

                $mediaUrl = $uploaded['secure_url'];
                $fileSize = $uploaded['bytes'] ?? $file->getSize();
                if (isset($uploaded['duration'])) {
                    $duration = (int) $uploaded['duration'];
                }
            }

            // -------------------------------------------------------
            // Cập nhật Advertisement
            // -------------------------------------------------------
            $ad->update([
                'name'            => $validated['name']            ?? $ad->name,
                'type'            => $validated['type']            ?? $ad->type,
                'advertiser_name' => $validated['advertiser_name'] ?? $ad->advertiser_name,
                'advertiser_url'  => $validated['advertiser_url']  ?? $ad->advertiser_url,
                'media_url'       => $mediaUrl,
                'thumbnail_url'   => $thumbnailUrl,
                'click_url'       => $validated['click_url']       ?? $ad->click_url,
                'duration'        => $duration,
                'file_size'       => $fileSize,
                'budget_total'    => $validated['budget_total']    ?? $ad->budget_total,
                'cost_per_play'   => $validated['cost_per_play']   ?? $ad->cost_per_play,
                'cost_per_click'  => $validated['cost_per_click']  ?? $ad->cost_per_click,
                'max_plays_per_user_per_day' => $validated['max_plays_per_user_per_day'] ?? $ad->max_plays_per_user_per_day,
                'frequency_cap'   => $validated['frequency_cap']   ?? $ad->frequency_cap,
                'priority'        => $validated['priority']        ?? $ad->priority,
                'start_date'      => $validated['start_date']      ?? $ad->start_date,
                'end_date'        => $validated['end_date']        ?? $ad->end_date,
                'target_age_min'  => $validated['target_age_min']  ?? $ad->target_age_min,
                'target_age_max'  => $validated['target_age_max']  ?? $ad->target_age_max,
                'target_gender'   => $validated['target_gender']   ?? $ad->target_gender,
                'target_location' => $validated['target_location'] ?? $ad->target_location,
                'target_genres'   => $validated['target_genres']   ?? $ad->target_genres,
                'status'          => 'pending', // Reset về pending để admin duyệt lại
            ]);

            return response()->json([
                'message' => 'Advertisement campaign updated successfully',
                'data'    => $ad->fresh(),
            ], 200);

        } catch (ValidationException $e) {
            return response()->json([
                'message' => 'Validation failed',
                'errors'  => $e->errors(),
            ], 422);
        } catch (\Exception $e) {
            Log::error('Ad update failed: ' . $e->getMessage());
            return response()->json([
                'message' => 'Internal server error during ad update',
                'error'   => $e->getMessage(),
            ], 500);
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

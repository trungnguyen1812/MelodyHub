<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Copyright;
use App\Models\Song;
use App\Models\Notification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AdminCopyrightController extends Controller
{
    /**
     * Danh sách tất cả copyright requests (có filter, search, phân trang)
     */
    public function index(Request $request)
    {
        try {
            $query = Copyright::with(['song.artist', 'song.genre', 'partner.user']);

            if ($request->filled('status')) {
                $query->where('status', $request->status);
            }

            if ($request->filled('search')) {
                $search = $request->search;
                $query->where(function ($q) use ($search) {
                    $q->where('owner_name', 'like', "%{$search}%")
                      ->orWhereHas('song', fn($sq) => $sq->where('title', 'like', "%{$search}%"))
                      ->orWhere('registration_number', 'like', "%{$search}%");
                });
            }

            if ($request->filled('copyright_type')) {
                $query->where('copyright_type', $request->copyright_type);
            }

            $perPage = $request->get('per_page', 15);
            $copyrights = $query->orderBy('created_at', 'desc')->paginate($perPage);

            return response()->json([
                'success'      => true,
                'data'         => $copyrights->items(),
                'current_page' => $copyrights->currentPage(),
                'last_page'    => $copyrights->lastPage(),
                'per_page'     => $copyrights->perPage(),
                'total'        => $copyrights->total(),
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    /**
     * Thống kê tổng quan cho dashboard
     */
    public function stats()
    {
        try {
            $total    = Copyright::count();
            $pending  = Copyright::where('status', 'pending')->count();
            $active   = Copyright::where('status', 'active')->count();
            $expired  = Copyright::where('status', 'expired')->count();
            $disputed = Copyright::where('status', 'disputed')->count();
            $revoked  = Copyright::where('status', 'revoked')->count();

            // Theo loại copyright
            $byType = Copyright::selectRaw('copyright_type, count(*) as count')
                ->groupBy('copyright_type')
                ->pluck('count', 'copyright_type');

            // Theo tháng (6 tháng gần nhất)
            $monthly = Copyright::selectRaw("DATE_FORMAT(created_at, '%Y-%m') as month, count(*) as count")
                ->where('created_at', '>=', now()->subMonths(6))
                ->groupBy('month')
                ->orderBy('month')
                ->get();

            return response()->json([
                'success' => true,
                'data'    => [
                    'total'    => $total,
                    'pending'  => $pending,
                    'active'   => $active,
                    'expired'  => $expired,
                    'disputed' => $disputed,
                    'revoked'  => $revoked,
                    'by_type'  => $byType,
                    'monthly'  => $monthly,
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    /**
     * Chi tiết một copyright
     */
    public function show($id)
    {
        try {
            $copyright = Copyright::with(['song.artist', 'song.genre', 'partner.user'])->findOrFail($id);

            return response()->json(['success' => true, 'data' => $copyright]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => 'Copyright not found'], 404);
        }
    }

    /**
     * Approve (verify) một copyright request
     */
    public function approve(Request $request, $id)
    {
        try {
            $copyright = Copyright::with(['song', 'partner.user'])->findOrFail($id);

            if ($copyright->status === 'active') {
                return response()->json(['success' => false, 'message' => 'Already verified'], 422);
            }

            $copyright->update([
                'status'      => 'active',
                'verified_at' => now(),
                'verified_by' => Auth::id(),
                'notes'       => $request->input('notes', $copyright->notes),
            ]);

            // Cập nhật copyright_status trên song
            Song::where('id', $copyright->song_id)
                ->update(['copyright_status' => 'verified']);

            // Gửi notification cho partner
            $this->notifyPartner($copyright, 'copyright_approved',
                'Copyright Approved ✓',
                "Your copyright registration for \"{$copyright->song->title}\" has been approved."
            );

            return response()->json([
                'success' => true,
                'message' => 'Copyright approved successfully',
                'data'    => $copyright->fresh(['song.artist', 'partner.user']),
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    /**
     * Reject một copyright request
     */
    public function reject(Request $request, $id)
    {
        try {
            $copyright = Copyright::with(['song', 'partner.user'])->findOrFail($id);

            if (!in_array($copyright->status, ['pending', 'disputed'])) {
                return response()->json(['success' => false, 'message' => 'Cannot reject this record'], 422);
            }

            $request->validate([
                'reason' => 'nullable|string|max:500',
            ]);

            $copyright->update([
                'status' => 'revoked',
                'notes'  => $request->input('reason', $copyright->notes),
            ]);

            // Cập nhật copyright_status trên song về unverified
            Song::where('id', $copyright->song_id)
                ->update(['copyright_status' => 'unverified']);

            // Gửi notification cho partner
            $this->notifyPartner($copyright, 'copyright_rejected',
                'Copyright Registration Rejected',
                "Your copyright registration for \"{$copyright->song->title}\" was not approved." .
                ($request->reason ? " Reason: {$request->reason}" : '')
            );

            return response()->json([
                'success' => true,
                'message' => 'Copyright rejected',
                'data'    => $copyright->fresh(['song.artist', 'partner.user']),
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    /**
     * Cập nhật ghi chú / thông tin bổ sung
     */
    public function update(Request $request, $id)
    {
        try {
            $copyright = Copyright::findOrFail($id);

            $validated = $request->validate([
                'notes'  => 'nullable|string',
                'status' => 'sometimes|in:active,expired,pending,disputed,revoked',
            ]);

            $copyright->update($validated);

            return response()->json([
                'success' => true,
                'message' => 'Updated successfully',
                'data'    => $copyright->fresh(['song.artist', 'partner.user']),
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    // ── Private helpers ──────────────────────────────────────────────────────

    private function notifyPartner(Copyright $copyright, string $type, string $title, string $message): void
    {
        if (!$copyright->partner?->user_id) return;

        Notification::create([
            'user_id'    => $copyright->partner->user_id,
            'type'       => $type,
            'title'      => $title,
            'message'    => $message,
            'data'       => json_encode(['copyright_id' => $copyright->id, 'song_id' => $copyright->song_id]),
            'action_url' => '/center/copyright-registration',
            'is_read'    => false,
        ]);
    }
}

<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use App\Models\Song;
use App\Models\Partner;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class NotificationController extends Controller
{
    /**
     * Lấy danh sách notifications của user đang login.
     * Tự động tạo notifications nhắc nhở bài chưa đăng ký bản quyền.
     */
    public function index(Request $request)
    {
        $user = Auth::user();

        // Tự động tạo nhắc nhở cho partner nếu có bài unverified
        $this->generateCopyrightReminders($user);

        $notifications = Notification::where('user_id', $user->id)
            ->orderByDesc('created_at')
            ->limit(30)
            ->get();

        $unreadCount = Notification::where('user_id', $user->id)
            ->where('is_read', false)
            ->count();

        return response()->json([
            'success' => true,
            'data' => $notifications,
            'unread_count' => $unreadCount,
        ]);
    }

    /**
     * Đánh dấu một notification là đã đọc.
     */
    public function markRead($id)
    {
        $notification = Notification::where('id', $id)
            ->where('user_id', Auth::id())
            ->firstOrFail();

        $notification->update([
            'is_read' => true,
            'read_at' => now(),
        ]);

        return response()->json(['success' => true]);
    }

    /**
     * Đánh dấu tất cả là đã đọc.
     */
    public function markAllRead()
    {
        Notification::where('user_id', Auth::id())
            ->where('is_read', false)
            ->update(['is_read' => true, 'read_at' => now()]);

        return response()->json(['success' => true]);
    }

    /**
     * Lấy số lượng chưa đọc (dùng cho polling nhẹ).
     */
    public function unreadCount()
    {
        $count = Notification::where('user_id', Auth::id())
            ->where('is_read', false)
            ->count();

        return response()->json(['unread_count' => $count]);
    }

    /**
     * Tự động tạo/cập nhật notification nhắc nhở bản quyền cho partner.
     * Chiến lược: chỉ giữ đúng 1 notification unread loại này — upsert thay vì tạo mới.
     */
    private function generateCopyrightReminders($user): void
    {
        // Chỉ áp dụng cho partner active
        $partner = Partner::where('user_id', $user->id)
            ->where('status', 'active')
            ->first();

        if (!$partner) return;

        // Đếm bài chưa đăng ký bản quyền (unverified hoặc pending chưa được duyệt)
        $unverifiedCount = Song::where('partner_id', $partner->id)
            ->where('copyright_status', 'unverified')
            ->where('status', 'published')
            ->count();

        // Tìm notification unread hiện có (nếu có)
        $existing = Notification::where('user_id', $user->id)
            ->where('type', 'copyright_unverified')
            ->where('is_read', false)
            ->latest()
            ->first();

        // Không còn bài nào unverified → xóa notification cũ nếu có
        if ($unverifiedCount === 0) {
            if ($existing) {
                $existing->delete();
            }
            return;
        }

        $message = "You have {$unverifiedCount} song(s) without copyright registration. Register now to protect your work and get a verified ✓ badge.";
        $data    = json_encode(['unverified_count' => $unverifiedCount, 'partner_id' => $partner->id]);

        if ($existing) {
            // Cập nhật notification hiện có thay vì tạo mới
            $existing->update([
                'message' => $message,
                'data'    => $data,
            ]);
            return;
        }

        // Chưa có notification unread nào → kiểm tra 24h trước khi tạo mới
        $recentlyCreated = Notification::where('user_id', $user->id)
            ->where('type', 'copyright_unverified')
            ->where('created_at', '>=', now()->subHours(24))
            ->exists();

        if ($recentlyCreated) return;

        Notification::create([
            'user_id'    => $user->id,
            'type'       => 'copyright_unverified',
            'title'      => 'Copyright Registration Reminder',
            'message'    => $message,
            'data'       => $data,
            'action_url' => '/center/copyright-registration',
            'is_read'    => false,
        ]);
    }
}

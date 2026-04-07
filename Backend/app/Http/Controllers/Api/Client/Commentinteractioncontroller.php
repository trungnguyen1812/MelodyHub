<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\Comment;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class CommentInteractionController extends Controller
{
    // =========================================================================
    // COMMENT LIKE
    // POST /api/comments/{comment}/like
    // Body: { is_liked: true|false }
    //
    // Vì bảng comments dùng counter column (total_likes) thay vì bảng pivot
    // nên ta track bằng bảng comment_likes (nếu có) hoặc dùng cache user→comment
    // =========================================================================
    public function like(Request $request, Comment $comment): JsonResponse
    {
        $request->validate([
            'is_liked' => ['required', 'boolean'],
        ]);

        $userId   = Auth::id();
        $isLiked  = $request->boolean('is_liked');
        $cacheKey = "comment_like:{$userId}:{$comment->id}";

        // Kiểm tra trạng thái like hiện tại qua cache (tránh query nặng)
        // Nếu có bảng comment_likes thì thay bằng DB query
        $alreadyLiked = cache()->get($cacheKey, false);

        if ($isLiked && !$alreadyLiked) {
            // Like: tăng total_likes, lưu cache
            $comment->increment('total_likes');
            cache()->put($cacheKey, true, now()->addDays(7));

        } elseif (!$isLiked && $alreadyLiked) {
            // Unlike: giảm total_likes, xóa cache
            $comment->decrement('total_likes');
            cache()->forget($cacheKey);
        }

        // Reload để lấy giá trị mới nhất
        $comment->refresh();

        return response()->json([
            'is_liked'    => $isLiked,
            'total_likes' => $comment->total_likes,
        ]);
    }
}
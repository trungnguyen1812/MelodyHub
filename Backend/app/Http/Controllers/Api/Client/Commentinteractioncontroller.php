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
        $alreadyLiked = cache()->get($cacheKey, false);

        if ($isLiked && !$alreadyLiked) {
            $comment->increment('total_likes');
            cache()->put($cacheKey, true, now()->addDays(7));

        } elseif (!$isLiked && $alreadyLiked) {
            $comment->decrement('total_likes');
            cache()->forget($cacheKey);
        }

        $comment->refresh();

        return response()->json([
            'is_liked'    => $isLiked,
            'total_likes' => $comment->total_likes,
        ]);
    }
}
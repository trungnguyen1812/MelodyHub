<?php
namespace App\Http\Controllers\Api\Client;

use App\Models\Album;
use App\Models\AlbumLike;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;

class AlbumInteractionController extends Controller
{
    public function like(Request $request, $albumId): JsonResponse  // ← Đổi từ Album $album thành $albumId
    {
        Log::info('Album like request', ['album_id' => $albumId, 'user_id' => Auth::id()]);
        
        $request->validate([
            'is_liked' => ['required', 'boolean'],
        ]);
  
        $userId = Auth::id();
        
        // Tìm album bằng ID
        $album = Album::find($albumId);
        
        if (!$album) {
            return response()->json(['error' => 'Album not found'], 404);
        }
 
        if ($request->boolean('is_liked')) {
            AlbumLike::firstOrCreate([
                'user_id' => $userId,
                'album_id' => $album->id,
            ]);
        } else {
            AlbumLike::where('user_id', $userId)
                    ->where('album_id', $album->id)
                    ->delete();
        }
 
        // Đếm lại số lượng likes
        $likeCount = AlbumLike::where('album_id', $album->id)->count();
        
        // Cập nhật album
        $album->like_count = $likeCount;
        $album->save();
 
        return response()->json([
            'is_liked'   => $request->boolean('is_liked'),
            'like_count' => $likeCount,
        ]);
    }
}
<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\Artist;
use App\Models\ArtistFollower;
use App\Models\Song;
use App\Models\SongLike;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class Songinteractioncontroller  extends Controller
{
     // =========================================================================
    // LIKE
    // POST /api/songs/{song}/like
    // Body: { is_liked: true|false }
    // =========================================================================
    public function like(Request $request, Song $song): JsonResponse
    {
        $request->validate([
            'is_liked' => ['required', 'boolean'],
        ]);
  
        $userId = Auth::id();
 
        if ($request->boolean('is_liked')) {
            SongLike::firstOrCreate([
                'user_id' => $userId,
                'song_id' => $song->id,
            ]);
 
            $song->total_likes = SongLike::where('song_id', $song->id)->count();
            $song->save();
        } else {
            SongLike::where('user_id', $userId)
                    ->where('song_id', $song->id)
                    ->delete();
 
            $song->like_count = SongLike::where('song_id', $song->id)->count();
            $song->save();
        }
 
        return response()->json([
            'is_liked'   => $request->boolean('is_liked'),
            'like_count' => $song->like_count,
        ]);
    }
    // =========================================================================
    // SHARE
    // POST /api/songs/{song}/share
    // Body: { shared: true }
    // =========================================================================
    public function share(Request $request, Song $song): JsonResponse
    {
        $song->increment('total_shares');
 
        return response()->json([
            'total_shares' => $song->total_shares,
        ]);
    }
}
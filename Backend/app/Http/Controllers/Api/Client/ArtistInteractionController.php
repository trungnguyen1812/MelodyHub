<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\Artist;
use App\Models\ArtistFollower;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ArtistInteractionController  extends Controller
{
    // follow
    public function follow(Request $request, Artist $artist): JsonResponse
    {
        log::info('---------------------');
        log::info($request);
        log::info('---------------------');
        log::info($artist);
        $request->validate([
            'is_followed' => ['required', 'boolean'],
        ]);

        $userId = Auth::id();
        log::info('---------------------');
        log::info($userId);
        if ($request->boolean('is_followed')) {
            ArtistFollower::firstOrCreate([
                'user_id'   => $userId,
                'artist_id' => $artist->id,
            ], [
                'followed_at' => now(),
            ]);
        } else {
            ArtistFollower::where('user_id', $userId)
                        ->where('artist_id', $artist->id)
                        ->delete();
        }

        $followerCount = ArtistFollower::where('artist_id', $artist->id)->count();

        return response()->json([
            'is_followed'    => $request->boolean('is_followed'),
            'follower_count' => $followerCount,
        ]);
    }
}
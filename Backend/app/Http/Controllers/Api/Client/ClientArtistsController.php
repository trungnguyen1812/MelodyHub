<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\Artist;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;

class ClientArtistsController extends Controller
{
    public function getAllArtist(Request $request)
    {
        $limit = $request->query('limit', 10);
        $artists = Artist::limit($limit)->get();
        return response()->json(['data' => $artists]);
    }

   

    public function show(Artist $artist)
    {
        log::info($artist);
        return response()->json($artist);
    }

    public function search(Request $request)
    {
        $artists = Artist::query()
            ->search($request->q)
            ->latest()
            ->paginate(10);
        return response()->json([
            'status' => 'success',
            'data' => $artists
        ]);
    }

    public function statistics()
    {
        $statistics = Artist::getFullStatistics();
        
        return response()->json([
            'success' => true,
            'message' => 'Artist statistics retrieved successfully',
            'data' => $statistics
        ]);
    }
}

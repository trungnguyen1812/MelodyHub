<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\Genre;
use App\Http\Resources\SongResource;
use Illuminate\Http\Request;

class ClientGenresController extends Controller
{
    public function index()
    {
        $genres = Genre::all();
        return response()->json($genres);
    }

    public function show(string $slug)
    {
        $genre = Genre::where('slug', $slug)->firstOrFail();
        
        // Eager load songs with their artist and other relations
        $songs = $genre->songs()
            ->with(['artist', 'album', 'genre'])
            ->where('status', 'published')
            ->orderBy('created_at', 'desc')
            ->paginate(20);

        return response()->json([
            'success' => true,
            'data' => [
                'genre' => $genre,
                'songs' => SongResource::collection($songs),
                'meta' => [
                    'current_page' => $songs->currentPage(),
                    'last_page' => $songs->lastPage(),
                    'per_page' => $songs->perPage(),
                    'total' => $songs->total(),
                ]
            ]
        ]);
    }
}

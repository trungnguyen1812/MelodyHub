<?php

namespace App\Http\Controllers\Api\client;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class MusicController extends Controller
{
    public function index()
    {
        // ví dụ dữ liệu giả để test
        $songs = [
            ['id' => 1, 'title' => 'Song A', 'artist' => 'Artist 1'],
            ['id' => 2, 'title' => 'Song B', 'artist' => 'Artist 2'],
        ];

        return response()->json($songs);
    }

    public function show($id)
    {
        return response()->json(['id' => $id, 'title' => 'Demo Song']);
    }
}

<?php

namespace App\Http\Controllers\Api\Admin;

use App\Helpers\FileUploadHelper;
use App\Http\Controllers\Controller;
use App\Models\Genre;
use App\Models\Song;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class GenresManagerController extends Controller
{
    public function index()
    {
        $genres = Genre::all();
        return response()->json($genres);
    }

    public function add(Request $request)
    {
        try {
            $request->merge([
                'is_active' => filter_var($request->is_active ?? true, FILTER_VALIDATE_BOOLEAN),
            ]);

            $data = $request->validate([
                'name' => 'required|string|max:255',
                'slug' => 'nullable|string|max:255|unique:genres,slug',
                'description' => 'nullable|string',
                'cover_url' => 'nullable|image|max:5120',
                'color' => 'nullable|string|max:20',
                'parent_id' => 'nullable|exists:genres,id',
                'order' => 'nullable|integer',
                'is_active' => 'nullable|boolean',
            ]);

            $coverPath = null;
            if ($request->hasFile('cover_url') && $request->file('cover_url')->isValid()) {
                $coverPath = FileUploadHelper::upload($request->file('cover_url'), 'covers/genres');
                Log::info('Cover uploaded during add: ' . $coverPath);
            }

            $genre = Genre::create([
                ...$data,
                'slug' => $data['slug'] ?? Str::slug($data['name']) . '-' . time(),
                'cover_url' => $coverPath,
                'total_songs' => 0,
            ]);

            return response()->json([
                'status' => 'success',
                'data' => $genre
            ], 201);
            
        } catch (\Throwable $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage()
            ], 400);
        }
    }

    public function show(Genre $genre)
    {
        return response()->json($genre);
    }

    public function update(Request $request, Genre $genre)
    {
        try {
            $request->merge([
                'is_active' => filter_var($request->is_active ?? true, FILTER_VALIDATE_BOOLEAN),
            ]);

            $data = $request->validate([
                'name' => 'required|string|max:255',
                'slug' => 'nullable|string|max:255|unique:genres,slug,' . $genre->id,
                'description' => 'nullable|string',
                'cover_url' => 'nullable|image|max:5120',
                'color' => 'nullable|string|max:20',
                'parent_id' => 'nullable|exists:genres,id',
                'order' => 'nullable|integer',
                'is_active' => 'nullable|boolean',
            ]);

            $coverPath = $genre->cover_url;
            if ($request->hasFile('cover_url') && $request->file('cover_url')->isValid()) {
                $coverPath = FileUploadHelper::upload($request->file('cover_url'), 'covers/genres');
                Log::info('Cover uploaded during update: ' . $coverPath);
            }

            $genre->update([
                ...$data,
                'slug' => $data['slug'] ?? Str::slug($data['name']) . '-' . time(),
                'cover_url' => $coverPath,
            ]);

            return response()->json([
                'status' => 'success',
                'data' => $genre
            ], 200);

        } catch (\Throwable $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage()
            ], 400);
        }
    }

    public function destroy(Genre $genre)
    {
        try {
            // Nullify genre_id for all songs in this genre
            $genre->songs()->update(['genre_id' => null]);
            
            // Nullify parent_id for any sub-genres
            Genre::where('parent_id', $genre->id)->update(['parent_id' => null]);
            
            $genre->delete();

            return response()->json([
                'success' => true,
                'message' => 'Genre deleted successfully',
                'deleted_id' => $genre->id
            ]);
        } catch (\Exception $e) {
            Log::error('Delete Genre error:', ['error' => $e->getMessage()]);
            return response()->json([
                'success' => false,
                'message' => 'Delete failed: ' . $e->getMessage()
            ], 500);
        }
    }
}
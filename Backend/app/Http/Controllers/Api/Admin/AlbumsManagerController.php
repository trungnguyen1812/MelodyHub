<?php

namespace App\Http\Controllers\Api\Admin;

use App\Helpers\FileUploadHelper;
use App\Http\Controllers\Controller;
use App\Models\Album;
use App\Models\AlbumTrack;
use App\Models\Song;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;

class AlbumsManagerController extends Controller
{
    public function index()
    {
        $albums = Album::with(['artist', 'album_tracks'])->get();
        return response()->json($albums);
    }

    public function search(Request $request)
    {
        try {
            $keyword = $request->get('q') ?? $request->get('search') ?? '';

            $albums = Album::with('artist')
                ->where(function ($q) use ($keyword) {
                    $q->where('name', 'like', "%{$keyword}%")
                      ->orWhere('slug', 'like', "%{$keyword}%")
                      ->orWhere('description', 'like', "%{$keyword}%")
                      ->orWhereHas('artist', function ($artistQ) use ($keyword) {
                          $artistQ->where('name', 'like', "%{$keyword}%");
                      });
                })
                ->get();

            return response()->json([
                'success' => true,
                'data' => $albums
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    public function add(Request $request)
    {
        DB::beginTransaction();
        try {
            $request->merge([
                'is_featured' => filter_var($request->is_featured, FILTER_VALIDATE_BOOLEAN),
                'is_premium' => filter_var($request->is_premium, FILTER_VALIDATE_BOOLEAN),
            ]);

            $data = $request->validate([
                'name' => 'required|string|max:255',
                'slug' => 'nullable|string|max:255|unique:albums,slug',
                'artist_id' => 'required|exists:artists,id',
                'cover_url' => 'nullable|image|max:5120',
                'description' => 'nullable|string',
                'release_date' => 'nullable|date',
                'album_type' => 'nullable|string',
                'label' => 'nullable|string|max:255',
                'is_featured' => 'nullable|boolean',
                'is_premium' => 'nullable|boolean',
                'partner_id' => 'nullable|exists:partners,id',
                'status' => 'nullable|string',
                'seo_title' => 'nullable|string|max:255',
                'seo_description' => 'nullable|string|max:500',
                'track_ids' => 'nullable|array',
                'track_ids.*' => 'numeric|exists:songs,id'
            ]);

            $coverPath = null;
            if ($request->hasFile('cover_url') && $request->file('cover_url')->isValid()) {
                $coverPath = FileUploadHelper::upload($request->file('cover_url'), 'covers/albums');
                Log::info('Cover uploaded during add: ' . $coverPath);
            }

            // Create album
            $album = Album::create([
                ...$data,
                'slug' => $data['slug'] ?? Str::slug($data['name']) . '-' . time(),
                'cover_url' => $coverPath,
                'total_tracks' => 0,
                'total_duration' => 0,
                'total_plays' => 0,
                'total_likes' => 0,
            ]);

            // Add tracks to album_tracks if provided
            if (!empty($data['track_ids'])) {
                $trackIds = $data['track_ids'];
                $totalDuration = 0;

                foreach ($trackIds as $position => $trackId) {
                    AlbumTrack::create([
                        'album_id' => $album->id,
                        'track_id' => $trackId,
                        'position' => $position + 1,
                    ]);

                    // Get song duration for total calculation
                    $song = Song::find($trackId);
                    if ($song && $song->duration) {
                        $totalDuration += $song->duration;
                    }
                }

                // Update album total_tracks and total_duration
                $album->update([
                    'total_tracks' => count($trackIds),
                    'total_duration' => $totalDuration,
                ]);
            }

            DB::commit();

            return response()->json([
                'status' => 'success',
                'data' => $album->load('artist', 'tracks.artist')
            ], 201);
            
        } catch (\Throwable $e) {
            DB::rollBack();
            Log::error('Album add error:', ['error' => $e->getMessage()]);
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage()
            ], 400);
        }
    }

    public function show(Album $album)
    {
        return response()->json($album->load('artist', 'tracks.artist'));
    }

    public function update(Request $request, Album $album)
    {
        DB::beginTransaction();
        try {
            $request->merge([
                'is_featured' => filter_var($request->is_featured, FILTER_VALIDATE_BOOLEAN),
                'is_premium' => filter_var($request->is_premium, FILTER_VALIDATE_BOOLEAN),
            ]);

            $data = $request->validate([
                'name' => 'required|string|max:255',
                'slug' => 'nullable|string|max:255|unique:albums,slug,' . $album->id,
                'artist_id' => 'required|exists:artists,id',
                'cover_url' => 'nullable|image|max:5120',
                'description' => 'nullable|string',
                'release_date' => 'nullable|date',
                'album_type' => 'nullable|string',
                'label' => 'nullable|string|max:255',
                'is_featured' => 'nullable|boolean',
                'is_premium' => 'nullable|boolean',
                'partner_id' => 'nullable|exists:partners,id',
                'status' => 'nullable|string',
                'seo_title' => 'nullable|string|max:255',
                'seo_description' => 'nullable|string|max:500',
                'track_ids' => 'nullable|array',
                'track_ids.*' => 'numeric|exists:songs,id'
            ]);

            $coverPath = $album->cover_url;
            if ($request->hasFile('cover_url') && $request->file('cover_url')->isValid()) {
                $coverPath = FileUploadHelper::upload($request->file('cover_url'), 'covers/albums');
                Log::info('Cover uploaded during update: ' . $coverPath);
            }

            $album->update([
                ...$data,
                'slug' => $data['slug'] ?? Str::slug($data['name']) . '-' . time(),
                'cover_url' => $coverPath,
            ]);

            // Update album tracks if provided
            if ($request->has('track_ids')) {
                // Delete old album tracks
                AlbumTrack::where('album_id', $album->id)->delete();

                if (!empty($data['track_ids'])) {
                    $trackIds = $data['track_ids'];
                    $totalDuration = 0;

                    foreach ($trackIds as $position => $trackId) {
                        AlbumTrack::create([
                            'album_id' => $album->id,
                            'track_id' => $trackId,
                            'position' => $position + 1,
                        ]);

                        // Get song duration for total calculation
                        $song = Song::find($trackId);
                        if ($song && $song->duration) {
                            $totalDuration += $song->duration;
                        }
                    }

                    // Update album total_tracks and total_duration
                    $album->update([
                        'total_tracks' => count($trackIds),
                        'total_duration' => $totalDuration,
                    ]);
                } else {
                    // Reset totals if no tracks
                    $album->update([
                        'total_tracks' => 0,
                        'total_duration' => 0,
                    ]);
                }
            }

            DB::commit();

            return response()->json([
                'status' => 'success',
                'data' => $album->load('artist', 'tracks.artist')
            ], 200);

        } catch (\Throwable $e) {
            DB::rollBack();
            Log::error('Album update error:', ['error' => $e->getMessage()]);
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage()
            ], 400);
        }
    }

    public function destroy(Album $album)
    {
        try {
            // Remove associated songs constraint (set album_id to null)
            Song::where('album_id', $album->id)->update(['album_id' => null]);
            
            $album->delete();

            return response()->json([
                'success' => true,
                'message' => 'Album deleted successfully',
                'deleted_id' => $album->id
            ]);
        } catch (\Exception $e) {
            Log::error('Delete Album error:', ['error' => $e->getMessage()]);
            return response()->json([
                'success' => false,
                'message' => 'Delete failed: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update album tracks specifically
     * PUT /albums/{id}/tracks
     */
    public function updateTracks(Request $request, Album $album)
    {
        DB::beginTransaction();
        try {
            $data = $request->validate([
                'track_ids' => 'required|array',
                'track_ids.*' => 'numeric|exists:songs,id'
            ]);

            $trackIds = $data['track_ids'];
            $totalDuration = 0;

            // Delete old album tracks
            AlbumTrack::where('album_id', $album->id)->delete();

            // Add new album tracks
            foreach ($trackIds as $position => $trackId) {
                AlbumTrack::create([
                    'album_id' => $album->id,
                    'track_id' => $trackId,
                    'position' => $position + 1,
                ]);

                // Get song duration for total calculation
                $song = Song::find($trackId);
                if ($song && $song->duration) {
                    $totalDuration += $song->duration;
                }
            }

            // Update album total_tracks and total_duration
            $album->update([
                'total_tracks' => count($trackIds),
                'total_duration' => $totalDuration,
            ]);

            DB::commit();

            return response()->json([
                'status' => 'success',
                'message' => 'Album tracks updated successfully',
                'data' => $album->load('tracks.artist')
            ], 200);

        } catch (\Throwable $e) {
            DB::rollBack();
            Log::error('Album tracks update error:', ['error' => $e->getMessage()]);
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage()
            ], 400);
        }
    }
}


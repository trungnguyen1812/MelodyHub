<?php

namespace App\Http\Controllers\Api\Admin;
use App\Http\Controllers\Controller;
use App\Models\Song;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Jobs\ProcessSongAudio;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\JsonResponse;
use App\Http\Resources\SongResource;

use App\Services\CloudinaryService;

class SongsManagerController extends Controller
{
    public function add(Request $request): JsonResponse
    {
        log::info($request);
        // ── 1. Validate ──
        $request->validate([
            'title'           => 'required|string|max:255',
            'slug'            => 'required|string|unique:songs,slug',
            'artist_id'       => 'required|exists:artists,id',
            'album_id'        => 'nullable|exists:albums,id',
            'year'            => 'nullable|integer|min:1900|max:2099',
            'track_number'    => 'nullable|integer|min:1',
            'disc_number'     => 'nullable|integer|min:1',
            'isrc'            => 'nullable|string|max:20',
            'copyright_owner' => 'required|string|max:255',
            'license_type'    => 'nullable|string|max:100',
            'duration'        => 'nullable|integer|min:0',
            'file_size'       => 'nullable|integer|min:0',
            'bitrate'         => 'nullable|integer',
            'quality'         => 'nullable|string|in:low,standard,high,lossless',
            'lyrics'          => 'nullable|string',
            'cover_url'       => 'nullable|string|max:500',
            'audio_file'      => [
                                    'required',
                                    'file',
                                    'max:51200',
                                    function ($attribute, $value, $fail) {
                                        $ext = strtolower($value->getClientOriginalExtension());
                                        $allowed = ['mp3', 'wav', 'flac', 'aac', 'ogg', 'm4a'];
                                        if (!in_array($ext, $allowed)) {
                                            $fail("The {$attribute} must be a valid audio file (mp3, wav, flac, aac, ogg, m4a).");
                                        }
                                    },
                                ],
            'status'          => 'nullable|string|in:draft,published,blocked',
            'partner_id'      => 'nullable|exists:partners,id',
            'is_premium'      => 'nullable',
            'is_explicit'     => 'nullable',
            'is_featured'     => 'nullable',
            'allow_download'  => 'nullable',
        ]);
 
        DB::beginTransaction();
 
        try {
            $audioFile  = $request->file('audio_file');
            $storedPath = $audioFile->store('audio_originals', 'local');
 
            Log::info('Audio file stored', [
                'path'     => $storedPath,
                'size'     => $audioFile->getSize(),
                'original' => $audioFile->getClientOriginalName(),
            ]);
            Log::info('Year value before insert', [
                'raw' => $request->year,
                'casted' => $request->year ? (int) $request->year : null,
                'type' => gettype($request->year)
            ]);
            $song = Song::create([
                'title'             => $request->title,
                'slug'              => $request->slug,
                'artist_id'         => $request->artist_id,
                'album_id'          => $request->album_id       ?: null,
                'year'              => $request->year ? (int) $request->year : null,
                'track_number'      => $request->track_number   ?: null,
                'disc_number'       => $request->disc_number    ?? 1,
                'isrc'              => $request->isrc           ?: null,
                'copyright_owner'   => $request->copyright_owner,
                'license_type'      => $request->license_type   ?: null,
                'lyrics'            => $request->lyrics         ?: null,
                'duration'          => $request->duration       ?? 0,
                'file_size'         => $audioFile->getSize(),
                'bitrate'           => $request->bitrate        ?? 320,
                'quality'           => $request->quality        ?? 'high',
                'cover_url'         => $request->cover_url      ?: null,
                'song_url'          => null,
                'song_url_hq'       => null,
                'song_url_lossless' => null,
                'is_premium'        => filter_var($request->is_premium,    FILTER_VALIDATE_BOOLEAN),
                'is_explicit'       => filter_var($request->is_explicit,   FILTER_VALIDATE_BOOLEAN),
                'is_featured'       => filter_var($request->is_featured,   FILTER_VALIDATE_BOOLEAN),
                'allow_download'    => filter_var($request->allow_download, FILTER_VALIDATE_BOOLEAN),
                'partner_id'        => $request->partner_id     ?: null,
                'status'            => $request->status,
            ]);
 
            DB::commit();
 
            ProcessSongAudio::dispatch(
                $song->id,
                $storedPath,
                $request->status ?? 'published'  
            )->onQueue('audio');
 
            Log::info("Song #{$song->id} queued for audio processing", [
                'stored_path' => $storedPath,
            ]);
 
            return response()->json([
                'success' => true,
                'message' => 'Song created. Audio is being processed in the background.',
                'data'    => [
                    'id'        => $song->id,
                    'title'     => $song->title,
                    'cover_url' => $song->cover_url,
                    'status'    => $song->status, 
                ],
            ], 201);
 
        } catch (\Throwable $e) {
            DB::rollBack();
            Log::error('SongController@add failed: ' . $e->getMessage());
 
            return response()->json([
                'success' => false,
                'message' => 'Failed to create song: ' . $e->getMessage(),
            ], 500);
        }
    }

    public function index(Request $request): JsonResponse
    {
        $query = Song::query()
            ->with(['artist', 'album', 'partner']);
 
        // ── Tìm kiếm theo title / slug ──
        if ($search = $request->get('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('slug',  'like', "%{$search}%");
            });
        }
 
        // ── Filter ──
        if ($request->filled('artist_id'))  $query->where('artist_id',  $request->artist_id);
        if ($request->filled('album_id'))   $query->where('album_id',   $request->album_id);
        if ($request->filled('partner_id')) $query->where('partner_id', $request->partner_id);
        if ($request->filled('status'))     $query->where('status',     $request->status);
        if ($request->filled('quality'))    $query->where('quality',    $request->quality);
        if ($request->filled('year'))       $query->whereYear('year',   $request->year);
        if ($request->filled('genre_id')) $query->where('genre_id', $request->genre_id);
 
        if ($request->filled('is_premium'))
            $query->where('is_premium', filter_var($request->is_premium, FILTER_VALIDATE_BOOLEAN));
        if ($request->filled('is_featured'))
            $query->where('is_featured', filter_var($request->is_featured, FILTER_VALIDATE_BOOLEAN));
        if ($request->filled('is_explicit'))
            $query->where('is_explicit', filter_var($request->is_explicit, FILTER_VALIDATE_BOOLEAN));
 
        // ── Sort ──
        $allowedSorts = ['created_at', 'title', 'total_plays', 'total_likes', 'duration', 'year'];
        $sortBy  = in_array($request->get('sort_by'), $allowedSorts)
            ? $request->get('sort_by')
            : 'created_at';
        $sortDir = $request->get('sort_dir') === 'asc' ? 'asc' : 'desc';
        $query->orderBy($sortBy, $sortDir);
 
        // ── Phân trang ──
        $perPage = min((int) $request->get('per_page', 20), 100);
        $songs   = $query->paginate($perPage);
 
        return response()->json([
            'success' => true,
            'data'    => SongResource::collection($songs),
            'meta'    => [
                'current_page' => $songs->currentPage(),
                'last_page'    => $songs->lastPage(),
                'per_page'     => $songs->perPage(),
                'total'        => $songs->total(),
            ],
        ]);
    }
 
    public function show(Request $request, string $idOrSlug): JsonResponse
    {
        $song = is_numeric($idOrSlug)
            ? Song::with(['artist', 'album', 'partner'])->findOrFail($idOrSlug)
            : Song::with(['artist', 'album', 'partner'])->where('slug', $idOrSlug)->firstOrFail();
 
        return response()->json([
            'success' => true,
            'data'    => new SongResource($song),
        ]);
    }
    
    public function __construct(
        protected CloudinaryService $cloudinaryService
    ) {}

    public function delete(Song $song): JsonResponse
    {
        try {
            DB::transaction(function () use ($song) {
                $coverUrl = $song->cover_url;
                $songId   = $song->id;

                Log::info("Delete song", [
                    'id'       => $songId,
                    'coverUrl' => $coverUrl,
                ]);

                $song->delete();

                $this->cloudinaryService->deleteSong($coverUrl, null, $songId);
            });

            return response()->json(['message' => 'Song deleted successfully'], 200);

        } catch (\Exception $e) {
            Log::error("Failed to delete song: " . $e->getMessage());
            return response()->json(['message' => 'Failed to delete song'], 500);
        }
    }


    public function update(Request $request, Song $song): JsonResponse
    {
        Log::info('Update song request', ['id' => $song->id, 'data' => $request->except('audio_file')]);

        // ── 1. Validate ──
        $request->validate([
            'title'           => 'sometimes|string|max:255',
            'slug'            => 'sometimes|string|unique:songs,slug,' . $song->id,
            'artist_id'       => 'sometimes|exists:artists,id',
            'album_id'        => 'nullable|exists:albums,id',
            'year'            => 'nullable|integer|min:1900|max:2099',
            'track_number'    => 'nullable|integer|min:1',
            'disc_number'     => 'nullable|integer|min:1',
            'isrc'            => 'nullable|string|max:20',
            'copyright_owner' => 'sometimes|string|max:255',
            'license_type'    => 'nullable|string|max:100',
            'duration'        => 'nullable|integer|min:0',
            'file_size'       => 'nullable|integer|min:0',
            'bitrate'         => 'nullable|integer',
            'quality'         => 'nullable|string|in:low,standard,high,lossless',
            'lyrics'          => 'nullable|string',
            'cover_url'       => 'nullable|string|max:500',
            'cover_file'      => 'nullable|image|max:5120',
            'audio_file'      => [
                'nullable', 'file', 'max:51200',
                function ($attribute, $value, $fail) {
                    $ext     = strtolower($value->getClientOriginalExtension());
                    $allowed = ['mp3', 'wav', 'flac', 'aac', 'ogg', 'm4a'];
                    if (!in_array($ext, $allowed)) {
                        $fail("The {$attribute} must be a valid audio file.");
                    }
                },
            ],
            'status'         => 'nullable|string|in:draft,published,blocked',
            'partner_id'     => 'nullable|exists:partners,id',
            'is_premium'     => 'nullable',
            'is_explicit'    => 'nullable',
            'is_featured'    => 'nullable',
            'allow_download' => 'nullable',
        ]);

        DB::beginTransaction();

        try {
            $updateData = [];

            // ── 2. Các field text ──
            $fields = [
                'title', 'slug', 'artist_id', 'album_id', 'track_number',
                'disc_number', 'isrc', 'copyright_owner', 'license_type',
                'lyrics', 'duration', 'bitrate', 'quality', 'partner_id', 'status',
            ];

            foreach ($fields as $field) {
                if ($request->has($field)) {
                    $updateData[$field] = $request->$field ?: null;
                }
            }

            if ($request->has('year')) {
                $updateData['year'] = $request->year ? (int) $request->year : null;
            }

            foreach (['is_premium', 'is_explicit', 'is_featured', 'allow_download'] as $bool) {
                if ($request->has($bool)) {
                    $updateData[$bool] = filter_var($request->$bool, FILTER_VALIDATE_BOOLEAN);
                }
            }

            // ── 3. Cover image ──
            if ($request->hasFile('cover_file')) {
                // Xóa ảnh cũ trên Cloudinary
                $this->cloudinaryService->deleteImageByUrl($song->cover_url);

                // Upload ảnh mới
                $updateData['cover_url'] = $this->cloudinaryService->uploadImage(
                    $request->file('cover_file'),
                    'songs/partners'
                );
            } elseif ($request->has('cover_url')) {
                $updateData['cover_url'] = $request->cover_url ?: null;
            }

            // ── 4. Audio file mới ──
            $newAudioStoredPath = null;
            if ($request->hasFile('audio_file')) {
                $audioFile          = $request->file('audio_file');
                $newAudioStoredPath = $audioFile->store('audio_originals', 'local');
                $updateData['file_size'] = $audioFile->getSize();

                // Reset audio URLs — sẽ được điền lại sau khi transcode xong
                $updateData['song_url']          = null;
                $updateData['song_url_hq']       = null;
                $updateData['song_url_lossless'] = null;

                // Xóa folder audio cũ trên Cloudinary
                $this->cloudinaryService->deleteSongFolder($song->id);

                Log::info('New audio file stored', [
                    'path'     => $newAudioStoredPath,
                    'original' => $audioFile->getClientOriginalName(),
                ]);
            }

            $song->update($updateData);

            DB::commit();

            // ── 5. Dispatch transcode job nếu có audio mới ──
            if ($newAudioStoredPath) {
                ProcessSongAudio::dispatch(
                    $song->id,
                    $newAudioStoredPath,
                    $song->status
                )->onQueue('audio');

                Log::info("Song #{$song->id} re-queued for audio processing");
            }

            return response()->json([
                'success' => true,
                'message' => $newAudioStoredPath
                    ? 'Song updated. New audio is being processed.'
                    : 'Song updated successfully.',
                'data' => [
                    'id'        => $song->id,
                    'title'     => $song->title,
                    'cover_url' => $song->cover_url,
                    'status'    => $song->status,
                ],
            ], 200);

        } catch (\Throwable $e) {
            DB::rollBack();
            Log::error("SongController@update failed: " . $e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Failed to update song: ' . $e->getMessage(),
            ], 500);
        }
    }

    public function deleteMultiple(Request $request): JsonResponse
    {
        $ids = $request->input('ids', []);

        if (empty($ids)) {
            return response()->json(['message' => 'No song IDs provided'], 422);
        }

        $songs = Song::whereIn('id', $ids)->get();

        if ($songs->isEmpty()) {
            return response()->json(['message' => 'No songs found'], 404);
        }

        try {
            DB::transaction(function () use ($songs) {
                foreach ($songs as $song) {
                    $coverUrl = $song->cover_url;
                    $songId   = $song->id;

                    Log::info("Delete song", [
                        'id'       => $songId,
                        'coverUrl' => $coverUrl,
                    ]);

                    $song->delete();

                    $this->cloudinaryService->deleteSong($coverUrl, null, $songId);
                }
            });

            return response()->json(['message' => 'Songs deleted successfully'], 200);

        } catch (\Exception $e) {
            Log::error("Failed to delete multiple songs: " . $e->getMessage());
            return response()->json(['message' => 'Failed to delete songs'], 500);
        }
    }
   
}
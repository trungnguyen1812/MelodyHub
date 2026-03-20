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

use CloudinaryLabs\CloudinaryLaravel\Facades\Cloudinary;

class SongsManagerController extends Controller
{
    public function add(Request $request): JsonResponse
    {
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
            'audio_file'      => 'required|file|mimes:mp3,wav,flac,aac,ogg,m4a|max:204800',
            'status'          => 'nullable|string|in:draft,published,blocked',
            'partner_id'      => 'nullable|exists:partners,id',
            'is_premium'      => 'nullable',
            'is_explicit'     => 'nullable',
            'is_featured'     => 'nullable',
            'allow_download'  => 'nullable',
        ]);
 
        DB::beginTransaction();
 
        try {
            // ── 2. Lưu file audio gốc vào storage/app/audio_originals ──
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
            // ── 3. Tạo Song record với status = 'processing' ──
            // song_url / song_url_hq / song_url_lossless sẽ được
            // Queue Job fill vào sau khi transcode + upload Cloudinary xong
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
                // ✅ cover_url: frontend đã upload lên Cloudinary rồi gửi URL lên
                'cover_url'         => $request->cover_url      ?: null,
                // ⏳ Audio URLs: để trống — Job sẽ cập nhật sau khi transcode xong
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
 
            // ── 4. Dispatch Queue Job ──
            // Job: ffmpeg transcode 3 chất lượng → upload Cloudinary → update DB
            ProcessSongAudio::dispatch(
                $song->id,
                $storedPath,
                $request->status ?? 'published'   // status cuối sau khi xử lý xong
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
                    'status'    => $song->status,  // "processing"
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
 
    /**
     * GET /admin/songs/{id}
     * Chi tiết 1 bài hát theo id hoặc slug
     */
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
}
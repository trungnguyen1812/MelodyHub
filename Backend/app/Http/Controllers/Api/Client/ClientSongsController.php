<?php

namespace App\Http\Controllers\Api\Client;

use App\Helpers\ParseLrcFile;
use App\Http\Controllers\Controller;
use App\Models\Song;
use App\Models\SongLike;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use App\Jobs\ProcessSongAudio;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\JsonResponse;
use App\Http\Resources\SongResource;
use Illuminate\Support\Facades\Auth;

use App\Jobs\GenerateLyricsJob;
use App\Services\LyricsService;
use App\Services\CloudinaryService;


class ClientSongsController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Song::query()
            ->with(['artist', 'album', 'partner', 'genre']);

        // ── Tìm kiếm theo title / slug / tên ca sĩ ──
        if ($search = $request->get('search')) {
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('slug',  'like', "%{$search}%")
                  ->orWhereHas('artist', function ($a) use ($search) {
                      $a->where('name', 'like', "%{$search}%");
                  });
            });
        }

        // ── Filter ──
        if ($request->filled('artist_id'))  $query->where('artist_id',  $request->artist_id);
        if ($request->filled('album_id'))   $query->where('album_id',   $request->album_id);
        if ($request->filled('partner_id')) $query->where('partner_id', $request->partner_id);
        if ($request->filled('status'))     $query->where('status',     $request->status);
        if ($request->filled('quality'))    $query->where('quality',    $request->quality);
        if ($request->filled('year')) $query->where('year', $request->year);
        if ($request->filled('genre_id'))   $query->where('genre_id',   $request->genre_id);

        if ($request->filled('is_premium'))
            $query->where('is_premium',  filter_var($request->is_premium,  FILTER_VALIDATE_BOOLEAN));
        if ($request->filled('is_featured'))
            $query->where('is_featured', filter_var($request->is_featured, FILTER_VALIDATE_BOOLEAN));
        if ($request->filled('is_explicit'))
            $query->where('is_explicit', filter_var($request->is_explicit, FILTER_VALIDATE_BOOLEAN));

        // ── Sort ──
        $sortBy = $request->get('sort_by');
        if ($sortBy === 'random') {
            $query->inRandomOrder();
        } else {
            $allowedSorts = ['created_at', 'title', 'total_plays', 'total_likes', 'duration', 'year'];
            $sortBy       = in_array($sortBy, $allowedSorts) ? $sortBy : 'created_at';
            $sortDir      = $request->get('sort_dir') === 'asc' ? 'asc' : 'desc';
            $query->orderBy($sortBy, $sortDir);
        }

        // ── Limit (không phân trang) hoặc Phân trang ──
        if ($request->filled('limit')) {
            $limit = min((int) $request->get('limit'), 100);
            $songs = $query->limit($limit)->get();

            return response()->json([
                'success' => true,
                'data'    => SongResource::collection($songs),
            ]);
        }

        // ── Phân trang (mặc định) ──
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
        Log::info('Fetching song with:', ['idOrSlug' => $idOrSlug]);
        
        $userId = Auth::id();
        Log::info('User ID in song show:', ['user_id' => $userId]);

        // Nếu không có userId thì không cần withExists (luôn false)
        $withIsLiked = function ($query) use ($userId) {
            if ($userId) {
                $query->where('user_id', $userId);
            } else {
                $query->whereRaw('1 = 0'); // Không có user → is_liked luôn false
            }
        };

        if (is_numeric($idOrSlug)) {
            $song = Song::with(['artist', 'album', 'partner', 'genre'])
                ->withCount(['song_likes as like_count'])  
                ->withExists(['song_likes as is_liked' => $withIsLiked])
                ->find($idOrSlug);
            
            if (!$song) {
                return response()->json([
                    'success' => false,
                    'message' => 'Song not found with ID: ' . $idOrSlug
                ], 404);
            }
        } else {
            $song = Song::with(['artist', 'album', 'partner', 'genre'])
                ->withCount(['song_likes as like_count'])  
                ->withExists(['song_likes as is_liked' => $withIsLiked])
                ->where('slug', $idOrSlug)
                ->first();
            
            if (!$song) {
                return response()->json([
                    'success' => false,
                    'message' => 'Song not found with slug: ' . $idOrSlug
                ], 404);
            }
        }
        
        return response()->json([
            'success' => true,
            'data'    => new SongResource($song),
        ]);
    }

    public function getNewSongs(Request $request): JsonResponse
    {
        $limit  = min((int) $request->get('limit', 10), 100);
       /** @var \App\Models\User $user */
        $user = Auth::user();
        $userId = $user?->id;
        
        $query = Song::query()
            ->with(['artist', 'album', 'genre'])
            ->withCount('song_likes')
            ->where('status', 'published');

        $songs = (clone $query)
            ->where('created_at', '>=', now()->subDays(90))
            ->orderBy('created_at', 'desc')
            ->limit($limit)
            ->get();

        if ($songs->isEmpty()) {
            $songs = $query
                ->orderBy('created_at', 'desc')
                ->limit($limit)
                ->get();
        }
        if ($userId) {
            $likedSongIds = SongLike::where('user_id', $userId)
                ->pluck('song_id')
                ->toArray();
                
            foreach ($songs as $song) {
                $song->is_liked = in_array($song->id, $likedSongIds);
            }
            Log::info('After assigning is_liked', [
                'song_id' => $songs->first()?->id,
                'is_liked_value' => $songs->first()?->is_liked,
                'liked_song_ids' => $likedSongIds
            ]);
        }
        
        return response()->json([
            'success' => true,
            'data'    => SongResource::collection($songs),
        ]);
    }

    public function getPopularSongs(Request $request): JsonResponse
    {
        $limit  = min((int) $request->get('limit', 10), 100);
        /** @var \App\Models\User $user */
        $user = Auth::user();
        $userId = $user?->id;

        $songs = Song::query()
            ->with(['artist', 'album', 'genre'])
            ->withCount('song_likes')
            ->when($userId, function ($q) use ($userId) {
                $q->withExists([
                    'song_likes as is_liked' => fn($q) => $q->where('user_id', $userId)
                ]);
            })
            ->where('status', 'published')
            ->orderBy('total_plays', 'desc')
            ->limit($limit)
            ->get();
        log::info($userId);
        if ($userId && $songs->isNotEmpty()) {
            $songIds = $songs->pluck('id')->toArray();
            $likedSongIds = SongLike::where('user_id', $userId)
                ->whereIn('song_id', $songIds)
                ->pluck('song_id')
                ->toArray();
                
            foreach ($songs as $song) {
                $song->is_liked = in_array($song->id, $likedSongIds);
            }
        }
        
        return response()->json([
            'success' => true,
            'data'    => SongResource::collection($songs),
        ]);
    }

    public function getTopLikedSongs(Request $request): JsonResponse
    {
        $limit = min((int) $request->get('limit', 20), 100);
        /** @var \App\Models\User $user */
        $user   = Auth::user();
        $userId = $user?->id;

        $songs = Song::query()
            ->with(['artist', 'album', 'genre'])
            ->withCount('song_likes')
            ->when($userId, function ($q) use ($userId) {
                $q->withExists([
                    'song_likes as is_liked' => fn($q) => $q->where('user_id', $userId)
                ]);
            })
            ->where('status', 'published')
            ->orderBy('song_likes_count', 'desc')
            ->orderBy('total_likes', 'desc')
            ->limit($limit)
            ->get();

        return response()->json([
            'success' => true,
            'data'    => SongResource::collection($songs),
        ]);
    }

    public function __construct(
        protected CloudinaryService $cloudinaryService,
        protected LyricsService $lyricsService        
    ) {}

    public function add(Request $request): JsonResponse
    {
        if (is_array($request->input('lyrics'))) {
            $lyricsJson   = json_encode(array_values($request->input('lyrics')), JSON_UNESCAPED_UNICODE);
            $lyricsSource = 'lrc';
            $request->merge(['lyrics' => null]);
        }
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
            'quality'         => 'nullable|string|in:standard,high,lossless',
    
            // Lyrics: text thô HOẶC file .lrc (không bắt buộc cả hai)
            'lyrics'          => 'nullable|string',
            'lyrics_file'     => [
                                    'nullable',
                                    'file',
                                    'max:512',
                                    function ($attribute, $value, $fail) {
                                        $ext = strtolower($value->getClientOriginalExtension());
                                        if ($ext !== 'lrc') {
                                            $fail("The {$attribute} must be a .lrc file.");
                                        }
                                    },
                                ],
    
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
            'genre_id'        => 'nullable|exists:genres,id',
            'is_premium'      => 'nullable',
            'is_explicit'     => 'nullable',
            'is_featured'     => 'nullable',
            'allow_download'  => 'nullable',
        ]);
    
        // ── 2. Xử lý lyrics trước khi vào DB ──────────────────────────────────────
        //
        //  Ưu tiên: lyrics_file (.lrc) > lyrics (text thô)
        //
        //  - File .lrc  → parse ra array [{start, end, text}, ...]  → lưu JSON
        //  - Text thô   → lưu dạng [{start:0, end:0, text: "..."}, ...]  → JSON
        //  - Không có   → null
        //
        $lyricsJson     = null;
        $lyricsSource   = 'none'; // 'lrc' | 'raw' | 'none'
        $lrcParser = new ParseLrcFile();

        // ── Ưu tiên 1: Frontend gửi array đã parse sẵn ──
        if (is_array($request->input('lyrics'))) {
            $lyricsJson   = json_encode(array_values($request->input('lyrics')), JSON_UNESCAPED_UNICODE);
            $lyricsSource = 'lrc';
            $request->merge(['lyrics' => null]);

        // ── Ưu tiên 2: File .lrc ──
        } elseif ($request->hasFile('lyrics_file')) {
            $lrcContent  = file_get_contents($request->file('lyrics_file')->getRealPath());
            $parsedLines = $lrcParser->parseLrcFile($lrcContent);
            if (!empty($parsedLines)) {
                $lyricsJson   = json_encode($parsedLines, JSON_UNESCAPED_UNICODE);
                $lyricsSource = 'lrc';
            }

        // ── Ưu tiên 3: Raw text ──
        } elseif (!empty(trim($request->lyrics ?? ''))) {
            $rawLines = array_filter(
                array_map('trim', explode("\n", $request->lyrics)),
                fn($line) => $line !== ''
            );
            $segments = array_values(array_map(fn($line) => [
                'start' => 0, 'end' => 0, 'text' => $line,
            ], $rawLines));
            if (!empty($segments)) {
                $lyricsJson   = json_encode($segments, JSON_UNESCAPED_UNICODE);
                $lyricsSource = 'raw';
            }
        }
    
        // ── 3. Store audio ─────────────────────────────────────────────────────────
        DB::beginTransaction();
    
        try {
            $audioFile  = $request->file('audio_file');
            $storedPath = $audioFile->store('audio_originals', 'local');
    
            Log::info('Audio file stored', [
                'path'     => $storedPath,
                'size'     => $audioFile->getSize(),
                'original' => $audioFile->getClientOriginalName(),
            ]);
    
            // ── 4. Tạo Song ───────────────────────────────────────────────────────
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
                'descriptions'      => $request->descriptions   ?: null,
                'duration'          => $request->duration       ?? 0,
                'file_size'         => $audioFile->getSize(),
                'bitrate'           => $request->bitrate        ?? 320,
                'quality'           => $request->quality        ?? 'high',
                'cover_url'         => $request->cover_url      ?: null,
                'song_url'          => null,
                'song_url_hq'       => null,
                'song_url_lossless' => null,
                'lyrics'            => $lyricsJson,
                'lyrics_status'     => $lyricsSource === 'lrc' ? 'completed' : 'pending',
                'is_premium'        => filter_var($request->is_premium,    FILTER_VALIDATE_BOOLEAN),
                'is_explicit'       => filter_var($request->is_explicit,   FILTER_VALIDATE_BOOLEAN),
                'is_featured'       => filter_var($request->is_featured,   FILTER_VALIDATE_BOOLEAN),
                'allow_download'    => filter_var($request->allow_download, FILTER_VALIDATE_BOOLEAN),
                'partner_id'        => $request->partner_id     ?: null,
                'genre_id'          => $request->genre_id       ?: null,
                'status'            => $request->status,
            ]);
    
            DB::commit();
    
            // ── 5. Dispatch jobs ───────────────────────────────────────────────────
    
            ProcessSongAudio::dispatch(
                $song->id,
                $storedPath,
                $request->status ?? 'published'
            )->onQueue('audio');
    
            // GenerateLyricsJob chỉ chạy nếu KHÔNG phải từ .lrc
            // (lrc đã có timestamps đầy đủ rồi, không cần Groq)
            if ($lyricsSource !== 'lrc') {
                GenerateLyricsJob::dispatch(
                    $song->id,
                    $song->audio_public_id  
                )->onQueue('lyrics')->delay(now()->addSeconds(10)); 
            }
    
            Log::info("Song #{$song->id} queued", [
                'stored_path'   => $storedPath,
                'lyrics_source' => $lyricsSource,
                'lyrics_job'    => $lyricsSource !== 'lrc' ? 'dispatched' : 'skipped',
            ]);
    
            return response()->json([
                'success' => true,
                'message' => 'Song created. Audio is being processed in the background.',
                'data'    => [
                    'id'             => $song->id,
                    'title'          => $song->title,
                    'cover_url'      => $song->cover_url,
                    'status'         => $song->status,
                    'lyrics_status'  => $song->lyrics_status,
                    'lyrics_source'  => $lyricsSource,
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
            'quality'         => 'nullable|string|in:standard,high,lossless',
    
            // Lyrics: text thô HOẶC file .lrc
            'lyrics'          => 'nullable|string',
            'lyrics_file'     => [
                                    'nullable',
                                    'file',
                                    'max:512',
                                    function ($attribute, $value, $fail) {
                                        $ext = strtolower($value->getClientOriginalExtension());
                                        if ($ext !== 'lrc') {
                                            $fail("The {$attribute} must be a .lrc file.");
                                        }
                                    },
                                ],
    
            'cover_url'       => 'nullable|string|max:500',
            'cover_file'      => 'nullable|image|max:5120',
            'audio_file'      => [
                                    'nullable',
                                    'file',
                                    'max:51200',
                                    function ($attribute, $value, $fail) {
                                        $ext     = strtolower($value->getClientOriginalExtension());
                                        $allowed = ['mp3', 'wav', 'flac', 'aac', 'ogg', 'm4a'];
                                        if (!in_array($ext, $allowed)) {
                                            $fail("The {$attribute} must be a valid audio file.");
                                        }
                                    },
                                ],
            'status'          => 'nullable|string|in:draft,published,blocked',
            'partner_id'      => 'nullable|exists:partners,id',
            'genre_id'        => 'nullable|exists:genres,id',
            'is_premium'      => 'nullable',
            'is_explicit'     => 'nullable',
            'is_featured'     => 'nullable',
            'allow_download'  => 'nullable',
        ]);
    
        // ── 2. Xử lý lyrics ───────────────────────────────────────────────────────
        //
        //  Ưu tiên: lyrics_file (.lrc) > lyrics (text thô)
        //
        //  - File .lrc  → parse → [{start, end, text}] → JSON, status = completed, skip Groq
        //  - Text thô   → [{start:0, end:0, text}]     → JSON, status = pending,   run Groq
        //  - Không gửi  → giữ nguyên lyrics cũ trong DB
        //
        $lyricsJson   = null;   // null = không update lyrics
        $lyricsSource = null;   // 'lrc' | 'raw' | null
        $lrcParser = new ParseLrcFile();
        if ($request->hasFile('lyrics_file')) {
        // ── File .lrc ──
        $lrcContent  = file_get_contents($request->file('lyrics_file')->getRealPath());
        $parsedLines = $lrcParser->parseLrcFile($lrcContent);

        if (!empty($parsedLines)) {
            $lyricsJson   = json_encode($parsedLines, JSON_UNESCAPED_UNICODE);
            $lyricsSource = 'lrc';

            Log::info('LRC file parsed for update', [
                'song_id'    => $song->id,
                'line_count' => count($parsedLines),
            ]);
        }

        // ── Thêm case này: frontend gửi array trực tiếp ──
        } elseif (is_array($request->input('lyrics'))) {
            $arr = $request->input('lyrics');
            if (!empty($arr)) {
                $lyricsJson   = json_encode(array_values($arr), JSON_UNESCAPED_UNICODE);
                $lyricsSource = 'lrc';

                Log::info('Array lyrics stored for update', [
                    'song_id'    => $song->id,
                    'line_count' => count($arr),
                ]);
            }

        } elseif ($request->has('lyrics')) {
            // ── Text thô hoặc JSON string ──
            $raw = $request->lyrics;

            if (!empty($raw) && $raw !== '[object Object]') {
                $decoded = json_decode($raw, true);

                if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
                    $lyricsJson   = $raw;
                    $lyricsSource = 'lrc';
                } else {
                    $rawLines = array_filter(
                        array_map('trim', explode("\n", $raw)),
                        fn($line) => $line !== ''
                    );

                    $segments = array_values(array_map(fn($line) => [
                        'start' => 0,
                        'end'   => 0,
                        'text'  => $line,
                    ], $rawLines));

                    if (!empty($segments)) {
                        $lyricsJson   = json_encode($segments, JSON_UNESCAPED_UNICODE);
                        $lyricsSource = 'raw';

                        Log::info('Raw lyrics stored for update', [
                            'song_id'    => $song->id,
                            'line_count' => count($segments),
                        ]);
                    }
                }
            } else {
                $lyricsJson   = 'null_clear';
                $lyricsSource = null;
            }
        }
        log::info($lyricsJson);
        DB::beginTransaction();
    
        try {
            $updateData = [];
    
            // ── 3. Các field text thông thường ────────────────────────────────────
            $fields = [
                'title', 'slug', 'artist_id', 'album_id', 'track_number',
                'disc_number', 'isrc', 'copyright_owner', 'license_type',
                'duration', 'bitrate', 'quality', 'partner_id', 'genre_id', 'status',
            ];
    
            foreach ($fields as $field) {
                if ($request->has($field)) {
                    $updateData[$field] = $request->$field ?: null;
                }
            }
    
            if ($request->has('year')) {
                $updateData['year'] = $request->year ?: null;
            }
    
            foreach (['is_premium', 'is_explicit', 'is_featured', 'allow_download'] as $bool) {
                if ($request->has($bool)) {
                    $updateData[$bool] = filter_var($request->$bool, FILTER_VALIDATE_BOOLEAN);
                }
            }
    
            // ── 4. Ghi lyrics vào updateData ──────────────────────────────────────
            if ($lyricsJson === 'null_clear') {
                // Xóa lyrics
                $updateData['lyrics']        = null;
                $updateData['lyrics_status'] = 'pending';
            } elseif ($lyricsJson !== null) {
                $updateData['lyrics'] = $lyricsJson;
    
                if ($lyricsSource === 'lrc') {
                    // .lrc hoặc JSON đã có timestamps → hoàn chỉnh, không cần Groq
                    $updateData['lyrics_status']       = 'completed';
                    $updateData['lyrics_processed_at'] = now();
                    $updateData['lyrics_error']        = null;
                } else {
                    // Text thô → cần Groq align
                    $updateData['lyrics_status'] = 'pending';
                    $updateData['lyrics_error']  = null;
                }
            }
            // Nếu $lyricsJson === null → không gửi lyrics lên → giữ nguyên DB
    
            // ── 5. Cover image ────────────────────────────────────────────────────
            if ($request->hasFile('cover_file')) {
                $this->cloudinaryService->deleteImageByUrl($song->cover_url);
                $updateData['cover_url'] = $this->cloudinaryService->uploadImage(
                    $request->file('cover_file'),
                    'songs/partners'
                );
            } elseif ($request->has('cover_url')) {
                $updateData['cover_url'] = $request->cover_url ?: null;
            }
    
            // ── 6. Audio file mới ─────────────────────────────────────────────────
            $newAudioStoredPath = null;
            if ($request->hasFile('audio_file')) {
                $audioFile          = $request->file('audio_file');
                $newAudioStoredPath = $audioFile->store('audio_originals', 'local');
                $updateData['file_size'] = $audioFile->getSize();
    
                // Reset audio URLs — sẽ được điền lại sau khi transcode xong
                $updateData['song_url']          = null;
                $updateData['song_url_hq']       = null;
                $updateData['song_url_lossless'] = null;
    
                $this->cloudinaryService->deleteSongFolder($song->id);
    
                Log::info('New audio file stored', [
                    'song_id'  => $song->id,
                    'path'     => $newAudioStoredPath,
                    'original' => $audioFile->getClientOriginalName(),
                ]);
            }
    
            $song->update($updateData);
    
            DB::commit();
    
            // ── 7. Dispatch jobs sau commit ───────────────────────────────────────
    
            // Audio processing nếu có file mới
            if ($newAudioStoredPath) {
                ProcessSongAudio::dispatch(
                    $song->id,
                    $newAudioStoredPath,
                    $song->status
                )->onQueue('audio')->delay(now()->addSeconds(5));
    
                Log::info("Song #{$song->id} re-queued for audio processing");
            }
    
            // GenerateLyricsJob chỉ chạy khi lyrics là text thô (raw)
            // - lrc / JSON đã có timestamps → skip
            // - null (không gửi) → skip
            if ($lyricsSource === 'raw') {
                GenerateLyricsJob::dispatch(
                    $song->id,
                    $song->audio_public_id  // field lưu public_id Cloudinary
                )->onQueue('lyrics')->delay(now()->addSeconds(10));
    
                Log::info("Song #{$song->id} queued for lyrics alignment", [
                    'lyrics_source' => $lyricsSource,
                ]);
            }
    
            return response()->json([
                'success' => true,
                'message' => $newAudioStoredPath
                    ? 'Song updated. New audio is being processed.'
                    : 'Song updated successfully.',
                'data' => [
                    'id'            => $song->id,
                    'title'         => $song->title,
                    'cover_url'     => $song->cover_url,
                    'status'        => $song->status,
                    'lyrics_status' => $song->fresh()->lyrics_status,
                    'lyrics_source' => $lyricsSource ?? 'unchanged',
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

    public function getLyricsSong(Song $song) {
        return response()->json([
            'lyrics' => $song->lyrics,
            'lyrics_status' => $song->lyrics_status,
        ]);
    }

}

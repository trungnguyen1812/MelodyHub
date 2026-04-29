<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\Playlist;
use App\Models\PlaylistSong;
use App\Models\Song;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class PlaylistController extends Controller
{
    // ── GET /playlists (all public + my private) ──────────────────────────────
    public function index(Request $request)
    {
        $user = $request->user();
        
        $query = Playlist::query()
            ->with(['user' => function($q) {
                $q->select('id', 'name', 'avatar_url', 'email');
            }])
            ->withCount('songs');
        
        if ($user) {
            $query->where(function($q) use ($user) {
                $q->where('is_public', true)
                  ->orWhere('user_id', $user->id);
            });
        } else {
            $query->where('is_public', true);
        }
        
        $playlists = $query->orderByDesc('created_at')->get();
        
        return response()->json([
            'data' => $playlists->map(fn($p) => $this->formatPlaylist($p))
        ]);
    }

    // ── GET /playlists/my (only my playlists) ────────────────────────────────
    public function myPlaylists(Request $request)
    {
        $user = $request->user();

        $playlists = Playlist::where('user_id', $user->id)
            ->with(['user' => function($q) {
                $q->select('id', 'name', 'avatar_url', 'email');
            }])
            ->withCount('songs')
            ->orderByDesc('created_at')
            ->get();

        return response()->json([
            'data' => $playlists->map(fn($p) => $this->formatPlaylist($p))
        ]);
    }

    // ── GET /users/{userId}/playlists (public playlists of a user) ───────────
    public function userPlaylists(Request $request, $userId)
    {
        $viewer = $request->user();

        $query = Playlist::where('user_id', $userId)
            ->with(['user' => function($q) {
                $q->select('id', 'name', 'avatar_url', 'email');
            }])
            ->withCount('songs');

        // If viewer is the owner, show all; otherwise only public
        if (!$viewer || $viewer->id != $userId) {
            $query->where('is_public', true);
        }

        $playlists = $query->orderByDesc('created_at')->get();

        return response()->json([
            'data' => $playlists->map(fn($p) => $this->formatPlaylist($p))
        ]);
    }

    // ── POST /playlists ──────────────────────────────────────────────────────
    public function store(Request $request)
    {
        $user = $request->user();

        $validated = $request->validate([
            'name'        => 'required|string|max:100',
            'description' => 'nullable|string|max:500',
            'is_public'   => 'nullable|boolean',
            'cover'       => 'nullable|image|mimes:jpeg,png,jpg,webp|max:2048',
        ]);

        $coverPath = null;
        if ($request->hasFile('cover')) {
            $coverPath = $request->file('cover')->store('playlist_covers', 'public');
        }

        $playlist = Playlist::create([
            'user_id'     => $user->id,
            'name'        => $validated['name'],
            'slug'        => Str::slug($validated['name']) . '-' . Str::random(5),
            'description' => $validated['description'] ?? null,
            'is_public'   => $validated['is_public'] ?? false,
            'cover_url'   => $coverPath,
            'status'      => 'active',
            'total_songs' => 0,
            'total_duration' => 0,
        ]);

        return response()->json([
            'message' => 'Playlist created',
            'data'    => $this->formatPlaylist($playlist->load('user')),
        ], 201);
    }

    // ── GET /playlists/{id} ──────────────────────────────────────────────────
    public function show(Request $request, $id)
    {
        $user = $request->user();

        $query = Playlist::query()->with(['user' => function($q) {
            $q->select('id', 'name', 'avatar_url');
        }]);

        if (is_numeric($id)) {
            $query->where('id', (int) $id);
        } else {
            $query->where('slug', $id);
        }

        $playlist = $query->first();

        if (!$playlist) {
            return response()->json(['message' => 'Playlist not found'], 404);
        }

        $isOwner = $user && $user->id === $playlist->user_id;

        if (!$isOwner && !$playlist->is_public) {
            return response()->json(['message' => 'This playlist is private'], 403);
        }

        $songs = $playlist->songs()
            ->with(['artist:id,name,slug', 'album:id,title,cover_url'])
            ->orderBy('playlist_songs.position')
            ->get()
            ->map(fn($s) => $this->formatSong($s, $playlist->id));

        return response()->json([
            'data'  => $this->formatPlaylist($playlist),
            'songs' => $songs,
        ]);
    }

    // ── PUT /playlists/{id} ──────────────────────────────────────────────────
    public function update(Request $request, $id)
    {
        $user     = $request->user();
        $playlist = $this->findOwned($id, $user->id);

        $validated = $request->validate([
            'name'        => 'sometimes|string|max:100',
            'description' => 'nullable|string|max:500',
            'is_public'   => 'nullable|boolean',
            'cover'       => 'nullable|image|mimes:jpeg,png,jpg,webp|max:2048',
        ]);

        if ($request->hasFile('cover')) {
            if ($playlist->cover_url) {
                Storage::disk('public')->delete($playlist->cover_url);
            }
            $validated['cover_url'] = $request->file('cover')->store('playlist_covers', 'public');
        }

        unset($validated['cover']);
        $playlist->update($validated);

        return response()->json([
            'message' => 'Playlist updated',
            'data'    => $this->formatPlaylist($playlist->fresh()->load('user')),
        ]);
    }

    // ── DELETE /playlists/{id} ───────────────────────────────────────────────
    public function destroy(Request $request, $id)
    {
        $user     = $request->user();
        $playlist = $this->findOwned($id, $user->id);

        if ($playlist->cover_url) {
            Storage::disk('public')->delete($playlist->cover_url);
        }

        $playlist->delete();

        return response()->json(['message' => 'Playlist deleted']);
    }

    // ── POST /playlists/{id}/songs ───────────────────────────────────────────
    public function addSong(Request $request, $id)
    {
        $user     = $request->user();
        $playlist = $this->findOwned($id, $user->id);

        $request->validate(['song_id' => 'required|integer|exists:songs,id']);
        $songId = $request->input('song_id');

        if ($playlist->songs()->where('songs.id', $songId)->exists()) {
            return response()->json(['message' => 'Song already in playlist'], 409);
        }

        $position = ($playlist->songs()->max('playlist_songs.position') ?? 0) + 1;

        PlaylistSong::create([
            'playlist_id' => $playlist->id,
            'song_id'     => $songId,
            'added_by'    => $user->id,
            'position'    => $position,
            'added_at'    => now(),
        ]);

        $song = Song::find($songId);
        $playlist->increment('total_songs');
        $playlist->increment('total_duration', $song->duration ?? 0);

        return response()->json(['message' => 'Song added to playlist']);
    }

    // ── DELETE /playlists/{id}/songs/{songId} ────────────────────────────────
    public function removeSong(Request $request, $id, $songId)
    {
        $user     = $request->user();
        $playlist = $this->findOwned($id, $user->id);

        $deleted = PlaylistSong::where('playlist_id', $playlist->id)
            ->where('song_id', $songId)
            ->delete();

        if (!$deleted) {
            return response()->json(['message' => 'Song not found in playlist'], 404);
        }

        $song = Song::find($songId);
        $playlist->decrement('total_songs');
        $playlist->decrement('total_duration', $song->duration ?? 0);

        $songs = PlaylistSong::where('playlist_id', $playlist->id)
            ->orderBy('position')
            ->get();
        foreach ($songs as $i => $ps) {
            $ps->update(['position' => $i + 1]);
        }

        return response()->json(['message' => 'Song removed from playlist']);
    }

    // ── POST /playlists/{id}/reorder ─────────────────────────────────────────
    public function reorder(Request $request, $id)
    {
        $user     = $request->user();
        $playlist = $this->findOwned($id, $user->id);

        $request->validate([
            'song_ids'   => 'required|array',
            'song_ids.*' => 'integer',
        ]);

        foreach ($request->input('song_ids') as $pos => $songId) {
            PlaylistSong::where('playlist_id', $playlist->id)
                ->where('song_id', $songId)
                ->update(['position' => $pos + 1]);
        }

        return response()->json(['message' => 'Playlist reordered']);
    }

    // ── Helpers ──────────────────────────────────────────────────────────────
    private function findOwned($id, $userId): Playlist
    {
        $query = Playlist::where('user_id', $userId);

        if (is_numeric($id)) {
            $query->where('id', (int) $id);
        } else {
            $query->where('slug', $id);
        }

        $playlist = $query->first();

        if (!$playlist) {
            abort(404, 'Playlist not found');
        }
        return $playlist;
    }

    // ── Format methods ───────────────────────────────────────────────────────
    private function formatPlaylist(Playlist $p): array
    {
        return [
            'id'             => $p->id,
            'user_id'        => $p->user_id,
            'name'           => $p->name,
            'slug'           => $p->slug,
            'description'    => $p->description,
            'cover_url'      => $p->cover_url 
                ? (str_starts_with($p->cover_url, 'http') 
                    ? $p->cover_url 
                    : asset('storage/' . $p->cover_url))
                : null,
            'is_public'      => $p->is_public,
            'total_songs'    => $p->total_songs ?? $p->songs_count ?? 0,
            'total_duration' => $p->total_duration ?? 0,
            'status'         => $p->status,
            'created_at'     => $p->created_at,
            'updated_at'     => $p->updated_at,
            'user'           => $p->relationLoaded('user') && $p->user ? [
                'id'     => $p->user->id,
                'name'   => $p->user->name,
                'avatar_url' => $p->user->avatar_url 
                    ? (str_starts_with($p->user->avatar_url, 'http') 
                        ? $p->user->avatar_url 
                        : asset('storage/' . $p->user->avatar_url))
                    : null,
                'email'  => $p->user->email,
            ] : null,
        ];
    }

    private function formatSong(Song $s, $playlistId = null): array
    {
        return [
            'id'          => $s->id,
            'title'       => $s->title,
            'slug'        => $s->slug,
            'cover_url'   => $s->cover_url 
                ? (str_starts_with($s->cover_url, 'http') 
                    ? $s->cover_url 
                    : asset('storage/' . $s->cover_url))
                : null,
            'song_url'    => $s->song_url,
            'duration'    => $s->duration,
            'is_premium'  => $s->is_premium,
            'is_explicit' => $s->is_explicit,
            'artist'      => $s->artist ? [
                'id'   => $s->artist->id,
                'name' => $s->artist->name,
                'slug' => $s->artist->slug,
            ] : null,
            'album'       => $s->album ? [
                'id'        => $s->album->id,
                'title'     => $s->album->title,
                'cover_url' => $s->album->cover_url 
                    ? (str_starts_with($s->album->cover_url, 'http') 
                        ? $s->album->cover_url 
                        : asset('storage/' . $s->album->cover_url))
                    : null,
            ] : null,
            'position'    => $s->pivot->position ?? null,
            'added_at'    => $s->pivot->added_at ?? null,
        ];
    }
}
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
    // ── GET /playlists  (my playlists) ──────────────────────────────────────
    public function index(Request $request)
    {
        $user = $request->user();

        $playlists = Playlist::where('user_id', $user->id)
            ->withCount('songs')
            ->orderByDesc('created_at')
            ->get()
            ->map(fn($p) => $this->formatPlaylist($p));

        return response()->json(['data' => $playlists]);
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
        ]);

        return response()->json([
            'message' => 'Playlist created',
            'data'    => $this->formatPlaylist($playlist),
        ], 201);
    }

    // ── GET /playlists/{id} ──────────────────────────────────────────────────
    public function show(Request $request, $id)
    {
        $user     = $request->user();
        $playlist = $this->findOwned($id, $user->id);

        $songs = $playlist->songs()
            ->with(['artist:id,name,slug', 'album:id,title,cover_url'])
            ->orderBy('playlist_songs.position')
            ->get()
            ->map(fn($s) => $this->formatSong($s));

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
            'data'    => $this->formatPlaylist($playlist->fresh()),
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

        // Prevent duplicate
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

        // Re-order positions
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
        $playlist = Playlist::where('id', $id)->where('user_id', $userId)->first();
        if (!$playlist) {
            abort(404, 'Playlist not found');
        }
        return $playlist;
    }

    private function formatPlaylist(Playlist $p): array
    {
        return [
            'id'           => $p->id,
            'name'         => $p->name,
            'slug'         => $p->slug,
            'description'  => $p->description,
            'cover_url'    => $p->cover_url
                ? (str_starts_with($p->cover_url, 'http') ? $p->cover_url : asset('storage/' . $p->cover_url))
                : null,
            'is_public'    => $p->is_public,
            'total_songs'  => $p->total_songs,
            'total_duration' => $p->total_duration,
            'status'       => $p->status,
            'created_at'   => $p->created_at,
            'updated_at'   => $p->updated_at,
        ];
    }

    private function formatSong(Song $s): array
    {
        return [
            'id'         => $s->id,
            'title'      => $s->title,
            'slug'       => $s->slug,
            'cover_url'  => $s->cover_url,
            'song_url'   => $s->song_url,
            'duration'   => $s->duration,
            'is_premium' => $s->is_premium,
            'is_explicit'=> $s->is_explicit,
            'artist'     => $s->artist ? ['id' => $s->artist->id, 'name' => $s->artist->name, 'slug' => $s->artist->slug] : null,
            'album'      => $s->album  ? ['id' => $s->album->id,  'title' => $s->album->title, 'cover_url' => $s->album->cover_url] : null,
            'position'   => $s->pivot->position ?? null,
            'added_at'   => $s->pivot->added_at ?? null,
        ];
    }
}

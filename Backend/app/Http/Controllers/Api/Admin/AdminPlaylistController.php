<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Playlist;
use App\Models\PlaylistSong;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class AdminPlaylistController extends Controller
{
    // ── GET /admin/playlists ─────────────────────────────────────────────────
    public function index(Request $request)
    {
        $query = Playlist::with(['user' => fn($q) => $q->select('id', 'name', 'email', 'avatar_url')])
            ->withCount('songs');

        // Search
        if ($keyword = $request->get('q')) {
            $query->where(function ($q) use ($keyword) {
                $q->where('name', 'like', "%{$keyword}%")
                  ->orWhere('description', 'like', "%{$keyword}%")
                  ->orWhere('slug', 'like', "%{$keyword}%")
                  ->orWhereHas('user', fn($u) => $u->where('name', 'like', "%{$keyword}%")
                                                    ->orWhere('email', 'like', "%{$keyword}%"));
            });
        }

        // Filter by status
        if ($status = $request->get('status')) {
            if ($status === 'public')  $query->where('is_public', true);
            if ($status === 'private') $query->where('is_public', false);
        }

        $playlists = $query->orderByDesc('created_at')->get();

        // Statistics
        $stats = [
            'total'   => Playlist::count(),
            'public'  => Playlist::where('is_public', true)->count(),
            'private' => Playlist::where('is_public', false)->count(),
        ];

        return response()->json([
            'success' => true,
            'data'    => $playlists->map(fn($p) => $this->format($p)),
            'stats'   => $stats,
        ]);
    }

    // ── GET /admin/playlists/{id} ────────────────────────────────────────────
    public function show($id)
    {
        $playlist = Playlist::with(['user' => fn($q) => $q->select('id', 'name', 'email', 'avatar_url')])
            ->findOrFail($id);

        $songs = $playlist->songs()
            ->with(['artist:id,name,slug', 'album:id,title,cover_url'])
            ->orderBy('playlist_songs.position')
            ->get()
            ->map(fn($s) => [
                'id'          => $s->id,
                'title'       => $s->title,
                'cover_url'   => $s->cover_url
                    ? (str_starts_with($s->cover_url, 'http') ? $s->cover_url : asset('storage/' . $s->cover_url))
                    : null,
                'duration'    => $s->duration,
                'is_explicit' => $s->is_explicit,
                'artist'      => $s->artist ? ['id' => $s->artist->id, 'name' => $s->artist->name] : null,
                'album'       => $s->album  ? ['id' => $s->album->id,  'title' => $s->album->title] : null,
                'position'    => $s->pivot->position ?? null,
                'added_at'    => $s->pivot->added_at ?? null,
            ]);

        return response()->json([
            'success' => true,
            'data'    => $this->format($playlist),
            'songs'   => $songs,
        ]);
    }

    // ── PATCH /admin/playlists/{id}/status ───────────────────────────────────
    public function updateStatus(Request $request, $id)
    {
        $request->validate([
            'is_public' => 'required|boolean',
        ]);

        $playlist = Playlist::findOrFail($id);
        $playlist->update(['is_public' => $request->boolean('is_public')]);

        return response()->json([
            'success' => true,
            'message' => 'Playlist status updated',
            'data'    => $this->format($playlist->fresh()),
        ]);
    }

    // ── DELETE /admin/playlists/{id} ─────────────────────────────────────────
    public function destroy($id)
    {
        $playlist = Playlist::findOrFail($id);

        if ($playlist->cover_url && !str_starts_with($playlist->cover_url, 'http')) {
            Storage::disk('public')->delete($playlist->cover_url);
        }

        PlaylistSong::where('playlist_id', $playlist->id)->delete();
        $playlist->delete();

        return response()->json([
            'success'    => true,
            'message'    => 'Playlist deleted successfully',
            'deleted_id' => $id,
        ]);
    }

    // ── DELETE /admin/playlists/{id}/songs/{songId} ──────────────────────────
    public function removeSong($id, $songId)
    {
        $playlist = Playlist::findOrFail($id);

        $deleted = PlaylistSong::where('playlist_id', $playlist->id)
            ->where('song_id', $songId)
            ->delete();

        if (!$deleted) {
            return response()->json(['success' => false, 'message' => 'Song not found in playlist'], 404);
        }

        $playlist->decrement('total_songs');

        return response()->json(['success' => true, 'message' => 'Song removed from playlist']);
    }

    // ── Helper ───────────────────────────────────────────────────────────────
    private function format(Playlist $p): array
    {
        return [
            'id'             => $p->id,
            'user_id'        => $p->user_id,
            'name'           => $p->name,
            'slug'           => $p->slug,
            'description'    => $p->description,
            'cover_url'      => $p->cover_url
                ? (str_starts_with($p->cover_url, 'http') ? $p->cover_url : asset('storage/' . $p->cover_url))
                : null,
            'is_public'      => $p->is_public,
            'total_songs'    => $p->total_songs ?? $p->songs_count ?? 0,
            'total_duration' => $p->total_duration ?? 0,
            'total_plays'    => $p->total_plays ?? 0,
            'status'         => $p->status,
            'created_at'     => $p->created_at,
            'updated_at'     => $p->updated_at,
            'user'           => $p->relationLoaded('user') && $p->user ? [
                'id'         => $p->user->id,
                'name'       => $p->user->name,
                'email'      => $p->user->email,
                'avatar_url' => $p->user->avatar_url
                    ? (str_starts_with($p->user->avatar_url, 'http') ? $p->user->avatar_url : asset('storage/' . $p->user->avatar_url))
                    : null,
            ] : null,
        ];
    }
}

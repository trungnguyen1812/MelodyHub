import { defineStore } from 'pinia'
import { ref } from 'vue'
import playlistService from '@/modules/client/services/playlists/playlist.service'

export interface PlaylistUser {
  id: number
  name: string
  avatar_url: string | null
  email?: string
}

export interface PlaylistSong {
  id: number
  title: string
  slug: string
  cover_url: string | null
  song_url: string | null
  duration: number
  is_premium: boolean
  is_explicit: boolean
  artist: { id: number; name: string; slug: string } | null
  album: { id: number; title: string; cover_url: string | null } | null
  position: number
  added_at: string | null
}

export interface Playlist {
  id: number
  user_id: number
  name: string
  slug: string | null
  description: string | null
  cover_url: string | null
  is_public: boolean
  total_songs: number
  total_duration: number
  status: string
  created_at: string
  updated_at: string
  user: PlaylistUser | null
}

export const usePlaylistStore = defineStore('playlist', () => {
  // ── State ──────────────────────────────────────────────────────────────────
  const playlists     = ref<Playlist[]>([])
  const current       = ref<Playlist | null>(null)
  const currentSongs  = ref<PlaylistSong[]>([])
  const loading       = ref(false)
  const loadingDetail = ref(false)
  const error         = ref<string | null>(null)

  // ── Actions ────────────────────────────────────────────────────────────────

  /** Tất cả public playlists + own nếu login */
  async function fetchAll() {
    loading.value = true
    error.value = null
    try {
      const res = await playlistService.getAll()
      playlists.value = res.data ?? []
    } catch (e: any) {
      if (e?.response?.status === 401) {
        playlists.value = []
      } else {
        error.value = e?.response?.data?.message ?? 'Failed to load playlists'
      }
    } finally {
      loading.value = false
    }
  }

  /** Chỉ playlists của mình (cần login) */
  async function fetchMyPlaylists() {
    loading.value = true
    error.value = null
    try {
      const res = await playlistService.getMyPlaylists()
      playlists.value = res.data ?? []
    } catch (e: any) {
      error.value = e?.response?.data?.message ?? 'Failed to load playlists'
    } finally {
      loading.value = false
    }
  }

  /** Playlists public của 1 user cụ thể */
  async function fetchUserPlaylists(userId: number) {
    loading.value = true
    error.value = null
    try {
      const res = await playlistService.getUserPlaylists(userId)
      playlists.value = res.data ?? []
    } catch (e: any) {
      error.value = e?.response?.data?.message ?? 'Failed to load playlists'
    } finally {
      loading.value = false
    }
  }

  async function fetchById(id: number | string) {
    loadingDetail.value = true
    error.value = null
    try {
      const res = await playlistService.getById(id)
      current.value = res.data
      currentSongs.value = res.songs ?? []
    } catch (e: any) {
      error.value = e?.response?.data?.message ?? 'Failed to load playlist'
      current.value = null
      currentSongs.value = []
    } finally {
      loadingDetail.value = false
    }
  }

  async function create(payload: { name: string; description?: string; is_public?: boolean; cover?: File | null }) {
    const res = await playlistService.create(payload)
    playlists.value.unshift(res.data)
    return res.data as Playlist
  }

  async function update(id: number, payload: { name?: string; description?: string; is_public?: boolean; cover?: File | null }) {
    const res = await playlistService.update(id, payload)
    const idx = playlists.value.findIndex(p => p.id === id)
    if (idx !== -1) playlists.value[idx] = res.data
    if (current.value?.id === id) current.value = res.data
    return res.data as Playlist
  }

  async function deletePlaylist(id: number) {
    await playlistService.delete(id)
    playlists.value = playlists.value.filter(p => p.id !== id)
    if (current.value?.id === id) {
      current.value = null
      currentSongs.value = []
    }
  }

  async function addSong(playlistId: number, songId: number) {
    await playlistService.addSong(playlistId, songId)
    if (current.value?.id === playlistId) await fetchById(playlistId)
    const p = playlists.value.find(p => p.id === playlistId)
    if (p) p.total_songs++
  }

  async function removeSong(playlistId: number, songId: number) {
    await playlistService.removeSong(playlistId, songId)
    currentSongs.value = currentSongs.value.filter(s => s.id !== songId)
    if (current.value) current.value.total_songs = Math.max(0, current.value.total_songs - 1)
    const p = playlists.value.find(p => p.id === playlistId)
    if (p) p.total_songs = Math.max(0, p.total_songs - 1)
  }

  return {
    // state
    playlists,
    current,
    currentSongs,
    loading,
    loadingDetail,
    error,
    // actions
    fetchAll,
    fetchMyPlaylists,
    fetchUserPlaylists,
    fetchById,
    create,
    update,
    delete: deletePlaylist,
    addSong,
    removeSong,
  }
})

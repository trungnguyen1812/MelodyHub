import { defineStore } from 'pinia'
import { ref } from 'vue'
import adminPlaylistService from '@/modules/admin/services/playlists/playlists.service'

export interface AdminPlaylistUser {
  id: number
  name: string
  email: string
  avatar_url: string | null
}

export interface AdminPlaylistSong {
  id: number
  title: string
  cover_url: string | null
  duration: number
  is_explicit: boolean
  artist: { id: number; name: string } | null
  album: { id: number; title: string } | null
  position: number | null
  added_at: string | null
}

export interface AdminPlaylist {
  id: number
  user_id: number
  name: string
  slug: string | null
  description: string | null
  cover_url: string | null
  is_public: boolean
  total_songs: number
  total_duration: number
  total_plays: number
  status: string
  created_at: string
  updated_at: string
  user: AdminPlaylistUser | null
}

export interface AdminPlaylistStats {
  total: number
  public: number
  private: number
}

export const useAdminPlaylistStore = defineStore('admin_playlist', () => {
  const playlists  = ref<AdminPlaylist[]>([])
  const current    = ref<AdminPlaylist | null>(null)
  const songs      = ref<AdminPlaylistSong[]>([])
  const stats      = ref<AdminPlaylistStats>({ total: 0, public: 0, private: 0 })
  const loading    = ref(false)
  const loadingDetail = ref(false)
  const error      = ref<string | null>(null)

  async function fetchAll(params?: { q?: string; status?: string }) {
    loading.value = true
    error.value = null
    try {
      const res = await adminPlaylistService.getAll(params)
      playlists.value = res.data ?? []
      stats.value = res.stats ?? { total: 0, public: 0, private: 0 }
    } catch (e: any) {
      error.value = e?.response?.data?.message ?? 'Failed to load playlists'
    } finally {
      loading.value = false
    }
  }

  async function fetchById(id: number) {
    loadingDetail.value = true
    error.value = null
    try {
      const res = await adminPlaylistService.getById(id)
      current.value = res.data
      songs.value = res.songs ?? []
    } catch (e: any) {
      error.value = e?.response?.data?.message ?? 'Failed to load playlist'
    } finally {
      loadingDetail.value = false
    }
  }

  async function updateStatus(id: number, is_public: boolean) {
    const res = await adminPlaylistService.updateStatus(id, is_public)
    const idx = playlists.value.findIndex(p => p.id === id)
    if (idx !== -1) playlists.value[idx] = res.data
    if (current.value?.id === id) current.value = res.data
    return res.data
  }

  async function deletePlaylist(id: number) {
    await adminPlaylistService.delete(id)
    playlists.value = playlists.value.filter(p => p.id !== id)
    stats.value.total = Math.max(0, stats.value.total - 1)
    if (current.value?.id === id) current.value = null
  }

  async function removeSong(playlistId: number, songId: number) {
    await adminPlaylistService.removeSong(playlistId, songId)
    songs.value = songs.value.filter(s => s.id !== songId)
    if (current.value?.id === playlistId) {
      current.value.total_songs = Math.max(0, current.value.total_songs - 1)
    }
  }

  return {
    playlists, current, songs, stats, loading, loadingDetail, error,
    fetchAll, fetchById, updateStatus, deletePlaylist, removeSong,
  }
})

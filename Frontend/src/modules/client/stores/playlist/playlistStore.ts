import { defineStore } from 'pinia'
import playlistService from '@/modules/client/services/playlists/playlist.service'

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
}

interface PlaylistState {
  playlists: Playlist[]
  current: Playlist | null
  currentSongs: PlaylistSong[]
  loading: boolean
  loadingDetail: boolean
  error: string | null
}

export const usePlaylistStore = defineStore('playlist', {
  state: (): PlaylistState => ({
    playlists: [],
    current: null,
    currentSongs: [],
    loading: false,
    loadingDetail: false,
    error: null,
  }),

  actions: {
    async fetchAll() {
      this.loading = true
      this.error = null
      try {
        const res = await playlistService.getAll()
        this.playlists = res.data ?? []
      } catch (e: any) {
        this.error = e?.response?.data?.message ?? 'Failed to load playlists'
      } finally {
        this.loading = false
      }
    },

    async fetchById(id: number) {
      this.loadingDetail = true
      this.error = null
      try {
        const res = await playlistService.getById(id)
        this.current = res.data
        this.currentSongs = res.songs ?? []
      } catch (e: any) {
        this.error = e?.response?.data?.message ?? 'Failed to load playlist'
      } finally {
        this.loadingDetail = false
      }
    },

    async create(payload: { name: string; description?: string; is_public?: boolean; cover?: File | null }) {
      const res = await playlistService.create(payload)
      this.playlists.unshift(res.data)
      return res.data as Playlist
    },

    async update(id: number, payload: { name?: string; description?: string; is_public?: boolean; cover?: File | null }) {
      const res = await playlistService.update(id, payload)
      const idx = this.playlists.findIndex(p => p.id === id)
      if (idx !== -1) this.playlists[idx] = res.data
      if (this.current?.id === id) this.current = res.data
      return res.data as Playlist
    },

    async delete(id: number) {
      await playlistService.delete(id)
      this.playlists = this.playlists.filter(p => p.id !== id)
      if (this.current?.id === id) { this.current = null; this.currentSongs = [] }
    },

    async addSong(playlistId: number, songId: number) {
      await playlistService.addSong(playlistId, songId)
      // Refresh detail if open
      if (this.current?.id === playlistId) await this.fetchById(playlistId)
      // Update count in list
      const p = this.playlists.find(p => p.id === playlistId)
      if (p) p.total_songs++
    },

    async removeSong(playlistId: number, songId: number) {
      await playlistService.removeSong(playlistId, songId)
      this.currentSongs = this.currentSongs.filter(s => s.id !== songId)
      if (this.current) this.current.total_songs = Math.max(0, this.current.total_songs - 1)
      const p = this.playlists.find(p => p.id === playlistId)
      if (p) p.total_songs = Math.max(0, p.total_songs - 1)
    },
  },
})

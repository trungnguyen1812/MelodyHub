import api from '@/plugins/axios'

export interface PlaylistPayload {
  name: string
  description?: string
  is_public?: boolean
  cover?: File | null
}

class PlaylistService {
  async getAll() {
    const res = await api.get('/playlists')
    return res.data
  }

  async getById(id: number) {
    const res = await api.get(`/playlists/${id}`)
    return res.data
  }

  async create(payload: PlaylistPayload) {
    const form = new FormData()
    form.append('name', payload.name)
    if (payload.description) form.append('description', payload.description)
    form.append('is_public', payload.is_public ? '1' : '0')
    if (payload.cover) form.append('cover', payload.cover)
    const res = await api.post('/playlists', form, {
      headers: { 'Content-Type': 'multipart/form-data' },
    })
    return res.data
  }

  async update(id: number, payload: Partial<PlaylistPayload>) {
    const form = new FormData()
    if (payload.name !== undefined)        form.append('name', payload.name)
    if (payload.description !== undefined) form.append('description', payload.description ?? '')
    if (payload.is_public !== undefined)   form.append('is_public', payload.is_public ? '1' : '0')
    if (payload.cover)                     form.append('cover', payload.cover)
    const res = await api.post(`/playlists/${id}`, form, {
      headers: { 'Content-Type': 'multipart/form-data' },
    })
    return res.data
  }

  async delete(id: number) {
    const res = await api.delete(`/playlists/${id}`)
    return res.data
  }

  async addSong(playlistId: number, songId: number) {
    const res = await api.post(`/playlists/${playlistId}/songs`, { song_id: songId })
    return res.data
  }

  async removeSong(playlistId: number, songId: number) {
    const res = await api.delete(`/playlists/${playlistId}/songs/${songId}`)
    return res.data
  }

  async reorder(playlistId: number, songIds: number[]) {
    const res = await api.post(`/playlists/${playlistId}/reorder`, { song_ids: songIds })
    return res.data
  }
}

export default new PlaylistService()

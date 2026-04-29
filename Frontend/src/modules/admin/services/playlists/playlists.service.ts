import adminApi from '@/plugins/axios_admin'

class AdminPlaylistService {
  async getAll(params?: { q?: string; status?: string }) {
    const res = await adminApi.get('/playlists', { params })
    return res.data
  }

  async getById(id: number) {
    const res = await adminApi.get(`/playlists/${id}`)
    return res.data
  }

  async updateStatus(id: number, is_public: boolean) {
    const res = await adminApi.patch(`/playlists/${id}/status`, { is_public })
    return res.data
  }

  async delete(id: number) {
    const res = await adminApi.delete(`/playlists/${id}`)
    return res.data
  }

  async removeSong(playlistId: number, songId: number) {
    const res = await adminApi.delete(`/playlists/${playlistId}/songs/${songId}`)
    return res.data
  }
}

export default new AdminPlaylistService()

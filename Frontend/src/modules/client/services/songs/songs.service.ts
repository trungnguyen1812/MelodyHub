import clientApi from '@/plugins/axios';
import type { CreateSongPayload } from "@/modules/client/interfaces/songs/create-song.payload";
import type { SongFilterParams } from '@/interfaces/songs.interface'
import type { UpdateSongPayload } from "@/modules/client/interfaces/songs/update_song.payload";

class SongService {

    async getAllSongs(params: SongFilterParams = {}) {
        return clientApi.get('/songs/allSongs', { params })
    }
 
    async getNewSongs(limit: number = 10) {
        return clientApi.get('/songs/new', { params: { limit } });
    }

    async getPopularSongs(limit: number = 10) {
        return clientApi.get('/songs/popular', { params: { limit } });
    }

    async getTopLikedSongs(limit: number = 20) {
        return clientApi.get('/songs/top-liked', { params: { limit } });
    }

    async getSong(idOrSlug: string | number) {
        return clientApi.get(`/songs/${idOrSlug}`)
    }

    async addSong(payload: CreateSongPayload) {
        return clientApi.post('/songs/add', payload, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });
    }

    async deleteSong(id: number) {
        return await clientApi.delete(`/songs/delete/${id}`);
    }

    async deleteMultipleSongs(ids: number[]) {
        return await clientApi.delete(`/songs/delete-multiple`, { data: { ids } });
    }
    async updateSong(id: number, payload: UpdateSongPayload) {
        const formData = new FormData();
        
        Object.entries(payload).forEach(([key, value]) => {
            if (value !== undefined && value !== null) {
                formData.append(key, value as any);
            }
        });

        return await clientApi.post(`/songs/update/${id}`, formData, {
            headers: { 'Content-Type': 'multipart/form-data' },
        });
    }

    async getArtistStatistics(){
        const res = await clientApi.get("/artists/statistics");
        return res.data;
    }

    async getLyrics(songId: number) {
        return clientApi.get(`/songs/${songId}/lyrics`)
    }

    async recordPlay(songId: number, payload: {
        played_duration: number
        play_percentage: number
        is_completed: boolean
        playlist_id?: number  
    }) {
        return clientApi.post(`/songs/${songId}/play`, payload)
    }
}

export default new SongService();
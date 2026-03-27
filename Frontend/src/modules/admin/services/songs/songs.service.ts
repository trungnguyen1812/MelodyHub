import adminApi from '@/plugins/axios_admin';
import type { CreateSongPayload } from "@/modules/admin/interfaces/songs/create-song.payload";
import type { UpdateSongPayload } from "@/modules/admin/interfaces/songs/update_song.payload";
import type { SongFilterParams } from '@/modules/admin/interfaces/songs/songs.interface'

class SongService {

     async getAllSongs(params: SongFilterParams = {}) {
        return adminApi.get('/songs', { params })
    }
 
    async getSong(idOrSlug: string | number) {
        return adminApi.get(`/songs/${idOrSlug}`)
    }

    async addSong(payload: CreateSongPayload) {
        return adminApi.post('/songs/add', payload, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });
    }

    async deleteSong(id: number) {
        return await adminApi.delete(`/songs/delete/${id}`);
    }

    async deleteMultipleSongs(ids: number[]) {
        return await adminApi.delete(`/songs/delete-multiple`, { data: { ids } });
    }
    async updateSong(id: number, payload: UpdateSongPayload) {
        const formData = new FormData();
        
        Object.entries(payload).forEach(([key, value]) => {
            if (value !== undefined && value !== null) {
                formData.append(key, value as any);
            }
        });

        return await adminApi.post(`/songs/update/${id}`, formData, {
            headers: { 'Content-Type': 'multipart/form-data' },
        });
    }

    // async getArtistStatistics(){
    //     const res = await adminApi.get("/artists/statistics");
    //     return res.data;
    // }
}

export default new SongService();
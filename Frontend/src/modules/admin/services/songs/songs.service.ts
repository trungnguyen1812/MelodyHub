import adminApi from '@/plugins/axios_admin';
import type { CreateSongPayload } from "@/modules/admin/interfaces/songs/create-song.payload";
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

    // async updateArtist(id: number, payload: CreateArtistPayload) {
    //     const formData = new FormData();
        
    //     Object.keys(payload).forEach(key => {
    //         if (key !== 'avatar' && key !== 'banner'  && payload[key as keyof CreateArtistPayload]) {
    //             formData.append(key, String(payload[key as keyof CreateArtistPayload]));
    //         }
    //     });
        
    //     if (payload.avatar instanceof File) {
    //         formData.append('avatar', payload.avatar);
    //     }
    //     if (payload.banner instanceof File) {
    //         formData.append('banner', payload.banner);
    //     }
    //     console.log(payload.avatar);
    //     console.log(payload.banner);
        
        
    //     return await adminApi.post(`/artists/update/${id}`, formData, {
    //         headers: {
    //             'Content-Type': undefined, 
    //         },
    //     });
    // }

    // async getArtistStatistics(){
    //     const res = await adminApi.get("/artists/statistics");
    //     return res.data;
    // }
}

export default new SongService();
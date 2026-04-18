import adminApi from '@/plugins/axios_admin';
import type { CreateArtistPayload } from "@/modules/admin/interfaces/artists/create-artist.payload";

class ArtistService {

    async getAllArtist() {
        const res = await adminApi.get("/artists");
        return res.data;
    }

    async searchArtist(keyword: string) {
        const res = await adminApi.post("/artists/search", {
            q: keyword  
        });
        return res.data;
    }

    async detailArtist(id: number) {
          console.log('Calling detailArtist with id:', id, typeof id);
        return await adminApi.get(`/artists/${id}`);
    } 

    async deleteArtist(id: number) {
        return await adminApi.delete(`/artists/delete/${id}`);
    }

    async addArtist(payload: CreateArtistPayload) {
        return adminApi.post('/artists/add', payload, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });
    }

    async updateArtist(id: number, payload: CreateArtistPayload) {
        const formData = new FormData();
        
        Object.keys(payload).forEach(key => {
            if (key !== 'avatar' && key !== 'banner'  && payload[key as keyof CreateArtistPayload]) {
                formData.append(key, String(payload[key as keyof CreateArtistPayload]));
            }
        });
        
        if (payload.avatar instanceof File) {
            formData.append('avatar', payload.avatar);
        }
        if (payload.banner instanceof File) {
            formData.append('banner', payload.banner);
        }
        console.log(payload.avatar);
        console.log(payload.banner);
        
        
        return await adminApi.post(`/artists/update/${id}`, formData, {
            headers: {
                'Content-Type': undefined, 
            },
        });
    }

    async getArtistStatistics(){
        const res = await adminApi.get("/artists/statistics");
        return res.data;
    }
}

export default new ArtistService();
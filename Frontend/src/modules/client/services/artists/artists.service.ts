import clientApi from '@/plugins/axios';
import type { CreateArtistPayload } from "@/modules/admin/interfaces/artists/create-artist.payload";

class ArtistService {

    async getAllArtist(partnerId?: number) {
        const params: any = {};
        if (partnerId) {
            params.partner_id = partnerId;
        }
        const res = await clientApi.get("/artists/allArtists", { params });
        return res.data;
    }

    async getArtists(limit: number = 10) {
        return clientApi.get('/artists/Artists', { params: { limit } });
    }

    async addArtist(payload: CreateArtistPayload) {
        return clientApi.post('/artists/add', payload, {
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
        
        
        return await clientApi.post(`/artists/update/${id}`, formData, {
            headers: {
                'Content-Type': undefined, 
            },
        });
    }

    async searchArtist(keyword: string) {
        const res = await clientApi.post("/artists/search", {
            q: keyword  
        });
        return res.data;
    }

    async detailArtist(idOrSlug: string | number) {
        return await clientApi.get(`/artists/${idOrSlug}`);
    } 

    async deleteArtist(id: number) {
        return await clientApi.delete(`/artists/delete/${id}`);
    }
    
    async getArtistStatistics(){
        const res = await clientApi.get("/artists/statistics");
        return res.data;
    }

    async getAritstByIdPartner(id: number){
        const res = await clientApi.get(`/artists/by-partner?partner_id=${id}`);
        return res.data;
    }
}

export default new ArtistService();
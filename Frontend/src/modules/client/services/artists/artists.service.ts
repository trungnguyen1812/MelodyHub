import clientApi from '@/plugins/axios';
import type { CreateArtistPayload } from "@/modules/admin/interfaces/artists/create-artist.payload";

class ArtistService {

    async getAllArtist() {
        const res = await clientApi.get("/artists/allArtists");
        return res.data;
    }

    async getArtists(limit: number = 10) {
        return clientApi.get('/artists/allArtists', { params: { limit } });
    }

    async searchArtist(keyword: string) {
        const res = await clientApi.post("/artists/search", {
            q: keyword  
        });
        return res.data;
    }

    async detailArtist(id: number) {
        return await clientApi.get(`/artists/${id}`);
    } 

    
    async getArtistStatistics(){
        const res = await clientApi.get("/artists/statistics");
        return res.data;
    }
}

export default new ArtistService();
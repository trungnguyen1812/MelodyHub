import clientApi from '@/plugins/axios';
import type { CreatePartnerRequest } from "@/modules/client/interfaces/partners/create-partner.payload";

class PartnerService {

    async addPartner(formData: FormData) {
        return clientApi.post('/partners/add', formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });
    }

    async getAllPartners() {
        const res = await clientApi.get("/partners");
        return res.data;
    }
    // async getPartnerByID() {
    //     const res = await clientApi.get("/artists/allArtists");
    //     return res.data;
    // }

    // async getArtists(limit: number = 10) {
    //     return clientApi.get('/artists/allArtists', { params: { limit } });
    // }

    // async searchArtist(keyword: string) {
    //     const res = await clientApi.post("/artists/search", {
    //         q: keyword  
    //     });
    //     return res.data;
    // }

    // async detailArtist(id: number) {
    //     return await clientApi.get(`/artists/${id}`);
    // } 

    
    // async getArtistStatistics(){
    //     const res = await clientApi.get("/artists/statistics");
    //     return res.data;
    // }
}

export default new PartnerService();
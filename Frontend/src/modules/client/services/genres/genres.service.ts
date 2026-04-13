import clientApi from '@/plugins/axios';
import type { CreateArtistPayload } from "@/modules/admin/interfaces/artists/create-artist.payload";

class GenreService {

    async getAllGenres() {
        const res = await clientApi.get("/genres");
        return res.data;
    }

    async getGenreDetail(slug: string) {
        const res = await clientApi.get(`/genres/${slug}`);
        return res.data;
    }

    async getGenreDetail(slug: string) {
        const res = await clientApi.get(`/genres/${slug}`);
        return res.data;
    }

    // async searchArtist(keyword: string) {
    //     const res = await clientApi.post("/artists/search", {
    //         q: keyword  
    //     });
    //     return res.data;
    // }

    // async detailArtist(id: number) {
    //     return await clientApi.get(`/artists/${id}`);
    // } 

    // async deleteArtist(id: number) {
    //     return await clientApi.delete(`/artists/delete/${id}`);
    // }

    // async addArtist(payload: CreateArtistPayload) {
    //     return clientApi.post('/artists/add', payload, {
    //         headers: {
    //             'Content-Type': 'multipart/form-data'
    //         }
    //     });
    // }

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
        
        
    //     return await clientApi.post(`/artists/update/${id}`, formData, {
    //         headers: {
    //             'Content-Type': undefined, 
    //         },
    //     });
    // }

    // async getArtistStatistics(){
    //     const res = await clientApi.get("/artists/statistics");
    //     return res.data;
    // }
}

export default new GenreService();
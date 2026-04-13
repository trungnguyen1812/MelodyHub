import adminApi from '@/plugins/axios_admin';
import type { CreateGenrePayload } from "@/modules/admin/interfaces/genres/create-genre.payload";

class GenreService {

    async getAllGenre() {
        const res = await adminApi.get("/genres");
        return res.data;
    }

    async searchGenre(keyword: string) {
        const res = await adminApi.post("/genres/search", {
            q: keyword  
        });
        return res.data;
    }

    async detailGenre(id: number) {
        return await adminApi.get(`/genres/${id}`);
    } 

    async deleteGenre(id: number) {
        return await adminApi.delete(`/genres/delete/${id}`);
    }

    async addGenre(payload: CreateGenrePayload) {
        return adminApi.post('/genres/add', payload, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });
    }

    async updateGenre(id: number, payload: CreateGenrePayload) {
        const formData = new FormData();
        
        Object.keys(payload).forEach(key => {
            const value = payload[key as keyof CreateGenrePayload];
            if (value === undefined || value === null || value === '') return;

            if (key === 'avatar' || key === 'banner' || key === 'cover_url') {
                return;
            }
            
            formData.append(key, String(value));
        });
        
        if (payload.avatar instanceof File) {
            formData.append('avatar', payload.avatar);
        }
        if (payload.banner instanceof File) {
            formData.append('banner', payload.banner);
        }
        if (payload.cover_url instanceof File) {
            formData.append('cover_url', payload.cover_url);
        }
        
        return await adminApi.post(`/genres/update/${id}`, formData, {
            headers: {
                'Content-Type': undefined, 
            },
        });
    }

    async getGenreStatistics(){
        const res = await adminApi.get("/genres/statistics");
        return res.data;
    }
}

export default new GenreService();
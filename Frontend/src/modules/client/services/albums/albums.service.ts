import clientApi from '@/plugins/axios';
import type { CreateAlbumPayload } from "@/modules/admin/interfaces/albums/create-album.payload";

class AlbumService {

    async getAllAlbum() {
        const res = await clientApi.get("/albums");
        return res.data;
    }

    async searchAlbum(keyword: string) {
        const res = await clientApi.post("/albums/search", {
            q: keyword  
        });
        return res.data;
    }

    async detailAlbum(slug: string) {
        return await clientApi.get(`/albums/${slug}`);
    } 

    async deleteAlbum(id: number) {
        return await clientApi.delete(`/albums/delete/${id}`);
    }

    async addAlbum(payload: CreateAlbumPayload) {
        const formData = new FormData();

        Object.entries(payload).forEach(([key, value]) => {
            if (value === undefined || value === null || value === '') {
                return;
            }

            if (key === 'cover_url') {
                return;
            }

            // Handle arrays (like track_ids)
            if (Array.isArray(value)) {
                value.forEach((item, index) => {
                    formData.append(`${key}[${index}]`, String(item));
                });
            } else {
                formData.append(key, String(value));
            }
        });

        if (payload.cover_url instanceof File) {
            formData.append('cover_url', payload.cover_url);
        }

        return clientApi.post('/albums/add', formData, {
            headers: {
                'Content-Type': undefined,
            }
        });
    }

    async updateAlbum(slug: string, payload: CreateAlbumPayload) {
        const formData = new FormData();
        
        Object.entries(payload).forEach(([key, value]) => {
            if (value === undefined || value === null || value === '') {
                return;
            }

            if (key === 'cover_url') {
                return;
            }

            if (typeof value === 'boolean') {
                formData.append(key, value ? '1' : '0');
                return;
            }

            if (Array.isArray(value)) {
                value.forEach((item, index) => {
                    formData.append(`${key}[${index}]`, String(item));
                });
                return;
            }

            formData.append(key, String(value));
        });
        
        if (payload.cover_url instanceof File) {
            formData.append('cover_url', payload.cover_url);
        }
        
        return await clientApi.post(`/albums/update/${slug}`, formData, {
            headers: {
                'Content-Type': 'multipart/form-data', 
            },
        });
    }

    async getAlbumStatistics(){
        const res = await clientApi.get("/albums/statistics");
        return res.data;
    }

    async getAlbumByPartner(id: number){
        const res = await clientApi.get(`/albums/partner/${id}`);
        return res.data;
    }
}

export default new AlbumService();
import adminApi from '@/plugins/axios_admin';
import type { CreateAlbumPayload } from "@/modules/admin/interfaces/albums/create-album.payload";

class AlbumService {

    async getAllAlbum() {
        const res = await adminApi.get("/albums");
        return res.data;
    }

    async searchAlbum(keyword: string) {
        const res = await adminApi.post("/albums/search", {
            q: keyword  
        });
        return res.data;
    }

    async detailAlbum(id: number) {
        return await adminApi.get(`/albums/${id}`);
    } 

    async deleteAlbum(id: number) {
        return await adminApi.delete(`/albums/delete/${id}`);
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

        return adminApi.post('/albums/add', formData, {
            headers: {
                'Content-Type': undefined,
            }
        });
    }

    async updateAlbum(id: number, payload: CreateAlbumPayload) {
        const formData = new FormData();
        
        Object.entries(payload).forEach(([key, value]) => {
            if (value === undefined || value === null || value === '') {
                return;
            }

            // Skip file fields - will add separately
            if (key === 'avatar' || key === 'banner' || key === 'cover_url') {
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
        
        // Add files if present
        if (payload.avatar instanceof File) {
            formData.append('avatar', payload.avatar);
        }
        if (payload.banner instanceof File) {
            formData.append('banner', payload.banner);
        }
        if (payload.cover_url instanceof File) {
            formData.append('cover_url', payload.cover_url);
        }
        
        return await adminApi.post(`/albums/update/${id}`, formData, {
            headers: {
                'Content-Type': undefined, 
            },
        });
    }

    async getAlbumStatistics(){
        const res = await adminApi.get("/albums/statistics");
        return res.data;
    }
}

export default new AlbumService();
import adminApi from '@/plugins/axios_admin';
import type { CreateArtistPayload } from "@/modules/admin/interfaces/artists/create-artist.payload";

class ArtistService {

    async getAllArtist() {
        const res = await adminApi.get("/list-artist");
        return res.data;
    }

    async searchArtist(keyword: string) {
        const res = await adminApi.post("/search-artist", {
            q: keyword  // Đổi từ 'keyword' thành 'q' cho đồng bộ với UserService
        });
        return res.data;
    }

    async detailArtist(id: number) {
        return await adminApi.get(`/artists/${id}`);
    } 

    async deleteArtist(id: number) {
        return await adminApi.post(`/artist/delete/${id}`);
    }

    async addArtist(payload: CreateArtistPayload) {
        return adminApi.post('/add-artist', payload, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });
    }

    async updateArtist(id: number, payload: CreateArtistPayload) {
        const formData = new FormData();
        
        // Xử lý tương tự UserService: bỏ qua trường avatar nếu có
        Object.keys(payload).forEach(key => {
            if (key !== 'avatar' && key !== 'banner'  && payload[key as keyof CreateArtistPayload]) {
                formData.append(key, String(payload[key as keyof CreateArtistPayload]));
            }
        });
        
        // Xử lý riêng file avatar nếu có
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
                'Content-Type': undefined,  // Để browser tự set boundary
            },
        });
    }
}

export default new ArtistService();
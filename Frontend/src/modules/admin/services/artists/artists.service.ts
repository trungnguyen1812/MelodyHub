import adminApi from '@/plugins/axios_admin';
import type { CreateArtistPayload } from "@/modules/admin/interfaces/artists/create-artist.payload";

class ArtistService {

    async getAllArtist() {
        return (await adminApi.get("/artists")).data;
    }

    async searchArtist(keyword: string) {
        return (await adminApi.get("/artists/search", {
            params: { q: keyword }
        })).data;
    }

    async detailArtist(slug: string) {
        return (await adminApi.get(`/artists/${slug}`)).data;
    }

    async deleteArtist(id: number) {
        return (await adminApi.delete(`/artists/artist/${id}`)).data;
    }

    async addArtist(payload: CreateArtistPayload) {
        const formData = new FormData();

        Object.entries(payload).forEach(([key, value]) => {
            if (value) formData.append(key, value as any);
        });

        return adminApi.post("/artists", formData);
    }

    async updateArtist(id: number, payload: CreateArtistPayload) {

        const formData = new FormData();

        Object.entries(payload).forEach(([key, value]) => {
            if (value) formData.append(key, value as any);
        });

        return adminApi.post(`/artists/${id}`, formData);
    }

}

export default new ArtistService();
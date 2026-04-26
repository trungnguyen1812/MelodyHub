import adminApi from '@/plugins/axios_admin';

class AdvertisingService {
    async getAll() {
        const res = await adminApi.get('/advertising/');
        return res.data;
    }

    // Sửa Number → number
    async getById(id: number| string) {
        const res = await adminApi.get(`/advertising/${id}`);
        return res.data;
    }

    // Sửa Number → number
    async toggleStatus(id: number| string) {
        const res = await adminApi.patch(`/advertising/${id}/toggle-status`);
        return res.data;
    }
}

export default new AdvertisingService();
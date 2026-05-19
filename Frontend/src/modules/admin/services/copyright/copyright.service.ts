import adminApi from '@/plugins/axios_admin';

export interface CopyrightListParams {
    page?: number;
    per_page?: number;
    search?: string;
    status?: string;
    copyright_type?: string;
}

class AdminCopyrightService {
    async getAll(params: CopyrightListParams = {}) {
        const res = await adminApi.get('/copyrights', { params });
        return res.data;
    }

    async getStats() {
        const res = await adminApi.get('/copyrights/stats');
        return res.data;
    }

    async getDetail(id: number) {
        const res = await adminApi.get(`/copyrights/${id}`);
        return res.data;
    }

    async approve(id: number, notes?: string) {
        const res = await adminApi.post(`/copyrights/${id}/approve`, { notes });
        return res.data;
    }

    async reject(id: number, reason?: string) {
        const res = await adminApi.post(`/copyrights/${id}/reject`, { reason });
        return res.data;
    }

    async update(id: number, payload: { notes?: string; status?: string }) {
        const res = await adminApi.patch(`/copyrights/${id}`, payload);
        return res.data;
    }
}

export default new AdminCopyrightService();

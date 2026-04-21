// services/partnerService.ts
import adminApi from '@/plugins/axios_admin';
import type { CreatePartnerPayload } from "@/modules/admin/interfaces/partners/create-partner.payload";
import type { UpdatePartnerPayload } from "@/modules/admin/interfaces/partners/update-partner.payload";

class PartnerService {

    /**
     * Lấy danh sách tất cả partners
     */
    async getAllPartners() {
        const res = await adminApi.get("/partners");
        return res.data;
    }

    /**
     * Lấy danh sách partners gần đây (cho dashboard)
     */
    async getRecentPartners(limit: number = 8) {
        const res = await adminApi.get("/partners/recent", {
            params: { limit }
        });
        return res.data;
    }

    /**
     * Tìm kiếm partners
     */
    async searchPartners(keyword: string) {
        const res = await adminApi.get("/partners/search", {
            params: { keyword }
        });
        return res.data;
    }

    /**
     * Lấy chi tiết một partner
     */
    async detailPartner(id: number) {
        const res = await adminApi.get(`/partners/${id}`);
        return res.data;
    }

    /**
     * Verify partner (pending -> active)
     */
    async verifyPartner(id: number) {
        const res = await adminApi.post(`/partners/${id}/verify`);
        return res.data;
    }

    /**
     * Update status của partner (active/suspended/terminated)
     */
    async updatePartnerStatus(id: number, status: 'active' | 'pending' | 'suspended' | 'terminated') {
        const res = await adminApi.patch(`/partners/${id}/status`, { status });
        return res.data;
    }

    /**
     * Lấy thống kê partners cho dashboard
     */
    async getPartnerStatistics() {
        const res = await adminApi.get("/partners/statistics");
        return res.data;
    }

    /**
     * Bulk update status cho nhiều partners
     */
    async bulkUpdateStatus(ids: number[], status: string) {
        const res = await adminApi.post("/partners/bulk-update-status", {
            ids,
            status
        });
        return res.data;
    }

    /**
     * Lấy partners theo status
     */
    async getPartnersByStatus(status: string) {
        const res = await adminApi.get("/partners", {
            params: { status }
        });
        return res.data;
    }

    /**
     * Upload logo cho partner
     */
    async uploadLogo(id: number, file: File) {
        const formData = new FormData();
        formData.append('logo', file);
        
        const res = await adminApi.post(`/partners/${id}/upload-logo`, formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });
        return res.data;
    }

    /**
     * Upload contract file cho partner
     */
    async uploadContract(id: number, file: File) {
        const formData = new FormData();
        formData.append('contract', file);
        
        const res = await adminApi.post(`/partners/${id}/upload-contract`, formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });
        return res.data;
    }

    /**
     * Export partners data
     */
    async exportPartners(format: 'csv' | 'excel' | 'pdf' = 'csv') {
        const res = await adminApi.get("/partners/export", {
            params: { format },
            responseType: 'blob'
        });
        return res.data;
    }
}

export default new PartnerService();
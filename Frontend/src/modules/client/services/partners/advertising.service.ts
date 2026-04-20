import clientApi from '@/plugins/axios';

class AdvertisingService {
    /**
     * Get list of all campaigns for the current partner.
     */
    async getCampaigns() {
        const res = await clientApi.get('/partners/advertising');
        return res.data;
    }

    /**
     * Get a single campaign by ID.
     */
    async getCampaign(id: number | string) {
        const res = await clientApi.get(`/partners/advertising/${id}`);
        return res.data;
    }

    /**
     * Create a new advertisement campaign (support FormData for files).
     */
    async createCampaign(formData: FormData) {
        return clientApi.post('/partners/advertising/store', formData, {
            headers: {
                'Content-Type': 'multipart/form-data',
            },
        });
    }

    /**
     * Update an existing campaign.
     * Supports both PUT and PATCH (Laravel thường dùng PATCH cho partial update).
     */
    async updateCampaign(id: number | string, formData: FormData | object) {
        // Nếu truyền FormData (có file) thì dùng multipart/form-data
        const isFormData = formData instanceof FormData;

        const config = isFormData
            ? { headers: { 'Content-Type': 'multipart/form-data' } }
            : {};

        // Laravel hỗ trợ cả PUT và PATCH cho cùng route
        return clientApi.put(`/partners/advertising/${id}`, formData, config);
        // Hoặc dùng patch nếu bạn thích partial update:
        // return clientApi.patch(`/partners/advertising/${id}`, formData, config);
    }

    /**
     * Delete a campaign.
     */
    async deleteCampaign(id: number | string) {
        return clientApi.delete(`/partners/advertising/${id}`);
    }

    /**
     * Toggle status (active/inactive) of a campaign.
     */
    async toggleCampaignStatus(id: number | string) {
        return clientApi.patch(`/partners/advertising/${id}/toggle-status`);
    }

    /**
     * (Optional) Get genres for targeting selection in wizard.
     */
    async getGenres() {
        const res = await clientApi.get('/genres');
        return res.data;
    }

    /**
     * (Optional) Get wallet balance or partner info if needed.
     */
    async getPartnerInfo() {
        const res = await clientApi.get('/partners/info'); // Điều chỉnh endpoint nếu khác
        return res.data;
    }
}

export default new AdvertisingService();
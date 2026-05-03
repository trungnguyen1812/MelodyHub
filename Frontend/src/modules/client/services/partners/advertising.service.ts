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
     * Dùng POST thay vì PUT/PATCH để tránh PHP không parse được file upload.
     * Backend route: POST /partners/advertising/{id}/update
     */
    async updateCampaign(id: number | string, formData: FormData | object) {
        console.log('📤 Updating campaign:', id, formData);

        if (formData instanceof FormData) {
            return clientApi.post(`/partners/advertising/${id}/update`, formData, {
                headers: { 'Content-Type': 'multipart/form-data' },
            });
        }

        return clientApi.post(`/partners/advertising/${id}/update`, formData, {
            headers: { 'Content-Type': 'application/json' },
        });
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
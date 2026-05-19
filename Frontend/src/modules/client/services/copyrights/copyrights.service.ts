import clientApi from '@/plugins/axios';

class CopyrightService {

    async addCopyright(formData: FormData) {
        return clientApi.post('/copyrights/add', formData, {
            headers: { 'Content-Type': 'multipart/form-data' }
        });
    }

    async getCopyrights(params: Record<string, unknown> = {}) {
        return clientApi.get('/copyrights', { params });
    }

    async getCopyright(id: number) {
        return clientApi.get(`/copyrights/${id}`);
    }

    async updateCopyright(id: number, formData: FormData) {
        // Dùng POST thay vì PUT/PATCH vì PHP không parse multipart/form-data với PUT
        return clientApi.post(`/copyrights/${id}`, formData, {
            headers: { 'Content-Type': 'multipart/form-data' }
        });
    }

    async deleteCopyright(id: number) {
        return clientApi.delete(`/copyrights/${id}`);
    }

    async uploadContract(id: number, formData: FormData, onUploadProgress?: (event: ProgressEvent) => void) {
        return clientApi.post(`/copyrights/${id}/upload-contract`, formData, {
            headers: { 'Content-Type': 'multipart/form-data' },
            onUploadProgress: onUploadProgress as ((progressEvent: import('axios').AxiosProgressEvent) => void) | undefined,
        });
    }
}

export default new CopyrightService();

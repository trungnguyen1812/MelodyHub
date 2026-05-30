import adminApi from '@/plugins/axios_admin'

export interface ReportListParams {
  page?: number
  per_page?: number
  status?: string
  sort_by?: string
  sort_order?: string
  min_similarity?: number
}

class AdminCopyrightReportService {
  async getAll(params: ReportListParams = {}) {
    const res = await adminApi.get('/copyright-reports', { params })
    return res.data
  }

  async getStats() {
    const res = await adminApi.get('/copyright-reports/stats')
    return res.data
  }

  async getDetail(id: number) {
    const res = await adminApi.get(`/copyright-reports/${id}`)
    return res.data
  }

  async update(id: number, payload: { status: string; resolution_note?: string }) {
    const res = await adminApi.patch(`/copyright-reports/${id}`, payload)
    return res.data
  }

  async destroy(id: number) {
    const res = await adminApi.delete(`/copyright-reports/${id}`)
    return res.data
  }

  async reprocess(id: number) {
    const res = await adminApi.post(`/copyright-reports/${id}/reprocess`)
    return res.data
  }
}

export default new AdminCopyrightReportService()

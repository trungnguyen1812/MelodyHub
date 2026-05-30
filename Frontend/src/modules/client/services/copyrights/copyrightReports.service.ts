import clientApi from '@/plugins/axios'

export interface ReportFilterParams {
  page?: number
  per_page?: number
  status?: string
  violation_type?: string
  search?: string
  sort_by?: string
  sort_order?: string
}

class CopyrightReportService {
  /** Lấy danh sách report của partner đang login */
  async getMyReports(params: ReportFilterParams = {}) {
    return clientApi.get('/report/my', { params })
  }

  /** Lấy thống kê */
  async getStats() {
    return clientApi.get('/report/stats')
  }

  /** Lấy chi tiết 1 report */
  async getReport(id: number) {
    return clientApi.get(`/report/${id}`)
  }

  /** Tạo report mới */
  async createReport(data: Record<string, unknown>) {
    return clientApi.post('/report/add', data)
  }

  /** Reprocess report */
  async reprocess(id: number) {
    return clientApi.post(`/report/${id}/reprocess`)
  }
}

export default new CopyrightReportService()

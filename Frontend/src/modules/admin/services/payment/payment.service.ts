// services/payment/payment.service.ts
import adminApi from '@/plugins/axios_admin'
import type { PaymentFilterParams } from '@/modules/admin/interfaces/payment/payment.interface'

class PaymentService {
  /** Danh sách giao dịch (có filter + pagination) */
  async getAll(params: PaymentFilterParams = {}) {
    const res = await adminApi.get('/payments', { params })
    return res.data
  }

  /** Chi tiết một giao dịch */
  async getById(id: string) {
    const res = await adminApi.get(`/payments/${id}`)
    return res.data
  }

  /** Approve / process một payment (partner payout) */
  async approve(id: string, note?: string) {
    const res = await adminApi.post(`/payments/${id}/approve`, { note })
    return res.data
  }

  /** Từ chối / cancel */
  async reject(id: string, reason: string) {
    const res = await adminApi.post(`/payments/${id}/reject`, { reason })
    return res.data
  }

  /** Tóm tắt thống kê */
  async getSummary() {
    const res = await adminApi.get('/payments/summary')
    return res.data
  }

  /** Export CSV / Excel */
  async export(format: 'csv' | 'excel' = 'csv', params: PaymentFilterParams = {}) {
    const res = await adminApi.get('/payments/export', {
      params: { format, ...params },
      responseType: 'blob',
    })
    return res.data
  }
}

export default new PaymentService()

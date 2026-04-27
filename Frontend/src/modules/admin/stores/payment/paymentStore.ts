// stores/payment/paymentStore.ts
import { defineStore } from 'pinia'
import paymentService from '@/modules/admin/services/payment/payment.service'
import type {
  Payment,
  PaymentSummary,
  PaymentFilterParams,
} from '@/modules/admin/interfaces/payment/payment.interface'

interface PaymentState {
  payments: Payment[]
  summary: PaymentSummary | null
  currentPayment: Payment | null
  total: number
  currentPage: number
  lastPage: number
  perPage: number
  loadingList: boolean
  loadingDetail: boolean
  actionLoading: boolean
  error: string | null
}

export const usePaymentStore = defineStore('payment', {
  state: (): PaymentState => ({
    payments: [],
    summary: null,
    currentPayment: null,
    total: 0,
    currentPage: 1,
    lastPage: 1,
    perPage: 15,
    loadingList: false,
    loadingDetail: false,
    actionLoading: false,
    error: null,
  }),

  getters: {
    pendingPayments: (s) => s.payments.filter(p => p.status === 'pending'),
    completedPayments: (s) => s.payments.filter(p => p.status === 'completed'),
  },

  actions: {
    async fetchAll(params: PaymentFilterParams = {}) {
      this.loadingList = true
      this.error = null
      try {
        const res = await paymentService.getAll(params)
        this.payments    = res.data        ?? []
        this.summary     = res.summary     ?? null
        this.total       = res.total       ?? 0
        this.currentPage = res.current_page ?? 1
        this.lastPage    = res.last_page    ?? 1
        this.perPage     = res.per_page     ?? 15
      } catch (err: any) {
        this.error = err?.response?.data?.message || err?.message || 'Không thể tải danh sách giao dịch.'
      } finally {
        this.loadingList = false
      }
    },

    async fetchById(id: string) {
      this.loadingDetail = true
      this.error = null
      try {
        const res = await paymentService.getById(id)
        this.currentPayment = res.data ?? res
      } catch (err: any) {
        this.error = err?.response?.data?.message || err?.message || 'Không thể tải chi tiết giao dịch.'
        this.currentPayment = null
      } finally {
        this.loadingDetail = false
      }
    },

    async approve(id: string, note?: string) {
      this.actionLoading = true
      this.error = null
      try {
        await paymentService.approve(id, note)
        // Cập nhật local
        const idx = this.payments.findIndex(p => p.id === id)
        if (idx !== -1) this.payments[idx].status = 'completed'
        if (this.currentPayment?.id === id) this.currentPayment.status = 'completed'
      } catch (err: any) {
        this.error = err?.response?.data?.message || err?.message || 'Không thể duyệt giao dịch.'
        throw err
      } finally {
        this.actionLoading = false
      }
    },

    async reject(id: string, reason: string) {
      this.actionLoading = true
      this.error = null
      try {
        await paymentService.reject(id, reason)
        const idx = this.payments.findIndex(p => p.id === id)
        if (idx !== -1) this.payments[idx].status = 'failed'
        if (this.currentPayment?.id === id) this.currentPayment.status = 'failed'
      } catch (err: any) {
        this.error = err?.response?.data?.message || err?.message || 'Không thể từ chối giao dịch.'
        throw err
      } finally {
        this.actionLoading = false
      }
    },

    clearCurrentPayment() {
      this.currentPayment = null
    },
  },
})

// stores/advertisingStore.js
import { defineStore } from 'pinia'
import advertisingService from '@/modules/admin/services/avertising/avertising.service'
import type {  
    Advertisement, 
    AdvertisementDetail, 
    AdvertisingListResponse,
    AdvertisingSummary 
} from '@/modules/admin/interfaces/avertising/avertising.interface'

interface AdvertisingState {
  advertisements: Advertisement[]
  summary: AdvertisingSummary | null 
  currentAd: AdvertisementDetail | null
  loadingList: boolean
  loadingDetail: boolean
  togglingId: number | string | null
  error: string | null
  
}

export const useAdvertisingStore = defineStore('advertising', {
  state: (): AdvertisingState => ({
    advertisements: [],
    summary: null,
    currentAd: null,
    loadingList: false,
    loadingDetail: false,
    togglingId: null,
    error: null,
  }),


  getters: {
    /** Danh sách quảng cáo đang active */
    activeAds: (state): Advertisement[] =>
      state.advertisements.filter(ad => ad.status === 'active'),

    /** Danh sách quảng cáo đang paused */
    pausedAds: (state): Advertisement[] =>
      state.advertisements.filter(ad => ad.status === 'paused'),

    /** Danh sách quảng cáo đã completed */
    completedAds: (state): Advertisement[] =>
      state.advertisements.filter(ad => ad.status === 'completed'),

    /** Tổng budget đã chi */
    totalBudgetSpent: (state): number =>
      state.advertisements.reduce((sum, ad) => sum + (ad.budget_spent ?? 0), 0),

    /** Đang toggle status hay không (loading) */
    isToggling: (state): boolean => state.togglingId !== null,
  },

  actions: {
    /**
     * Fetch toàn bộ danh sách ads của partner hiện tại
     */
     async fetchAll() {
        this.loadingList = true
        this.error = null
        try {
            const response = await advertisingService.getAll() as AdvertisingListResponse
            this.advertisements = response.data ?? []
            this.summary = response.summary ?? null
        } catch (err: any) {
            this.error = err?.response?.data?.message || err?.message || 'Unable to load ad list.'
        } finally {
            this.loadingList = false
        }
    },

    /**
     * Fetch chi tiết một ad theo id
     * @param {number|string} id
     */
    async fetchById(id: number | string) {
      this.loadingDetail = true
      this.error = null
      try {
        const data = await advertisingService.getById(id)
        // Data có thể là object hoặc { data: {...} }
        this.currentAd = data?.data ?? data
      } catch (err: any) {
        this.error = err?.response?.data?.message || err?.message || 'Unable to load ad list.'
        this.currentAd = null
      } finally {
        this.loadingDetail = false
      }
    },

    /**
     * Toggle active/paused cho một ad.
     * Optimistic update: đổi trực tiếp trong list, rollback nếu API lỗi.
     * @param {number|string} id
     */
    async toggleStatus(id: number | string) {
      // Tránh double-click
      if (this.togglingId === id) return
      
      this.togglingId = id
      this.error = null

      // --- Tìm ad trong list ---
      const adInList = this.advertisements.find(a => a.id === id)
      const prevStatus = adInList?.status

      // --- Optimistic update trên list ---
      if (adInList) {
        adInList.status = adInList.status === 'active' ? 'paused' : 'active'
      }

      // --- Optimistic update trên currentAd nếu đang xem detail ---
      const prevCurrentStatus = this.currentAd?.status
      if (this.currentAd && this.currentAd.id === id) {
        this.currentAd.status = this.currentAd.status === 'active' ? 'paused' : 'active'
      }

      try {
        const result = await advertisingService.toggleStatus(id)
        const newStatus = result?.status ?? (result?.data?.status)

        // Đồng bộ lại status từ server nếu có
        if (newStatus) {
          if (adInList) adInList.status = newStatus
          if (this.currentAd && this.currentAd.id === id) {
            this.currentAd.status = newStatus
          }
        }

        return result
      } catch (err: any) {
        // Rollback nếu lỗi
        if (adInList && prevStatus) adInList.status = prevStatus
        if (this.currentAd && this.currentAd.id === id && prevCurrentStatus) {
          this.currentAd.status = prevCurrentStatus
        }
        this.error = err?.response?.data?.message || err?.message || 'Unable to update ad status.'
        throw err
      } finally {
        this.togglingId = null
      }
    },

    /**
     * Xóa currentAd (dùng khi unmount trang detail)
     */
    clearCurrentAd() {
      this.currentAd = null
    },

    /**
     * Reset toàn bộ store
     */
    reset() {
      this.advertisements = []
      this.currentAd = null
      this.loadingList = false
      this.loadingDetail = false
      this.togglingId = null
      this.error = null
    },
  },
})
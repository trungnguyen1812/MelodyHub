import { defineStore } from 'pinia'
import dashboardService from '@/modules/admin/services/dashboard/dashboard.service'

interface TrendPoint {
  month: string
  count?: number
  amount?: number
}

interface RecentUser {
  id: number
  name: string
  email: string
  status: string
  created_at: string
}

interface RecentPartner {
  id: number
  company_name: string
  status: string
  type: string | null
  created_at: string
}

interface DashboardStats {
  total_users: number
  new_users_month: number
  user_growth: number
  total_partners: number
  active_partners: number
  pending_partners: number
  total_songs: number
  total_artists: number
  total_albums: number
  revenue_total: number
  revenue_this_month: number
  revenue_last_month: number
  revenue_growth: number
}

interface DashboardState {
  stats: DashboardStats | null
  userTrend: TrendPoint[]
  revenueTrend: TrendPoint[]
  recentUsers: RecentUser[]
  recentPartners: RecentPartner[]
  loading: boolean
  error: string | null
}

export const useDashboardStore = defineStore('dashboard', {
  state: (): DashboardState => ({
    stats: null,
    userTrend: [],
    revenueTrend: [],
    recentUsers: [],
    recentPartners: [],
    loading: false,
    error: null,
  }),

  actions: {
    async fetch() {
      this.loading = true
      this.error = null
      try {
        const data = await dashboardService.getDashboard()
        this.stats          = data.stats
        this.userTrend      = data.user_trend      ?? []
        this.revenueTrend   = data.revenue_trend   ?? []
        this.recentUsers    = data.recent_users    ?? []
        this.recentPartners = data.recent_partners ?? []
      } catch (err: any) {
        this.error = err?.response?.data?.message ?? 'Failed to load dashboard'
      } finally {
        this.loading = false
      }
    },
  },
})

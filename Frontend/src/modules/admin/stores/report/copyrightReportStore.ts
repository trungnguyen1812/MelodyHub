import { defineStore } from 'pinia'
import AdminCopyrightReportService, { type ReportListParams } from '@/modules/admin/services/report/copyrightReport.service'

export interface AdminCopyrightReport {
  id: number
  reporter_type: string
  reporter_partner_id: number | null
  reporter_user_id: number | null
  original_song_id: number
  infringing_song_id: number
  violation_type: string
  description: string | null
  evidence_files: string[] | null
  similarity_score: number | null
  similarity_raw: number | null
  ai_report_path: string | null
  comparison_duration_ms: number | null
  fingerprint_cache_hit: boolean | null
  status: string
  resolution_note: string | null
  resolved_by: number | null
  resolved_at: string | null
  created_at: string
  updated_at: string
  original_song?: { id: number; title: string; artist?: { name: string }; cover_url?: string }
  infringing_song?: { id: number; title: string; artist?: { name: string }; cover_url?: string }
  reporter_partner?: { id: number; company_name: string }
  reporter_user?: { id: number; name: string }
  resolved_by_user?: { id: number; name: string }
}

export interface ReportStats {
  total: number
  pending: number
  ai_scanning: number
  reviewing: number
  auto_rejected: number
  resolved_removed: number
  resolved_kept: number
  rejected: number
  avg_similarity: number | null
  violation_rate: number
}

interface Pagination {
  current_page: number
  last_page: number
  per_page: number
  total: number
}

export const useAdminCopyrightReportStore = defineStore('adminCopyrightReport', {
  state: () => ({
    reports: [] as AdminCopyrightReport[],
    currentReport: null as AdminCopyrightReport | null,
    stats: null as ReportStats | null,
    pagination: { current_page: 1, last_page: 1, per_page: 15, total: 0 } as Pagination,
    loading: false,
    statsLoading: false,
    error: null as string | null,
  }),

  actions: {
    async fetchReports(params: ReportListParams = {}) {
      this.loading = true
      this.error = null
      try {
        const res = await AdminCopyrightReportService.getAll(params)
        if (res.success) {
          this.reports = res.data.data
          this.pagination = {
            current_page: res.data.current_page,
            last_page:    res.data.last_page,
            per_page:     res.data.per_page,
            total:        res.data.total,
          }
        }
      } catch (e: any) {
        this.error = e?.response?.data?.message ?? e.message
      } finally {
        this.loading = false
      }
    },

    async fetchStats() {
      this.statsLoading = true
      try {
        const res = await AdminCopyrightReportService.getStats()
        if (res.success) this.stats = res.data
      } catch {
        // non-critical
      } finally {
        this.statsLoading = false
      }
    },

    async fetchDetail(id: number) {
      try {
        const res = await AdminCopyrightReportService.getDetail(id)
        if (res.success) this.currentReport = res.data
        return res
      } catch (e: any) {
        this.error = e?.response?.data?.message ?? e.message
        throw e
      }
    },

    async updateStatus(id: number, status: string, resolutionNote?: string) {
      try {
        const res = await AdminCopyrightReportService.update(id, {
          status,
          resolution_note: resolutionNote,
        })
        if (res.success) {
          const idx = this.reports.findIndex(r => r.id === id)
          if (idx !== -1) this.reports[idx] = res.data
          if (this.currentReport?.id === id) this.currentReport = res.data
          // Update stats counters
          if (this.stats) {
            this.stats.reviewing = Math.max(0, this.stats.reviewing - 1)
            if (status === 'resolved_removed') this.stats.resolved_removed++
            else if (status === 'resolved_kept') this.stats.resolved_kept++
            else if (status === 'rejected') this.stats.rejected++
          }
        }
        return res
      } catch (e: any) {
        this.error = e?.response?.data?.message ?? e.message
        throw e
      }
    },

    async destroy(id: number) {
      try {
        const res = await AdminCopyrightReportService.destroy(id)
        if (res.success) {
          this.reports = this.reports.filter(r => r.id !== id)
          if (this.stats) this.stats.total = Math.max(0, this.stats.total - 1)
        }
        return res
      } catch (e: any) {
        this.error = e?.response?.data?.message ?? e.message
        throw e
      }
    },

    async reprocess(id: number) {
      try {
        const res = await AdminCopyrightReportService.reprocess(id)
        if (res.success) {
          const idx = this.reports.findIndex(r => r.id === id)
          if (idx !== -1) this.reports[idx].status = 'pending'
        }
        return res
      } catch (e: any) {
        this.error = e?.response?.data?.message ?? e.message
        throw e
      }
    },

    clearError() { this.error = null },
  },
})

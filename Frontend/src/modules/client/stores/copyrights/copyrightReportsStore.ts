import { defineStore } from 'pinia'
import CopyrightReportService, { type ReportFilterParams } from '@/modules/client/services/copyrights/copyrightReports.service'

export interface CopyrightReport {
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
  status: string
  resolution_note: string | null
  resolved_by: number | null
  resolved_at: string | null
  created_at: string
  updated_at: string
  original_song?: { id: number; title: string; artist?: { name: string }; song_url?: string }
  infringing_song?: { id: number; title: string; artist?: { name: string }; song_url?: string }
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

interface ReportState {
  reports: CopyrightReport[]
  currentReport: CopyrightReport | null
  stats: ReportStats | null
  loading: boolean
  statsLoading: boolean
  error: string | null
  pagination: Pagination
}

function extractError(error: unknown): string {
  if (error && typeof error === 'object' && 'response' in error) {
    const e = error as { response?: { data?: { message?: string } } }
    return e.response?.data?.message ?? 'Có lỗi xảy ra'
  }
  if (error instanceof Error) return error.message
  return 'Có lỗi xảy ra'
}

export const useCopyrightReportStore = defineStore('copyrightReportsClient', {
  state: (): ReportState => ({
    reports: [],
    currentReport: null,
    stats: null,
    loading: false,
    statsLoading: false,
    error: null,
    pagination: { current_page: 1, last_page: 1, per_page: 15, total: 0 },
  }),

  actions: {
    async fetchMyReports(params: ReportFilterParams = {}) {
      this.loading = true
      this.error = null
      try {
        const res = await CopyrightReportService.getMyReports(params)
        if (res.data.success) {
          const d = res.data.data
          this.reports = d.data as CopyrightReport[]
          this.pagination = {
            current_page: d.current_page,
            last_page: d.last_page,
            per_page: d.per_page,
            total: d.total,
          }
        }
      } catch (e) {
        this.error = extractError(e)
      } finally {
        this.loading = false
      }
    },

    async fetchStats() {
      this.statsLoading = true
      try {
        const res = await CopyrightReportService.getStats()
        if (res.data.success) {
          this.stats = res.data.data as ReportStats
        }
      } catch {
        // stats failure is non-critical
      } finally {
        this.statsLoading = false
      }
    },

    async fetchReport(id: number) {
      this.loading = true
      this.error = null
      try {
        const res = await CopyrightReportService.getReport(id)
        if (res.data.success) {
          this.currentReport = res.data.data as CopyrightReport
          return this.currentReport
        }
      } catch (e) {
        this.error = extractError(e)
      } finally {
        this.loading = false
      }
    },

    async createReport(data: Record<string, unknown>) {
      console.log(data);
      
      this.loading = true
      this.error = null
      try {
        const res = await CopyrightReportService.createReport(data)
        return res.data
      } catch (e) {
        this.error = extractError(e)
        return { success: false, message: this.error }
      } finally {
        this.loading = false
      }
    },

    async reprocess(id: number) {
      try {
        const res = await CopyrightReportService.reprocess(id)
        return res.data
      } catch (e) {
        return { success: false, message: extractError(e) }
      }
    },

    clearError() {
      this.error = null
    },
  },
})

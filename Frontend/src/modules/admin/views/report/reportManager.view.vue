<template>
  <div class="rpt-page">

    <!-- Header -->
    <div class="rpt-header">
      <div>
        <h1 class="rpt-title">Copyright Infringement Reports</h1>
        <p class="rpt-subtitle">Monitor & manage AI-powered audio fingerprint reports</p>
      </div>
      <button class="rpt-refresh-btn" @click="loadAll" :disabled="store.loading">
        <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"
          :class="{ 'spin': store.loading }">
          <polyline points="23 4 23 10 17 10"/>
          <path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/>
        </svg>
        Refresh
      </button>
    </div>

    <!-- Stats -->
    <div class="rpt-stats">
      <div class="rpt-stat" v-for="s in statCards" :key="s.key">
        <span class="rpt-stat__label">{{ s.label }}</span>
        <span class="rpt-stat__value" :style="{ color: s.color }">
          <span v-if="store.statsLoading" class="rpt-skeleton-num"></span>
          <span v-else>{{ s.value }}</span>
        </span>
      </div>
    </div>

    <!-- Table card -->
    <div class="rpt-card">
      <div class="rpt-card__head">
        <span class="rpt-card__title">Reports</span>
        <div class="rpt-controls">
          <select v-model="filterStatus" class="rpt-select">
            <option value="">All statuses</option>
            <option value="pending">Pending</option>
            <option value="ai_scanning">AI Scanning</option>
            <option value="reviewing">Reviewing</option>
            <option value="auto_rejected">Auto Rejected</option>
            <option value="resolved_removed">Resolved – Removed</option>
            <option value="resolved_kept">Resolved – Kept</option>
            <option value="rejected">Rejected</option>
          </select>
          <select v-model="sortBy" class="rpt-select">
            <option value="created_at">Sort: Date</option>
            <option value="similarity_score">Sort: Similarity</option>
            <option value="status">Sort: Status</option>
          </select>
          <button class="rpt-sort-btn" @click="toggleSortOrder" :title="sortOrder === 'desc' ? 'Descending' : 'Ascending'">
            {{ sortOrder === 'desc' ? '↓' : '↑' }}
          </button>
        </div>
      </div>

      <!-- Loading skeleton -->
      <div v-if="store.loading" class="rpt-skeletons">
        <div class="rpt-skeleton-row" v-for="i in 6" :key="i"></div>
      </div>

      <div v-else class="rpt-table-wrap">
        <table class="rpt-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Original Song</th>
              <th>Infringing Song</th>
              <th>Reporter</th>
              <th>Similarity</th>
              <th>Violation Type</th>
              <th>Status</th>
              <th>Date</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="store.reports.length === 0">
              <td colspan="9" class="rpt-empty">No reports found</td>
            </tr>
            <tr v-for="r in store.reports" :key="r.id" class="rpt-row">
              <td class="rpt-id">#{{ r.id }}</td>
              <td>
                <div class="rpt-song">
                  <strong>{{ r.original_song?.title ?? '—' }}</strong>
                  <span>{{ r.original_song?.artist?.name ?? '—' }}</span>
                </div>
              </td>
              <td>
                <div class="rpt-song">
                  <strong>{{ r.infringing_song?.title ?? '—' }}</strong>
                  <span>{{ r.infringing_song?.artist?.name ?? '—' }}</span>
                </div>
              </td>
              <td class="rpt-reporter">{{ reporterName(r) }}</td>
              <td class="rpt-sim-cell">
                <template v-if="r.similarity_score !== null">
                  <span class="rpt-sim-badge" :class="r.similarity_score >= 60 ? 'high' : 'low'">
                    {{ r.similarity_score }}%
                  </span>
                  <div class="rpt-sim-bar">
                    <div class="rpt-sim-fill"
                      :style="{ width: r.similarity_score + '%', background: r.similarity_score >= 60 ? '#ef4444' : '#22c55e' }">
                    </div>
                  </div>
                </template>
                <span v-else class="rpt-muted">—</span>
              </td>
              <td><span class="rpt-type-badge">{{ violationLabel(r.violation_type) }}</span></td>
              <td><span class="rpt-status" :class="'s-' + r.status">{{ statusLabel(r.status) }}</span></td>
              <td class="rpt-muted rpt-date">{{ fmtDate(r.created_at) }}</td>
              <td>
                <div class="rpt-actions">
                  <button class="rpt-btn view" title="View Details" @click="openDetail(r)">
                    <svg width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                      <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                    </svg>
                  </button>
                  <button v-if="r.status === 'reviewing'" class="rpt-btn approve" title="Confirm Violation"
                    @click="quickResolve(r, 'resolved_removed')">
                    <svg width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                      <polyline points="20 6 9 17 4 12"/>
                    </svg>
                  </button>
                  <button v-if="r.status === 'reviewing'" class="rpt-btn reject" title="No Violation"
                    @click="quickResolve(r, 'rejected')">
                    <svg width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                      <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                  </button>
                  <button v-if="canReprocess(r)" class="rpt-btn reprocess" title="Re-run AI"
                    @click="handleReprocess(r)">
                    <svg width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                      <polyline points="23 4 23 10 17 10"/>
                      <path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/>
                    </svg>
                  </button>
                  <button class="rpt-btn delete" title="Delete" @click="handleDelete(r)">
                    <svg width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                      <polyline points="3 6 5 6 21 6"/>
                      <path d="M19 6l-1 14H6L5 6m5 0V4h4v2"/>
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <div class="rpt-pagination">
        <span class="rpt-muted">{{ store.pagination.total }} total · page {{ store.pagination.current_page }} / {{ store.pagination.last_page }}</span>
        <div class="rpt-pages">
          <button class="rpt-pg" :disabled="page === 1" @click="page--">‹</button>
          <button class="rpt-pg" v-for="p in pageRange" :key="p"
            :class="{ active: p === page }" @click="page = p">{{ p }}</button>
          <button class="rpt-pg" :disabled="page === store.pagination.last_page" @click="page++">›</button>
        </div>
      </div>
    </div>

    <!-- Detail Modal -->
    <Transition name="fade">
      <div v-if="detailReport" class="rpt-overlay" @click.self="detailReport = null">
        <div class="rpt-modal">
          <div class="rpt-modal__head">
            <span class="rpt-modal__title">Report #{{ detailReport.id }}</span>
            <button class="rpt-modal__close" @click="detailReport = null">✕</button>
          </div>
          <div class="rpt-modal__body">

            <!-- Similarity bar -->
            <div class="rpt-analysis">
              <div class="rpt-analysis__row">
                <span class="rpt-analysis__label">Audio Similarity Analysis</span>
                <span class="rpt-analysis__pct"
                  :class="(detailReport.similarity_score ?? 0) >= 60 ? 'high' : 'low'">
                  {{ detailReport.similarity_score !== null ? detailReport.similarity_score + '%' : 'Pending...' }}
                </span>
              </div>
              <div class="rpt-analysis__track">
                <div class="rpt-analysis__fill"
                  :class="(detailReport.similarity_score ?? 0) >= 60 ? 'high' : 'low'"
                  :style="{ width: (detailReport.similarity_score ?? 0) + '%' }">
                </div>
                <div class="rpt-analysis__threshold"></div>
              </div>
              <div class="rpt-analysis__verdict"
                :class="(detailReport.similarity_score ?? 0) >= 60 ? 'violation' : 'safe'">
                <template v-if="detailReport.similarity_score === null">
                  ⏳ AI analysis in progress...
                </template>
                <template v-else-if="(detailReport.similarity_score ?? 0) >= 60">
                  ⚠️ VIOLATION — Similarity ≥ 60%. Admin action required.
                </template>
                <template v-else>
                  ✅ SAFE — Similarity &lt; 60%. No copyright violation detected.
                </template>
              </div>
              <div v-if="detailReport.comparison_duration_ms" class="rpt-analysis__meta">
                Analysis time: {{ detailReport.comparison_duration_ms }}ms
                <span v-if="detailReport.fingerprint_cache_hit"> · Cache hit</span>
              </div>
            </div>

            <!-- Song pair -->
            <div class="rpt-detail-grid">
              <div class="rpt-detail-section">
                <div class="rpt-detail-section__title">🎵 Original Song</div>
                <div class="rpt-detail-row"><span>Title</span><strong>{{ detailReport.original_song?.title ?? '—' }}</strong></div>
                <div class="rpt-detail-row"><span>Artist</span><strong>{{ detailReport.original_song?.artist?.name ?? '—' }}</strong></div>
              </div>
              <div class="rpt-detail-section">
                <div class="rpt-detail-section__title">🎤 Infringing Song</div>
                <div class="rpt-detail-row"><span>Title</span><strong>{{ detailReport.infringing_song?.title ?? '—' }}</strong></div>
                <div class="rpt-detail-row"><span>Artist</span><strong>{{ detailReport.infringing_song?.artist?.name ?? '—' }}</strong></div>
              </div>
            </div>

            <!-- Report info -->
            <div class="rpt-detail-section">
              <div class="rpt-detail-section__title">📝 Report Info</div>
              <div class="rpt-detail-row"><span>Reporter</span><strong>{{ reporterName(detailReport) }}</strong></div>
              <div class="rpt-detail-row"><span>Violation type</span><strong>{{ violationLabel(detailReport.violation_type) }}</strong></div>
              <div class="rpt-detail-row"><span>Status</span>
                <span class="rpt-status" :class="'s-' + detailReport.status">{{ statusLabel(detailReport.status) }}</span>
              </div>
              <div class="rpt-detail-row"><span>Submitted</span><strong>{{ fmtDate(detailReport.created_at) }}</strong></div>
              <div v-if="detailReport.description" class="rpt-detail-row rpt-detail-row--full">
                <span>Description</span><p>{{ detailReport.description }}</p>
              </div>
              <div v-if="detailReport.resolution_note" class="rpt-detail-row rpt-detail-row--full">
                <span>Resolution note</span><p>{{ detailReport.resolution_note }}</p>
              </div>
            </div>

            <!-- Actions -->
            <div v-if="detailReport.status === 'reviewing'" class="rpt-modal__actions">
              <div class="rpt-resolve-note">
                <label>Resolution note (optional)</label>
                <textarea v-model="resolveNote" rows="2" placeholder="Add a note..."></textarea>
              </div>
              <div class="rpt-modal__btns">
                <button class="rpt-modal-btn ghost" @click="detailReport = null">Close</button>
                <button class="rpt-modal-btn kept" @click="resolveFromModal('resolved_kept')">✓ Keep Song</button>
                <button class="rpt-modal-btn removed" @click="resolveFromModal('resolved_removed')">⛔ Block Song</button>
              </div>
            </div>
            <div v-else class="rpt-modal__actions">
              <div class="rpt-modal__btns">
                <button class="rpt-modal-btn ghost" @click="detailReport = null">Close</button>
                <button v-if="canReprocess(detailReport)" class="rpt-modal-btn reprocess"
                  @click="handleReprocess(detailReport); detailReport = null">
                  ↺ Re-run AI
                </button>
              </div>
            </div>

          </div>
        </div>
      </div>
    </Transition>

  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useAdminCopyrightReportStore, type AdminCopyrightReport } from '@/modules/admin/stores/report/copyrightReportStore'
import { useNotificationStore } from '@/store/notificationStore'

const store            = useAdminCopyrightReportStore()
const notificationStore = useNotificationStore()

// ── Filters & pagination ──────────────────────────────────────────────────
const filterStatus = ref('')
const sortBy       = ref('created_at')
const sortOrder    = ref<'desc' | 'asc'>('desc')
const page         = ref(1)
const PER_PAGE     = 15

const toggleSortOrder = () => { sortOrder.value = sortOrder.value === 'desc' ? 'asc' : 'desc' }

// ── UI state ──────────────────────────────────────────────────────────────
const detailReport = ref<AdminCopyrightReport | null>(null)
const resolveNote  = ref('')

// ── Load ──────────────────────────────────────────────────────────────────
const loadAll = async () => {
  await Promise.all([
    store.fetchReports({
      page:       page.value,
      per_page:   PER_PAGE,
      status:     filterStatus.value || undefined,
      sort_by:    sortBy.value,
      sort_order: sortOrder.value,
    }),
    store.fetchStats(),
  ])
}

onMounted(loadAll)
watch([filterStatus, sortBy, sortOrder], () => { page.value = 1; loadAll() })
watch(page, loadAll)

// ── Stats cards ───────────────────────────────────────────────────────────
const statCards = computed(() => {
  const s = store.stats
  return [
    { key: 'total',            label: 'TOTAL',            value: s?.total            ?? 0, color: 'var(--rpt-text)' },
    { key: 'reviewing',        label: 'NEEDS REVIEW',     value: s?.reviewing        ?? 0, color: '#ffffffff' },
    { key: 'resolved_removed', label: 'SONGS BLOCKED',    value: s?.resolved_removed ?? 0, color: '#ffffffff' },
    { key: 'auto_rejected',    label: 'AUTO REJECTED',    value: s?.auto_rejected    ?? 0, color: '#ffffffff' },
    { key: 'avg_similarity',   label: 'AVG SIMILARITY',
      value: s?.avg_similarity != null ? s.avg_similarity + '%' : '—', color: '#60a5fa' },
    { key: 'violation_rate',   label: 'VIOLATION RATE',
      value: s?.violation_rate != null ? s.violation_rate + '%' : '—', color: '#a78bfa' },
  ]
})

// ── Pagination range ──────────────────────────────────────────────────────
const pageRange = computed(() => {
  const last = store.pagination.last_page
  const cur  = page.value
  const range: number[] = []
  for (let p = Math.max(1, cur - 2); p <= Math.min(last, cur + 2); p++) range.push(p)
  return range
})

// ── Helpers ───────────────────────────────────────────────────────────────
const fmtDate = (d?: string | null) => d ? d.substring(0, 10) : '—'

const reporterName = (r: AdminCopyrightReport) => {
  if (r.reporter_type === 'partner') return r.reporter_partner?.company_name ?? `Partner #${r.reporter_partner_id}`
  if (r.reporter_type === 'user')    return r.reporter_user?.name ?? `User #${r.reporter_user_id}`
  return r.reporter_type
}

const violationLabel = (v: string) => ({
  melody: 'Melody', lyrics: 'Lyrics', beat: 'Beat',
  full_copy: 'Full Copy', unauthorized_remix: 'Unauth. Remix', other: 'Other',
}[v] ?? v)

const statusLabel = (s: string) => ({
  pending:          'Pending',
  ai_scanning:      'AI Scanning',
  reviewing:        'Reviewing',
  auto_rejected:    'Auto Rejected',
  resolved_removed: 'Removed',
  resolved_kept:    'Kept',
  rejected:         'Rejected',
}[s] ?? s)

const canReprocess = (r: AdminCopyrightReport) =>
  !['resolved_removed', 'resolved_kept', 'rejected'].includes(r.status)

// ── Actions ───────────────────────────────────────────────────────────────
const openDetail = async (r: AdminCopyrightReport) => {
  detailReport.value = { ...r }
  resolveNote.value  = ''
  try {
    const res = await store.fetchDetail(r.id)
    if (res?.success && store.currentReport) detailReport.value = { ...store.currentReport }
  } catch { /* keep list data */ }
}

const quickResolve = async (r: AdminCopyrightReport, status: string) => {
  try {
    await store.updateStatus(r.id, status)
    notificationStore.success(status === 'resolved_removed' ? 'Song blocked successfully' : 'Report rejected')
  } catch {
    notificationStore.error('Failed to update report')
  }
}

const resolveFromModal = async (status: string) => {
  if (!detailReport.value) return
  try {
    await store.updateStatus(detailReport.value.id, status, resolveNote.value || undefined)
    detailReport.value = null
    notificationStore.success(status === 'resolved_removed' ? 'Song blocked — reporter will be notified' : 'Song kept — report closed')
  } catch {
    notificationStore.error('Failed to update report')
  }
}

const handleReprocess = async (r: AdminCopyrightReport) => {
  try {
    await store.reprocess(r.id)
    notificationStore.success('Report queued for reprocessing')
  } catch {
    notificationStore.error('Failed to reprocess')
  }
}

const handleDelete = async (r: AdminCopyrightReport) => {
  if (!confirm(`Delete report #${r.id}? This cannot be undone.`)) return
  try {
    await store.destroy(r.id)
    notificationStore.success('Report deleted')
    if (store.reports.length === 0 && page.value > 1) page.value--
  } catch (e: any) {
    notificationStore.error(e?.response?.data?.message ?? 'Cannot delete resolved reports')
  }
}
</script>

<style scoped>
.rpt-page {
  --rpt-bg: #0f1216;
  --rpt-card: #181b1f;
  --rpt-border: #1e2d3d;
  --rpt-text: #e2e8f0;
  --rpt-muted: #4a5568;
  min-height: 100vh;
  background: var(--rpt-bg);
  color: var(--rpt-text);
  padding: 32px;
  font-family: 'DM Sans', 'Segoe UI', sans-serif;
}

/* Header */
.rpt-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 28px; }
.rpt-title  { font-size: 26px; font-weight: 800; letter-spacing: -0.5px; margin: 0 0 4px; }
.rpt-subtitle { font-size: 13px; color: var(--rpt-muted); margin: 0; }
.rpt-refresh-btn {
  display: flex; align-items: center; gap: 7px;
  background: transparent; border: 1px solid var(--rpt-border);
  color: #94a3b8; padding: 9px 16px; border-radius: 9px;
  font-size: 13px; cursor: pointer; transition: all .2s;
}
.rpt-refresh-btn:hover:not(:disabled) { border-color: #3b82f6; color: #60a5fa; }
.rpt-refresh-btn:disabled { opacity: .4; cursor: not-allowed; }
.spin { animation: spin .7s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

/* Stats */
.rpt-stats {
  display: grid; grid-template-columns: repeat(6, 1fr);
  gap: 14px; margin-bottom: 20px;
}
.rpt-stat {
  background: var(--rpt-card); border: 1px solid var(--rpt-border);
  border-radius: 12px; padding: 18px 20px;
  display: flex; flex-direction: column; gap: 10px;
}
.rpt-stat__label { font-size: 10px; font-weight: 600; letter-spacing: 1px; text-transform: uppercase; color: var(--rpt-muted); }
.rpt-stat__value { font-size: 32px; font-weight: 800; line-height: 1; }
.rpt-skeleton-num { display: inline-block; width: 48px; height: 32px; border-radius: 6px;
  background: linear-gradient(90deg, #1a2332 25%, #1e2d3d 50%, #1a2332 75%);
  background-size: 200% 100%; animation: shimmer 1.4s infinite; }
@keyframes shimmer { 0% { background-position: 200% 0; } 100% { background-position: -200% 0; } }

/* Card */
.rpt-card { background: var(--rpt-card); border: 1px solid var(--rpt-border); border-radius: 14px; padding: 22px 24px; }
.rpt-card__head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; flex-wrap: wrap; gap: 12px; }
.rpt-card__title { font-size: 15px; font-weight: 700; }
.rpt-controls { display: flex; gap: 8px; align-items: center; }
.rpt-select {
  background: #0d1117; border: 1px solid var(--rpt-border);
  border-radius: 8px; color: #94a3b8; font-size: 13px;
  padding: 8px 12px; cursor: pointer; outline: none;
}
.rpt-sort-btn {
  background: #0d1117; border: 1px solid var(--rpt-border);
  border-radius: 8px; color: #94a3b8; font-size: 16px;
  width: 34px; height: 34px; cursor: pointer;
}

/* Skeleton rows */
.rpt-skeletons { display: flex; flex-direction: column; gap: 10px; padding: 4px 0; }
.rpt-skeleton-row { height: 48px; border-radius: 8px;
  background: linear-gradient(90deg, #1a2332 25%, #1e2d3d 50%, #1a2332 75%);
  background-size: 200% 100%; animation: shimmer 1.4s infinite; }

/* Table */
.rpt-table-wrap { overflow-x: auto; }
.rpt-table { width: 100%; border-collapse: collapse; font-size: 13px; }
.rpt-table th {
  text-align: left; font-size: 10px; font-weight: 600;
  letter-spacing: 1px; text-transform: uppercase; color: var(--rpt-muted);
  padding: 10px 12px; border-bottom: 1px solid var(--rpt-border);
}
.rpt-table td { padding: 12px 12px; border-bottom: 1px solid #131d2b; vertical-align: middle; }
.rpt-row { transition: background .15s; }
.rpt-row:hover { background: #141f2e; }
.rpt-id { color: var(--rpt-muted); font-family: monospace; font-size: 12px; }
.rpt-song { display: flex; flex-direction: column; gap: 2px; }
.rpt-song strong { color: #f1f5f9; font-size: 13px; }
.rpt-song span { font-size: 11px; color: var(--rpt-muted); }
.rpt-reporter { color: #94a3b8; font-size: 12px; white-space: nowrap; }
.rpt-muted { color: var(--rpt-muted); }
.rpt-date { font-size: 12px; white-space: nowrap; }
.rpt-empty { text-align: center; color: var(--rpt-muted); padding: 48px; font-size: 13px; }

/* Similarity */
.rpt-sim-cell { min-width: 100px; }
.rpt-sim-badge { display: inline-block; padding: 3px 9px; border-radius: 20px; font-size: 12px; font-weight: 700; margin-bottom: 5px; }
.rpt-sim-badge.high { background: rgba(239,68,68,.2); color: #f87171; }
.rpt-sim-badge.low  { background: rgba(34,197,94,.2);  color: #4ade80; }
.rpt-sim-bar  { height: 4px; background: #1e2d3d; border-radius: 2px; overflow: hidden; }
.rpt-sim-fill { height: 100%; border-radius: 2px; transition: width .3s; }

/* Type badge */
.rpt-type-badge { background: #1e2d3d; color: #60a5fa; padding: 3px 9px; border-radius: 5px; font-size: 11px; font-weight: 600; white-space: nowrap; }

/* Status */
.rpt-status { display: inline-block; padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; white-space: nowrap; }
.s-pending          { background: rgba(59,130,246,.12);  color: #60a5fa;  border: 1px solid rgba(59,130,246,.25); }
.s-ai_scanning      { background: rgba(139,92,246,.12);  color: #a78bfa;  border: 1px solid rgba(139,92,246,.25); }
.s-reviewing        { background: rgba(245,158,11,.12);  color: #fbbf24;  border: 1px solid rgba(245,158,11,.25); }
.s-auto_rejected    { background: rgba(34,197,94,.12);   color: #4ade80;  border: 1px solid rgba(34,197,94,.25); }
.s-resolved_removed { background: rgba(239,68,68,.12);   color: #f87171;  border: 1px solid rgba(239,68,68,.25); }
.s-resolved_kept    { background: rgba(34,197,94,.12);   color: #4ade80;  border: 1px solid rgba(34,197,94,.25); }
.s-rejected         { background: rgba(100,116,139,.12); color: #94a3b8;  border: 1px solid rgba(100,116,139,.25); }

/* Action buttons */
.rpt-actions { display: flex; gap: 5px; }
.rpt-btn {
  width: 30px; height: 30px; border-radius: 7px;
  border: 1px solid var(--rpt-border); background: #0d1117;
  cursor: pointer; display: flex; align-items: center; justify-content: center;
  color: #64748b; transition: all .2s;
}
.rpt-btn.view:hover     { border-color: #3b82f6; color: #60a5fa; background: rgba(59,130,246,.1); }
.rpt-btn.approve:hover  { border-color: #22c55e; color: #4ade80; background: rgba(34,197,94,.1); }
.rpt-btn.reject:hover   { border-color: #ef4444; color: #f87171; background: rgba(239,68,68,.1); }
.rpt-btn.reprocess:hover{ border-color: #a78bfa; color: #a78bfa; background: rgba(139,92,246,.1); }
.rpt-btn.delete:hover   { border-color: #ef4444; color: #f87171; background: rgba(239,68,68,.1); }

/* Pagination */
.rpt-pagination { display: flex; justify-content: space-between; align-items: center; margin-top: 16px; padding-top: 14px; border-top: 1px solid var(--rpt-border); font-size: 12px; }
.rpt-pages { display: flex; gap: 4px; }
.rpt-pg { background: #0d1117; border: 1px solid var(--rpt-border); color: #64748b; width: 30px; height: 30px; border-radius: 6px; cursor: pointer; font-size: 13px; transition: all .2s; }
.rpt-pg:disabled { opacity: .3; cursor: not-allowed; }
.rpt-pg.active { background: #1d4ed8; color: #fff; border-color: #1d4ed8; }
.rpt-pg:hover:not(:disabled):not(.active) { background: #1e2d3d; color: #cbd5e1; }

/* Modal */
.rpt-overlay { position: fixed; inset: 0; background: rgba(0,0,0,.75); backdrop-filter: blur(4px); display: flex; align-items: center; justify-content: center; z-index: 9999; }
.rpt-modal { background: var(--rpt-card); border: 1px solid var(--rpt-border); border-radius: 18px; width: 580px; max-width: 95vw; max-height: 90vh; overflow-y: auto; box-shadow: 0 25px 60px rgba(0,0,0,.6); }
.rpt-modal__head { display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid var(--rpt-border); }
.rpt-modal__title { font-size: 16px; font-weight: 700; }
.rpt-modal__close { background: none; border: none; color: var(--rpt-muted); font-size: 18px; cursor: pointer; padding: 2px 6px; border-radius: 6px; }
.rpt-modal__close:hover { color: var(--rpt-text); background: #252a38; }
.rpt-modal__body { padding: 24px; }

/* Analysis section */
.rpt-analysis { background: #0d1117; border-radius: 12px; padding: 18px; margin-bottom: 22px; }
.rpt-analysis__row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
.rpt-analysis__label { font-size: 12px; font-weight: 600; color: #94a3b8; }
.rpt-analysis__pct { font-size: 28px; font-weight: 800; }
.rpt-analysis__pct.high { color: #ef4444; }
.rpt-analysis__pct.low  { color: #22c55e; }
.rpt-analysis__track { position: relative; height: 10px; background: #1e2d3d; border-radius: 5px; overflow: visible; margin-bottom: 10px; }
.rpt-analysis__fill { height: 100%; border-radius: 5px; transition: width .5s ease; }
.rpt-analysis__fill.high { background: #ef4444; }
.rpt-analysis__fill.low  { background: #22c55e; }
.rpt-analysis__threshold { position: absolute; left: 60%; top: -4px; bottom: -4px; width: 2px; background: #f59e0b; border-radius: 1px; }
.rpt-analysis__verdict { padding: 10px 14px; border-radius: 9px; font-size: 13px; font-weight: 600; margin-bottom: 8px; }
.rpt-analysis__verdict.violation { background: rgba(239,68,68,.15); color: #f87171; }
.rpt-analysis__verdict.safe      { background: rgba(34,197,94,.15);  color: #4ade80; }
.rpt-analysis__meta { font-size: 11px; color: var(--rpt-muted); }

/* Detail grid */
.rpt-detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 18px; }
.rpt-detail-section { padding-bottom: 16px; border-bottom: 1px solid var(--rpt-border); }
.rpt-detail-section:last-child { border-bottom: none; }
.rpt-detail-section__title { font-size: 12px; font-weight: 600; color: var(--rpt-muted); margin-bottom: 10px; }
.rpt-detail-row { display: flex; gap: 10px; padding: 5px 0; font-size: 13px; }
.rpt-detail-row span:first-child { width: 110px; color: var(--rpt-muted); font-size: 12px; flex-shrink: 0; }
.rpt-detail-row--full { flex-direction: column; gap: 4px; }
.rpt-detail-row--full p { color: #cbd5e1; font-size: 13px; line-height: 1.5; margin: 0; }

/* Modal actions */
.rpt-modal__actions { margin-top: 20px; }
.rpt-resolve-note { margin-bottom: 14px; }
.rpt-resolve-note label { display: block; font-size: 12px; color: var(--rpt-muted); margin-bottom: 6px; }
.rpt-resolve-note textarea { width: 100%; background: #0d1117; border: 1px solid var(--rpt-border); border-radius: 8px; color: #cbd5e1; font-size: 13px; padding: 10px 12px; resize: vertical; outline: none; box-sizing: border-box; }
.rpt-resolve-note textarea:focus { border-color: rgba(59,130,246,.5); }
.rpt-modal__btns { display: flex; gap: 10px; justify-content: flex-end; }
.rpt-modal-btn { padding: 10px 18px; border-radius: 9px; border: none; font-size: 13px; font-weight: 600; cursor: pointer; transition: opacity .2s; }
.rpt-modal-btn:hover { opacity: .85; }
.rpt-modal-btn.ghost    { background: transparent; border: 1px solid var(--rpt-border); color: #94a3b8; }
.rpt-modal-btn.removed  { background: #ef4444; color: #fff; }
.rpt-modal-btn.kept     { background: #22c55e; color: #fff; }
.rpt-modal-btn.reprocess{ background: #7c3aed; color: #fff; }

/* Toast */
.rpt-toast { position: fixed; bottom: 28px; right: 28px; padding: 12px 20px; border-radius: 10px; font-size: 13px; font-weight: 500; z-index: 10000; box-shadow: 0 8px 24px rgba(0,0,0,.4); }
.rpt-toast.success { background: rgba(34,197,94,.15); border: 1px solid rgba(34,197,94,.3); color: #4ade80; }
.rpt-toast.error   { background: rgba(239,68,68,.12); border: 1px solid rgba(239,68,68,.25); color: #f87171; }

/* Transitions */
.fade-enter-active, .fade-leave-active { transition: opacity .2s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
.slide-up-enter-active, .slide-up-leave-active { transition: all .3s; }
.slide-up-enter-from, .slide-up-leave-to { opacity: 0; transform: translateY(12px); }

/* Responsive */
@media (max-width: 1200px) { .rpt-stats { grid-template-columns: repeat(3, 1fr); } }
@media (max-width: 768px)  { .rpt-stats { grid-template-columns: repeat(2, 1fr); } .rpt-page { padding: 16px; } }
</style>

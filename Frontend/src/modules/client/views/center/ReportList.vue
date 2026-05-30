<template>
  <div class="cr-page">
    <!-- Hero Banner -->
    <section class="cr-hero">
      <div class="cr-hero__bg"></div>
      <div class="cr-container">
        <div class="cr-hero__inner">
          <h1 class="cr-hero__title">My Reports</h1>
          <p class="cr-hero__subtitle">Track your copyright infringement reports on <strong>Melody Hub.</strong></p>
        </div>
      </div>
    </section>

    <!-- Reports List -->
    <section class="cr-section">
      <div class="cr-container cr-container--narrow">

        <!-- Stat Cards -->
        <div class="cr-stats">
          <div class="cr-stat-card cr-stat-card--amber">
            <div class="cr-stat-card__num">{{ statCounts.pending }}</div>
            <div class="cr-stat-card__label">Pending</div>
          </div>
          <div class="cr-stat-card cr-stat-card--blue">
            <div class="cr-stat-card__num">{{ statCounts.reviewing }}</div>
            <div class="cr-stat-card__label">Reviewing</div>
          </div>
          <div class="cr-stat-card cr-stat-card--green">
            <div class="cr-stat-card__num">{{ statCounts.resolved }}</div>
            <div class="cr-stat-card__label">Resolved</div>
          </div>
          <div class="cr-stat-card cr-stat-card--red">
            <div class="cr-stat-card__num">{{ statCounts.rejected }}</div>
            <div class="cr-stat-card__label">Rejected</div>
          </div>
        </div>

        <!-- Toolbar -->
        <div class="cr-toolbar">
          <div class="cr-toolbar__left">
            <div class="cr-search">
              <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
              <input v-model="searchQuery" type="text" placeholder="Search songs..." @input="onSearch" />
              <button v-if="searchQuery" type="button" class="cr-search__clear" @click="searchQuery = ''; onSearch()">
                <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
              </button>
            </div>
            <div class="cr-filter-tabs">
              <button
                v-for="tab in filterTabs"
                :key="tab.value"
                class="cr-filter-tab"
                :class="{ 'cr-filter-tab--active': activeFilter === tab.value }"
                @click="setFilter(tab.value)"
              >
                {{ tab.label }}
              </button>
            </div>
          </div>
          <router-link to="/center/copyright-report" class="cr-btn-new">
            <svg width="13" height="13" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            New Report
          </router-link>
        </div>

        <!-- List -->
        <div class="cr-list">
          <!-- Loading -->
          <div v-if="loading" class="cr-empty">
            <span class="cr-spinner cr-spinner--lg"></span>
            <p>Loading reports...</p>
          </div>

          <!-- Empty -->
          <div v-else-if="!filteredReports.length" class="cr-empty">
            <svg width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
            <p>No reports found</p>
            <router-link to="/center/copyright-report" class="cr-btn-new" style="margin-top:8px">Submit your first report</router-link>
          </div>

          <!-- Items -->
          <template v-else>
            <div
              v-for="item in filteredReports"
              :key="item.id"
              class="cr-report-item"
            >
              <!-- Original Song Cover -->
              <div class="cr-report-item__cover" :style="getCoverStyle(item.original_song)">
                <svg v-if="!item.original_song?.cover_url" width="16" height="16" fill="rgba(255,255,255,0.5)" viewBox="0 0 24 24"><path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/></svg>
              </div>

              <div class="cr-report-item__main">
                <!-- Song pair -->
                <div class="cr-report-item__title">
                  <span>{{ item.original_song?.title ?? `Song #${item.original_song_id}` }}</span>
                  <span class="cr-vs">vs</span>
                  <span class="cr-report-item__title--infringing">{{ item.infringing_song?.title ?? `Song #${item.infringing_song_id}` }}</span>
                </div>

                <div class="cr-report-item__meta">
                  <!-- Violation type -->
                  <span class="cr-report-item__type">{{ formatViolationType(item.violation_type) }}</span>

                  <!-- Similarity score if available -->
                  <span v-if="item.similarity_score != null" class="cr-report-item__similarity" :class="getSimilarityClass(item.similarity_score)">
                    {{ item.similarity_score }}% match
                  </span>

                  <!-- Date -->
                  <span class="cr-report-item__date">{{ formatDate(item.created_at) }}</span>
                </div>

                <!-- Description preview -->
                <div v-if="item.description" class="cr-report-item__desc">
                  {{ item.description.length > 100 ? item.description.slice(0, 100) + '…' : item.description }}
                </div>
              </div>

              <div class="cr-report-item__right">
                <span class="cr-badge" :class="'cr-badge--' + normalizeStatus(item.status)">
                  {{ formatStatus(item.status) }}
                </span>
                <!-- Resolution note if resolved/rejected -->
                <div v-if="item.resolution_note" class="cr-report-item__note" :title="item.resolution_note">
                  <svg width="11" height="11" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>
                  Note
                </div>
              </div>
            </div>
          </template>
        </div>

        <!-- Pagination -->
        <div v-if="meta && meta.last_page > 1" class="cr-pagination">
          <span class="cr-pagination__info">
            Showing {{ (meta.current_page - 1) * meta.per_page + 1 }}–{{ Math.min(meta.current_page * meta.per_page, meta.total) }} of {{ meta.total }} reports
          </span>
          <div class="cr-pagination__btns">
            <button class="cr-page-btn" :disabled="meta.current_page <= 1" @click="changePage(meta.current_page - 1)">
              <svg width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
            </button>
            <button
              v-for="p in pageNumbers"
              :key="p"
              class="cr-page-btn"
              :class="{ 'cr-page-btn--active': p === meta.current_page }"
              @click="changePage(p)"
            >
              {{ p }}
            </button>
            <button class="cr-page-btn" :disabled="meta.current_page >= meta.last_page" @click="changePage(meta.current_page + 1)">
              <svg width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>
            </button>
          </div>
        </div>

      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import clientApi from '@/plugins/axios'

const router = useRouter()

// ── Types ──
interface Song {
  id: number
  title: string
  cover_url?: string | null
}

interface CopyrightReport {
  id: number
  original_song_id: number
  infringing_song_id: number
  original_song?: Song | null
  infringing_song?: Song | null
  violation_type: string
  description?: string | null
  similarity_score?: number | null
  status: string
  resolution_note?: string | null
  created_at: string
}

interface PaginationMeta {
  current_page: number
  last_page: number
  per_page: number
  total: number
}

// ── State ──
const loading      = ref(false)
const reports      = ref<CopyrightReport[]>([])
const meta         = ref<PaginationMeta | null>(null)
const searchQuery  = ref('')
const activeFilter = ref('all')
let   searchTimer: ReturnType<typeof setTimeout>

// ── Filter tabs ──
const filterTabs = [
  { value: 'all',      label: 'All' },
  { value: 'pending',  label: 'Pending' },
  { value: 'scanning', label: 'Scanning' },
  { value: 'reviewing',label: 'Reviewing' },
  { value: 'resolved', label: 'Resolved' },
  { value: 'rejected', label: 'Rejected' },
]

// ── Stat counts (computed from loaded data) ──
const statCounts = computed(() => {
  const all = reports.value
  return {
    pending:  all.filter(r => r.status === 'pending' || r.status === 'ai_scanning').length,
    reviewing:all.filter(r => r.status === 'reviewing').length,
    resolved: all.filter(r => r.status === 'resolved_removed' || r.status === 'resolved_kept').length,
    rejected: all.filter(r => r.status === 'rejected' || r.status === 'auto_rejected').length,
  }
})

// ── Filtered list (client-side filter + search on current page) ──
const filteredReports = computed(() => {
  let list = reports.value

  // Filter by status tab
  if (activeFilter.value !== 'all') {
    if (activeFilter.value === 'pending') {
      list = list.filter(r => r.status === 'pending' || r.status === 'ai_scanning')
    } else if (activeFilter.value === 'scanning') {
      list = list.filter(r => r.status === 'ai_scanning')
    } else if (activeFilter.value === 'resolved') {
      list = list.filter(r => r.status === 'resolved_removed' || r.status === 'resolved_kept')
    } else if (activeFilter.value === 'rejected') {
      list = list.filter(r => r.status === 'rejected' || r.status === 'auto_rejected')
    } else {
      list = list.filter(r => r.status === activeFilter.value)
    }
  }

  // Search by song title
  if (searchQuery.value.trim()) {
    const q = searchQuery.value.toLowerCase()
    list = list.filter(r =>
      r.original_song?.title?.toLowerCase().includes(q) ||
      r.infringing_song?.title?.toLowerCase().includes(q)
    )
  }

  return list
})

// ── Pagination ──
const pageNumbers = computed(() => {
  if (!meta.value) return []
  const { current_page, last_page } = meta.value
  const pages: number[] = []
  const start = Math.max(1, current_page - 2)
  const end   = Math.min(last_page, current_page + 2)
  for (let i = start; i <= end; i++) pages.push(i)
  return pages
})

// ── Helpers ──
const coverGradients = [
  'linear-gradient(135deg,#1a1a2e,#0f3460)',
  'linear-gradient(135deg,#2d1b69,#11998e)',
  'linear-gradient(135deg,#1a1a1a,#c94b4b)',
  'linear-gradient(135deg,#0f2027,#2c5364)',
  'linear-gradient(135deg,#1c3a2a,#1f9350)',
  'linear-gradient(135deg,#134e5e,#71b280)',
  'linear-gradient(135deg,#4a1942,#c94b4b)',
  'linear-gradient(135deg,#16213e,#533483)',
]

const getCoverStyle = (song: Song | null | undefined) => {
  if (song?.cover_url) {
    return { backgroundImage: `url(${song.cover_url})`, backgroundSize: 'cover', backgroundPosition: 'center' }
  }
  return { background: coverGradients[(song?.id ?? 0) % coverGradients.length] }
}

const formatDate = (dateStr: string) => {
  if (!dateStr) return '—'
  return new Date(dateStr).toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' })
}

const formatViolationType = (type: string) => {
  const map: Record<string, string> = {
    melody:             'Melody',
    lyrics:             'Lyrics',
    beat:               'Beat',
    full_copy:          'Full Copy',
    unauthorized_remix: 'Unauth. Remix',
    other:              'Other',
  }
  return map[type] ?? type
}

const formatStatus = (status: string) => {
  const map: Record<string, string> = {
    pending:          'Pending',
    ai_scanning:      'AI Scanning',
    auto_rejected:    'Auto Rejected',
    reviewing:        'Reviewing',
    resolved_removed: 'Resolved',
    resolved_kept:    'Resolved',
    rejected:         'Rejected',
  }
  return map[status] ?? status
}

// Map status to badge CSS class
const normalizeStatus = (status: string) => {
  if (status === 'resolved_removed' || status === 'resolved_kept') return 'resolved'
  if (status === 'ai_scanning') return 'scanning'
  if (status === 'auto_rejected') return 'rejected'
  return status
}

const getSimilarityClass = (score: number) => ({
  'cr-similarity--high':   score >= 80,
  'cr-similarity--medium': score >= 60 && score < 80,
  'cr-similarity--low':    score < 60,
})

// ── Fetch ──
const fetchReports = async (page = 1) => {
  loading.value = true
  try {
    const res = await clientApi.get('/report/my-reports', {
      params: { page, per_page: 20 },
    })
    const payload = res.data?.data
    // Laravel paginate returns { data: [...], current_page, last_page, ... }
    if (payload?.data) {
      reports.value = payload.data
      meta.value = {
        current_page: payload.current_page,
        last_page:    payload.last_page,
        per_page:     payload.per_page,
        total:        payload.total,
      }
    } else {
      reports.value = payload ?? []
      meta.value = null
    }
  } catch (err: any) {
    reports.value = []
    meta.value = null
  } finally {
    loading.value = false
  }
}

const setFilter = (value: string) => {
  activeFilter.value = value
}

const onSearch = () => {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {}, 350)
}

const changePage = (page: number) => fetchReports(page)

// ── Init ──
onMounted(() => fetchReports())
</script>

<style scoped>
.cr-page { min-height: 100vh; color: #fff; font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; }
.cr-container { max-width: 1100px; margin: 0 auto; padding: 0 24px; }
.cr-container--narrow { max-width: 860px; }

/* Hero */
.cr-hero { position: relative; padding: 72px 0 60px; overflow: hidden; }
.cr-hero__bg { position: absolute; inset: 0; background: radial-gradient(ellipse 80% 60% at 50% 0%, #1c3e3a 0%, transparent 70%); pointer-events: none; }
.cr-hero__inner { position: relative; text-align: center; max-width: 680px; margin: 0 auto; }
.cr-hero__title { font-size: clamp(2rem, 5vw, 3rem); font-weight: 800; background: linear-gradient(135deg, #fff 30%, #1f9350); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; margin-bottom: 16px; line-height: 1.15; }
.cr-hero__subtitle { font-size: 1.05rem; color: rgba(255,255,255,0.6); line-height: 1.7; }
.cr-hero__subtitle strong { color: #1f9350; }

/* Section */
.cr-section { padding: 0 0 60px; }

/* Stats */
.cr-stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-bottom: 24px; }
.cr-stat-card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 12px; padding: 16px 18px; }
.cr-stat-card__num { font-size: 1.6rem; font-weight: 800; margin-bottom: 4px; color: #fff; }
.cr-stat-card__label { font-size: 11px; color: rgba(255,255,255,0.4); text-transform: uppercase; letter-spacing: 0.05em; }

/* Toolbar */
.cr-toolbar { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-bottom: 20px; flex-wrap: wrap; }
.cr-toolbar__left { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }

.cr-search { display: flex; align-items: center; gap: 8px; background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.12); border-radius: 10px; padding: 9px 14px; }
.cr-search input { background: none; border: none; outline: none; color: #fff; font-size: 13px; font-family: inherit; width: 200px; }
.cr-search input::placeholder { color: rgba(255,255,255,0.3); }
.cr-search__clear { background: none; border: none; color: rgba(255,255,255,0.3); cursor: pointer; display: flex; align-items: center; transition: color 0.15s; padding: 0; }
.cr-search__clear:hover { color: rgba(255,255,255,0.7); }

.cr-filter-tabs { display: flex; gap: 6px; flex-wrap: wrap; }
.cr-filter-tab { padding: 7px 14px; border-radius: 20px; font-size: 12px; font-weight: 600; border: 1px solid rgba(255,255,255,0.12); background: rgba(255,255,255,0.05); color: rgba(255,255,255,0.45); cursor: pointer; font-family: inherit; transition: all 0.15s; }
.cr-filter-tab:hover { color: rgba(255,255,255,0.75); border-color: rgba(255,255,255,0.22); }
.cr-filter-tab--active { background: rgba(31,147,80,0.18); border-color: rgba(31,147,80,0.5); color: #4ade80; }

.cr-btn-new { display: inline-flex; align-items: center; gap: 7px; padding: 9px 18px; border-radius: 10px; font-size: 13px; font-weight: 600; background: linear-gradient(135deg, #1f9350, #157a3f); color: #fff; border: none; cursor: pointer; font-family: inherit; transition: all 0.2s; box-shadow: 0 4px 18px rgba(31,147,80,0.3); text-decoration: none; }
.cr-btn-new:hover { transform: translateY(-1px); box-shadow: 0 6px 24px rgba(31,147,80,0.45); }

/* List */
.cr-list { display: flex; flex-direction: column; gap: 10px; min-height: 200px; }

.cr-report-item { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.09); border-radius: 14px; padding: 16px 20px; display: grid; grid-template-columns: 44px 1fr auto; gap: 16px; align-items: center; transition: border-color 0.2s, background 0.2s; }
.cr-report-item:hover { background: rgba(255,255,255,0.07); border-color: rgba(31,147,80,0.35); }

.cr-report-item__cover { width: 44px; height: 44px; border-radius: 10px; flex-shrink: 0; display: flex; align-items: center; justify-content: center; overflow: hidden; }

.cr-report-item__main { display: flex; flex-direction: column; gap: 5px; min-width: 0; }
.cr-report-item__title { font-size: 14px; font-weight: 700; color: #f0f4f8; display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
.cr-report-item__title--infringing { color: rgba(255,255,255,0.55); font-weight: 500; }
.cr-vs { font-size: 11px; font-weight: 700; color: rgba(255,100,100,0.7); background: rgba(255,100,100,0.1); border: 1px solid rgba(255,100,100,0.2); border-radius: 4px; padding: 1px 5px; flex-shrink: 0; }

.cr-report-item__meta { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
.cr-report-item__type { font-size: 11px; font-weight: 600; padding: 2px 9px; border-radius: 20px; background: rgba(31,147,80,0.12); color: #4ade80; border: 1px solid rgba(31,147,80,0.25); text-transform: capitalize; }
.cr-report-item__date { font-size: 11px; color: rgba(255,255,255,0.3); }
.cr-report-item__desc { font-size: 12px; color: rgba(255,255,255,0.35); line-height: 1.5; }
.cr-report-item__note { display: inline-flex; align-items: center; gap: 4px; font-size: 11px; color: rgba(255,255,255,0.3); cursor: help; }

/* Similarity badge */
.cr-report-item__similarity { font-size: 11px; font-weight: 700; padding: 2px 9px; border-radius: 20px; }
.cr-similarity--high   { background: rgba(239,68,68,0.12);  color: #f87171; border: 1px solid rgba(239,68,68,0.25); }
.cr-similarity--medium { background: rgba(245,158,11,0.12); color: #fbbf24; border: 1px solid rgba(245,158,11,0.25); }
.cr-similarity--low    { background: rgba(255,255,255,0.06); color: rgba(255,255,255,0.4); border: 1px solid rgba(255,255,255,0.1); }

.cr-report-item__right { display: flex; flex-direction: column; align-items: flex-end; gap: 8px; flex-shrink: 0; }

/* Badge */
.cr-badge { font-size: 11px; font-weight: 600; padding: 4px 11px; border-radius: 20px; text-transform: capitalize; white-space: nowrap; }
.cr-badge--pending   { background: rgba(245,158,11,0.12);  color: #fbbf24; border: 1px solid rgba(245,158,11,0.3); }
.cr-badge--scanning  { background: rgba(139,92,246,0.12);  color: #a78bfa; border: 1px solid rgba(139,92,246,0.3); }
.cr-badge--reviewing { background: rgba(59,130,246,0.1);   color: #60a5fa; border: 1px solid rgba(59,130,246,0.25); }
.cr-badge--resolved  { background: rgba(34,197,94,0.12);   color: #4ade80; border: 1px solid rgba(34,197,94,0.3); }
.cr-badge--rejected  { background: rgba(239,68,68,0.1);    color: #f87171; border: 1px solid rgba(239,68,68,0.25); }

/* Empty / Loading */
.cr-empty { display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 14px; padding: 60px 20px; color: rgba(255,255,255,0.3); text-align: center; }
.cr-empty svg { opacity: 0.3; }
.cr-empty p { font-size: 14px; }

/* Spinner */
.cr-spinner { display: inline-block; border-radius: 50%; border: 2px solid rgba(255,255,255,0.15); border-top-color: #1f9350; animation: spin 0.7s linear infinite; }
.cr-spinner--lg { width: 36px; height: 36px; border-width: 3px; }
@keyframes spin { to { transform: rotate(360deg); } }

/* Pagination */
.cr-pagination { display: flex; align-items: center; justify-content: space-between; margin-top: 24px; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.07); }
.cr-pagination__info { font-size: 12px; color: rgba(255,255,255,0.35); }
.cr-pagination__btns { display: flex; gap: 6px; }
.cr-page-btn { width: 32px; height: 32px; border-radius: 8px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); color: rgba(255,255,255,0.5); display: flex; align-items: center; justify-content: center; cursor: pointer; font-size: 12px; font-family: inherit; font-weight: 600; transition: all 0.15s; }
.cr-page-btn:hover:not(:disabled) { background: rgba(255,255,255,0.1); color: #fff; }
.cr-page-btn:disabled { opacity: 0.3; cursor: not-allowed; }
.cr-page-btn--active { background: rgba(31,147,80,0.2); border-color: rgba(31,147,80,0.5); color: #4ade80; }

@media (max-width: 600px) {
  .cr-stats { grid-template-columns: repeat(2, 1fr); }
  .cr-report-item { grid-template-columns: 36px 1fr; }
  .cr-report-item__right { display: none; }
  .cr-toolbar { flex-direction: column; align-items: stretch; }
  .cr-search input { width: 100%; }
}
</style>

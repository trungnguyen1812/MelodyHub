<template>
  <div class="copyright-dashboard">
    <!-- Header -->
    <div class="header">
      <div class="header-left">
        <h1 class="title">Copyright Management</h1>
        <p class="subtitle">Manage & verify song copyright requests</p>
      </div>
    </div>

    <!-- Stat Cards -->
    <div class="stats-grid">
      <div class="stat-card" v-for="stat in statCards" :key="stat.key">
        <div class="stat-label">{{ stat.label }}</div>
        <div class="stat-value">
          <span v-if="store.statsLoading" class="skeleton-num"></span>
          <span v-else>{{ stat.value }}</span>
        </div>
      </div>
    </div>

    <!-- Charts Row -->
    <div class="charts-row">
      <!-- Bar Chart: by type -->
      <div class="chart-card">
        <div class="chart-header">
          <span class="chart-title">Requests by Type</span>
          <div class="legend">
            <span class="dot blue"></span><span>Total</span>
            <span class="dot green"></span><span>~Verified</span>
          </div>
        </div>
        <div class="bar-chart">
          <div class="bars-container">
            <div v-if="barData.length === 0" class="empty-chart">No data</div>
            <div class="bar-group" v-for="item in barData" :key="item.name">
              <div class="bar-wrap">
                <div class="bar total"    :style="{ height: item.totalH    + 'px' }"></div>
                <div class="bar verified" :style="{ height: item.verifiedH + 'px' }"></div>
              </div>
              <div class="bar-label">{{ item.name }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Status Progress -->
      <div class="chart-card">
        <div class="chart-title" style="margin-bottom:20px">Copyright Status</div>
        <div class="status-list">
          <div class="status-item" v-for="s in statusProgress" :key="s.label">
            <div class="status-row">
              <span class="status-name">{{ s.label }}</span>
              <span class="status-count">{{ s.count }} ({{ s.pct }}%)</span>
            </div>
            <div class="progress-track">
              <div class="progress-fill" :style="{ width: s.pct + '%', background: s.color }"></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Table -->
    <div class="table-card">
      <div class="table-header">
        <span class="chart-title">Copyright List</span>
        <div class="table-controls">
          <div class="search-wrap">
            <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
            </svg>
            <input v-model="search" class="search-input" placeholder="Search song / owner..." />
          </div>
          <select v-model="filterStatus" class="filter-select">
            <option value="">All statuses</option>
            <option value="active">Verified</option>
            <option value="pending">Pending</option>
            <option value="revoked">Rejected</option>
            <option value="disputed">Disputed</option>
            <option value="expired">Expired</option>
          </select>
          <select v-model="filterType" class="filter-select">
            <option value="">All types</option>
            <option value="author">Author</option>
            <option value="performer">Performer</option>
            <option value="producer">Producer</option>
            <option value="publisher">Publisher</option>
            <option value="exclusive">Exclusive</option>
            <option value="non_exclusive">Non-exclusive</option>
          </select>
        </div>
      </div>

      <!-- Loading skeleton -->
      <div v-if="store.loading" class="loading-rows">
        <div class="skeleton-row" v-for="i in 5" :key="i"></div>
      </div>

      <table v-else class="data-table">
        <thead>
          <tr>
            <th>SONG</th>
            <th>OWNER</th>
            <th>TYPE</th>
            <th>STATUS</th>
            <th>SUBMITTED</th>
            <th>VALID UNTIL</th>
            <th>TERRITORY</th>
            <th>ACTIONS</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="store.copyrights.length === 0">
            <td colspan="8" class="empty-row">No copyright records found</td>
          </tr>
          <tr v-for="row in store.copyrights" :key="row.id" class="table-row">
            <td>
              <div class="song-cell">
                <div class="song-avatar" :style="{ background: getAvatarColor(row.id) }">
                  {{ getInitials(row.song?.title) }}
                </div>
                <div>
                  <div class="song-name">{{ row.song?.title ?? '—' }}</div>
                  <div class="song-id">{{ row.song?.artist?.name ?? '—' }}</div>
                </div>
              </div>
            </td>
            <td class="muted">{{ row.owner_name }}</td>
            <td><span class="type-badge">{{ row.copyright_type.replace('_', ' ') }}</span></td>
            <td>
              <span class="status-badge" :class="statusClass(row.status)">
                {{ statusLabel(row.status) }}
              </span>
            </td>
            <td class="muted">{{ formatDate(row.created_at) }}</td>
            <td class="muted">{{ formatDate(row.valid_until) }}</td>
            <td class="muted">{{ row.territory ?? '—' }}</td>
            <td>
              <div class="action-btns">
                <button class="act-btn view" @click="openDetail(row)" title="View Detail">
                  <svg width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                  </svg>
                </button>
                <button class="act-btn verify" v-if="row.status === 'pending'" @click="handleApprove(row)" title="Approve">
                  <svg width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <polyline points="20 6 9 17 4 12"/>
                  </svg>
                </button>
                <button class="act-btn reject" v-if="row.status === 'pending' || row.status === 'disputed'" @click="openRejectModal(row)" title="Reject">
                  <svg width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
                  </svg>
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>

      <div class="table-footer">
        <span class="muted">Total {{ store.pagination.total }} records</span>
        <div class="pagination">
          <button class="pg-btn" :disabled="page === 1" @click="page--">‹</button>
          <span
            class="pg-num"
            v-for="p in totalPages"
            :key="p"
            :class="{ active: p === page }"
            @click="page = p"
          >{{ p }}</span>
          <button class="pg-btn" :disabled="page === totalPages" @click="page++">›</button>
        </div>
      </div>
    </div>

    <!-- Detail Modal — không dùng Teleport, đặt trong component để scoped styles hoạt động -->
    <transition name="fade">
      <div v-if="detailRow" class="cr-modal-overlay" @click.self="detailRow = null">
        <div class="cr-modal">
          <div class="cr-modal-header">
            <span class="cr-modal-title">Copyright Detail</span>
            <button class="cr-modal-close" @click="detailRow = null">✕</button>
          </div>
          <div class="cr-modal-body">
            <div v-if="detailLoading" class="cr-detail-loading">
              <span class="cr-detail-spinner"></span> Loading...
            </div>
            <div class="cr-detail-hero">
              <div class="cr-detail-avatar" :style="{ background: getAvatarColor(detailRow.id) }">
                {{ getInitials(detailRow.song?.title) }}
              </div>
              <div>
                <div class="cr-detail-song">{{ detailRow.song?.title ?? '—' }}</div>
                <div class="cr-detail-artist">{{ detailRow.song?.artist?.name ?? '—' }}</div>
              </div>
            </div>
            <div class="cr-detail-grid">
              <div class="cr-detail-item">
                <div class="cr-detail-label">Copyright ID</div>
                <div class="cr-detail-value">#{{ detailRow.id }}</div>
              </div>
              <div class="cr-detail-item">
                <div class="cr-detail-label">Type</div>
                <div class="cr-detail-value">{{ detailRow.copyright_type.replace('_', ' ') }}</div>
              </div>
              <div class="cr-detail-item">
                <div class="cr-detail-label">Status</div>
                <div class="cr-detail-value">
                  <span class="status-badge" :class="statusClass(detailRow.status)">{{ statusLabel(detailRow.status) }}</span>
                </div>
              </div>
              <div class="cr-detail-item">
                <div class="cr-detail-label">Owner</div>
                <div class="cr-detail-value">{{ detailRow.owner_name }}</div>
              </div>
              <div class="cr-detail-item">
                <div class="cr-detail-label">Valid From</div>
                <div class="cr-detail-value">{{ formatDate(detailRow.valid_from) }}</div>
              </div>
              <div class="cr-detail-item">
                <div class="cr-detail-label">Valid Until</div>
                <div class="cr-detail-value">{{ formatDate(detailRow.valid_until) }}</div>
              </div>
              <div class="cr-detail-item">
                <div class="cr-detail-label">Territory</div>
                <div class="cr-detail-value">{{ detailRow.territory ?? '—' }}</div>
              </div>
              <div class="cr-detail-item">
                <div class="cr-detail-label">Reg. Number</div>
                <div class="cr-detail-value">{{ detailRow.registration_number ?? '—' }}</div>
              </div>
              <div class="cr-detail-item" v-if="detailRow.document_url">
                <div class="cr-detail-label">Document</div>
                <div class="cr-detail-value">
                  <div class="cr-doc-actions">
                    <button class="cr-doc-preview-btn" @click="openDocViewer(detailRow.document_url!)">
                      <svg width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                      </svg>
                      Preview
                    </button>
                    <br>
                    <a :href="detailRow.document_url" target="_blank" class="cr-doc-link">Download ↗</a>
                  </div>
                </div>
              </div>
              <div class="cr-detail-item" v-if="detailRow.notes">
                <div class="cr-detail-label">Notes</div>
                <div class="cr-detail-value">{{ detailRow.notes }}</div>
              </div>
              <div class="cr-detail-item">
                <div class="cr-detail-label">Partner</div>
                <div class="cr-detail-value">{{ detailRow.partner?.company_name ?? '—' }}</div>
              </div>
              <div class="cr-detail-item">
                <div class="cr-detail-label">Submitted</div>
                <div class="cr-detail-value">{{ formatDate(detailRow.created_at) }}</div>
              </div>
            </div>
            <div class="cr-modal-actions" v-if="detailRow.status === 'pending'">
              <button class="cr-modal-btn cr-modal-btn--verify" @click="handleApprove(detailRow)">✓ Approve</button>
              <button class="cr-modal-btn cr-modal-btn--reject" @click="openRejectModal(detailRow); detailRow = null">✕ Reject</button>
            </div>
          </div>
        </div>
      </div>
    </transition>

    <!-- Reject Modal -->
    <transition name="fade">
      <div v-if="rejectModal" class="cr-modal-overlay" @click.self="rejectModal = false">
        <div class="cr-modal cr-modal--sm">
          <div class="cr-modal-header">
            <span class="cr-modal-title">Reject Copyright</span>
            <button class="cr-modal-close" @click="rejectModal = false">✕</button>
          </div>
          <div class="cr-modal-body">
            <p class="cr-reject-song">Song: <strong>{{ rejectTarget?.song?.title }}</strong></p>
            <label class="cr-detail-label" style="display:block;margin-bottom:8px">Reason (optional)</label>
            <textarea v-model="rejectReason" class="cr-reject-textarea" rows="3"
              placeholder="Explain why this registration is rejected..."></textarea>
            <div class="cr-modal-actions" style="margin-top:16px">
              <button class="cr-modal-btn cr-modal-btn--reject" @click="confirmReject">Confirm Reject</button>
              <button class="cr-modal-btn cr-modal-btn--cancel" @click="rejectModal = false">Cancel</button>
            </div>
          </div>
        </div>
      </div>
    </transition>

    <!-- Document Viewer Modal -->
    <transition name="fade">
      <div v-if="docViewerUrl" class="cr-modal-overlay cr-doc-viewer-overlay" @click.self="docViewerUrl = null">
        <div class="cr-doc-viewer-modal">
          <div class="cr-modal-header">
            <span class="cr-modal-title">Document</span>
            <div style="display:flex;gap:8px;align-items:center">
              <a :href="docViewerUrl" target="_blank" class="cr-doc-link" style="font-size:12px">Open in new tab ↗</a>
              <button class="cr-modal-close" @click="docViewerUrl = null">✕</button>
            </div>
          </div>
          <div class="cr-doc-viewer-body">
            <template v-if="docViewerType === 'docx'">
              <vue-office-docx
                :src="docViewerUrl"
                class="cr-office-viewer"
                @rendered="() => {}"
                @error="docViewerError = true"
              />
              <div v-if="docViewerError" class="cr-doc-fallback">
                <p>Cannot preview this file.</p>
                <a :href="docViewerUrl" target="_blank" class="cr-modal-btn cr-modal-btn--verify" style="display:inline-block;text-decoration:none;text-align:center;padding:10px 20px">Download file</a>
              </div>
            </template>
            <template v-else-if="docViewerType === 'pdf'">
              <iframe :src="docViewerUrl" class="cr-iframe-viewer" frameborder="0"></iframe>
            </template>
            <template v-else-if="docViewerType === 'image'">
              <img :src="docViewerUrl" class="cr-img-viewer" alt="Document" />
            </template>
            <template v-else>
              <div class="cr-doc-fallback">
                <svg width="48" height="48" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" style="color:#334155;margin-bottom:12px">
                  <path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/>
                </svg>
                <p>Preview not supported for this file type.</p>
                <a :href="docViewerUrl" target="_blank" class="cr-modal-btn cr-modal-btn--verify" style="display:inline-block;text-decoration:none;text-align:center;padding:10px 20px;margin-top:12px">Download file</a>
              </div>
            </template>
          </div>
        </div>
      </div>
    </transition>

    <!-- Toast -->
    <transition name="slide-up">
      <div class="toast" v-if="toast.show" :class="toast.type">{{ toast.msg }}</div>
    </transition>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import VueOfficeDocx from '@vue-office/docx'
import '@vue-office/docx/lib/index.css'
import { useAdminCopyrightStore } from '@/modules/admin/stores/copyright/copyrightStore'
import type { AdminCopyright } from '@/modules/admin/stores/copyright/copyrightStore'
import { useNotificationStore } from '@/store/notificationStore'

const store = useAdminCopyrightStore()
const notificationStore = useNotificationStore()
// ── Filters & pagination ──────────────────────────────────────────────────
const search       = ref('')
const filterStatus = ref('')
const filterType   = ref('')
const page         = ref(1)
const pageSize     = 15

// ── UI state ──────────────────────────────────────────────────────────────
const detailRow     = ref<AdminCopyright | null>(null)
const detailLoading = ref(false)
const rejectModal   = ref(false)
const rejectReason  = ref('')
const rejectTarget  = ref<AdminCopyright | null>(null)
const toast         = ref({ show: false, msg: '', type: '' })

// ── Document viewer ───────────────────────────────────────────────────────
const docViewerUrl   = ref<string | null>(null)
const docViewerType  = ref<'docx' | 'pdf' | 'image' | 'other'>('other')
const docViewerError = ref(false)

const getDocType = (url: string): 'docx' | 'pdf' | 'image' | 'other' => {
  const ext = url.split('?')[0].split('.').pop()?.toLowerCase() ?? ''
  if (ext === 'docx' || ext === 'doc') return 'docx'
  if (ext === 'pdf') return 'pdf'
  if (['jpg', 'jpeg', 'png', 'gif', 'webp'].includes(ext)) return 'image'
  return 'other'
}

const openDocViewer = (url: string) => {
  docViewerError.value = false
  docViewerType.value  = getDocType(url)
  docViewerUrl.value   = url
}

let searchTimer: ReturnType<typeof setTimeout>

// ── Load data ─────────────────────────────────────────────────────────────
const loadData = async () => {
  await Promise.all([
    store.fetchCopyrights({
      page: page.value,
      per_page: pageSize,
      search: search.value || undefined,
      status: filterStatus.value || undefined,
      copyright_type: filterType.value || undefined,
    }),
    store.fetchStats(),
  ])
}

onMounted(loadData)

watch([filterStatus, filterType], () => { page.value = 1; loadData() })
watch(search, () => {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(() => { page.value = 1; loadData() }, 350)
})
watch(page, loadData)

// ── Computed stats ────────────────────────────────────────────────────────
const statCards = computed(() => {
  const s = store.stats
  return [
    { key: 'total',    label: 'TOTAL REQUESTS', value: s?.total    ?? 0 },
    { key: 'active',   label: 'VERIFIED',        value: s?.active   ?? 0 },
    { key: 'pending',  label: 'PENDING',          value: s?.pending  ?? 0 },
    { key: 'revoked',  label: 'REJECTED',         value: s?.revoked  ?? 0 },
  ]
})

const statusProgress = computed(() => {
  const s = store.stats
  if (!s || s.total === 0) return []
  return [
    { label: 'Verified',  count: s.active,   pct: Math.round(s.active   / s.total * 100), color: '#00c97b' },
    { label: 'Pending',   count: s.pending,  pct: Math.round(s.pending  / s.total * 100), color: '#3b82f6' },
    { label: 'Rejected',  count: s.revoked,  pct: Math.round(s.revoked  / s.total * 100), color: '#ef4444' },
    { label: 'Disputed',  count: s.disputed, pct: Math.round(s.disputed / s.total * 100), color: '#f59e0b' },
  ]
})

const barData = computed(() => {
  const s = store.stats
  if (!s?.by_type) return []
  return Object.entries(s.by_type).map(([name, count]) => ({
    name: name.replace('_', ' '),
    totalH: Math.max(20, (count as number) * 18),
    verifiedH: Math.max(8, Math.floor((count as number) * 0.6) * 18),
  }))
})

const totalPages = computed(() => store.pagination.last_page)

// ── Helpers ───────────────────────────────────────────────────────────────
const avatarColors = ['#1e6fb5','#7c3aed','#be185d','#065f46','#92400e','#047857','#5b21b6','#1d4ed8']
const getAvatarColor = (id: number) => avatarColors[id % avatarColors.length]
const getInitials    = (title?: string) => (title ?? '??').split(' ').slice(0, 2).map(w => w[0]).join('').toUpperCase()
const formatDate     = (d?: string | null) => d ? d.substring(0, 10) : '—'

const statusLabel = (s: string) => ({ active: 'Verified', pending: 'Pending', revoked: 'Rejected', expired: 'Expired', disputed: 'Disputed' }[s] ?? s)
const statusClass = (s: string) => ({ active: 'verified', pending: 'pending', revoked: 'rejected', expired: 'expired', disputed: 'disputed' }[s] ?? '')

// ── Actions ───────────────────────────────────────────────────────────────
const openDetail = async (row: AdminCopyright) => {
  // Hiện modal ngay với data từ list, không chờ API
  detailRow.value = { ...row }

  // Fetch chi tiết đầy đủ (song/artist/partner) ở background
  detailLoading.value = true
  try {
    const res = await store.fetchDetail(row.id)
    if (res?.success && store.currentCopyright) {
      detailRow.value = { ...store.currentCopyright }
    }
  } catch {
    // giữ nguyên data từ list nếu fetch thất bại
  } finally {
    detailLoading.value = false
  }
}

const handleApprove = async (row: AdminCopyright) => {
  try {
    await store.approve(row.id)
    detailRow.value = null
    notificationStore.notify('has been verified', 'success')
  } catch {
    notificationStore.notify('Failed to approve', 'error')
  }
}

const openRejectModal = (row: AdminCopyright) => {
  rejectTarget.value = row
  rejectReason.value = ''
  rejectModal.value  = true
}

const confirmReject = async () => {
  if (!rejectTarget.value) return
  try {
    await store.reject(rejectTarget.value.id, rejectReason.value)
    detailRow.value   = null
    rejectModal.value = false
    notificationStore.notify('has been rejected', 'error')
  } catch {
    notificationStore.notify('Failed to reject', 'error')
  }
}

const showToast = (msg: string, type: string) => {
  toast.value = { show: true, msg, type }
  setTimeout(() => { toast.value.show = false }, 3000)
}
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap');

* { box-sizing: border-box; margin: 0; padding: 0; }

.copyright-dashboard {
  min-height: 100vh;
  background: #0f1216;
  color: #e2e8f0;
  font-family: 'DM Sans', sans-serif;
  padding: 32px;
  position: relative;
}

/* ── Header ── */
.header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 28px;
}
.title {
  
  font-size: 26px;
  font-weight: 800;
  color: #f1f5f9;
  letter-spacing: -0.5px;
}
.subtitle { font-size: 13px; color: #64748b; margin-top: 4px; }
.export-btn {
  display: flex; align-items: center; gap: 8px;
  background: transparent;
  border: 1px solid #2d3748;
  color: #cbd5e1;
  padding: 10px 18px;
  border-radius: 10px;
  font-size: 13px;
  cursor: pointer;
  font-family: 'DM Sans', sans-serif;
  transition: all .2s;
}
.export-btn:hover { border-color: #4a5568; background: #1a2332; }

/* ── Stats ── */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 20px;
}
.stat-card {
  background: #181b1f;
  border: 1px solid #1e2d3d;
  border-radius: 14px;
  padding: 22px 24px;
  transition: border-color .2s;
}
.stat-card:hover { border-color: #2d4a6e; }
.stat-label {
  font-size: 11px;
  letter-spacing: 1.2px;
  color: #4a5568;
  text-transform: uppercase;
  font-weight: 600;
  margin-bottom: 10px;
}
.stat-value {
  
  font-size: 36px;
  font-weight: 800;
}

/* ── Charts Row ── */
.charts-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 20px;
}
.chart-card {
  background: #181b1f;
  border: 1px solid #1e2d3d;
  border-radius: 14px;
  padding: 22px 24px;
}
.chart-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.chart-title {
  
  font-size: 15px;
  font-weight: 700;
  color: #f1f5f9;
}
.legend { display: flex; align-items: center; gap: 12px; font-size: 12px; color: #64748b; }
.dot { width: 8px; height: 8px; border-radius: 50%; display: inline-block; margin-right: 4px; }
.dot.blue { background: #3b82f6; }
.dot.green { background: #00c97b; }

/* Bar chart */
.bar-chart { padding: 0 8px; }
.bars-container { display: flex; align-items: flex-end; gap: 20px; height: 130px; }
.bar-group { display: flex; flex-direction: column; align-items: center; flex: 1; gap: 4px; height: 100%; }
.bar-wrap { display: flex; align-items: flex-end; gap: 4px; flex: 1; width: 100%; justify-content: center; }
.bar { width: 22px; border-radius: 5px 5px 0 0; transition: height .5s ease; }
.bar.total { background: #3b82f6; }
.bar.verified { background: #ffffffff; }
.bar-label { font-size: 11px; color: #4a5568; text-align: center; white-space: nowrap; }

/* Status progress */
.status-list { display: flex; flex-direction: column; gap: 18px; }
.status-item {}
.status-row { display: flex; justify-content: space-between; margin-bottom: 7px; font-size: 13px; }
.status-name { color: #cbd5e1; }
.status-count { color: #94a3b8; }
.progress-track { height: 7px; background: #1e2d3d; border-radius: 99px; overflow: hidden; }
.progress-fill { height: 100%; border-radius: 99px; transition: width 1s ease; }

/* ── Table Card ── */
.table-card {
  background: #181b1f;
  border: 1px solid #1e2d3d;
  border-radius: 14px;
  padding: 22px 24px;
}
.table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 12px; }
.table-controls { display: flex; gap: 10px; flex-wrap: wrap; }
.search-wrap {
  display: flex; align-items: center; gap: 8px;
  background: #0d1117;
  border: 1px solid #1e2d3d;
  border-radius: 8px;
  padding: 8px 12px;
  color: #4a5568;
}
.search-input {
  background: none; border: none; outline: none;
  color: #cbd5e1; font-size: 13px; font-family: 'DM Sans', sans-serif;
  width: 160px;
}
.search-input::placeholder { color: #334155; }
.filter-select {
  background: #0d1117;
  border: 1px solid #1e2d3d;
  border-radius: 8px;
  color: #94a3b8;
  font-size: 13px;
  padding: 8px 12px;
  cursor: pointer;
  outline: none;
  font-family: 'DM Sans', sans-serif;
}

/* Table */
.data-table { width: 100%; border-collapse: collapse; }
.data-table th {
  text-align: left;
  font-size: 10px;
  letter-spacing: 1.2px;
  text-transform: uppercase;
  color: #334155;
  font-weight: 600;
  padding: 10px 12px;
  border-bottom: 1px solid #1e2d3d;
}
.table-row { border-bottom: 1px solid #131d2b; transition: background .15s; }
.table-row:hover { background: #141f2e; }
.table-row td { padding: 13px 12px; font-size: 13px; vertical-align: middle; }
.muted { color: #4a5568; }

.song-cell { display: flex; align-items: center; gap: 10px; }
.song-avatar {
  width: 34px; height: 34px; border-radius: 9px;
  display: flex; align-items: center; justify-content: center;
   font-size: 11px; font-weight: 700;
  color: #fff; flex-shrink: 0;
}
.song-name { font-size: 13px; color: #e2e8f0; font-weight: 500; }
.song-id { font-size: 11px; color: #334155; margin-top: 1px; }

.type-badge {
  background: #1e2d3d;
  color: #60a5fa;
  padding: 3px 9px;
  border-radius: 5px;
  font-size: 11px;
  font-weight: 600;
}

.status-badge {
  padding: 4px 10px; border-radius: 20px;
  font-size: 11px; font-weight: 600; letter-spacing: 0.3px;
}
.status-badge.verified { background: rgba(0,201,123,.12); color: #00c97b; border: 1px solid rgba(0,201,123,.25); }
.status-badge.pending  { background: rgba(59,130,246,.12); color: #60a5fa; border: 1px solid rgba(59,130,246,.25); }
.status-badge.rejected { background: rgba(239,68,68,.1);   color: #f87171; border: 1px solid rgba(239,68,68,.2); }

.royalty-wrap { display: flex; align-items: center; gap: 8px; }
.royalty-bar-track { width: 70px; height: 5px; background: #1e2d3d; border-radius: 99px; overflow: hidden; }
.royalty-bar-fill { height: 100%; border-radius: 99px; }
.royalty-pct { font-size: 12px; color: #64748b; width: 32px; }

.action-btns { display: flex; gap: 6px; }
.act-btn {
  width: 30px; height: 30px; border-radius: 7px;
  border: 1px solid #1e2d3d;
  background: #0d1117;
  cursor: pointer; display: flex; align-items: center; justify-content: center;
  transition: all .2s; color: #64748b;
}
.act-btn.view:hover { border-color: #3b82f6; color: #60a5fa; background: rgba(59,130,246,.1); }
.act-btn.verify:hover { border-color: #00c97b; color: #00c97b; background: rgba(0,201,123,.1); }
.act-btn.reject:hover { border-color: #ef4444; color: #f87171; background: rgba(239,68,68,.1); }

/* Footer */
.table-footer {
  display: flex; justify-content: space-between; align-items: center;
  margin-top: 18px; font-size: 12px;
}
.pagination { display: flex; align-items: center; gap: 4px; }
.pg-btn {
  background: #0d1117; border: 1px solid #1e2d3d;
  color: #64748b; width: 28px; height: 28px; border-radius: 6px;
  cursor: pointer; font-size: 14px; transition: all .2s;
}
.pg-btn:disabled { opacity: 0.3; cursor: not-allowed; }
.pg-num {
  width: 28px; height: 28px; border-radius: 6px;
  display: flex; align-items: center; justify-content: center;
  font-size: 12px; cursor: pointer; color: #4a5568; transition: all .2s;
}
.pg-num.active { background: #1d4ed8; color: #fff; }
.pg-num:hover:not(.active) { background: #1e2d3d; color: #cbd5e1; }

/* ── Modal (scoped, không dùng Teleport) ── */
.cr-modal-overlay {
  position: fixed; inset: 0;
  background: rgba(0,0,0,.75);
  backdrop-filter: blur(4px);
  display: flex; align-items: center; justify-content: center;
  z-index: 9999;
}
.cr-modal {
  background: #181b1f;
  border: 1px solid #1e2d3d;
  border-radius: 16px;
  width: 500px; max-width: 95vw; max-height: 90vh;
  overflow-y: auto;
  padding: 28px;
  box-shadow: 0 25px 60px rgba(0,0,0,.6);
}
.cr-modal--sm { width: 400px; }
.cr-modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
.cr-modal-title { font-size: 17px; font-weight: 700; color: #f1f5f9; }
.cr-modal-close {
  background: none; border: none; color: #4a5568;
  cursor: pointer; font-size: 18px; line-height: 1;
  transition: color .2s; padding: 2px 6px;
}
.cr-modal-close:hover { color: #e2e8f0; }
.cr-modal-body { color: #e2e8f0; }
.cr-detail-loading {
  display: flex; align-items: center; gap: 8px;
  font-size: 13px; color: #64748b; margin-bottom: 16px;
}
.cr-detail-spinner {
  width: 14px; height: 14px;
  border: 2px solid rgba(255,255,255,.15);
  border-top-color: #60a5fa;
  border-radius: 50%;
  animation: spin .7s linear infinite;
  display: inline-block;
}
.cr-detail-hero {
  display: flex; align-items: center; gap: 14px;
  margin-bottom: 24px; padding-bottom: 20px;
  border-bottom: 1px solid #1e2d3d;
}
.cr-detail-avatar {
  width: 50px; height: 50px; border-radius: 12px;
  display: flex; align-items: center; justify-content: center;
  font-size: 14px; font-weight: 800; color: #fff; flex-shrink: 0;
}
.cr-detail-song { font-size: 16px; font-weight: 700; color: #f1f5f9; }
.cr-detail-artist { font-size: 13px; color: #64748b; margin-top: 4px; }
.cr-detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px; }
.cr-detail-item {}
.cr-detail-label { font-size: 11px; letter-spacing: 1px; text-transform: uppercase; color: #334155; margin-bottom: 4px; }
.cr-detail-value { font-size: 14px; color: #cbd5e1; font-weight: 500; }
.cr-doc-link { color: #60a5fa; text-decoration: underline; }
.cr-doc-link:hover { color: #93c5fd; }
.cr-modal-actions { display: flex; gap: 10px; }
.cr-modal-btn {
  flex: 1; padding: 11px; border-radius: 9px; border: none;
  font-size: 13px; font-weight: 600; cursor: pointer;
  font-family: 'DM Sans', sans-serif; transition: opacity .2s;
}
.cr-modal-btn:hover { opacity: .85; }
.cr-modal-btn--verify { background: #00c97b; color: #fff; }
.cr-modal-btn--reject { background: #ef4444; color: #fff; }
.cr-modal-btn--cancel { background: #1e2d3d; color: #94a3b8; }
.cr-modal-btn--cancel:hover { background: #263548; opacity: 1; }
.cr-reject-song { font-size: 13px; color: #94a3b8; margin-bottom: 14px; }
.cr-reject-song strong { color: #e2e8f0; }
.cr-reject-textarea {
  width: 100%; background: #0d1117; border: 1px solid #1e2d3d;
  border-radius: 8px; color: #cbd5e1; font-size: 13px;
  padding: 10px 12px; resize: vertical; outline: none;
  font-family: 'DM Sans', sans-serif; box-sizing: border-box;
}
.cr-reject-textarea:focus { border-color: rgba(59,130,246,.5); }

/* ── Document Viewer ── */
.cr-doc-actions { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
.cr-doc-preview-btn {
  display: inline-flex; align-items: center; gap: 5px;
  background: transparent;
  border: none;
  color: #60a5fa; font-size: 12px; font-weight: 500;
  padding: 0;
  border-radius: 0;
  cursor: pointer;
  font-family: 'DM Sans', sans-serif;
  transition: all .2s;
  text-decoration: none;
}

.cr-doc-preview-btn:hover {
  color: #93c5fd;
  text-decoration: underline;
  background: transparent;
}
.cr-doc-preview-btn:hover { background: rgba(59,130,246,.25); }
.cr-doc-viewer-overlay { align-items: flex-start; padding: 24px; }
.cr-doc-viewer-modal {
  background: #181b1f;
  border: 1px solid #1e2d3d;
  border-radius: 16px;
  width: 860px; max-width: 98vw;
  height: calc(100vh - 48px);
  display: flex; flex-direction: column;
  box-shadow: 0 25px 60px rgba(0,0,0,.6);
  overflow: hidden;
}
.cr-doc-viewer-body {
  flex: 1; overflow: auto;
  background: #fff;
  border-radius: 0 0 16px 16px;
}
.cr-office-viewer { width: 100%; min-height: 100%; }
.cr-iframe-viewer { width: 100%; height: 100%; min-height: 600px; border: none; display: block; }
.cr-img-viewer { max-width: 100%; display: block; margin: 0 auto; padding: 16px; }
.cr-doc-fallback {
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  height: 300px; color: #64748b; font-size: 14px; gap: 8px;
  background: #0f1216;
}

/* ── Toast ── */
.toast {
  position: fixed; bottom: 28px; right: 28px;
  padding: 12px 20px; border-radius: 10px;
  font-size: 13px; font-weight: 500; z-index: 2000;
  box-shadow: 0 8px 24px rgba(0,0,0,.4);
}
.toast.success { background: rgba(0,201,123,.15); border: 1px solid rgba(0,201,123,.3); color: #00c97b; }
.toast.error   { background: rgba(239,68,68,.12); border: 1px solid rgba(239,68,68,.25); color: #f87171; }

/* ── Transitions ── */
.fade-enter-active, .fade-leave-active { transition: opacity .2s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
.slide-up-enter-active, .slide-up-leave-active { transition: all .3s; }
.slide-up-enter-from, .slide-up-leave-to { opacity: 0; transform: translateY(12px); }

/* Scrollbar */
::-webkit-scrollbar { width: 6px; }
::-webkit-scrollbar-track { background: #0d1117; }
::-webkit-scrollbar-thumb { background: #1e2d3d; border-radius: 3px; }

/* ── Extra ── */
.empty-chart { color: #334155; font-size: 12px; text-align: center; width: 100%; padding: 20px 0; }
.empty-row { text-align: center; color: #334155; padding: 40px !important; font-size: 13px; }

.loading-rows { display: flex; flex-direction: column; gap: 10px; padding: 8px 0; }
.skeleton-row { height: 48px; background: linear-gradient(90deg, #1a2332 25%, #1e2d3d 50%, #1a2332 75%); background-size: 200% 100%; border-radius: 8px; animation: shimmer 1.4s infinite; }
.skeleton-num { display: inline-block; width: 48px; height: 36px; background: linear-gradient(90deg, #1a2332 25%, #1e2d3d 50%, #1a2332 75%); background-size: 200% 100%; border-radius: 6px; animation: shimmer 1.4s infinite; }
@keyframes shimmer { 0% { background-position: 200% 0; } 100% { background-position: -200% 0; } }

.doc-link { color: #60a5fa; text-decoration: underline; font-size: 13px; }
.doc-link:hover { color: #93c5fd; }

.status-badge.expired  { background: rgba(245,158,11,.1);  color: #fbbf24; border: 1px solid rgba(245,158,11,.2); }
.status-badge.disputed { background: rgba(245,158,11,.1);  color: #f59e0b; border: 1px solid rgba(245,158,11,.2); }
</style>
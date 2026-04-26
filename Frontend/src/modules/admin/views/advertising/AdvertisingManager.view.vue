<template>
  <div class="pa-page">
    <!-- Header -->
    <div class="pa-header">
      <div>
        <h1 class="pa-title">Partner Advertising</h1>
        <p class="pa-subtitle">Manage campaigns &amp; creative assets</p>
      </div>
      <div class="pa-header-right">
        <button class="btn btn-outline" @click="exportReport">
          <span>Export Report</span>
        </button>
      </div>
    </div>

    <!-- Loading toàn trang -->
    <div v-if="advertisingStore.loadingList" class="loading-overlay">
      <span>Đang tải dữ liệu...</span>
    </div>

    <!-- Error banner -->
    <div v-if="advertisingStore.error" class="error-banner">
      {{ advertisingStore.error }}
    </div>

    <!-- Stats (tính từ store) -->
    <div class="stats-grid">
      <div class="stat-card" v-for="stat in stats" :key="stat.key">
        <div class="stat-label">{{ stat.label }}</div>
        <div class="stat-value">{{ stat.value }}</div>
        <div v-if="stat.change" class="stat-change" :class="stat.up ? 'up' : 'down'">
          {{ stat.up ? '▲' : '▼' }} {{ stat.change }}
        </div>
      </div>
    </div>

    <!-- Charts row -->
    <div class="chart-row">
      <!-- Budget usage per ad (thay thế monthly chart bằng data thật) -->
      <div class="section">
        <div class="sec-header">
          <span class="sec-title">Budget Usage per Campaign</span>
          <div class="legend">
            <div class="leg-item">
              <span class="leg-dot" style="background:#3a80f5"></span>
              Budget Total
            </div>
            <div class="leg-item">
              <span class="leg-dot" style="background:#34d399"></span>
              Budget Spent
            </div>
          </div>
        </div>
        <div class="chart-area">
          <div class="bar-group">
            <div
              v-for="ad in advertisingStore.advertisements.slice(0, 7)"
              :key="ad.id"
              class="bar-col"
            >
              <div class="bars">
                <div
                  class="bar bar-imp"
                  :style="{ height: barHeight(ad.budget_total) + 'px' }"
                  :title="`${ad.name}: Total ₫${formatVND(ad.budget_total)}`"
                ></div>
                <div
                  class="bar bar-click"
                  :style="{ height: barHeight(ad.budget_spent) + 'px' }"
                  :title="`${ad.name}: Spent ₫${formatVND(ad.budget_spent)}`"
                ></div>
              </div>
              <span class="bar-label">{{ shortName(ad.name) }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Status breakdown -->
      <div class="section">
        <div class="sec-header">
          <span class="sec-title">Campaign Status</span>
        </div>
        <div class="chart-area">
          <div
            v-for="item in statusBreakdown"
            :key="item.status"
            class="rev-row"
          >
            <span class="rev-name">{{ item.label }}</span>
            <div class="rev-bar-wrap">
              <div
                class="rev-bar"
                :style="{ width: item.pct + '%', background: item.color }"
              ></div>
            </div>
            <span class="rev-pct">{{ item.count }} ({{ item.pct }}%)</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Campaigns table -->
    <div class="section">
      <div class="sec-header">
        <span class="sec-title">Campaign List</span>
        <div class="filters">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search campaign..."
            class="pa-input"
            @input="currentPage = 1"
          />
          <select v-model="filterStatus" class="pa-select" @change="currentPage = 1">
            <option value="">All statuses</option>
            <option value="active">Active</option>
            <option value="paused">Paused</option>
            <option value="completed">Completed</option>
          </select>
          <select v-model="filterType" class="pa-select" @change="currentPage = 1">
            <option value="">All types</option>
            <option value="banner">Banner</option>
            <option value="video">Video</option>
            <option value="audio">Audio</option>
          </select>
        </div>
      </div>

      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Campaign</th>
              <th>Type</th>
              <th>Status</th>
              <th>Budget Total</th>
              <th>Budget Spent</th>
              <th>Budget Used</th>
              <th>Cost/Play</th>
              <th>Schedule</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="ad in paginatedAds" :key="ad.id">
              <td>
                <div class="name-cell">
                  <div class="avatar">{{ initials(ad.name) }}</div>
                  <div>
                    <span class="cell-name">{{ ad.name }}</span>
                    <div class="muted" style="font-size:11px">{{ ad.advertiser_name }}</div>
                  </div>
                </div>
              </td>
              <td class="muted">{{ ad.type }}</td>
              <td>
                <span class="badge" :class="'badge-' + ad.status">
                  {{ statusLabel[ad.status] ?? ad.status }}
                </span>
              </td>
              <td>₫{{ formatVND(ad.budget_total) }}</td>
              <td>₫{{ formatVND(ad.budget_spent) }}</td>
              <td>
                <div class="prog-wrap">
                  <div
                    class="prog-bar"
                    :style="{ width: Math.max(budgetUsedPct(ad), budgetUsedPct(ad) > 0 ? 1 : 0) + '%' }"
                  ></div>
                </div>
                <span class="prog-label">{{ budgetUsedPct(ad).toFixed(2) }}%</span>
              </td>
              <td class="accent">₫{{ formatVND(ad.cost_per_play) }}</td>
              <td class="muted" style="font-size:12px">
                {{ ad.start_date ? ad.start_date.slice(0,10) : '—' }}
                <br/>
                → {{ ad.end_date ? ad.end_date.slice(0,10) : '∞' }}
              </td>
              <td>
                <div class="actions">
                  <button
                    class="icon-btn"
                    :disabled="advertisingStore.togglingId === ad.id"
                    @click="handleToggle(ad.id)"
                  >
                    {{ advertisingStore.togglingId === ad.id
                        ? '...'
                        : ad.status === 'active' ? 'Pause' : 'Resume' }}
                  </button>
                  <button class="icon-btn" @click="handleViewDetail(ad.id)">Details</button>
                </div>
              </td>
            </tr>
            <tr v-if="paginatedAds.length === 0">
              <td colspan="9" style="text-align:center;color:#475569;padding:32px">
                {{ advertisingStore.loadingList ? 'Loading...' : 'No campaigns found' }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="pagination">
        <span class="page-info">
          Showing {{ pageStart }}–{{ pageEnd }} of {{ filteredAds.length }} campaigns
        </span>
        <div class="page-btns">
          <button
            class="page-btn"
            :disabled="currentPage === 1"
            @click="currentPage--"
          >‹</button>
          <button
            v-for="p in totalPages"
            :key="p"
            class="page-btn"
            :class="{ active: currentPage === p }"
            @click="currentPage = p"
          >{{ p }}</button>
          <button
            class="page-btn"
            :disabled="currentPage === totalPages"
            @click="currentPage++"
          >›</button>
        </div>
      </div>
    </div>

    <!-- Ad Detail Modal (từ store.currentAd) -->
    <Teleport to="body">
      <Transition name="modal-fade">
        <div
          v-if="showDetailModal"
          class="modal-overlay"
          @click.self="closeDetail"
        >
        <div class="modal" style="max-width:640px">
          <div class="modal-header">
            <h2 class="modal-title">
              {{ advertisingStore.loadingDetail ? 'Loading...' : advertisingStore.currentAd?.name }}
            </h2>
            <button class="modal-close" @click="closeDetail">✕</button>
          </div>

          <div v-if="advertisingStore.loadingDetail" class="modal-body" style="text-align:center;padding:40px">
            Đang tải chi tiết...
          </div>

          <div v-else-if="advertisingStore.currentAd" class="modal-body">
            <div class="detail-grid">
              <div class="detail-item">
                <span class="detail-label">Status</span>
                <span class="badge" :class="'badge-' + advertisingStore.currentAd.status">
                  {{ statusLabel[advertisingStore.currentAd.status] ?? advertisingStore.currentAd.status }}
                </span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Type</span>
                <span>{{ advertisingStore.currentAd.type }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Advertiser</span>
                <a :href="advertisingStore.currentAd.advertiser_url" target="_blank" class="accent">
                  {{ advertisingStore.currentAd.advertiser_name }}
                </a>
              </div>
              <div class="detail-item">
                <span class="detail-label">Duration</span>
                <span>{{ advertisingStore.currentAd.duration }}s</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">File Size</span>
                <span>{{ advertisingStore.currentAd.file_size_readable ?? '—' }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Cost/Play</span>
                <span>₫{{ formatVND(advertisingStore.currentAd.cost_per_play) }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Cost/Click</span>
                <span>₫{{ formatVND(advertisingStore.currentAd.cost_per_click) }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Priority</span>
                <span>{{ advertisingStore.currentAd.priority }}</span>
              </div>
            </div>

            <!-- Budget -->
            <div class="detail-section">
              <div class="detail-section-title">Budget</div>
              <div class="detail-grid">
                <div class="detail-item">
                  <span class="detail-label">Total</span>
                  <span>₫{{ formatVND(advertisingStore.currentAd.budget?.total) }}</span>
                </div>
                <div class="detail-item">
                  <span class="detail-label">Spent</span>
                  <span>₫{{ formatVND(advertisingStore.currentAd.budget?.spent) }}</span>
                </div>
                <div class="detail-item">
                  <span class="detail-label">Remaining</span>
                  <span class="accent">₫{{ formatVND(advertisingStore.currentAd.budget?.remaining) }}</span>
                </div>
                <div class="detail-item">
                  <span class="detail-label">Used</span>
                  <span>{{ advertisingStore.currentAd.budget?.used_percent }}</span>
                </div>
              </div>
              <div class="prog-wrap" style="margin-top:8px">
                <div
                  class="prog-bar"
                  :style="{ width: advertisingStore.currentAd.budget?.used_percent }"
                ></div>
              </div>
            </div>

            <!-- Schedule -->
            <div class="detail-section">
              <div class="detail-section-title">Schedule</div>
              <div class="detail-grid">
                <div class="detail-item">
                  <span class="detail-label">Start</span>
                  <span>{{ advertisingStore.currentAd.schedule?.start_date?.slice(0,10) ?? '—' }}</span>
                </div>
                <div class="detail-item">
                  <span class="detail-label">End</span>
                  <span>{{ advertisingStore.currentAd.schedule?.end_date?.slice(0,10) ?? '∞' }}</span>
                </div>
                <div class="detail-item">
                  <span class="detail-label">Days Remaining</span>
                  <span :class="{ 'down': advertisingStore.currentAd.schedule?.is_expired }">
                    {{ advertisingStore.currentAd.schedule?.days_remaining ?? '—' }}
                    {{ advertisingStore.currentAd.schedule?.is_expired ? '(expired)' : '' }}
                  </span>
                </div>
              </div>
            </div>

            <!-- Targeting -->
            <div class="detail-section">
              <div class="detail-section-title">Targeting</div>
              <div class="detail-grid">
                <div class="detail-item">
                  <span class="detail-label">Age</span>
                  <span>
                    {{ advertisingStore.currentAd.targeting?.age_min ?? '—' }}
                    –
                    {{ advertisingStore.currentAd.targeting?.age_max ?? '—' }}
                  </span>
                </div>
                <div class="detail-item">
                  <span class="detail-label">Gender</span>
                  <span>{{ advertisingStore.currentAd.targeting?.gender ?? 'All' }}</span>
                </div>
                <div class="detail-item">
                  <span class="detail-label">Location</span>
                  <span>{{ advertisingStore.currentAd.targeting?.location ?? 'All' }}</span>
                </div>
              </div>
            </div>
          </div>

          <div class="modal-footer">
            <button class="btn btn-outline" @click="closeDetail">Close</button>
            <button
              class="btn btn-primary"
              :disabled="advertisingStore.togglingId === advertisingStore.currentAd?.id"
              @click="handleToggle(advertisingStore.currentAd?.id)"
            >
              {{ advertisingStore.currentAd?.status === 'active' ? 'Pause Campaign' : 'Resume Campaign' }}
            </button>
          </div>
        </div>
        </div>
      </Transition>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useAdvertisingStore } from '@/modules/admin/stores/avertising/avertisingsStore'
import router from '@/modules/router'

const advertisingStore = useAdvertisingStore()

// ─── UI STATE ─────────────────────────────────────────────────────────────────
const searchQuery   = ref('')
const filterStatus  = ref('')
const filterType    = ref('')
const currentPage   = ref(1)
const pageSize      = 6
const showDetailModal = ref(false)

// ─── LIFECYCLE ────────────────────────────────────────────────────────────────
onMounted(async () => {
  await advertisingStore.fetchAll()
})

// ─── STATS (tính từ store) ────────────────────────────────────────────────────
const stats = computed(() => {
  const s   = advertisingStore.summary
  const ads = advertisingStore.advertisements

  const total       = s?.total_campaigns  ?? ads.length
  const active      = s?.active_campaigns ?? ads.filter(a => a.status === 'active').length
  const revenue     = s?.revenue_earned   ?? ads.reduce((acc, a) => acc + (a.budget_spent ?? 0), 0)
  const totalBudget = s?.total_budget     ?? ads.reduce((acc, a) => acc + (a.budget_total ?? 0), 0)
  
  return [
    { key: 'total',   label: 'Total Campaigns',  value: total },
    { key: 'active',  label: 'Active Campaigns',  value: active },
    { key: 'revenue', label: 'Ad Revenue Earned', value: '₫' + formatVND(revenue) },
    { key: 'budget',  label: 'Total Budget',      value: '₫' + formatVND(totalBudget) },
  ]
})
// ─── STATUS BREAKDOWN (thay revenue by partner) ───────────────────────────────
const statusBreakdown = computed(() => {
  const ads = advertisingStore.advertisements
  const total = ads.length || 1
  const groups = [
    { status: 'active',    label: 'Active',    color: '#34d399' },
    { status: 'paused',    label: 'Paused',    color: '#f59e0b' },
    { status: 'completed', label: 'Completed', color: '#475569' },
  ]
  return groups.map(g => {
    const count = ads.filter(a => a.status === g.status).length
    return { ...g, count, pct: Math.round((count / total) * 100) }
  })
})

// ─── BAR CHART ────────────────────────────────────────────────────────────────
const maxBudget = computed(() =>
  Math.max(...advertisingStore.advertisements.map(a => a.budget_total ?? 0), 1)
)
const barHeight = (val: number | null | undefined): number => Math.round(((val ?? 0) / maxBudget.value) * 90)

// ─── TABLE FILTER & PAGINATION ────────────────────────────────────────────────
const filteredAds = computed(() =>
  advertisingStore.advertisements.filter(ad => {
    const q = searchQuery.value.toLowerCase()
    const matchSearch = !q
      || ad.name?.toLowerCase().includes(q)
      || ad.advertiser_name?.toLowerCase().includes(q)
    const matchStatus = !filterStatus.value || ad.status === filterStatus.value
    const matchType   = !filterType.value   || ad.type === filterType.value
    return matchSearch && matchStatus && matchType
  })
)

const totalPages = computed(() => Math.max(1, Math.ceil(filteredAds.value.length / pageSize)))
const pageStart  = computed(() => filteredAds.value.length === 0 ? 0 : (currentPage.value - 1) * pageSize + 1)
const pageEnd    = computed(() => Math.min(currentPage.value * pageSize, filteredAds.value.length))
const paginatedAds = computed(() =>
  filteredAds.value.slice((currentPage.value - 1) * pageSize, currentPage.value * pageSize)
)

// ─── ACTIONS ──────────────────────────────────────────────────────────────────
const handleToggle = async (id: number | string | undefined | null): Promise<void> => {
  if (!id) return
  try {
    await advertisingStore.toggleStatus(id)
  } catch {
    // error đã được lưu trong store.error
  }
}

function handleViewDetail(id: number) {
    router.push({
        name: "admin.advtising.detail",
        params: { id }
    });
}


const closeDetail = () => {
  showDetailModal.value = false
  advertisingStore.clearCurrentAd()
}

const exportReport = () => console.log('Export report')

// ─── HELPERS ──────────────────────────────────────────────────────────────────
const statusLabel = {
  active: 'Active', paused: 'Paused', completed: 'Completed', draft: 'Draft'
}

const formatVND = (val: number | string | null | undefined): string => {
  if (!val && val !== 0) return '—'
  return Number(val).toLocaleString('vi-VN')
}

const budgetUsedPct = (ad: {
  budget_total: number | null
  budget_spent: number | null
  budget_used_percent?: number | null
}): number => {
  // Ưu tiên dùng giá trị backend đã tính sẵn
  if (ad.budget_used_percent != null) {
    return Math.min(100, Math.round(Number(ad.budget_used_percent) * 100) / 100)
  }
  // Fallback tự tính
  const total = Number(ad.budget_total ?? 0)
  const spent = Number(ad.budget_spent ?? 0)
  if (!total) return 0
  return Math.min(100, Math.round((spent / total) * 100))
}

const initials = (name: string | null | undefined): string =>
  (name ?? '?').split(' ').map((w: string) => w[0]).join('').slice(0, 2).toUpperCase()

const shortName = (name: string | null | undefined): string =>
  (name ?? '').length > 8 ? (name ?? '').slice(0, 8) + '…' : (name ?? '')
</script>

<style scoped>
.pa-page {
  padding: 28px;
  min-height: 100vh;
  background: #181b1f;
  color: #e2e8f0;
  font-family: 'DM Sans', 'Inter', sans-serif;
  font-size: 14px;
}
.pa-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:24px; }
.pa-title { font-size:20px; font-weight:500; color:#f1f5f9; margin:0; }
.pa-subtitle { font-size:12px; color:#475569; margin-top:2px; }
.pa-header-right { display:flex; gap:10px; align-items:center; }
.btn { padding:7px 16px; border-radius:8px; font-size:13px; font-weight:500; cursor:pointer; border:none; transition:opacity 0.15s; }
.btn-primary { background:#3a80f5; color:#fff; }
.btn-outline { background:transparent; border:0.5px solid #334155; color:#94a3b8; }
.btn:hover { opacity:0.85; }
.btn:disabled { opacity:0.4; cursor:not-allowed; }
.pa-select, .pa-input { background:#0f1117; border:0.5px solid #334155; border-radius:6px; padding:6px 10px; font-size:12px; color:#94a3b8; outline:none; font-family:inherit; }
.pa-select:focus, .pa-input:focus { border-color:#3a80f5; }
.pa-input.full, .pa-select.full { width:100%; }
.stats-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:12px; margin-bottom:20px; }
.stat-card { background:#181b1f; border-radius:10px; padding:16px 18px; border:0.5px solid #2d3748; }
.stat-label { font-size:11px; color:#64748b; text-transform:uppercase; letter-spacing:0.04em; margin-bottom:6px; }
.stat-value { font-size:22px; font-weight:500; color:#f1f5f9; }
.stat-change { font-size:12px; margin-top:4px; }
.up { color:#34d399; } .down { color:#f87171; }
.chart-row { display:grid; grid-template-columns:1fr 1fr; gap:18px; margin-bottom:18px; }
.section { background:#181b1f; border-radius:10px; border:0.5px solid #2d3748; margin-bottom:18px; overflow:hidden; }
.sec-header { display:flex; align-items:center; justify-content:space-between; padding:14px 20px; border-bottom:0.5px solid #2d3748; flex-wrap:wrap; gap:8px; }
.sec-title { font-size:13px; font-weight:500; color:#cbd5e1; }
.legend { display:flex; gap:14px; }
.leg-item { display:flex; align-items:center; gap:5px; font-size:11px; color:#64748b; }
.leg-dot { width:8px; height:8px; border-radius:50%; display:inline-block; flex-shrink:0; }
.chart-area { padding:16px 20px; }
.bar-group { display:flex; align-items:flex-end; gap:4px; height:110px; }
.bar-col { display:flex; flex-direction:column; align-items:center; gap:6px; flex:1; }
.bars { display:flex; align-items:flex-end; gap:3px; height:90px; }
.bar { width:12px; border-radius:3px 3px 0 0; transition:opacity 0.15s; cursor:pointer; min-height:2px; }
.bar:hover { opacity:0.7; }
.bar-imp { background:#3a80f5; } .bar-click { background:#34d399; }
.bar-label { font-size:10px; color:#475569; }
.rev-row { display:flex; align-items:center; gap:10px; margin-bottom:12px; }
.rev-name { font-size:12px; color:#64748b; width:110px; flex-shrink:0; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
.rev-bar-wrap { flex:1; background:#2d3748; border-radius:4px; height:8px; overflow:hidden; }
.rev-bar { height:100%; border-radius:4px; transition:width 0.5s ease; }
.rev-pct { font-size:12px; color:#94a3b8; width:60px; text-align:right; }
.filters { display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
.table-wrap { overflow-x:auto; }
table { width:100%; border-collapse:collapse; }
th { font-size:11px; font-weight:500; color:#475569; text-transform:uppercase; letter-spacing:0.05em; padding:10px 18px; text-align:left; border-bottom:0.5px solid #2d3748; background:#161b27; white-space:nowrap; }
td { padding:12px 18px; border-bottom:0.5px solid #1e2a3a; color:#cbd5e1; font-size:13px; }
tr:last-child td { border-bottom:none; }
tr:hover td { background:#232a3d; }
.name-cell { display:flex; align-items:center; gap:10px; }
.avatar { width:28px; height:28px; border-radius:6px; background:#2d3748; display:flex; align-items:center; justify-content:center; font-size:10px; font-weight:500; color:#818cf8; flex-shrink:0; }
.cell-name { color:#e2e8f0; font-weight:500; }
.muted { color:#94a3b8; } .accent { color:#818cf8; } .revenue { color:#34d399; font-weight:500; }
.badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:11px; font-weight:500; white-space:nowrap; }
.badge-active { background:#064e3b; color:#34d399; }
.badge-paused { background:#3b1f00; color:#f59e0b; }
.badge-ended, .badge-completed { background:#1f1f2e; color:#64748b; }
.badge-draft { background:#1e1e35; color:#818cf8; }
.prog-wrap { width:100%; background:#2d3748; border-radius:4px; height:5px; overflow:hidden; }
.prog-bar { height:100%; border-radius:4px; background:#3a80f5; }
.prog-label { font-size:11px; color:#475569; margin-top:3px; display:block; }
.actions { display:flex; gap:6px; }
.icon-btn { background:transparent; border:0.5px solid #334155; border-radius:6px; padding:4px 10px; color:#64748b; cursor:pointer; font-size:11px; font-family:inherit; transition:background 0.15s, color 0.15s; }
.icon-btn:hover { background:#232a3d; color:#94a3b8; }
.icon-btn:disabled { opacity:0.4; cursor:not-allowed; }
.pagination { display:flex; align-items:center; justify-content:space-between; padding:12px 20px; border-top:0.5px solid #2d3748; }
.page-info { font-size:12px; color:#475569; }
.page-btns { display:flex; gap:6px; }
.page-btn { background:#161b27; border:0.5px solid #2d3748; border-radius:6px; padding:5px 10px; color:#64748b; cursor:pointer; font-size:12px; font-family:inherit; transition:background 0.15s; }
.page-btn:hover:not(:disabled) { background:#232a3d; color:#94a3b8; }
.page-btn.active { background:#3a80f5; border-color:#3a80f5; color:#fff; }
.page-btn:disabled { opacity:0.4; cursor:not-allowed; }

/* ── MODAL FIX ── */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.65);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}
.modal {
  background: #181b1f;
  border: 0.5px solid #2d3748;
  border-radius: 12px;
  width: 640px;
  max-width: 92vw;
  max-height: 88vh;
  overflow-y: auto;
}
.modal-header { display:flex; align-items:center; justify-content:space-between; padding:18px 20px; border-bottom:0.5px solid #2d3748; }
.modal-title { font-size:15px; font-weight:500; color:#f1f5f9; margin:0; }
.modal-close { background:transparent; border:none; color:#64748b; cursor:pointer; font-size:14px; padding:4px 8px; }
.modal-close:hover { color:#94a3b8; }
.modal-body { padding:20px; display:flex; flex-direction:column; gap:16px; }
.modal-footer { display:flex; justify-content:flex-end; gap:10px; padding:16px 20px; border-top:0.5px solid #2d3748; }

/* Detail grid inside modal */
.detail-grid { display:grid; grid-template-columns:1fr 1fr; gap:12px; }
.detail-item { display:flex; flex-direction:column; gap:4px; background:#161b27; border-radius:8px; padding:10px 14px; border:0.5px solid #2d3748; }
.detail-label { font-size:10px; color:#475569; text-transform:uppercase; letter-spacing:0.05em; }
.detail-section { display:flex; flex-direction:column; gap:10px; }
.detail-section-title { font-size:12px; font-weight:600; color:#64748b; text-transform:uppercase; letter-spacing:0.06em; padding-bottom:4px; border-bottom:0.5px solid #2d3748; }

/* Transition */
.modal-fade-enter-active { transition: opacity 0.2s ease; }
.modal-fade-leave-active { transition: opacity 0.15s ease; }
.modal-fade-enter-active .modal { transition: transform 0.2s ease, opacity 0.2s ease; }
.modal-fade-leave-active .modal { transition: transform 0.15s ease, opacity 0.15s ease; }
.modal-fade-enter-from, .modal-fade-leave-to { opacity: 0; }
.modal-fade-enter-from .modal, .modal-fade-leave-to .modal { transform: translateY(-10px); opacity: 0; }

.form-group { display:flex; flex-direction:column; gap:6px; flex:1; }
.form-group label { font-size:12px; color:#94a3b8; }
.form-row { display:grid; grid-template-columns:1fr 1fr; gap:14px; }

.loading-overlay { padding:16px 20px; color:#64748b; font-size:13px; }
.error-banner { background:#3b0e0e; border:0.5px solid #7f1d1d; color:#f87171; padding:10px 16px; border-radius:8px; margin-bottom:16px; font-size:13px; }

@media (max-width:900px) {
  .stats-grid { grid-template-columns:repeat(2,1fr); }
  .chart-row { grid-template-columns:1fr; }
}
@media (max-width:600px) {
  .stats-grid { grid-template-columns:1fr; }
  .pa-header { flex-direction:column; align-items:flex-start; gap:12px; }
  .detail-grid { grid-template-columns:1fr; }
}
</style>
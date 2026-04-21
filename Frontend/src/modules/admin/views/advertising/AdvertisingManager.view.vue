<template>
  <div class="pa-page">
    <!-- Header -->
    <div class="pa-header">
      <div>
        <h1 class="pa-title">Partner Advertising</h1>
        <p class="pa-subtitle">Quản lý campaigns &amp; creative assets</p>
      </div>
      <div class="pa-header-right">
        <button class="btn btn-outline" @click="exportReport">
          <span>Xuất báo cáo</span>
        </button>
      </div>
    </div>

    <!-- Stats -->
    <div class="stats-grid">
      <div class="stat-card" v-for="stat in stats" :key="stat.key">
        <div class="stat-label">{{ stat.label }}</div>
        <div class="stat-value">{{ stat.value }}</div>
        <div class="stat-change" :class="stat.up ? 'up' : 'down'">
          {{ stat.up ? '▲' : '▼' }} {{ stat.change }}
        </div>
      </div>
    </div>

    <!-- Charts row -->
    <div class="chart-row">
      <!-- Monthly chart -->
      <div class="section">
        <div class="sec-header">
          <span class="sec-title">Impressions &amp; Clicks theo tháng</span>
          <div class="legend">
            <div class="leg-item">
              <span class="leg-dot" style="background:#3a80f5"></span>
              Impressions
            </div>
            <div class="leg-item">
              <span class="leg-dot" style="background:#34d399"></span>
              Clicks
            </div>
          </div>
        </div>
        <div class="chart-area">
          <div class="bar-group">
            <div
              v-for="(item, i) in monthlyChart"
              :key="i"
              class="bar-col"
            >
              <div class="bars">
                <div
                  class="bar bar-imp"
                  :style="{ height: barHeight(item.impressions) + 'px' }"
                  :title="`${item.month}: ${item.impressions}K impressions`"
                ></div>
                <div
                  class="bar bar-click"
                  :style="{ height: barHeight(item.clicks) + 'px' }"
                  :title="`${item.month}: ${item.clicks}K clicks`"
                ></div>
              </div>
              <span class="bar-label">{{ item.month }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Revenue by partner -->
      <div class="section">
        <div class="sec-header">
          <span class="sec-title">Revenue theo partner</span>
        </div>
        <div class="chart-area">
          <div
            v-for="item in revenueByPartner"
            :key="item.name"
            class="rev-row"
          >
            <span class="rev-name">{{ item.name }}</span>
            <div class="rev-bar-wrap">
              <div
                class="rev-bar"
                :style="{ width: item.pct + '%', background: item.color }"
              ></div>
            </div>
            <span class="rev-pct">{{ item.pct }}%</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Campaigns table -->
    <div class="section">
      <div class="sec-header">
        <span class="sec-title">Danh sách Campaigns</span>
        <div class="filters">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Tìm campaign..."
            class="pa-input"
          />
          <select v-model="filterStatus" class="pa-select">
            <option value="">Tất cả trạng thái</option>
            <option value="active">Active</option>
            <option value="paused">Paused</option>
            <option value="ended">Ended</option>
            <option value="draft">Draft</option>
          </select>
          <select v-model="filterPartner" class="pa-select">
            <option value="">Tất cả partners</option>
            <option v-for="p in partnerOptions" :key="p" :value="p">{{ p }}</option>
          </select>
        </div>
      </div>

      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Campaign</th>
              <th>Partner</th>
              <th>Trạng thái</th>
              <th>Impressions</th>
              <th>Clicks</th>
              <th>CTR</th>
              <th>Revenue</th>
              <th>Budget</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="c in paginatedCampaigns" :key="c.id">
              <td>
                <div class="name-cell">
                  <div class="avatar">{{ initials(c.name) }}</div>
                  <span class="cell-name">{{ c.name }}</span>
                </div>
              </td>
              <td class="muted">{{ c.partner }}</td>
              <td>
                <span class="badge" :class="'badge-' + c.status">
                  {{ statusLabel[c.status] }}
                </span>
              </td>
              <td>{{ c.impressions }}</td>
              <td>{{ c.clicks }}</td>
              <td class="accent">{{ c.ctr }}</td>
              <td class="revenue">{{ c.revenue }}</td>
              <td>
                <div class="prog-wrap">
                  <div class="prog-bar" :style="{ width: c.budget + '%' }"></div>
                </div>
                <span class="prog-label">{{ c.budget }}%</span>
              </td>
              <td>
                <div class="actions">
                  <button class="icon-btn" @click="editCampaign(c)">Sửa</button>
                  <button class="icon-btn" @click="viewCampaign(c)">Chi tiết</button>
                </div>
              </td>
            </tr>
            <tr v-if="paginatedCampaigns.length === 0">
              <td colspan="9" style="text-align:center;color:#475569;padding:32px">
                Không tìm thấy campaign nào
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="pagination">
        <span class="page-info">
          Hiển thị {{ pageStart }}–{{ pageEnd }} / {{ filteredCampaigns.length }} campaigns
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

    <!-- Creative Assets -->
    <div class="section">
      <div class="sec-header">
        <span class="sec-title">Creative Assets</span>
        <div class="filters">
          <select v-model="assetFilter" class="pa-select">
            <option value="">Tất cả loại</option>
            <option value="Banner">Banner</option>
            <option value="Video">Video</option>
            <option value="Audio">Audio Ad</option>
          </select>
          <button class="btn btn-outline" @click="uploadAsset">Upload asset</button>
        </div>
      </div>

      <div class="asset-tabs">
        <div
          v-for="tab in assetTabs"
          :key="tab.key"
          class="asset-tab"
          :class="{ active: activeAssetTab === tab.key }"
          @click="activeAssetTab = tab.key"
        >
          {{ tab.label }}
        </div>
      </div>

      <div class="asset-grid">
        <div
          v-for="asset in filteredAssets"
          :key="asset.id"
          class="asset-card"
          @click="viewAsset(asset)"
        >
          <div class="asset-thumb" :style="{ background: asset.thumbColor }">
            <span class="thumb-type">{{ asset.type }}</span>
          </div>
          <div class="asset-info">
            <div class="asset-name">{{ asset.name }}</div>
            <div class="asset-meta">
              <span :style="{ color: typeColor(asset.type) }">{{ asset.type }}</span>
              <span>{{ asset.size }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Create Campaign Modal -->
    <Teleport to="body">
      <div v-if="showModal" class="modal-overlay" @click.self="showModal = false">
        <div class="modal">
          <div class="modal-header">
            <h2 class="modal-title">Tạo Campaign mới</h2>
            <button class="modal-close" @click="showModal = false">✕</button>
          </div>
          <div class="modal-body">
            <div class="form-group">
              <label>Tên campaign</label>
              <input v-model="newCampaign.name" type="text" class="pa-input full" placeholder="VD: Summer Hits 2026" />
            </div>
            <div class="form-row">
              <div class="form-group">
                <label>Partner</label>
                <select v-model="newCampaign.partner" class="pa-select full">
                  <option value="">Chọn partner</option>
                  <option v-for="p in partnerOptions" :key="p" :value="p">{{ p }}</option>
                </select>
              </div>
              <div class="form-group">
                <label>Loại campaign</label>
                <select v-model="newCampaign.type" class="pa-select full">
                  <option value="banner">Banner</option>
                  <option value="video">Video</option>
                  <option value="audio">Audio Ad</option>
                </select>
              </div>
            </div>
            <div class="form-row">
              <div class="form-group">
                <label>Ngày bắt đầu</label>
                <input v-model="newCampaign.startDate" type="date" class="pa-input full" />
              </div>
              <div class="form-group">
                <label>Ngày kết thúc</label>
                <input v-model="newCampaign.endDate" type="date" class="pa-input full" />
              </div>
            </div>
            <div class="form-group">
              <label>Budget (VND)</label>
              <input v-model="newCampaign.budget" type="number" class="pa-input full" placeholder="VD: 50000000" />
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn btn-outline" @click="showModal = false">Hủy</button>
            <button class="btn btn-primary" @click="saveCampaign">Tạo campaign</button>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const selectedPeriod = ref('this_month')
const searchQuery = ref('')
const filterStatus = ref('')
const filterPartner = ref('')
const currentPage = ref(1)
const pageSize = 6
const assetFilter = ref('')
const activeAssetTab = ref('all')
const showModal = ref(false)

const newCampaign = ref({
  name: '', partner: '', type: 'banner',
  startDate: '', endDate: '', budget: ''
})

const statusLabel = {
  active: 'Active', paused: 'Paused',
  ended: 'Ended', draft: 'Draft'
}

const stats = [
  { key: 'campaigns', label: 'Tổng campaigns', value: '24', change: '+3 so với tháng trước', up: true },
  { key: 'impressions', label: 'Tổng Impressions', value: '2.4M', change: '+18.2%', up: true },
  { key: 'clicks', label: 'Tổng Clicks', value: '148K', change: '+12.5%', up: true },
  { key: 'revenue', label: 'Tổng Revenue', value: '₫84.2M', change: '-3.1%', up: false },
]

const monthlyChart = [
  { month: 'Oct', impressions: 38, clicks: 18 },
  { month: 'Nov', impressions: 52, clicks: 28 },
  { month: 'Dec', impressions: 44, clicks: 22 },
  { month: 'Jan', impressions: 60, clicks: 35 },
  { month: 'Feb', impressions: 72, clicks: 42 },
  { month: 'Mar', impressions: 68, clicks: 38 },
  { month: 'Apr', impressions: 85, clicks: 52 },
]

const maxImp = computed(() => Math.max(...monthlyChart.map(m => m.impressions)))
const barHeight = (val) => Math.round((val / maxImp.value) * 90)

const revenueByPartner = [
  { name: 'Đen Vâu', pct: 32, color: '#3a80f5' },
  { name: 'M-TP Entertainment', pct: 22, color: '#34d399' },
  { name: 'J97 Entertainment', pct: 18, color: '#f59e0b' },
  { name: 'GERDNANG', pct: 15, color: '#f472b6' },
  { name: 'Others', pct: 13, color: '#475569' },
]

const campaigns = ref([
  { id: 1, name: 'Nhạc Tết 2026', partner: 'Đen Vâu', status: 'active', impressions: '520K', clicks: '38.2K', ctr: '7.3%', revenue: '₫18.4M', budget: 72 },
  { id: 2, name: 'Summer Hits Vol.2', partner: 'M-TP Entertainment', status: 'active', impressions: '310K', clicks: '21.5K', ctr: '6.9%', revenue: '₫11.2M', budget: 55 },
  { id: 3, name: 'J97 Fan Campaign', partner: 'J97 Entertainment', status: 'paused', impressions: '188K', clicks: '9.4K', ctr: '5.0%', revenue: '₫6.8M', budget: 40 },
  { id: 4, name: 'Brand Awareness Q1', partner: 'Đen Vâu', status: 'ended', impressions: '420K', clicks: '16.8K', ctr: '4.0%', revenue: '₫14.1M', budget: 100 },
  { id: 5, name: 'Melody Discovery', partner: 'Melody Hub', status: 'draft', impressions: '—', clicks: '—', ctr: '—', revenue: '—', budget: 0 },
  { id: 6, name: 'GERDNANG x Platform', partner: 'GERDNANG', status: 'active', impressions: '95K', clicks: '7.1K', ctr: '7.5%', revenue: '₫3.9M', budget: 28 },
  { id: 7, name: 'Indie Spotlight', partner: 'Melody Hub', status: 'active', impressions: '72K', clicks: '5.4K', ctr: '7.5%', revenue: '₫2.8M', budget: 35 },
  { id: 8, name: 'J97 New Album', partner: 'J97 Entertainment', status: 'draft', impressions: '—', clicks: '—', ctr: '—', revenue: '—', budget: 0 },
])

const partnerOptions = computed(() =>
  [...new Set(campaigns.value.map(c => c.partner))]
)

const filteredCampaigns = computed(() =>
  campaigns.value.filter(c => {
    const q = searchQuery.value.toLowerCase()
    const matchSearch = !q || c.name.toLowerCase().includes(q) || c.partner.toLowerCase().includes(q)
    const matchStatus = !filterStatus.value || c.status === filterStatus.value
    const matchPartner = !filterPartner.value || c.partner === filterPartner.value
    return matchSearch && matchStatus && matchPartner
  })
)

const totalPages = computed(() => Math.ceil(filteredCampaigns.value.length / pageSize))
const pageStart = computed(() => (currentPage.value - 1) * pageSize + 1)
const pageEnd = computed(() => Math.min(currentPage.value * pageSize, filteredCampaigns.value.length))
const paginatedCampaigns = computed(() =>
  filteredCampaigns.value.slice((currentPage.value - 1) * pageSize, currentPage.value * pageSize)
)

const assets = ref([
  { id: 1, name: 'banner-tet-2026-hero.jpg', type: 'Banner', size: '1200×628', thumbColor: '#1e1e35' },
  { id: 2, name: 'mtp-summer-video-30s.mp4', type: 'Video', size: '30 giây', thumbColor: '#1a2a1a' },
  { id: 3, name: 'j97-audio-ad-15s.mp3', type: 'Audio', size: '15 giây', thumbColor: '#1a1a2a' },
  { id: 4, name: 'gerdnang-banner-sq.jpg', type: 'Banner', size: '600×600', thumbColor: '#2a1a1a' },
  { id: 5, name: 'melody-discovery-banner.jpg', type: 'Banner', size: '728×90', thumbColor: '#1a2a2a' },
  { id: 6, name: 'den-vau-video-60s.mp4', type: 'Video', size: '60 giây', thumbColor: '#1a1e2a' },
  { id: 7, name: 'j97-banner-300x250.jpg', type: 'Banner', size: '300×250', thumbColor: '#221a2a' },
  { id: 8, name: 'mtp-audio-10s.mp3', type: 'Audio', size: '10 giây', thumbColor: '#1e2a1a' },
  { id: 9, name: 'gerdnang-video-15s.mp4', type: 'Video', size: '15 giây', thumbColor: '#2a1e1a' },
])

const assetTabs = [
  { key: 'all', label: `Tất cả (${assets.value.length})` },
  { key: 'Banner', label: `Banner (${assets.value.filter(a => a.type === 'Banner').length})` },
  { key: 'Video', label: `Video (${assets.value.filter(a => a.type === 'Video').length})` },
  { key: 'Audio', label: `Audio Ad (${assets.value.filter(a => a.type === 'Audio').length})` },
]

const filteredAssets = computed(() => {
  const type = activeAssetTab.value === 'all' ? '' : activeAssetTab.value
  const filterType = assetFilter.value || type
  return filterType ? assets.value.filter(a => a.type === filterType) : assets.value
})

const typeColor = (type) => {
  const map = { Banner: '#818cf8', Video: '#34d399', Audio: '#f59e0b' }
  return map[type] || '#64748b'
}

const initials = (name) =>
  name.split(' ').map(w => w[0]).join('').slice(0, 2).toUpperCase()

const openCreateCampaign = () => { showModal.value = true }
const saveCampaign = () => {
  if (!newCampaign.value.name || !newCampaign.value.partner) return
  campaigns.value.push({
    id: Date.now(),
    name: newCampaign.value.name,
    partner: newCampaign.value.partner,
    status: 'draft',
    impressions: '—', clicks: '—', ctr: '—', revenue: '—', budget: 0
  })
  showModal.value = false
  newCampaign.value = { name: '', partner: '', type: 'banner', startDate: '', endDate: '', budget: '' }
}
const editCampaign = (c) => console.log('Edit:', c)
const viewCampaign = (c) => console.log('View:', c)
const viewAsset = (a) => console.log('Asset:', a)
const uploadAsset = () => console.log('Upload asset')
const exportReport = () => console.log('Export report')
</script>

<style scoped>
.pa-page {
  padding: 28px;
  min-height: 100vh;
  background:  #181b1f;;
  color: #e2e8f0;
  font-family: 'DM Sans', 'Inter', sans-serif;
  font-size: 14px;
}

/* Header */
.pa-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24px;
}
.pa-title {
  font-size: 20px;
  font-weight: 500;
  color: #f1f5f9;
  margin: 0;
}
.pa-subtitle {
  font-size: 12px;
  color: #475569;
  margin-top: 2px;
}
.pa-header-right {
  display: flex;
  gap: 10px;
  align-items: center;
}

/* Buttons */
.btn {
  padding: 7px 16px;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  border: none;
  transition: opacity 0.15s;
}
.btn-primary { background: #3a80f5; color: #fff; }
.btn-outline {
  background: transparent;
  border: 0.5px solid #334155;
  color: #94a3b8;
}
.btn:hover { opacity: 0.85; }
.btn:disabled { opacity: 0.4; cursor: not-allowed; }

/* Inputs */
.pa-select,
.pa-input {
  background: #0f1117;
  border: 0.5px solid #334155;
  border-radius: 6px;
  padding: 6px 10px;
  font-size: 12px;
  color: #94a3b8;
  outline: none;
  font-family: inherit;
}
.pa-select:focus,
.pa-input:focus { border-color: #3a80f5; }
.pa-input.full,
.pa-select.full { width: 100%; }

/* Stats */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
  margin-bottom: 20px;
}
.stat-card {
  background: #181b1f;
  border-radius: 10px;
  padding: 16px 18px;
  border: 0.5px solid #2d3748;
}
.stat-label {
  font-size: 11px;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  margin-bottom: 6px;
}
.stat-value {
  font-size: 22px;
  font-weight: 500;
  color: #f1f5f9;
}
.stat-change { font-size: 12px; margin-top: 4px; }
.up { color: #34d399; }
.down { color: #f87171; }

/* Chart row */
.chart-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 18px;
  margin-bottom: 18px;
}

/* Section */
.section {
  background: #181b1f;
  border-radius: 10px;
  border: 0.5px solid #2d3748;
  margin-bottom: 18px;
  overflow: hidden;
}
.sec-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 20px;
  border-bottom: 0.5px solid #2d3748;
  flex-wrap: wrap;
  gap: 8px;
}
.sec-title {
  font-size: 13px;
  font-weight: 500;
  color: #cbd5e1;
}

/* Legend */
.legend {
  display: flex;
  gap: 14px;
}
.leg-item {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 11px;
  color: #64748b;
}
.leg-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  display: inline-block;
  flex-shrink: 0;
}

/* Charts */
.chart-area { padding: 16px 20px; }
.bar-group {
  display: flex;
  align-items: flex-end;
  gap: 4px;
  height: 110px;
}
.bar-col {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  flex: 1;
}
.bars {
  display: flex;
  align-items: flex-end;
  gap: 3px;
  height: 90px;
}
.bar {
  width: 12px;
  border-radius: 3px 3px 0 0;
  transition: opacity 0.15s;
  cursor: pointer;
  min-height: 2px;
}
.bar:hover { opacity: 0.7; }
.bar-imp { background: #3a80f5; }
.bar-click { background: #34d399; }
.bar-label { font-size: 10px; color: #475569; }

/* Revenue chart */
.rev-row {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
}
.rev-name {
  font-size: 12px;
  color: #64748b;
  width: 110px;
  flex-shrink: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.rev-bar-wrap {
  flex: 1;
  background: #2d3748;
  border-radius: 4px;
  height: 8px;
  overflow: hidden;
}
.rev-bar { height: 100%; border-radius: 4px; transition: width 0.5s ease; }
.rev-pct { font-size: 12px; color: #94a3b8; width: 30px; text-align: right; }

/* Filters */
.filters {
  display: flex;
  gap: 8px;
  align-items: center;
  flex-wrap: wrap;
}

/* Table */
.table-wrap { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; }
th {
  font-size: 11px;
  font-weight: 500;
  color: #475569;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  padding: 10px 18px;
  text-align: left;
  border-bottom: 0.5px solid #2d3748;
  background: #161b27;
  white-space: nowrap;
}
td {
  padding: 12px 18px;
  border-bottom: 0.5px solid #1e2a3a;
  color: #cbd5e1;
  font-size: 13px;
}
tr:last-child td { border-bottom: none; }
tr:hover td { background: #232a3d; }

.name-cell { display: flex; align-items: center; gap: 10px; }
.avatar {
  width: 28px;
  height: 28px;
  border-radius: 6px;
  background: #2d3748;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 10px;
  font-weight: 500;
  color: #818cf8;
  flex-shrink: 0;
}
.cell-name { color: #e2e8f0; font-weight: 500; }
.muted { color: #94a3b8; }
.accent { color: #818cf8; }
.revenue { color: #34d399; font-weight: 500; }

/* Badge */
.badge {
  display: inline-block;
  padding: 3px 10px;
  border-radius: 20px;
  font-size: 11px;
  font-weight: 500;
  white-space: nowrap;
}
.badge-active { background: #064e3b; color: #34d399; }
.badge-paused { background: #3b1f00; color: #f59e0b; }
.badge-ended { background: #1f1f2e; color: #64748b; }
.badge-draft { background: #1e1e35; color: #818cf8; }

/* Progress */
.prog-wrap {
  width: 100%;
  background: #2d3748;
  border-radius: 4px;
  height: 5px;
  overflow: hidden;
}
.prog-bar { height: 100%; border-radius: 4px; background: #3a80f5; }
.prog-label { font-size: 11px; color: #475569; margin-top: 3px; display: block; }

/* Actions */
.actions { display: flex; gap: 6px; }
.icon-btn {
  background: transparent;
  border: 0.5px solid #334155;
  border-radius: 6px;
  padding: 4px 10px;
  color: #64748b;
  cursor: pointer;
  font-size: 11px;
  font-family: inherit;
  transition: background 0.15s, color 0.15s;
}
.icon-btn:hover { background: #232a3d; color: #94a3b8; }

/* Pagination */
.pagination {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 20px;
  border-top: 0.5px solid #2d3748;
}
.page-info { font-size: 12px; color: #475569; }
.page-btns { display: flex; gap: 6px; }
.page-btn {
  background: #161b27;
  border: 0.5px solid #2d3748;
  border-radius: 6px;
  padding: 5px 10px;
  color: #64748b;
  cursor: pointer;
  font-size: 12px;
  font-family: inherit;
  transition: background 0.15s;
}
.page-btn:hover:not(:disabled) { background: #232a3d; color: #94a3b8; }
.page-btn.active { background: #3a80f5; border-color: #3a80f5; color: #fff; }
.page-btn:disabled { opacity: 0.4; cursor: not-allowed; }

/* Assets */
.asset-tabs {
  display: flex;
  gap: 2px;
  padding: 0 16px;
  border-bottom: 0.5px solid #2d3748;
}
.asset-tab {
  padding: 10px 14px;
  font-size: 12px;
  color: #64748b;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  transition: color 0.15s;
}
.asset-tab.active { color: #818cf8; border-bottom-color: #3a80f5; }
.asset-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
  gap: 12px;
  padding: 16px;
}
.asset-card {
  background: #161b27;
  border-radius: 8px;
  border: 0.5px solid #2d3748;
  overflow: hidden;
  cursor: pointer;
  transition: border-color 0.15s;
}
.asset-card:hover { border-color: #475569; }
.asset-thumb {
  height: 72px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.thumb-type {
  font-size: 10px;
  color: #475569;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  font-weight: 500;
}
.asset-info {
  padding: 10px 12px;
  border-top: 0.5px solid #2d3748;
}
.asset-name {
  font-size: 12px;
  color: #cbd5e1;
  font-weight: 500;
  margin-bottom: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.asset-meta {
  display: flex;
  justify-content: space-between;
  font-size: 11px;
  color: #475569;
}

/* Modal */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}
.modal {
  background: #181b1f;
  border: 0.5px solid #2d3748;
  border-radius: 12px;
  width: 480px;
  max-width: 90vw;
}
.modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 20px;
  border-bottom: 0.5px solid #2d3748;
}
.modal-title {
  font-size: 15px;
  font-weight: 500;
  color: #f1f5f9;
  margin: 0;
}
.modal-close {
  background: transparent;
  border: none;
  color: #64748b;
  cursor: pointer;
  font-size: 14px;
  padding: 4px 8px;
}
.modal-close:hover { color: #94a3b8; }
.modal-body { padding: 20px; display: flex; flex-direction: column; gap: 16px; }
.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 16px 20px;
  border-top: 0.5px solid #2d3748;
}

.form-group { display: flex; flex-direction: column; gap: 6px; flex: 1; }
.form-group label { font-size: 12px; color: #94a3b8; }
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }

/* Responsive */
@media (max-width: 900px) {
  .stats-grid { grid-template-columns: repeat(2, 1fr); }
  .chart-row { grid-template-columns: 1fr; }
}
@media (max-width: 600px) {
  .stats-grid { grid-template-columns: 1fr; }
  .pa-header { flex-direction: column; align-items: flex-start; gap: 12px; }
}
</style>
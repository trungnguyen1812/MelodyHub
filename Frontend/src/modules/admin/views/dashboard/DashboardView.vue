<template>
  <div class="dash">
    <div class="dash__ambient" />

    <!-- ── Header ──────────────────────────────────────────────────────── -->
    <div class="dash__header">
      <div>
        <h1 class="dash__title">Dashboard</h1>
        <p class="dash__subtitle">Welcome back, {{ adminName }} — here's what's happening today.</p>
      </div>
      <button class="btn-refresh" :class="{ spinning: store.loading }" @click="store.fetch()" title="Refresh">
        <svg width="15" height="15" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
        </svg>
      </button>
    </div>

    <!-- ── Error ────────────────────────────────────────────────────────── -->
    <div v-if="store.error" class="alert-error">{{ store.error }}</div>

    <!-- ── Stat Cards ───────────────────────────────────────────────────── -->
    <div class="stat-grid">
      <div v-for="card in statCards" :key="card.label" class="stat-card" :class="card.color">
        <div class="stat-card__top">
          <div class="stat-card__icon" v-html="card.icon" />
          <span class="stat-card__badge" :class="card.badgeClass">{{ card.badge }}</span>
        </div>
        <div class="stat-card__value">
          <template v-if="store.loading">
            <div class="skel skel-val" />
          </template>
          <template v-else>{{ card.value }}</template>
        </div>
        <div class="stat-card__label">{{ card.label }}</div>
        <div class="stat-card__sub">{{ card.sub }}</div>
      </div>
    </div>

    <!-- ── Charts row ───────────────────────────────────────────────────── -->
    <div class="charts-row">
      <!-- User registrations trend -->
      <div class="chart-card">
        <div class="chart-card__header">
          <span class="chart-card__title">User Registrations</span>
          <span class="chart-card__sub">Last 6 months</span>
        </div>
        <div class="chart-card__body">
          <VueApexCharts
            v-if="!store.loading && userChartSeries[0].data.length"
            type="area"
            height="200"
            :options="userChartOptions"
            :series="userChartSeries"
          />
          <div v-else-if="store.loading" class="skel skel-chart" />
          <div v-else class="chart-empty">No data</div>
        </div>
      </div>

      <!-- Revenue trend -->
      <div class="chart-card">
        <div class="chart-card__header">
          <span class="chart-card__title">Revenue</span>
          <span class="chart-card__sub">Last 6 months (VND)</span>
        </div>
        <div class="chart-card__body">
          <VueApexCharts
            v-if="!store.loading && revenueChartSeries[0].data.length"
            type="bar"
            height="200"
            :options="revenueChartOptions"
            :series="revenueChartSeries"
          />
          <div v-else-if="store.loading" class="skel skel-chart" />
          <div v-else class="chart-empty">No data</div>
        </div>
      </div>
    </div>

    <!-- ── Content stats row ─────────────────────────────────────────────── -->
    <div class="mini-stat-row">
      <div class="mini-stat" v-for="m in miniStats" :key="m.label">
        <div class="mini-stat__icon" v-html="m.icon" />
        <div>
          <div class="mini-stat__value">
            <template v-if="store.loading"><div class="skel skel-mini" /></template>
            <template v-else>{{ m.value }}</template>
          </div>
          <div class="mini-stat__label">{{ m.label }}</div>
        </div>
      </div>
    </div>

    <!-- ── Tables row ───────────────────────────────────────────────────── -->
    <div class="tables-row">
      <!-- Recent Users -->
      <div class="table-card">
        <div class="table-card__header">
          <span class="table-card__title">Recent Users</span>
          <router-link :to="{ name: 'admin.usermanager' }" class="table-card__link">View all →</router-link>
        </div>
        <div v-if="store.loading" class="skel-rows">
          <div v-for="i in 5" :key="i" class="skel-row-item">
            <div class="skel skel-avatar" />
            <div class="skel-row-text">
              <div class="skel skel-name" />
              <div class="skel skel-email" />
            </div>
          </div>
        </div>
        <div v-else-if="store.recentUsers.length === 0" class="table-empty">No users yet</div>
        <div v-else class="user-list">
          <div v-for="u in store.recentUsers" :key="u.id" class="user-item">
            <div class="user-avatar">{{ initial(u.name) }}</div>
            <div class="user-info">
              <span class="user-name">{{ u.name }}</span>
              <span class="user-email">{{ u.email }}</span>
            </div>
            <span class="status-chip" :class="'status-' + u.status">{{ u.status }}</span>
          </div>
        </div>
      </div>

      <!-- Recent Partners -->
      <div class="table-card">
        <div class="table-card__header">
          <span class="table-card__title">Recent Partners</span>
          <router-link :to="{ name: 'admin.partnersmanager' }" class="table-card__link">View all →</router-link>
        </div>
        <div v-if="store.loading" class="skel-rows">
          <div v-for="i in 5" :key="i" class="skel-row-item">
            <div class="skel skel-avatar" />
            <div class="skel-row-text">
              <div class="skel skel-name" />
              <div class="skel skel-email" />
            </div>
          </div>
        </div>
        <div v-else-if="store.recentPartners.length === 0" class="table-empty">No partners yet</div>
        <div v-else class="user-list">
          <div v-for="p in store.recentPartners" :key="p.id" class="user-item">
            <div class="user-avatar user-avatar--partner">{{ initial(p.company_name) }}</div>
            <div class="user-info">
              <span class="user-name">{{ p.company_name }}</span>
              <span class="user-email">{{ p.type ?? 'Partner' }}</span>
            </div>
            <span class="status-chip" :class="'status-' + p.status">{{ p.status }}</span>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import VueApexCharts from 'vue3-apexcharts'
import type { ApexOptions } from 'apexcharts'
import { useDashboardStore } from '@/modules/admin/stores/dashboard/dashboardStore'
import { useAuthStore } from '@/store/authStore'

const store     = useDashboardStore()
const authStore = useAuthStore()

const adminName = computed(() => authStore.user?.name ?? 'Admin')

// ── Helpers ──────────────────────────────────────────────────────────────────
const initial = (name?: string | null) =>
  (name ?? '?').trim().charAt(0).toUpperCase()

const fmtVND = (val: number | null | undefined) => {
  if (!val) return '₫0'
  if (val >= 1_000_000_000) return '₫' + (val / 1_000_000_000).toFixed(1) + 'B'
  if (val >= 1_000_000)     return '₫' + (val / 1_000_000).toFixed(1) + 'M'
  if (val >= 1_000)         return '₫' + (val / 1_000).toFixed(0) + 'K'
  return '₫' + val.toLocaleString('vi-VN')
}

const fmtGrowth = (val: number | null | undefined) => {
  if (val == null) return '—'
  return (val >= 0 ? '+' : '') + val + '%'
}

// ── Stat cards ────────────────────────────────────────────────────────────────
const statCards = computed(() => {
  const s = store.stats
  return [
    {
      label: 'Total Users',
      value: s?.total_users?.toLocaleString() ?? '—',
      sub: `+${s?.new_users_month ?? 0} this month`,
      badge: fmtGrowth(s?.user_growth),
      badgeClass: (s?.user_growth ?? 0) >= 0 ? 'badge-up' : 'badge-down',
      color: 'card-blue',
      icon: `<svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>`,
    },
    {
      label: 'Active Partners',
      value: s?.active_partners?.toLocaleString() ?? '—',
      sub: `${s?.pending_partners ?? 0} pending approval`,
      badge: `${s?.total_partners ?? 0} total`,
      badgeClass: 'badge-neutral',
      color: 'card-purple',
      icon: `<svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>`,
    },
    {
      label: 'Revenue This Month',
      value: fmtVND(s?.revenue_this_month),
      sub: `Total: ${fmtVND(s?.revenue_total)}`,
      badge: fmtGrowth(s?.revenue_growth),
      badgeClass: (s?.revenue_growth ?? 0) >= 0 ? 'badge-up' : 'badge-down',
      color: 'card-green',
      icon: `<svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>`,
    },
    {
      label: 'Total Songs',
      value: s?.total_songs?.toLocaleString() ?? '—',
      sub: `${s?.total_artists ?? 0} artists · ${s?.total_albums ?? 0} albums`,
      badge: 'Content',
      badgeClass: 'badge-neutral',
      color: 'card-orange',
      icon: `<svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3"/></svg>`,
    },
  ]
})

// ── Mini stats ────────────────────────────────────────────────────────────────
const miniStats = computed(() => {
  const s = store.stats
  return [
    {
      label: 'Artists',
      value: s?.total_artists?.toLocaleString() ?? '—',
      icon: `<svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>`,
    },
    {
      label: 'Albums',
      value: s?.total_albums?.toLocaleString() ?? '—',
      icon: `<svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>`,
    },
    {
      label: 'Songs',
      value: s?.total_songs?.toLocaleString() ?? '—',
      icon: `<svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3"/></svg>`,
    },
    {
      label: 'Total Partners',
      value: s?.total_partners?.toLocaleString() ?? '—',
      icon: `<svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z"/></svg>`,
    },
    {
      label: 'Pending Partners',
      value: s?.pending_partners?.toLocaleString() ?? '—',
      icon: `<svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>`,
    },
    {
      label: 'Total Revenue',
      value: fmtVND(s?.revenue_total),
      icon: `<svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 14l6-6m-5.5.5h.01m4.99 5h.01M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16l3.5-2 3.5 2 3.5-2 3.5 2z"/></svg>`,
    },
  ]
})

// ── Chart configs ─────────────────────────────────────────────────────────────
const chartBase: ApexOptions = {
  chart: { toolbar: { show: false }, background: 'transparent', fontFamily: 'DM Sans, system-ui' },
  grid: { borderColor: 'rgba(255,255,255,0.06)', strokeDashArray: 4 },
  xaxis: { labels: { style: { colors: '#64748b', fontSize: '11px' } }, axisBorder: { show: false }, axisTicks: { show: false } },
  yaxis: { labels: { style: { colors: '#64748b', fontSize: '11px' } } },
  tooltip: { theme: 'dark' },
  legend: { show: false },
}

const userChartSeries = computed(() => [{
  name: 'New Users',
  data: store.userTrend.map(t => t.count ?? 0),
}])

const userChartOptions = computed<ApexOptions>(() => ({
  ...chartBase,
  colors: ['#00c6ff'],
  fill: { type: 'gradient', gradient: { shadeIntensity: 1, opacityFrom: 0.35, opacityTo: 0.02, stops: [0, 100] } },
  stroke: { curve: 'smooth', width: 2 },
  xaxis: { ...chartBase.xaxis, categories: store.userTrend.map(t => t.month) },
  dataLabels: { enabled: false },
}))

const revenueChartSeries = computed(() => [{
  name: 'Revenue',
  data: store.revenueTrend.map(t => t.amount ?? 0),
}])

const revenueChartOptions = computed<ApexOptions>(() => ({
  ...chartBase,
  colors: ['#a78bfa'],
  plotOptions: { bar: { borderRadius: 5, columnWidth: '55%' } },
  xaxis: { ...chartBase.xaxis, categories: store.revenueTrend.map(t => t.month) },
  dataLabels: { enabled: false },
  tooltip: {
    theme: 'dark',
    y: { formatter: (v: number) => fmtVND(v) },
  },
}))

onMounted(() => store.fetch())
</script>

<style scoped>
/* ── Page ───────────────────────────────────────────────────────────────────── */
.dash {
  padding: 24px 28px 48px;
  min-height: 100%;
  color: rgba(255,255,255,0.9);
  font-family: 'DM Sans', system-ui, sans-serif;
  font-size: 14px;
  position: relative;
}

.dash__ambient {
  position: fixed;
  inset: 0;
  pointer-events: none;
  background:
    radial-gradient(ellipse 55% 35% at 5% 0%, rgba(0,198,255,0.06) 0%, transparent 70%),
    radial-gradient(ellipse 45% 45% at 95% 100%, rgba(167,139,250,0.05) 0%, transparent 70%);
  z-index: 0;
}

/* ── Header ─────────────────────────────────────────────────────────────────── */
.dash__header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: 24px;
  position: relative;
  z-index: 1;
}

.dash__title {
  font-size: 22px;
  font-weight: 700;
  margin: 0 0 4px;
  background: linear-gradient(90deg, #fff 40%, #00c6ff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.dash__subtitle {
  font-size: 13px;
  color: rgba(255,255,255,0.38);
  margin: 0;
}

.btn-refresh {
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.08);
  color: rgba(255,255,255,0.5);
  width: 36px; height: 36px;
  border-radius: 10px;
  display: flex; align-items: center; justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
  flex-shrink: 0;
}

.btn-refresh:hover { background: rgba(255,255,255,0.1); color: #fff; }
.btn-refresh.spinning svg { animation: spin 0.8s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

.alert-error {
  background: rgba(248,113,113,0.1);
  border: 1px solid rgba(248,113,113,0.2);
  color: #f87171;
  padding: 10px 16px;
  border-radius: 10px;
  margin-bottom: 20px;
  font-size: 13px;
  position: relative; z-index: 1;
}

/* ── Stat cards ─────────────────────────────────────────────────────────────── */
.stat-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 20px;
  position: relative; z-index: 1;
}

.stat-card {
  border-radius: 16px;
  padding: 20px;
  border: 1px solid rgba(255,255,255,0.07);
  background: rgba(255,255,255,0.03);
  backdrop-filter: blur(8px);
  transition: transform 0.2s, border-color 0.2s;
  position: relative;
  overflow: hidden;
}

.stat-card::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 2px;
}

.stat-card:hover { transform: translateY(-3px); border-color: rgba(255,255,255,0.12); }

.card-blue::before   { background: linear-gradient(90deg, #00c6ff, #0072ff); }
.card-purple::before { background: linear-gradient(90deg, #a78bfa, #7c3aed); }
.card-green::before  { background: linear-gradient(90deg, #34d399, #059669); }
.card-orange::before { background: linear-gradient(90deg, #fb923c, #ea580c); }

.stat-card__top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 14px;
}

.stat-card__icon {
  width: 38px; height: 38px;
  border-radius: 10px;
  background: rgba(255,255,255,0.06);
  display: flex; align-items: center; justify-content: center;
  color: rgba(255,255,255,0.7);
}

.stat-card__badge {
  font-size: 11px;
  font-weight: 600;
  padding: 3px 8px;
  border-radius: 20px;
}

.badge-up      { background: rgba(52,211,153,0.12); color: #34d399; }
.badge-down    { background: rgba(248,113,113,0.12); color: #f87171; }
.badge-neutral { background: rgba(255,255,255,0.07); color: rgba(255,255,255,0.5); }

.stat-card__value {
  font-size: 26px;
  font-weight: 700;
  color: #fff;
  margin-bottom: 4px;
  min-height: 32px;
}

.stat-card__label {
  font-size: 12px;
  font-weight: 500;
  color: rgba(255,255,255,0.5);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 4px;
}

.stat-card__sub {
  font-size: 12px;
  color: rgba(255,255,255,0.3);
}

/* ── Charts row ─────────────────────────────────────────────────────────────── */
.charts-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 16px;
  position: relative; z-index: 1;
}

.chart-card {
  background: rgba(255,255,255,0.03);
  border: 1px solid rgba(255,255,255,0.07);
  border-radius: 16px;
  overflow: hidden;
  backdrop-filter: blur(8px);
}

.chart-card__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px 12px;
  border-bottom: 1px solid rgba(255,255,255,0.05);
}

.chart-card__title {
  font-size: 14px;
  font-weight: 600;
  color: rgba(255,255,255,0.9);
}

.chart-card__sub {
  font-size: 11px;
  color: rgba(255,255,255,0.3);
}

.chart-card__body {
  padding: 12px 8px 4px;
}

.chart-empty {
  height: 200px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: rgba(255,255,255,0.2);
  font-size: 13px;
}

/* ── Mini stats ─────────────────────────────────────────────────────────────── */
.mini-stat-row {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 12px;
  margin-bottom: 20px;
  position: relative; z-index: 1;
}

.mini-stat {
  background: rgba(255,255,255,0.03);
  border: 1px solid rgba(255,255,255,0.06);
  border-radius: 12px;
  padding: 14px 16px;
  display: flex;
  align-items: center;
  gap: 12px;
  transition: border-color 0.2s;
}

.mini-stat:hover { border-color: rgba(255,255,255,0.12); }

.mini-stat__icon {
  color: rgba(255,255,255,0.4);
  flex-shrink: 0;
}

.mini-stat__value {
  font-size: 18px;
  font-weight: 700;
  color: #fff;
  min-height: 22px;
}

.mini-stat__label {
  font-size: 11px;
  color: rgba(255,255,255,0.35);
  text-transform: uppercase;
  letter-spacing: 0.04em;
  margin-top: 2px;
}

/* ── Tables row ─────────────────────────────────────────────────────────────── */
.tables-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  position: relative; z-index: 1;
}

.table-card {
  background: rgba(255,255,255,0.03);
  border: 1px solid rgba(255,255,255,0.07);
  border-radius: 16px;
  overflow: hidden;
  backdrop-filter: blur(8px);
}

.table-card__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-bottom: 1px solid rgba(255,255,255,0.05);
}

.table-card__title {
  font-size: 14px;
  font-weight: 600;
  color: rgba(255,255,255,0.9);
}

.table-card__link {
  font-size: 12px;
  color: #00c6ff;
  text-decoration: none;
  transition: opacity 0.2s;
}

.table-card__link:hover { opacity: 0.75; }

.table-empty {
  padding: 32px;
  text-align: center;
  color: rgba(255,255,255,0.2);
  font-size: 13px;
}

/* User list */
.user-list { padding: 8px 0; }

.user-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 20px;
  transition: background 0.15s;
}

.user-item:hover { background: rgba(255,255,255,0.03); }

.user-avatar {
  width: 36px; height: 36px;
  border-radius: 10px;
  background: linear-gradient(135deg, #00c6ff22, #0072ff33);
  border: 1px solid rgba(0,198,255,0.2);
  display: flex; align-items: center; justify-content: center;
  font-size: 13px; font-weight: 700;
  color: #00c6ff;
  flex-shrink: 0;
}

.user-avatar--partner {
  background: linear-gradient(135deg, #a78bfa22, #7c3aed33);
  border-color: rgba(167,139,250,0.2);
  color: #a78bfa;
}

.user-info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.user-name {
  font-size: 13px;
  font-weight: 500;
  color: rgba(255,255,255,0.9);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.user-email {
  font-size: 11px;
  color: rgba(255,255,255,0.3);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Status chips */
.status-chip {
  font-size: 10px;
  font-weight: 600;
  padding: 3px 8px;
  border-radius: 20px;
  text-transform: capitalize;
  flex-shrink: 0;
}

.status-active    { background: rgba(52,211,153,0.12); color: #34d399; }
.status-inactive  { background: rgba(100,116,139,0.12); color: #94a3b8; }
.status-banned    { background: rgba(248,113,113,0.12); color: #f87171; }
.status-pending   { background: rgba(251,191,36,0.12); color: #fbbf24; }
.status-suspended { background: rgba(251,146,60,0.12); color: #fb923c; }

/* ── Skeleton ───────────────────────────────────────────────────────────────── */
@keyframes shimmer {
  0%   { background-position: -600px 0; }
  100% { background-position:  600px 0; }
}

.skel {
  border-radius: 6px;
  background: linear-gradient(90deg,
    rgba(255,255,255,0.04) 25%,
    rgba(255,255,255,0.09) 50%,
    rgba(255,255,255,0.04) 75%);
  background-size: 600px 100%;
  animation: shimmer 1.6s infinite linear;
}

.skel-val   { width: 80px; height: 28px; border-radius: 6px; }
.skel-mini  { width: 50px; height: 20px; border-radius: 5px; }
.skel-chart { height: 200px; border-radius: 8px; margin: 8px; }

.skel-rows { padding: 8px 0; }
.skel-row-item {
  display: flex; align-items: center; gap: 12px;
  padding: 10px 20px;
}
.skel-avatar { width: 36px; height: 36px; border-radius: 10px; flex-shrink: 0; }
.skel-row-text { flex: 1; display: flex; flex-direction: column; gap: 6px; }
.skel-name  { width: 120px; height: 12px; }
.skel-email { width: 160px; height: 10px; }

/* ── Responsive ─────────────────────────────────────────────────────────────── */
@media (max-width: 1280px) {
  .stat-grid      { grid-template-columns: repeat(2, 1fr); }
  .mini-stat-row  { grid-template-columns: repeat(3, 1fr); }
}

@media (max-width: 900px) {
  .charts-row  { grid-template-columns: 1fr; }
  .tables-row  { grid-template-columns: 1fr; }
}

@media (max-width: 640px) {
  .dash         { padding: 16px; }
  .stat-grid    { grid-template-columns: 1fr; }
  .mini-stat-row { grid-template-columns: repeat(2, 1fr); }
}
</style>

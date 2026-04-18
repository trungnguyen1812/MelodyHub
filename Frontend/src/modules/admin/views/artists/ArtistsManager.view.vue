<template>
    <div class="dashboard-container">
        <div class="header-section">
            <div class="title-container">
                <h1>Artists Management</h1>
                <p class="subtitle">Manage All Artists Accounts</p>
            </div>
            <div class="header-actions">
                <button class="btn-add-user" @click="CreateArtist">
                    <span class="btn-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v6m3-3H9m12 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                        </svg>
                    </span>
                    Add New Artist
                </button>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="statistics-section">
                <!-- Stats Cards -->
                <div class="stats-cards">
                    <div class="stats-header">
                        <h2>Quick Stats</h2>
                        <span class="stats-update">Updated just now</span>
                    </div>
                    <div class="stats-grid">
                        <!-- Card 1: Total Artists -->
                        <div class="stat-card">
                            <div class="stat-icon total-artists">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
                                </svg>
                            </div>
                            <div class="stat-info">
                                <h3>Total Artists</h3>
                                <CountUp 
                                    :key="statistics?.total_artists ?? 0"
                                    :endVal="statistics?.total_artists ?? 0" 
                                    :duration="1" 
                                    class="stat-value"
                                />
                                <p class="stat-change" :class="getChangeClass(statistics?.growth_percentage)">
                                    {{ formatGrowthChange(statistics?.growth_percentage) }}
                                </p>
                            </div>
                        </div>

                        <!-- Card 2: New Singer of the Month -->
                        <div class="stat-card">
                            <div class="stat-icon new-artists">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v6m3-3H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                            </div>
                            <div class="stat-info">
                                <h3>New Singer of the Month</h3>
                                <CountUp 
                                    :key="statistics?.new_artists_this_month ?? 0"
                                    :endVal="statistics?.new_artists_this_month ?? 0" 
                                    :duration="1" 
                                    class="stat-value"
                                />
                                <p 
                                    class="stat-change"
                                    :class="getChangeClass(
                                        (statistics?.new_artists_this_month ?? 0) - (statistics?.new_artists_last_month ?? 0)
                                    )"
                                    >
                                    {{ formatNewArtistsChange(statistics?.new_artists_this_month, statistics?.new_artists_last_month) }}
                                </p>
                            </div>
                        </div>

                        <!-- Card 3: Growth -->
                        <div class="stat-card">
                            <div class="stat-icon growth">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 18L9 11.25l4.306 4.307a11.95 11.95 0 015.814-5.519l2.74-1.22m0 0l-5.94-2.28m5.94 2.28l-2.28 5.941" />
                                </svg>
                            </div>
                            <div class="stat-info">
                                <h3>Growth</h3>
                                <p class="stat-value">{{ formatGrowthValue(statistics?.growth_percentage) }}</p>
                                <p class="stat-change" :class="getChangeClass(statistics?.growth_percentage)">
                                    {{ formatGrowthStatus(statistics?.status, statistics?.growth_percentage) }}
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Loading State -->
                    <div v-if="store.loading" class="loading-overlay">
                        <div class="spinner"></div>
                    </div>

                    <!-- Error State -->
                    <div v-if="store.error" class="error-message">
                        {{ store.error }}
                    </div>
                </div>
                <!-- Chart Container -->
                <div class="chart-container">
                    <div class="section-header">
                        <h2>Artists Distribution</h2>
                        <div class="chart-filter">
                            <select class="period-select">
                                <option value="month">This Month</option>
                                <option value="quarter">This Quarter</option>
                                <option value="year">This Year</option>
                            </select>
                        </div>
                    </div>
                    <ApexChart
                        type="bar"
                        height="350"
                        :options="chartOptions"
                        :series="series"
                    />
                </div>
            </div>

            <!-- Top Artists Ranking-->
            <div class="ranking-section">
                <div class="ranking-header">
                    <h2>Top Artists Ranking</h2>
                    <div class="ranking-actions">
                        <button class="btn-view-all" @click="ViewAllArtists">View All →</button>
                    </div>
                </div>

                <div class="ranking-table">
                    <div class="table-header">
                        <div class="rank-col">Rank</div>
                        <div class="artist-col">Artist</div>
                        <div class="plays-col">Plays</div>
                        <div class="followers-col">Followers</div>
                        <div class="trend-col">Trend</div>
                    </div>

                    <div class="table-body">
                        <!-- Dynamic Top Artists -->
                        <div 
                            v-for="(artist, rank) in topArtists"
                            :key="artist.id"
                            class="table-row"
                        >
                            <div class="rank-col">
                                <span class="rank-number" :class="`rank-${rank + 1}`">{{ rank + 1 }}</span>
                            </div>
                            <div class="artist-col">
                                <div class="artist-info">
                                    <div class="artist-avatar">
                                        <img 
                                            v-if="artist.avatar_url"
                                            :src="getFullImageUrl(artist.avatar_url)"
                                            :alt="artist.name"
                                            class="avatar-img"
                                        />
                                        <div v-else class="avatar-placeholder">
                                            {{ artist.name.charAt(0).toUpperCase() }}
                                        </div>
                                    </div>
                                    <div class="artist-details">
                                        <h4>{{ artist.name }}</h4>
                                        <p class="artist-category">{{ getCategoryLabel(artist) }}</p>
                                    </div>
                                </div>
                            </div>
                            <div class="plays-col">
                                <span class="stat-value">{{ formatNumber(artist.total_plays || 0) }}</span>
                            </div>
                            <div class="followers-col">
                                <span class="stat-value">{{ formatNumber(artist.total_followers || 0) }}</span>
                            </div>
                            <div class="trend-col">
                                <span class="trend-indicator" :class="getTrendClass(artist)">{{ getTrendIcon(artist) }}</span>
                            </div>
                        </div>

                        <!-- Empty State -->
                        <div v-if="topArtists.length === 0" class="empty-state">
                            <p>No artists available</p>
                        </div>
                    </div>
                </div>

                <div class="ranking-footer">
                    <div class="pagination-info">
                        Showing {{ topArtists.length }} of {{ store.artists.length }} artists
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import VueApexCharts from "vue3-apexcharts"
import type { ApexOptions } from "apexcharts"
import { useArtistStore, getFullImageUrl } from '@/modules/admin/stores/artists/artistsStore'
import { ref, computed, onMounted } from "vue"
import router from '@/modules/router'
import CountUp from '@/components/common/VcCountUp/CountUp.vue'

const ApexChart = VueApexCharts
const store = useArtistStore()

// ─── Computed: Top Artists (sorted by plays) ─────────────────────────────────
const topArtists = computed(() => {
  return store.artists
    .slice()
    .sort((a: any, b: any) => (b.total_plays || 0) - (a.total_plays || 0))
    .slice(0, 8)
})

// ─── Chart: Dynamic data from store ───────────────────────────────────────────
const chartData = computed(() => {
  // Get top 12 artists + plays count for chart
  const artists = store.artists
    .slice()
    .sort((a: any, b: any) => (b.total_plays || 0) - (a.total_plays || 0))
    .slice(0, 12)
  
  return {
    labels: artists.map(a => a.name),
    data: artists.map(a => Math.round((a.total_plays || 0) / 1_000_000)) // Convert to millions
  }
})

const series = computed(() => [
  {
    name: "Plays (Millions)",
    data: chartData.value.data,
  },
])

const chartOptions = computed((): ApexOptions => ({
  chart: {
    type: "bar",
    height: 350,
    toolbar: { show: false },
  },
  plotOptions: {
    bar: {
      borderRadius: 10,
      columnWidth: "60%",
      dataLabels: { position: "top" },
    },
  },
  dataLabels: {
    enabled: false,
  },
  stroke: {
    width: 0,
  },
  grid: {
    show: true,
    borderColor: 'rgba(255, 255, 255, 0.1)',
    strokeDashArray: 4,
  },
  xaxis: {
    categories: chartData.value.labels,
    labels: {
      rotate: -45,
      maxHeight: 100,
      style: {
        colors: '#9ca3af',
        fontSize: '12px',
        fontWeight: 500
      }
    },
    axisBorder: { show: false },
    axisTicks: { show: false },
  },
  yaxis: {
    title: {
      text: "Plays (Millions)",
      style: { color: '#9ca3af' }
    },
    labels: {
      style: { colors: '#9ca3af' }
    }
  },
  colors: ['#00aaff'],
  tooltip: {
    theme: 'dark',
    y: {
      formatter: (val: number) => `${val}M plays`
    }
  }
}))

// ─── Helper Functions ────────────────────────────────────────────────────────

const formatNumber = (n: number): string => {
  if (n >= 1_000_000) return (n / 1_000_000).toFixed(1) + 'M'
  if (n >= 1_000) return (n / 1_000).toFixed(1) + 'K'
  return String(n)
}

const getCategoryLabel = (artist: any): string => {
  const plays = artist.total_plays || 0
  const followers = artist.total_followers || 0
  
  if (followers > 1_000_000) return 'Superstar'
  if (followers > 100_000) return 'Popular'
  if (plays > 1_000_000) return 'Rising'
  return 'Emerging'
}

const getTrendClass = (artist: any): string => {
  // Check if follows were gained this month or plays increased
  const followers = artist.total_followers || 0
  const plays = artist.total_plays || 0
  
  if (followers > 500_000 || plays > 5_000_000) return 'trend-up'
  if (followers < 50_000) return 'trend-down'
  return 'trend-neutral'
}

const getTrendIcon = (artist: any): string => {
  const trendClass = getTrendClass(artist)
  if (trendClass === 'trend-up') return '↗'
  if (trendClass === 'trend-down') return '↘'
  return '→'
}

// ─── Actions ─────────────────────────────────────────────────────────────────

const ViewAllArtists = () => {
  router.push({ name: "admin.artistsmanager.all" })
}

const CreateArtist = () => {
  router.push({ name: "admin.artistsmanager.add" })
}

// ─── Statistics Getters ──────────────────────────────────────────────────────

const statistics = computed(() => store.statistics)

// ─── Format Functions ────────────────────────────────────────────────────────

const formatGrowthChange = (percentage: number | undefined): string => {
  if (percentage === undefined) return 'No data'
  const sign = percentage >= 0 ? '+' : ''
  return `${sign}${percentage}% from last month`
}

const formatNewArtistsChange = (current: number | undefined, last: number | undefined): string => {
  if (current === undefined || last === undefined) return 'No data'
  const diff = current - last
  const sign = diff >= 0 ? '+' : ''
  return `${sign}${diff} compared to last month`
}

const formatGrowthValue = (percentage: number | undefined): string => {
  if (percentage === undefined) return '0%'
  const sign = percentage >= 0 ? '+' : ''
  return `${sign}${percentage}%`
}

const formatGrowthStatus = (status: string | undefined, percentage: number | undefined): string => {
  if (!status || percentage === undefined) return 'No data'
  const action = status === 'increase' ? 'Up' : 'Down'
  return `${action} ${Math.abs(percentage)}% compared to the previous month`
}

const getChangeClass = (value: number | undefined): string => {
  if (value === undefined) return ''
  return value >= 0 ? 'positive' : 'negative'
}

// ─── Lifecycle ───────────────────────────────────────────────────────────────

onMounted(async () => {
  await store.fetchArtists()
  await store.fetchShowStatistic()
})
</script>

<style scoped>
/* Base Styles */
.dashboard-container {
    height: 82vh;
    width: 100%;
    border-radius: 14px;
    margin-top: 7px;
    display: block;
    background: rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    display: flex;
    flex-direction: column;
    padding: 25px;
    position: relative;
    color: white;
    overflow-y: auto;
}

/* Header Section */
.header-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.title-container h1 {
    font-size: 26px;
    font-weight: 700;
    margin: 0;
    background: linear-gradient(90deg, #fff 30%, #00aaff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.subtitle {
    font-size: 14px;
    color: rgba(255, 255, 255, 0.7);
    margin-top: 5px;
    margin-bottom: 0;
}

.btn-add-user {
    background: linear-gradient(135deg, #00aaff, #0088cc);
    border: none;
    color: white;
    padding: 10px 20px;
    border-radius: 8px;
    font-weight: 500;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 8px;
    transition: all 0.3s ease;
}

.btn-add-user:hover {
    background: linear-gradient(135deg, #0088cc, #006699);
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(0, 170, 255, 0.4);
}

.btn-icon {
    display: flex;
    align-items: center;
    justify-content: center;
}

.btn-icon svg {
    width: 18px;
    height: 18px;
}

/* Main Content Layout */
.main-content {
    display: grid;
    grid-template-columns: 1fr;
    gap: 25px;
    flex: 1;
}

/* Statistics Section */
.statistics-section {
    display: flex;
    flex-direction: column;
    gap: 25px;
}

/* Chart Container */
.chart-container {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    padding: 20px;
    border: 1px solid rgba(255, 255, 255, 0.1);
}

.section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.section-header h2 {
    font-size: 18px;
    font-weight: 600;
    color: #fff;
    margin: 0;
}

.chart-filter {
    display: flex;
    align-items: center;
    gap: 10px;
}

.period-select {
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.2);
    color: white;
    padding: 6px 12px;
    border-radius: 6px;
    font-size: 14px;
    cursor: pointer;
}

.period-select option {
    background: #1a1a2e;
    color: white;
}

/* Chart Placeholder */


.chart-center {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    width: 120px;
    height: 120px;
    border-radius: 50%;
    background: rgba(0, 0, 0, 0.7);
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    color: white;
    font-size: 12px;
}

.center-value {
    font-size: 20px;
    font-weight: bold;
    color: #00aaff;
    margin-top: 5px;
}

.chart-legend {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.legend-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 8px 12px;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 6px;
    transition: all 0.3s ease;
}

.legend-item:hover {
    background: rgba(255, 255, 255, 0.1);
    transform: translateX(5px);
}

.legend-color {
    width: 16px;
    height: 16px;
    border-radius: 4px;
    flex-shrink: 0;
}

.legend-label {
    font-size: 14px;
    color: rgba(255, 255, 255, 0.9);
}

/* Stats Cards */
.stats-cards {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    padding: 20px;
    border: 1px solid rgba(255, 255, 255, 0.1);
}

.stats-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.stats-header h2 {
    font-size: 18px;
    font-weight: 600;
    color: #fff;
    margin: 0;
}

.stats-update {
    font-size: 12px;
    color: rgba(255, 255, 255, 0.6);
}

.stats-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 15px;
}

.stat-card {
    background: rgba(255, 255, 255, 0.03);
    border-radius: 10px;
    padding: 15px;
    display: flex;
    align-items: center;
    gap: 15px;
    transition: all 0.3s ease;
    border: 1px solid rgba(255, 255, 255, 0.05);
}

.stat-card:hover {
    background: rgba(255, 255, 255, 0.07);
    border-color: rgba(0, 170, 255, 0.3);
    transform: translateY(-2px);
}

.stat-icon {
    width: 50px;
    height: 50px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
}

.stat-icon svg {
    width: 24px;
    height: 24px;
    stroke-width: 2;
}

.total-artists {
    background: linear-gradient(135deg, #00aaff22, #00aaff55);
    color: #00aaff;
}

.featured-artists {
    background: linear-gradient(135deg, #00ffaa22, #00ffaa55);
    color: #00ffaa;
}

.total-plays {
    background: linear-gradient(135deg, #ff6b6b22, #ff6b6b55);
    color: #ff6b6b;
}

.total-followers {
    background: linear-gradient(135deg, #aa00ff22, #aa00ff55);
    color: #aa00ff;
}

.stat-info h3 {
    font-size: 14px;
    color: rgba(255, 255, 255, 0.7);
    margin: 0 0 5px 0;
    font-weight: 500;
}

.stat-value {
    font-size: 22px;
    font-weight: 700;
    color: #fff;
    margin: 0 0 3px 0;
}

.stat-change {
    font-size: 12px;
    margin: 0;
}

.stat-change.positive {
    color: #00ffaa;
}

.negative {
    color: red; 
}

/* Ranking Section */
.ranking-section {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    padding: 20px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    display: flex;
    flex-direction: column;
}

.ranking-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.ranking-header h2 {
    font-size: 18px;
    font-weight: 600;
    color: #fff;
    margin: 0;
}

.btn-view-all {
    background: transparent;
    border: 1px solid rgba(0, 170, 255, 0.5);
    color: #00aaff;
    padding: 8px 16px;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 14px;
}

.btn-view-all:hover {
    background: rgba(255, 255, 255, 0.1);
    border-color: rgba(0, 170, 255, 0.5);
}

.btn-view-all svg {
    width: 16px;
    height: 16px;
}

/* Ranking Table */
.ranking-table {
    flex: 1;
    overflow-y: auto;
}

.table-header {
    display: grid;
    grid-template-columns: 60px 2fr 1fr 1fr 60px;
    padding: 12px 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    font-size: 12px;
    color: rgba(255, 255, 255, 0.6);
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.table-body {
    display: flex;
    flex-direction: column;
}

.table-row {
    display: grid;
    grid-template-columns: 60px 2fr 1fr 1fr 60px;
    padding: 15px 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
    cursor: pointer;
    transition: all 0.3s ease;
    align-items: center;
}

.table-row:hover {
    background: rgba(255, 255, 255, 0.03);
    border-radius: 8px;
    padding-left: 10px;
    padding-right: 10px;
}

.rank-col {
    text-align: center;
}

.rank-number {
    display: inline-block;
    width: 30px;
    height: 30px;
    line-height: 30px;
    border-radius: 50%;
    font-weight: 700;
    font-size: 14px;
    background: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.7);
}

.rank-1 {
    background: linear-gradient(135deg, #ffd700, #ffaa00);
    color: #000;
}

.rank-2 {
    background: linear-gradient(135deg, #c0c0c0, #a0a0a0);
    color: #000;
}

.rank-3 {
    background: linear-gradient(135deg, #cd7f32, #a0522d);
    color: #000;
}

.artist-col {
    display: flex;
    align-items: center;
    gap: 12px;
}

.artist-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    overflow: hidden;
    flex-shrink: 0;
    background: rgba(255, 255, 255, 0.05);
}

.avatar-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
}

.avatar-placeholder {
    width: 100%;
    height: 100%;
    background: linear-gradient(135deg, #00aaff, #0088cc);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-weight: 700;
    font-size: 16px;
}

.artist-details h4 {
    font-size: 15px;
    font-weight: 600;
    color: #fff;
    margin: 0 0 4px 0;
}

.artist-category {
    font-size: 12px;
    color: rgba(255, 255, 255, 0.6);
    margin: 0;
}

.plays-col, .followers-col {
    font-size: 14px;
    font-weight: 600;
    color: #fff;
}

.trend-col {
    text-align: center;
}

.trend-indicator {
    font-size: 18px;
    font-weight: bold;
}

.trend-up {
    color: #00ffaa;
}

.trend-down {
    color: #ff6b6b;
}

.trend-neutral {
    color: #aaa;
}

/* Ranking Footer */
.ranking-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 20px;
    padding-top: 15px;
    border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.pagination-info {
    font-size: 12px;
    color: rgba(255, 255, 255, 0.6);
}

.view-more {
    font-size: 14px;
    color: #00aaff;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 5px;
}

.view-more:hover {
    color: #00ffaa;
    gap: 8px;
}

.empty-state {
    grid-column: 1 / -1;
    text-align: center;
    padding: 40px 20px;
    color: rgba(255, 255, 255, 0.5);
    font-size: 14px;
}

/* Scrollbar Styling */
.dashboard-container::-webkit-scrollbar,
.ranking-table::-webkit-scrollbar {
    width: 6px;
}

.dashboard-container::-webkit-scrollbar-thumb,
.ranking-table::-webkit-scrollbar-thumb {
    background: rgba(0, 170, 255, 0.6);
    border-radius: 3px;
}

.dashboard-container::-webkit-scrollbar-track,
.ranking-table::-webkit-scrollbar-track {
    background: transparent;
}

/* Responsive Design */
@media (max-width: 1200px) {
    .main-content {
        grid-template-columns: 1fr;
    }
    
    .ranking-section {
        min-height: 500px;
    }
}

@media (max-width: 768px) {
    .dashboard-container {
        padding: 15px;
        height: auto;
        min-height: 82vh;
    }
    
    .header-section {
        flex-direction: column;
        align-items: flex-start;
        gap: 15px;
    }
    
    .stats-grid {
        grid-template-columns: 1fr;
    }
    
    .chart-placeholder {
        flex-direction: column;
    }
    
    .table-header,
    .table-row {
        grid-template-columns: 50px 2fr 1fr 1fr 40px;
    }
    
    .ranking-footer {
        flex-direction: column;
        gap: 10px;
        text-align: center;
    }
}

@media (max-width: 480px) {
    .dashboard-container {
        padding: 12px;
    }
    
    .title-container h1 {
        font-size: 24px;
    }
    
    .btn-add-user {
        width: 100%;
        justify-content: center;
    }
    
    .chart-container,
    .stats-cards,
    .ranking-section {
        padding: 15px;
    }
    
    .table-header,
    .table-row {
        grid-template-columns: 40px 2fr 1fr 40px;
    }
    
    .followers-col {
        display: none;
    }
    
    .pie-chart {
        width: 180px;
        height: 180px;
    }
    
    .chart-center {
        width: 100px;
        height: 100px;
    }
}
</style>
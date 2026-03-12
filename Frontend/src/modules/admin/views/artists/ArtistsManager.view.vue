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
                        <div class="stat-card">
                            <div class="stat-icon total-artists">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
                                </svg>
                            </div>
                            <div class="stat-info">
                                <h3>Total Artists</h3>
                                <p class="stat-value">156</p>
                                <p class="stat-change positive">+12% from last month</p>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon featured-artists">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M11.48 3.499a.562.562 0 011.04 0l2.125 5.111a.563.563 0 00.475.345l5.518.442c.499.04.701.663.321.988l-4.204 3.602a.563.563 0 00-.182.557l1.285 5.385a.562.562 0 01-.84.61l-4.725-2.885a.563.563 0 00-.586 0L6.982 20.54a.562.562 0 01-.84-.61l1.285-5.386a.562.562 0 00-.182-.557l-4.204-3.602a.563.563 0 01.321-.988l5.518-.442a.563.563 0 00.475-.345L11.48 3.5z" />
                                </svg>
                            </div>
                            <div class="stat-info">
                                <h3>Featured Artists</h3>
                                <p class="stat-value">24</p>
                                <p class="stat-change">15% of total</p>
                            </div>
                        </div>
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
                        <!-- Top 1 -->
                        <div class="table-row">
                            <div class="rank-col">
                                <span class="rank-number rank-1">1</span>
                            </div>
                            <div class="artist-col">
                                <div class="artist-info">
                                    <div class="artist-avatar">
                                        <div class="avatar-placeholder">S</div>
                                    </div>
                                    <div class="artist-details">
                                        <h4>Sơn Tùng M-TP</h4>
                                        <p class="artist-category">Superstar</p>
                                    </div>
                                </div>
                            </div>
                            <div class="plays-col">
                                <span class="stat-value">985M</span>
                            </div>
                            <div class="followers-col">
                                <span class="stat-value">12.5M</span>
                            </div>
                            <div class="trend-col">
                                <span class="trend-indicator trend-up">↗</span>
                            </div>
                        </div>

                        <!-- Top 2 -->
                        <div class="table-row">
                            <div class="rank-col">
                                <span class="rank-number rank-2">2</span>
                            </div>
                            <div class="artist-col">
                                <div class="artist-info">
                                    <div class="artist-avatar">
                                        <div class="avatar-placeholder">Đ</div>
                                    </div>
                                    <div class="artist-details">
                                        <h4>Đen Vâu</h4>
                                        <p class="artist-category">Superstar</p>
                                    </div>
                                </div>
                            </div>
                            <div class="plays-col">
                                <span class="stat-value">750M</span>
                            </div>
                            <div class="followers-col">
                                <span class="stat-value">8.5M</span>
                            </div>
                            <div class="trend-col">
                                <span class="trend-indicator trend-up">↗</span>
                            </div>
                        </div>

                        <!-- Top 3 -->
                        <div class="table-row">
                            <div class="rank-col">
                                <span class="rank-number rank-3">3</span>
                            </div>
                            <div class="artist-col">
                                <div class="artist-info">
                                    <div class="artist-avatar">
                                        <div class="avatar-placeholder">M</div>
                                    </div>
                                    <div class="artist-details">
                                        <h4>Mỹ Tâm</h4>
                                        <p class="artist-category">Superstar</p>
                                    </div>
                                </div>
                            </div>
                            <div class="plays-col">
                                <span class="stat-value">890M</span>
                            </div>
                            <div class="followers-col">
                                <span class="stat-value">9.5M</span>
                            </div>
                            <div class="trend-col">
                                <span class="trend-indicator trend-neutral">→</span>
                            </div>
                        </div>

                        <!-- Top 4 -->
                        <div class="table-row">
                            <div class="rank-col">
                                <span class="rank-number">4</span>
                            </div>
                            <div class="artist-col">
                                <div class="artist-info">
                                    <div class="artist-avatar">
                                        <div class="avatar-placeholder">H</div>
                                    </div>
                                    <div class="artist-details">
                                        <h4>Hòa Minzy</h4>
                                        <p class="artist-category">Popular</p>
                                    </div>
                                </div>
                            </div>
                            <div class="plays-col">
                                <span class="stat-value">680M</span>
                            </div>
                            <div class="followers-col">
                                <span class="stat-value">7.2M</span>
                            </div>
                            <div class="trend-col">
                                <span class="trend-indicator trend-up">↗</span>
                            </div>
                        </div>

                        <!-- Top 5 -->
                        <div class="table-row">
                            <div class="rank-col">
                                <span class="rank-number">5</span>
                            </div>
                            <div class="artist-col">
                                <div class="artist-info">
                                    <div class="artist-avatar">
                                        <div class="avatar-placeholder">B</div>
                                    </div>
                                    <div class="artist-details">
                                        <h4>Bích Phương</h4>
                                        <p class="artist-category">Popular</p>
                                    </div>
                                </div>
                            </div>
                            <div class="plays-col">
                                <span class="stat-value">520M</span>
                            </div>
                            <div class="followers-col">
                                <span class="stat-value">5.8M</span>
                            </div>
                            <div class="trend-col">
                                <span class="trend-indicator trend-up">↗</span>
                            </div>
                        </div>

                        <!-- Top 6 -->
                        <div class="table-row">
                            <div class="rank-col">
                                <span class="rank-number">6</span>
                            </div>
                            <div class="artist-col">
                                <div class="artist-info">
                                    <div class="artist-avatar">
                                        <div class="avatar-placeholder">Đ</div>
                                    </div>
                                    <div class="artist-details">
                                        <h4>Đức Phúc</h4>
                                        <p class="artist-category">Rising</p>
                                    </div>
                                </div>
                            </div>
                            <div class="plays-col">
                                <span class="stat-value">275M</span>
                            </div>
                            <div class="followers-col">
                                <span class="stat-value">3.1M</span>
                            </div>
                            <div class="trend-col">
                                <span class="trend-indicator trend-up">↗</span>
                            </div>
                        </div>

                        <!-- Top 7 -->
                        <div class="table-row">
                            <div class="rank-col">
                                <span class="rank-number">7</span>
                            </div>
                            <div class="artist-col">
                                <div class="artist-info">
                                    <div class="artist-avatar">
                                        <div class="avatar-placeholder">A</div>
                                    </div>
                                    <div class="artist-details">
                                        <h4>AMEE</h4>
                                        <p class="artist-category">Rising</p>
                                    </div>
                                </div>
                            </div>
                            <div class="plays-col">
                                <span class="stat-value">420M</span>
                            </div>
                            <div class="followers-col">
                                <span class="stat-value">4.8M</span>
                            </div>
                            <div class="trend-col">
                                <span class="trend-indicator trend-up">↗</span>
                            </div>
                        </div>

                        <!-- Top 8 -->
                        <div class="table-row">
                            <div class="rank-col">
                                <span class="rank-number">8</span>
                            </div>
                            <div class="artist-col">
                                <div class="artist-info">
                                    <div class="artist-avatar">
                                        <div class="avatar-placeholder">T</div>
                                    </div>
                                    <div class="artist-details">
                                        <h4>Trúc Nhân</h4>
                                        <p class="artist-category">Rising</p>
                                    </div>
                                </div>
                            </div>
                            <div class="plays-col">
                                <span class="stat-value">285M</span>
                            </div>
                            <div class="followers-col">
                                <span class="stat-value">3.2M</span>
                            </div>
                            <div class="trend-col">
                                <span class="trend-indicator trend-neutral">→</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="ranking-footer">
                    <div class="pagination-info">
                        Showing 8 of 156 artists
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import VueApexCharts from "vue3-apexcharts"
import type { ApexOptions } from "apexcharts"
import { ref } from "vue"
import router from '@/modules/router';


const ApexChart = VueApexCharts

const series = ref([
  {
    name: "Servings",
    data: [44, 55, 41, 67, 22, 43, 21, 33, 45, 31, 87, 65, 35],
  },
])

const chartOptions: ApexOptions = {
  chart: {
    type: "bar",
    height: 350,
  },
  annotations: {
    points: [
      {
        x: "Bananas",
        seriesIndex: 0,
        label: {
          borderColor: "#775DD0",
          offsetY: 0,
          style: {
            color: "#000",
            background: "#775DD0",
          },
          text: "Bananas are good",
        },
      },
    ],
  },
  plotOptions: {
    bar: {
      borderRadius: 10,
      columnWidth: "50%",
    },
  },
  dataLabels: {
    enabled: false,
  },
  stroke: {
    width: 0,
  },
  grid: {
    row: {
    //   colors: ["#fff", "#f2f2f2"],
    },
  },
  xaxis: {
    categories: [
      "Apples","Oranges","Strawberries","Pineapples","Mangoes","Bananas",
      "Blackberries","Pears","Watermelons","Cherries","Pomegranates","Tangerines","Papayas"
    ],
    labels: {
        rotate: -45,
        style: {
            colors: "#fff", 
            fontSize: "12px",
            fontWeight: 500
        }
    },
    tickPlacement: "on",
  },
  yaxis: {
    title: {
      text: "Servings",
       
    },
  },
}

const ViewAllArtists =()=>{
    router.push({name:"admin.artistsmanager.all"});
}

const CreateArtist =()=>{
    router.push({name:"admin.artistsmanager.add"});
}
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
    font-family: 'Afacad', sans-serif;
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
    font-size: 28px;
    font-weight: 600;
    margin: 0;
    background: linear-gradient(90deg, #00aaff, #00ffaa);
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
    font-family: 'Afacad', sans-serif;
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
    font-family: 'Afacad', sans-serif;
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
    grid-template-columns: repeat(2, 1fr);
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
    font-family: 'Afacad', sans-serif;
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
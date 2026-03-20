<template>
  <div class="songs-management">
    <!-- Header -->
    <div class="header">
      <div class="header-left">
        <h1 class="title">Songs Management</h1>
        <p class="subtitle">Manage All Music Tracks</p>
      </div>
      <div class="header-right">
        <button class="btn-add" @click="ViewAddSong">
          <span class="btn-icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <circle cx="12" cy="12" r="10"/>
              <line x1="12" y1="8" x2="12" y2="16"/>
              <line x1="8" y1="12" x2="16" y2="12"/>
            </svg>
          </span>
          Add New Song
        </button>
        <div class="search-box">
          <input type="text" placeholder="Search songs..." v-model="searchQuery" />
          <svg class="search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="11" cy="11" r="8"/>
            <line x1="21" y1="21" x2="16.65" y2="16.65"/>
          </svg>
        </div>
      </div>
    </div>

    <!-- Stat Cards -->
    <div class="stats-grid">
      <div class="stat-card stat-card--blue">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M9 18V5l12-2v13"/>
            <circle cx="6" cy="18" r="3"/>
            <circle cx="18" cy="16" r="3"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Total Songs</span>
          <span class="stat-value">{{ stats.total }}</span>
          <span class="stat-change positive">↑ 18% from last month</span>
        </div>
      </div>

      <div class="stat-card stat-card--green">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <polygon points="5 3 19 12 5 21 5 3"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Published</span>
          <span class="stat-value">{{ stats.published }}</span>
          <span class="stat-change positive">↑ 12% from last month</span>
        </div>
      </div>

      <div class="stat-card stat-card--purple">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M3 18v-6a9 9 0 0 1 18 0v6"/>
            <path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3z"/>
            <path d="M3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Premium</span>
          <span class="stat-value">{{ stats.premium }}</span>
          <span class="stat-change positive">↑ 5% from last month</span>
        </div>
      </div>

      <div class="stat-card stat-card--orange">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Top Liked</span>
          <span class="stat-value">{{ stats.liked }}</span>
          <span class="stat-change positive">↑ 30% from last month</span>
        </div>
      </div>
    </div>

    <!-- Table Section -->
    <div class="table-section">
      <div class="table-header">
        <h2 class="table-title">Recent Songs</h2>
        <div class="table-controls">
          <select class="filter-select" v-model="selectedGenre">
            <option value="">All Genres</option>
            <option value="pop">Pop</option>
            <option value="rock">Rock</option>
            <option value="jazz">Jazz</option>
            <option value="hiphop">Hip-Hop</option>
            <option value="classical">Classical</option>
          </select>
          <button class="btn-view-all" @click="ViewAllSongs">
            View All
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="5" y1="12" x2="19" y2="12"/>
              <polyline points="12 5 19 12 12 19"/>
            </svg>
          </button>
        </div>
      </div>

      <div class="table-wrapper">
        <table class="songs-table">
          <thead>
            <tr>
              <th>Song</th>
              <th>Artist</th>
              <th>Genre</th>
              <th>Duration</th>
              <th>Plays</th>
              <th>Status</th>
              <th>Upload Date</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="song in filteredSongs" :key="song.id" class="table-row">
              <td>
                <div class="song-info">
                  <div class="song-cover" :style="{ background: song.coverGradient }">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="white">
                      <path d="M9 18V5l12-2v13"/>
                      <circle cx="6" cy="18" r="3"/>
                      <circle cx="18" cy="16" r="3"/>
                    </svg>
                  </div>
                  <div>
                    <p class="song-title">{{ song.title }}</p>
                    <p class="song-id">ID: {{ song.id }}</p>
                  </div>
                </div>
              </td>
              <td class="td-artist">{{ song.artist }}</td>
              <td>
                <span class="genre-badge">{{ song.genre }}</span>
              </td>
              <td class="td-duration">{{ song.duration }}</td>
              <td class="td-plays">
                <div class="plays-bar">
                  <div class="plays-bar-fill" :style="{ width: song.playsPercent + '%' }"></div>
                </div>
                <span class="plays-count">{{ song.plays }}</span>
              </td>
              <td>
                <span class="status-badge" :class="'status--' + song.status">{{ song.status }}</span>
              </td>
              <td class="td-date">{{ song.uploadDate }}</td>
              <td>
                <div class="action-buttons">
                  <button class="action-btn action-btn--edit" title="Edit">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                      <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                    </svg>
                  </button>
                  <button class="action-btn action-btn--delete" title="Delete">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <polyline points="3 6 5 6 21 6"/>
                      <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                    </svg>
                  </button>
                  <button class="action-btn action-btn--view" title="Preview">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <div class="pagination">
        <span class="pagination-info">Showing 1–{{ filteredSongs.length }} of {{ stats.total }} songs</span>
        <div class="pagination-controls">
          <button class="page-btn" disabled>
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <polyline points="15 18 9 12 15 6"/>
            </svg>
          </button>
          <button class="page-btn active">1</button>
          <button class="page-btn">2</button>
          <button class="page-btn">3</button>
          <button class="page-btn">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <polyline points="9 18 15 12 9 6"/>
            </svg>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import router from '@/modules/router';

const searchQuery = ref('')
const selectedGenre = ref('')

const stats = ref({
  total: 248,
  published: 195,
  premium: 43,
  liked: 1200,
})

const songs = ref([
  {
    id: 101,
    title: 'Midnight Dreams',
    artist: 'Lana Reverie',
    genre: 'Pop',
    duration: '3:42',
    plays: '128K',
    playsPercent: 85,
    status: 'published',
    uploadDate: '16/3/2026',
    coverGradient: 'linear-gradient(135deg, #00c6ff, #0072ff)',
  },
  {
    id: 102,
    title: 'Neon Pulse',
    artist: 'DJ Axon',
    genre: 'Hip-Hop',
    duration: '4:10',
    plays: '95K',
    playsPercent: 63,
    status: 'published',
    uploadDate: '14/3/2026',
    coverGradient: 'linear-gradient(135deg, #f093fb, #f5576c)',
  },
  {
    id: 103,
    title: 'Ocean Floor',
    artist: 'Aria Winds',
    genre: 'Jazz',
    duration: '5:28',
    plays: '47K',
    playsPercent: 31,
    status: 'pending',
    uploadDate: '10/3/2026',
    coverGradient: 'linear-gradient(135deg, #43e97b, #38f9d7)',
  },
  {
    id: 104,
    title: 'Golden Hour',
    artist: 'The Solars',
    genre: 'Rock',
    duration: '3:55',
    plays: '210K',
    playsPercent: 100,
    status: 'published',
    uploadDate: '8/3/2026',
    coverGradient: 'linear-gradient(135deg, #f7971e, #ffd200)',
  },
  {
    id: 105,
    title: 'Velvet Storm',
    artist: 'Kairo Black',
    genre: 'Classical',
    duration: '6:14',
    plays: '22K',
    playsPercent: 15,
    status: 'draft',
    uploadDate: '4/3/2026',
    coverGradient: 'linear-gradient(135deg, #a18cd1, #fbc2eb)',
  },
  {
    id: 106,
    title: 'Starfall',
    artist: 'Nova Echo',
    genre: 'Pop',
    duration: '3:20',
    plays: '74K',
    playsPercent: 49,
    status: 'published',
    uploadDate: '1/3/2026',
    coverGradient: 'linear-gradient(135deg, #30cfd0, #330867)',
  },
])

const filteredSongs = computed(() => {
  return songs.value.filter((song) => {
    const matchSearch =
      song.title.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      song.artist.toLowerCase().includes(searchQuery.value.toLowerCase())
    const matchGenre =
      selectedGenre.value === '' ||
      song.genre.toLowerCase() === selectedGenre.value.toLowerCase()
    return matchSearch && matchGenre
  })
})

const ViewAllSongs = () => {
    router.push({ name: "admin.songsmanager.all" });
}

const ViewAddSong = () => {
    router.push({ name: "admin.songsmanager.add" });
}
</script>

<style scoped>
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

.songs-management {
  background-color: #1b2325;
  min-height: 100vh;
  padding: 32px 36px;
  font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
  color: #e2e8f0;
}

/* ── Header ── */
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 32px;
}

.title {
  font-size: 28px;
  font-weight: 700;
  background: linear-gradient(90deg, #00d2ff, #7b2ff7);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.subtitle {
  font-size: 13px;
  color: #64748b;
  margin-top: 4px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.btn-add {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  background: linear-gradient(90deg, #00c6ff, #0072ff);
  border: none;
  border-radius: 10px;
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: opacity 0.2s;
}

.btn-add:hover {
  opacity: 0.85;
}

.btn-icon {
  display: flex;
  align-items: center;
}

.search-box {
  position: relative;
  display: flex;
  align-items: center;
}

.search-box input {
  background: #1a1f2e;
  border: 1px solid #2d3748;
  border-radius: 10px;
  padding: 10px 42px 10px 16px;
  color: #e2e8f0;
  font-size: 14px;
  width: 220px;
  outline: none;
  transition: border-color 0.2s;
}

.search-box input::placeholder {
  color: #4a5568;
}

.search-box input:focus {
  border-color: #0072ff;
}

.search-icon {
  position: absolute;
  right: 14px;
  color: #4a5568;
  pointer-events: none;
}

/* ── Stat Cards ── */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 18px;
  margin-bottom: 28px;
}

.stat-card {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 14px;
  padding: 22px 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  border-top: 3px solid transparent;
  position: relative;
  overflow: hidden;
}

.stat-card--blue  { border-top-color: #00c6ff; }
.stat-card--green { border-top-color: #43e97b; }
.stat-card--purple{ border-top-color: #a78bfa; }
.stat-card--orange{ border-top-color: #f59e0b; }

.stat-icon {
  width: 52px;
  height: 52px;
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  color: #94a3b8;
}

.stat-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.stat-label {
  font-size: 12px;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #f1f5f9;
  line-height: 1.1;
}

.stat-change {
  font-size: 12px;
  color: #64748b;
}

.stat-change.positive {
  color: #43e97b;
}

/* ── Table Section ── */
.table-section {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 16px;
  padding: 24px;
}

.table-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}

.table-title {
  font-size: 18px;
  font-weight: 600;
  color: #f1f5f9;
}

.table-controls {
  display: flex;
  align-items: center;
  gap: 12px;
}

.filter-select {
  background: #1e2535;
  border: 1px solid #2d3748;
  border-radius: 8px;
  padding: 8px 14px;
  color: #94a3b8;
  font-size: 13px;
  outline: none;
  cursor: pointer;
}

.btn-view-all {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  background: transparent;
  border: 1px solid #00c6ff;
  border-radius: 8px;
  color: #00c6ff;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: background 0.2s;
}

.btn-view-all:hover {
  background: rgba(0, 198, 255, 0.08);
}

/* ── Table ── */
.table-wrapper {
  overflow-x: auto;
}

.songs-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

.songs-table thead tr {
  background: #1e3a4a;
}

.songs-table thead th {
  padding: 14px 16px;
  text-align: left;
  font-size: 13px;
  font-weight: 600;
  color: #94a3b8;
  white-space: nowrap;
}

.songs-table thead th:first-child {
  border-radius: 8px 0 0 8px;
}

.songs-table thead th:last-child {
  border-radius: 0 8px 8px 0;
}

.table-row {
  border-bottom: 1px solid #1e2535;
  transition: background 0.15s;
}

.table-row:hover {
  background: rgba(255, 255, 255, 0.025);
}

.songs-table td {
  padding: 14px 16px;
  vertical-align: middle;
}

/* Song cell */
.song-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.song-cover {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.song-title {
  font-size: 14px;
  font-weight: 600;
  color: #f1f5f9;
}

.song-id {
  font-size: 12px;
  color: #4a5568;
  margin-top: 2px;
}

.td-artist {
  color: #94a3b8;
}

.td-duration,
.td-date {
  color: #64748b;
  white-space: nowrap;
}

/* Genre badge */
.genre-badge {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 500;
  background: #1e2535;
  color: #94a3b8;
  border: 1px solid #2d3748;
}

/* Plays bar */
.td-plays {
  display: flex;
  align-items: center;
  gap: 8px;
}

.plays-bar {
  width: 60px;
  height: 4px;
  background: #1e2535;
  border-radius: 2px;
  overflow: hidden;
}

.plays-bar-fill {
  height: 100%;
  background: linear-gradient(90deg, #00c6ff, #0072ff);
  border-radius: 2px;
}

.plays-count {
  font-size: 13px;
  color: #64748b;
  white-space: nowrap;
}

/* Status badges */
.status-badge {
  display: inline-block;
  padding: 4px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  text-transform: capitalize;
}

.status--published {
  background: rgba(67, 233, 123, 0.15);
  color: #43e97b;
}

.status--pending {
  background: rgba(245, 158, 11, 0.15);
  color: #f59e0b;
}

.status--draft {
  background: rgba(100, 116, 139, 0.15);
  color: #64748b;
}

/* Action buttons */
.action-buttons {
  display: flex;
  align-items: center;
  gap: 6px;
}

.action-btn {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  border: 1px solid #2d3748;
  background: #1e2535;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: border-color 0.2s, background 0.2s;
  color: #94a3b8;
}

.action-btn--edit:hover {
  border-color: #00c6ff;
  color: #00c6ff;
  background: rgba(0, 198, 255, 0.08);
}

.action-btn--delete:hover {
  border-color: #f87171;
  color: #f87171;
  background: rgba(248, 113, 113, 0.08);
}

.action-btn--view:hover {
  border-color: #43e97b;
  color: #43e97b;
  background: rgba(67, 233, 123, 0.08);
}

/* ── Pagination ── */
.pagination {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 20px;
  padding-top: 16px;
  border-top: 1px solid #1e2535;
}

.pagination-info {
  font-size: 13px;
  color: #4a5568;
}

.pagination-controls {
  display: flex;
  align-items: center;
  gap: 6px;
}

.page-btn {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  border: 1px solid #2d3748;
  background: #1e2535;
  color: #64748b;
  font-size: 13px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.2s, border-color 0.2s;
}

.page-btn:hover:not(:disabled) {
  border-color: #00c6ff;
  color: #00c6ff;
}

.page-btn.active {
  background: linear-gradient(90deg, #00c6ff, #0072ff);
  border-color: transparent;
  color: #fff;
  font-weight: 600;
}

.page-btn:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

/* ── Responsive ── */
@media (max-width: 1024px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 640px) {
  .songs-management {
    padding: 20px 16px;
  }

  .header {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
  }

  .stats-grid {
    grid-template-columns: 1fr 1fr;
  }
}
</style>
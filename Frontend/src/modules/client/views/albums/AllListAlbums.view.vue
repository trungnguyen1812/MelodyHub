<template>
  <div class="albums-shell">
    <!-- Background Blur Effect -->
    <div class="bg-blur-container">
      <div 
        v-if="latestAlbumCover" 
        class="banner-blur" 
        :style="{ backgroundImage: `url(${getFullImageUrl(latestAlbumCover)})` }"
      ></div>
      <div v-else class="banner-blur-placeholder"></div>
    </div>

    <div class="content-container">
      <!-- Navigation Header -->
      <div class="header-nav">
        <button class="back-nav-btn" @click="goBack">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="18" height="18">
            <path fill-rule="evenodd" d="M17 10a.75.75 0 0 1-.75.75H5.612l4.158 3.96a.75.75 0 1 1-1.04 1.08l-5.5-5.25a.75.75 0 0 1 0-1.08l5.5-5.25a.75.75 0 1 1 1.04 1.08L5.612 9.25H16.25A.75.75 0 0 1 17 10Z" clip-rule="evenodd" />
          </svg>
          Back
        </button>

        <div class="search-wrapper">
          <div class="search-box">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="18" height="18" class="search-icon">
              <path fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11ZM2 9a7 7 0 1 1 12.452 4.391l3.328 3.329a.75.75 0 1 1-1.06 1.06l-3.329-3.328A7 7 0 0 1 2 9Z" clip-rule="evenodd" />
            </svg>
            <input 
              v-model="searchQuery" 
              type="text" 
              placeholder="Search albums..." 
              class="search-input"
            />
          </div>
        </div>
      </div>

      <!-- Main Header -->
      <header class="section-header">
        <div class="header-main">
          <div class="type-pill">Library</div>
          <h1 class="page-title">
            <span class="gradient-text">All Albums</span>
            <span class="count-badge" v-if="filteredAlbums.length">{{ filteredAlbums.length }}</span>
          </h1>
          <p class="page-desc">Discover all albums available on MelodyHub.</p>
        </div>

        <div class="header-actions">
          <!-- Sort & View Toggles -->
          <div class="sort-wrap">
            <select v-model="sortBy" class="sort-select">
              <option value="default">Default</option>
              <option value="name_asc">Name A–Z</option>
              <option value="name_desc">Name Z–A</option>
              <option value="artist">By Artist</option>
            </select>
          </div>

          <div class="view-toggle">
            <button :class="{ active: viewMode === 'grid' }" @click="viewMode = 'grid'" title="Grid view">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
                <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
              </svg>
            </button>
            <button :class="{ active: viewMode === 'list' }" @click="viewMode = 'list'" title="List view">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                <rect x="3" y="4" width="18" height="3" rx="1"/><rect x="3" y="10.5" width="18" height="3" rx="1"/>
                <rect x="3" y="17" width="18" height="3" rx="1"/>
              </svg>
            </button>
            <button :class="{ active: showLikedAlbums }" @click="toggleLikedFilter" title="Liked albums">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
              </svg>
            </button>
          </div>
        </div>
      </header>

      <!-- Loading State -->
      <div v-if="isLoading" class="loading-grid">
        <div v-for="i in 12" :key="i" class="skeleton-card"></div>
      </div>

      <!-- Albums Grid/List -->
      <template v-else>
        <div v-if="filteredAlbums.length" class="albums-list-view">
          <!-- GRID VIEW -->
          <div v-if="viewMode === 'grid'" class="albums-grid">
            <div
              v-for="(album, idx) in filteredAlbums"
              :key="album.id"
              class="album-card"
              :style="{ '--delay': `${idx * 30}ms` }"
              @click="navigateToAlbum(album.slug)"
            >
              <div class="card-cover">
                <img
                  :src="getAlbumThumbnail(album)"
                  :alt="album.name"
                  class="cover-img"
                  @error="handleImageError"
                />
                <div class="cover-overlay"></div>
                <div class="card-badge">ALBUM</div>
                <button class="play-btn" @click.stop="playAlbum(album)" aria-label="Play album">
                  <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M8 5v14l11-7z" />
                  </svg>
                </button>
              </div>
              <div class="card-info">
                <p class="card-name" :title="album.name">{{ album.name }}</p>
                <p class="card-artist" :title="album.artist?.name">{{ album.artist?.name }}</p>
              </div>
            </div>
          </div>

          <!-- LIST VIEW -->
          <div v-else class="albums-list">
            <div class="list-header">
              <span class="col-rank">#</span>
              <span class="col-info">Album / Artist</span>
              <span class="col-tracks">Tracks</span>
              <span class="col-date">Release</span>
              <span class="col-actions"></span>
            </div>

            <div
              v-for="(album, idx) in filteredAlbums"
              :key="album.id"
              class="list-row"
              :style="{ '--delay': `${idx * 20}ms` }"
              @click="navigateToAlbum(album.slug)"
            >
              <span class="list-index">{{ idx + 1 }}</span>

              <div class="list-thumb">
                <img
                  :src="getAlbumThumbnail(album)"
                  :alt="album.name"
                  @error="handleImageError"
                />
                <button class="list-play" @click.stop="playAlbum(album)" aria-label="Play">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M8 5v14l11-7z" />
                  </svg>
                </button>
              </div>

              <div class="list-meta">
                <p class="list-name">{{ album.name }}</p>
                <p class="list-artist">{{ album.artist?.name }}</p>
              </div>

              <div class="list-tracks">{{ album.total_tracks || 0 }} songs</div>
              <div class="list-date">{{ formatDate(album.release_date) }}</div>

              <button class="list-action" @click.stop="playAlbum(album)">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M8 5v14l11-7z" />
                </svg>
              </button>
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-else class="empty-state">
          <div class="empty-icon">...</div>
          <h3>No albums found</h3>
          <p v-if="showLikedAlbums && !searchQuery">You haven't liked any albums yet.</p> 
          <p v-else-if="searchQuery">No results for <em>"{{ searchQuery }}"</em></p>
          <p v-else>There are no albums available at the moment.</p>
          <div style="display:flex; gap:8px; justify-content:center;">
          <button v-if="showLikedAlbums" class="reset-btn" @click="toggleLikedFilter">Show All</button> 
            <button v-if="searchQuery" class="reset-btn" @click="searchQuery = ''">Clear Search</button>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAlbumStore, getFullImageUrl } from '@/modules/client/stores/albums/albumssStore'
import { usePlayerStore } from '@/store/playerStore'
import type { AlbumInterface } from '@/interfaces/albums.interface'

const router = useRouter()
const albumStore = useAlbumStore()
const player = usePlayerStore()

const emit = defineEmits<{
  (e: 'playAlbum', album: AlbumInterface): void
}>()

// ── State ──────────────────────────────────────────────────────────────────
const searchQuery = ref('')
const sortBy = ref<'default' | 'name_asc' | 'name_desc' | 'artist'>('default')
const viewMode = ref<'grid' | 'list'>('grid')
const showLikedAlbums = ref(false)

// Toggle liked filter và refetch nếu cần
const toggleLikedFilter = async () => {
  showLikedAlbums.value = !showLikedAlbums.value
  // Luôn refetch để đảm bảo is_liked được tính với token hiện tại
  await albumStore.fetchAllAlbums()
}
// ── Computed ───────────────────────────────────────────────────────────────
const latestAlbumCover = computed(() => {
  if (albumStore.albums?.length > 0) {
    return albumStore.albums[0].cover_url
  }
  return null
})

const filteredAlbums = computed(() => {
  let list = [...(albumStore.albums ?? [])]

   if (showLikedAlbums.value) {
    list = list.filter(a => a.is_liked === true)
  }

  if (searchQuery.value.trim()) {
    const q = searchQuery.value.toLowerCase()
    list = list.filter(a =>
      a.name?.toLowerCase().includes(q) ||
      a.artist?.name?.toLowerCase().includes(q)
    )
  }

  switch (sortBy.value) {
    case 'name_asc':  list.sort((a, b) => a.name.localeCompare(b.name)); break
    case 'name_desc': list.sort((a, b) => b.name.localeCompare(a.name)); break
    case 'artist':    list.sort((a, b) => (a.artist?.name ?? '').localeCompare(b.artist?.name ?? '')); break
  }

  return list
})

const isLoading = computed(() => albumStore.loading)

// ── Helpers ────────────────────────────────────────────────────────────────
const getAlbumThumbnail = (album: AlbumInterface): string => {
  if (!album.cover_url) return '/default-album.jpg'
  return getFullImageUrl(album.cover_url)
}

const formatDate = (date: string | null) => {
  if (!date) return '—'
  return new Date(date).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
}

const handleImageError = (e: Event) => {
  (e.target as HTMLImageElement).src = '/default-album.jpg'
}

const navigateToAlbum = (slug: string) =>
  router.push({ name: 'client.album.detail', params: { slug } })

const goBack = () => router.back()

const playAlbum = (album: AlbumInterface) => emit('playAlbum', album)

// ─── Lifecycle ─────────────────────────────────────────────────────────────
onMounted(async () => {
  // Luôn refetch để is_liked được tính đúng với token hiện tại
  await albumStore.fetchAllAlbums()
})
</script>

<style scoped>
/* ─── Layout Shell ───────────────────────────────────────── */
.albums-shell {
  min-height: 100vh;
  color: #fff;
  position: relative;
  overflow-x: hidden;
  padding-bottom: 100px;
}

/* ─── Background blur ─────────────────────────────────────── */
.bg-blur-container {
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 550px;
  overflow: hidden;
  z-index: 0;
  mask-image: linear-gradient(to bottom, black 50%, transparent 100%);
}

.banner-blur {
  width: 100%; height: 100%;
  background-size: cover;
  background-position: center;
  filter: blur(100px) saturate(1.5) opacity(0.25);
  transform: scale(1.3);
}

.banner-blur-placeholder {
  width: 100%; height: 100%;
  background: radial-gradient(circle at 30% 30%, #1a2a4a 0%, #080e14 100%);
  filter: blur(80px);
}

/* ─── Content ─────────────────────────────────────────────── */
.content-container {
  position: relative;
  z-index: 1;
  max-width: 1280px;
  margin: 0 auto;
  padding: 40px 40px;
}

/* ─── Navigation Header ───────────────────────────────────── */
.header-nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 48px;
}

.back-nav-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.7);
  padding: 8px 18px;
  border-radius: 99px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.back-nav-btn:hover {
  background: rgba(255,255,255,0.1);
  color: #fff;
  transform: translateX(-3px);
}

.search-wrapper {
  position: relative;
}

.search-box {
  position: relative;
  width: 300px;
}

.search-icon {
  position: absolute;
  left: 14px;
  top: 50%;
  transform: translateY(-50%);
  color: rgba(255,255,255,0.3);
}

.search-input {
  width: 100%;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 12px;
  padding: 10px 14px 10px 42px;
  color: #fff;
  font-size: 13px;
  outline: none;
  transition: all 0.2s;
}

.search-input:focus {
  background: rgba(255,255,255,0.08);
  border-color: rgba(255,255,255,0.2);
  width: 360px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.2);
}

/* ─── Section Header ───────────────────────────────────────── */
.section-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  margin-bottom: 40px;
  flex-wrap: wrap;
  gap: 20px;
}

.header-main {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.type-pill {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  color: #00aaff;
}

.page-title {
  font-size: 64px;
  font-weight: 900;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 20px;
}

.gradient-text {
  background: linear-gradient(135deg, #fff 0%, rgba(255,255,255,0.5) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.count-badge {
  font-size: 18px;
  background: rgba(255,255,255,0.1);
  padding: 4px 14px;
  border-radius: 99px;
  color: rgba(255,255,255,0.5);
  font-weight: 700;
}

.page-desc {
  font-size: 16px;
  color: rgba(255,255,255,0.5);
  max-width: 600px;
  line-height: 1.6;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.sort-wrap {
  display: flex;
  align-items: center;
}

.sort-select {
  background: rgb(0, 0, 0);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 10px;
  color: #e5e7eb;
  font-size: 13px;
  padding: 10px 14px;
  outline: none;
  cursor: pointer;
}

.view-toggle {
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.04);
  border: 1px solid rgba(255, 255, 255, 0.07);
  border-radius: 10px;
  padding: 4px;
  gap: 2px;
}

.view-toggle button {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  background: transparent;
  border: none;
  color: #6b7280;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.15s;
}

.view-toggle button.active {
  background: rgba(0, 170, 255, 0.2);
  color: #00aaff;
}

/* ─── Loading ──────────────────────────────────────────────── */
.loading-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 20px;
}

.skeleton-card {
  background: rgba(255,255,255,0.03);
  border-radius: 16px;
  padding-top: 100%;
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 0.3; }
  50% { opacity: 0.6; }
}

/* ─── GRID VIEW ───────────────────────────────────────────── */
.albums-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 24px;
}

.album-card {
  cursor: pointer;
  animation: fadeUp 0.35s ease both;
  animation-delay: var(--delay, 0ms);
}

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.card-cover {
  position: relative;
  width: 100%;
  padding-top: 100%;
  border-radius: 16px;
  overflow: hidden;
  background: #1a1d26;
  box-shadow: 0 8px 24px rgba(0,0,0,0.3);
  transition: transform 0.3s ease;
}

.album-card:hover .card-cover {
  transform: translateY(-4px);
}

.cover-img {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.album-card:hover .cover-img {
  transform: scale(1.05);
}

.cover-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, transparent 50%, rgba(0,0,0,0.7) 100%);
  pointer-events: none;
}

.card-badge {
  position: absolute;
  top: 10px;
  left: 10px;
  background: rgba(0,0,0,0.6);
  backdrop-filter: blur(8px);
  color: #fff;
  font-size: 9px;
  font-weight: 700;
  letter-spacing: 0.1em;
  padding: 4px 10px;
  border-radius: 20px;
}

.play-btn {
  position: absolute;
  bottom: 12px;
  right: 12px;
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: #fff;
  border: none;
  color: #000;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  opacity: 0;
  transform: translateY(8px);
  transition: all 0.25s;
  box-shadow: 0 4px 12px rgba(0,0,0,0.3);
}

.album-card:hover .play-btn {
  opacity: 1;
  transform: translateY(0);
}

.play-btn:hover {
  background: #00aaff;
  color: #fff;
  transform: scale(1.05);
}

.card-info {
  padding: 12px 8px 8px;
}

.card-name {
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin: 0 0 6px;
}

.card-artist {
  font-size: 12px;
  color: rgba(255,255,255,0.5);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin: 0;
}

/* ─── LIST VIEW ───────────────────────────────────────────── */
.albums-list {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.list-header {
  display: grid;
  grid-template-columns: 48px 1fr 100px 120px 60px;
  padding: 12px 16px;
  border-bottom: 1px solid rgba(255,255,255,0.06);
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  color: rgba(255,255,255,0.3);
  letter-spacing: 0.1em;
}

.list-row {
  display: grid;
  grid-template-columns: 48px 1fr 100px 120px 60px;
  align-items: center;
  padding: 10px 16px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.2s;
  animation: fadeUp 0.3s ease both;
  animation-delay: var(--delay, 0ms);
}

.list-row:hover {
  background: rgba(255,255,255,0.05);
}

.list-index {
  color: rgba(255,255,255,0.3);
  font-size: 14px;
  font-family: monospace;
}

.list-thumb {
  position: relative;
  width: 48px;
  height: 48px;
  border-radius: 10px;
  overflow: hidden;
  flex-shrink: 0;
}

.list-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.list-play {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0,0,0,0.6);
  border: none;
  color: #fff;
  cursor: pointer;
  opacity: 0;
  transition: opacity 0.2s;
}

.list-row:hover .list-play {
  opacity: 1;
}

.list-meta {
  padding-left: 14px;
}

.list-name {
  font-weight: 600;
  font-size: 14px;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin: 0 0 4px;
}

.list-artist {
  font-size: 12px;
  color: rgba(255,255,255,0.5);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin: 0;
}

.list-tracks, .list-date {
  font-size: 13px;
  color: rgba(255,255,255,0.4);
}

.list-action {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.08);
  color: rgba(255,255,255,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  opacity: 0;
  transition: all 0.2s;
}

.list-row:hover .list-action {
  opacity: 1;
}

.list-action:hover {
  background: #00aaff;
  border-color: #00aaff;
  color: #fff;
}

/* ─── Empty State ─────────────────────────────────────────── */
.empty-state {
  text-align: center;
  padding: 80px 20px;
}

.empty-icon {
  width: 80px;
  height: 80px;
  margin: 0 auto 24px;
  color: rgba(255,255,255,0.2);
}

.empty-state h3 {
  font-size: 20px;
  margin-bottom: 8px;
}

.empty-state p {
  color: rgba(255,255,255,0.4);
  margin-bottom: 24px;
}

.reset-btn {
  background: rgba(255,255,255,0.1);
  border: none;
  padding: 10px 24px;
  border-radius: 30px;
  color: #fff;
  cursor: pointer;
  transition: background 0.2s;
}

.reset-btn:hover {
  background: rgba(255,255,255,0.15);
}

/* ─── Responsive ───────────────────────────────────────────── */
@media (max-width: 768px) {
  .content-container { padding: 20px; }
  .page-title { font-size: 40px; }
  .search-box { width: 200px; }
  .search-input:focus { width: 240px; }
  .list-header, .list-row { grid-template-columns: 40px 1fr 0 0 50px; }
  .list-tracks, .list-date { display: none; }
  .albums-grid { grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 16px; }
  .header-actions { width: 100%; justify-content: flex-start; }
}

@media (max-width: 480px) {
  .albums-grid { grid-template-columns: repeat(2, 1fr); }
}
.view-toggle button.active:last-child {
  background: rgba(239, 68, 68, 0.2);
  color: #ef4444;
}
</style>
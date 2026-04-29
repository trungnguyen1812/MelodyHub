<template>
  <div class="albums-shell">
    <div class="bg-blur-container">
      <div v-if="latestCover" class="banner-blur" :style="{ backgroundImage: `url(${latestCover})` }"></div>
      <div v-else class="banner-blur-placeholder"></div>
    </div>

    <div class="content-container">
      <!-- Nav -->
      <div class="header-nav">
        <button class="back-nav-btn" @click="goBack">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="18" height="18">
            <path fill-rule="evenodd" d="M17 10a.75.75 0 0 1-.75.75H5.612l4.158 3.96a.75.75 0 1 1-1.04 1.08l-5.5-5.25a.75.75 0 0 1 0-1.08l5.5-5.25a.75.75 0 1 1 1.04 1.08L5.612 9.25H16.25A.75.75 0 0 1 17 10Z" clip-rule="evenodd" />
          </svg>
          Back
        </button>
        <div class="search-wrapper">
          <div class="search-box">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16" class="search-icon">
              <path fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11ZM2 9a7 7 0 1 1 12.452 4.391l3.328 3.329a.75.75 0 1 1-1.06 1.06l-3.329-3.328A7 7 0 0 1 2 9Z" clip-rule="evenodd" />
            </svg>
            <input v-model="searchQuery" type="text" placeholder="Search playlists..." class="search-input" />
          </div>
        </div>
      </div>

      <!-- Header -->
      <header class="section-header">
        <div class="header-main">
          <div class="type-pill">Library</div>
          <h1 class="page-title">
            <span class="gradient-text">Playlists</span>
            <span class="count-badge" v-if="filteredPlaylists.length">{{ filteredPlaylists.length }}</span>
          </h1>
          <p class="page-desc">Discover public playlists from the community.</p>
        </div>

        <div class="header-actions">
          <!-- Tabs: All / Mine -->
          <div class="tab-group" v-if="authStore.isLoggedIn">
            <button :class="['tab-btn', { active: activeTab === 'all' }]" @click="switchTab('all')">All</button>
            <button :class="['tab-btn', { active: activeTab === 'mine' }]" @click="switchTab('mine')">My Playlists</button>
          </div>

          <div class="sort-wrap">
            <select v-model="sortBy" class="sort-select">
              <option value="default">Default</option>
              <option value="name_asc">Name A–Z</option>
              <option value="name_desc">Name Z–A</option>
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
          </div>
        </div>
      </header>

      <!-- Loading -->
      <div v-if="isLoading" class="loading-grid">
        <div v-for="i in 12" :key="i" class="skeleton-card"></div>
      </div>

      <template v-else>
        <div v-if="filteredPlaylists.length" class="albums-list-view">

          <!-- GRID VIEW -->
          <div v-if="viewMode === 'grid'" class="albums-grid">
            <div
              v-for="(playlist, idx) in filteredPlaylists"
              :key="playlist.id"
              class="album-card"
              :style="{ '--delay': `${idx * 30}ms` }"
              @click="navigateToPlaylist(playlist)"
            >
              <div class="card-cover">
                <img :src="getPlaylistThumbnail(playlist)" :alt="playlist.name" class="cover-img" @error="handleImageError" />
                <div class="cover-overlay"></div>
                <div class="card-badge" :class="playlist.is_public ? 'badge-public' : 'badge-private'">
                  {{ playlist.is_public ? 'PUBLIC' : 'PRIVATE' }}
                </div>
              </div>
              <div class="card-info">
                <p class="card-name" :title="playlist.name">{{ playlist.name }}</p>
                <p class="card-meta">
                  {{ playlist.total_songs }} songs
                  <span v-if="playlist.total_duration"> · {{ formatDuration(playlist.total_duration) }}</span>
                </p>
                <!-- User info -->
                <div class="card-user" v-if="playlist.user">
                  <img
                    :src="playlist.user.avatar_url || '/default-avatar.jpg'"
                    :alt="playlist.user.name"
                    class="card-user-avatar"
                    @error="handleAvatarError"
                  />
                  <span class="card-user-name">{{ playlist.user.name }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- LIST VIEW -->
          <div v-else class="albums-list">
            <div class="list-header">
              <span class="col-rank">#</span>
              <span class="col-info">Playlist</span>
              <span class="col-creator hide-mobile">Creator</span>
              <span class="col-tracks">Tracks</span>
              <span class="col-date hide-mobile">Created</span>
              <span class="col-actions"></span>
            </div>

            <div
              v-for="(playlist, idx) in filteredPlaylists"
              :key="playlist.id"
              class="list-row"
              :style="{ '--delay': `${idx * 20}ms` }"
              @click="navigateToPlaylist(playlist)"
            >
              <span class="list-index">{{ idx + 1 }}</span>

              <div class="list-thumb">
                <img :src="getPlaylistThumbnail(playlist)" :alt="playlist.name" @error="handleImageError" />
              </div>

              <div class="list-meta">
                <p class="list-name">{{ playlist.name }}</p>
                <p class="list-desc">{{ playlist.description || '—' }}</p>
              </div>

              <!-- Creator -->
              <div class="list-creator hide-mobile" v-if="playlist.user">
                <img
                  :src="playlist.user.avatar_url || '/default-avatar.jpg'"
                  :alt="playlist.user.name"
                  class="creator-avatar"
                  @error="handleAvatarError"
                />
                <span class="creator-name">{{ playlist.user.name }}</span>
              </div>
              <div class="list-creator hide-mobile" v-else>—</div>

              <div class="list-tracks">{{ playlist.total_songs }} songs</div>
              <div class="list-date hide-mobile">{{ formatDate(playlist.created_at) }}</div>

              <div class="list-action">
                <span class="visibility-badge" :class="playlist.is_public ? 'public' : 'private'">
                  {{ playlist.is_public ? 'Public' : 'Private' }}
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- Empty -->
        <div v-else class="empty-state">
          <div class="empty-icon">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor" width="64" height="64">
              <path stroke-linecap="round" stroke-linejoin="round" d="M9 9l10.5-3m0 6.553v3.75a2.25 2.25 0 01-1.632 2.163l-1.32.377a1.803 1.803 0 11-2.8-1.452l.328-.094a1.125 1.125 0 00.764-1.235V5.11a.75.75 0 00-.272-.578l-7.5 5.75a.75.75 0 00-.228.531V16.65c0 .543-.321 1.03-.815 1.235l-1.32.378a1.803 1.803 0 11-2.8-1.452l.328-.094a1.125 1.125 0 00.764-1.235V10.5c0-.621.504-1.125 1.125-1.125h1.5" />
            </svg>
          </div>
          <h3>No playlists found</h3>
          <p v-if="searchQuery">No results for <em>"{{ searchQuery }}"</em></p>
          <p v-else-if="activeTab === 'mine'">You haven't created any playlists yet.</p>
          <p v-else>No public playlists available.</p>
          <div class="empty-actions">
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
import { usePlaylistStore } from '@/modules/client/stores/playlist/playlistStore'
import { useAuthStore } from '@/store/authStore'
import type { Playlist } from '@/modules/client/stores/playlist/playlistStore'

const router = useRouter()
const playlistStore = usePlaylistStore()
const authStore = useAuthStore()

// ── State ──────────────────────────────────────────────────────────────────
const searchQuery  = ref('')
const sortBy       = ref<'default' | 'name_asc' | 'name_desc'>('default')
const viewMode     = ref<'grid' | 'list'>('grid')
const activeTab    = ref<'all' | 'mine'>('all')

// ── Computed ───────────────────────────────────────────────────────────────
const latestCover = computed(() =>
  playlistStore.playlists.find(p => p.cover_url)?.cover_url ?? null
)

const filteredPlaylists = computed(() => {
  let list = [...playlistStore.playlists]

  if (searchQuery.value.trim()) {
    const q = searchQuery.value.toLowerCase()
    list = list.filter(p =>
      p.name?.toLowerCase().includes(q) ||
      p.description?.toLowerCase().includes(q) ||
      p.user?.name?.toLowerCase().includes(q)
    )
  }

  switch (sortBy.value) {
    case 'name_asc':  list.sort((a, b) => a.name.localeCompare(b.name)); break
    case 'name_desc': list.sort((a, b) => b.name.localeCompare(a.name)); break
  }

  return list
})

const isLoading = computed(() => playlistStore.loading)

// ── Tab switch ─────────────────────────────────────────────────────────────
const switchTab = async (tab: 'all' | 'mine') => {
  activeTab.value = tab
  playlistStore.$patch({ playlists: [] })
  if (tab === 'mine') {
    await playlistStore.fetchMyPlaylists()
  } else {
    await playlistStore.fetchAll()
  }
}

// ── Helpers ────────────────────────────────────────────────────────────────
const getPlaylistThumbnail = (playlist: Playlist): string => {
  if (!playlist.cover_url) return '/playlist_default.jpg'
  return playlist.cover_url.startsWith('http')
    ? playlist.cover_url
    : `${import.meta.env.VITE_API_URL}/storage/${playlist.cover_url}`
}

const formatDuration = (seconds: number): string => {
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  if (h > 0) return `${h}h ${m}m`
  return `${m} min`
}

const formatDate = (iso: string | null): string => {
  if (!iso) return '—'
  return new Date(iso).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
}

const handleImageError = (e: Event) => {
  (e.target as HTMLImageElement).src = '/playlist_default.jpg'
}

const handleAvatarError = (e: Event) => {
  (e.target as HTMLImageElement).src = '/default-avatar.jpg'
}

const navigateToPlaylist = (playlist: Playlist) => {
  router.push({ name: 'client.Playlist.detail', params: { slug: String(playlist.id) } })
}

const goBack = () => router.back()

// ─── Lifecycle ─────────────────────────────────────────────────────────────
onMounted(async () => {
  await playlistStore.fetchAll()
})
</script>

<style scoped>
.albums-shell {
  min-height: 100vh;
  color: #fff;
  position: relative;
  overflow-x: hidden;
  padding-bottom: 100px;
}

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

.content-container {
  position: relative;
  z-index: 1;
  max-width: 1280px;
  margin: 0 auto;
  padding: 40px;
}

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

.sort-select {
  background: rgb(0,0,0);
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
  background: rgba(255,255,255,0.04);
  border: 1px solid rgba(255,255,255,0.07);
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
  background: rgba(0,170,255,0.2);
  color: #00aaff;
}

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

.badge-public { background: rgba(0,170,255,0.7); }
.badge-private { background: rgba(0,0,0,0.6); }

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
  margin: 0 0 4px;
}

.card-meta {
  font-size: 12px;
  color: rgba(255,255,255,0.5);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin: 0 0 8px;
}

.card-user {
  display: flex;
  align-items: center;
  gap: 6px;
}

.card-user-avatar {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  object-fit: cover;
  border: 1px solid rgba(255,255,255,0.15);
}

.card-user-name {
  font-size: 11px;
  color: rgba(255,255,255,0.4);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Tabs */
.tab-group {
  display: flex;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 10px;
  padding: 3px;
  gap: 2px;
}

.tab-btn {
  padding: 7px 18px;
  border-radius: 8px;
  background: transparent;
  border: none;
  color: rgba(255,255,255,0.5);
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.15s;
}

.tab-btn.active {
  background: rgba(0,170,255,0.2);
  color: #00aaff;
}

/* List creator column */
.list-header {
  display: grid;
  grid-template-columns: 48px 1fr 160px 100px 120px 80px;
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
  grid-template-columns: 48px 1fr 160px 100px 120px 80px;
  align-items: center;
  padding: 10px 16px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.2s;
  animation: fadeUp 0.3s ease both;
  animation-delay: var(--delay, 0ms);
}

.list-row:hover { background: rgba(255,255,255,0.05); }

.list-creator {
  display: flex;
  align-items: center;
  gap: 8px;
}

.creator-avatar {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  object-fit: cover;
  border: 1px solid rgba(255,255,255,0.1);
  flex-shrink: 0;
}

.creator-name {
  font-size: 13px;
  color: rgba(255,255,255,0.5);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
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
  display: flex;
  align-items: center;
}

.visibility-badge {
  font-size: 11px;
  font-weight: 600;
  padding: 3px 10px;
  border-radius: 20px;
}

.visibility-badge.public {
  background: rgba(0,170,255,0.15);
  color: #00aaff;
}

.visibility-badge.private {
  background: rgba(255,255,255,0.08);
  color: rgba(255,255,255,0.4);
}

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

.empty-actions {
  display: flex;
  gap: 8px;
  justify-content: center;
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

@media (max-width: 768px) {
  .content-container { padding: 20px; }
  .page-title { font-size: 40px; }
  .search-box { width: 200px; }
  .search-input:focus { width: 240px; }
  .list-header, .list-row { grid-template-columns: 40px 1fr 0 0 70px; }
  .list-tracks, .list-date { display: none; }
  .albums-grid { grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 16px; }
  .header-actions { width: 100%; justify-content: flex-start; }
}

@media (max-width: 480px) {
  .albums-grid { grid-template-columns: repeat(2, 1fr); }
}
</style>
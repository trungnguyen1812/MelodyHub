<template>
  <div class="detail-shell">
    <!-- Loading Overlay -->
    <div v-if="loading" class="loading-overlay">
       <span class="btn-spinner" style="border-width: 3px; width: 24px; height: 24px;"></span>
       <span style="margin-left: 12px; font-weight: 500;">Loading album details...</span>
    </div>

    <!-- Background grid -->
    <div class="bg-grid" aria-hidden="true"></div>

    <!-- Top bar -->
    <header class="topbar">
      <button class="back-btn" @click="$router.back()">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M7.793 2.232a.75.75 0 0 1-.025 1.06L3.622 7.25h10.003a5.375 5.375 0 0 1 0 10.75H10.75a.75.75 0 0 1 0-1.5h2.875a3.875 3.875 0 0 0 0-7.75H3.622l4.146 3.957a.75.75 0 0 1-1.036 1.085l-5.5-5.25a.75.75 0 0 1 0-1.085l5.5-5.25a.75.75 0 0 1 1.06.025Z" clip-rule="evenodd" />
        </svg>
        Albums
      </button>

      <div class="topbar-title">
        <span class="topbar-label">Album Detail</span>
      </div>

      <div class="topbar-actions">
        <!-- Client doesn't have edit permissions -->
      </div>
    </header>

    <!-- Main Content -->
    <main v-if="!loading && album" class="detail-body">

      <div class="detail-layout">
        <!-- ─── LEFT: Overview Card ─── -->
        <div class="overview-col">
          <div class="cover-card">
            <div class="cover-image-wrap">
              <img :src="displayCover" alt="Cover" class="cover-img" />
              <!-- Badges -->
              <div class="cover-badges">
                <span v-if="album.is_featured" class="badge featured">Featured</span>
                <span v-if="album.is_premium" class="badge premium">Premium</span>
              </div>
            </div>

            <div class="cover-meta">
              <h2 class="album-name">{{ album.name }}</h2>
              <p class="album-artist">{{ artistName }}</p>

              <div class="meta-pills">
                <span class="mpill">{{ album.album_type || 'Album' }}</span>
                <span class="mpill status" :class="album.status">{{ statusText }}</span>
              </div>
            </div>

            <div class="quick-info">
              <div class="qi-row">
                <span class="qi-label">Release Date</span>
                <span class="qi-value">{{ formattedDate }}</span>
              </div>
              <div class="qi-row">
                <span class="qi-label">Record Label</span>
                <span class="qi-value">{{ album.label || '—' }}</span>
              </div>
              <div class="qi-row">
                <span class="qi-label">Slug</span>
                <span class="qi-value mono">{{ album.slug || '—' }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- ─── RIGHT: Tabs / Details ─── -->
        <div class="content-col">

          <!-- About Section -->
          <section class="detail-section">
            <div class="section-head">
              <h3 class="section-title">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
                  <path fill-rule="evenodd" d="M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-7-4a1 1 0 1 1-2 0 1 1 0 0 1 2 0ZM9 9a.75.75 0 0 0 0 1.5h.253a.25.25 0 0 1 .244.304l-.459 2.066A1.75 1.75 0 0 0 10.747 15H11a.75.75 0 0 0 0-1.5h-.253a.25.25 0 0 1-.244-.304l.459-2.066A1.75 1.75 0 0 0 9.253 9H9Z" clip-rule="evenodd" />
                </svg>
                Description
              </h3>
            </div>
            <div class="section-body">
              <p class="description-text">{{ album.description || 'No description provided for this album.' }}</p>
            </div>
          </section>

          <!-- Tracks Section -->
          <section class="detail-section">
            <div class="section-head">
              <h3 class="section-title">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
                  <path fill-rule="evenodd" d="M19.952 1.651a.75.75 0 0 1 .298.599V16.303a3 3 0 0 1-2.176 2.884l-1.32.377a2.553 2.553 0 1 1-1.403-4.909l2.311-.66a1.5 1.5 0 0 0 1.088-1.442V6.994l-9 2.572V21a3 3 0 0 1-2.176 2.884l-1.32.377a2.553 2.553 0 1 1-1.402-4.909l2.31-.66A1.5 1.5 0 0 0 8.25 17.25V5.251a.75.75 0 0 1 .544-.721l10.5-3a.75.75 0 0 1 .658.121Z" clip-rule="evenodd" />
                </svg>
                Tracklist <span class="track-count">({{ tracks.length }})</span>
              </h3>
            </div>
            <div class="section-body no-pad">
              <div v-if="tracks.length" class="track-list">
                <div v-for="(track, idx) in tracks" :key="track.id" class="track-row">
                  <div class="track-num">{{ String(idx + 1).padStart(2, '0') }}</div>
                  <div class="track-cover">
                    <img :src="track.cover || defaultCover" :alt="track.title" />
                  </div>
                  <div class="track-info">
                    <span class="track-title">{{ track.title }}</span>
                    <span class="track-artist">{{ track.artist }}</span>
                  </div>
                  <div class="track-meta">
                    <span class="track-duration">{{ track.duration }}</span>
                  </div>
                </div>
              </div>
              <div v-else class="empty-state">
                No tracks assigned to this album.
              </div>
            </div>
          </section>

        </div>
      </div>

    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAlbumStore, getFullImageUrl } from '@/modules/client/stores/albums/albumssStore'
import { useNotificationStore } from '@/store/notificationStore'

const route = useRoute()
const router = useRouter()
const notificationStore = useNotificationStore()
const albumStore = useAlbumStore()

const loading = ref(true)
const defaultCover = 'https://via.placeholder.com/400x400?text=Cover'

const album = ref<any>(null)
const tracks = ref<any[]>([])

const albumSlug = route.params.slug as string

const formatDuration = (seconds?: number) => {
  if (!seconds) return '0:00';
  const m = Math.floor(seconds / 60);
  const s = Math.floor(seconds % 60);
  return `${m}:${s.toString().padStart(2, '0')}`;
}

const loadAlbumData = async () => {
  try {
    const res = await albumStore.fetchShow(albumSlug)
    if (res) {
      const data = res.data || res
      album.value = data

      if (data.tracks && Array.isArray(data.tracks)) {
        tracks.value = data.tracks.map((t: any) => ({
          id: t.id,
          title: t.title,
          artist: t.artist?.name || 'Unknown Artist',
          duration: formatDuration(t.duration),
          cover: t.cover_url ? getFullImageUrl(t.cover_url) : defaultCover
        }))
      }
    }
  } catch (err: any) {
    const status = err?.response?.status
    if (status === 404) router.push('/404')
    else if (status === 401) router.push('/login')
    else {
      notificationStore.notify('Failed to load album details', 'error')
      router.push({ name: 'client.albums' })
    }
  }
}

onMounted(async () => {
  loading.value = true
  await loadAlbumData()
  loading.value = false
})

// ── Computed ──────────────────────────────────────────────
const displayCover = computed(() => {
  if (!album.value?.cover_url) return defaultCover;
  const url = album.value.cover_url;
  return url.startsWith('http') ? url : (getFullImageUrl ? getFullImageUrl(url) : url);
})

const artistName = computed(() => {
  if (!album.value) return 'Unknown Artist';
  // Try relationship first
  if (album.value.artist?.name) return album.value.artist.name;
  return `Artist #${album.value.artist_id || '?'}`;
})

const statusText = computed(() => {
  const s = album.value?.status;
  if (!s) return 'Unknown';
  return s.charAt(0).toUpperCase() + s.slice(1);
})

const formattedDate = computed(() => {
  if (!album.value?.release_date) return '—';
  // Attempt simple format
  const dateObj = new Date(album.value.release_date);
  if (isNaN(dateObj.getTime())) return album.value.release_date;
  return dateObj.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });
})
</script>

<style scoped>
/* ── Base ───────────────────────────────────────── */
.detail-shell {
  min-height: 100vh;
  background: #080e14;
  display: flex;
  flex-direction: column;
  font-family: 'DM Sans', 'Segoe UI', sans-serif;
  color: #e8edf2;
  position: relative;
  overflow: hidden;
}

.loading-overlay {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(8, 14, 20, 0.9);
  z-index: 100;
  backdrop-filter: blur(4px);
  color: white;
}

.btn-spinner {
  width: 15px;
  height: 15px;
  border: 2px solid rgba(255,255,255,0.2);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
  display: inline-block;
}
@keyframes spin { to { transform: rotate(360deg); } }

.bg-grid {
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(0, 160, 255, 0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0, 160, 255, 0.03) 1px, transparent 1px);
  background-size: 40px 40px;
  pointer-events: none;
  z-index: 0;
}

/* ── Topbar ─────────────────────────────────────── */
.topbar {
  position: sticky;
  top: 0;
  z-index: 50;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 24px;
  background: rgba(8, 14, 20, 0.95);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.back-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 6px;
  color: #e8edf2;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}
.back-btn:hover {
  background: rgba(255, 255, 255, 0.08);
  border-color: rgba(255, 255, 255, 0.12);
}

.topbar-title {
  flex: 1;
  text-align: center;
}
.topbar-label {
  font-size: 16px;
  font-weight: 600;
  color: #e8edf2;
}

.topbar-actions {
  display: flex;
  gap: 8px;
}

/* ── Detail Body ────────────────────────────────── */
.detail-body {
  flex: 1;
  padding: 24px;
  position: relative;
  z-index: 10;
}

.detail-layout {
  display: grid;
  grid-template-columns: 320px 1fr;
  gap: 32px;
  max-width: 1200px;
  margin: 0 auto;
}

/* ── Overview Column ────────────────────────────── */
.overview-col {
  position: sticky;
  top: 120px;
  height: fit-content;
}

.cover-card {
  background: rgba(255, 255, 255, 0.02);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 12px;
  padding: 20px;
  backdrop-filter: blur(8px);
}

.cover-image-wrap {
  position: relative;
  margin-bottom: 16px;
}
.cover-img {
  width: 100%;
  aspect-ratio: 1;
  object-fit: cover;
  border-radius: 8px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

.cover-badges {
  position: absolute;
  top: 8px;
  right: 8px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 10px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
.badge.featured {
  background: linear-gradient(135deg, #ff6b6b, #ee5a24);
  color: white;
}
.badge.premium {
  background: linear-gradient(135deg, #ffd93d, #ff8c00);
  color: #1a1a1a;
}

.cover-meta {
  margin-bottom: 20px;
}
.album-name {
  font-size: 24px;
  font-weight: 700;
  color: #e8edf2;
  margin: 0 0 4px 0;
  line-height: 1.2;
}
.album-artist {
  font-size: 16px;
  color: #a8b3c0;
  margin: 0 0 12px 0;
}

.meta-pills {
  display: flex;
  gap: 8px;
  margin-bottom: 16px;
}
.mpill {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}
.mpill.status {
  background: rgba(0, 160, 255, 0.1);
  color: #00a0ff;
  border: 1px solid rgba(0, 160, 255, 0.2);
}

.quick-info {
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  padding-top: 16px;
}
.qi-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 6px 0;
}
.qi-label {
  font-size: 13px;
  color: #a8b3c0;
}
.qi-value {
  font-size: 13px;
  color: #e8edf2;
  font-weight: 500;
}
.qi-value.mono {
  font-family: 'JetBrains Mono', monospace;
  font-size: 12px;
}

/* ── Content Column ─────────────────────────────── */
.content-col {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.detail-section {
  background: rgba(255, 255, 255, 0.02);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 12px;
  overflow: hidden;
  backdrop-filter: blur(8px);
}

.section-head {
  padding: 20px 24px 0 24px;
}
.section-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 18px;
  font-weight: 600;
  color: #e8edf2;
  margin: 0;
}

.section-body {
  padding: 20px 24px;
}
.section-body.no-pad {
  padding: 0;
}

.description-text {
  color: #c8d1db;
  line-height: 1.6;
  margin: 0;
}

/* ── Track List ─────────────────────────────────── */
.track-list {
  padding: 0;
}

.track-row {
  display: grid;
  grid-template-columns: 40px 48px 1fr 80px;
  gap: 16px;
  align-items: center;
  padding: 12px 24px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.04);
  transition: background 0.2s ease;
}
.track-row:hover {
  background: rgba(255, 255, 255, 0.02);
}
.track-row:last-child {
  border-bottom: none;
}

.track-num {
  font-size: 14px;
  font-weight: 600;
  color: #a8b3c0;
  text-align: center;
}

.track-cover img {
  width: 48px;
  height: 48px;
  object-fit: cover;
  border-radius: 4px;
}

.track-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.track-title {
  font-size: 14px;
  font-weight: 500;
  color: #e8edf2;
}
.track-artist {
  font-size: 12px;
  color: #a8b3c0;
}

.track-meta {
  text-align: right;
}
.track-duration {
  font-size: 12px;
  color: #a8b3c0;
  font-family: 'JetBrains Mono', monospace;
}

.track-count {
  font-size: 14px;
  color: #a8b3c0;
  font-weight: 400;
}

/* ── Empty State ────────────────────────────────── */
.empty-state {
  padding: 40px 24px;
  text-align: center;
  color: #a8b3c0;
  font-style: italic;
}

/* ── Responsive ─────────────────────────────────── */
@media (max-width: 1024px) {
  .detail-layout {
    grid-template-columns: 1fr;
    gap: 24px;
  }
  .overview-col {
    position: static;
  }
}

@media (max-width: 768px) {
  .detail-body {
    padding: 16px;
  }
  .topbar {
    padding: 12px 16px;
  }
  .section-head,
  .section-body {
    padding-left: 16px;
    padding-right: 16px;
  }
  .track-row {
    grid-template-columns: 32px 40px 1fr 60px;
    gap: 12px;
    padding: 10px 16px;
  }
}
</style>
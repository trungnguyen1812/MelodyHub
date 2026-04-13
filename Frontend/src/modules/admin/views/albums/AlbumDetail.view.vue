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
        <button class="action-btn" @click="goToEdit">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
            <path d="M2.695 14.763l-1.262 3.156a.5.5 0 0 0 .65.65l3.155-1.262a4 4 0 0 0 1.343-.885L17.5 5.5a2.121 2.121 0 0 0-3-3L3.58 13.42a4 4 0 0 0-.885 1.343Z" />
          </svg>
          Edit Album
        </button>
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

          <!-- System & Metadata Section -->
          <section class="detail-section">
            <div class="section-head">
              <h3 class="section-title">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
                  <path fill-rule="evenodd" d="M11.49 3.17c-.38-1.56-2.6-1.56-2.98 0a1.532 1.532 0 0 1-2.286.948c-1.372-.836-2.942.734-2.106 2.106.54.886.061 2.042-.947 2.287-1.561.379-1.561 2.6 0 2.978a1.532 1.532 0 0 1 .947 2.287c-.836 1.372.734 2.942 2.106 2.106a1.532 1.532 0 0 1 2.287.947c.379 1.561 2.6 1.561 2.978 0a1.533 1.533 0 0 1 2.287-.947c1.372.836 2.942-.734 2.106-2.106a1.533 1.533 0 0 1 .947-2.287c1.561-.379 1.561-2.6 0-2.978a1.532 1.532 0 0 1-.947-2.287c.836-1.372-.734-2.942-2.106-2.106a1.532 1.532 0 0 1-2.287-.947ZM10 13a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z" clip-rule="evenodd" />
                </svg>
                System & SEO Metadata
              </h3>
            </div>
            <div class="section-body">
              <div class="meta-grid">
                <div class="m-box">
                  <span class="m-label">Partner</span>
                  <span class="m-value">{{ partnerName }}</span>
                </div>
                <div class="m-box">
                  <span class="m-label">Created At</span>
                  <span class="m-value">{{ formattedCreatedAt }}</span>
                </div>
                <div class="m-box">
                  <span class="m-label">Updated At</span>
                  <span class="m-value">{{ formattedUpdatedAt }}</span>
                </div>
              </div>
              
              <div class="seo-box">
                <div class="seo-row">
                  <span class="m-label">SEO Title</span>
                  <span class="m-value block">{{ album.seo_title || '—' }}</span>
                </div>
                <div class="seo-row" style="margin-top:12px;">
                  <span class="m-label">SEO Description</span>
                  <span class="m-value block">{{ album.seo_description || '—' }}</span>
                </div>
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
import { useAlbumStore, getFullImageUrl } from '@/modules/admin/stores/albums/albumsStore'
import { useNotificationStore } from '@/store/notificationStore'
import { useArtistStore } from '@/modules/admin/stores/artists/artistsStore'
import { usePartnerStore } from '@/modules/admin/stores/partners/partnersStore'

const route = useRoute()
const router = useRouter()
const notificationStore = useNotificationStore()
const albumStore = useAlbumStore()
const artistStore = useArtistStore()
const partnerStore = usePartnerStore()

const loading = ref(true)
const defaultCover = 'https://via.placeholder.com/400x400?text=Cover'

const album = ref<any>(null)
const tracks = ref<any[]>([])
const allArtists = ref<any[]>([])
const allPartners = ref<any[]>([])

const albumId = Number(route.params.id)

const formatDuration = (seconds?: number) => {
  if (!seconds) return '0:00';
  const m = Math.floor(seconds / 60);
  const s = Math.floor(seconds % 60);
  return `${m}:${s.toString().padStart(2, '0')}`;
}

const loadAlbumData = async () => {
  try {
    const res = await albumStore.fetchShow(albumId)
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
      router.push({ name: 'admin.albumsmanager' })
    }
  }
}

onMounted(async () => {
  loading.value = true
  // Let's load generic artist list just in case artist relationship isn't included or we need to map artist_id
  await artistStore.fetchArtists().then(() => {
    allArtists.value = artistStore.artists
  }).catch(() => {})
  
  await partnerStore.fetchPartners().then(() => {
    allPartners.value = partnerStore.partners
  }).catch(() => {})
  
  await loadAlbumData()
  loading.value = false
})

const goToEdit = () => {
  router.push({ name: 'admin.albumsmanager.update', params: { id: albumId } })
}

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
  // Fallback to loaded list
  const found = allArtists.value.find(a => a.id === album.value.artist_id);
  return found?.name || `Artist #${album.value.artist_id || '?'}`;
})

const partnerName = computed(() => {
  if (!album.value) return 'None';
  // Try relationship first
  if (album.value.partner?.company_name) return album.value.partner.company_name;
  // Fallback to loaded list
  const found = allPartners.value.find(p => p.id === album.value.partner_id);
  return found?.company_name || 'None';
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

const formattedCreatedAt = computed(() => {
  if (!album.value?.created_at) return '—';
  return new Date(album.value.created_at).toLocaleString();
})
const formattedUpdatedAt = computed(() => {
  if (!album.value?.updated_at) return '—';
  return new Date(album.value.updated_at).toLocaleString();
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
  position: relative;
  z-index: 10;
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 18px 28px;
  border-bottom: 1px solid rgba(255,255,255,0.06);
  background: rgba(8, 14, 20, 0.8);
  backdrop-filter: blur(12px);
}

.back-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.7);
  border-radius: 8px;
  padding: 7px 14px;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.15s;
  flex-shrink: 0;
}
.back-btn:hover { background: rgba(255,255,255,0.1); color: #fff; }

.topbar-title { flex: 1; }
.topbar-label { font-size: 15px; font-weight: 600; color: rgba(255,255,255,0.5); }

.topbar-actions {
  display: flex;
  gap: 12px;
}

.action-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  border-radius: 8px;
  background: #00aaff;
  color: #000;
  font-size: 13px;
  font-weight: 600;
  border: none;
  cursor: pointer;
  transition: all 0.2s;
}
.action-btn:hover {
  background: #33bbff;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0,170,255,0.3);
}

/* ── Main Detail Body ───────────────────────────── */
.detail-body {
  flex: 1;
  overflow-y: auto;
  padding: 32px 28px;
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 1100px;
  margin: 0 auto;
  box-sizing: border-box;
}

.detail-layout {
  display: grid;
  grid-template-columns: 320px 1fr;
  gap: 32px;
  align-items: start;
}

/* ── OVERVIEW COLUMN (Left) ─────────────────────── */
.overview-col {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.cover-card {
  background: rgba(255,255,255,0.02);
  border: 1px solid rgba(255,255,255,0.07);
  border-radius: 16px;
  overflow: hidden;
  padding: 0;
  display: flex;
  flex-direction: column;
}

.cover-image-wrap {
  position: relative;
  width: 100%;
  aspect-ratio: 1/1;
  background: #111;
}

.cover-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.cover-badges {
  position: absolute;
  top: 12px;
  left: 12px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.badge {
  font-size: 11px;
  font-weight: 700;
  padding: 4px 10px;
  border-radius: 100px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  backdrop-filter: blur(8px);
}
.badge.featured { background: rgba(0,200,120,0.8); color: #fff; }
.badge.premium { background: rgba(255,170,0,0.8); color: #000; }

.cover-meta {
  padding: 20px 20px 16px;
  text-align: center;
  border-bottom: 1px solid rgba(255,255,255,0.06);
}
.album-name {
  font-size: 22px;
  font-weight: 700;
  color: #fff;
  margin: 0 0 4px;
}
.album-artist {
  font-size: 15px;
  color: #00aaff;
  margin: 0 0 16px;
  font-weight: 500;
}
.meta-pills {
  display: flex;
  gap: 8px;
  justify-content: center;
  flex-wrap: wrap;
}
.mpill {
  font-size: 12px;
  padding: 4px 12px;
  border-radius: 100px;
  background: rgba(255,255,255,0.07);
  color: rgba(255,255,255,0.6);
  text-transform: capitalize;
}
.mpill.status.published {
  color: #00c87a;
  background: rgba(0, 200, 120, 0.12);
  border: 1px solid rgba(0, 200, 120, 0.5);
  width: auto;
  height: 25px;
}
.mpill.status.draft { color: #ffbb00; }

.quick-info {
  padding: 16px 20px 20px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.qi-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
}
.qi-label { color: rgba(255,255,255,0.4); }
.qi-value { color: rgba(255,255,255,0.8); font-weight: 500; text-align: right; max-width: 60%; word-break: break-word; }
.qi-value.mono { font-family: monospace; color: #00aaff; background: rgba(0,170,255,0.1); padding: 2px 6px; border-radius: 4px; }


/* ── CONTENT COLUMN (Right) ─────────────────────── */
.content-col {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.detail-section {
  background: rgba(255,255,255,0.02);
  border: 1px solid rgba(255,255,255,0.07);
  border-radius: 16px;
  overflow: hidden;
}

.section-head {
  padding: 16px 22px;
  border-bottom: 1px solid rgba(255,255,255,0.05);
  background: rgba(255,255,255,0.01);
}
.section-title {
  font-size: 15px;
  font-weight: 600;
  color: #fff;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
}
.section-title svg { color: #00aaff; }
.track-count { color: rgba(255,255,255,0.4); font-weight: 400; font-size: 14px; }

.section-body {
  padding: 22px;
}
.section-body.no-pad {
  padding: 0;
}

.description-text {
  font-size: 14px;
  color: rgba(255,255,255,0.65);
  line-height: 1.6;
  margin: 0;
  white-space: pre-wrap;
}

/* Tracks */
.track-list {
  display: flex;
  flex-direction: column;
}
.track-row {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 12px 22px;
  border-bottom: 1px solid rgba(255,255,255,0.04);
  transition: background 0.15s;
}
.track-row:last-child { border-bottom: none; }
.track-row:hover { background: rgba(255,255,255,0.03); }

.track-num {
  font-size: 12px;
  color: rgba(255,255,255,0.25);
  font-variant-numeric: tabular-nums;
  width: 24px;
  text-align: right;
  flex-shrink: 0;
}
.track-cover {
  width: 38px;
  height: 38px;
  border-radius: 6px;
  overflow: hidden;
  flex-shrink: 0;
}
.track-cover img { width: 100%; height: 100%; object-fit: cover; }

.track-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
}
.track-title { font-size: 14px; font-weight: 500; color: #fff; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.track-artist { font-size: 12px; color: rgba(255,255,255,0.4); }

.track-meta { flex-shrink: 0; }
.track-duration { font-size: 13px; color: rgba(255,255,255,0.35); font-variant-numeric: tabular-nums; }

.empty-state {
  padding: 32px;
  text-align: center;
  color: rgba(255,255,255,0.4);
  font-size: 14px;
}

/* System & Meta Box */
.meta-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 24px;
}
.m-box {
  background: rgba(255,255,255,0.03);
  padding: 14px;
  border-radius: 10px;
  border: 1px solid rgba(255,255,255,0.05);
}
.m-label {
  display: block;
  font-size: 11px;
  text-transform: uppercase;
  color: rgba(255,255,255,0.4);
  margin-bottom: 6px;
  letter-spacing: 0.05em;
}
.m-value {
  font-size: 14px;
  color: #fff;
  font-weight: 500;
}
.m-value.block {
  display: block;
  line-height: 1.5;
  color: rgba(255,255,255,0.8);
  font-weight: 400;
}
.seo-box {
  background: rgba(255,255,255,0.02);
  padding: 16px;
  border-radius: 10px;
  border: 1px solid rgba(255,255,255,0.04);
}

/* ── Responsive ─────────────────────────────────── */
@media (max-width: 900px) {
  .detail-layout {
    grid-template-columns: 1fr;
  }
  .overview-col {
    flex-direction: row;
    align-items: flex-start;
  }
  .cover-card {
    flex-direction: row;
    align-items: center;
    width: 100%;
  }
  .cover-image-wrap {
    width: 200px;
    flex-shrink: 0;
  }
  .cover-meta {
    flex: 1;
    border-bottom: none;
    border-right: 1px solid rgba(255,255,255,0.06);
    text-align: left;
  }
  .meta-pills { justify-content: flex-start; }
  .quick-info {
    flex: 1;
    padding: 16px 20px;
  }
}

@media (max-width: 600px) {
  .overview-col { flex-direction: column; }
  .cover-card { flex-direction: column; }
  .cover-image-wrap { width: 100%; }
  .cover-meta { border-right: none; border-bottom: 1px solid rgba(255,255,255,0.06); text-align: center; }
  .meta-pills { justify-content: center; }
  .meta-grid { grid-template-columns: 1fr; }
}
</style>
<template>
  <div class="album-detail-shell">
    <div class="bg-blur-container">
      <div v-if="album?.cover_url" class="banner-blur" :style="{ backgroundImage: `url(${getFullImageUrl(album.cover_url)})` }"></div>
      <div v-else class="banner-blur-placeholder"></div>
    </div>

    <div class="content-container">
      <!-- Back Button -->
      <button class="back-nav-btn" @click="$router.back()">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M17 10a.75.75 0 0 1-.75.75H5.612l4.158 3.96a.75.75 0 1 1-1.04 1.08l-5.5-5.25a.75.75 0 0 1 0-1.08l5.5-5.25a.75.75 0 1 1 1.04 1.08L5.612 9.25H16.25A.75.75 0 0 1 17 10Z" clip-rule="evenodd" />
        </svg>
        Back
      </button>

      <!-- Loading -->
      <div v-if="loading" class="loading-overlay">
        <div class="spinner"></div>
        <p>Loading album...</p>
      </div>

      <template v-else-if="album">
        <!-- Album Header -->
        <header class="album-header">
          <div class="profile-main">
            <!-- Album Cover -->
            <div class="cover-wrap">
              <img :src="getFullImageUrl(album.cover_url)" :alt="album.name" class="album-cover" />
            </div>

            <div class="profile-info">
              <div class="type-pill">ALBUM</div>
              <h1 class="album-name">{{ album.name }}</h1>
              <p class="album-artist" @click="goToArtist">
                {{ album.artist?.name }}
              </p>

              <div class="stats-row">
                <span>{{ album.release_date ? new Date(album.release_date).getFullYear() : '' }}</span>
                <span class="dot">·</span>
                <span>{{ album.tracks?.length || 0 }} songs</span>
                <span class="dot">·</span>
                <span>{{ formatTotalDuration() }}</span>
              </div>
            </div>
          </div>

          <div class="header-actions">
            <button class="play-all-btn" @click="playAll">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                <path fill-rule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clip-rule="evenodd" />
              </svg>
              Play all
            </button>

            <ActionButton 
              v-if="album?.id"
              class="follow-btn"
              type="likeAlbum" 
              :item="{ 
                id: album.id, 
                isActive: album.is_liked ?? false,
                count: album.like_count ?? 0
              }"
              @success="onLikeSuccess"
            />
          </div>
        </header>

        <!-- Tracks Section -->
        <section class="tracks-section">
          <div class="section-head">
            <h2 class="section-title">Tracks</h2>
            <span class="track-count" v-if="album.tracks?.length">{{ album.tracks.length }} songs</span>
          </div>

          <div v-if="album.tracks && album.tracks.length" class="tracks-list">
            <!-- Header -->
            <div class="tracks-list-header">
              <span>#</span>
              <span>Title</span>
              <span class="col-duration">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm.75-13a.75.75 0 0 0-1.5 0v5c0 .414.336.75.75.75h4a.75.75 0 0 0 0-1.5h-3.25V5Z" clip-rule="evenodd" />
                </svg>
              </span>
              <span></span>
            </div>

            <div
              v-for="(track, index) in album.tracks"
              :key="track.id"
              class="track-row"
              :class="{ 'is-active': player.currentSong?.id === track.id }"
              @click="playTrack(track)"
            >
              <!-- Track number / Wave -->
              <div class="t-rank">
                <span class="rank-num" v-if="!(player.currentSong?.id === track.id && player.isPlaying)">
                  {{ index + 1 }}
                </span>
                <span class="rank-wave" v-else>
                  <span></span><span></span><span></span>
                </span>
              </div>

              <!-- Cover + Info -->
              <div class="t-info">
                <div class="t-cover">
                  <img :src="getFullImageUrl(track.cover_url || album.cover_url)" alt="cover" />
                  <div class="t-cover-overlay">
                    <svg v-if="!(player.currentSong?.id === track.id && player.isPlaying)" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
                      <path fill-rule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clip-rule="evenodd" />
                    </svg>
                    <svg v-else xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
                      <path fill-rule="evenodd" d="M6.75 5.25a.75.75 0 0 1 .75-.75H9a.75.75 0 0 1 .75.75v13.5a.75.75 0 0 1-.75.75H7.5a.75.75 0 0 1-.75-.75V5.25Zm7.5 0A.75.75 0 0 1 15 4.5h1.5a.75.75 0 0 1 .75.75v13.5a.75.75 0 0 1-.75.75H15a.75.75 0 0 1-.75-.75V5.25Z" clip-rule="evenodd" />
                    </svg>
                  </div>
                </div>
                <div class="t-details">
                  <div class="t-title">{{ track.title }}</div>
                  <div class="t-tags">
                    <span v-if="track.is_premium" class="tag tag-premium">Premium</span>
                    <span v-if="track.is_explicit" class="tag tag-explicit">E</span>
                  </div>
                </div>
              </div>

              <!-- Duration -->
              <div class="t-duration col-duration">{{ formatDuration(track.duration) }}</div>

              <!-- Actions -->
              <div class="t-actions">
                <button class="row-action-btn" @click.stop>
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
                    <path d="M10 3a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM10 8.5a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM11.5 15.5a1.5 1.5 0 1 0-3 0 1.5 1.5 0 0 0 3 0Z" />
                  </svg>
                </button>
              </div>
            </div>
          </div>

          <div v-else class="empty-tracks">
            <p>No tracks available yet.</p>
          </div>
        </section>
      </template>

      <!-- Error -->
      <div v-else class="error-state">
        <h2>Album not found</h2>
        <p>This album may have been removed or the link is invalid.</p>
        <button @click="$router.push({ name: 'client.albums' })" class="back-btn">Back to Albums</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getFullImageUrl } from '@/modules/client/stores/artists/artistsStore'
import AlbumService from '@/modules/client/services/albums/albums.service'
import { usePlayerStore } from '@/store/playerStore'
import ActionButton from '@/components/common/VcBtnAction/ActionButton.vue'
import type { AlbumInterface } from '@/interfaces/albums.interface'
import type { Song } from '@/interfaces/songs.interface'

const route = useRoute()
const router = useRouter()
const album = ref<AlbumInterface | null>(null)
const loading = ref(true)
const player = usePlayerStore()

const mapTrack = (track: any): Song => ({
  ...track,
  urls: track.urls || {
    standard: track.song_url ?? null,
    hq: track.song_url_hq ?? null,
    lossless: track.song_url_lossless ?? null,
  },
  artist: album.value?.artist || track.artist,
})

const playTrack = (track: any) => {
  const mapped = mapTrack(track)
  const queue = (album.value?.tracks ?? []).map(mapTrack)
  player.play(mapped, queue)
}

const playAll = () => {
  if (!album.value?.tracks?.length) return
  const queue = album.value.tracks.map(mapTrack)
  player.play(queue[0], queue)
}

const formatDuration = (seconds: number) => {
  const min = Math.floor(seconds / 60)
  const sec = seconds % 60
  return `${min}:${sec.toString().padStart(2, '0')}`
}

const formatTotalDuration = () => {
  const total = album.value?.tracks?.reduce((sum, t) => sum + (t.duration || 0), 0) || 0
  const min = Math.floor(total / 60)
  return min > 60 ? `${Math.floor(min / 60)} hr ${min % 60} min` : `${min} min`
}

const goToArtist = () => {
  if (album.value?.artist?.slug) {
    router.push({ name: 'client.artist.songs', params: { slug: album.value.artist.slug } })
  }
}

const onLikeSuccess = async () => {
  // Refetch nếu cần update trạng thái
  await fetchAlbum()
}

const fetchAlbum = async () => {
  try {
    loading.value = true
    const slug = route.params.slug as string
    const res = await AlbumService.detailAlbum(slug)
    album.value = res.data.data || res.data
  } catch (error) {
    console.error('Failed to fetch album:', error)
  } finally {
    loading.value = false
  }
}

onMounted(fetchAlbum)
</script>

<style scoped>
/* ─── Shell ──────────────────────────────────────────────── */
.album-detail-shell {
  min-height: 100vh;
  color: #fff;
  position: relative;
  overflow-x: hidden;
}

/* ─── Background blur ─────────────────────────────────────── */
.bg-blur-container {
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 520px;
  overflow: hidden;
  z-index: 0;
  mask-image: linear-gradient(to bottom, black 40%, transparent 100%);
}

.banner-blur {
  width: 100%; height: 100%;
  background-size: cover;
  background-position: center;
  filter: blur(90px) saturate(1.4) opacity(0.28);
  transform: scale(1.25);
}

.banner-blur-placeholder {
  width: 100%; height: 100%;
  background: radial-gradient(circle at 30% 50%, #1a2a3a 0%, #080e14 100%);
  filter: blur(60px);
}

/* ─── Content ─────────────────────────────────────────────── */
.content-container {
  position: relative;
  z-index: 1;
  max-width: 1280px;
  margin: 0 auto;
  padding: 56px 40px 100px;
}

/* ─── Back button ─────────────────────────────────────────── */
.back-nav-btn {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.7);
  padding: 8px 16px;
  border-radius: 99px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  margin-bottom: 36px;
  transition: background 0.2s, color 0.2s, transform 0.2s;
}

.back-nav-btn:hover {
  background: rgba(255,255,255,0.1);
  color: #fff;
  transform: translateX(-3px);
}

/* ─── Header ──────────────────────────────────────────────── */
.album-header {
  display: flex;
  flex-direction: column;
  gap: 36px;
  margin-bottom: 56px;
}

.profile-main {
  display: flex;
  align-items: flex-end;
  gap: 28px;
}

.cover-wrap {
  position: relative;
  width: 220px; height: 220px;
  flex-shrink: 0;
  border-radius: 10px;
  box-shadow: 0 24px 60px rgba(0,0,0,0.6);
}

.album-cover {
  width: 100%; height: 100%;
  object-fit: cover;
  border-radius: 10px;
  border: 3px solid rgba(255,255,255,0.08);
}

.verified-badge {
  position: absolute;
  bottom: 14px; right: 14px;
  background: #fff;
  color: #00aaff;
  width: 32px; height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(0,0,0,0.3);
}

.profile-info {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding-bottom: 12px;
}

.type-pill {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  color: rgba(255,255,255,0.5);
}

.album-name {
  font-size: clamp(42px, 7vw, 80px);
  font-weight: 900;
  margin: 0;
  letter-spacing: -0.03em;
  line-height: 1;
}

.stats-row {
  display: flex;
  align-items: center;
  gap: 14px;
  font-size: 14px;
  color: rgba(255,255,255,0.55);
}

.stat-item { display: flex; align-items: center; gap: 5px; }
.stat-item b { color: #fff; font-weight: 700; }
.dot { color: rgba(255,255,255,0.2); }

/* ─── Actions ─────────────────────────────────────────────── */
.header-actions {
  display: flex;
  align-items: center;
  gap: 14px;
}

.play-all-btn {
  background: #00aaff;
  color: #000;
  border: none;
  padding: 13px 28px;
  border-radius: 99px;
  font-weight: 800;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  transition: transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1), background 0.2s, box-shadow 0.2s;
}

.play-all-btn:hover {
  transform: scale(1.04);
  background: #29bbff;
  box-shadow: 0 0 28px rgba(0, 170, 255, 0.35);
}

.play-all-btn:active { transform: scale(0.98); }


.header-actions:deep(.follow-btn) {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  background: transparent;
  color: #fff;
  border: 1px solid rgba(255,255,255,0.25);
  padding: 12px 24px;
  border-radius: 99px;
  font-weight: 700;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
  height: 50px;
}

/* Chưa follow — outline style */
.follow-btn {
  background: transparent;
  color: #fff;
  border: 1.5px solid rgba(255,255,255,0.5);
  padding: 12px 24px;
  border-radius: 99px;
  font-weight: 700;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
  height: 50px;
}

.follow-btn:hover {
  background: rgba(255,255,255,0.08);
  border-color: #fff;
}

.follow-btn.is-following {
  background: #00aaff;
  border-color: #00aaff;
  color: #000;
  font-weight: 800;
}

.follow-btn.is-following:hover {
  background: #ff4d4d;
  border-color: #ff4d4d;
  color: #fff;
}

/* ─── Songs section ───────────────────────────────────────── */
.tracks-section { margin-top: 36px; }

.section-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid rgba(255,255,255,0.06);
  padding-bottom: 14px;
  margin-bottom: 4px;
}

.section-title {
  font-size: 20px;
  font-weight: 800;
  margin: 0;
}

.track-count {
  font-size: 12px;
  color: rgba(255,255,255,0.3);
}

/* ─── List header ─────────────────────────────────────────── */
.tracks-list-header {
  display: grid;
  grid-template-columns: 44px 1fr 120px 72px 40px;
  align-items: center;
  padding: 6px 12px;
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: rgba(255,255,255,0.25);
  margin-bottom: 2px;
}

/* ─── Song row ────────────────────────────────────────────── */
.track-row {
  display: grid;
  grid-template-columns: 44px 1fr 120px 72px 40px;
  align-items: center;
  padding: 6px 12px;
  border-radius: 10px;
  cursor: pointer;
  transition: background 0.15s;
  position: relative;
}

.track-row:hover { background: rgba(255,255,255,0.05); }

.track-row.is-active { background: rgba(0,170,255,0.07); }

/* ─── Rank ────────────────────────────────────────────────── */
.t-rank {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
}

.rank-num {
  font-size: 13px;
  color: rgba(255,255,255,0.3);
  font-variant-numeric: tabular-nums;
}

/* Wave bars for currently playing */
.rank-wave {
  display: flex;
  align-items: flex-end;
  gap: 2px;
  height: 16px;
}

.rank-wave span {
  display: block;
  width: 3px;
  background: #00aaff;
  border-radius: 2px;
  animation: wave 0.85s ease-in-out infinite;
}

.rank-wave span:nth-child(1) { animation-delay: 0s;    animation-duration: 0.9s; }
.rank-wave span:nth-child(2) { animation-delay: 0.18s; animation-duration: 0.72s; }
.rank-wave span:nth-child(3) { animation-delay: 0.34s; animation-duration: 1.0s; }

@keyframes wave {
  0%, 100% { height: 3px; }
  50%       { height: 16px; }
}

/* ─── Cover ───────────────────────────────────────────────── */
.t-info {
  display: flex;
  align-items: center;
  gap: 14px;
  min-width: 0;
}

.t-cover {
  position: relative;
  width: 42px; height: 42px;
  border-radius: 7px;
  overflow: hidden;
  flex-shrink: 0;
  background: rgba(255,255,255,0.05);
}

.t-cover img {
  width: 100%; height: 100%;
  object-fit: cover;
  display: block;
}

.t-cover-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.58);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  opacity: 0;
  transition: opacity 0.15s;
}

.track-row:hover .t-cover-overlay,
.track-row.is-active .t-cover-overlay { opacity: 1; }

/* ─── Details ─────────────────────────────────────────────── */
.t-details {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.t-title {
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  transition: color 0.15s;
}

.track-row.is-active .t-title { color: #00aaff; }

.t-tags {
  display: flex;
  gap: 5px;
  align-items: center;
}

.tag {
  font-size: 10px;
  font-weight: 700;
  padding: 1px 5px;
  border-radius: 4px;
  text-transform: uppercase;
  letter-spacing: 0.03em;
}

.tag-premium {
  background: rgba(251,192,45,0.12);
  color: #fbc02d;
  border: 1px solid rgba(251,192,45,0.2);
}

.tag-explicit {
  background: rgba(255,255,255,0.07);
  color: rgba(255,255,255,0.45);
  border: 1px solid rgba(255,255,255,0.1);
}

/* ─── Plays / Duration ────────────────────────────────────── */
.t-duration {
  font-size: 13px;
  color: rgba(255,255,255,0.38);
  font-variant-numeric: tabular-nums;
  text-align: right;
}

.col-duration { text-align: right; }

/* ─── Actions ─────────────────────────────────────────────── */
.row-action-btn {
  background: transparent;
  border: none;
  color: rgba(255,255,255,0.2);
  cursor: pointer;
  padding: 5px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.15s, color 0.15s, background 0.15s;
}

.track-row:hover .row-action-btn { opacity: 1; }
.row-action-btn:hover { color: #fff; background: rgba(255,255,255,0.08); }

/* ─── Empty ───────────────────────────────────────────────── */
.empty-tracks {
  text-align: center;
  padding: 80px 0;
  color: rgba(255,255,255,0.28);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 14px;
  font-size: 14px;
}

/* ─── Loading ─────────────────────────────────────────────── */
.loading-overlay {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 120px 0;
  gap: 18px;
  color: rgba(255,255,255,0.35);
  font-size: 14px;
}

.spinner {
  width: 44px; height: 44px;
  border: 3px solid rgba(0,170,255,0.12);
  border-left-color: #00aaff;
  border-radius: 50%;
  animation: spin 0.9s linear infinite;
}

@keyframes spin { to { transform: rotate(360deg); } }

/* ─── Error ───────────────────────────────────────────────── */
.error-state {
  text-align: center;
  padding: 80px 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  color: rgba(255,255,255,0.4);
}

.error-state h2 { color: #fff; margin: 0; font-size: 22px; }

.back-btn {
  margin-top: 8px;
  background: rgba(255,255,255,0.08);
  color: #fff;
  border: 1px solid rgba(255,255,255,0.15);
  padding: 10px 22px;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  transition: background 0.2s;
}

.back-btn:hover { background: rgba(255,255,255,0.13); }

/* ─── Responsive ──────────────────────────────────────────── */
@media (max-width: 900px) {
  .content-container { padding: 36px 20px 80px; }
  .profile-main { flex-direction: column; align-items: center; text-align: center; }
  .album-name { font-size: 42px; }
  .cover-wrap { width: 160px; height: 160px; }
  .stats-row { justify-content: center; }
  .header-actions { justify-content: center; }
  .track-row,
  .tracks-list-header { grid-template-columns: 36px 1fr 68px 36px; }
}

@media (max-width: 480px) {
  .track-row,
  .tracks-list-header { grid-template-columns: 32px 1fr 56px; }
  .t-actions { display: none; }
}

</style>
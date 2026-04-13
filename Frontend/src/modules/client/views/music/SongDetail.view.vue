<template>
  <div class="song-detail-page">

    <!-- Loading -->
    <div v-if="songStore.loading" class="loading-wrap">
      <div class="skeleton-hero"></div>
      <div class="skeleton-body">
        <div class="skeleton-block" v-for="n in 4" :key="n"></div>
      </div>
    </div>

    <!-- Error -->
    <div v-else-if="songStore.error" class="error-state">
      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#f87171" stroke-width="1.5">
        <circle cx="12" cy="12" r="10" />
        <line x1="12" y1="8" x2="12" y2="12" />
        <line x1="12" y1="16" x2="12.01" y2="16" />
      </svg>
      <p>{{ songStore.error }}</p>
      <button @click="loadSong">Retry</button>
    </div>

    <!-- Immersive Backdrop -->
    <div class="page-backdrop" v-if="song">
      <div class="backdrop-image" :style="{ backgroundImage: `url(${song.cover_url})` }"></div>
      <div class="backdrop-overlay"></div>
    </div>

    <div class="content-wrapper">
      <!-- Top Navigation -->
      <nav class="top-nav">
        <button class="back-link" @click="$router.back()">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <polyline points="15 18 9 12 15 6" />
          </svg>
          <span class="back-text">Back</span>
        </button>
      </nav>

      <div class="main-layout" v-if="song">
        <!-- Left: Media & Primary Actions -->
        <aside class="media-column">
          <div class="sticky-media">
            <div class="cover-art-box">
              <img :src="song.cover_url" :alt="song.title" class="main-cover" />
              <div class="cover-shine"></div>
            </div>

            <div class="primary-controls">
              <button class="main-play-btn" @click="handlePlay">
                <svg v-if="player.currentSong?.id === song.id && player.isPlaying" width="32" height="32"
                  viewBox="0 0 24 24" fill="currentColor">
                  <rect x="6" y="4" width="4" height="16" rx="1" />
                  <rect x="14" y="4" width="4" height="16" rx="1" />
                </svg>
                <svg v-else width="32" height="32" viewBox="0 0 24 24" fill="currentColor">
                  <polygon points="5 3 19 12 5 21 5 3" />
                </svg>
              </button>

              <div class="song-header-info">
                <h1 class="song-title-large">{{ song.title }}</h1>
                <div class="artist-link" v-if="song.artist">
                  <div class="mini-avatar" :style="{ backgroundImage: `url(${song.artist.avatar_url})` }"></div>
                  <span class="artist-name-link">{{ song.artist.name }}</span>
                </div>
              </div>
            </div>

            <!-- Listening Progress (Synced with Global Player) -->
            <div class="sync-progress" v-if="player.currentSong?.id === song.id">
              <div class="progress-labels">
                <span>{{ formatTime(player.currentTime) }}</span>
                <span>{{ formatTime(player.duration) }}</span>
              </div>
              <div class="progress-track">
                <div class="progress-fill" :style="{ width: (player.currentTime / player.duration * 100) + '%' }"></div>
              </div>
            </div>

            <div class="action-badges">
              <span v-if="song.is_premium" class="badge-item platinum">Premium</span>
              <span v-if="song.is_explicit" class="badge-item explicit">E</span>
              <span class="badge-item genre-chip" :style="{ borderColor: song.genre?.color, color: song.genre?.color }">
                {{ song.genre?.name }}
              </span>
            </div>
          </div>
        </aside>

        <!-- Right: Lyrics & Insights -->
        <main class="data-column">
          <!-- Lyrics Section -->
          <section class="lyrics-section" v-if="song.lyrics">
            <h2 class="column-title">Lyrics</h2>
            <div class="lyrics-card">
              <pre class="lyrics-text">{{ song.lyrics }}</pre>
            </div>
          </section>

          <!-- Insights / Stats -->
          <section class="insights-section">
            <h2 class="column-title">Insights</h2>
            <div class="insights-grid">
              <div class="insight-tile">
                <span class="tile-val">{{ formatNumber(song.stats.total_plays) }}</span>
                <span class="tile-label">Total Streams</span>
              </div>
              <div class="insight-tile">
                <span class="tile-val">{{ formatNumber(song.stats.total_likes) }}</span>
                <span class="tile-label">Fan Likes</span>
              </div>
              <div class="insight-tile">
                <span class="tile-val">{{ formatNumber(song.stats.total_comments) }}</span>
                <span class="tile-label">Discussion</span>
              </div>
              <div class="insight-tile">
                <span class="tile-val">{{ formatNumber(song.stats.total_shares) }}</span>
                <span class="tile-label">Global Shares</span>
              </div>
            </div>
          </section>

          <!-- Metadata Sidebar-like entries -->
          <section class="meta-section">
            <h2 class="column-title">Technical Info</h2>
            <div class="meta-grid">
              <div class="meta-entry" v-if="song.isrc">
                <label>ISRC</label>
                <div class="val">{{ song.isrc }}</div>
              </div>
              <div class="meta-entry" v-if="song.quality">
                <label>Audio Quality</label>
                <div class="val">{{ song.quality.toUpperCase() }}</div>
              </div>
              <div class="meta-entry" v-if="song.bitrate">
                <label>Bitrate</label>
                <div class="val">{{ song.bitrate }} kbps</div>
              </div>
              <div class="meta-entry" v-if="song.file_size">
                <label>File Size</label>
                <div class="val">{{ formatBytes(song.file_size) }}</div>
              </div>
              <div class="meta-entry">
                <label>Released</label>
                <div class="val">{{ formatDate(song.created_at) }}</div>
              </div>
            </div>
          </section>

          <!-- More From Artist -->
          <section class="more-section" v-if="artistSongs.length > 0">
            <h2 class="column-title">More From {{ song.artist?.name }}</h2>
            <div class="artist-songs-list">
              <div 
                v-for="s in artistSongs.filter(as => as.id !== song.id).slice(0, 5)" 
                :key="s.id" 
                class="mini-song-row"
                @click="$router.push({ name: 'client.song.detail', params: { id: s.slug } })"
              >
                <img :src="s.cover_url" class="mini-cover-img" />
                <div class="mini-info">
                  <div class="mini-title">{{ s.title }}</div>
                  <div class="mini-meta">{{ formatNumber(s.stats.total_plays) }} plays</div>
                </div>
                <button class="mini-play-btn" @click.stop="player.play(s, artistSongs)">
                  <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                    <polygon points="5 3 19 12 5 21 5 3"/>
                  </svg>
                </button>
              </div>
              <button 
                class="view-all-btn" 
                @click="$router.push({ name: 'client.artist.detail', params: { slug: song.artist?.slug } })"
              >
                View Artist Profile
              </button>
            </div>
          </section>
        </main>
      </div>
    </div>
  </div>
</template>


<script setup lang="ts">
import { onMounted, computed, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useSongStore } from '@/modules/client/stores/songs/songsStore'
import { usePlayerStore } from '@/store/playerStore'
import ArtistService from '@/modules/client/services/artists/artists.service'
import type { Song } from '@/interfaces/songs.interface'

const route      = useRoute()
const songStore  = useSongStore()
const player     = usePlayerStore()

const song = computed<Song | null>(() => songStore.currentSong)
const artistSongs = ref<Song[]>([])

const handlePlay = () => {
  if (song.value) {
    player.play(song.value, [song.value])
  }
}

// ── Helpers ──
const formatTime = (s: number) => {
  if (!s || isNaN(s)) return '0:00'
  const m = Math.floor(s / 60)
  const sec = Math.floor(s % 60)
  return `${m}:${String(sec).padStart(2, '0')}`
}

const formatNumber = (n: number) =>
  n >= 1_000_000 ? (n / 1_000_000).toFixed(1) + 'M'
    : n >= 1_000 ? (n / 1_000).toFixed(1) + 'K'
      : String(n)

const formatDate = (iso: string) =>
  new Date(iso).toLocaleDateString('vi-VN', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  })

const formatBytes = (bytes: number) =>
  bytes >= 1024 * 1024
    ? (bytes / (1024 * 1024)).toFixed(2) + ' MB'
    : (bytes / 1024).toFixed(1) + ' KB'

const loadSong = async () => {
  const idOrSlug = route.params.id as string
  await songStore.fetchSong(idOrSlug)
  
  if (song.value?.artist?.slug) {
    fetchArtistSongs(song.value.artist.slug)
  }
}

const fetchArtistSongs = async (slug: string) => {
  try {
    const res = await ArtistService.detailArtist(slug)
    // The fixed API now returns songs resolved in 'data.songs'
    artistSongs.value = res.data.data.songs || []
  } catch (err) {
    console.error('Failed to fetch artist songs:', err)
  }
}

watch(() => route.params.id, () => {
  loadSong()
})

onMounted(() => loadSong())
</script>

<style scoped>
.song-detail-page {
  min-height: 100vh;
}

/* ── Loading ── */
.loading-wrap {
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.skeleton-hero {
  height: 280px;
  border-radius: 16px;
  background: linear-gradient(90deg, #1e2535 25%, #2d3748 50%, #1e2535 75%);
  background-size: 200% 100%;
  animation: shimmer 1.4s infinite;
}

.skeleton-body {
  display: grid;
  grid-template-columns: 1fr 320px;
  gap: 16px;
}

.skeleton-block {
  height: 120px;
  border-radius: 12px;
  background: linear-gradient(90deg, #1e2535 25%, #2d3748 50%, #1e2535 75%);
  background-size: 200% 100%;
  animation: shimmer 1.4s infinite;
}

@keyframes shimmer {
  0% {
    background-position: 200% 0;
  }

  100% {
    background-position: -200% 0;
  }
}

/* ── Error ── */
.error-state {
  text-align: center;
  padding: 60px 20px;
  color: #f87171;
}

.error-state p {
  margin: 12px 0;
  font-size: 14px;
}

.error-state button {
  padding: 8px 24px;
  background: rgba(248, 113, 113, .1);
  border: 1px solid #f87171;
  border-radius: 8px;
  color: #f87171;
  cursor: pointer;
}

/* ── Hero ── */
.hero {
  position: relative;
  border-radius: 16px;
  overflow: hidden;
  margin-bottom: 20px;
}

.hero__backdrop {
  position: absolute;
  inset: 0;
  background: var(--hero-gradient);
  opacity: .15;
}

.hero__content {
  position: relative;
  padding: 24px;
}

.btn-back {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 7px 14px;
  background: rgba(0, 0, 0, .25);
  border: 1px solid rgba(255, 255, 255, .1);
  border-radius: 8px;
  color: #94a3b8;
  font-size: 13px;
  cursor: pointer;
  margin-bottom: 20px;
  transition: color .2s;
}

.btn-back:hover {
  color: #e2e8f0;
}

.hero__main {
  display: flex;
  align-items: flex-start;
  gap: 28px;
}

/* Cover */
.cover-wrap {
  flex-shrink: 0;
}

.cover {
  width: 180px;
  height: 180px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
  cursor: pointer;
}

.cover__icon {
  display: flex;
  align-items: center;
  justify-content: center;
}

.cover__overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, .35);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity .2s;
}

.cover:hover .cover__overlay {
  opacity: 1;
}

.cover__play-btn {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: rgba(255, 255, 255, .2);
  border: 2px solid rgba(255, 255, 255, .5);
  display: flex;
  align-items: center;
  justify-content: center;
}

/* Info */
.hero__info {
  flex: 1;
}

.hero__badges {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 10px;
}

.hero__title {
  font-size: 28px;
  font-weight: 700;
  color: #f1f5f9;
  line-height: 1.2;
  margin-bottom: 10px;
}

.hero__artist {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #94a3b8;
  margin-bottom: 14px;
}

.artist-avatar {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: linear-gradient(135deg, #00c6ff, #0072ff);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 700;
  color: #fff;
  flex-shrink: 0;
}

.hero__album {
  color: #64748b;
}

.hero__meta-row {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 18px;
}

.meta-chip {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 5px 10px;
  background: rgba(0, 0, 0, .2);
  border: 1px solid #1e2535;
  border-radius: 20px;
  font-size: 12px;
  color: #64748b;
}

.hero__actions {
  display: flex;
  gap: 10px;
}

.btn-edit {
  display: flex;
  align-items: center;
  gap: 7px;
  padding: 9px 18px;
  background: linear-gradient(90deg, #00c6ff, #0072ff);
  border: none;
  border-radius: 9px;
  color: #fff;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: opacity .2s;
}

.btn-edit:hover {
  opacity: .85;
}

.btn-delete {
  display: flex;
  align-items: center;
  gap: 7px;
  padding: 9px 18px;
  background: rgba(248, 113, 113, .1);
  border: 1px solid rgba(248, 113, 113, .3);
  border-radius: 9px;
  color: #f87171;
  font-size: 13px;
  cursor: pointer;
  transition: all .2s;
}

.btn-delete:hover {
  background: rgba(248, 113, 113, .2);
}

/* Badges */
.status-badge {
  display: inline-block;
  padding: 3px 10px;
  border-radius: 20px;
  font-size: 11.5px;
  font-weight: 600;
  text-transform: capitalize;
}

.status--published {
  background: rgba(67, 233, 123, .15);
  color: #43e97b;
}

.status--draft {
  background: rgba(100, 116, 139, .15);
  color: #64748b;
}

.status--blocked {
  background: rgba(248, 113, 113, .15);
  color: #f87171;
}

.status--processing {
  background: rgba(251, 191, 36, .15);
  color: #fbbf24;
}

.status--processing_failed {
  background: rgba(248, 113, 113, .15);
  color: #f87171;
}

.flag-badge {
  display: inline-block;
  padding: 3px 10px;
  border-radius: 20px;
  font-size: 11.5px;
}

.flag--premium {
  background: rgba(251, 191, 36, .12);
  color: #fbbf24;
}

.flag--explicit {
  background: rgba(248, 113, 113, .12);
  color: #f87171;
}

.flag--featured {
  background: rgba(251, 146, 60, .12);
  color: #fb923c;
}

/* ── Body ── */
.detail-body {
  display: grid;
  grid-template-columns: 1fr 300px;
  gap: 20px;
  align-items: start;
}

/* ── Section ── */
.card-section {
  background: rgba(0, 0, 0, .2);
  border: 1px solid #1e2535;
  border-radius: 14px;
  padding: 20px;
  margin-bottom: 16px;
}

.section-heading {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 16px;
}

.section-icon {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.section-icon--green {
  background: rgba(67, 233, 123, .12);
  color: #43e97b;
}

.section-icon--blue {
  background: rgba(0, 198, 255, .12);
  color: #00c6ff;
}

.section-icon--purple {
  background: rgba(167, 139, 250, .12);
  color: #a78bfa;
}

.section-icon--orange {
  background: rgba(251, 146, 60, .12);
  color: #fb923c;
}

.section-icon--pink {
  background: rgba(244, 114, 182, .12);
  color: #f472b6;
}

.section-icon--teal {
  background: rgba(45, 212, 191, .12);
  color: #2dd4bf;
}

.section-title {
  font-size: 15px;
  font-weight: 600;
  color: #f1f5f9;
}

/* ── Player ── */
.quality-tabs {
  display: flex;
  gap: 8px;
  margin-bottom: 16px;
}

.quality-tab {
  flex: 1;
  padding: 10px 12px;
  background: #0f1117;
  border: 1px solid #2d3748;
  border-radius: 10px;
  cursor: pointer;
  text-align: left;
  transition: all .2s;
}

.quality-tab.active {
  border-color: #00c6ff;
  background: rgba(0, 198, 255, .08);
}

.quality-tab.disabled {
  opacity: .45;
  cursor: not-allowed;
}

.quality-tab__label {
  display: block;
  font-size: 13px;
  font-weight: 600;
  color: #e2e8f0;
}

.quality-tab__sub {
  display: block;
  font-size: 11px;
  color: #64748b;
  margin-top: 2px;
}

.quality-tab__lock {
  display: block;
  font-size: 11px;
  margin-top: 2px;
}

.player-wrap {
  background: #0f1117;
  border: 1px solid #1e2535;
  border-radius: 12px;
  padding: 16px;
}

.waveform {
  display: flex;
  align-items: flex-end;
  gap: 2px;
  height: 48px;
  margin-bottom: 12px;
}

.wave-bar {
  flex: 1;
  background: #2d3748;
  border-radius: 2px;
  min-height: 3px;
  transition: background .1s;
}

.wave-bar.played {
  background: linear-gradient(180deg, #00c6ff, rgba(0, 114, 255, .4));
}

.player-progress {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
}

.player-time {
  font-size: 11.5px;
  color: #64748b;
  min-width: 36px;
}

.seek-bar {
  flex: 1;
  height: 3px;
  accent-color: #00c6ff;
  cursor: pointer;
}

.player-controls {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
}

.ctrl-btn {
  background: none;
  border: none;
  color: #94a3b8;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  padding: 6px;
  transition: color .2s;
}

.ctrl-btn:hover {
  color: #e2e8f0;
}

.ctrl-btn--play {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: linear-gradient(90deg, #00c6ff, #0072ff);
  color: white;
}

.ctrl-btn--play:hover {
  opacity: .85;
}

.volume-wrap {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-left: 8px;
}

.volume-bar {
  width: 70px;
  height: 3px;
  accent-color: #00c6ff;
  cursor: pointer;
}

.player-no-url {
  text-align: center;
  padding: 20px;
  color: #64748b;
  font-size: 13px;
}

.url-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-top: 12px;
}

.url-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #0f1117;
  border: 1px solid #1e2535;
  border-radius: 8px;
  padding: 8px 12px;
  gap: 12px;
}

.url-item__left {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}

.url-badge {
  padding: 2px 8px;
  border-radius: 6px;
  font-size: 11px;
  font-weight: 600;
}

.url-badge--low {
  background: rgba(100, 116, 139, .15);
  color: #94a3b8;
}

.url-badge--standard {
  background: rgba(0, 198, 255, .12);
  color: #00c6ff;
}

.url-badge--lossless {
  background: rgba(167, 139, 250, .12);
  color: #a78bfa;
}

.url-item__desc {
  font-size: 11.5px;
  color: #64748b;
}

.url-item__url {
  font-size: 11px;
  color: #334155;
  font-family: monospace;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 300px;
}

.url-item__null {
  font-size: 11px;
  color: #334155;
  font-style: italic;
}

/* ── Lyrics ── */
.lyrics-block {
  white-space: pre-wrap;
  font-size: 13.5px;
  line-height: 1.9;
  color: #94a3b8;
  font-family: inherit;
  background: #0f1117;
  border: 1px solid #1e2535;
  border-radius: 10px;
  padding: 16px;
  max-height: 400px;
  overflow-y: auto;
}

/* ── Stats ── */
.stats-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
}

.stat-card {
  background: #0f1117;
  border: 1px solid #1e2535;
  border-radius: 10px;
  padding: 14px;
  text-align: center;
}

.stat-card--full {
  grid-column: 1 / -1;
}

.stat-value {
  font-size: 22px;
  font-weight: 700;
  color: #00c6ff;
}

.stat-label {
  font-size: 11.5px;
  color: #64748b;
  margin-top: 3px;
  text-transform: uppercase;
  letter-spacing: .05em;
}

/* ── Meta list ── */
.meta-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.meta-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 7px 0;
  border-bottom: 1px solid #1e2535;
}

.meta-row:last-child {
  border-bottom: none;
}

.meta-key {
  font-size: 12px;
  color: #64748b;
  font-weight: 500;
}

.meta-val {
  font-size: 12.5px;
  color: #94a3b8;
  text-align: right;
}

.meta-val--mono {
  font-family: monospace;
  font-size: 11.5px;
}

/* ── Artist / Album card ── */
.artist-card {
  display: flex;
  align-items: center;
  gap: 12px;
}

.artist-card__avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: linear-gradient(135deg, #00c6ff, #0072ff);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  font-weight: 700;
  color: #fff;
  flex-shrink: 0;
}

.artist-card__name {
  font-size: 14px;
  font-weight: 600;
  color: #f1f5f9;
}

.artist-card__slug {
  font-size: 12px;
  color: #64748b;
  margin-top: 2px;
}

.album-card {
  display: flex;
  align-items: center;
  gap: 12px;
}

.album-card__cover {
  width: 48px;
  height: 48px;
  border-radius: 8px;
  background: linear-gradient(135deg, #a78bfa, #7c3aed);
  flex-shrink: 0;
}

.album-card__title {
  font-size: 14px;
  font-weight: 600;
  color: #f1f5f9;
}

.album-card__slug {
  font-size: 12px;
  color: #64748b;
  margin-top: 2px;
}

.genre-tag {
  display: inline-block;
  padding: 4px 10px;
  font-size: 11px;
  font-weight: 500;
  border-radius: 999px;
  border: 1px solid;
  line-height: 1;
  white-space: nowrap;

  /* nền nhẹ theo màu */
  background-color: rgba(0, 0, 0, 0.05);
}

/* ── Responsive ── */
/* More section */
.more-section {
  margin-top: 20px;
}

.artist-songs-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.mini-song-row {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 12px;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.06);
  border-radius: 16px;
  cursor: pointer;
  transition: all 0.2s;
}

.mini-song-row:hover {
  background: rgba(255, 255, 255, 0.06);
  transform: translateX(5px);
}

.mini-cover-img {
  width: 48px;
  height: 48px;
  border-radius: 10px;
  object-fit: cover;
}

.mini-info {
  flex: 1;
}

.mini-title {
  font-size: 14px;
  font-weight: 700;
  color: #fff;
}

.mini-meta {
  font-size: 12px;
  color: #64748b;
  margin-top: 2px;
}

.mini-play-btn {
  width: 32px;
  height: 32px;
  background: rgba(59, 130, 246, 0.2);
  border: none;
  border-radius: 50%;
  color: #3b82f6;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
}

.mini-play-btn:hover {
  background: #3b82f6;
  color: #fff;
  transform: scale(1.1);
}

.view-all-btn {
  margin-top: 8px;
  width: 100%;
  padding: 14px;
  background: transparent;
  border: 1px dashed rgba(255, 255, 255, 0.15);
  border-radius: 16px;
  color: #94a3b8;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.view-all-btn:hover {
  border-style: solid;
  border-color: #3b82f6;
  color: #3b82f6;
  background: rgba(59, 130, 246, 0.05);
}

@media (max-width: 1100px) {
  .detail-body {
    grid-template-columns: 1fr;
  }

  .hero__main {
    flex-direction: column;
  }

  .quality-tabs {
    flex-wrap: wrap;
  }
}

@media (max-width: 640px) {
  .hero__title {
    font-size: 22px;
  }

  .cover {
    width: 140px;
    height: 140px;
  }

  .stats-grid {
    grid-template-columns: 1fr 1fr;
  }
}
</style>
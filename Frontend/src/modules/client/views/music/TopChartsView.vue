<template>
  <div class="top-charts-view">
    <!-- Immersive Backdrop -->
    <div class="charts-backdrop">
      <div v-if="featuredSong" class="backdrop-image" :style="{ backgroundImage: `url(${featuredSong.cover_url})` }"></div>
      <div class="backdrop-gradient"></div>
    </div>

    <!-- Main Content -->
    <div class="charts-content pb-24">
      <!-- Header -->
      <header class="charts-header">
        <button class="back-link-btn" @click="$router.back()">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <polyline points="15 18 9 12 15 6" />
          </svg>
          <span>Back</span>
        </button>
        <h1 class="charts-view-title">Music Charts</h1>
        <p class="charts-view-subtitle">Trending hits and community favorites</p>
      </header>

      <!-- Charts Grid -->
      <div class="charts-grid mt-12">
        
        <!-- Column 1: MOST PLAYED -->
        <section class="chart-column">
          <div class="column-header">
            <div class="header-icon bg-blue-500/10 text-blue-400">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M23 7l-7 5 7 5V7z"/><rect x="1" y="5" width="15" height="14" rx="2" ry="2"/>
              </svg>
            </div>
            <div>
              <h2 class="column-title">Most Played</h2>
              <p class="column-desc">Global stream count leaders</p>
            </div>
          </div>

          <div class="songs-container mt-6">
            <div 
              v-for="(song, index) in topPlayed" 
              :key="'played-' + song.id"
              class="song-item-card"
              :class="{ 'is-playing': player.currentSong?.id === song.id }"
              @click="handlePlay(song, topPlayed)"
            >
              <div class="song-rank">{{ index + 1 }}</div>
              <div class="song-cover-wrap">
                <img :src="song.cover_url || ''"  :alt="song.title" class="song-cover" />
                <div class="play-overlay">
                  <svg v-if="!(player.currentSong?.id === song.id && player.isPlaying)" fill="currentColor" viewBox="0 0 24 24" width="20" height="20">
                    <path d="M8 5v14l11-7z"/>
                  </svg>
                  <svg v-else fill="currentColor" viewBox="0 0 24 24" width="20" height="20">
                    <path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/>
                  </svg>
                </div>
              </div>
              <div class="song-info">
                <div class="song-title-row">
                  <span class="song-title">{{ song.title }}</span>
                  <span v-if="song.is_premium" class="premium-tag">Premium</span>
                </div>
                <span class="song-artist">{{ song.artist?.name || 'Unknown Artist' }}</span>
              </div>
              <div class="song-stats">
                <span class="stats-val">{{ formatNumber(song.stats?.total_plays || 0) }}</span>
                <span class="stats-label">plays</span>
              </div>
            </div>
          </div>
        </section>

        <!-- Column 2: MOST LIKED -->
        <section class="chart-column">
          <div class="column-header">
            <div class="header-icon bg-rose-500/10 text-rose-400">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
              </svg>
            </div>
            <div>
              <h2 class="column-title">Most Loved</h2>
              <p class="column-desc">Fan favorites of the community</p>
            </div>
          </div>

          <div class="songs-container mt-6">
            <div 
              v-for="(song, index) in topLiked" 
              :key="'liked-' + song.id"
              class="song-item-card"
              :class="{ 'is-playing': player.currentSong?.id === song.id }"
              @click="handlePlay(song, topLiked)"
            >
              <div class="song-rank">{{ index + 1 }}</div>
              <div class="song-cover-wrap">
                <img :src="song.cover_url|| ''" :alt="song.title" class="song-cover" />
                <div class="play-overlay">
                  <svg v-if="!(player.currentSong?.id === song.id && player.isPlaying)" fill="currentColor" viewBox="0 0 24 24" width="20" height="20">
                    <path d="M8 5v14l11-7z"/>
                  </svg>
                  <svg v-else fill="currentColor" viewBox="0 0 24 24" width="20" height="20">
                    <path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/>
                  </svg>
                </div>
              </div>
              <div class="song-info">
                <div class="song-title-row">
                  <span class="song-title">{{ song.title }}</span>
                  <span v-if="song.is_premium" class="premium-tag">Premium</span>
                </div>
                <span class="song-artist">{{ song.artist?.name || 'Unknown Artist' }}</span>
              </div>
              <div class="song-stats">
                <span class="stats-val text-rose-400">{{ formatNumber(song.stats?.total_likes || song.like_count || 0) }}</span>
                <span class="stats-label">likes</span>
              </div>
            </div>
          </div>
        </section>

      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, computed } from 'vue'
import { useSongStore } from '@/modules/client/stores/songs/songsStore'
import { usePlayerStore } from '@/store/playerStore'
import type { Song } from '@/interfaces/songs.interface'

const songStore = useSongStore()
const player = usePlayerStore()

const topPlayed = computed(() => songStore.popularSongs)
const topLiked = computed(() => songStore.topLikedSongs)

// Determine a featured song for the background blur
const featuredSong = computed(() => topPlayed.value[0] || topLiked.value[0] || null)

onMounted(async () => {
  // Fetch data
  Promise.all([
    songStore.fetchPopularSongs(20),
    songStore.fetchTopLikedSongs(20)
  ])
})

const formatNumber = (n: number) =>
  n >= 1_000_000 ? (n / 1_000_000).toFixed(1) + 'M'
    : n >= 1_000 ? (n / 1_000).toFixed(1) + 'K'
      : String(n)

const handlePlay = (song: Song, queue: Song[]) => {
  if (player.currentSong?.id === song.id) {
    player.isPlaying 
  } else {
    player.play(song, queue)
  }
}
</script>

<style scoped>
.top-charts-view {
  min-height: 100vh;
  position: relative;
  overflow-x: hidden;
}

/* ─── Backdrop ────────────────────────────────────────── */
.charts-backdrop {
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 36vh;
  z-index: 0;
  pointer-events: none;
}

.backdrop-image {
  width: 100%; height: 100%;
  background-size: cover;
  background-position: center;
  filter: blur(100px) saturate(1.8) opacity(0.25);
  transform: scale(1.3);
}

.backdrop-gradient {
  position: absolute;
  inset: 0;
  background: linear-gradient(to bottom, transparent 0%, #080e14 100%);
}

/* ─── Content ─────────────────────────────────────────── */
.charts-content {
  position: relative;
  z-index: 1;
  max-width: 1300px;
  margin: 0 auto;
  padding: 40px 40px 100px;
}

/* ─── Header ──────────────────────────────────────────── */
.charts-header {
  margin-top: 20px;
}

.back-link-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: rgba(255, 255, 255, 0.04);
  border: 1px solid rgba(255, 255, 255, 0.08);
  color: rgba(255, 255, 255, 0.6);
  padding: 8px 16px;
  border-radius: 99px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  margin-bottom: 30px;
  transition: all 0.2s;
}

.back-link-btn:hover {
  background: rgba(255, 255, 255, 0.08);
  color: #fff;
  transform: translateX(-4px);
}

.charts-view-title {
  font-size: clamp(40px, 6vw, 64px);
  font-weight: 950;
  color: #fff;
  letter-spacing: -0.04em;
  margin: 0;
  line-height: 1;
}

.charts-view-subtitle {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.45);
  margin-top: 12px;
  font-weight: 500;
}

/* ─── Grid ────────────────────────────────────────────── */
.charts-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 40px;
}

.chart-column {
  animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) both;
}

.chart-column:last-child {
  animation-delay: 0.15s;
}

@keyframes slideUp {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: translateY(0); }
}

.column-header {
  display: flex;
  align-items: center;
  gap: 16px;
  padding-bottom: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.header-icon {
  width: 48px;
  height: 48px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.column-title {
  font-size: 20px;
  font-weight: 800;
  color: #fff;
  margin: 0;
}

.column-desc {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.4);
  margin-top: 2px;
}

/* ─── Song Item Card ──────────────────────────────────── */
.songs-container {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.song-item-card {
  display: grid;
  grid-template-columns: 40px 60px 1fr 80px;
  align-items: center;
  gap: 16px;
  padding: 12px;
  border-radius: 18px;
  cursor: pointer;
  background: rgba(255, 255, 255, 0.02);
  border: 1px solid transparent;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}

.song-item-card:hover {
  background: rgba(255, 255, 255, 0.05);
  border-color: rgba(255, 255, 255, 0.08);
  transform: translateX(4px);
}

.song-item-card.is-playing {
  background: rgba(0, 170, 255, 0.08);
  border-color: rgba(0, 170, 255, 0.15);
}

.song-rank {
  font-size: 16px;
  font-weight: 900;
  color: rgba(255, 255, 255, 0.15);
  text-align: center;
  font-variant-numeric: tabular-nums;
}

.is-playing .song-rank {
  color: #00aaff;
}

.song-cover-wrap {
  position: relative;
  width: 60px;
  height: 60px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 16px rgba(0,0,0,0.3);
}

.song-cover {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.play-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  opacity: 0;
  transition: opacity 0.2s;
}

.song-item-card:hover .play-overlay,
.is-playing .play-overlay {
  opacity: 1;
}

.song-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.song-title-row {
  display: flex;
  align-items: center;
  gap: 8px;
  min-width: 0;
}

.song-title {
  font-size: 15px;
  font-weight: 700;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.is-playing .song-title {
  color: #00aaff;
}

.premium-tag {
  font-size: 9px;
  font-weight: 800;
  text-transform: uppercase;
  background: rgba(251, 191, 36, 0.12);
  color: #fbbf24;
  padding: 1px 4px;
  border-radius: 4px;
  border: 1px solid rgba(251, 191, 36, 0.2);
  flex-shrink: 0;
}

.song-artist {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.4);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.song-stats {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 2px;
}

.stats-val {
  font-size: 14px;
  font-weight: 800;
  color: #3b82f6;
  font-variant-numeric: tabular-nums;
}

.stats-label {
  font-size: 10px;
  font-weight: 700;
  color: rgba(255, 255, 255, 0.25);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

/* ─── Responsive ──────────────────────────────────────── */
@media (max-width: 1024px) {
  .charts-grid { grid-template-columns: 1fr; gap: 60px; }
  .charts-content { padding: 40px 24px 100px; }
}

@media (max-width: 640px) {
  .song-item-card {
    grid-template-columns: 30px 50px 1fr 70px;
    gap: 12px;
    padding: 10px;
  }
  .song-cover-wrap { width: 50px; height: 50px; }
  .song-title { font-size: 14px; }
  .charts-view-title { font-size: 40px; }
}
</style>

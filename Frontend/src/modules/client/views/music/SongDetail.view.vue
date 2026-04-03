<template>
  <div class="song-detail">
    <!-- Ambient background -->
    <div class="ambient-bg" :style="{ background: heroGradient }"></div>
    
    <!-- Subtle particles -->
    <div class="particles">
      <div v-for="i in 12" :key="i" class="particle" :style="getParticleStyle(i)"></div>
    </div>

    <!-- Loading -->
    <div v-if="songStore.loading" class="loading-state">
      <div class="loading-spinner"></div>
      <p>Loading masterpiece...</p>
    </div>

    <!-- Error -->
    <div v-else-if="songStore.error" class="error-state">
      <div class="error-icon">🎵</div>
      <p>{{ songStore.error }}</p>
      <button @click="loadSong">Retry</button>
    </div>

    <!-- Main Content -->
    <template v-else-if="song">
      <div class="content-wrapper">
        
        <!-- Header Navigation -->
        <div class="nav-header">
          <button class="nav-btn" @click="$router.back()">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <polyline points="15 18 9 12 15 6"/>
            </svg>
            Back
          </button>
        </div>

        <!-- Main Grid -->
        <div class="main-grid">
          
          <!-- LEFT: Record Player -->
          <div class="hero-section">
            <!-- Record Player Container -->
            <div class="record-player-wrapper">
              <!-- Cover Art with Play Overlay -->
              <div class="cover-container">
                <div class="cover-glow"></div>
                <div 
                  class="cover-art" 
                  :class="{ spinning: isCurrentSongPlaying(song) && player.isPlaying }"
                  :style="coverStyle"
                >
                  <div class="vinyl-grooves"></div>
                  <div class="cover-overlay"></div>
                  
                  <!-- Play Button Overlay -->
                  <div 
                    class="play-overlay"
                    :class="{ 
                      'visible': isCurrentSongPlaying(song) && !player.isPlaying,
                      'playing': isCurrentSongPlaying(song) && player.isPlaying
                    }"
                    @click="playSong(song)"
                  >
                    <!-- Play icon -->
                    <svg 
                      v-if="!isCurrentSongPlaying(song) || !player.isPlaying" 
                      width="28" 
                      height="28" 
                      viewBox="0 0 24 24" 
                      fill="currentColor"
                    >
                      <path d="M8 5v14l11-7z" />
                    </svg>
                    <!-- Pause icon -->
                    <svg 
                      v-else 
                      width="28" 
                      height="28" 
                      viewBox="0 0 24 24" 
                      fill="currentColor"
                    >
                      <rect x="6" y="4" width="4" height="16" rx="1" />
                      <rect x="14" y="4" width="4" height="16" rx="1" />
                    </svg>
                  </div>
                </div>

                <!-- Tonearm -->
                <div class="tonearm-wrapper">
                  <svg class="tonearm" :class="{ playing: isCurrentSongPlaying(song) && player.isPlaying }" width="180" height="180" viewBox="0 0 200 200">
                    <path d="M38,138 L38,138" stroke="none" fill="none"/>
                    <circle cx="40" cy="138" r="8" fill="#555" stroke="#333" stroke-width="2"/>
                    <line x1="40" y1="138" x2="120" y2="70" stroke="#999" stroke-width="4" stroke-linecap="round"/>
                    <circle cx="120" cy="70" r="6" fill="#777" stroke="#555" stroke-width="1.5"/>
                    <path d="M120,70 L125,90 L115,90 Z" fill="#888"/>
                  </svg>
                </div>
              </div>
            </div>

            <!-- Song Info -->
            <div class="song-info">
              <div class="badge-strip">
                <span class="badge" :class="`badge-${song.status}`">{{ song.status }}</span>
                <span v-if="song.is_explicit" class="badge badge-explicit">EXPLICIT</span>
                <span v-if="song.is_premium" class="badge badge-premium">PREMIUM</span>
                <span 
                  v-if="song.genre && song.genre.color" 
                  class="badge badge-genre" 
                  :style="{ borderColor: song.genre.color }"
                >
                  {{ song.genre.name }}
                </span>
              </div>

              <h1 class="song-title">{{ song.title }}</h1>

              <div class="artist-row" @click="goToArtist">
                <div class="artist-avatar" :style="artistAvatarStyle">
                  <span v-if="!song.artist?.avatar_url">
                    <img
                      :src="getArtistAvatar(song.artist)"
                      :alt="song.artist?.name"
                      class="object-cover w-full h-full transition duration-300 group-hover:brightness-75"
                      @error="handleImageError"
                    />
                  </span>
                </div>
                <div class="artist-details">
                  <span class="artist-name">{{ song.artist?.name || 'Unknown Artist' }}</span>&nbsp
                  <span v-if="song.year" class="artist-year">{{ song.year }}</span>
                </div>
              </div>
            </div>

            <!-- Stats -->
            <div class="stats-strip">
              <div class="stat-item">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                </svg>
                <span>{{ formatNumber(song.stats?.total_likes || 0) }}</span>
              </div>
              <div class="stat-item">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                  <polygon points="5 3 19 12 5 21 5 3"/>
                </svg>
                <span>{{ formatNumber(song.stats?.total_plays || 0) }}</span>
              </div>
              <div class="stat-item">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
                </svg>
                <span>{{ formatNumber(song.stats?.total_comments || 0) }}</span>
              </div>
            </div>

            <!-- Album Card -->
            <div class="card info-card" v-if="song.album" @click="goToAlbum">
              <div class="card-icon">
                <div class="album-thumb" :style="albumThumbStyle"></div>
              </div>
              <div class="card-content">
                <span class="card-label">From Album</span>
                <span class="card-value">{{ song.album.title }}</span>
              </div>
            </div>
          </div>

          <!-- RIGHT: Lyrics thuần -->
          <div class="lyrics-section">
            <div v-if="song.lyrics" class="lyrics-scroll">
              <pre class="lyrics-text">{{ song.lyrics }}</pre>
            </div>
            <div v-else class="empty-state">
              <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                <polyline points="14 2 14 8 20 8"/>
              </svg>
              <p>No lyrics available for this track</p>
            </div>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useSongStore } from '@/modules/client/stores/songs/songsStore'
import {getFullImageUrl } from '@/modules/client/stores/artists/artistsStore';
import type { Song } from '@/interfaces/songs.interface'
import {ArtistInterface} from '@/interfaces/artists.interface';
import { usePlayerStore } from '@/store/playerStore'

const route = useRoute()
const router = useRouter()
const songStore = useSongStore()
const player = usePlayerStore()

type Artist = ArtistInterface;

const song = computed<Song | null>(() => songStore.currentSong)

// Gradient mapping
const gradients = [
  'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
  'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
  'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
  'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)',
  'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
  'linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%)',
]

const heroGradient = computed(() => gradients[(song.value?.id ?? 0) % gradients.length])

const coverStyle = computed(() => {
  if (song.value?.cover_url) {
    return {
      backgroundImage: `url(${song.value.cover_url})`,
      backgroundSize: 'cover',
      backgroundPosition: 'center'
    }
  }
  return { background: heroGradient.value }
})

const artistAvatarStyle = computed(() => {
  if (song.value?.artist?.avatar_url) {
    return {
      backgroundImage: `url(${song.value.artist.avatar_url})`,
      backgroundSize: 'cover'
    }
  }
  return {}
})

const albumThumbStyle = computed(() => {
  if (song.value?.album?.cover_url) {
    return {
      backgroundImage: `url(${song.value.album.cover_url})`,
      backgroundSize: 'cover'
    }
  }
  return { background: heroGradient.value }
})


const getArtistAvatar = (artist: any) => {
  if (!artist?.avatar_url) return '/images/default-avatar.png'
  return getFullImageUrl(artist.avatar_url)
}



const handleImageError = (event: Event) => {
  const img = event.target as HTMLImageElement
  img.src = '/images/default-avatar.png'
}

// Particle effects
const getParticleStyle = (i: number) => ({
  left: `${Math.random() * 100}%`,
  animationDelay: `${Math.random() * 6}s`,
  animationDuration: `${4 + Math.random() * 5}s`,
  opacity: 0.08 + Math.random() * 0.25
})

// Navigation
const goToArtist = () => {
  if (song.value?.artist?.id) {
    router.push({ name: 'client.artist.songs', params: { slug: song.value.artist.slug } })
  }
}

const goToAlbum = () => {
  if (song.value?.album?.id) {
    // router.push({ name: 'client.album.detail', params: { id: song.value.album.id } })
  }
}

// Helpers
const formatNumber = (n: number) => {
  if (n >= 1_000_000) return (n / 1_000_000).toFixed(1) + 'M'
  if (n >= 1_000) return (n / 1_000).toFixed(1) + 'K'
  return String(n)
}

const playSong = (song: Song) => {
  player.play(song, songStore.songs)
}

const isCurrentSongPlaying = (song: Song): boolean => {
  return player.currentSong?.id === song.id;
};

// Load song
const loadSong = async () => {
  const id = route.params.id as string
  if (!id || id === 'undefined') return
  await songStore.fetchSong(id)
}

onMounted(() => {
  loadSong()
})
</script>

<style scoped>
/* Modern CSS - Siêu sạch, tối giản */
.song-detail {
  --primary: #3b82f6;
  --primary-dark: #4f46e5;
  --secondary: #8b5cf6;
  --bg-dark: #0a0a0f;
  --bg-surface: #111115;
  --bg-elevated: #1a1a22;
  --text-primary: #ffffff;
  --text-secondary: #a1a1aa;
  --text-muted: #52525b;
  --border: rgba(255, 255, 255, 0.08);
  --radius: 24px;
  --transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: 20px;
  min-height: 100vh;
  background: var(--bg-dark);
  position: relative;
  overflow-x: hidden;
}

/* Ambient + Particles */
.ambient-bg {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  opacity: 0.12;
  filter: blur(140px);
  pointer-events: none;
  z-index: 0;
}

.particles {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  pointer-events: none;
  z-index: 0;
}

.particle {
  position: absolute;
  bottom: -30px;
  width: 3px;
  height: 3px;
  background: linear-gradient(135deg, var(--primary), var(--secondary));
  border-radius: 50%;
  opacity: 0;
  animation: floatUp linear infinite;
}

@keyframes floatUp {
  0% { transform: translateY(0) rotate(0deg); opacity: 0; }
  15% { opacity: 0.6; }
  85% { opacity: 0.6; }
  100% { transform: translateY(-110vh) rotate(380deg); opacity: 0; }
}

/* Content */
.content-wrapper {
  position: relative;
  z-index: 1;
  max-width: 1480px;
  margin: 0 auto;
  padding: 28px 40px 80px;
}

.nav-header {
  display: flex;
  align-items: center;
  margin-bottom: 48px;
  padding-bottom: 20px;
  border-bottom: 1px solid var(--border);
}

.nav-btn {
  width: 110px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: 14px;
  color: var(--text-secondary);
  font-weight: 500;
  transition: var(--transition);
}

.nav-btn:hover {
  background: var(--bg-elevated);
  color: var(--text-primary);
  transform: translateX(-3px);
}

/* Grid - Bên trái đã thu nhỏ (380px) */
.main-grid {
  display: grid;
  grid-template-columns: 380px 1fr;
  gap: 64px;
  align-items: start;
}

/* Record Player Wrapper */
.record-player-wrapper {
  margin-bottom: 32px;
}

.cover-container {
  position: relative;
  width: 320px;
  margin: 0 auto;
}

.cover-glow {
  position: absolute;
  inset: -40px;
  background: radial-gradient(circle, rgba(99, 102, 241, 0.4) 0%, transparent 70%);
  border-radius: 50%;
  filter: blur(60px);
  opacity: 0.75;
  pointer-events: none;
}

.cover-art {
  position: relative;
  width: 100%;
  aspect-ratio: 1;
  border-radius: 50%;
  background-size: cover;
  background-position: center;
  box-shadow: 
    0 30px 60px -15px rgba(0, 0, 0, 0.7),
    0 0 0 18px rgba(99, 102, 241, 0.15),
    inset 0 0 60px rgba(0, 0, 0, 0.4);
  transition: var(--transition);
  overflow: hidden;
  cursor: pointer;
}

.cover-art.spinning {
  animation: vinylSpin 2.8s linear infinite;
}

@keyframes vinylSpin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* Vinyl grooves */
.vinyl-grooves {
  position: absolute;
  inset: 12%;
  border: 2px solid rgba(255,255,255,0.15);
  border-radius: 50%;
  box-shadow: 
    0 0 0 12px rgba(255,255,255,0.08),
    0 0 0 24px rgba(255,255,255,0.06),
    0 0 0 36px rgba(255,255,255,0.04);
  pointer-events: none;
}

.cover-overlay {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  background: radial-gradient(circle, transparent 58%, rgba(0, 0, 0, 0.3) 100%);
  pointer-events: none;
}

/* Play Overlay */
.play-overlay {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 80px;
  height: 80px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(4px);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--primary);
  cursor: pointer;
  z-index: 20;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  opacity: 0;
  visibility: hidden;
}

/* Hiển thị khi hover hoặc khi đang pause */
.cover-art:hover .play-overlay {
  opacity: 1;
  visibility: visible;
  transform: translate(-50%, -50%) scale(1);
}

.play-overlay.visible {
  opacity: 1;
  visibility: visible;
}

.play-overlay.playing {
  background: #3b82f6;
  color: white;
}

.play-overlay:hover {
  transform: translate(-50%, -50%) scale(1.1);
  background: var(--primary);
  color: white;
  box-shadow: 0 15px 40px #3b82f6;
}

.play-overlay.playing:hover {
    background: #3b82f6;
  color: white;
}

/* Tonearm */
.tonearm-wrapper {
  position: absolute;
  top: 35px;
  right: -85px;
  z-index: 10;
  width: 220px;
  height: 180px;
  pointer-events: none;
}

.tonearm {
  transition: transform 0.7s cubic-bezier(0.4, 0, 0.2, 1);
  transform-origin: 40px 138px;
}

.tonearm.playing {
  transform: rotate(-38deg);
}

/* Song Info */
.song-info {
  text-align: center;
  margin-top: 24px;
}

.badge-strip {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  justify-content: center;
  margin-bottom: 14px;
}

.badge {
  padding: 5px 14px;
  font-size: 10.5px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.6px;
  border-radius: 9999px;
  background: rgba(255,255,255,0.06);
  color: var(--text-secondary);
}

.badge-published { background: rgba(16, 185, 129, 0.18); color: #10b981; }
.badge-draft { background: rgba(100, 116, 139, 0.18); color: #64748b; }
.badge-blocked { background: rgba(239, 68, 68, 0.18); color: #ef4444; }
.badge-explicit { background: rgba(239, 68, 68, 0.18); color: #ef4444; }
.badge-premium { background: rgba(245, 158, 11, 0.18); color: #f59e0b; }
.badge-genre { background: transparent; border: 1.5px solid; }

.song-title {
  font-size: 34px;
  line-height: 1.1;
  font-weight: 700;
  background: linear-gradient(90deg, #fff, #c7c7ff);
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
  margin: 0 0 12px;
  letter-spacing: -0.03em;
}

.artist-row {
  display: inline-flex;
  align-items: center;
  gap: 14px;
  padding: 8px 24px 8px 10px;
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: 9999px;
  cursor: pointer;
  transition: var(--transition);
}

.artist-row:hover {
  background: var(--bg-elevated);
  transform: translateY(-1px);
}

.artist-avatar {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--primary), var(--secondary));
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  color: white;
  font-size: 18px;
}

.artist-name {
  font-size: 15.5px;
  font-weight: 600;
  color: var(--text-primary);
}

.artist-year {
  font-size: 12px;
  color: var(--text-muted);
}

/* Stats */
.stats-strip {
  display: flex;
  justify-content: center;
  gap: 40px;
  padding: 20px;
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  margin-top: 12px;
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 15px;
  font-weight: 600;
  color: var(--text-secondary);
}

/* Lyrics Section - Thuần chữ, không nền, không viền */
.lyrics-section {
  padding-top: 8px;
}

.lyrics-scroll {
  max-height: calc(100vh - 280px);
  overflow-y: auto;
  padding-right: 12px;
}

.lyrics-text {
  font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  font-size: 19.5px;
  line-height: 2;
  color: #e0e0ff;
  white-space: pre-wrap;
  margin: 0;
  font-weight: 400;
  letter-spacing: -0.005em;
}

/* Empty state */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 20px;
  padding: 120px 40px;
  color: var(--text-muted);
  text-align: center;
}

/* Album Card */
.card {
  transition: var(--transition);
}

.info-card {
  display: flex;
  align-items: center;
  gap: 18px;
  padding: 16px 20px;
  cursor: pointer;
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius);
}

.info-card:hover {
  background: var(--bg-elevated);
  transform: translateY(-2px);
}

.card-icon {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  overflow: hidden;
}

.album-thumb {
  width: 100%;
  height: 100%;
  border-radius: 12px;
  background-size: cover;
  background-position: center;
}

.card-content {
  flex: 1;
}

.card-label {
  font-size: 10px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.8px;
  color: var(--text-muted);
  display: block;
}

.card-value {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-primary);
  display: block;
  margin-top: 4px;
}

/* Loading & Error */
.loading-state,
.error-state {
  position: fixed;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: var(--bg-dark);
  z-index: 100;
  gap: 24px;
}

.loading-spinner {
  width: 64px;
  height: 64px;
  border: 4px solid var(--border);
  border-top-color: var(--primary);
  border-radius: 50%;
  animation: spin 1.2s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.error-icon {
  font-size: 56px;
}

.error-state button {
  padding: 12px 32px;
  background: var(--primary);
  border: none;
  border-radius: 9999px;
  color: white;
  font-weight: 600;
  cursor: pointer;
  transition: var(--transition);
}

.error-state button:hover {
  background: var(--primary-dark);
  transform: scale(1.05);
}

/* Responsive */
@media (max-width: 1100px) {
  .main-grid {
    grid-template-columns: 1fr;
    gap: 48px;
  }
  
  .cover-container {
    width: 280px;
  }
}

@media (max-width: 640px) {
  .content-wrapper {
    padding: 20px 24px 60px;
  }
  
  .song-title {
    font-size: 29px;
  }
  
  .lyrics-text {
    font-size: 18px;
    line-height: 1.9;
  }
  
  .play-overlay {
    width: 60px;
    height: 60px;
  }
  
  .play-overlay svg {
    width: 24px;
    height: 24px;
  }
}

/* Animation cho bounce subtle */
@keyframes bounceSubtle {
  0%, 100% { transform: translate(-50%, -50%) scale(1); }
  50% { transform: translate(-50%, -50%) scale(1.08); }
}

.play-overlay.visible {
  animation: bounceSubtle 1.5s ease-in-out infinite;
}
</style>
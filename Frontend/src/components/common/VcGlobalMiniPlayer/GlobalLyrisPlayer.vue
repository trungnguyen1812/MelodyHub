<template>
  <Teleport to="body">
    <Transition name="player-slide">
      <div v-if="player.currentSong" class="mini-player">


        <!-- Main content wrapper -->
        <div class="player-content">
          <!-- Cover -->
          <div class="player-cover" :style="getCoverStyle(player.currentSong)">
            <div v-if="!player.currentSong.cover_url" class="player-cover-fallback">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="rgba(255,255,255,0.5)">
                <path d="M9 18V5l12-2v13"/>
                <circle cx="6" cy="18" r="3"/>
                <circle cx="18" cy="16" r="3"/>
              </svg>
            </div>
            <div class="player-cover-spin" :class="{ spinning: player.isPlaying }"></div>
          </div>

          <!-- Info -->
          <div class="player-info" @click="goToDetail">
            <p class="player-title">{{ player.currentSong.title }}</p>
            <p class="player-artist">{{ player.currentSong.artist?.name ?? '—' }}</p>
          </div>

          <!-- Seek -->
          <div class="player-seek-area">
            <span class="player-time">{{ formatTime(player.currentTime) }}</span>
            <div class="player-seek-wrap" @click="onSeekClick">
              <div class="player-seek-track">
                <div
                  class="player-seek-fill"
                  :style="{ width: player.duration > 0 ? (player.currentTime / player.duration * 100) + '%' : '0%' }"
                ></div>
                <div
                  class="player-seek-thumb"
                  :style="{ left: player.duration > 0 ? (player.currentTime / player.duration * 100) + '%' : '0%' }"
                ></div>
              </div>
              <input
                type="range"
                min="0"
                :max="player.duration"
                :value="player.currentTime"
                step="0.1"
                class="player-seek-input"
                @input="onSeek"
              />
            </div>
            <span class="player-time">{{ formatTime(player.duration) }}</span>
          </div>

          <!-- Controls -->
          <div class="player-controls">
            <button
              class="player-btn player-btn--skip"
              :class="{ disabled: !player.hasPrev }"
              :disabled="!player.hasPrev"
              @click="player.playPrev()"
              title="Previous"
            >
              <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                <polygon points="19 20 9 12 19 4 19 20"/>
                <rect x="4" y="4" width="3" height="16" rx="1"/>
              </svg>
            </button>

            <button class="player-btn player-btn--play" @click="player.toggle()" title="Play/Pause">
              <svg v-if="player.isPlaying" width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <rect x="6" y="4" width="4" height="16" rx="1"/>
                <rect x="14" y="4" width="4" height="16" rx="1"/>
              </svg>
              <svg v-else width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <polygon points="5 3 19 12 5 21 5 3"/>
              </svg>
            </button>

            <button
              class="player-btn player-btn--skip"
              :class="{ disabled: !player.hasNext }"
              :disabled="!player.hasNext"
              @click="player.playNext()"
              title="Next"
            >
              <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                <polygon points="5 4 15 12 5 20 5 4"/>
                <rect x="17" y="4" width="3" height="16" rx="1"/>
              </svg>
            </button>

            <!-- Lyrics Button -->
            <button 
              class="player-btn player-btn--lyrics" 
              @click="toggleLyrics" 
              :class="{ active: showLyrics }"
              title="Show/Hide Lyrics"
            >
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M3 6h18M3 12h12M3 18h6"/>
                <path d="M18 12v6M15 15h6"/>
              </svg>
            </button>

            <button class="player-btn player-btn--close" @click="player.stop()" title="Close">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="18" y1="6" x2="6" y2="18"/>
                <line x1="6" y1="6" x2="18" y2="18"/>
              </svg>
            </button>
          </div>

          <!-- Volume -->
          <div class="player-volume">
            <button class="player-vol-icon" @click="player.toggleMute()" title="Mute/Unmute">
              <!-- Muted -->
              <svg v-if="player.isMuted || player.volume === 0" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/>
                <line x1="23" y1="9" x2="17" y2="15"/>
                <line x1="17" y1="9" x2="23" y2="15"/>
              </svg>
              <!-- Low volume -->
              <svg v-else-if="player.volume <= 0.5" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/>
                <path d="M15.54 8.46a5 5 0 0 1 0 7.07"/>
              </svg>
              <!-- High volume -->
              <svg v-else width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/>
                <path d="M15.54 8.46a5 5 0 0 1 0 7.07"/>
                <path d="M19.07 4.93a10 10 0 0 1 0 14.14"/>
              </svg>
            </button>
            <input
              type="range"
              min="0"
              max="1"
              step="0.05"
              :value="player.isMuted ? 0 : player.volume"
              class="player-vol-slider"
              @input="onVolumeChange"
            />
          </div>
        </div>

        <!-- Lyrics Panel -->
        <Transition name="lyrics-slide">
          <div v-if="showLyrics" class="lyrics-panel">
            <div class="lyrics-header">
              <h3>Lyrics</h3>
              <button class="lyrics-close" @click="showLyrics = false">×</button>
            </div>
            <div class="lyrics-content">
              <div v-if="loadingLyrics" class="lyrics-loading">
                <div class="spinner"></div>
                <p>Loading lyrics...</p>
              </div>
              <div v-else-if="lyrics" class="lyrics-text">
                <pre>{{ lyrics }}</pre>
              </div>
              <div v-else class="lyrics-empty">
                <p>No lyrics available for this song</p>
              </div>
            </div>
          </div>
        </Transition>

      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { usePlayerStore } from '@/modules/admin/stores/songs/playerStore'
import type { Song } from '@/modules/admin/interfaces/songs/songs.interface'
import { useSongStore } from '@/modules/admin/stores/songs/songsStore'
import { useRouter } from 'vue-router'
import adminApi from '@/plugins/axios_admin';


const router = useRouter()
const player = usePlayerStore()
const songStore = useSongStore()

// Lyrics state
const showLyrics = ref(false)
const lyrics = ref<string | null>(null)
const loadingLyrics = ref(false)

console.log(player.currentSong);


const goToDetail = () => {
  if (!player.currentSong) return
  router.push({
    name: 'admin.songsmanager.detail',
    params: { id: player.currentSong.id }
  })
}

// Toggle lyrics panel and fetch lyrics if needed
const toggleLyrics = async () => {
  if (!showLyrics.value && !lyrics.value && player.currentSong) {
    await fetchLyrics(player.currentSong)
  }
  showLyrics.value = !showLyrics.value
}

// Fetch lyrics from API
const fetchLyrics = async (song: Song) => {
  loadingLyrics.value = true
  try {
    // Giả sử API có endpoint để lấy lyrics
    const response = await adminApi.get(`/songs/${song.id}/lyrics`)
    lyrics.value = response.data.lyrics || null
  } catch (error) {
    console.error('Failed to fetch lyrics:', error)
    lyrics.value = null
  } finally {
    loadingLyrics.value = false
  }
}

// ── Cover style ──
const gradients = [
  'linear-gradient(135deg,#1a1a2e,#16213e,#0f3460)',
  'linear-gradient(135deg,#2d1b69,#11998e)',
  'linear-gradient(135deg,#1a1a1a,#c94b4b)',
  'linear-gradient(135deg,#0f2027,#203a43,#2c5364)',
  'linear-gradient(135deg,#4a1942,#c94b4b)',
  'linear-gradient(135deg,#134e5e,#71b280)',
]

const getCoverStyle = (song: Song) => {
  if (song.cover_url) {
    return {
      backgroundImage: `url(${song.cover_url})`,
      backgroundSize: 'cover',
      backgroundPosition: 'center',
    }
  }
  return { background: gradients[song.id % gradients.length] }
}

// ── Time format ──
const formatTime = (secs: number) => {
  if (!secs || isNaN(secs)) return '0:00'
  const m = Math.floor(secs / 60)
  const s = Math.floor(secs % 60)
  return `${m}:${String(s).padStart(2, '0')}`
}

// ── Seek ──
const onSeek = (e: Event) => {
  player.seek(parseFloat((e.target as HTMLInputElement).value))
}

const onSeekClick = (e: MouseEvent) => {
  if (player.duration === 0) return
  const rect = (e.currentTarget as HTMLElement).getBoundingClientRect()
  const ratio = (e.clientX - rect.left) / rect.width
  player.seek(ratio * player.duration)
}

// ── Volume ──
const onVolumeChange = (e: Event) => {
  player.setVolume(parseFloat((e.target as HTMLInputElement).value))
}
</script>

<style scoped>
/* ─────────────────────────────────────────
   MINI PLAYER - FULL WIDTH
───────────────────────────────────────── */
.mini-player {
  position: fixed;
  bottom: 0;
  left: 25%;
  right: 0;
  width: 73.90%;
  background: rgba(14, 18, 26, 0.96);
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 0 0 20px 20px;
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
  z-index: 9999;
  box-shadow: 0 -8px 32px rgba(0, 0, 0, 0.3);
}

/* Main content wrapper */
.player-content {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 12px 20px;
  max-width: 1400px;
  margin: 0 auto;
}

/* ── Progress top ── */
.player-progress-top {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: rgba(255, 255, 255, 0.08);
}
.player-progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #3b82f6, #06b6d4);
  transition: width 0.2s linear;
  border-radius: 0;
}

/* ── Cover ── */
.player-cover {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  flex-shrink: 0;
  background-size: cover;
  background-position: center;
  position: relative;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}
.player-cover-fallback {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
}
.player-cover-spin {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  border: 2px solid transparent;
  transition: border-color 0.3s;
}
.player-cover-spin.spinning {
  border-color: rgba(59, 130, 246, 0.5);
  animation: cover-spin 8s linear infinite;
}
@keyframes cover-spin {
  to { transform: rotate(360deg); }
}

/* ── Info ── */
.player-info {
  flex-shrink: 0;
  min-width: 120px;
  max-width: 200px;
  cursor: pointer;
}
.player-title {
  font-size: 14px;
  font-weight: 600;
  color: #f0f4f8;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  line-height: 1.3;
}
.player-artist {
  font-size: 12px;
  color: #9ca3af;
  margin-top: 2px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* ── Seek ── */
.player-seek-area {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 12px;
  min-width: 0;
}
.player-time {
  font-size: 12px;
  color: #9ca3af;
  white-space: nowrap;
  font-variant-numeric: tabular-nums;
  flex-shrink: 0;
  width: 38px;
}
.player-time:last-child { text-align: right; }

.player-seek-wrap {
  flex: 1;
  position: relative;
  height: 24px;
  display: flex;
  align-items: center;
  cursor: pointer;
}
.player-seek-track {
  position: absolute;
  left: 0;
  right: 0;
  height: 4px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
}
.player-seek-fill {
  height: 100%;
  background: linear-gradient(90deg, #3b82f6, #06b6d4);
  border-radius: 4px;
  transition: width 0.05s linear;
}
.player-seek-thumb {
  position: absolute;
  top: 50%;
  transform: translate(-50%, -50%);
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: #fff;
  box-shadow: 0 0 6px rgba(0, 0, 0, 0.5);
  opacity: 0;
  transition: opacity 0.2s;
  pointer-events: none;
}
.player-seek-wrap:hover .player-seek-thumb { opacity: 1; }
.player-seek-input {
  position: absolute;
  left: 0;
  right: 0;
  width: 100%;
  height: 100%;
  opacity: 0;
  cursor: pointer;
  margin: 0;
}

/* ── Controls ── */
.player-controls {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}

.player-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  cursor: pointer;
  transition: all 0.2s;
  border-radius: 50%;
}

/* Play/Pause */
.player-btn--play {
  width: 44px;
  height: 44px;
  background: #3b82f6;
  color: #fff;
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}
.player-btn--play:hover {
  background: #60a5fa;
  transform: scale(1.05);
}
.player-btn--play:active { transform: scale(0.95); }

/* Prev / Next */
.player-btn--skip {
  width: 36px;
  height: 36px;
  background: rgba(255, 255, 255, 0.05);
  color: #d1d5db;
  border: 1px solid rgba(255, 255, 255, 0.08);
}
.player-btn--skip:hover:not(:disabled) {
  background: rgba(59, 130, 246, 0.15);
  color: #60a5fa;
  border-color: rgba(59, 130, 246, 0.4);
  transform: scale(1.05);
}
.player-btn--skip:disabled,
.player-btn--skip.disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

/* Lyrics Button */
.player-btn--lyrics {
  width: 36px;
  height: 36px;
  background: rgba(255, 255, 255, 0.05);
  color: #d1d5db;
  border: 1px solid rgba(255, 255, 255, 0.08);
}
.player-btn--lyrics:hover {
  background: rgba(59, 130, 246, 0.15);
  color: #60a5fa;
  border-color: rgba(59, 130, 246, 0.4);
  transform: scale(1.05);
}
.player-btn--lyrics.active {
  background: rgba(59, 130, 246, 0.2);
  color: #60a5fa;
  border-color: rgba(59, 130, 246, 0.5);
}

/* Close */
.player-btn--close {
  width: 34px;
  height: 34px;
  background: rgba(255, 255, 255, 0.03);
  color: #9ca3af;
  border: 1px solid rgba(255, 255, 255, 0.06);
  margin-left: 4px;
}
.player-btn--close:hover {
  background: rgba(239, 68, 68, 0.1);
  color: #f87171;
  border-color: rgba(239, 68, 68, 0.3);
}

/* ── Volume ── */
.player-volume {
  display: flex;
  align-items: center;
  gap: 6px;
  flex-shrink: 0;
}
.player-vol-icon {
  background: none;
  border: none;
  cursor: pointer;
  color: #9ca3af;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 4px;
  transition: color 0.2s;
}
.player-vol-icon:hover { color: #d1d5db; }

.player-vol-slider {
  width: 80px;
  height: 4px;
  -webkit-appearance: none;
  appearance: none;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  outline: none;
  cursor: pointer;
}
.player-vol-slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: #d1d5db;
  cursor: pointer;
  transition: all 0.2s;
}
.player-vol-slider:hover::-webkit-slider-thumb {
  background: #fff;
  transform: scale(1.2);
}
.player-vol-slider::-moz-range-thumb {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: #d1d5db;
  border: none;
  cursor: pointer;
}

/* ── Lyrics Panel ── */
.lyrics-panel {
  position: absolute;
  bottom: 100%;
  left: 0;
  right: 0;
  background: rgba(14, 18, 26, 0.98);
  backdrop-filter: blur(24px);
  border-radius: 16px 16px 0 0;
  margin-bottom: 8px;
  max-height: 400px;
  display: flex;
  flex-direction: column;
  box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-bottom: none;
}

.lyrics-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

.lyrics-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #f0f4f8;
}

.lyrics-close {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #9ca3af;
  transition: color 0.2s;
  line-height: 1;
  padding: 0;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
}

.lyrics-close:hover {
  color: #f87171;
  background: rgba(239, 68, 68, 0.1);
}

.lyrics-content {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

.lyrics-text pre {
  margin: 0;
  font-family: inherit;
  font-size: 14px;
  line-height: 1.6;
  color: #d1d5db;
  white-space: pre-wrap;
  word-wrap: break-word;
}

.lyrics-empty {
  text-align: center;
  color: #9ca3af;
  padding: 40px 20px;
}

.lyrics-empty p {
  margin: 0;
}

.lyrics-loading {
  text-align: center;
  padding: 40px 20px;
  color: #9ca3af;
}

.spinner {
  width: 40px;
  height: 40px;
  margin: 0 auto 16px;
  border: 3px solid rgba(59, 130, 246, 0.3);
  border-top-color: #3b82f6;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* Lyrics transition */
.lyrics-slide-enter-active,
.lyrics-slide-leave-active {
  transition: all 0.3s ease;
}

.lyrics-slide-enter-from,
.lyrics-slide-leave-to {
  opacity: 0;
  transform: translateY(20px);
}

/* ─────────────────────────────────────────
   TRANSITION - SLIDE FROM BOTTOM
───────────────────────────────────────── */
.player-slide-enter-active {
  transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.3s ease;
}
.player-slide-leave-active {
  transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.2s ease;
}
.player-slide-enter-from,
.player-slide-leave-to {
  transform: translateY(100%);
  opacity: 0;
}
.player-slide-enter-to,
.player-slide-leave-from {
  transform: translateY(0);
  opacity: 1;
}

/* ─────────────────────────────────────────
   RESPONSIVE
───────────────────────────────────────── */
@media (max-width: 1024px) {
  .player-content {
    gap: 12px;
    padding: 10px 16px;
  }
  .player-seek-area {
    gap: 8px;
  }
  .player-volume {
    gap: 6px;
  }
  .player-vol-slider {
    width: 70px;
  }
  .lyrics-panel {
    max-height: 350px;
  }
}

@media (max-width: 768px) {
  .player-content {
    gap: 10px;
    padding: 10px 12px;
  }
  .player-info {
    min-width: 100px;
    max-width: 150px;
  }
  .player-title {
    font-size: 13px;
  }
  .player-artist {
    font-size: 11px;
  }
  .player-time {
    font-size: 11px;
    width: 34px;
  }
  .player-btn--play {
    width: 40px;
    height: 40px;
  }
  .player-btn--skip {
    width: 32px;
    height: 32px;
  }
  .player-btn--lyrics {
    width: 32px;
    height: 32px;
  }
  .player-vol-slider {
    width: 60px;
  }
  .lyrics-panel {
    max-height: 300px;
  }
  .lyrics-content {
    padding: 16px;
  }
  .lyrics-text pre {
    font-size: 13px;
  }
}

@media (max-width: 640px) {
  .player-volume {
    display: none;
  }
  .player-info {
    min-width: 80px;
    max-width: 120px;
  }
  .player-controls {
    gap: 6px;
  }
  .player-seek-area {
    gap: 6px;
  }
  .player-time {
    width: 30px;
  }
  .lyrics-panel {
    max-height: 250px;
  }
}

@media (max-width: 480px) {
  .player-info {
    min-width: 70px;
    max-width: 100px;
  }
  .player-title {
    font-size: 12px;
  }
  .player-artist {
    font-size: 10px;
  }
  .player-btn--play {
    width: 36px;
    height: 36px;
  }
  .player-btn--skip {
    width: 28px;
    height: 28px;
  }
  .player-btn--lyrics {
    width: 28px;
    height: 28px;
  }
  .player-btn--close {
    width: 28px;
    height: 28px;
  }
  .lyrics-header h3 {
    font-size: 16px;
  }
  .lyrics-content {
    padding: 12px;
  }
  .lyrics-text pre {
    font-size: 12px;
  }
}
</style>
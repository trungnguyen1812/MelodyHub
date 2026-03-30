<template>
  <Teleport to="body">
    <div v-if="player.currentSong" class="player-wrapper" :class="{ collapsed: isCollapsed }">

      <!-- BAR BACKGROUND (ẩn khi collapsed) -->
      <div class="player-bar-bg"></div>

      <div class="player-content">

        <!-- ĐĨA - luôn tồn tại, chỉ di chuyển vị trí -->
        <div
          class="player-disc"
          :class="{ spinning: player.isPlaying }"
          :style="getCoverStyle(player.currentSong)"
          @click="isCollapsed = !isCollapsed"
          :title="isCollapsed ? 'Mở rộng' : 'Thu nhỏ'"
        >
          <div class="disc-grooves"></div>
          <div class="disc-hole"></div>
          <div v-if="player.isPlaying" class="disc-pulse"></div>
          <div class="disc-hint">
            <!-- icon expand khi collapsed -->
            <svg v-if="isCollapsed" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <polyline points="15 3 21 3 21 9"/><polyline points="9 21 3 21 3 15"/>
              <line x1="21" y1="3" x2="14" y2="10"/><line x1="3" y1="21" x2="10" y2="14"/>
            </svg>
            <!-- icon collapse khi mở -->
            <svg v-else width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <polyline points="4 14 10 14 10 20"/><polyline points="20 10 14 10 14 4"/>
              <line x1="10" y1="14" x2="3" y2="21"/><line x1="21" y1="3" x2="14" y2="10"/>
            </svg>
          </div>
        </div>

        <!-- PHẦN MỞ RỘNG -->
        <div class="player-expandable">
          <div class="player-info" @click="goToDetail">
            <p class="player-title">{{ player.currentSong.title }}</p>
            <p class="player-artist">{{ player.currentSong.artist?.name ?? '—' }}</p>
          </div>

          <div class="player-seek-area">
            <span class="player-time">{{ formatTime(player.currentTime) }}</span>
            <div class="player-seek-wrap" @click="onSeekClick">
              <div class="player-seek-track">
                <div class="player-seek-fill" :style="{ width: player.duration > 0 ? (player.currentTime / player.duration * 100) + '%' : '0%' }"></div>
                <div class="player-seek-thumb" :style="{ left: player.duration > 0 ? (player.currentTime / player.duration * 100) + '%' : '0%' }"></div>
              </div>
              <input type="range" min="0" :max="player.duration" :value="player.currentTime" step="0.1" class="player-seek-input" @input="onSeek" />
            </div>
            <span class="player-time">{{ formatTime(player.duration) }}</span>
          </div>

          <div class="player-controls">
            <button class="player-btn player-btn--skip" :disabled="!player.hasPrev" @click="player.playPrev()">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><polygon points="19 20 9 12 19 4 19 20"/><rect x="4" y="4" width="3" height="16" rx="1"/></svg>
            </button>
            <button class="player-btn player-btn--play" @click="player.toggle()">
              <svg v-if="player.isPlaying" width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><rect x="6" y="4" width="4" height="16" rx="1"/><rect x="14" y="4" width="4" height="16" rx="1"/></svg>
              <svg v-else width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><polygon points="5 3 19 12 5 21 5 3"/></svg>
            </button>
            <button class="player-btn player-btn--skip" :disabled="!player.hasNext" @click="player.playNext()">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor"><polygon points="5 4 15 12 5 20 5 4"/><rect x="17" y="4" width="3" height="16" rx="1"/></svg>
            </button>
            <button class="player-btn player-btn--close" @click="player.stop()">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
            </button>
          </div>

          <div class="player-volume">
            <button class="player-vol-icon" @click="player.toggleMute()">
              <svg v-if="player.isMuted || player.volume === 0" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/><line x1="23" y1="9" x2="17" y2="15"/><line x1="17" y1="9" x2="23" y2="15"/>
              </svg>
              <svg v-else-if="player.volume <= 0.5" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/><path d="M15.54 8.46a5 5 0 0 1 0 7.07"/>
              </svg>
              <svg v-else width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/>
                <path d="M15.54 8.46a5 5 0 0 1 0 7.07"/><path d="M19.07 4.93a10 10 0 0 1 0 14.14"/>
              </svg>
            </button>
            <input type="range" min="0" max="1" step="0.05" :value="player.isMuted ? 0 : player.volume" class="player-vol-slider" @input="onVolumeChange" />
          </div>
        </div>

      </div>
    </div>
  </Teleport>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { usePlayerStore } from '@/modules/admin/stores/songs/playerStore'
import type { Song } from '@/modules/admin/interfaces/songs/songs.interface'
import { useRouter } from 'vue-router'

const router = useRouter()
const player = usePlayerStore()
const isCollapsed = ref(false)

const goToDetail = () => {
  if (!player.currentSong) return
  router.push({ name: 'client.song.detail', params: { id: player.currentSong.id } })
}

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
    return { backgroundImage: `url(${song.cover_url})`, backgroundSize: 'cover', backgroundPosition: 'center' }
  }
  return { background: gradients[song.id % gradients.length] }
}

const formatTime = (secs: number) => {
  if (!secs || isNaN(secs)) return '0:00'
  const m = Math.floor(secs / 60)
  const s = Math.floor(secs % 60)
  return `${m}:${String(s).padStart(2, '0')}`
}

const onSeek = (e: Event) => player.seek(parseFloat((e.target as HTMLInputElement).value))
const onSeekClick = (e: MouseEvent) => {
  if (player.duration === 0) return
  const rect = (e.currentTarget as HTMLElement).getBoundingClientRect()
  player.seek((e.clientX - rect.left) / rect.width * player.duration)
}
const onVolumeChange = (e: Event) => player.setVolume(parseFloat((e.target as HTMLInputElement).value))
</script>

<style scoped>
/* ====================== WRAPPER ====================== */
.player-wrapper {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  z-index: 9999;
  /* Quan trọng: đặt height để collapsed không chiếm space */
  pointer-events: none;
}

/* ====================== BAR BACKGROUND ====================== */
.player-bar-bg {
  position: absolute;
  bottom: 0; left: 0; right: 0;
  height: 68px;
  background: rgba(14, 18, 26, 0.96);
  border-top: 1px solid rgba(255,255,255,0.08);
  backdrop-filter: blur(24px);
  box-shadow: 0 -6px 30px rgba(0,0,0,0.35);
  pointer-events: all;

  /* Transition: xuất hiện / biến mất */
  opacity: 1;
  transform: translateY(0);
  transition: opacity 0.35s ease, transform 0.35s ease;
}

.player-wrapper.collapsed .player-bar-bg {
  opacity: 0;
  transform: translateY(100%);
  pointer-events: none;
}

/* ====================== CONTENT ROW ====================== */
.player-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 10px 24px;
  max-width: 1400px;
  margin: 0 auto;

  /* Khi collapsed: đẩy đĩa về phải */
  transition: justify-content 0s 0.35s; /* delay để chờ bar ẩn xong */
}

/* ====================== ĐĨA ====================== */
.player-disc {
  pointer-events: all;
  position: relative;
  width: 48px;
  height: 48px;
  border-radius: 50%;
  flex-shrink: 0;
  background-size: cover;
  background-position: center;
  cursor: pointer;
  overflow: hidden;
  box-shadow:
    0 0 0 2px rgba(0,0,0,0.6),
    0 0 0 4px rgba(255,255,255,0.08),
    0 4px 16px rgba(0,0,0,0.5),
    0 0 16px rgba(59,130,246,0.35);
  
  /* Transition vị trí + kích thước */
  transition:
    transform 0.45s cubic-bezier(0.4, 0, 0.2, 1),
    width 0.45s cubic-bezier(0.4, 0, 0.2, 1),
    height 0.45s cubic-bezier(0.4, 0, 0.2, 1),
    box-shadow 0.3s ease,
    margin-left 0.45s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Khi collapsed: đĩa to hơn, dịch sang phải */
.player-wrapper.collapsed .player-disc {
  width: 62px;
  height: 62px;
  /* Tính toán để đĩa nằm ở góc phải, cách mép 28px */
  margin-left: calc(100vw - 62px - 80px);
  margin-bottom: 10px;
  box-shadow:
    0 0 0 3px rgba(0,0,0,0.7),
    0 0 0 5px rgba(255,255,255,0.1),
    0 8px 32px rgba(0,0,0,0.7),
    0 0 28px rgba(59,130,246,0.6);
}

.player-disc.spinning {
  animation: disc-spin 4s linear infinite;
}

/* Vinyl grooves */
.disc-grooves {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  background: repeating-radial-gradient(
    circle at 50% 50%,
    transparent 0px, transparent 3px,
    rgba(0,0,0,0.13) 3px, rgba(0,0,0,0.13) 4px
  );
  pointer-events: none;
}

/* Lỗ giữa */
.disc-hole {
  position: absolute;
  top: 50%; left: 50%;
  transform: translate(-50%, -50%);
  width: 14px; height: 14px;
  border-radius: 50%;
  background: #0a0e16;
  border: 2px solid rgba(59,130,246,0.65);
  box-shadow: 0 0 7px rgba(59,130,246,0.5);
  z-index: 3;
}

/* Pulse khi đang phát + collapsed */
.disc-pulse {
  position: absolute;
  top: 50%; left: 50%;
  transform: translate(-50%, -50%);
  width: 100%; height: 100%;
  border-radius: 50%;
  border: 2px solid rgba(59,130,246,0.5);
  animation: pulse-ring 1.8s ease-out infinite;
  pointer-events: none;
}

/* Icon hint khi hover */
.disc-hint {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0,0,0,0.5);
  color: #fff;
  opacity: 0;
  transition: opacity 0.2s ease;
  z-index: 4;
}

.player-disc:hover .disc-hint {
  opacity: 1;
}

/* ====================== EXPANDABLE ====================== */
.player-expandable {
  display: flex;
  align-items: center;
  gap: 16px;
  flex: 1;
  overflow: hidden;

  opacity: 1;
  transform: translateX(0);
  transition:
    opacity 0.3s ease,
    transform 0.35s ease,
    max-width 0.45s cubic-bezier(0.4, 0, 0.2, 1);
  max-width: 9999px;
  pointer-events: all;
}

/* Khi collapsed: ẩn toàn bộ phần mở rộng */
.player-wrapper.collapsed .player-expandable {
  opacity: 0;
  transform: translateX(60px);
  max-width: 0;
  pointer-events: none;
}

/* ====================== INFO ====================== */
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
}

.player-artist {
  font-size: 12px;
  color: #9ca3af;
  margin-top: 2px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* ====================== SEEK ====================== */
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
  left: 0; right: 0;
  height: 4px;
  background: rgba(255,255,255,0.1);
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
  width: 12px; height: 12px;
  border-radius: 50%;
  background: #fff;
  box-shadow: 0 0 6px rgba(0,0,0,0.5);
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.2s;
}

.player-seek-wrap:hover .player-seek-thumb { opacity: 1; }

.player-seek-input {
  position: absolute;
  inset: 0;
  opacity: 0;
  cursor: pointer;
  width: 100%;
}

/* ====================== CONTROLS ====================== */
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

.player-btn--play {
  width: 44px; height: 44px;
  background: #3b82f6;
  color: #fff;
  box-shadow: 0 4px 12px rgba(59,130,246,0.35);
}

.player-btn--play:hover { background: #60a5fa; transform: scale(1.05); }

.player-btn--skip {
  width: 36px; height: 36px;
  background: rgba(255,255,255,0.05);
  color: #d1d5db;
  border: 1px solid rgba(255,255,255,0.08);
}

.player-btn--skip:hover:not(:disabled) {
  background: rgba(59,130,246,0.15);
  color: #60a5fa;
  border-color: rgba(59,130,246,0.4);
  transform: scale(1.05);
}

.player-btn--close {
  width: 34px; height: 34px;
  background: rgba(255,255,255,0.03);
  color: #9ca3af;
  border: 1px solid rgba(255,255,255,0.06);
  margin-left: 4px;
}

.player-btn--close:hover {
  background: rgba(239,68,68,0.1);
  color: #f87171;
  border-color: rgba(239,68,68,0.3);
}

/* ====================== VOLUME ====================== */
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
  padding: 4px;
}

.player-vol-slider {
  width: 80px;
  height: 4px;
  -webkit-appearance: none;
  background: rgba(255,255,255,0.1);
  border-radius: 4px;
  outline: none;
  cursor: pointer;
}

.player-vol-slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  width: 12px; height: 12px;
  border-radius: 50%;
  background: #d1d5db;
  cursor: pointer;
}

/* ====================== ANIMATIONS ====================== */
@keyframes disc-spin { to { transform: rotate(360deg); } }

@keyframes pulse-ring {
  0%   { transform: translate(-50%,-50%) scale(1);   opacity: 0.7; }
  100% { transform: translate(-50%,-50%) scale(1.65); opacity: 0;   }
}

/* ====================== RESPONSIVE ====================== */
@media (max-width: 768px) {
  .player-content { padding: 10px 16px; gap: 12px; }
  .player-wrapper.collapsed .player-disc { margin-left: calc(100vw - 62px - 40px); }
}

@media (max-width: 640px) { .player-volume { display: none; } }

@media (max-width: 480px) {
  .player-btn--play { width: 36px; height: 36px; }
  .player-btn--skip, .player-btn--close { width: 28px; height: 28px; }
}
</style>
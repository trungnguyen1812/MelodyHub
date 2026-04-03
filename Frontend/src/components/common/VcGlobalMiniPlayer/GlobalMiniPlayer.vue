<template>
  <Teleport to="body">
    <div v-if="player.currentSong" class="player-wrapper" :class="{ collapsed: isCollapsed }">

      <div class="player-bar-bg"></div>

      <div class="player-content">

        <div class="player-disc" :class="{ spinning: player.isPlaying }" :style="getCoverStyle(player.currentSong)"
          @click="isCollapsed = !isCollapsed" :title="isCollapsed ? 'Mở rộng' : 'Thu nhỏ'">
          <div class="disc-grooves"></div>
          <div class="disc-hole"></div>
          <div v-if="player.isPlaying" class="disc-pulse"></div>
          <div class="disc-hint">
            <!-- icon expand khi collapsed -->
            <svg v-if="isCollapsed" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
              stroke-width="2.5">
              <polyline points="15 3 21 3 21 9" />
              <polyline points="9 21 3 21 3 15" />
              <line x1="21" y1="3" x2="14" y2="10" />
              <line x1="3" y1="21" x2="10" y2="14" />
            </svg>
            <!-- icon collapse khi mở -->
            <svg v-else width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <polyline points="4 14 10 14 10 20" />
              <polyline points="20 10 14 10 14 4" />
              <line x1="10" y1="14" x2="3" y2="21" />
              <line x1="21" y1="3" x2="14" y2="10" />
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
                <div class="player-seek-fill"
                  :style="{ width: player.duration > 0 ? (player.currentTime / player.duration * 100) + '%' : '0%' }">
                </div>
                <div class="player-seek-thumb"
                  :style="{ left: player.duration > 0 ? (player.currentTime / player.duration * 100) + '%' : '0%' }">
                </div>
              </div>
              <input type="range" min="0" :max="player.duration" :value="player.currentTime" step="0.1"
                class="player-seek-input" @input="onSeek" />
            </div>
            <span class="player-time">{{ formatTime(player.duration) }}</span>
          </div>

          <div class="player-controls">
            <button class="player-btn player-btn--skip" :disabled="!player.hasPrev" @click="player.playPrev()">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                <polygon points="19 20 9 12 19 4 19 20" />
                <rect x="4" y="4" width="3" height="16" rx="1" />
              </svg>
            </button>
            <button class="player-btn player-btn--play" @click="player.toggle()">
              <svg v-if="player.isPlaying" width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <rect x="6" y="4" width="4" height="16" rx="1" />
                <rect x="14" y="4" width="4" height="16" rx="1" />
              </svg>
              <svg v-else width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <polygon points="5 3 19 12 5 21 5 3" />
              </svg>
            </button>
            <button class="player-btn player-btn--skip" :disabled="!player.hasNext" @click="player.playNext()">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                <polygon points="5 4 15 12 5 20 5 4" />
                <rect x="17" y="4" width="3" height="16" rx="1" />
              </svg>
            </button>
            <!-- Thêm nút lyrics -->
            <button class="player-btn player-btn--lyrics" @click="toggleLyrics" :class="{ active: showLyrics }">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M4 4h16v2H4V4zm0 4h10v2H4V8zm0 4h16v2H4v-2zm0 4h10v2H4v-2z" />
                <path d="M18 12v6a2 2 0 0 0 2 2h2" />
                <circle cx="18" cy="18" r="3" />
              </svg>
            </button>
            <button class="player-btn player-btn--close" @click="player.stop()">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="18" y1="6" x2="6" y2="18" />
                <line x1="6" y1="6" x2="18" y2="18" />
              </svg>
            </button>
          </div>

          <div class="player-volume">
            <button class="player-vol-icon" @click="player.toggleMute()">
              <svg v-if="player.isMuted || player.volume === 0" width="14" height="14" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2">
                <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5" />
                <line x1="23" y1="9" x2="17" y2="15" />
                <line x1="17" y1="9" x2="23" y2="15" />
              </svg>
              <svg v-else-if="player.volume <= 0.5" width="14" height="14" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2">
                <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5" />
                <path d="M15.54 8.46a5 5 0 0 1 0 7.07" />
              </svg>
              <svg v-else width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5" />
                <path d="M15.54 8.46a5 5 0 0 1 0 7.07" />
                <path d="M19.07 4.93a10 10 0 0 1 0 14.14" />
              </svg>
            </button>
            <input type="range" min="0" max="1" step="0.05" :value="player.isMuted ? 0 : player.volume"
              class="player-vol-slider" @input="onVolumeChange" />
          </div>
        </div>

      </div>
    </div>

    <!-- LYRICS PANEL -->
    <Transition name="lyrics-slide">
      <div v-if="showLyrics" class="lyrics-panel" :style="{ background: lyricGradient }">
        <div class="lyrics-header">
          <h3>Lyrics</h3>
          <button @click="showLyrics = false" class="close-lyrics">×</button>
        </div>
        <div v-if="!currentLyrics" class="lyrics-loading">
          <div class="lyrics-loading-spinner"></div>
          <p>loading lyrics...</p>
        </div>
        <div v-else class="lyrics-content">
          <div class="div1">
            <!-- TikTok Style Card -->
            <div class="tiktok-card">
              <!-- Avatar + Follow Button -->
              <div class="card-header">
                <div class="artist-info">
                  <div class="artist-avatar-card">
                    <img :src="getArtistAvatarUrl(player.currentSong?.artist)"
                      :alt="player.currentSong?.artist?.name || 'Artist'" @error="handleImageError">
                  </div>
                  <div class="artist-details-card">
                    <span class="artist-name-card">{{ player.currentSong?.artist?.name ?? 'Unknown Artist' }}</span>
                    <span class="artist-handle">@{{ player.currentSong?.artist?.slug ?? 'artist' }}</span>
                  </div>
                </div>
                <button class="follow-btn">Follow</button>
              </div>

              <!-- Disc/Cover Art -->
              <div class="card-media">
                <div class="player-disc_lyrics" :style="getCoverStyle(player.currentSong!)">
                  <div class="disc-grooves"></div>
                  <div class="disc-hole"></div>
                  <div v-if="player.isPlaying" class="disc-pulse-card"></div>

                  <!-- Play/Pause Overlay -->
                  <div class="play-overlay-card" @click.stop="player.toggle()">
                    <svg v-if="!player.isPlaying" width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                      <polygon points="5 3 19 12 5 21 5 3" />
                    </svg>
                    <svg v-else width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                      <rect x="6" y="4" width="4" height="16" rx="1" />
                      <rect x="14" y="4" width="4" height="16" rx="1" />
                    </svg>
                  </div>
                </div>
              </div>

              <!-- Song Info -->
              <div class="card-info">
                <h4 class="song-name">{{ player.currentSong?.title }}</h4>
                <p class="song-description">{{ player.currentSong?.genre?.name || 'No description' }}</p>
              </div>

              <!-- Music Note & Duration -->
              <div class="card-footer">
                <div class="music-tag">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 3v10.55c-.59-.34-1.27-.55-2-.55-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4V7h4V3h-6z" />
                  </svg>
                  <span>Original Sound</span>
                </div>
                <div class="duration">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10" />
                    <polyline points="12 6 12 12 16 14" />
                  </svg>
                  <span>{{ formatTime(player.duration) }}</span>
                </div>
              </div>

              <!-- Action Buttons Row -->
              <div class="action-row">
                <button class="action-btn like-btn">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path
                      d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
                  </svg>
                  <span>12.3K</span>
                </button>
                <button class="action-btn comment-btn">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
                  </svg>
                  <span>2.5K</span>
                </button>
                <button class="action-btn share-btn">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="18" cy="5" r="3" />
                    <circle cx="6" cy="12" r="3" />
                    <circle cx="18" cy="19" r="3" />
                    <line x1="8.59" y1="13.51" x2="15.42" y2="17.49" />
                    <line x1="15.41" y1="6.51" x2="8.59" y2="10.49" />
                  </svg>
                  <span>Share</span>
                </button>
              </div>
            </div>
          </div>
          <div class="div2">
            <div class="lyrics-lines">
              <div
                v-for="(line, i) in currentLyrics"
                :key="i"
                class="lyric-line"
                :class="{ 
                  'lyric-line--active': activeLyricIdx === i,
                  'lyric-line--past': activeLyricIdx > i
                }"
                @click="player.seek(line.start > 0 ? line.start : (i / currentLyrics!.length) * player.duration)"
              >
                {{ line.text }}
              </div>
            </div>
          </div>
        </div>
      </div>
      
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, watch, onUnmounted, computed ,nextTick } from 'vue'
import { usePlayerStore } from '@/store/playerStore'
import type { Song } from '@/interfaces/songs.interface'
import { useRouter } from 'vue-router'
import { useSongStore } from '@/modules/client/stores/songs/songsStore'
import { getFullImageUrl } from '@/modules/client/stores/artists/artistsStore';
import songsService from '@/modules/client/services/songs/songs.service';

const router = useRouter()
const player = usePlayerStore()
const songStore = useSongStore()
const isCollapsed = ref(false)
const showLyrics = ref(false)
const currentLyrics = ref<Array<{start: number, end: number, text: string}> | null>(null)

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

// Thêm logic lyrics
const extractLyrics = (lyrics: any): Array<{start: number, end: number, text: string}> | null => {
  if (!lyrics) return null

  // Unwrap Vue Proxy
  const raw = lyrics?.__v_raw ?? lyrics

  // String → parse JSON
  let parsed = raw
  if (typeof raw === 'string') {
    const trimmed = raw.trim()
    if (!trimmed || trimmed === '[object Object]') return null
    try { parsed = JSON.parse(trimmed) } catch { return null }
  }

  // ── Format: { type: "timed", segments: [{start, end, text}] } ──
  if (parsed?.type === 'timed' && Array.isArray(parsed.segments)) {
    const lines = parsed.segments.filter((s: any) => s?.text?.trim())
    if (lines.length > 0) return lines
  }

  // ── Format: { plain_text: "line1\nline2\n..." } ──
  if (parsed?.plain_text?.trim()) {
    return parsed.plain_text
      .split('\n')
      .map((text: string) => text.trim())
      .filter(Boolean)
      .map((text: string) => ({ start: 0, end: 0, text }))
  }

  // ── Format: Array [{start, end, text}] ──
  if (Array.isArray(parsed)) {
    const lines = parsed.filter((s: any) => s?.text?.trim())
    return lines.length > 0 ? lines : null
  }

  return null
}

const toggleLyrics = async () => {
  showLyrics.value = !showLyrics.value
  
  // Nếu mở panel mà chưa có lyrics → thử fetch
  if (showLyrics.value && !currentLyrics.value && player.currentSong?.id) {
    const song = await songStore.fetchSong(player.currentSong.id).catch(() => null)
    if (song?.lyrics) {
      currentLyrics.value = extractLyrics(song.lyrics)
    }
  }
}

const lyricGradient = ref('linear-gradient(135deg, rgba(16, 16, 21, 0.95), rgba(10, 10, 15, 0.98))')



const getLyricGradient = (song: Song) => {
  if (!song) return 'linear-gradient(135deg, rgba(16, 16, 21, 0.95), rgba(10, 10, 15, 0.98))'

  const gradients = [
    'linear-gradient(135deg, rgba(59, 130, 246, 0.15), rgba(139, 92, 246, 0.08), rgba(10, 10, 15, 0.95))',
    'linear-gradient(135deg, rgba(236, 72, 153, 0.15), rgba(244, 114, 182, 0.08), rgba(10, 10, 15, 0.95))',
    'linear-gradient(135deg, rgba(16, 185, 129, 0.15), rgba(52, 211, 153, 0.08), rgba(10, 10, 15, 0.95))',
    'linear-gradient(135deg, rgba(245, 158, 11, 0.15), rgba(251, 191, 36, 0.08), rgba(10, 10, 15, 0.95))',
    'linear-gradient(135deg, rgba(239, 68, 68, 0.15), rgba(248, 113, 113, 0.08), rgba(10, 10, 15, 0.95))',
    'linear-gradient(135deg, rgba(139, 92, 246, 0.15), rgba(167, 139, 250, 0.08), rgba(10, 10, 15, 0.95))',
  ]

  return gradients[song.id % gradients.length]
}

const activeLyricIdx = computed(() => {
  if (!currentLyrics.value) return -1
  const lines = currentLyrics.value
  const t = player.currentTime
  const dur = player.duration

  const allZero = lines.every(l => l.start === 0 && l.end === 0)
  if (allZero && dur > 0) {
    const idx = Math.floor((t / dur) * lines.length)
    return Math.min(idx, lines.length - 1)
  }

  for (let i = lines.length - 1; i >= 0; i--) {
    if (t >= lines[i].start) return i
  }
  return 0
})


watch(
  () => player.currentSong,
  async (newSong) => {
    if (!newSong?.id) {
      currentLyrics.value = null
      lyricGradient.value = 'linear-gradient(135deg, rgba(16, 16, 21, 0.95), rgba(10, 10, 15, 0.98))'
      return
    }

    lyricGradient.value = getLyricGradient(newSong)

    if (newSong.lyrics) {
      currentLyrics.value = extractLyrics(newSong.lyrics)
      return
    }

    try {
      const { data } = await songsService.getLyrics(newSong.id)
      currentLyrics.value = extractLyrics(data.lyrics)
    } catch {
      currentLyrics.value = null
    }
  },
  { immediate: true }
)

watch(activeLyricIdx, async (idx) => {
  if (idx < 0) return
  await nextTick()
  const container = document.querySelector('.lyrics-content')
  const activeLine = document.querySelectorAll('.lyric-line')[idx] as HTMLElement
  if (container && activeLine) {
    const containerRect = container.getBoundingClientRect()
    const lineRect = activeLine.getBoundingClientRect()
    const offset = lineRect.top - containerRect.top - containerRect.height / 2 + lineRect.height / 2
    container.scrollBy({ top: offset, behavior: 'smooth' })
  }
})

const lockScroll = (isLocked: boolean) => {
  if (isLocked) {
    const scrollY = window.scrollY
    document.body.style.position = 'fixed'
    document.body.style.top = `-${scrollY}px`
    document.body.style.width = '100%'
    document.body.style.overflow = 'hidden'
  } else {
    const scrollY = document.body.style.top
    document.body.style.position = ''
    document.body.style.top = ''
    document.body.style.width = ''
    document.body.style.overflow = ''
    if (scrollY) {
      window.scrollTo(0, parseInt(scrollY || '0') * -1)
    }
  }
}

watch(showLyrics, (isOpen) => {
  lockScroll(isOpen)
})

onUnmounted(() => {
  lockScroll(false)
})

const getArtistAvatarUrl = (artist: any) => {
  if (!artist?.avatar_url) return '/images/default-avatar.png'
  return getFullImageUrl(artist.avatar_url)
}

const handleImageError = (event: Event) => {
  const img = event.target as HTMLImageElement
  img.src = '/images/default-avatar.png'
}
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
  bottom: 0;
  left: 0;
  right: 0;
  height: 68px;
  background: rgba(14, 18, 26, 0.96);
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  backdrop-filter: blur(24px);
  box-shadow: 0 -6px 30px rgba(0, 0, 0, 0.35);
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
  transition: justify-content 0s 0.35s;
  /* delay để chờ bar ẩn xong */
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
    0 0 0 2px rgba(0, 0, 0, 0.6),
    0 0 0 4px rgba(255, 255, 255, 0.08),
    0 4px 16px rgba(0, 0, 0, 0.5),
    0 0 16px rgba(59, 130, 246, 0.35);

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
    0 0 0 3px rgba(0, 0, 0, 0.7),
    0 0 0 5px rgba(255, 255, 255, 0.1),
    0 8px 32px rgba(0, 0, 0, 0.7),
    0 0 28px rgba(59, 130, 246, 0.6);
}

.player-disc.spinning {
  animation: disc-spin 4s linear infinite;
}

/* Vinyl grooves */
.disc-grooves {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  background: repeating-radial-gradient(circle at 50% 50%,
      transparent 0px, transparent 3px,
      rgba(0, 0, 0, 0.13) 3px, rgba(0, 0, 0, 0.13) 4px);
  pointer-events: none;
}

/* Lỗ giữa */
.disc-hole {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 14px;
  height: 14px;
  border-radius: 50%;
  background: #0a0e16;
  border: 2px solid rgba(59, 130, 246, 0.65);
  box-shadow: 0 0 7px rgba(59, 130, 246, 0.5);
  z-index: 3;
}

/* Pulse khi đang phát + collapsed */
.disc-pulse {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 100%;
  height: 100%;
  border-radius: 50%;
  border: 2px solid rgba(59, 130, 246, 0.5);
  animation: pulse-ring 1.8s ease-out infinite;
  pointer-events: none;
}

.disc-hint {
  position: absolute;
  top: 0;
  bottom: 0;
  right: 0;

  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.5);
  color: #fff;
  opacity: 0;
  transition: opacity 0.2s ease, transform 0.2s ease;
  z-index: 4;

  transform: translateX(30px);
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

.player-time:last-child {
  text-align: right;
}

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
  pointer-events: none;
  transition: opacity 0.2s;
}

.player-seek-wrap:hover .player-seek-thumb {
  opacity: 1;
}

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
  width: 44px;
  height: 44px;
  background: #3b82f6;
  color: #fff;
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.35);
}

.player-btn--play:hover {
  background: #60a5fa;
  transform: scale(1.05);
}

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

/* Thêm style cho nút lyrics */
.player-btn--lyrics {
  width: 36px;
  height: 36px;
  background: rgba(255, 255, 255, 0.05);
  color: #d1d5db;
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 50%;
}

.player-btn--lyrics.active {
  background: rgba(59, 130, 246, 0.25);
  color: #3b82f6;
  border-color: rgba(59, 130, 246, 0.6);
}

.player-btn--lyrics:hover:not(:disabled) {
  background: rgba(59, 130, 246, 0.15);
  color: #60a5fa;
  border-color: rgba(59, 130, 246, 0.4);
  transform: scale(1.05);
}

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
}

/* ====================== LYRICS PANEL ====================== */
.lyrics-panel {
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

  position: fixed;
  bottom: 65px;
  right: 0px;
  width: 100%;
  height: 91vh;
  max-height: 700px;

  backdrop-filter: blur(40px) saturate(180%);
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow:
    inset 0 1px 1px rgba(255, 255, 255, 0.1),
    0 20px 40px rgba(0, 0, 0, 0.6);
  overflow: hidden;
  z-index: 10000;
  pointer-events: all;

  /* Thêm transition cho gradient mượt mà */
  transition: background 0.5s ease;
}

/* Lớp phủ để tăng độ đọc cho text */
.lyrics-panel::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.3);
  pointer-events: none;
  z-index: 0;
}

/* Hiệu ứng shimmer */
.lyrics-panel::after {
  content: "";
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(45deg,
      transparent 45%,
      rgba(255, 255, 255, 0.03) 50%,
      transparent 55%);
  animation: shimmer 10s infinite linear;
  pointer-events: none;
  z-index: 1;
}

@keyframes shimmer {
  0% {
    transform: translateX(-30%) translateY(-30%);
  }

  100% {
    transform: translateX(30%) translateY(30%);
  }
}

/* Header lyrics */
.lyrics-header {
  position: relative;
  z-index: 2;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  background: rgba(0, 0, 0, 0.2);
  backdrop-filter: blur(10px);
}

.lyrics-header h3 {
  margin: 0;
  font-size: 14px;
  font-weight: 600;
  color: #e5e7eb;
}

.close-lyrics {
  background: none;
  border: none;
  color: #9ca3af;
  font-size: 24px;
  cursor: pointer;
  padding: 0;
  line-height: 1;
  transition: color 0.2s;
}

.close-lyrics:hover {
  color: #f87171;
}

/* Content lyrics */
.lyrics-content {
  position: relative;
  z-index: 2;
  padding: 16px;
  max-height: calc(91vh - 60px);
  overflow-y: auto;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  align-items: start;
}

.div1 {
  grid-area: 1 / 1 / 2 / 2;
  height: fit-content;
  position: sticky;
  top: 30px;

  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;

  gap: 12px;
  width: 100%;
}

.div2 {
  grid-area: 1 / 2 / 2 / 3;
  height: auto;
}

/* Scrollbar đẹp */
.lyrics-content::-webkit-scrollbar {
  width: 4px;
}

.lyrics-content::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 4px;
}

.lyrics-content::-webkit-scrollbar-thumb {
  background: rgba(59, 130, 246, 0.5);
  border-radius: 4px;
}

.lyrics-content::-webkit-scrollbar-thumb:hover {
  background: rgba(59, 130, 246, 0.7);
}

/* Text lyrics */
.lyrics-text {
  margin: 0;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  font-size: 15px;
  line-height: 1.8;
  color: #e0e0ff;
  white-space: pre-wrap;
  word-wrap: break-word;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

/* Responsive */
@media (max-width: 768px) {
  .lyrics-panel {
    bottom: 65px;
    right: 0;
    left: 0;
    width: 100%;
    height: 85vh;
    border-radius: 16px 16px 0 0;
  }

  .lyrics-text {
    font-size: 14px;
    line-height: 1.7;
  }
}

@media (max-width: 640px) {
  .lyrics-panel {
    height: 80vh;
  }

  .lyrics-text {
    font-size: 13px;
    line-height: 1.6;
  }
}

/* Transitions */
.lyrics-slide-enter-active,
.lyrics-slide-leave-active {
  transition: all 0.3s ease;
}

.lyrics-slide-enter-from,
.lyrics-slide-leave-to {
  opacity: 0;
  transform: translateY(20px);
}

/* ====================== ANIMATIONS ====================== */
@keyframes disc-spin {
  to {
    transform: rotate(360deg);
  }
}

@keyframes pulse-ring {
  0% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 0.7;
  }

  100% {
    transform: translate(-50%, -50%) scale(1.65);
    opacity: 0;
  }
}

/* ====================== RESPONSIVE ====================== */
@media (max-width: 768px) {
  .player-content {
    padding: 10px 16px;
    gap: 12px;
  }

  .player-wrapper.collapsed .player-disc {
    margin-left: calc(100vw - 62px - 40px);
  }

  .lyrics-panel {
    width: calc(100% - 32px);
    right: 16px;
    left: 16px;
    bottom: 72px;
  }
}

@media (max-width: 640px) {
  .player-volume {
    display: none;
  }
}

@media (max-width: 480px) {
  .player-btn--play {
    width: 36px;
    height: 36px;
  }

  .player-btn--skip,
  .player-btn--lyrics,
  .player-btn--close {
    width: 28px;
    height: 28px;
  }
}

.player-disc_lyrics {
  pointer-events: all;
  position: relative;
  width: 260px;
  height: 260px;
  border-radius: 10%;
  flex-shrink: 0;
  background-size: cover;
  background-position: center;
  cursor: pointer;
  overflow: hidden;
  box-shadow:
    0 0 0 2px rgba(0, 0, 0, 0.6),
    0 0 0 4px rgba(255, 255, 255, 0.08),
    0 4px 16px rgba(0, 0, 0, 0.5),
    0 0 16px rgba(59, 130, 246, 0.35);

  /* Transition vị trí + kích thước */
  transition:
    transform 0.45s cubic-bezier(0.4, 0, 0.2, 1),
    width 0.45s cubic-bezier(0.4, 0, 0.2, 1),
    height 0.45s cubic-bezier(0.4, 0, 0.2, 1),
    box-shadow 0.3s ease,
    margin-left 0.45s cubic-bezier(0.4, 0, 0.2, 1);
}

.lyrics-lines {
  display: flex;
  flex-direction: column;
  gap: 6px;
  padding: 8px 0;
}

.lyric-line {
  font-size: 15px;
  line-height: 1.8;
  color: rgba(255, 255, 255, 0.35);
  cursor: pointer;
  padding: 4px 8px;
  border-radius: 6px;
  transition: all 0.4s ease;
  font-family: system-ui, -apple-system, sans-serif;
}

.lyric-line--past {
  color: rgba(255, 255, 255, 0.5);
}

.lyric-line--active {
  color: #ffffff;
  font-size: 17px;
  font-weight: 600;
  text-shadow: 0 0 20px rgba(59, 130, 246, 0.8);
  transform: translateX(4px);
}

.lyric-line:hover {
  color: rgba(255, 255, 255, 0.7);
  background: rgba(255, 255, 255, 0.05);
}

.tiktok-card {
  background: linear-gradient(135deg, rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.2));
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 16px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
}

.tiktok-card:hover {
  transform: translateY(-4px);
}

/* Header */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.artist-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.artist-avatar-card {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  background: linear-gradient(135deg, #3b82f6, #8b5cf6);
  border: 2px solid rgba(255, 255, 255, 0.2);
  overflow: hidden;
}

.artist-avatar-card img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.artist-details-card {
  display: flex;
  flex-direction: column;
}

.artist-name-card {
  font-size: 15px;
  font-weight: 600;
  color: white;
}

.artist-handle {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
}

.follow-btn {
  background: rgba(59, 130, 246, 0.2);
  border: 1px solid rgba(59, 130, 246, 0.5);
  color: #3b82f6;
  padding: 6px 16px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.follow-btn:hover {
  background: #3b82f6;
  color: white;
  transform: scale(1.05);
}

/* Media */
.card-media {
  display: flex;
  justify-content: center;
  margin: 20px 0;
}

.player-disc_lyrics {
  position: relative;
  width: 200px;
  height: 200px;
  border-radius: 50%;
  background-size: cover;
  background-position: center;
  box-shadow:
    0 0 0 3px rgba(255, 255, 255, 0.1),
    0 0 0 6px rgba(255, 255, 255, 0.05),
    0 10px 30px rgba(0, 0, 0, 0.5);
  cursor: pointer;
  transition: transform 0.3s ease;
}

.player-disc_lyrics:hover {
  transform: scale(1.02);
}

.player-disc_lyrics.spinning {
  animation: disc-spin 4s linear infinite;
}

/* Play Overlay */
.play-overlay-card {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 50px;
  height: 50px;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(8px);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  cursor: pointer;
  opacity: 0;
  transition: all 0.3s ease;
  z-index: 10;
}

.player-disc_lyrics:hover .play-overlay-card {
  opacity: 1;
}

.play-overlay-card:hover {
  background: #3b82f6;
  transform: translate(-50%, -50%) scale(1.1);
}

/* Disc details */
.disc-grooves {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  background: repeating-radial-gradient(circle at 50% 50%, transparent 0px, transparent 3px, rgba(0, 0, 0, 0.13) 3px, rgba(0, 0, 0, 0.13) 4px);
  pointer-events: none;
}

.disc-hole {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 16px;
  height: 16px;
  border-radius: 50%;
  background: #0a0e16;
  border: 2px solid rgba(59, 130, 246, 0.65);
  z-index: 3;
}

.disc-pulse-card {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 100%;
  height: 100%;
  border-radius: 50%;
  border: 2px solid rgba(59, 130, 246, 0.5);
  animation: pulse-ring 1.8s ease-out infinite;
  pointer-events: none;
}

/* Card Info */
.card-info {
  text-align: center;
  margin: 16px 0;
}

.song-name {
  font-size: 18px;
  font-weight: 700;
  color: white;
  margin: 0 0 8px 0;
}

.song-description {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.7);
  margin: 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Card Footer */
.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 0;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  margin-bottom: 16px;
}

.music-tag,
.duration {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
}

/* Action Row */
.action-row {
  display: flex;
  justify-content: space-around;
  gap: 12px;
}

.action-btn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 10px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 30px;
  color: white;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.action-btn:hover {
  background: rgba(59, 130, 246, 0.2);
  border-color: rgba(59, 130, 246, 0.4);
  transform: translateY(-2px);
}

.like-btn:hover {
  background: rgba(239, 68, 68, 0.2);
  border-color: rgba(239, 68, 68, 0.4);
  color: #ef4444;
}

.comment-btn:hover {
  background: rgba(59, 130, 246, 0.2);
  border-color: rgba(59, 130, 246, 0.4);
  color: #3b82f6;
}

.share-btn:hover {
  background: rgba(16, 185, 129, 0.2);
  border-color: rgba(16, 185, 129, 0.4);
  color: #10b981;
}

/* Responsive */
@media (max-width: 768px) {
  .player-disc_lyrics {
    width: 160px;
    height: 160px;
  }

  .song-name {
    font-size: 16px;
  }

  .action-btn {
    font-size: 11px;
    padding: 8px;
  }

  .action-btn svg {
    width: 16px;
    height: 16px;
  }
}

@keyframes disc-spin {
  to {
    transform: rotate(360deg);
  }
}

@keyframes pulse-ring {
  0% {
    transform: translate(-50%, -50%) scale(1);
    opacity: 0.7;
  }

  100% {
    transform: translate(-50%, -50%) scale(1.5);
    opacity: 0;
  }
}

.lyrics-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 60%;
  gap: 12px;
  color: rgba(255,255,255,0.5);
  font-size: 14px;
}

.lyrics-loading-spinner {
  width: 28px;
  height: 28px;
  border: 2px solid rgba(255,255,255,0.1);
  border-top-color: #3b82f6;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>
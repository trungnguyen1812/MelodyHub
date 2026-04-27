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
            <svg v-if="isCollapsed" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor"
              stroke-width="2.5">
              <polyline points="15 3 21 3 21 9" />
              <polyline points="9 21 3 21 3 15" />
              <line x1="21" y1="3" x2="14" y2="10" />
              <line x1="3" y1="21" x2="10" y2="14" />
            </svg>
            <svg v-else width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <polyline points="4 14 10 14 10 20" />
              <polyline points="20 10 14 10 14 4" />
              <line x1="10" y1="14" x2="3" y2="21" />
              <line x1="21" y1="3" x2="14" y2="10" />
            </svg>
          </div>
        </div>

        <div class="player-expandable">
          <div class="player-info-wrap">
            <div class="player-info" @click="goToDetail">
              <p class="player-title">{{ player.currentSong.title }}</p>
              <p class="player-artist">{{ player.currentSong.artist?.name ?? '—' }}</p>
            </div>
          </div>

          <div class="player-seek-area">
            <span class="player-time">{{ formatTime(player.currentTime) }}</span>
            <div class="player-seek-wrap" @click.self="onSeekClick">
              <div class="player-seek-track">
                <div class="player-seek-fill"
                  :style="{ width: player.duration > 0 ? (player.currentTime / player.duration * 100) + '%' : '0%' }">
                </div>
                <div class="player-seek-thumb"
                  :style="{ left: player.duration > 0 ? (player.currentTime / player.duration * 100) + '%' : '0%' }">
                </div>
              </div>
              <input type="range" min="0" :max="player.duration" :value="player.currentTime" step="0.1"
                    class="player-seek-input" @input="onSeek" @click.stop />
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

          <div class="player-volume" ref="volumePopupRef">
              <button class="player-vol-icon" @click="toggleVolumePopup">
                <!-- Icon mute -->
                <svg v-if="player.isMuted || player.volume === 0" width="18" height="18" viewBox="0 0 24 24" fill="none"
                  stroke="currentColor" stroke-width="2">
                  <path d="M11 5L6 9H2V15H6L11 19V5Z" />
                  <line x1="23" y1="9" x2="17" y2="15" />
                  <line x1="17" y1="9" x2="23" y2="15" />
                </svg>
                <!-- Icon có âm thanh -->
                <svg v-else width="18" height="18" viewBox="0 0 24 24" fill="none"
                  stroke="currentColor" stroke-width="2">
                  <path d="M11 5L6 9H2V15H6L11 19V5Z" />
                  <path d="M15.54 8.46a5 5 0 0 1 0 7.07" />
                  <path v-if="player.volume > 0.5" d="M19.07 4.93a10 10 0 0 1 0 14.14" />
                </svg>
              </button>

              <!-- Popup volume - chỉ hiện khi showVolumePopup = true -->
              <div v-if="showVolumePopup" class="player-vol-popup">
                <div class="player-vol-wrap">
                  <div class="player-vol-track">
                    <div class="player-vol-fill" :style="{ width: (displayVolume * 100) + '%' }"></div>
                  </div>
                  <input 
                    type="range" 
                    min="0" 
                    max="1" 
                    step="0.05" 
                    :value="displayVolume"
                    class="player-vol-slider" 
                    @input="onVolumeChange"
                  />
                </div>
              </div>
          </div>

          <div class="player-timer" ref="timerPopupRef">
            <button class="player-timer-icon" @click="toggleTimerPopup" :class="{ active: timerRemaining > 0 }">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10" />
                <polyline points="12 6 12 12 16 14" />
              </svg>
              <span v-if="timerRemaining > 0" class="timer-badge">{{ formatTimerDisplay }}</span>
            </button>

            <!-- Popup timer -->
            <div v-if="showTimerPopup" class="player-timer-popup">
              <div class="timer-header">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <circle cx="12" cy="12" r="10" />
                  <polyline points="12 6 12 12 16 14" />
                </svg>
                <span>Timer stop</span>
              </div>
              <div class="timer-options">
                <button v-for="opt in timerOptions" :key="opt.minutes" 
                  class="timer-option" 
                  :class="{ active: timerSelected === opt.minutes }"
                  @click="setSleepTimer(opt.minutes)">
                  {{ opt.label }}
                </button>
              </div>
              <div v-if="timerRemaining > 0" class="timer-cancel" @click="cancelSleepTimer">
                🗑️ Turn off the timer.
              </div>
            </div>
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

        <!-- Loading state: chỉ khi đang fetch -->
        <div v-if="isLoadingLyrics" class="lyrics-loading">
          <div class="lyrics-loading-spinner"></div>
          <p>loading lyrics...</p>
        </div>

        <!-- Content: hiển thị sau khi fetch xong (dù có hay không có lyrics) -->
        <div v-else class="lyrics-content" :class="{ 'no-lyrics': !hasLyrics }">
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
                <ActionButton 
                  class="follow-btn"
                  type="follow" 
                  :item="{ 
                    id: player.currentSong!.artist!.id,
                    isActive: player.currentSong!.is_followed,   
                    count:    player.currentSong!.follower_count  
                  }"
                  @success="onFollowSuccess"
                />
              </div>

              <!-- Disc/Cover Art -->
              <div class="card-media">
                <div class="player-disc_lyrics" :class="{ spinning: player.isPlaying }" :style="getCoverStyle(player.currentSong!)">
                  <div class="disc-grooves"></div>
                  <div class="disc-hole"></div>
                  <div v-if="player.isPlaying" class="disc-pulse-card"></div>

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
                  <span>{{ formatNumber(player.currentSong?.stats?.total_plays || player.currentSong?.total_plays || 0) }}</span>
                  <span class="play-count-label">listens</span>
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
                <ActionButton 
                  type="like" 
                  :item="{ 
                    id: player.currentSong!.id,
                    isActive: player.currentSong!.is_liked,   
                    count:    player.currentSong!.like_count  
                  }" 
                />
                <ActionButton 
                  type="share" 
                  aria-label
                  :item="{ 
                    id: player.currentSong!.id,
                    // isActive: player.currentSong!.is_liked,   
                    // count:    player.currentSong!.like_count  
                  }" 
                />
              </div>

              <!-- No lyrics notice -->
              <div v-if="!hasLyrics" class="no-lyrics-notice">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <circle cx="12" cy="12" r="10"/>
                  <line x1="12" y1="8" x2="12" y2="12"/>
                  <line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
                <span>No lyrics available for this song</span>
              </div>
            </div>
          </div>

          <!-- div2 chỉ render khi có lyrics -->
          <div class="div2">
            <!-- Có lyrics → show lyrics bình thường -->
            <div v-if="hasLyrics" class="lyrics-lines">
              <div
                v-for="(line, i) in currentLyrics"
                :key="i"
                class="lyric-line"
                :class="{
                  'lyric-line--active': activeLyricIdx === i,
                  'lyric-line--past': activeLyricIdx > i
                }"
                @click="player.seek(line.start > 0 ? line.start : (i / currentLyrics.length) * player.duration)"
              >
                {{ line.text }}
              </div>
            </div>
          
            <!-- Không có lyrics → show quảng cáo thay thế -->
            <div v-else class="lyrics-ad-slot">
              <p class="lyrics-ad-slot__label">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                  <circle cx="12" cy="12" r="10"/>
                  <line x1="12" y1="8" x2="12" y2="12"/>
                  <line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
                No lyrics available
              </p>
              <VcAdBanner />
            </div>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, watch, onUnmounted, computed, nextTick, onMounted } from 'vue'
import { usePlayerStore } from '@/store/playerStore'
import type { Song } from '@/interfaces/songs.interface'
import { useRouter } from 'vue-router'
import { useSongStore } from '@/modules/client/stores/songs/songsStore'
import { getFullImageUrl } from '@/modules/client/stores/artists/artistsStore'
import songsService from '@/modules/client/services/songs/songs.service'
import ActionButton from '@/components/common/VcBtnAction/ActionButton.vue'
import VcAdBanner from '@/components/common/VcAd/VcAdBanner.vue'

// ─── Types ───────────────────────────────────────────────────────────────────
interface LyricLine {
  start: number
  end: number
  text: string
}

// ─── Stores & Router ─────────────────────────────────────────────────────────
const router = useRouter()
const player = usePlayerStore()
const songStore = useSongStore()

// ─── State ───────────────────────────────────────────────────────────────────
const isCollapsed = ref(false)
const showLyrics = ref(false)
const currentLyrics = ref<LyricLine[]>([])
const isLoadingLyrics = ref(false)
const lyricGradient = ref('linear-gradient(135deg, rgba(16, 16, 21, 0.95), rgba(10, 10, 15, 0.98))')

// ─── Volume Popup State ──────────────────────────────────────────────────────
const showVolumePopup = ref(false)
const volumePopupRef = ref<HTMLElement | null>(null)

// ─── Sleep Timer State ───────────────────────────────────────────────────────
const showTimerPopup = ref(false)
const timerPopupRef = ref<HTMLElement | null>(null)
const timerRemaining = ref(0)
const timerSelected = ref(0)
let timerInterval: ReturnType<typeof setInterval> | null = null

const timerOptions = [
  { minutes: 15, label: '15 minutes' },
  { minutes: 30, label: '30 minutes' },
  { minutes: 45, label: '45 minutes' },
  { minutes: 60, label: '60 minutes' },
]

// ─── Computed ─────────────────────────────────────────────────────────────────
const hasLyrics = computed(() => currentLyrics.value.length > 0)

const displayVolume = computed(() => {
  if (player.isMuted) return 0
  return player.volume
})

const formatTimerDisplay = computed(() => {
  if (timerRemaining.value <= 0) return ''
  const mins = Math.floor(timerRemaining.value / 60)
  const secs = timerRemaining.value % 60
  return `${mins}:${secs.toString().padStart(2, '0')}`
})

// ─── Navigation ──────────────────────────────────────────────────────────────
const goToDetail = () => {
  if (!player.currentSong) return
  router.push({ name: 'client.song.detail', params: { id: player.currentSong.id } })
}

// ─── Helpers ─────────────────────────────────────────────────────────────────
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

const getLyricGradient = (song: Song) => {
  if (!song) return 'linear-gradient(135deg, rgba(16, 16, 21, 0.95), rgba(10, 10, 15, 0.98))'
  const list = [
    'linear-gradient(135deg, rgba(59, 130, 246, 0.15), rgba(139, 92, 246, 0.08), rgba(10, 10, 15, 0.95))',
    'linear-gradient(135deg, rgba(236, 72, 153, 0.15), rgba(244, 114, 182, 0.08), rgba(10, 10, 15, 0.95))',
    'linear-gradient(135deg, rgba(16, 185, 129, 0.15), rgba(52, 211, 153, 0.08), rgba(10, 10, 15, 0.95))',
    'linear-gradient(135deg, rgba(245, 158, 11, 0.15), rgba(251, 191, 36, 0.08), rgba(10, 10, 15, 0.95))',
    'linear-gradient(135deg, rgba(239, 68, 68, 0.15), rgba(248, 113, 113, 0.08), rgba(10, 10, 15, 0.95))',
    'linear-gradient(135deg, rgba(139, 92, 246, 0.15), rgba(167, 139, 250, 0.08), rgba(10, 10, 15, 0.95))',
  ]
  return list[song.id % list.length]
}

const getArtistAvatarUrl = (artist: any) => {
  if (!artist?.avatar_url) return '/images/default-avatar.png'
  return getFullImageUrl(artist.avatar_url)
}

const handleImageError = (event: Event) => {
  const img = event.target as HTMLImageElement
  img.src = '/images/default-avatar.png'
}

const formatNumber = (n: number) =>
  n >= 1_000_000 ? (n / 1_000_000).toFixed(1) + 'M'
  : n >= 1_000 ? (n / 1_000).toFixed(1) + 'K'
  : String(n)

// ─── Seek / Volume ───────────────────────────────────────────────────────────
const onSeek = (e: Event) => player.seek(parseFloat((e.target as HTMLInputElement).value))

const onSeekClick = (e: MouseEvent) => {
  if (player.duration === 0) return
  const track = (e.currentTarget as HTMLElement).querySelector('.player-seek-track')
  if (!track) return
  const rect = track.getBoundingClientRect()
  const ratio = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width))
  player.seek(ratio * player.duration)
}

const onVolumeChange = (e: Event) => {
  const newVolume = parseFloat((e.target as HTMLInputElement).value)
  player.setVolume(newVolume)
  if (player.isMuted && newVolume > 0) {
    player.toggleMute()
  }
}

// ─── Volume Popup ───────────────────────────────────────────────────────────
const toggleVolumePopup = () => {
  showVolumePopup.value = !showVolumePopup.value
}

// ─── Sleep Timer ─────────────────────────────────────────────────────────────
const toggleTimerPopup = () => {
  showTimerPopup.value = !showTimerPopup.value
}

const setSleepTimer = (minutes: number) => {
  if (minutes === 0) {
    cancelSleepTimer()
    return
  }

  if (timerInterval) clearInterval(timerInterval)

  timerSelected.value = minutes
  timerRemaining.value = minutes * 60

  timerInterval = setInterval(() => {
    if (timerRemaining.value > 0) {
      timerRemaining.value--

      if (timerRemaining.value === 0) {
        if (timerInterval) clearInterval(timerInterval)
        timerInterval = null
        player.stop()
        timerSelected.value = 0
      }
    }
  }, 1000)

  showTimerPopup.value = false
}

const cancelSleepTimer = () => {
  if (timerInterval) {
    clearInterval(timerInterval)
    timerInterval = null
  }
  timerRemaining.value = 0
  timerSelected.value = 0
  showTimerPopup.value = false
}

// ─── Lyrics: extract ─────────────────────────────────────────────────────────
const extractLyrics = (lyrics: any): LyricLine[] => {
  if (!lyrics) return []

  const raw = (lyrics as any)?.__v_raw ?? lyrics
  let parsed: any = raw

  if (typeof raw === 'string') {
    const trimmed = raw.trim()
    if (!trimmed || trimmed === '[object Object]') return []
    try { parsed = JSON.parse(trimmed) } catch { return [] }
  }

  if (parsed?.type === 'timed' && Array.isArray(parsed.segments)) {
    const lines: LyricLine[] = parsed.segments.filter((s: any) => s?.text?.trim())
    if (lines.length > 0) return lines
  }

  if (parsed?.plain_text?.trim()) {
    return parsed.plain_text
      .split('\n')
      .map((text: string) => text.trim())
      .filter(Boolean)
      .map((text: string): LyricLine => ({ start: 0, end: 0, text }))
  }

  if (Array.isArray(parsed)) {
    const lines: LyricLine[] = parsed.filter((s: any) => s?.text?.trim())
    return lines
  }

  return []
}

// ─── Lyrics: active line ─────────────────────────────────────────────────────
const activeLyricIdx = computed(() => {
  if (!hasLyrics.value) return -1
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

// ─── Lyrics: toggle panel ────────────────────────────────────────────────────
const toggleLyrics = async () => {
  showLyrics.value = !showLyrics.value

  if (showLyrics.value && !hasLyrics.value && !isLoadingLyrics.value && player.currentSong?.id) {
    isLoadingLyrics.value = true
    try {
      const song = await songStore.fetchSong(player.currentSong.id).catch(() => null)
      currentLyrics.value = song?.lyrics ? extractLyrics(song.lyrics) : []
    } finally {
      isLoadingLyrics.value = false
    }
  }
}

// ─── Scroll active lyric into view ───────────────────────────────────────────
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

// ─── Follow Success Handler ──────────────────────────────────────────────────
const onFollowSuccess = (result: any) => {
  if (!player.currentSong) return
  player.updateFollowStatus(
    player.currentSong.id,
    result?.is_followed ?? false,
    result?.follower_count
  )
}

// ─── Click outside handler ───────────────────────────────────────────────────
const handleClickOutside = (event: MouseEvent) => {
  if (volumePopupRef.value && !volumePopupRef.value.contains(event.target as Node)) {
    showVolumePopup.value = false
  }
  if (timerPopupRef.value && !timerPopupRef.value.contains(event.target as Node)) {
    showTimerPopup.value = false
  }
}

// ─── Body scroll lock ────────────────────────────────────────────────────────
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

// ─── Watches ─────────────────────────────────────────────────────────────────
watch(
  () => player.currentSong,
  async (newSong) => {
    if (!newSong?.id) {
      currentLyrics.value = []
      isLoadingLyrics.value = false
      lyricGradient.value = 'linear-gradient(135deg, rgba(16, 16, 21, 0.95), rgba(10, 10, 15, 0.98))'
      showLyrics.value = false
      cancelSleepTimer() // Tắt timer khi không có bài
      return
    }

    player.restoreFollowStatus(newSong.id)

    lyricGradient.value = getLyricGradient(newSong)
    currentLyrics.value = []
    isLoadingLyrics.value = true

    if (newSong.lyrics) {
      currentLyrics.value = extractLyrics(newSong.lyrics)
      isLoadingLyrics.value = false
      return
    }

    try {
      const { data } = await songsService.getLyrics(newSong.id)
      currentLyrics.value = extractLyrics(data.lyrics)
    } catch {
      currentLyrics.value = []
    } finally {
      isLoadingLyrics.value = false
    }
  },
  { immediate: true }
)

watch(isCollapsed, (collapsed) => {
  if (collapsed) showLyrics.value = false
})

watch(showLyrics, (isOpen) => lockScroll(isOpen))

// ─── Lifecycle ───────────────────────────────────────────────────────────────
onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
  if (timerInterval) clearInterval(timerInterval)
  lockScroll(false)
})
</script>

<style scoped>
/* ====================== WRAPPER ====================== */
.player-wrapper {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  z-index: 9999;
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
  transition: justify-content 0s 0.35s;
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
  transition:
    transform 0.45s cubic-bezier(0.4, 0, 0.2, 1),
    width 0.45s cubic-bezier(0.4, 0, 0.2, 1),
    height 0.45s cubic-bezier(0.4, 0, 0.2, 1),
    box-shadow 0.3s ease,
    margin-left 0.45s cubic-bezier(0.4, 0, 0.2, 1);
}

.player-wrapper.collapsed .player-disc {
  width: 62px;
  height: 62px;
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

.disc-grooves {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  background: repeating-radial-gradient(circle at 50% 50%,
      transparent 0px, transparent 3px,
      rgba(0, 0, 0, 0.13) 3px, rgba(0, 0, 0, 0.13) 4px);
  pointer-events: none;
}

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
  overflow: visible !important;
}

.player-wrapper.collapsed .player-expandable {
  opacity: 0;
  transform: translateX(60px);
  max-width: 0;
  pointer-events: none;
}

/* ====================== INFO ====================== */
.player-info-wrap {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-shrink: 0;
  min-width: 154px;
  max-width: 250px;
}

.player-info {
  flex: 1;
  cursor: pointer;
  overflow: hidden;
}

.player-bar-like {
  background: transparent !important;
  border: none !important;
  padding: 4px !important;
  color: #9ca3af;
  opacity: 0.7;
  transition: all 0.2s;
}

.player-bar-like:hover {
  opacity: 1;
  transform: scale(1.1);
  color: #ef4444 !important;
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
  margin-top: 1px;
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
  position: relative;
  display: inline-flex;
  align-items: center;
   overflow: visible !important;
}

.player-vol-icon {
  background: transparent;
  border: none;
  cursor: pointer;
  padding: 8px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #ccc;
  transition: all 0.2s;
}

.player-vol-icon:hover {
  background: rgba(255, 255, 255, 0.1);
  color: #fff;
}

/* POPUP - cái này mới là quan trọng */
.player-vol-popup {
  position: absolute;
  bottom: 100%;
  left: 50%;
  transform: translateX(-50%);
  margin-bottom: 12px;
  background: #1e1e2e;
  backdrop-filter: blur(12px);
  border-radius: 12px;
  padding: 12px 16px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
  border: 1px solid rgba(255, 255, 255, 0.1);
  z-index: 10000;
  min-width: 100px;
  display: block;  /* ← THÊM DÒNG NÀY */
}

/* Mũi tên chỉ xuống icon */
.player-vol-popup::after {
  content: '';
  position: absolute;
  top: 100%;
  left: 50%;
  transform: translateX(-50%);
  border-width: 8px;
  border-style: solid;
  border-color: #1e1e2e transparent transparent transparent;
  filter: drop-shadow(0 2px 4px rgba(0,0,0,0.2));
}

.player-vol-wrap {
  width: 100px;
  height: 4px;
  position: relative;
}

.player-vol-track {
  width: 100%;
  height: 4px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 4px;
  position: relative;
}

.player-vol-fill {
  height: 100%;
  background: linear-gradient(90deg, #3b82f6, #06b6d4);
  border-radius: 4px;
  position: absolute;
  top: 0;
  left: 0;
  pointer-events: none;
}

.player-vol-slider {
  position: absolute;
  top: -8px;
  left: 0;
  width: 100%;
  height: 20px;
  opacity: 0;
  cursor: pointer;
  margin: 0;
}

/* Hover effect */
.player-vol-popup:hover .player-vol-track {
  height: 6px;
}

.player-vol-slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: #fff;
  cursor: pointer;
  box-shadow: 0 0 6px rgba(59, 130, 246, 0.6);
}
/* ====================== LYRICS PANEL ====================== */
.lyrics-panel {
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
  transition: background 0.5s ease;
}

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
  0% { transform: translateX(-30%) translateY(-30%); }
  100% { transform: translateX(30%) translateY(30%); }
}

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

/* ── Loading ── */
.lyrics-loading {
  position: relative;
  z-index: 2;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: calc(100% - 50px);
  gap: 12px;
  color: rgba(255, 255, 255, 0.5);
  font-size: 14px;
}

.lyrics-loading-spinner {
  width: 28px;
  height: 28px;
  border: 2px solid rgba(255, 255, 255, 0.1);
  border-top-color: #3b82f6;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* ── Content grid ── */
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

/* Khi không có lyrics → 1 cột, card căn giữa */
.lyrics-content.no-lyrics {
  grid-template-columns: 1fr;
  justify-items: center;
}

.lyrics-content.no-lyrics .div1 {
  grid-area: unset;
  width: 100%;
  max-width: 360px;
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

/* Scrollbar */
.lyrics-content::-webkit-scrollbar { width: 4px; }
.lyrics-content::-webkit-scrollbar-track { background: rgba(255, 255, 255, 0.05); border-radius: 4px; }
.lyrics-content::-webkit-scrollbar-thumb { background: rgba(59, 130, 246, 0.5); border-radius: 4px; }
.lyrics-content::-webkit-scrollbar-thumb:hover { background: rgba(59, 130, 246, 0.7); }

/* ── Lyric lines ── */
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

/* ── No lyrics notice ── */
.no-lyrics-notice {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-top: 16px;
  padding: 10px 16px;
  border-radius: 10px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.08);
  color: rgba(255, 255, 255, 0.4);
  font-size: 13px;
}

/* ── TikTok Card ── */
.tiktok-card {
  background: linear-gradient(135deg, rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.2));
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 16px;
  border: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
  width: 100%;
}

.tiktok-card:hover {
  transform: translateY(-4px);
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 4px 0;
}

.artist-info {
  display: flex;
  align-items: center;
  gap: 10px;
  min-width: 0;     
  flex: 4;        
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
  gap: 2px;
  min-width: 0;
}

.artist-name-card {
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.artist-handle {
  font-size: 12px;
  color: rgba(255,255,255,0.45);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.card-header :deep(.follow-btn) {
  width: fit-content !important;
  align-self: center;
  flex-shrink: 0;
  background: rgba(59, 130, 246, 0.15);
  border: 1px solid rgba(59, 130, 246, 0.4);
  color: #3b82f6;
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.card-header :deep(.follow-btn):hover {
  background: #3b82f6;
  border-color: #3b82f6;
  color: white;
  transform: scale(1.05);
}

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
  overflow: hidden;
  transition: transform 0.3s ease;
}

.player-disc_lyrics:hover {
  transform: scale(1.02);
}

.player-disc_lyrics.spinning {
  animation: disc-spin 4s linear infinite;
}

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
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

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

/* ====================== TRANSITIONS ====================== */
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
  to { transform: rotate(360deg); }
}

@keyframes pulse-ring {
  0% { transform: translate(-50%, -50%) scale(1); opacity: 0.7; }
  100% { transform: translate(-50%, -50%) scale(1.65); opacity: 0; }
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
    width: 100%;
    right: 0;
    left: 0;
    bottom: 65px;
    height: 85vh;
    border-radius: 16px 16px 0 0;
  }

  .lyrics-content {
    grid-template-columns: 1fr;
  }

  .div1 {
    grid-area: unset;
    position: static;
  }

  .div2 {
    grid-area: unset;
  }

  .lyrics-content.no-lyrics .div1 {
    max-width: 100%;
  }

  .player-disc_lyrics {
    width: 160px;
    height: 160px;
  }

  .song-name {
    font-size: 16px;
  }
}

@media (max-width: 640px) {
  .player-volume {
    display: none;
  }

  .lyrics-panel {
    height: 80vh;
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

  .action-btn {
    font-size: 11px;
    padding: 8px;
  }
}

/* Card info container */
.card-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

/* Wrapper cho play count */
.play-count-wrapper {
    display: flex;
    align-items: center;
    gap: 6px;
    margin-top: 8px;
    padding: 6px 12px;
    background: rgba(0, 0, 0, 0.05);
    border-radius: 20px;
    width: fit-content;
}

/* Icon headphones */
.play-count-wrapper i {
    font-size: 14px;
    color: #4a9eff;
}

/* Số lượt nghe */
.play-count {
    font-size: 16px;
    font-weight: 600;
    color: #333;
    margin-right: 2px;
}

/* Chữ "lượt nghe" */
.play-count-label {
    font-size: 12px;
    color: #666;
    font-weight: normal;
}

.lyrics-ad-slot {
  padding: 24px 16px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.lyrics-ad-slot__label {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.35);
}

/* ====================== SLEEP TIMER ====================== */
.player-timer {
  position: relative;
  display: inline-flex;
  align-items: center;
  margin-left: 4px;
}

.player-timer-icon {
  background: transparent;
  border: none;
  cursor: pointer;
  padding: 8px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #ccc;
  transition: all 0.2s;
  position: relative;
}

.player-timer-icon:hover {
  background: rgba(255, 255, 255, 0.1);
  color: #fff;
}

.player-timer-icon.active {
  color: #3b82f6;
}

.timer-badge {
  position: absolute;
  bottom: -2px;
  right: -2px;
  background: #3b82f6;
  color: white;
  font-size: 9px;
  font-weight: bold;
  padding: 2px 4px;
  border-radius: 10px;
  min-width: 28px;
  text-align: center;
}

.player-timer-popup {
  position: absolute;
  bottom: 100%;
  left: 50%;
  transform: translateX(-50%);
  margin-bottom: 12px;
  background: #1e1e2e;
  backdrop-filter: blur(12px);
  border-radius: 12px;
  padding: 12px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
  border: 1px solid rgba(255, 255, 255, 0.1);
  z-index: 10000;
  min-width: 140px;
}

.player-timer-popup::after {
  content: '';
  position: absolute;
  top: 100%;
  left: 50%;
  transform: translateX(-50%);
  border-width: 8px;
  border-style: solid;
  border-color: #1e1e2e transparent transparent transparent;
}

.timer-header {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding-bottom: 8px;
  margin-bottom: 8px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  font-size: 12px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.7);
}

.timer-options {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.timer-option {
  background: rgba(255, 255, 255, 0.05);
  border: none;
  padding: 8px 12px;
  border-radius: 8px;
  color: #ccc;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
  text-align: center;
}

.timer-option:hover {
  background: rgba(59, 130, 246, 0.3);
  color: #fff;
}

.timer-option.active {
  background: #3b82f6;
  color: white;
}

.timer-cancel {
  margin-top: 8px;
  padding-top: 8px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  text-align: center;
  font-size: 12px;
  color: #f87171;
  cursor: pointer;
  transition: all 0.2s;
}

.timer-cancel:hover {
  color: #ef4444;
  background: rgba(239, 68, 68, 0.1);
  border-radius: 6px;
}
</style>
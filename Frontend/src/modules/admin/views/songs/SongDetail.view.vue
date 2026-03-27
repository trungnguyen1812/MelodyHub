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
        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
      </svg>
      <p>{{ songStore.error }}</p>
      <button @click="loadSong">Retry</button>
    </div>

    <template v-else-if="song">

      <!-- ── HERO ── -->
      <div class="hero" :style="{ '--hero-gradient': heroGradient }">
        <div class="hero__backdrop"></div>
        <div class="hero__content">

          <!-- Back -->
          <button class="btn-back" @click="$router.back()">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
              <polyline points="15 18 9 12 15 6"/>
            </svg>
            Back
          </button>

          <div class="hero__main">
            <!-- Cover -->
            <div class="cover-wrap">
              <div class="cover"
                :style="song.cover_url
                  ? { backgroundImage: `url(${song.cover_url})`, backgroundSize: 'cover', backgroundPosition: 'center' }
                  : { background: heroGradient }"
              >
                <div v-if="!song.cover_url" class="cover__icon">
                  <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.6)" stroke-width="1.5">
                    <path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>
                  </svg>
                </div>
                <!-- Play overlay -->
                <div class="cover__overlay" @click="togglePlay">
                  <div class="cover__play-btn">
                    <svg v-if="isPlaying" width="28" height="28" viewBox="0 0 24 24" fill="white">
                      <rect x="6" y="4" width="4" height="16"/><rect x="14" y="4" width="4" height="16"/>
                    </svg>
                    <svg v-else width="28" height="28" viewBox="0 0 24 24" fill="white">
                      <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                  </div>
                </div>
              </div>
            </div>

            <!-- Info -->
            <div class="hero__info">
              <div class="hero__badges">
                <span class="status-badge" :class="'status--' + song.status">{{ song.status }}</span>
                <span v-if="song.is_premium" class="flag-badge flag--premium">⭐ Premium</span>
                <span v-if="song.is_explicit" class="flag-badge flag--explicit">🔞 Explicit</span>
                <span v-if="song.is_featured" class="flag-badge flag--featured">🔥 Featured</span>
              </div>

              <h1 class="hero__title">{{ song.title }}</h1>

              <div class="hero__artist" v-if="song.artist">
                <div class="artist-avatar" :style="song.artist.avatar_url ? { backgroundImage: `url(${song.artist.avatar_url})`, backgroundSize: 'cover' } : {}">
                  <span v-if="!song.artist.avatar_url">{{ song.artist.name[0] }}</span>
                </div>
                <span>{{ song.artist.name }}</span>
                <span v-if="song.album" class="hero__album">· {{ song.album.title }}</span>
              </div>

              <div class="hero__meta-row">
                <div class="meta-chip">
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                  </svg>
                  {{ song.duration_format }}
                </div>
                <div class="meta-chip" v-if="song.year">
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/>
                  </svg>
                  {{ song.year }}
                </div>
                <div class="meta-chip">
                  <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M3 18v-6a9 9 0 0 1 18 0v6"/>
                  </svg>
                  {{ song.quality.toUpperCase() }}
                </div>
                <div class="meta-chip" v-if="song.bitrate">{{ song.bitrate }} kbps</div>
              </div>

              <!-- Action buttons -->
              <div class="hero__actions">
                <button class="btn-edit" @click="goEdit">
                  <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                  </svg>
                  Edit Song
                </button>
                <button class="btn-delete" @click="confirmDelete">
                  <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="3 6 5 6 21 6"/>
                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                  </svg>
                  Delete
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- ── BODY ── -->
      <div class="detail-body">

        <!-- LEFT -->
        <div class="col-main">

          <!-- Audio Player -->
          <section class="card-section">
            <div class="section-heading">
              <div class="section-icon section-icon--green">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M3 18v-6a9 9 0 0 1 18 0v6"/>
                  <path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3z"/>
                  <path d="M3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/>
                </svg>
              </div>
              <h2 class="section-title">Audio Player</h2>
            </div>

            <!-- Quality selector -->
            <div class="quality-tabs">
              <button
                v-for="q in availableQualities"
                :key="q.key"
                class="quality-tab"
                :class="{ active: selectedQuality === q.key, disabled: !q.url }"
                @click="q.url && selectQuality(q.key)"
              >
                <span class="quality-tab__label">{{ q.label }}</span>
                <span class="quality-tab__sub">{{ q.desc }}</span>
                <span v-if="!q.url" class="quality-tab__lock">🔒</span>
              </button>
            </div>

            <!-- Waveform + controls -->
            <div class="player-wrap" v-if="currentUrl">
              <div class="waveform">
                <div v-for="(h, i) in waveHeights" :key="i"
                  class="wave-bar"
                  :class="{ played: (i / waveHeights.length) < (currentTime / (audioDuration || 1)) }"
                  :style="{ height: h + 'px' }"
                ></div>
              </div>

              <div class="player-progress">
                <span class="player-time">{{ formatTime(currentTime) }}</span>
                <input
                  type="range" min="0" :max="audioDuration" :value="currentTime" step="0.1"
                  class="seek-bar" @input="onSeek"
                />
                <span class="player-time">{{ formatTime(audioDuration) }}</span>
              </div>

              <div class="player-controls">
                <button class="ctrl-btn ctrl-btn--rewind" @click="rewind">
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="11 17 2 12 11 7 11 17"/><line x1="22" y1="12" x2="11" y2="12"/>
                  </svg>
                </button>
                <button class="ctrl-btn ctrl-btn--play" @click="togglePlay">
                  <svg v-if="isPlaying" width="22" height="22" viewBox="0 0 24 24" fill="white">
                    <rect x="6" y="4" width="4" height="16"/><rect x="14" y="4" width="4" height="16"/>
                  </svg>
                  <svg v-else width="22" height="22" viewBox="0 0 24 24" fill="white">
                    <polygon points="5 3 19 12 5 21 5 3"/>
                  </svg>
                </button>
                <button class="ctrl-btn ctrl-btn--forward" @click="forward">
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="13 17 22 12 13 7 13 17"/><line x1="2" y1="12" x2="13" y2="12"/>
                  </svg>
                </button>
                <div class="volume-wrap">
                  <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/>
                    <path d="M19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07"/>
                  </svg>
                  <input type="range" min="0" max="1" step="0.05" v-model="volume" class="volume-bar" @input="onVolumeChange"/>
                </div>
              </div>
            </div>
            <div v-else class="player-no-url">
              <p>Audio chưa được xử lý hoặc không có quyền truy cập.</p>
            </div>

            <!-- URL list -->
            <div class="url-list">
              <div v-for="q in availableQualities" :key="q.key" class="url-item">
                <div class="url-item__left">
                  <span class="url-badge" :class="'url-badge--' + q.key">{{ q.label }}</span>
                  <span class="url-item__desc">{{ q.desc }}</span>
                </div>
                <div class="url-item__right">
                  <span v-if="q.url" class="url-item__url">{{ q.url.slice(0, 50) }}…</span>
                  <span v-else class="url-item__null">null — chưa xử lý / không có quyền</span>
                </div>
              </div>
            </div>
          </section>

          <!-- Lyrics -->
          <section class="card-section" v-if="song.lyrics">
            <div class="section-heading">
              <div class="section-icon section-icon--purple">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                  <polyline points="14 2 14 8 20 8"/>
                  <line x1="16" y1="13" x2="8" y2="13"/>
                  <line x1="16" y1="17" x2="8" y2="17"/>
                </svg>
              </div>
              <h2 class="section-title">Lyrics</h2>
            </div>
            <pre class="lyrics-block">{{ song.lyrics }}</pre>
          </section>
        </div>

        <!-- RIGHT -->
        <div class="col-side">

          <!-- Stats -->
          <section class="card-section">
            <div class="section-heading">
              <div class="section-icon section-icon--blue">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <line x1="18" y1="20" x2="18" y2="10"/>
                  <line x1="12" y1="20" x2="12" y2="4"/>
                  <line x1="6" y1="20" x2="6" y2="14"/>
                </svg>
              </div>
              <h2 class="section-title">Statistics</h2>
            </div>
            <div class="stats-grid">
              <div class="stat-card">
                <p class="stat-value">{{ formatNumber(song.stats.total_plays) }}</p>
                <p class="stat-label">Plays</p>
              </div>
              <div class="stat-card">
                <p class="stat-value">{{ formatNumber(song.stats.total_likes) }}</p>
                <p class="stat-label">Likes</p>
              </div>
              <div class="stat-card">
                <p class="stat-value">{{ formatNumber(song.stats.total_comments) }}</p>
                <p class="stat-label">Comments</p>
              </div>
              <div class="stat-card">
                <p class="stat-value">{{ formatNumber(song.stats.total_shares) }}</p>
                <p class="stat-label">Shares</p>
              </div>
              <div class="stat-card stat-card--full">
                <p class="stat-value">{{ formatNumber(song.stats.total_downloads) }}</p>
                <p class="stat-label">Downloads</p>
              </div>
            </div>
          </section>

          <!-- Metadata -->
          <section class="card-section">
            <div class="section-heading">
              <div class="section-icon section-icon--orange">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <circle cx="12" cy="12" r="10"/>
                  <line x1="12" y1="8" x2="12" y2="12"/>
                  <line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
              </div>
              <h2 class="section-title">Metadata</h2>
            </div>
            <div class="meta-list">
              <div class="meta-row" v-if="song.isrc">
                <span class="meta-key">ISRC</span>
                <span class="meta-val meta-val--mono">{{ song.isrc }}</span>
              </div>
              <div class="meta-row" v-if="song.copyright_owner">
                <span class="meta-key">Copyright</span>
                <span class="meta-val">{{ song.copyright_owner }}</span>
              </div>
              <div class="meta-row" v-if="song.license_type">
                <span class="meta-key">License</span>
                <span class="meta-val">{{ song.license_type }}</span>
              </div>
              <div class="meta-row" v-if="song.track_number">
                <span class="meta-key">Track</span>
                <span class="meta-val">{{ song.track_number }} / Disc {{ song.disc_number ?? 1 }}</span>
              </div>
              <div class="meta-row" v-if="song.file_size">
                <span class="meta-key">File size</span>
                <span class="meta-val">{{ formatBytes(song.file_size) }}</span>
              </div>
              <div class="meta-row">
                <span class="meta-key">Created</span>
                <span class="meta-val">{{ formatDate(song.created_at) }}</span>
              </div>
              <div class="meta-row">
                <span class="meta-key">Updated</span>
                <span class="meta-val">{{ formatDate(song.updated_at) }}</span>
              </div>
              <div class="meta-row" v-if="song.partner">
                <span class="meta-key">Partner</span>
                <span class="meta-val">{{ song.partner.company_name }}</span>
              </div>
            </div>
          </section>

          <!-- Artist card -->
          <section class="card-section" v-if="song.artist">
            <div class="section-heading">
              <div class="section-icon section-icon--pink">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                  <circle cx="12" cy="7" r="4"/>
                </svg>
              </div>
              <h2 class="section-title">Artist</h2>
            </div>
            <div class="artist-card">
              <div class="artist-card__avatar"
                :style="song.artist.avatar_url
                  ? { backgroundImage: `url(${song.artist.avatar_url})`, backgroundSize: 'cover' }
                  : {}"
              >
                <span v-if="!song.artist.avatar_url">{{ song.artist.name[0] }}</span>
              </div>
              <div class="artist-card__info">
                <p class="artist-card__name">{{ song.artist.name }}</p>
                <p class="artist-card__slug">@{{ song.artist.slug }}</p>
              </div>
            </div>
          </section>

          <!-- Album card -->
          <section class="card-section" v-if="song.album">
            <div class="section-heading">
              <div class="section-icon section-icon--teal">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <rect x="3" y="3" width="18" height="18" rx="2"/>
                  <circle cx="12" cy="12" r="3"/>
                </svg>
              </div>
              <h2 class="section-title">Album</h2>
            </div>
            <div class="album-card">
              <div class="album-card__cover"
                :style="song.album.cover_url
                  ? { backgroundImage: `url(${song.album.cover_url})`, backgroundSize: 'cover' }
                  : { background: 'linear-gradient(135deg,#a78bfa,#7c3aed)' }"
              ></div>
              <div>
                <p class="album-card__title">{{ song.album.title }}</p>
                <p class="album-card__slug">{{ song.album.slug }}</p>
              </div>
            </div>
          </section>

        </div>
      </div>
    </template>

  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useSongStore } from '@/modules/admin/stores/songs/songsStore'
import type { Song } from '@/modules/admin/interfaces/songs/songs.interface'

const route      = useRoute()
const router     = useRouter()
const songStore  = useSongStore()

const song = computed<Song | null>(() => songStore.currentSong)

// ── Hero gradient ──
const gradients = [
  'linear-gradient(135deg,#00c6ff,#0072ff)',
  'linear-gradient(135deg,#f093fb,#f5576c)',
  'linear-gradient(135deg,#43e97b,#38f9d7)',
  'linear-gradient(135deg,#f7971e,#ffd200)',
  'linear-gradient(135deg,#a18cd1,#fbc2eb)',
]
const heroGradient = computed(() =>
  gradients[(song.value?.id ?? 0) % gradients.length]
)

// ── Audio ──
const audio          = ref<HTMLAudioElement | null>(null)
const isPlaying      = ref(false)
const currentTime    = ref(0)
const audioDuration  = ref(0)
const volume         = ref(1)
const selectedQuality = ref<'low' | 'standard' | 'lossless'>('standard')

const availableQualities = computed<{
  key: Quality
  label: string
  desc: string
  url: string | null
}[]>(() => [
  {
    key: 'low',
    label: 'Low',
    desc: '128 kbps · Mobile',
    url: song.value?.urls.low ?? null
  },
  {
    key: 'standard',
    label: 'Standard',
    desc: '320 kbps · Default',
    url: song.value?.urls.standard ?? null
  },
  {
    key: 'lossless',
    label: 'Lossless',
    desc: 'FLAC · Premium',
    url: song.value?.urls.lossless ?? null
  }
])

const currentUrl = computed(() => {
  if (!song.value) return null
  return song.value.urls[selectedQuality.value]
    ?? song.value.urls.standard
    ?? song.value.urls.low
    ?? null
})

const waveHeights = [8,14,20,28,18,10,24,32,16,12,26,20,8,30,18,14,22,28,10,20,
                     12,24,16,8,28,20,14,32,18,10,22,26,8,16,30,20,24,12,18,28]

type Quality = 'low' | 'standard' | 'lossless'



const selectQuality = (q: Quality) => {
  const wasPlaying = isPlaying.value
  const savedTime  = currentTime.value

  selectedQuality.value = q
  destroyAudio()

  if (wasPlaying) {
    initAudio(savedTime)
    audio.value?.play()
    isPlaying.value = true
  }
}

const initAudio = (startTime = 0) => {
  if (!currentUrl.value) return
  audio.value = new Audio(currentUrl.value)
  audio.value.volume = volume.value
  audio.value.currentTime = startTime
  audio.value.ontimeupdate = () => { currentTime.value = audio.value?.currentTime ?? 0 }
  audio.value.onloadedmetadata = () => { audioDuration.value = audio.value?.duration ?? 0 }
  audio.value.onended = () => { isPlaying.value = false }
}

const destroyAudio = () => {
  audio.value?.pause()
  audio.value = null
  isPlaying.value = false
}

const togglePlay = () => {
  if (!currentUrl.value) return
  if (!audio.value) initAudio()
  if (isPlaying.value) {
    audio.value?.pause()
    isPlaying.value = false
  } else {
    audio.value?.play()
    isPlaying.value = true
  }
}

const onSeek = (e: Event) => {
  const val = parseFloat((e.target as HTMLInputElement).value)
  if (audio.value) audio.value.currentTime = val
  currentTime.value = val
}

const rewind  = () => { if (audio.value) audio.value.currentTime = Math.max(0, audio.value.currentTime - 10) }
const forward = () => { if (audio.value) audio.value.currentTime = Math.min(audioDuration.value, audio.value.currentTime + 10) }

const onVolumeChange = () => {
  if (audio.value) audio.value.volume = volume.value
}

// ── Helpers ──
const formatTime = (s: number) => {
  const m = Math.floor(s / 60)
  const sec = Math.floor(s % 60)
  return `${m}:${String(sec).padStart(2, '0')}`
}

const formatNumber = (n: number) =>
  n >= 1_000_000 ? (n / 1_000_000).toFixed(1) + 'M'
  : n >= 1_000   ? (n / 1_000).toFixed(1) + 'K'
  : String(n)

const formatDate = (iso: string) =>
  new Date(iso).toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' })

const formatBytes = (bytes: number) =>
  bytes >= 1024 * 1024
    ? (bytes / (1024 * 1024)).toFixed(2) + ' MB'
    : (bytes / 1024).toFixed(1) + ' KB'

// ── Actions ──
const goEdit = () => router.push({ name: 'admin.songsmanager.edit', params: { id: song.value?.id } })

const confirmDelete = () => {
  if (!confirm(`Xóa bài "${song.value?.title}"? Hành động này không thể hoàn tác.`)) return
  // TODO: gọi songStore.deleteSong(song.value!.id) sau khi có hàm delete
  router.push({ name: 'admin.songsmanager.all' })
}

// ── Load ──
const loadSong = async () => {
  const idOrSlug = route.params.id as string
  await songStore.fetchSong(idOrSlug)
}

onMounted(() => loadSong())
onBeforeUnmount(() => destroyAudio())
</script>

<style scoped>
.song-detail-page { min-height: 100vh; }

/* ── Loading ── */
.loading-wrap { padding: 24px; display: flex; flex-direction: column; gap: 16px; }
.skeleton-hero { height: 280px; border-radius: 16px; background: linear-gradient(90deg,#1e2535 25%,#2d3748 50%,#1e2535 75%); background-size: 200% 100%; animation: shimmer 1.4s infinite; }
.skeleton-body { display: grid; grid-template-columns: 1fr 320px; gap: 16px; }
.skeleton-block { height: 120px; border-radius: 12px; background: linear-gradient(90deg,#1e2535 25%,#2d3748 50%,#1e2535 75%); background-size: 200% 100%; animation: shimmer 1.4s infinite; }
@keyframes shimmer { 0% { background-position: 200% 0; } 100% { background-position: -200% 0; } }

/* ── Error ── */
.error-state { text-align: center; padding: 60px 20px; color: #f87171; }
.error-state p { margin: 12px 0; font-size: 14px; }
.error-state button { padding: 8px 24px; background: rgba(248,113,113,.1); border: 1px solid #f87171; border-radius: 8px; color: #f87171; cursor: pointer; }

/* ── Hero ── */
.hero { position: relative; border-radius: 16px; overflow: hidden; margin-bottom: 20px; }
.hero__backdrop { position: absolute; inset: 0; background: var(--hero-gradient); opacity: .15; }
.hero__content { position: relative; padding: 24px; }
.btn-back { display: flex; align-items: center; gap: 6px; padding: 7px 14px; background: rgba(0,0,0,.25); border: 1px solid rgba(255,255,255,.1); border-radius: 8px; color: #94a3b8; font-size: 13px; cursor: pointer; margin-bottom: 20px; transition: color .2s; }
.btn-back:hover { color: #e2e8f0; }
.hero__main { display: flex; align-items: flex-start; gap: 28px; }

/* Cover */
.cover-wrap { flex-shrink: 0; }
.cover { width: 180px; height: 180px; border-radius: 14px; display: flex; align-items: center; justify-content: center; position: relative; overflow: hidden; cursor: pointer; }
.cover__icon { display: flex; align-items: center; justify-content: center; }
.cover__overlay { position: absolute; inset: 0; background: rgba(0,0,0,.35); display: flex; align-items: center; justify-content: center; opacity: 0; transition: opacity .2s; }
.cover:hover .cover__overlay { opacity: 1; }
.cover__play-btn { width: 56px; height: 56px; border-radius: 50%; background: rgba(255,255,255,.2); border: 2px solid rgba(255,255,255,.5); display: flex; align-items: center; justify-content: center; }

/* Info */
.hero__info { flex: 1; }
.hero__badges { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 10px; }
.hero__title { font-size: 28px; font-weight: 700; color: #f1f5f9; line-height: 1.2; margin-bottom: 10px; }
.hero__artist { display: flex; align-items: center; gap: 8px; font-size: 14px; color: #94a3b8; margin-bottom: 14px; }
.artist-avatar { width: 28px; height: 28px; border-radius: 50%; background: linear-gradient(135deg,#00c6ff,#0072ff); display: flex; align-items: center; justify-content: center; font-size: 12px; font-weight: 700; color: #fff; flex-shrink: 0; }
.hero__album { color: #64748b; }
.hero__meta-row { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 18px; }
.meta-chip { display: flex; align-items: center; gap: 5px; padding: 5px 10px; background: rgba(0,0,0,.2); border: 1px solid #1e2535; border-radius: 20px; font-size: 12px; color: #64748b; }
.hero__actions { display: flex; gap: 10px; }
.btn-edit { display: flex; align-items: center; gap: 7px; padding: 9px 18px; background: linear-gradient(90deg,#00c6ff,#0072ff); border: none; border-radius: 9px; color: #fff; font-size: 13px; font-weight: 600; cursor: pointer; transition: opacity .2s; }
.btn-edit:hover { opacity: .85; }
.btn-delete { display: flex; align-items: center; gap: 7px; padding: 9px 18px; background: rgba(248,113,113,.1); border: 1px solid rgba(248,113,113,.3); border-radius: 9px; color: #f87171; font-size: 13px; cursor: pointer; transition: all .2s; }
.btn-delete:hover { background: rgba(248,113,113,.2); }

/* Badges */
.status-badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 11.5px; font-weight: 600; text-transform: capitalize; }
.status--published { background: rgba(67,233,123,.15); color: #43e97b; }
.status--draft     { background: rgba(100,116,139,.15); color: #64748b; }
.status--blocked   { background: rgba(248,113,113,.15); color: #f87171; }
.status--processing { background: rgba(251,191,36,.15); color: #fbbf24; }
.status--processing_failed { background: rgba(248,113,113,.15); color: #f87171; }
.flag-badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 11.5px; }
.flag--premium  { background: rgba(251,191,36,.12); color: #fbbf24; }
.flag--explicit { background: rgba(248,113,113,.12); color: #f87171; }
.flag--featured { background: rgba(251,146,60,.12);  color: #fb923c; }

/* ── Body ── */
.detail-body { display: grid; grid-template-columns: 1fr 300px; gap: 20px; align-items: start; }

/* ── Section ── */
.card-section { background: rgba(0,0,0,.2); border: 1px solid #1e2535; border-radius: 14px; padding: 20px; margin-bottom: 16px; }
.section-heading { display: flex; align-items: center; gap: 10px; margin-bottom: 16px; }
.section-icon { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.section-icon--green  { background: rgba(67,233,123,.12);  color: #43e97b; }
.section-icon--blue   { background: rgba(0,198,255,.12);   color: #00c6ff; }
.section-icon--purple { background: rgba(167,139,250,.12); color: #a78bfa; }
.section-icon--orange { background: rgba(251,146,60,.12);  color: #fb923c; }
.section-icon--pink   { background: rgba(244,114,182,.12); color: #f472b6; }
.section-icon--teal   { background: rgba(45,212,191,.12);  color: #2dd4bf; }
.section-title { font-size: 15px; font-weight: 600; color: #f1f5f9; }

/* ── Player ── */
.quality-tabs { display: flex; gap: 8px; margin-bottom: 16px; }
.quality-tab { flex: 1; padding: 10px 12px; background: #0f1117; border: 1px solid #2d3748; border-radius: 10px; cursor: pointer; text-align: left; transition: all .2s; }
.quality-tab.active { border-color: #00c6ff; background: rgba(0,198,255,.08); }
.quality-tab.disabled { opacity: .45; cursor: not-allowed; }
.quality-tab__label { display: block; font-size: 13px; font-weight: 600; color: #e2e8f0; }
.quality-tab__sub   { display: block; font-size: 11px; color: #64748b; margin-top: 2px; }
.quality-tab__lock  { display: block; font-size: 11px; margin-top: 2px; }

.player-wrap { background: #0f1117; border: 1px solid #1e2535; border-radius: 12px; padding: 16px; }
.waveform { display: flex; align-items: flex-end; gap: 2px; height: 48px; margin-bottom: 12px; }
.wave-bar { flex: 1; background: #2d3748; border-radius: 2px; min-height: 3px; transition: background .1s; }
.wave-bar.played { background: linear-gradient(180deg,#00c6ff,rgba(0,114,255,.4)); }

.player-progress { display: flex; align-items: center; gap: 10px; margin-bottom: 12px; }
.player-time { font-size: 11.5px; color: #64748b; min-width: 36px; }
.seek-bar { flex: 1; height: 3px; accent-color: #00c6ff; cursor: pointer; }

.player-controls { display: flex; align-items: center; justify-content: center; gap: 12px; }
.ctrl-btn { background: none; border: none; color: #94a3b8; cursor: pointer; display: flex; align-items: center; justify-content: center; border-radius: 8px; padding: 6px; transition: color .2s; }
.ctrl-btn:hover { color: #e2e8f0; }
.ctrl-btn--play { width: 44px; height: 44px; border-radius: 50%; background: linear-gradient(90deg,#00c6ff,#0072ff); color: white; }
.ctrl-btn--play:hover { opacity: .85; }

.volume-wrap { display: flex; align-items: center; gap: 6px; margin-left: 8px; }
.volume-bar { width: 70px; height: 3px; accent-color: #00c6ff; cursor: pointer; }

.player-no-url { text-align: center; padding: 20px; color: #64748b; font-size: 13px; }

.url-list { display: flex; flex-direction: column; gap: 8px; margin-top: 12px; }
.url-item { display: flex; align-items: center; justify-content: space-between; background: #0f1117; border: 1px solid #1e2535; border-radius: 8px; padding: 8px 12px; gap: 12px; }
.url-item__left { display: flex; align-items: center; gap: 8px; flex-shrink: 0; }
.url-badge { padding: 2px 8px; border-radius: 6px; font-size: 11px; font-weight: 600; }
.url-badge--low      { background: rgba(100,116,139,.15); color: #94a3b8; }
.url-badge--standard { background: rgba(0,198,255,.12);   color: #00c6ff; }
.url-badge--lossless { background: rgba(167,139,250,.12); color: #a78bfa; }
.url-item__desc { font-size: 11.5px; color: #64748b; }
.url-item__url  { font-size: 11px; color: #334155; font-family: monospace; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 300px; }
.url-item__null { font-size: 11px; color: #334155; font-style: italic; }

/* ── Lyrics ── */
.lyrics-block { white-space: pre-wrap; font-size: 13.5px; line-height: 1.9; color: #94a3b8; font-family: inherit; background: #0f1117; border: 1px solid #1e2535; border-radius: 10px; padding: 16px; max-height: 400px; overflow-y: auto; }

/* ── Stats ── */
.stats-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
.stat-card { background: #0f1117; border: 1px solid #1e2535; border-radius: 10px; padding: 14px; text-align: center; }
.stat-card--full { grid-column: 1 / -1; }
.stat-value { font-size: 22px; font-weight: 700; color: #00c6ff; }
.stat-label { font-size: 11.5px; color: #64748b; margin-top: 3px; text-transform: uppercase; letter-spacing: .05em; }

/* ── Meta list ── */
.meta-list { display: flex; flex-direction: column; gap: 8px; }
.meta-row { display: flex; justify-content: space-between; align-items: center; padding: 7px 0; border-bottom: 1px solid #1e2535; }
.meta-row:last-child { border-bottom: none; }
.meta-key { font-size: 12px; color: #64748b; font-weight: 500; }
.meta-val { font-size: 12.5px; color: #94a3b8; text-align: right; }
.meta-val--mono { font-family: monospace; font-size: 11.5px; }

/* ── Artist / Album card ── */
.artist-card { display: flex; align-items: center; gap: 12px; }
.artist-card__avatar { width: 48px; height: 48px; border-radius: 50%; background: linear-gradient(135deg,#00c6ff,#0072ff); display: flex; align-items: center; justify-content: center; font-size: 18px; font-weight: 700; color: #fff; flex-shrink: 0; }
.artist-card__name { font-size: 14px; font-weight: 600; color: #f1f5f9; }
.artist-card__slug { font-size: 12px; color: #64748b; margin-top: 2px; }

.album-card { display: flex; align-items: center; gap: 12px; }
.album-card__cover { width: 48px; height: 48px; border-radius: 8px; background: linear-gradient(135deg,#a78bfa,#7c3aed); flex-shrink: 0; }
.album-card__title { font-size: 14px; font-weight: 600; color: #f1f5f9; }
.album-card__slug { font-size: 12px; color: #64748b; margin-top: 2px; }

/* ── Responsive ── */
@media (max-width: 1024px) {
  .detail-body { grid-template-columns: 1fr; }
  .hero__main { flex-direction: column; }
  .quality-tabs { flex-wrap: wrap; }
}
@media (max-width: 640px) {
  .hero__title { font-size: 22px; }
  .cover { width: 140px; height: 140px; }
  .stats-grid { grid-template-columns: 1fr 1fr; }
}
</style>
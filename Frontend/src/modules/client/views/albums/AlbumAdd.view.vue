<template>
  <div class="wizard-shell">
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
        <span class="topbar-label">New Album</span>
      </div>

      <div class="step-pills">
        <button
          v-for="(s, i) in steps"
          :key="i"
          class="step-pill"
          :class="{ active: currentStep === i, done: currentStep > i }"
          @click="currentStep > i && (currentStep = i)"
        >
          <span class="pill-num">
            <svg v-if="currentStep > i" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" width="12" height="12">
              <path fill-rule="evenodd" d="M12.416 3.376a.75.75 0 0 1 .208 1.04l-5 7.5a.75.75 0 0 1-1.154.114l-3-3a.75.75 0 0 1 1.06-1.06l2.353 2.353 4.493-6.74a.75.75 0 0 1 1.04-.207Z" clip-rule="evenodd" />
            </svg>
            <span v-else>{{ i + 1 }}</span>
          </span>
          <span class="pill-label">{{ s.label }}</span>
        </button>
      </div>
    </header>

    <!-- Progress bar -->
    <div class="progress-bar">
      <div class="progress-fill" :style="{ width: progressWidth }"></div>
    </div>

    <!-- Step panels -->
    <main class="wizard-body">

      <!-- ─── STEP 0: Pick Tracks ─── -->
      <transition name="slide-fade" mode="out-in">
        <section v-if="currentStep === 0" key="step0" class="step-panel">
          <div class="step-intro">
            <div class="step-icon-wrap">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="28" height="28">
                <path fill-rule="evenodd" d="M19.952 1.651a.75.75 0 0 1 .298.599V16.303a3 3 0 0 1-2.176 2.884l-1.32.377a2.553 2.553 0 1 1-1.403-4.909l2.311-.66a1.5 1.5 0 0 0 1.088-1.442V6.994l-9 2.572V21a3 3 0 0 1-2.176 2.884l-1.32.377a2.553 2.553 0 1 1-1.402-4.909l2.31-.66A1.5 1.5 0 0 0 8.25 17.25V5.251a.75.75 0 0 1 .544-.721l10.5-3a.75.75 0 0 1 .658.121Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="step-title">Select tracks</h2>
              <p class="step-sub">Pick the songs that belong to this album. You can reorder them after.</p>
            </div>
          </div>

          <!-- Filter bar -->
          <div class="filter-bar">
            <div class="track-search-bar">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16" class="search-icon">
                <path fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11ZM2 9a7 7 0 1 1 12.452 4.391l3.328 3.329a.75.75 0 1 1-1.06 1.06l-3.329-3.328A7 7 0 0 1 2 9Z" clip-rule="evenodd" />
              </svg>
              <input v-model="trackSearch" placeholder="Search by title…" class="track-search-input" />
              <span v-if="trackSearch" class="search-clear" @click="trackSearch = ''">✕</span>
            </div>

            <div class="artist-filter-wrap">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15" class="filter-icon">
                <path d="M10 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM3.465 14.493a1.23 1.23 0 0 0 .41 1.412A9.957 9.957 0 0 0 10 18c2.31 0 4.438-.784 6.131-2.1.43-.333.604-.903.408-1.41a7.002 7.002 0 0 0-13.074.003Z" />
              </svg>
              <select v-model="filterArtistId" class="artist-filter-select">
                <option value="">All artists</option>
                <option v-for="a in artists" :key="a.id" :value="a.id">
                  {{ a.name || `Artist #${a.id}` }}
                </option>
              </select>
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14" class="select-chevron">
                <path fill-rule="evenodd" d="M5.22 8.22a.75.75 0 0 1 1.06 0L10 11.94l3.72-3.72a.75.75 0 1 1 1.06 1.06l-4.25 4.25a.75.75 0 0 1-1.06 0L5.22 9.28a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd" />
              </svg>
            </div>
          </div>

          <!-- Artist pills (quick filter) -->
          <div class="artist-pills">
            <button
              class="artist-pill"
              :class="{ active: filterArtistId === '' }"
              @click="filterArtistId = ''"
            >All</button>
            <button
              v-for="a in artists"
              :key="a.id"
              class="artist-pill"
              :class="{ active: filterArtistId === a.id }"
              @click="filterArtistId = filterArtistId === a.id ? '' : a.id"
            >
              {{ a.name || `Artist #${a.id}` }}
            </button>
          </div>

          <!-- Active filter indicator -->
          <div v-if="filterArtistId" class="active-filter-bar">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
              <path fill-rule="evenodd" d="M3 10a7 7 0 1 1 14 0 7 7 0 0 1-14 0Zm7-5a1 1 0 1 0 0 2 1 1 0 0 0 0-2Zm-1 4a1 1 0 1 1 2 0v3a1 1 0 1 1-2 0V9Z" clip-rule="evenodd" />
            </svg>
            Filtering by <strong>{{ activeArtistName }}</strong>
            <button class="clear-filter" @click="filterArtistId = ''">Clear</button>
          </div>

          <!-- Track list -->
          <div class="track-list" v-if="filteredTracks.length">
            <div
              v-for="(track, idx) in filteredTracks"
              :key="track.id"
              class="track-row"
              :class="{ selected: isSelected(track.id) }"
              @click="toggleTrack(track)"
            >
              <div class="track-num">{{ idx + 1 }}</div>
              <div class="track-cover">
                <img :src="track.cover || defaultCover" :alt="track.title" />
                <div class="track-play-overlay">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
                    <path d="M6.3 2.841A1.5 1.5 0 004 4.11V15.89a1.5 1.5 0 002.3 1.269l9.344-5.89a1.5 1.5 0 000-2.538L6.3 2.84z" />
                  </svg>
                </div>
              </div>
              <div class="track-info">
                <span class="track-title">{{ track.title }}</span>
                <span class="track-artist">{{ track.artist }}</span>
              </div>
              <div class="track-meta">
                <span class="track-duration">{{ track.duration }}</span>
              </div>
              <div class="check-circle" :class="{ checked: isSelected(track.id) }">
                <svg v-if="isSelected(track.id)" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" width="10" height="10">
                  <path fill-rule="evenodd" d="M12.416 3.376a.75.75 0 0 1 .208 1.04l-5 7.5a.75.75 0 0 1-1.154.114l-3-3a.75.75 0 0 1 1.06-1.06l2.353 2.353 4.493-6.74a.75.75 0 0 1 1.04-.207Z" clip-rule="evenodd" />
                </svg>
              </div>
            </div>
          </div>
          <div v-else class="track-empty">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="32" height="32">
              <path d="M9 18V5l12-2v13" /> <circle cx="6" cy="18" r="3" /> <circle cx="18" cy="16" r="3" />
            </svg>
            <p>No tracks match your filters</p>
          </div>

          <!-- Selected summary -->
          <div v-if="selectedTracks.length" class="selected-summary" style="margin-top: 20px;">
            <div class="summary-chips">
              <span v-for="t in selectedTracks.slice(0, 3)" :key="t.id" class="summary-chip">
                {{ t.title }}
                <button class="chip-remove" @click.stop="toggleTrack(t)">✕</button>
              </span>
              <span v-if="selectedTracks.length > 3" class="summary-chip">
                +{{ selectedTracks.length - 3 }} more
              </span>
            </div>
            <span class="summary-count">{{ selectedTracks.length }} selected</span>
          </div>
        </section>
      </transition>

      <!-- ─── STEP 1: Album Info ─── -->
      <transition name="slide-fade" mode="out-in">
        <section v-if="currentStep === 1" key="step1" class="step-panel">
          <div class="step-intro">
            <div class="step-icon-wrap">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="28" height="28">
                <path fill-rule="evenodd" d="M2 5.5A3.5 3.5 0 015.5 2h13A3.5 3.5 0 0122 5.5v13a3.5 3.5 0 01-3.5 3.5h-13A3.5 3.5 0 012 18.5v-13zm14.5-1a.5.5 0 00-.5.5v8a.5.5 0 001 0V5a.5.5 0 00-.5-.5z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="step-title">Album information</h2>
              <p class="step-sub">Add details about your album</p>
            </div>
          </div>

          <div class="info-layout">
            <!-- Left: Cover -->
            <div class="cover-col">
              <div class="cover-uploader" @click="coverInput?.click()">
                <img :src="coverPreview || defaultCover" :alt="form.name || 'Album cover'" class="cover-img" />
                <div class="cover-overlay">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
                    <path d="M5.5 13a3.5 3.5 0 01-.369-6.98 4 4 0 117.753-1.3A4.5 4.5 0 1113.5 13H11V9.413l1.293 1.293a1 1 0 001.414-1.414l-3-3a1 1 0 00-1.414 0l-3 3a1 1 0 001.414 1.414L9 9.414V13H5.5z" />
                  </svg>
                  <span>Click to upload cover</span>
                </div>
              </div>
              <input ref="coverInput" type="file" accept="image/*" @change="handleCoverChange" style="display: none" />
              <p class="cover-hint">JPG, PNG or GIF<br />Max 5MB</p>

              <div class="artist-display" v-if="selectedArtistName">
                <span class="artist-label">Artist</span>
                <span class="artist-name">{{ selectedArtistName }}</span>
              </div>
            </div>

            <!-- Right: Fields -->
            <div class="fields-col">
              <div class="field">
                <label class="field-label required">Album name</label>
                <input v-model="form.name" type="text" class="field-control" placeholder="e.g. Midnight Dreams" />
              </div>

              <div class="field-row two-col">
                <div class="field">
                  <label class="field-label required">Artist</label>
                  <select v-model="form.artist_id" class="field-control">
                    <option value="">Select an artist</option>
                    <option v-for="a in artists" :key="a.id" :value="a.id">
                      {{ a.name || `Artist #${a.id}` }}
                    </option>
                  </select>
                </div>
                <div class="field">
                  <label class="field-label">Type</label>
                  <select v-model="form.album_type" class="field-control">
                    <option value="album">Album</option>
                    <option value="ep">EP</option>
                    <option value="single">Single</option>
                    <option value="compilation">Compilation</option>
                  </select>
                </div>
              </div>

              <div class="field">
                <label class="field-label">Slug</label>
                <div class="slug-row">
                  <input v-model="form.slug" type="text" class="field-control" placeholder="Auto-generated from name" />
                  <button class="slug-btn" type="button" @click="generateSlug" title="Generate slug">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                      <path fill-rule="evenodd" d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 1111.601 2.566 1 1 0 11-1.885.666A5.002 5.002 0 105.199 5.1H7a1 1 0 000-2H4a1 1 0 00-1 1z" clip-rule="evenodd" />
                    </svg>
                  </button>
                </div>
              </div>

              <div class="field-row two-col">
                <div class="field">
                  <label class="field-label">Release date</label>
                  <input v-model="form.release_date" type="date" class="field-control" />
                </div>
                <div class="field">
                  <label class="field-label">Record label</label>
                  <input v-model="form.label" type="text" class="field-control" placeholder="e.g. Sony Music" />
                </div>
              </div>

              <div class="field">
                <label class="field-label">Description</label>
                <textarea v-model="form.description" class="field-control" rows="4" placeholder="Tell us about this album..."></textarea>
              </div>

              <div class="field">
                <label class="field-label">SEO Title</label>
                <input v-model="form.seo_title" type="text" class="field-control" placeholder="Optimized title for search" />
              </div>

              <div class="field">
                <label class="field-label">SEO Description</label>
                <textarea v-model="form.seo_description" class="field-control" rows="3" placeholder="Meta description..."></textarea>
              </div>
            </div>
          </div>
        </section>
      </transition>

      <!-- ─── STEP 2: Publish ─── -->
      <transition name="slide-fade" mode="out-in">
        <section v-if="currentStep === 2" key="step2" class="step-panel">
          <div class="step-intro">
            <div class="step-icon-wrap">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="28" height="28">
                <path fill-rule="evenodd" d="M5 2a2 2 0 012-2h6a2 2 0 012 2v16a2 2 0 01-2 2H7a2 2 0 01-2-2V2zm10 0a2 2 0 012-2h6a2 2 0 012 2v16a2 2 0 01-2 2h-6a2 2 0 01-2-2V2z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="step-title">Publish & visibility</h2>
              <p class="step-sub">Configure how your album appears</p>
            </div>
          </div>

          <div class="vis-layout">
            <!-- Status section -->
            <div class="vis-section">
              <h3 class="vis-section-title">Status</h3>
              <select v-model="form.status" class="field-control">
                <option value="draft">Draft (Private)</option>
                <option value="published">Published</option>
                <option value="archived">Archived</option>
              </select>
            </div>

            <!-- Features section -->
            <div class="vis-section">
              <h3 class="vis-section-title">Features</h3>
              <div class="toggle-row">
                <label class="toggle-card" :class="{ on: form.is_featured }">
                  <div class="toggle-thumb" :class="{ on: form.is_featured }"></div>
                  <div class="toggle-body">
                    <span class="toggle-name">Featured album</span>
                    <span class="toggle-desc">Show in featured section</span>
                  </div>
                  <span class="toggle-badge" :class="{ on: form.is_featured }">
                    {{ form.is_featured ? 'ON' : 'OFF' }}
                  </span>
                  <input v-model="form.is_featured" type="checkbox" style="display: none" />
                </label>
                <label class="toggle-card" :class="{ on: form.is_premium }">
                  <div class="toggle-thumb" :class="{ on: form.is_premium }"></div>
                  <div class="toggle-body">
                    <span class="toggle-name">Premium only</span>
                    <span class="toggle-desc">Require subscription to play</span>
                  </div>
                  <span class="toggle-badge" :class="{ on: form.is_premium }">
                    {{ form.is_premium ? 'ON' : 'OFF' }}
                  </span>
                  <input v-model="form.is_premium" type="checkbox" style="display: none" />
                </label>
              </div>
            </div>

            <!-- Summary section -->
            <div class="vis-section">
              <h3 class="vis-section-title">Summary</h3>
              <div class="summary-card">
                <div class="summary-cover">
                  <img :src="coverPreview || defaultCover" :alt="form.name || 'Album cover'" />
                </div>
                <div class="summary-info">
                  <div class="summary-name">{{ form.name || 'Album name' }}</div>
                  <div class="summary-artist">{{ selectedArtistName || 'Select an artist' }}</div>
                  <div class="summary-tags">
                    <span class="stag">{{ form.album_type }}</span>
                    <span class="stag">{{ selectedTracks.length }} tracks</span>
                    <span v-if="form.is_featured" class="stag">featured</span>
                    <span v-if="form.is_premium" class="stag">premium</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>
      </transition>
    </main>

    <!-- Footer -->
    <footer class="wizard-footer">
      <div class="footer-dots">
        <span v-for="i in steps.length" :key="i" class="dot" :class="{ active: currentStep === i - 1 }"></span>
      </div>
      <div class="btn-group" style="display: flex; gap: 12px;">
        <button class="wf-btn ghost" @click="prevStep" :disabled="currentStep === 0">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
            <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
          </svg>
          Back
        </button>
        <button class="wf-btn primary" @click="currentStep === steps.length - 1 ? submitForm() : nextStep()" :disabled="loading">
          <span v-if="loading" class="btn-spinner"></span>
          {{ currentStep === steps.length - 1 ? 'Create Album' : 'Next' }}
        </button>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, computed, watch, onMounted } from 'vue'
import { storeToRefs } from 'pinia'
import { useRouter } from 'vue-router'
import type { CreateAlbumPayload } from '@/modules/client/interfaces/albums/create-album.payload'
import { useAlbumStore } from '@/modules/client/stores/albums/albumssStore'
import { useNotificationStore } from '@/store/notificationStore'
import type { Song, SongFilterParams } from '@/interfaces/songs.interface'
import { useArtistStore } from '@/modules/client/stores/artists/artistsStore'
import { usePartnerStore } from '@/modules/client/stores/partners/partnersStore';
import { useSongStore } from '@/modules/client/stores/songs/songsStore'

const router = useRouter()
const notificationStore = useNotificationStore()
const albumStore = useAlbumStore()
const artistStore = useArtistStore()
const songStore = useSongStore()
const partnerStore = usePartnerStore()
const { artists } = storeToRefs(artistStore)
const loading = ref(false)
const partnerReady = ref(false);

// ── Steps ──────────────────────────────────────────────
const steps = [
  { label: 'Tracks' },
  { label: 'Info' },
  { label: 'Publish' },
]
const currentStep = ref(0)

const progressWidth = computed(() => {
  return `${((currentStep.value) / (steps.length - 1)) * 100}%`
})

const nextStep = () => {
  if (currentStep.value < steps.length - 1) currentStep.value++
}
const prevStep = () => {
  if (currentStep.value > 0) currentStep.value--
}

// ── Track selection ─────────────────────────────────────
interface Track { id: number; title: string; artist: string; artistId: number; duration: string; cover?: string }

// Get songs from store
const { songs } = storeToRefs(songStore)

const trackSearch = ref('')
const filterArtistId = ref<number | ''>('')
const selectedTracks = ref<Track[]>([])

const formatDuration = (seconds?: number) => {
  if (!seconds) return '0:00';
  const m = Math.floor(seconds / 60);
  const s = Math.floor(seconds % 60);
  return `${m}:${s.toString().padStart(2, '0')}`;
};

const activeArtistName = computed(() => {
  if (!filterArtistId.value) return ''
  return artists.value.find((a: any) => a.id === filterArtistId.value)?.name || ''
})

const filteredTracks = computed(() =>
  songs.value.map((s: any) => ({
    id: s.id,
    title: s.title,
    artist: s.artist?.name || 'Unknown Artist',
    artistId: s.artist?.id || 0,
    duration: formatDuration(s.duration),
    cover: s.cover_url || undefined
  })).filter((t: Track) => {
    const matchSearch = t.title.toLowerCase().includes(trackSearch.value.toLowerCase()) ||
      t.artist.toLowerCase().includes(trackSearch.value.toLowerCase())
    const matchArtist = filterArtistId.value === '' || t.artistId === filterArtistId.value
    return matchSearch && matchArtist
  })
)

const isSelected = (id: number) => selectedTracks.value.some(t => t.id === id)

const toggleTrack = (track: Track) => {
  const idx = selectedTracks.value.findIndex(t => t.id === track.id)
  if (idx >= 0) selectedTracks.value.splice(idx, 1)
  else selectedTracks.value.push(track)
}

// ── Cover ───────────────────────────────────────────────
const coverPreview = ref<string>('')
const coverInput = ref<HTMLInputElement | null>(null)
const defaultCover = 'https://via.placeholder.com/400x400?text=Cover'

const handleCoverChange = (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  if (!file) return
  if (!file.type.startsWith('image/')) { notificationStore.notify('Please select an image file!', 'error'); return }
  if (file.size > 5 * 1024 * 1024) { notificationStore.notify('File too large! Max 5MB', 'error'); return }
  form.cover_url = file
  const reader = new FileReader()
  reader.onload = e => { coverPreview.value = e.target?.result as string }
  reader.readAsDataURL(file)
}

// ── Form ────────────────────────────────────────────────
const form = reactive<CreateAlbumPayload>({
  name: '',
  slug: '',
  artist_id: null,
  cover_url: null,
  description: '',
  release_date: '',
  album_type: 'album',
  label: '',
  is_featured: false,
  is_premium: false,
  partner_id: null,
  status: 'draft',
  seo_title: '',
  seo_description: '',
  track_ids: [],
})

const selectedArtistName = computed(() => {
  if (!form.artist_id) return ''
  return artists.value.find((a: any) => a.id === form.artist_id)?.name || ''
})

const generateSlug = () => {
  if (!form.name) return
  form.slug = form.name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')
}

const buildParams = () => ({
  partner_id:partnerStore.partner?.id,
} as const)


const loadPartner = async () => {
  try {
    await partnerStore.fetchPartnerInfo();
    partnerReady.value = true;
    console.log('Partner loaded:', partnerStore.partner);
  } catch (error) {
    console.error('Failed to load partner:', error);
    notificationStore.notify('Failed to load partner info', 'error');
  }
};

const loadArtists = async () => {
  const partner_id = partnerStore.partner?.id;
  
  if (!partner_id) {
    console.warn('Cannot load artists: partner_id is null');
    return;
  }
  
  console.log('Loading artists for partner_id:', partner_id);
  await artistStore.fetchAllArtists(partner_id);
};


const loadSongs = async () => {
  const partner_id = partnerStore.partner?.id;
  
  if (!partner_id) {
    console.warn('Cannot load songs: partner_id is null');
    return;
  }
  
  const params = { partner_id } as SongFilterParams;
  console.log('Loading songs with params:', params);
  await songStore.fetchSongs(params);
};


watch(() => form.name, generateSlug)

onMounted(async () => {
  await loadPartner();
    if (partnerStore.partner?.id) {
    await Promise.all([loadArtists(), loadSongs()]);
  } else {
    notificationStore.notify('Partner information not available', 'error');
  }
});


watch(filterArtistId, (val) => {
  form.artist_id = val === '' ? null : val
})

const submitForm = async () => {
  try {
    loading.value = true

    // Populate track_ids from selectedTracks
    form.track_ids = selectedTracks.value.map(t => t.id)
    form.partner_id = partnerStore.partner?.id || null;
    // Validate required fields
    if (!form.name) {
      notificationStore.notify('Album name is required', 'error')
      return
    }
    if (!form.artist_id) {
      notificationStore.notify('Artist is required', 'error')
      return
    }
    if (selectedTracks.value.length === 0) {
      notificationStore.notify('Please select at least one track', 'error')
      return
    }

    await albumStore.fetchAddAlbum(form)
    notificationStore.notify('Album created successfully!', 'success')
    router.push({ name: 'client.albums' })
  } catch (err: any) {
    notificationStore.notify(err.response?.data?.message || 'Failed to create album', 'error')
  } finally {
    loading.value = false
    setTimeout(() => notificationStore.clear(), 3000)
  }
}
</script>

<style scoped>
/* ── Base ───────────────────────────────────────── */
.wizard-shell {
  min-height: 100vh;
  background: #080e14;
  display: flex;
  flex-direction: column;
  font-family: 'DM Sans', 'Segoe UI', sans-serif;
  color: #e8edf2;
  position: relative;
  overflow: hidden;
}

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

.step-pills {
  display: flex;
  align-items: center;
  gap: 6px;
}

.step-pill {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 7px 14px;
  border-radius: 100px;
  border: 1px solid rgba(255,255,255,0.1);
  background: transparent;
  color: rgba(255,255,255,0.4);
  font-size: 13px;
  font-weight: 500;
  cursor: default;
  transition: all 0.2s;
}
.step-pill.active {
  background: rgba(0, 160, 255, 0.15);
  border-color: rgba(0, 160, 255, 0.5);
  color: #00aaff;
}
.step-pill.done {
  background: rgba(0, 200, 120, 0.1);
  border-color: rgba(0, 200, 120, 0.4);
  color: #00c87a;
  cursor: pointer;
}

.pill-num {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: rgba(255,255,255,0.08);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 11px;
  font-weight: 700;
}
.step-pill.active .pill-num { background: #00aaff; color: #000; }
.step-pill.done .pill-num { background: #00c87a; color: #000; }

/* ── Progress bar ───────────────────────────────── */
.progress-bar {
  position: relative;
  z-index: 10;
  height: 2px;
  background: rgba(255,255,255,0.06);
}
.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #00aaff, #00c87a);
  transition: width 0.4s cubic-bezier(0.4,0,0.2,1);
}

/* ── Body ───────────────────────────────────────── */
.wizard-body {
  flex: 1;
  overflow-y: auto;
  padding: 32px 28px;
  position: relative;
  z-index: 1;
  max-width: 960px;
  width: 100%;
  margin: 0 auto;
}

/* ── Step panel ─────────────────────────────────── */
.step-panel { animation: fadeUp 0.3s ease; }

@keyframes fadeUp {
  from { opacity: 0; transform: translateY(12px); }
  to   { opacity: 1; transform: translateY(0); }
}

.step-intro {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  margin-bottom: 28px;
}

.step-icon-wrap {
  width: 52px;
  height: 52px;
  border-radius: 14px;
  background: rgba(0, 160, 255, 0.1);
  border: 1px solid rgba(0, 160, 255, 0.25);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #00aaff;
  flex-shrink: 0;
}

.step-title {
  font-size: 22px;
  font-weight: 700;
  color: #fff;
  margin: 0 0 4px;
  line-height: 1.2;
}

.step-sub {
  font-size: 14px;
  color: rgba(255,255,255,0.45);
  margin: 0;
}

/* ── Filter bar ─────────────────────────────────── */
.filter-bar {
  display: flex;
  gap: 10px;
  margin-bottom: 10px;
  align-items: stretch;
}

.filter-bar .track-search-bar {
  flex: 1;
  margin-bottom: 0;
}

.artist-filter-wrap {
  position: relative;
  display: flex;
  align-items: center;
  background: rgba(255,255,255,0.04);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 10px;
  padding: 0 12px;
  gap: 8px;
  min-width: 180px;
  transition: border-color 0.2s;
}
.artist-filter-wrap:focus-within { border-color: rgba(0,170,255,0.5); }

.filter-icon { color: rgba(255,255,255,0.35); flex-shrink: 0; }
.select-chevron { color: rgba(255,255,255,0.25); flex-shrink: 0; pointer-events: none; }

.artist-filter-select {
  flex: 1;
  background: transparent;
  border: none;
  color: #fff;
  font-size: 13px;
  font-family: inherit;
  cursor: pointer;
  padding: 10px 0;
  appearance: none;
  -webkit-appearance: none;
  outline: none;
}
.artist-filter-select option { background: #1a2530; color: #fff; }

/* ── Artist pills ───────────────────────────────── */
.artist-pills {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
  margin-bottom: 12px;
}

.artist-pill {
  padding: 5px 14px;
  border-radius: 100px;
  border: 1px solid rgba(255,255,255,0.1);
  background: rgba(255,255,255,0.04);
  color: rgba(255,255,255,0.5);
  font-size: 12px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.15s;
  font-family: inherit;
  white-space: nowrap;
}
.artist-pill:hover { background: rgba(255,255,255,0.08); color: #fff; border-color: rgba(255,255,255,0.2); }
.artist-pill.active {
  background: rgba(0,160,255,0.15);
  border-color: rgba(0,160,255,0.5);
  color: #00aaff;
}

/* ── Active filter bar ──────────────────────────── */
.active-filter-bar {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background: rgba(0,160,255,0.07);
  border: 1px solid rgba(0,160,255,0.2);
  border-radius: 8px;
  margin-bottom: 10px;
  font-size: 13px;
  color: rgba(255,255,255,0.6);
}
.active-filter-bar svg { color: #00aaff; flex-shrink: 0; }
.active-filter-bar strong { color: #00aaff; font-weight: 600; }
.clear-filter {
  margin-left: auto;
  background: none;
  border: none;
  color: rgba(255,255,255,0.4);
  font-size: 12px;
  cursor: pointer;
  padding: 2px 8px;
  border-radius: 4px;
  transition: all 0.15s;
  font-family: inherit;
}
.clear-filter:hover { background: rgba(255,255,255,0.08); color: #fff; }

/* ── Track search bar ───────────────────────────── */
.track-search-bar {
  position: relative;
  margin-bottom: 12px;
}
.search-icon {
  position: absolute;
  left: 14px;
  top: 50%;
  transform: translateY(-50%);
  color: rgba(255,255,255,0.3);
  pointer-events: none;
}
.track-search-input {
  width: 100%;
  background: rgba(255,255,255,0.04);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 10px;
  padding: 11px 40px;
  color: #fff;
  font-size: 14px;
  transition: border-color 0.2s;
  box-sizing: border-box;
}
.track-search-input:focus { outline: none; border-color: rgba(0,170,255,0.5); }
.track-search-input::placeholder { color: rgba(255,255,255,0.25); }
.search-clear {
  position: absolute;
  right: 14px;
  top: 50%;
  transform: translateY(-50%);
  color: rgba(255,255,255,0.3);
  cursor: pointer;
  font-size: 12px;
}
.search-clear:hover { color: #fff; }

/* ── Track list ─────────────────────────────────── */
.track-list {
  background: rgba(255,255,255,0.02);
  border: 1px solid rgba(255,255,255,0.07);
  border-radius: 14px;
  overflow: hidden;
  margin-bottom: 16px;
}

.track-row {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 10px 16px;
  cursor: pointer;
  transition: background 0.15s;
  border-bottom: 1px solid rgba(255,255,255,0.04);
}
.track-row:last-child { border-bottom: none; }
.track-row:hover { background: rgba(255,255,255,0.04); }
.track-row.selected { background: rgba(0, 160, 255, 0.07); }

.track-num {
  font-size: 12px;
  color: rgba(255,255,255,0.25);
  font-variant-numeric: tabular-nums;
  width: 24px;
  text-align: right;
  flex-shrink: 0;
}

.track-cover {
  position: relative;
  width: 38px;
  height: 38px;
  border-radius: 6px;
  overflow: hidden;
  flex-shrink: 0;
}
.track-cover img { width: 100%; height: 100%; object-fit: cover; }
.track-play-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.55);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.15s;
  color: #fff;
}
.track-row:hover .track-play-overlay { opacity: 1; }

.track-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
}
.track-title {
  font-size: 14px;
  font-weight: 500;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.track-artist { font-size: 12px; color: rgba(255,255,255,0.4); }

.track-meta { flex-shrink: 0; }
.track-duration { font-size: 13px; color: rgba(255,255,255,0.35); font-variant-numeric: tabular-nums; }

.check-circle {
  width: 22px;
  height: 22px;
  border-radius: 50%;
  border: 1.5px solid rgba(255,255,255,0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.15s;
}
.check-circle.checked {
  background: #00aaff;
  border-color: #00aaff;
  color: #000;
}

.track-empty {
  padding: 40px;
  text-align: center;
  color: rgba(255,255,255,0.3);
  font-size: 14px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

/* ── Selected summary chips ─────────────────────── */
.selected-summary {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
}
.summary-chips { display: flex; flex-wrap: wrap; gap: 6px; flex: 1; }
.summary-chip {
  display: flex;
  align-items: center;
  gap: 5px;
  background: rgba(0,160,255,0.15);
  border: 1px solid rgba(0,160,255,0.3);
  color: #00aaff;
  font-size: 12px;
  padding: 4px 10px;
  border-radius: 100px;
}
.chip-remove {
  background: none;
  border: none;
  color: inherit;
  cursor: pointer;
  font-size: 11px;
  padding: 0;
  line-height: 1;
  opacity: 0.7;
}
.chip-remove:hover { opacity: 1; }
.summary-count { font-size: 13px; color: rgba(255,255,255,0.5); flex-shrink: 0; }

/* ── Step 1 layout ──────────────────────────────── */
.info-layout {
  display: grid;
  grid-template-columns: 220px 1fr;
  gap: 28px;
  align-items: start;
}

.cover-col { display: flex; flex-direction: column; align-items: center; gap: 10px; }

.cover-uploader {
  width: 200px;
  height: 200px;
  border-radius: 16px;
  overflow: hidden;
  border: 2px dashed rgba(255,255,255,0.15);
  position: relative;
  cursor: pointer;
  transition: border-color 0.2s;
}
.cover-uploader:hover { border-color: #00aaff; }
.cover-img { width: 100%; height: 100%; object-fit: cover; display: block; }

.cover-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.65);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 6px;
  color: #fff;
  opacity: 0;
  transition: opacity 0.2s;
  font-size: 13px;
}
.cover-uploader:hover .cover-overlay { opacity: 1; }
.cover-hint { font-size: 11px; color: rgba(255,255,255,0.3); text-align: center; line-height: 1.5; }

.artist-display {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding-top: 8px;
  width: 100%;
  text-align: center;
}

.artist-label {
  font-size: 11px;
  font-weight: 500;
  color: rgba(255,255,255,0.35);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.artist-name {
  font-size: 14px;
  font-weight: 600;
  color: #00aaff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 100%;
}

/* ── Fields ─────────────────────────────────────── */
.fields-col { display: flex; flex-direction: column; gap: 16px; }

.field { display: flex; flex-direction: column; gap: 6px; }

.field-row.two-col {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.field-label {
  font-size: 13px;
  font-weight: 500;
  color: rgba(255,255,255,0.6);
}
.field-label.required::after { content: ' *'; color: #ff5555; }

.field-control {
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 9px;
  padding: 10px 13px;
  color: #fff;
  font-size: 14px;
  transition: border-color 0.2s;
  width: 100%;
  box-sizing: border-box;
  font-family: inherit;
}
.field-control:focus { outline: none; border-color: rgba(0,170,255,0.6); background: rgba(255,255,255,0.07); }
.field-control::placeholder { color: rgba(255,255,255,0.2); }
.field-control option { background: #1a2530; color: #fff; }
textarea.field-control { resize: vertical; }

.field-hint { font-size: 11px; color: rgba(255,255,255,0.3); }

.slug-row { display: flex; gap: 8px; }
.slug-row .field-control { flex: 1; }
.slug-btn {
  width: 40px;
  height: 40px;
  border-radius: 9px;
  border: 1px solid rgba(255,255,255,0.1);
  background: rgba(255,255,255,0.05);
  color: rgba(255,255,255,0.5);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: all 0.15s;
}
.slug-btn:hover { background: #00aaff; border-color: #00aaff; color: #000; }

/* ── Step 2: Visibility ─────────────────────────── */
.vis-layout { display: flex; flex-direction: column; gap: 24px; }

.vis-section {
  background: rgba(255,255,255,0.02);
  border: 1px solid rgba(255,255,255,0.07);
  border-radius: 14px;
  padding: 22px;
}

.vis-section-title {
  font-size: 13px;
  font-weight: 600;
  color: rgba(255,255,255,0.4);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  margin: 0 0 18px;
}

.toggle-row { display: flex; flex-direction: column; gap: 10px; margin-top: 16px; }

.toggle-card {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 14px 16px;
  border-radius: 10px;
  border: 1px solid rgba(255,255,255,0.07);
  background: rgba(255,255,255,0.03);
  cursor: pointer;
  transition: all 0.2s;
  user-select: none;
}
.toggle-card:hover { background: rgba(255,255,255,0.06); }
.toggle-card.on { border-color: rgba(0,170,255,0.3); background: rgba(0,160,255,0.07); }

.toggle-thumb {
  width: 36px;
  height: 20px;
  border-radius: 100px;
  background: rgba(255,255,255,0.1);
  position: relative;
  flex-shrink: 0;
  transition: background 0.2s;
}
.toggle-thumb::after {
  content: '';
  position: absolute;
  width: 14px;
  height: 14px;
  border-radius: 50%;
  background: rgba(255,255,255,0.5);
  top: 3px;
  left: 3px;
  transition: all 0.2s;
}
.toggle-thumb.on { background: #00aaff; }
.toggle-thumb.on::after { left: 19px; background: #fff; }

.toggle-body { flex: 1; }
.toggle-name { display: block; font-size: 14px; font-weight: 500; color: #fff; }
.toggle-desc { font-size: 12px; color: rgba(255,255,255,0.35); }

.toggle-badge {
  font-size: 11px;
  font-weight: 700;
  padding: 3px 9px;
  border-radius: 100px;
  background: rgba(255,255,255,0.07);
  color: rgba(255,255,255,0.3);
  letter-spacing: 0.05em;
  transition: all 0.2s;
}
.toggle-badge.on { background: rgba(0,170,255,0.15); color: #00aaff; }

/* ── Summary card ───────────────────────────────── */
.summary-card {
  display: flex;
  align-items: center;
  gap: 18px;
  padding: 18px 20px;
  background: rgba(255,255,255,0.03);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 14px;
}
.summary-cover {
  width: 60px;
  height: 60px;
  border-radius: 10px;
  overflow: hidden;
  flex-shrink: 0;
}
.summary-cover img { width: 100%; height: 100%; object-fit: cover; }
.summary-info { display: flex; flex-direction: column; gap: 4px; flex: 1; }
.summary-name { font-size: 16px; font-weight: 600; color: #fff; }
.summary-artist { font-size: 13px; color: rgba(255,255,255,0.45); }
.summary-tags { display: flex; gap: 6px; flex-wrap: wrap; margin-top: 4px; }
.stag {
  font-size: 11px;
  padding: 2px 9px;
  border-radius: 100px;
  background: rgba(255,255,255,0.07);
  color: rgba(255,255,255,0.5);
  text-transform: capitalize;
}

/* ── Slide transition ───────────────────────────── */
.slide-fade-enter-active,
.slide-fade-leave-active { transition: all 0.25s ease; }
.slide-fade-enter-from { opacity: 0; transform: translateX(20px); }
.slide-fade-leave-to  { opacity: 0; transform: translateX(-20px); }

/* ── Footer ─────────────────────────────────────── */
.wizard-footer {
  position: relative;
  z-index: 10;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 28px;
  border-top: 1px solid rgba(255,255,255,0.06);
  background: rgba(8,14,20,0.85);
  backdrop-filter: blur(12px);
}

.footer-dots { display: flex; gap: 6px; align-items: center; }
.dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: rgba(255,255,255,0.2);
  transition: all 0.2s;
}
.dot.active { background: #00aaff; width: 18px; border-radius: 3px; }

.wf-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 22px;
  border-radius: 10px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  border: none;
  transition: all 0.2s;
  font-family: inherit;
}
.wf-btn:disabled { opacity: 0.4; cursor: not-allowed; }

.wf-btn.ghost {
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.6);
}
.wf-btn.ghost:hover:not(:disabled) { background: rgba(255,255,255,0.1); color: #fff; }

.wf-btn.primary {
  background: #00aaff;
  color: #000;
}
.wf-btn.primary:hover:not(:disabled) {
  background: #33bbff;
  transform: translateY(-1px);
  box-shadow: 0 6px 20px rgba(0,170,255,0.35);
}

.btn-spinner {
  width: 15px;
  height: 15px;
  border: 2px solid rgba(0,0,0,0.3);
  border-top-color: #000;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* ── Responsive ─────────────────────────────────── */
@media (max-width: 720px) {
  .topbar { flex-wrap: wrap; gap: 12px; }
  .step-pills { order: 3; width: 100%; justify-content: center; }
  .info-layout { grid-template-columns: 1fr; }
  .cover-col { flex-direction: row; align-items: center; }
  .cover-uploader { width: 100px; height: 100px; }
  .field-row.two-col { grid-template-columns: 1fr; }
  .wizard-body { padding: 20px 16px; }
  .wizard-footer { padding: 14px 16px; }
  .pill-label { display: none; }
}
.field-control:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
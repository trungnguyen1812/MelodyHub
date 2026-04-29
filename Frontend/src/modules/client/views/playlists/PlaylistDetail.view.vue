
<template>
  <div class="playlist-detail-shell" @click="closeContextMenu">
    <!-- Background Blur -->
    <div class="bg-blur-container">
      <div
        v-if="coverUrl"
        class="banner-blur"
        :style="{ backgroundImage: `url(${coverUrl})` }"
      ></div>
      <div v-else class="banner-blur-placeholder"></div>
    </div>

    <div class="content-container">
      <!-- Nav -->
      <div class="header-nav">
        <button class="back-nav-btn" @click="$router.back()">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="18" height="18">
            <path fill-rule="evenodd" d="M17 10a.75.75 0 0 1-.75.75H5.612l4.158 3.96a.75.75 0 1 1-1.04 1.08l-5.5-5.25a.75.75 0 0 1 0-1.08l5.5-5.25a.75.75 0 1 1 1.04 1.08L5.612 9.25H16.25A.75.75 0 0 1 17 10Z" clip-rule="evenodd" />
          </svg>
          Back
        </button>
      </div>

      <!-- Loading -->
      <div v-if="isLoading" class="loading-hero">
        <div class="skeleton-hero"></div>
        <div class="loading-tracks">
          <div v-for="i in 8" :key="i" class="skeleton-track"></div>
        </div>
      </div>

      <template v-else-if="playlist">
        <!-- Hero -->
        <div class="hero">
          <div class="hero-cover" @click="isOwner ? openEditModal() : null" :style="isOwner ? 'cursor:pointer' : 'cursor:default'">
            <img :src="coverUrl" :alt="playlist.name" @error="handleImageError" />
            <div v-if="isOwner" class="hero-cover-overlay">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="24" height="24">
                <path d="M21.731 2.269a2.625 2.625 0 0 0-3.712 0l-1.157 1.157 3.712 3.712 1.157-1.157a2.625 2.625 0 0 0 0-3.712ZM19.513 8.199l-3.712-3.712-8.4 8.4a5.25 5.25 0 0 0-1.32 2.214l-.8 2.685a.75.75 0 0 0 .933.933l2.685-.8a5.25 5.25 0 0 0 2.214-1.32l8.4-8.4Z" />
              </svg>
              <span>Edit cover</span>
            </div>
          </div>

          <div class="hero-info">
            <div class="type-pill">{{ playlist.is_public ? 'Public Playlist' : 'Private Playlist' }}</div>
            <h1 class="hero-title">{{ playlist.name }}</h1>
            <p class="hero-desc" v-if="playlist.description">{{ playlist.description }}</p>
            <div class="hero-meta">
              <span>{{ playlist.total_songs }} songs</span>
              <span class="dot">•</span>
              <span>{{ formatDuration(playlist.total_duration) }}</span>
              <span class="dot">•</span>
              <span>Updated {{ formatDate(playlist.updated_at) }}</span>
            </div>

            <!-- Owner info (hiện với non-owner) -->
            <div class="hero-owner" v-if="playlist.user && !isOwner">
              <img
                :src="playlist.user.avatar_url || '/default-avatar.jpg'"
                :alt="playlist.user.name"
                class="owner-avatar"
                @error="handleAvatarError"
              />
              <span class="owner-label">by</span>
              <span class="owner-name">{{ playlist.user.name }}</span>
            </div>
            <div class="hero-actions">
              <button class="play-all-btn" @click="playAll" :disabled="!songs.length">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                  <path fill-rule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clip-rule="evenodd" />
                </svg>
                Play All
              </button>

              <button class="shuffle-btn" @click="playShuffle" :disabled="!songs.length" title="Shuffle play">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18">
                  <polyline points="16 3 21 3 21 8"></polyline>
                  <line x1="4" y1="20" x2="21" y2="3"></line>
                  <polyline points="21 16 21 21 16 21"></polyline>
                  <line x1="15" y1="15" x2="21" y2="21"></line>
                </svg>
              </button>

              <button class="icon-action-btn" v-if="isOwner" @click="openEditModal" title="Edit playlist">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18">
                  <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                  <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                </svg>
              </button>

              <button class="icon-action-btn danger" v-if="isOwner" @click="confirmDelete = true" title="Delete playlist">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="18" height="18">
                  <polyline points="3 6 5 6 21 6"></polyline>
                  <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"></path>
                  <path d="M10 11v6"></path><path d="M14 11v6"></path>
                  <path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"></path>
                </svg>
              </button>
            </div>
          </div>
        </div>

        <!-- Track List -->
        <div class="tracks-section">
          <!-- Search bar -->
          <div class="tracks-toolbar">
            <div class="search-box">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15" class="search-icon">
                <path fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11ZM2 9a7 7 0 1 1 12.452 4.391l3.328 3.329a.75.75 0 1 1-1.06 1.06l-3.329-3.328A7 7 0 0 1 2 9Z" clip-rule="evenodd" />
              </svg>
              <input
                v-model="searchQuery"
                type="text"
                placeholder="Search in playlist..."
                class="search-input"
              />
              <button v-if="searchQuery" class="search-clear" @click="searchQuery = ''">✕</button>
            </div>
            <span class="tracks-count">{{ filteredSongs.length }} tracks</span>
          </div>

          <div v-if="filteredSongs.length" class="tracks-list">
            <div class="tracks-header">
              <span class="th-rank">#</span>
              <span class="th-info">Title / Artist</span>
              <span class="th-album hide-mobile">Album</span>
              <span class="th-added hide-mobile">Added</span>
              <span class="th-duration">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm.75-13a.75.75 0 0 0-1.5 0v5c0 .414.336.75.75.75h4a.75.75 0 0 0 0-1.5h-3.25V5Z" clip-rule="evenodd" />
                </svg>
              </span>
              <span class="th-actions"></span>
            </div>

            <div
              v-for="(song, index) in filteredSongs"
              :key="song.id"
              class="track-row"
              :class="{ 'is-active': player.currentSong?.id === song.id }"
              @click="playSong(song)"
              @contextmenu.prevent="openContextMenu($event, song)"
            >
              <div class="t-rank">
                <span class="rank-num" v-if="!(player.currentSong?.id === song.id && player.isPlaying)">
                  {{ index + 1 }}
                </span>
                <div class="rank-wave" v-else>
                  <span></span><span></span><span></span>
                </div>
              </div>

              <div class="t-info">
                <div class="t-cover">
                  <img :src="getSongCover(song)" :alt="song.title" @error="handleImageError" />
                  <div class="t-cover-overlay">
                    <svg v-if="!(player.currentSong?.id === song.id && player.isPlaying)"
                      xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
                      <path fill-rule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clip-rule="evenodd" />
                    </svg>
                    <svg v-else xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
                      <path fill-rule="evenodd" d="M6.75 5.25a.75.75 0 0 1 .75-.75H9a.75.75 0 0 1 .75.75v13.5a.75.75 0 0 1-.75.75H7.5a.75.75 0 0 1-.75-.75V5.25Zm7.5 0A.75.75 0 0 1 15 4.5h1.5a.75.75 0 0 1 .75.75v13.5a.75.75 0 0 1-.75.75H15a.75.75 0 0 1-.75-.75V5.25Z" clip-rule="evenodd" />
                    </svg>
                  </div>
                </div>
                <div class="t-details">
                  <div class="t-title" :class="{ active: player.currentSong?.id === song.id }">
                    {{ song.title }}
                    <span v-if="song.is_explicit" class="explicit-badge">E</span>
                  </div>
                  <div class="t-artist">{{ song.artist?.name || '—' }}</div>
                </div>
              </div>

              <div class="t-album hide-mobile">{{ song.album?.title || 'Single' }}</div>
              <div class="t-added hide-mobile">{{ formatDate(song.added_at) }}</div>
              <div class="t-duration">{{ formatTrackDuration(song.duration) }}</div>

              <div v-if="isOwner" class="t-actions" @click.stop>
                <button class="row-menu-btn" @click.stop="openContextMenu($event, song)" title="More options">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
                    <path d="M3 10a1.5 1.5 0 1 1 3 0 1.5 1.5 0 0 1-3 0ZM8.5 10a1.5 1.5 0 1 1 3 0 1.5 1.5 0 0 1-3 0ZM15.5 8.5a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3Z" />
                  </svg>
                </button>
              </div>
            </div>
          </div>

          <!-- No search results -->
          <div v-else-if="searchQuery" class="empty-tracks">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor" width="48" height="48">
              <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
            </svg>
            <h3>No results for "{{ searchQuery }}"</h3>
            <button class="reset-btn" @click="searchQuery = ''">Clear search</button>
          </div>

          <!-- Empty playlist -->
          <div v-else class="empty-tracks">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor" width="56" height="56">
              <path stroke-linecap="round" stroke-linejoin="round" d="m9 9 10.5-3m0 6.553v3.75a2.25 2.25 0 0 1-1.632 2.163l-1.32.377a1.803 1.803 0 1 1-2.8-1.452l.328-.094a1.125 1.125 0 0 0 .764-1.235V5.11a.75.75 0 0 0-.272-.578l-7.5 5.75a.75.75 0 0 0-.228.531V16.65c0 .543-.321 1.03-.815 1.235l-1.32.378a1.803 1.803 0 1 1-2.8-1.452l.328-.094a1.125 1.125 0 0 0 .764-1.235V10.5c0-.621.504-1.125 1.125-1.125h1.5" />
            </svg>
            <h3>No songs yet</h3>
            <p>This playlist doesn't have any songs.</p>
          </div>
        </div>
      </template>

      <!-- Not Found -->
      <div v-else class="not-found">
        <h3>Playlist not found</h3>
        <button class="reset-btn" @click="$router.back()">Go Back</button>
      </div>
    </div>

    <!-- ── Context Menu ── -->
    <Teleport to="body">
      <div
        v-if="contextMenu.visible"
        class="context-menu"
        :style="{ top: contextMenu.y + 'px', left: contextMenu.x + 'px' }"
        @click.stop
      >
        <button class="ctx-item" @click="playSongFromMenu">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="15" height="15">
            <path fill-rule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clip-rule="evenodd" />
          </svg>
          Play now
        </button>
        <button class="ctx-item" @click="addToQueueFromMenu">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="15" height="15">
            <line x1="8" y1="6" x2="21" y2="6"></line>
            <line x1="8" y1="12" x2="21" y2="12"></line>
            <line x1="8" y1="18" x2="21" y2="18"></line>
            <line x1="3" y1="6" x2="3.01" y2="6"></line>
            <line x1="3" y1="12" x2="3.01" y2="12"></line>
            <line x1="3" y1="18" x2="3.01" y2="18"></line>
          </svg>
          Add to queue
        </button>
        <div class="ctx-divider"></div>
        <button v-if="isOwner" class="ctx-item danger" @click="removeSongFromMenu">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" width="15" height="15">
            <polyline points="3 6 5 6 21 6"></polyline>
            <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"></path>
            <path d="M10 11v6"></path><path d="M14 11v6"></path>
          </svg>
          Remove from playlist
        </button>
      </div>
    </Teleport>

    <!-- ── Edit Playlist Modal ── -->
    <Teleport to="body">
      <Transition name="modal-fade">
        <div v-if="showEditModal" class="modal-backdrop" @click.self="showEditModal = false">
          <div class="edit-modal">
            <div class="edit-modal-header">
              <h3>Edit Playlist</h3>
              <button class="modal-close" @click="showEditModal = false">✕</button>
            </div>

            <div class="edit-modal-body">
              <!-- Cover preview -->
              <div class="edit-cover-wrap">
                <img :src="editForm.previewUrl || coverUrl" alt="cover" @error="handleImageError" />
                <label class="edit-cover-label">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                    <path d="M12 9a3.75 3.75 0 1 0 0 7.5A3.75 3.75 0 0 0 12 9Z" />
                    <path fill-rule="evenodd" d="M9.344 3.071a49.52 49.52 0 0 1 5.312 0c.967.052 1.83.585 2.332 1.39l.821 1.317c.24.383.645.643 1.11.71.386.054.77.113 1.152.177 1.432.239 2.429 1.493 2.429 2.909V18a3 3 0 0 1-3 3h-15a3 3 0 0 1-3-3V9.574c0-1.416.997-2.67 2.429-2.909.382-.064.766-.123 1.151-.178a1.56 1.56 0 0 0 1.11-.71l.822-1.315a2.942 2.942 0 0 1 2.332-1.39ZM6.75 12.75a5.25 5.25 0 1 1 10.5 0 5.25 5.25 0 0 1-10.5 0Zm12-1.5a.75.75 0 1 0 0-1.5.75.75 0 0 0 0 1.5Z" clip-rule="evenodd" />
                  </svg>
                  Change photo
                  <input type="file" accept="image/*" class="hidden-file" @change="onCoverChange" />
                </label>
              </div>

              <div class="edit-fields">
                <div class="field-group">
                  <label>Name</label>
                  <input v-model="editForm.name" type="text" placeholder="Playlist name" class="edit-input" maxlength="100" />
                </div>
                <div class="field-group">
                  <label>Description</label>
                  <textarea v-model="editForm.description" placeholder="Add an optional description..." class="edit-textarea" rows="3" maxlength="300"></textarea>
                </div>
                <div class="field-group">
                  <label class="toggle-label">
                    <span>Public playlist</span>
                    <div class="toggle-wrap" @click="editForm.is_public = !editForm.is_public">
                      <div class="toggle" :class="{ on: editForm.is_public }">
                        <div class="toggle-knob"></div>
                      </div>
                    </div>
                  </label>
                  <p class="field-hint">{{ editForm.is_public ? 'Everyone can see this playlist' : 'Only you can see this playlist' }}</p>
                </div>
              </div>
            </div>

            <div class="edit-modal-footer">
              <button class="btn-cancel" @click="showEditModal = false">Cancel</button>
              <button class="btn-save" @click="saveEdit" :disabled="isSaving">
                <span v-if="isSaving" class="saving-spinner"></span>
                {{ isSaving ? 'Saving...' : 'Save changes' }}
              </button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>

    <!-- ── Delete Confirm Modal ── -->
    <Teleport to="body">
      <Transition name="modal-fade">
        <div v-if="confirmDelete" class="modal-backdrop" @click.self="confirmDelete = false">
          <div class="confirm-modal">
            <div class="confirm-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="40" height="40">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" />
              </svg>
            </div>
            <h3>Delete playlist?</h3>
            <p>This will permanently delete <strong>"{{ playlist?.name }}"</strong>. This action cannot be undone.</p>
            <div class="confirm-actions">
              <button class="btn-cancel" @click="confirmDelete = false">Cancel</button>
              <button class="btn-delete" @click="deletePlaylist" :disabled="isDeleting">
                {{ isDeleting ? 'Deleting...' : 'Delete' }}
              </button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>

    <!-- ── Toast ── -->
    <Teleport to="body">
      <Transition name="toast-slide">
        <div v-if="toast.visible" class="toast" :class="toast.type">
          {{ toast.message }}
        </div>
      </Transition>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount, reactive } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { usePlaylistStore } from '@/modules/client/stores/playlist/playlistStore'
import { usePlayerStore } from '@/store/playerStore'
import { useAuthStore } from '@/store/authStore'
import type { PlaylistSong } from '@/modules/client/stores/playlist/playlistStore'

const route = useRoute()
const router = useRouter()
const playlistStore = usePlaylistStore()
const player = usePlayerStore()
const authStore = useAuthStore()

// ── State ────────────────────────────────────────────────────────────────────
const isLoading   = ref(true)
const isSaving    = ref(false)
const isDeleting  = ref(false)
const confirmDelete = ref(false)
const showEditModal = ref(false)
const searchQuery   = ref('')

const editForm = reactive({
  name: '',
  description: '',
  is_public: false,
  cover: null as File | null,
  previewUrl: '',
})

const contextMenu = reactive({
  visible: false,
  x: 0,
  y: 0,
  song: null as PlaylistSong | null,
})

const toast = reactive({
  visible: false,
  message: '',
  type: 'success' as 'success' | 'error',
})

// ── Computed ─────────────────────────────────────────────────────────────────
const playlist = computed(() => playlistStore.current)
const songs    = computed(() => playlistStore.currentSongs)

const filteredSongs = computed(() => {
  const q = searchQuery.value.trim().toLowerCase()
  if (!q) return songs.value
  return songs.value.filter(s =>
    s.title.toLowerCase().includes(q) ||
    (s.artist?.name ?? '').toLowerCase().includes(q) ||
    (s.album?.title ?? '').toLowerCase().includes(q)
  )
})

const coverUrl = computed(() => {
  const url = playlist.value?.cover_url
  if (!url) return '/playlist_default.jpg'
  return url.startsWith('http') ? url : `${import.meta.env.VITE_API_URL}/storage/${url}`
})

// Chỉ owner mới được edit/delete/remove song
const isOwner = computed(() =>
  authStore.isLoggedIn && !!authStore.user && !!playlist.value &&
  authStore.user.id === (playlist.value as any).user_id
)

// ── Helpers ───────────────────────────────────────────────────────────────────
const getSongCover = (song: PlaylistSong): string => {
  const url = song.cover_url ?? song.album?.cover_url ?? null
  if (!url) return '/playlist_default.jpg'
  return url.startsWith('http') ? url : `${import.meta.env.VITE_API_URL}/storage/${url}`
}

const formatDuration = (seconds: number): string => {
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  if (h > 0) return `${h}h ${m}m`
  return `${m} min`
}

const formatTrackDuration = (seconds: number): string => {
  const m = Math.floor(seconds / 60)
  const s = seconds % 60
  return `${m}:${s.toString().padStart(2, '0')}`
}

const formatDate = (iso: string | null): string => {
  if (!iso) return '—'
  return new Date(iso).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
}

const handleImageError = (e: Event) => {
  (e.target as HTMLImageElement).src = '/playlist_default.jpg'
}

const handleAvatarError = (e: Event) => {
  (e.target as HTMLImageElement).src = '/default-avatar.jpg'
}

const showToast = (message: string, type: 'success' | 'error' = 'success') => {
  toast.message = message
  toast.type = type
  toast.visible = true
  setTimeout(() => { toast.visible = false }, 3000)
}

// ── Fetch ─────────────────────────────────────────────────────────────────────
const loadPlaylist = async () => {
  isLoading.value = true
  try {
    // Param có thể là numeric id hoặc slug — truyền thẳng vào service
    const raw = (route.params.slug ?? route.params.id) as string
    if (!raw) return
    // Nếu là số thì dùng số, nếu là slug thì dùng slug (backend hỗ trợ cả hai)
    const idOrSlug = isNaN(Number(raw)) ? raw : Number(raw)
    await playlistStore.fetchById(idOrSlug as number)
  } finally {
    isLoading.value = false
  }
}

// ── Player ────────────────────────────────────────────────────────────────────
const mapSong = (song: PlaylistSong) => ({
  ...song,
  urls: { standard: song.song_url ?? null },
})

const playSong = (song: PlaylistSong) => {
  const queue = songs.value.map(mapSong)
  player.play(mapSong(song), queue, playlist.value?.id)
}

const playAll = () => {
  if (!songs.value.length) return
  const queue = songs.value.map(mapSong)
  player.play(queue[0], queue, playlist.value?.id)
}

const playShuffle = () => {
  if (!songs.value.length) return
  const shuffled = [...songs.value].sort(() => Math.random() - 0.5).map(mapSong)
  player.play(shuffled[0], shuffled, playlist.value?.id)
}

// ── Context Menu ──────────────────────────────────────────────────────────────
const openContextMenu = (e: MouseEvent, song: PlaylistSong) => {
  e.preventDefault()
  const MENU_W = 200
  const MENU_H = 130
  const x = Math.min(e.clientX, window.innerWidth - MENU_W - 8)
  const y = Math.min(e.clientY, window.innerHeight - MENU_H - 8)
  contextMenu.x = x
  contextMenu.y = y
  contextMenu.song = song
  contextMenu.visible = true
}

const closeContextMenu = () => {
  contextMenu.visible = false
  contextMenu.song = null
}

const playSongFromMenu = () => {
  if (contextMenu.song) playSong(contextMenu.song)
  closeContextMenu()
}

const addToQueueFromMenu = () => {
  if (!contextMenu.song) return
  const mapped = mapSong(contextMenu.song)
  // Append to current queue if playing, otherwise just play
  if (player.currentSong) {
    const newQueue = [...(player as any).queue ?? [], mapped]
    ;(player as any).queue = newQueue
    showToast('Added to queue')
  } else {
    player.play(mapped, [mapped], playlist.value?.id)
  }
  closeContextMenu()
}

const removeSongFromMenu = async () => {
  if (!contextMenu.song || !playlist.value) return
  const songId = contextMenu.song.id
  closeContextMenu()
  try {
    await playlistStore.removeSong(playlist.value.id, songId)
    showToast('Removed from playlist')
  } catch {
    showToast('Failed to remove song', 'error')
  }
}

// ── Edit Modal ────────────────────────────────────────────────────────────────
const openEditModal = () => {
  if (!playlist.value) return
  editForm.name = playlist.value.name
  editForm.description = playlist.value.description ?? ''
  editForm.is_public = playlist.value.is_public
  editForm.cover = null
  editForm.previewUrl = ''
  showEditModal.value = true
}

const onCoverChange = (e: Event) => {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (!file) return
  editForm.cover = file
  editForm.previewUrl = URL.createObjectURL(file)
}

const saveEdit = async () => {
  if (!playlist.value || !editForm.name.trim()) return
  isSaving.value = true
  try {
    await playlistStore.update(playlist.value.id, {
      name: editForm.name.trim(),
      description: editForm.description.trim(),
      is_public: editForm.is_public,
      cover: editForm.cover,
    })
    showEditModal.value = false
    showToast('Playlist updated')
  } catch {
    showToast('Failed to update playlist', 'error')
  } finally {
    isSaving.value = false
  }
}

// ── Delete ────────────────────────────────────────────────────────────────────
const deletePlaylist = async () => {
  if (!playlist.value) return
  isDeleting.value = true
  try {
    await playlistStore.delete(playlist.value.id)
    confirmDelete.value = false
    router.replace({ name: 'client.Playlist.list' })
  } catch {
    showToast('Failed to delete playlist', 'error')
    isDeleting.value = false
  }
}

// ── Keyboard shortcut: Escape closes menus/modals ────────────────────────────
const onKeydown = (e: KeyboardEvent) => {
  if (e.key === 'Escape') {
    closeContextMenu()
    showEditModal.value = false
    confirmDelete.value = false
  }
}

// ── Lifecycle ─────────────────────────────────────────────────────────────────
onMounted(() => {
  loadPlaylist()
  window.addEventListener('keydown', onKeydown)
})

onBeforeUnmount(() => {
  window.removeEventListener('keydown', onKeydown)
})
</script>

<style scoped>
/* ── Shell ── */
.playlist-detail-shell {
  min-height: 100vh;
  color: #fff;
  position: relative;
  overflow-x: hidden;
  padding-bottom: 120px;
}

/* ── Background ── */
.bg-blur-container {
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 600px;
  overflow: hidden;
  z-index: 0;
  mask-image: linear-gradient(to bottom, black 40%, transparent 100%);
}
.banner-blur {
  width: 100%; height: 100%;
  background-size: cover;
  background-position: center;
  filter: blur(100px) saturate(1.5) opacity(0.3);
  transform: scale(1.3);
}
.banner-blur-placeholder {
  width: 100%; height: 100%;
  background: radial-gradient(circle at 30% 30%, #1a2a4a 0%, #080e14 100%);
  filter: blur(80px);
}

/* ── Content ── */
.content-container {
  position: relative;
  z-index: 1;
  max-width: 1280px;
  margin: 0 auto;
  padding: 40px;
}

/* ── Nav ── */
.header-nav { margin-bottom: 40px; }
.back-nav-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.7);
  padding: 8px 18px;
  border-radius: 99px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}
.back-nav-btn:hover {
  background: rgba(255,255,255,0.1);
  color: #fff;
  transform: translateX(-3px);
}

/* ── Hero ── */
.hero {
  display: flex;
  gap: 40px;
  align-items: flex-end;
  margin-bottom: 48px;
}
.hero-cover {
  width: 220px; height: 220px;
  border-radius: 16px;
  overflow: hidden;
  flex-shrink: 0;
  box-shadow: 0 20px 60px rgba(0,0,0,0.5);
  position: relative;
  cursor: pointer;
}
.hero-cover img { width: 100%; height: 100%; object-fit: cover; }
.hero-cover-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.55);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: #fff;
  font-size: 12px;
  font-weight: 600;
  opacity: 0;
  transition: opacity 0.2s;
}
.hero-cover:hover .hero-cover-overlay { opacity: 1; }

.hero-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 12px;
  min-width: 0;
}
.type-pill {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  color: #00aaff;
}
.hero-title {
  font-size: 56px;
  font-weight: 900;
  margin: 0;
  background: linear-gradient(135deg, #fff 0%, rgba(255,255,255,0.6) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  line-height: 1.1;
  word-break: break-word;
}
.hero-desc {
  font-size: 15px;
  color: rgba(255,255,255,0.5);
  margin: 0;
  font-style: italic;
}
.hero-meta {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: rgba(255,255,255,0.4);
  flex-wrap: wrap;
}
.dot { opacity: 0.4; }

/* ── Owner info ── */
.hero-owner {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 4px;
}
.owner-avatar {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  object-fit: cover;
  border: 2px solid rgba(255,255,255,0.15);
}
.owner-label {
  font-size: 13px;
  color: rgba(255,255,255,0.35);
}
.owner-name {
  font-size: 13px;
  font-weight: 600;
  color: rgba(255,255,255,0.7);
}

/* ── Hero Actions ── */
.hero-actions {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-top: 8px;
  flex-wrap: wrap;
}
.play-all-btn {
  background: #fff;
  color: #000;
  border: none;
  padding: 14px 32px;
  border-radius: 99px;
  font-weight: 800;
  font-size: 15px;
  display: inline-flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  transition: all 0.2s;
}
.play-all-btn:hover:not(:disabled) {
  transform: scale(1.05);
  box-shadow: 0 10px 30px rgba(255,255,255,0.2);
}
.play-all-btn:disabled { opacity: 0.4; cursor: not-allowed; }

.shuffle-btn {
  width: 46px; height: 46px;
  border-radius: 50%;
  background: rgba(255,255,255,0.08);
  border: 1px solid rgba(255,255,255,0.12);
  color: rgba(255,255,255,0.7);
  display: flex; align-items: center; justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
}
.shuffle-btn:hover:not(:disabled) {
  background: rgba(255,255,255,0.14);
  color: #fff;
  transform: scale(1.08);
}
.shuffle-btn:disabled { opacity: 0.3; cursor: not-allowed; }

.icon-action-btn {
  width: 40px; height: 40px;
  border-radius: 50%;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.55);
  display: flex; align-items: center; justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
}
.icon-action-btn:hover {
  background: rgba(255,255,255,0.12);
  color: #fff;
}
.icon-action-btn.danger:hover {
  background: rgba(239,68,68,0.15);
  border-color: rgba(239,68,68,0.3);
  color: #ef4444;
}

/* ── Tracks Toolbar ── */
.tracks-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
  gap: 16px;
  flex-wrap: wrap;
}
.search-box {
  position: relative;
  display: flex;
  align-items: center;
}
.search-icon {
  position: absolute;
  left: 12px;
  color: rgba(255,255,255,0.3);
  pointer-events: none;
}
.search-input {
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 10px;
  padding: 9px 36px 9px 36px;
  color: #fff;
  font-size: 13px;
  outline: none;
  width: 260px;
  transition: all 0.2s;
}
.search-input:focus {
  background: rgba(255,255,255,0.08);
  border-color: rgba(255,255,255,0.2);
  width: 320px;
}
.search-input::placeholder { color: rgba(255,255,255,0.3); }
.search-clear {
  position: absolute;
  right: 10px;
  background: none;
  border: none;
  color: rgba(255,255,255,0.4);
  cursor: pointer;
  font-size: 12px;
  padding: 2px 4px;
  border-radius: 4px;
  transition: color 0.15s;
}
.search-clear:hover { color: #fff; }
.tracks-count {
  font-size: 13px;
  color: rgba(255,255,255,0.3);
  white-space: nowrap;
}

/* ── Track Table ── */
.tracks-header {
  display: grid;
  grid-template-columns: 48px 1fr 180px 130px 70px 40px;
  padding: 10px 16px;
  border-bottom: 1px solid rgba(255,255,255,0.06);
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  color: rgba(255,255,255,0.3);
  letter-spacing: 0.1em;
  margin-bottom: 8px;
}
.th-duration { text-align: right; }

.track-row {
  display: grid;
  grid-template-columns: 48px 1fr 180px 130px 70px 40px;
  align-items: center;
  padding: 8px 16px;
  border-radius: 12px;
  cursor: pointer;
  transition: background 0.2s;
}
.track-row:hover { background: rgba(255,255,255,0.05); }
.track-row.is-active { background: rgba(0,170,255,0.08); }

.t-rank {
  display: flex;
  justify-content: center;
  color: rgba(255,255,255,0.3);
  font-size: 14px;
  font-family: monospace;
}
.t-info {
  display: flex;
  align-items: center;
  gap: 14px;
  min-width: 0;
}
.t-cover {
  width: 44px; height: 44px;
  border-radius: 8px;
  overflow: hidden;
  position: relative;
  flex-shrink: 0;
  background: rgba(255,255,255,0.05);
}
.t-cover img { width: 100%; height: 100%; object-fit: cover; }
.t-cover-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.55);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  opacity: 0;
  transition: 0.2s;
}
.track-row:hover .t-cover-overlay,
.track-row.is-active .t-cover-overlay { opacity: 1; }

.t-details { display: flex; flex-direction: column; gap: 3px; min-width: 0; }
.t-title {
  font-weight: 600;
  font-size: 14px;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  display: flex;
  align-items: center;
  gap: 6px;
}
.t-title.active { color: #00aaff; }
.explicit-badge {
  font-size: 9px;
  font-weight: 700;
  background: rgba(255,255,255,0.2);
  color: rgba(255,255,255,0.7);
  padding: 1px 5px;
  border-radius: 3px;
  flex-shrink: 0;
}
.t-artist {
  font-size: 12px;
  color: rgba(255,255,255,0.45);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.t-album, .t-added {
  font-size: 13px;
  color: rgba(255,255,255,0.35);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.t-duration {
  font-size: 13px;
  color: rgba(255,255,255,0.35);
  text-align: right;
  font-family: monospace;
}
.t-actions {
  display: flex;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.15s;
}
.track-row:hover .t-actions { opacity: 1; }
.row-menu-btn {
  width: 28px; height: 28px;
  border-radius: 6px;
  background: none;
  border: none;
  color: rgba(255,255,255,0.5);
  display: flex; align-items: center; justify-content: center;
  cursor: pointer;
  transition: all 0.15s;
}
.row-menu-btn:hover {
  background: rgba(255,255,255,0.1);
  color: #fff;
}

/* ── Wave animation ── */
.rank-wave { display: flex; align-items: flex-end; gap: 2px; height: 14px; }
.rank-wave span { display: block; width: 2px; background: #00aaff; border-radius: 1px; animation: wave 1s ease-in-out infinite; }
.rank-wave span:nth-child(2) { animation-delay: 0.2s; }
.rank-wave span:nth-child(3) { animation-delay: 0.4s; }
@keyframes wave { 0%, 100% { height: 4px; } 50% { height: 14px; } }

/* ── Empty ── */
.empty-tracks {
  text-align: center;
  padding: 80px 20px;
  color: rgba(255,255,255,0.3);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}
.empty-tracks h3 { font-size: 20px; color: rgba(255,255,255,0.6); margin: 0; }
.empty-tracks p { font-size: 14px; margin: 0; }

/* ── Not Found ── */
.not-found { text-align: center; padding: 100px 20px; }
.not-found h3 { font-size: 24px; margin-bottom: 20px; }
.reset-btn {
  background: rgba(255,255,255,0.1);
  border: none;
  padding: 10px 24px;
  border-radius: 30px;
  color: #fff;
  cursor: pointer;
  font-size: 13px;
  transition: background 0.2s;
}
.reset-btn:hover { background: rgba(255,255,255,0.15); }

/* ── Loading skeleton ── */
.loading-hero { display: flex; gap: 40px; margin-bottom: 48px; }
.skeleton-hero {
  width: 220px; height: 220px;
  border-radius: 16px;
  background: rgba(255,255,255,0.05);
  animation: pulse 1.5s infinite;
  flex-shrink: 0;
}
.loading-tracks { flex: 1; display: flex; flex-direction: column; gap: 8px; }
.skeleton-track {
  height: 60px;
  border-radius: 12px;
  background: rgba(255,255,255,0.03);
  animation: pulse 1.5s infinite;
}
@keyframes pulse { 0%, 100% { opacity: 0.3; } 50% { opacity: 0.6; } }

/* ── Context Menu ── */
.context-menu {
  position: fixed;
  z-index: 9999;
  background: #1a1d2e;
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 12px;
  padding: 6px;
  min-width: 200px;
  box-shadow: 0 16px 48px rgba(0,0,0,0.6);
  animation: ctx-pop 0.12s ease;
}
@keyframes ctx-pop { from { opacity: 0; transform: scale(0.95); } to { opacity: 1; transform: scale(1); } }
.ctx-item {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
  padding: 9px 14px;
  background: none;
  border: none;
  color: rgba(255,255,255,0.8);
  font-size: 13px;
  font-weight: 500;
  border-radius: 8px;
  cursor: pointer;
  text-align: left;
  transition: background 0.15s;
}
.ctx-item:hover { background: rgba(255,255,255,0.08); color: #fff; }
.ctx-item.danger { color: #ef4444; }
.ctx-item.danger:hover { background: rgba(239,68,68,0.12); }
.ctx-divider { height: 1px; background: rgba(255,255,255,0.07); margin: 4px 0; }

/* ── Modal Backdrop ── */
.modal-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.7);
  backdrop-filter: blur(6px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9998;
}

/* ── Edit Modal ── */
.edit-modal {
  background: #141824;
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 20px;
  width: 520px;
  max-width: 95vw;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 24px 80px rgba(0,0,0,0.7);
}
.edit-modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24px 28px 0;
}
.edit-modal-header h3 {
  font-size: 20px;
  font-weight: 700;
  margin: 0;
  background: linear-gradient(90deg, #fff, rgba(255,255,255,0.6));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
.modal-close {
  width: 32px; height: 32px;
  border-radius: 50%;
  background: rgba(255,255,255,0.07);
  border: none;
  color: rgba(255,255,255,0.5);
  font-size: 16px;
  cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  transition: all 0.2s;
}
.modal-close:hover { background: rgba(255,255,255,0.12); color: #fff; }

.edit-modal-body {
  display: flex;
  gap: 24px;
  padding: 24px 28px;
}
.edit-cover-wrap {
  flex-shrink: 0;
  width: 140px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
}
.edit-cover-wrap img {
  width: 140px; height: 140px;
  border-radius: 12px;
  object-fit: cover;
}
.edit-cover-label {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  font-weight: 600;
  color: rgba(255,255,255,0.6);
  cursor: pointer;
  padding: 6px 12px;
  border-radius: 8px;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.1);
  transition: all 0.2s;
  white-space: nowrap;
}
.edit-cover-label:hover { background: rgba(255,255,255,0.1); color: #fff; }
.hidden-file { display: none; }

.edit-fields { flex: 1; display: flex; flex-direction: column; gap: 16px; }
.field-group { display: flex; flex-direction: column; gap: 6px; }
.field-group label {
  font-size: 12px;
  font-weight: 600;
  color: rgba(255,255,255,0.5);
  text-transform: uppercase;
  letter-spacing: 0.08em;
}
.edit-input, .edit-textarea {
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 10px;
  padding: 10px 14px;
  color: #fff;
  font-size: 14px;
  outline: none;
  transition: border-color 0.2s;
  resize: none;
  font-family: inherit;
}
.edit-input:focus, .edit-textarea:focus {
  border-color: rgba(0,170,255,0.5);
  background: rgba(255,255,255,0.07);
}
.toggle-label {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 14px;
  font-weight: 500;
  color: rgba(255,255,255,0.8);
  text-transform: none;
  letter-spacing: 0;
  cursor: pointer;
}
.toggle-wrap { cursor: pointer; }
.toggle {
  width: 44px; height: 24px;
  border-radius: 12px;
  background: rgba(255,255,255,0.15);
  position: relative;
  transition: background 0.25s;
}
.toggle.on { background: #00aaff; }
.toggle-knob {
  position: absolute;
  top: 3px; left: 3px;
  width: 18px; height: 18px;
  border-radius: 50%;
  background: #fff;
  transition: transform 0.25s;
  box-shadow: 0 1px 4px rgba(0,0,0,0.3);
}
.toggle.on .toggle-knob { transform: translateX(20px); }
.field-hint { font-size: 12px; color: rgba(255,255,255,0.35); margin: 0; }

.edit-modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 0 28px 24px;
}
.btn-cancel {
  padding: 10px 22px;
  border-radius: 10px;
  background: rgba(255,255,255,0.07);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.7);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}
.btn-cancel:hover { background: rgba(255,255,255,0.12); color: #fff; }
.btn-save {
  padding: 10px 24px;
  border-radius: 10px;
  background: #00aaff;
  border: none;
  color: #fff;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  display: flex; align-items: center; gap: 8px;
  transition: all 0.2s;
}
.btn-save:hover:not(:disabled) { background: #0099ee; transform: translateY(-1px); }
.btn-save:disabled { opacity: 0.5; cursor: not-allowed; }
.saving-spinner {
  width: 14px; height: 14px;
  border: 2px solid rgba(255,255,255,0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* ── Confirm Modal ── */
.confirm-modal {
  background: #141824;
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 20px;
  width: 400px;
  max-width: 95vw;
  padding: 36px 32px 28px;
  text-align: center;
  box-shadow: 0 24px 80px rgba(0,0,0,0.7);
}
.confirm-icon {
  width: 72px; height: 72px;
  border-radius: 50%;
  background: rgba(239,68,68,0.12);
  border: 1px solid rgba(239,68,68,0.25);
  display: flex; align-items: center; justify-content: center;
  margin: 0 auto 20px;
  color: #ef4444;
}
.confirm-modal h3 { font-size: 20px; font-weight: 700; margin: 0 0 10px; }
.confirm-modal p { font-size: 14px; color: rgba(255,255,255,0.5); margin: 0 0 28px; line-height: 1.6; }
.confirm-modal strong { color: rgba(255,255,255,0.85); }
.confirm-actions { display: flex; gap: 10px; justify-content: center; }
.btn-delete {
  padding: 10px 28px;
  border-radius: 10px;
  background: #ef4444;
  border: none;
  color: #fff;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.2s;
}
.btn-delete:hover:not(:disabled) { background: #dc2626; }
.btn-delete:disabled { opacity: 0.5; cursor: not-allowed; }

/* ── Toast ── */
.toast {
  position: fixed;
  bottom: 100px;
  left: 50%;
  transform: translateX(-50%);
  padding: 12px 24px;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 600;
  z-index: 99999;
  pointer-events: none;
  box-shadow: 0 8px 32px rgba(0,0,0,0.4);
}
.toast.success { background: #10b981; color: #fff; }
.toast.error   { background: #ef4444; color: #fff; }

/* ── Transitions ── */
.modal-fade-enter-active, .modal-fade-leave-active { transition: all 0.2s ease; }
.modal-fade-enter-from, .modal-fade-leave-to { opacity: 0; }
.modal-fade-enter-from .edit-modal,
.modal-fade-enter-from .confirm-modal { transform: scale(0.95) translateY(10px); }

.toast-slide-enter-active, .toast-slide-leave-active { transition: all 0.25s ease; }
.toast-slide-enter-from, .toast-slide-leave-to { opacity: 0; transform: translateX(-50%) translateY(12px); }

/* ── Responsive ── */
@media (max-width: 768px) {
  .content-container { padding: 20px; }
  .hero { flex-direction: column; align-items: center; text-align: center; gap: 24px; }
  .hero-cover { width: 160px; height: 160px; }
  .hero-title { font-size: 36px; }
  .hero-meta { justify-content: center; }
  .hero-actions { justify-content: center; }
  .tracks-header, .track-row { grid-template-columns: 40px 1fr 70px 40px; }
  .hide-mobile { display: none; }
  .loading-hero { flex-direction: column; }
  .skeleton-hero { width: 160px; height: 160px; }
  .search-input { width: 200px; }
  .search-input:focus { width: 240px; }
  .edit-modal-body { flex-direction: column; align-items: center; }
  .edit-cover-wrap { width: 100%; align-items: center; }
}
@media (max-width: 480px) {
  .hero-title { font-size: 28px; }
  .play-all-btn { padding: 12px 24px; font-size: 14px; }
  .tracks-header, .track-row { grid-template-columns: 36px 1fr 60px 36px; }
}
</style>

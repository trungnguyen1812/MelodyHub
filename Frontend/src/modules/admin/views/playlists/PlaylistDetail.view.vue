
<template>
  <div class="detail-shell">
    <div class="bg-grid" aria-hidden="true"></div>

    <div class="detail-nav">
      <button class="back-btn" @click="$router.back()">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M17 10a.75.75 0 0 1-.75.75H5.612l4.158 3.96a.75.75 0 1 1-1.04 1.08l-5.5-5.25a.75.75 0 0 1 0-1.08l5.5-5.25a.75.75 0 1 1 1.04 1.08L5.612 9.25H16.25A.75.75 0 0 1 17 10Z" clip-rule="evenodd" />
        </svg>
        Back to Playlists
      </button>
    </div>

    <div v-if="store.loadingDetail" class="loading-hero">
      <div class="skel-cover"></div>
      <div class="skel-info">
        <div class="skel skel-title"></div>
        <div class="skel skel-med"></div>
        <div class="skel skel-sm"></div>
      </div>
    </div>

    <template v-else-if="store.current">
      <div class="hero-card">
        <div class="hero-cover">
          <img :src="store.current.cover_url || '/playlist_default.jpg'" :alt="store.current.name" @error="onImgError" />
        </div>
        <div class="hero-info">
          <div class="hero-badges">
            <span class="badge-type">Playlist</span>
            <span class="badge-vis" :class="store.current.is_public ? 'public' : 'private'">
              {{ store.current.is_public ? 'Public' : 'Private' }}
            </span>
          </div>
          <h1 class="hero-title">{{ store.current.name }}</h1>
          <p class="hero-desc" v-if="store.current.description">{{ store.current.description }}</p>

          <div class="hero-owner" v-if="store.current.user">
            <img :src="store.current.user.avatar_url || '/default-avatar.jpg'" :alt="store.current.user.name" class="owner-avatar" @error="onAvatarError" />
            <div>
              <div class="owner-name">{{ store.current.user.name }}</div>
              <div class="owner-email">{{ store.current.user.email }}</div>
            </div>
          </div>

          <div class="hero-meta">
            <div class="meta-item"><span class="meta-lbl">Songs</span><span class="meta-val">{{ store.current.total_songs }}</span></div>
            <div class="meta-item"><span class="meta-lbl">Duration</span><span class="meta-val">{{ formatDuration(store.current.total_duration) }}</span></div>
            <div class="meta-item"><span class="meta-lbl">Plays</span><span class="meta-val">{{ formatNumber(store.current.total_plays) }}</span></div>
            <div class="meta-item"><span class="meta-lbl">Created</span><span class="meta-val">{{ formatDate(store.current.created_at) }}</span></div>
          </div>

          <div class="hero-actions">
            <button class="btn-toggle-vis" :class="store.current.is_public ? 'is-public' : 'is-private'" @click="toggleVisibility" :disabled="toggling">
              {{ toggling ? 'Updating…' : (store.current.is_public ? 'Make Private' : 'Make Public') }}
            </button>
            <button class="btn-danger" @click="confirmDelete = true">Delete Playlist</button>
          </div>
        </div>
      </div>

      <div class="songs-card">
        <div class="songs-header">
          <h2 class="songs-title">Songs <span class="songs-count">{{ store.songs.length }}</span></h2>
        </div>
        <div class="table-wrap">
          <table class="gtable">
            <thead>
              <tr>
                <th style="width:40px">#</th>
                <th>Title</th>
                <th>Artist</th>
                <th>Album</th>
                <th>Duration</th>
                <th>Added</th>
                <th style="width:60px"></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(song, idx) in store.songs" :key="song.id" class="g-row">
                <td class="pos-cell">{{ song.position ?? idx + 1 }}</td>
                <td>
                  <div class="song-cell">
                    <div class="song-cover"><img :src="song.cover_url || '/playlist_default.jpg'" :alt="song.title" @error="onImgError" /></div>
                    <div class="song-meta">
                      <span class="song-title">{{ song.title }}</span>
                      <span v-if="song.is_explicit" class="explicit-badge">E</span>
                    </div>
                  </div>
                </td>
                <td><span class="text-dim">{{ song.artist?.name || '—' }}</span></td>
                <td><span class="text-dim">{{ song.album?.title || 'Single' }}</span></td>
                <td><span class="text-dim mono">{{ formatTrackDuration(song.duration) }}</span></td>
                <td><span class="text-dim">{{ song.added_at ? formatDate(song.added_at) : '—' }}</span></td>
                <td>
                  <button class="act-btn delete" @click="removeSong(song.id)" title="Remove">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="13" height="13">
                      <path fill-rule="evenodd" d="M8.75 1A2.75 2.75 0 0 0 6 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 1 0 .23 1.482l.149-.022.841 10.518A2.75 2.75 0 0 0 7.596 19h4.807a2.75 2.75 0 0 0 2.742-2.53l.841-10.52.149.023a.75.75 0 0 0 .23-1.482A41.03 41.03 0 0 0 14 4.193V3.75A2.75 2.75 0 0 0 11.25 1h-2.5ZM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4ZM8.58 7.72a.75.75 0 0 0-1.5.06l.3 7.5a.75.75 0 1 0 1.5-.06l-.3-7.5Zm4.34.06a.75.75 0 1 0-1.5-.06l-.3 7.5a.75.75 0 1 0 1.5.06l.3-7.5Z" clip-rule="evenodd" />
                    </svg>
                  </button>
                </td>
              </tr>
              <tr v-if="store.songs.length === 0">
                <td colspan="7" class="empty-row">
                  <div class="empty-state">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1" width="40" height="40"><path stroke-linecap="round" stroke-linejoin="round" d="m9 9 10.5-3m0 6.553v3.75a2.25 2.25 0 0 1-1.632 2.163l-1.32.377a1.803 1.803 0 1 1-2.8-1.452l.328-.094a1.125 1.125 0 0 0 .764-1.235V5.11a.75.75 0 0 0-.272-.578l-7.5 5.75a.75.75 0 0 0-.228.531V16.65c0 .543-.321 1.03-.815 1.235l-1.32.378a1.803 1.803 0 1 1-2.8-1.452l.328-.094a1.125 1.125 0 0 0 .764-1.235V10.5c0-.621.504-1.125 1.125-1.125h1.5" /></svg>
                    <p>No songs in this playlist</p>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </template>

    <div v-else class="not-found"><h3>Playlist not found</h3><button class="back-btn" @click="$router.back()">Go Back</button></div>

    <Teleport to="body">
      <Transition name="modal-fade">
        <div v-if="confirmDelete" class="modal-backdrop" @click.self="confirmDelete = false">
          <div class="confirm-modal">
            <div class="confirm-icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="36" height="36"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" /></svg></div>
            <h3>Delete playlist?</h3>
            <p>Permanently delete <strong>"{{ store.current?.name }}"</strong>? This cannot be undone.</p>
            <div class="confirm-actions">
              <button class="btn-cancel" @click="confirmDelete = false">Cancel</button>
              <button class="btn-delete" @click="doDelete" :disabled="deleting">{{ deleting ? 'Deleting…' : 'Delete' }}</button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>

    <Teleport to="body">
      <Transition name="toast-slide">
        <div v-if="toast.show" class="toast" :class="toast.type">{{ toast.msg }}</div>
      </Transition>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAdminPlaylistStore } from '@/modules/admin/stores/playlists/playlistsStore'

const route  = useRoute()
const router = useRouter()
const store  = useAdminPlaylistStore()

const toggling      = ref(false)
const confirmDelete = ref(false)
const deleting      = ref(false)
const toast         = reactive({ show: false, msg: '', type: 'success' as 'success' | 'error' })

const showToast = (msg: string, type: 'success' | 'error' = 'success') => {
  toast.msg = msg; toast.type = type; toast.show = true
  setTimeout(() => { toast.show = false }, 3000)
}

const formatDate = (iso: string) =>
  new Date(iso).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
const formatDuration = (s: number) => {
  const h = Math.floor(s / 3600); const m = Math.floor((s % 3600) / 60)
  return h > 0 ? `${h}h ${m}m` : `${m} min`
}
const formatTrackDuration = (s: number) => {
  const m = Math.floor(s / 60); const sec = s % 60
  return `${m}:${sec.toString().padStart(2, '0')}`
}
const formatNumber = (n: number) =>
  n >= 1_000_000 ? (n / 1_000_000).toFixed(1) + 'M' : n >= 1_000 ? (n / 1_000).toFixed(1) + 'K' : String(n ?? 0)

const onImgError    = (e: Event) => { (e.target as HTMLImageElement).src = '/playlist_default.jpg' }
const onAvatarError = (e: Event) => { (e.target as HTMLImageElement).src = '/default-avatar.jpg' }

const toggleVisibility = async () => {
  if (!store.current) return
  toggling.value = true
  try { await store.updateStatus(store.current.id, !store.current.is_public); showToast('Visibility updated') }
  catch { showToast('Failed to update', 'error') }
  finally { toggling.value = false }
}

const removeSong = async (songId: number) => {
  if (!store.current) return
  try { await store.removeSong(store.current.id, songId); showToast('Song removed') }
  catch { showToast('Failed to remove song', 'error') }
}

const doDelete = async () => {
  if (!store.current) return
  deleting.value = true
  try { await store.deletePlaylist(store.current.id); router.replace({ name: 'admin.playlistsmanager' }) }
  catch { showToast('Failed to delete', 'error'); deleting.value = false }
}

onMounted(() => { const id = Number(route.params.id); if (id) store.fetchById(id) })
</script>

<style scoped>
.detail-shell { padding: 28px 32px; min-height: 100vh; color: #e5e7eb; position: relative; }
.bg-grid { position: fixed; inset: 0; z-index: 0; pointer-events: none; background-image: linear-gradient(rgba(255,255,255,0.015) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.015) 1px, transparent 1px); background-size: 40px 40px; }
.detail-nav { margin-bottom: 28px; position: relative; z-index: 1; }
.back-btn { display: inline-flex; align-items: center; gap: 8px; background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); color: rgba(255,255,255,0.7); padding: 8px 18px; border-radius: 99px; font-size: 13px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
.back-btn:hover { background: rgba(255,255,255,0.1); color: #fff; transform: translateX(-3px); }
.hero-card { display: flex; gap: 36px; align-items: flex-start; background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07); border-radius: 20px; padding: 28px; margin-bottom: 24px; position: relative; z-index: 1; }
.hero-cover { width: 200px; height: 200px; border-radius: 14px; overflow: hidden; flex-shrink: 0; box-shadow: 0 16px 48px rgba(0,0,0,0.5); }
.hero-cover img { width: 100%; height: 100%; object-fit: cover; }
.hero-info { flex: 1; display: flex; flex-direction: column; gap: 14px; min-width: 0; }
.hero-badges { display: flex; gap: 8px; }
.badge-type { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.12em; color: #818cf8; background: rgba(99,102,241,0.15); padding: 3px 10px; border-radius: 20px; }
.badge-vis { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.12em; padding: 3px 10px; border-radius: 20px; }
.badge-vis.public { color: #34d399; background: rgba(16,185,129,0.15); }
.badge-vis.private { color: rgba(255,255,255,0.5); background: rgba(255,255,255,0.07); }
.hero-title { font-size: 32px; font-weight: 800; color: #fff; margin: 0; line-height: 1.2; }
.hero-desc { font-size: 14px; color: rgba(255,255,255,0.5); margin: 0; font-style: italic; }
.hero-owner { display: flex; align-items: center; gap: 10px; }
.owner-avatar { width: 36px; height: 36px; border-radius: 50%; object-fit: cover; border: 2px solid rgba(255,255,255,0.1); }
.owner-name { font-size: 14px; font-weight: 600; color: #e5e7eb; }
.owner-email { font-size: 12px; color: rgba(255,255,255,0.4); }
.hero-meta { display: flex; gap: 24px; flex-wrap: wrap; }
.meta-item { display: flex; flex-direction: column; gap: 2px; }
.meta-lbl { font-size: 11px; color: rgba(255,255,255,0.35); text-transform: uppercase; letter-spacing: 0.08em; }
.meta-val { font-size: 16px; font-weight: 700; color: #fff; }
.hero-actions { display: flex; gap: 10px; flex-wrap: wrap; }
.btn-toggle-vis { padding: 9px 22px; border-radius: 10px; border: none; font-size: 13px; font-weight: 700; cursor: pointer; transition: all 0.2s; }
.btn-toggle-vis.is-public { background: rgba(255,255,255,0.1); color: rgba(255,255,255,0.8); }
.btn-toggle-vis.is-private { background: rgba(16,185,129,0.2); color: #34d399; }
.btn-toggle-vis:hover:not(:disabled) { filter: brightness(1.2); }
.btn-toggle-vis:disabled { opacity: 0.5; cursor: not-allowed; }
.btn-danger { padding: 9px 22px; border-radius: 10px; background: rgba(239,68,68,0.15); border: 1px solid rgba(239,68,68,0.3); color: #f87171; font-size: 13px; font-weight: 700; cursor: pointer; transition: all 0.2s; }
.btn-danger:hover { background: rgba(239,68,68,0.25); }
.songs-card { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07); border-radius: 16px; overflow: hidden; position: relative; z-index: 1; }
.songs-header { padding: 18px 20px 0; }
.songs-title { font-size: 16px; font-weight: 700; color: #fff; margin: 0 0 16px; }
.songs-count { display: inline-block; background: rgba(99,102,241,0.15); color: #818cf8; font-size: 12px; padding: 2px 8px; border-radius: 20px; margin-left: 8px; }
.table-wrap { overflow-x: auto; }
.gtable { width: 100%; border-collapse: collapse; }
.gtable thead tr { border-bottom: 1px solid rgba(255,255,255,0.07); }
.gtable th { padding: 10px 16px; text-align: left; font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.08em; color: rgba(255,255,255,0.3); }
.g-row { border-bottom: 1px solid rgba(255,255,255,0.04); transition: background 0.15s; }
.g-row:hover { background: rgba(255,255,255,0.03); }
.g-row:last-child { border-bottom: none; }
.gtable td { padding: 10px 16px; font-size: 13px; vertical-align: middle; }
.pos-cell { color: rgba(255,255,255,0.3); font-family: monospace; }
.song-cell { display: flex; align-items: center; gap: 10px; }
.song-cover { width: 38px; height: 38px; border-radius: 6px; overflow: hidden; flex-shrink: 0; background: rgba(255,255,255,0.05); }
.song-cover img { width: 100%; height: 100%; object-fit: cover; }
.song-meta { display: flex; align-items: center; gap: 6px; }
.song-title { font-weight: 500; color: #e5e7eb; }
.explicit-badge { font-size: 9px; font-weight: 700; background: rgba(255,255,255,0.15); color: rgba(255,255,255,0.6); padding: 1px 5px; border-radius: 3px; }
.text-dim { color: rgba(255,255,255,0.45); }
.mono { font-family: monospace; }
.act-btn { width: 28px; height: 28px; border-radius: 7px; border: none; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.15s; }
.act-btn.delete { background: rgba(239,68,68,0.1); color: #f87171; }
.act-btn.delete:hover { background: rgba(239,68,68,0.22); }
.empty-row { text-align: center; padding: 48px 20px !important; }
.empty-state { display: flex; flex-direction: column; align-items: center; gap: 10px; color: rgba(255,255,255,0.25); }
.empty-state p { font-size: 13px; margin: 0; }
.loading-hero { display: flex; gap: 28px; padding: 28px; background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07); border-radius: 20px; margin-bottom: 24px; position: relative; z-index: 1; }
.skel-cover { width: 200px; height: 200px; border-radius: 14px; background: rgba(255,255,255,0.06); animation: pulse 1.5s infinite; flex-shrink: 0; }
.skel-info { flex: 1; display: flex; flex-direction: column; gap: 12px; padding-top: 8px; }
.skel { height: 14px; border-radius: 6px; background: rgba(255,255,255,0.06); animation: pulse 1.5s infinite; }
.skel-title { height: 32px; width: 60%; } .skel-med { width: 50%; } .skel-sm { width: 35%; }
@keyframes pulse { 0%,100% { opacity: 0.4; } 50% { opacity: 0.8; } }
.not-found { text-align: center; padding: 80px 20px; position: relative; z-index: 1; }
.not-found h3 { font-size: 20px; margin-bottom: 20px; }
.modal-backdrop { position: fixed; inset: 0; background: rgba(0,0,0,0.7); backdrop-filter: blur(6px); display: flex; align-items: center; justify-content: center; z-index: 9999; }
.confirm-modal { background: #141824; border: 1px solid rgba(255,255,255,0.1); border-radius: 20px; width: 380px; max-width: 95vw; padding: 36px 28px 28px; text-align: center; box-shadow: 0 24px 80px rgba(0,0,0,0.7); }
.confirm-icon { width: 64px; height: 64px; border-radius: 50%; background: rgba(239,68,68,0.12); border: 1px solid rgba(239,68,68,0.25); display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; color: #ef4444; }
.confirm-modal h3 { font-size: 18px; font-weight: 700; margin: 0 0 10px; color: #fff; }
.confirm-modal p { font-size: 14px; color: rgba(255,255,255,0.5); margin: 0 0 28px; line-height: 1.6; }
.confirm-modal strong { color: rgba(255,255,255,0.85); }
.confirm-actions { display: flex; gap: 10px; justify-content: center; }
.btn-cancel { padding: 9px 22px; border-radius: 10px; background: rgba(255,255,255,0.07); border: 1px solid rgba(255,255,255,0.1); color: rgba(255,255,255,0.7); font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
.btn-cancel:hover { background: rgba(255,255,255,0.12); color: #fff; }
.btn-delete { padding: 9px 24px; border-radius: 10px; background: #ef4444; border: none; color: #fff; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.2s; }
.btn-delete:hover:not(:disabled) { background: #dc2626; }
.btn-delete:disabled { opacity: 0.5; cursor: not-allowed; }
.toast { position: fixed; bottom: 28px; left: 50%; transform: translateX(-50%); padding: 12px 24px; border-radius: 12px; font-size: 14px; font-weight: 600; z-index: 99999; pointer-events: none; box-shadow: 0 8px 32px rgba(0,0,0,0.4); }
.toast.success { background: #10b981; color: #fff; }
.toast.error { background: #ef4444; color: #fff; }
.modal-fade-enter-active, .modal-fade-leave-active { transition: opacity 0.2s; }
.modal-fade-enter-from, .modal-fade-leave-to { opacity: 0; }
.toast-slide-enter-active, .toast-slide-leave-active { transition: all 0.25s; }
.toast-slide-enter-from, .toast-slide-leave-to { opacity: 0; transform: translateX(-50%) translateY(10px); }
@media (max-width: 768px) { .detail-shell { padding: 16px; } .hero-card { flex-direction: column; } .hero-cover { width: 140px; height: 140px; } .hero-title { font-size: 24px; } }
</style>

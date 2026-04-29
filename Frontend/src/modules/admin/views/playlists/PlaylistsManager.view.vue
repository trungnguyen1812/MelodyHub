<template>
  <div class="playlists-shell">
    <div class="bg-grid" aria-hidden="true"></div>

    <!-- Stats -->
    <div class="stats-row">
      <div class="stat-card">
        <div class="stat-icon total"><svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20"><path d="M9 9l10.5-3m0 6.553v3.75a2.25 2.25 0 0 1-1.632 2.163l-1.32.377a1.803 1.803 0 1 1-2.8-1.452l.328-.094a1.125 1.125 0 0 0 .764-1.235V5.11a.75.75 0 0 0-.272-.578l-7.5 5.75a.75.75 0 0 0-.228.531V16.65c0 .543-.321 1.03-.815 1.235l-1.32.378a1.803 1.803 0 1 1-2.8-1.452l.328-.094a1.125 1.125 0 0 0 .764-1.235V10.5c0-.621.504-1.125 1.125-1.125h1.5"/></svg></div>
        <div class="stat-body"><span class="stat-val">{{ store.stats.total }}</span><span class="stat-lbl">Total</span></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon public"><svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 17.93c-3.95-.49-7-3.85-7-7.93 0-.62.08-1.21.21-1.79L9 15v1c0 1.1.9 2 2 2v1.93zm6.9-2.54c-.26-.81-1-1.39-1.9-1.39h-1v-3c0-.55-.45-1-1-1H8v-2h2c.55 0 1-.45 1-1V7h2c1.1 0 2-.9 2-2v-.41c2.93 1.19 5 4.06 5 7.41 0 2.08-.8 3.97-2.1 5.39z"/></svg></div>
        <div class="stat-body"><span class="stat-val">{{ store.stats.public }}</span><span class="stat-lbl">Public</span></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon private"><svg viewBox="0 0 24 24" fill="currentColor" width="20" height="20"><path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/></svg></div>
        <div class="stat-body"><span class="stat-val">{{ store.stats.private }}</span><span class="stat-lbl">Private</span></div>
      </div>
    </div>

    <!-- Header -->
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">Playlists</h1>
        <span class="page-badge">{{ filteredPlaylists.length }} results</span>
      </div>
      <div class="header-right">
        <div class="search-wrap">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15" class="search-ico">
            <path fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11ZM2 9a7 7 0 1 1 12.452 4.391l3.328 3.329a.75.75 0 1 1-1.06 1.06l-3.329-3.328A7 7 0 0 1 2 9Z" clip-rule="evenodd" />
          </svg>
          <input v-model="keyword" type="text" placeholder="Search playlists, users…" class="search-input" @input="onSearch" />
          <span v-if="keyword" class="search-clear" @click="clearSearch">✕</span>
        </div>
        <select v-model="statusFilter" class="filter-select" @change="onSearch">
          <option value="">All</option>
          <option value="public">Public</option>
          <option value="private">Private</option>
        </select>
      </div>
    </div>

    <!-- Table -->
    <div class="table-card">
      <div class="table-wrap">
        <table class="gtable">
          <thead>
            <tr>
              <th style="width:35%">Playlist</th>
              <th>Owner</th>
              <th>Tracks</th>
              <th>Plays</th>
              <th>Visibility</th>
              <th>Created</th>
              <th style="width:120px">Actions</th>
            </tr>
          </thead>
          <tbody>
            <template v-if="!store.loading">
              <tr v-for="pl in paginatedPlaylists" :key="pl.id" class="g-row">
                <!-- Playlist cell -->
                <td>
                  <div class="item-cell">
                    <div class="item-cover playlist-cover">
                      <img :src="pl.cover_url || '/playlist_default.jpg'" :alt="pl.name" loading="lazy" @error="onImgError" />
                    </div>
                    <div class="item-meta">
                      <span class="item-name">{{ pl.name }}</span>
                      <span class="item-sub" v-if="pl.description">{{ truncate(pl.description, 50) }}</span>
                      <span class="item-slug">{{ pl.slug }}</span>
                    </div>
                  </div>
                </td>

                <!-- Owner -->
                <td>
                  <div class="owner-cell" v-if="pl.user">
                    <img :src="pl.user.avatar_url || '/default-avatar.jpg'" :alt="pl.user.name" class="owner-avatar" @error="onAvatarError" />
                    <div class="owner-info">
                      <span class="owner-name">{{ pl.user.name }}</span>
                      <span class="owner-email">{{ pl.user.email }}</span>
                    </div>
                  </div>
                  <span v-else class="text-muted">—</span>
                </td>

                <td><span class="num-val">{{ pl.total_songs }}</span></td>
                <td><span class="num-val">{{ formatNumber(pl.total_plays) }}</span></td>

                <!-- Visibility toggle -->
                <td>
                  <button
                    class="visibility-toggle"
                    :class="pl.is_public ? 'is-public' : 'is-private'"
                    @click="toggleVisibility(pl)"
                    :disabled="togglingId === pl.id"
                    :title="pl.is_public ? 'Click to make private' : 'Click to make public'"
                  >
                    <span class="vis-dot"></span>
                    {{ pl.is_public ? 'Public' : 'Private' }}
                  </button>
                </td>

                <td><span class="date-val">{{ formatDate(pl.created_at) }}</span></td>

                <td>
                  <div class="actions">
                    <button class="act-btn view" @click="viewDetail(pl.id)" title="View detail">
                      <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                    </svg>
                    </button>
                    <button class="act-btn delete" @click="confirmDelete(pl)" title="Delete">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                        <path fill-rule="evenodd" d="M8.75 1A2.75 2.75 0 0 0 6 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 1 0 .23 1.482l.149-.022.841 10.518A2.75 2.75 0 0 0 7.596 19h4.807a2.75 2.75 0 0 0 2.742-2.53l.841-10.52.149.023a.75.75 0 0 0 .23-1.482A41.03 41.03 0 0 0 14 4.193V3.75A2.75 2.75 0 0 0 11.25 1h-2.5ZM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4ZM8.58 7.72a.75.75 0 0 0-1.5.06l.3 7.5a.75.75 0 1 0 1.5-.06l-.3-7.5Zm4.34.06a.75.75 0 1 0-1.5-.06l-.3 7.5a.75.75 0 1 0 1.5.06l.3-7.5Z" clip-rule="evenodd" />
                      </svg>
                    </button>
                  </div>
                </td>
              </tr>

              <!-- Empty -->
              <tr v-if="!store.loading && filteredPlaylists.length === 0">
                <td colspan="7" class="empty-row">
                  <div class="empty-state">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1" width="48" height="48">
                      <path stroke-linecap="round" stroke-linejoin="round" d="m9 9 10.5-3m0 6.553v3.75a2.25 2.25 0 0 1-1.632 2.163l-1.32.377a1.803 1.803 0 1 1-2.8-1.452l.328-.094a1.125 1.125 0 0 0 .764-1.235V5.11a.75.75 0 0 0-.272-.578l-7.5 5.75a.75.75 0 0 0-.228.531V16.65c0 .543-.321 1.03-.815 1.235l-1.32.378a1.803 1.803 0 1 1-2.8-1.452l.328-.094a1.125 1.125 0 0 0 .764-1.235V10.5c0-.621.504-1.125 1.125-1.125h1.5" />
                    </svg>
                    <p>No playlists found</p>
                  </div>
                </td>
              </tr>
            </template>

            <!-- Loading skeleton -->
            <template v-else>
              <tr v-for="i in 8" :key="i" class="g-row skeleton-row">
                <td><div class="skel skel-wide"></div></td>
                <td><div class="skel skel-med"></div></td>
                <td><div class="skel skel-sm"></div></td>
                <td><div class="skel skel-sm"></div></td>
                <td><div class="skel skel-med"></div></td>
                <td><div class="skel skel-med"></div></td>
                <td><div class="skel skel-sm"></div></td>
              </tr>
            </template>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <div class="pagination" v-if="totalPages > 1">
        <button class="pg-btn" :disabled="page === 1" @click="page--">‹</button>
        <button
          v-for="p in totalPages" :key="p"
          class="pg-btn" :class="{ active: p === page }"
          @click="page = p"
        >{{ p }}</button>
        <button class="pg-btn" :disabled="page === totalPages" @click="page++">›</button>
      </div>
    </div>

    <!-- Delete confirm modal -->
    <Teleport to="body">
      <Transition name="modal-fade">
        <div v-if="deleteTarget" class="modal-backdrop" @click.self="deleteTarget = null">
          <div class="confirm-modal">
            <div class="confirm-icon">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="36" height="36">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" />
              </svg>
            </div>
            <h3>Delete playlist?</h3>
            <p>Permanently delete <strong>"{{ deleteTarget.name }}"</strong>? This cannot be undone.</p>
            <div class="confirm-actions">
              <button class="btn-cancel" @click="deleteTarget = null">Cancel</button>
              <button class="btn-delete" @click="doDelete" :disabled="deleting">
                {{ deleting ? 'Deleting…' : 'Delete' }}
              </button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>

    <!-- Toast -->
    <Teleport to="body">
      <Transition name="toast-slide">
        <div v-if="toast.show" class="toast" :class="toast.type">{{ toast.msg }}</div>
      </Transition>
    </Teleport>
  </div>
</template>


<script setup lang="ts">
import { ref, computed, onMounted, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useAdminPlaylistStore } from '@/modules/admin/stores/playlists/playlistsStore'
import type { AdminPlaylist } from '@/modules/admin/stores/playlists/playlistsStore'

const router = useRouter()
const store  = useAdminPlaylistStore()

// ── State ──────────────────────────────────────────────────────────────────
const keyword      = ref('')
const statusFilter = ref('')
const page         = ref(1)
const PAGE_SIZE    = 12
const togglingId   = ref<number | null>(null)
const deleteTarget = ref<AdminPlaylist | null>(null)
const deleting     = ref(false)
const toast        = reactive({ show: false, msg: '', type: 'success' as 'success' | 'error' })

// ── Computed ───────────────────────────────────────────────────────────────
const filteredPlaylists = computed(() => {
  const q = keyword.value.toLowerCase().trim()
  return store.playlists.filter(p => {
    const matchQ = !q ||
      p.name.toLowerCase().includes(q) ||
      (p.description ?? '').toLowerCase().includes(q) ||
      (p.user?.name ?? '').toLowerCase().includes(q) ||
      (p.user?.email ?? '').toLowerCase().includes(q)
    const matchStatus = !statusFilter.value ||
      (statusFilter.value === 'public' && p.is_public) ||
      (statusFilter.value === 'private' && !p.is_public)
    return matchQ && matchStatus
  })
})

const totalPages = computed(() => Math.ceil(filteredPlaylists.value.length / PAGE_SIZE))

const paginatedPlaylists = computed(() => {
  const start = (page.value - 1) * PAGE_SIZE
  return filteredPlaylists.value.slice(start, start + PAGE_SIZE)
})

// ── Helpers ────────────────────────────────────────────────────────────────
const formatDate = (iso: string) =>
  new Date(iso).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })

const formatNumber = (n: number) =>
  n >= 1_000_000 ? (n / 1_000_000).toFixed(1) + 'M'
  : n >= 1_000   ? (n / 1_000).toFixed(1) + 'K'
  : String(n ?? 0)

const truncate = (s: string, len: number) => s.length > len ? s.slice(0, len) + '…' : s

const onImgError   = (e: Event) => { (e.target as HTMLImageElement).src = '/playlist_default.jpg' }
const onAvatarError = (e: Event) => { (e.target as HTMLImageElement).src = '/default-avatar.jpg' }

const showToast = (msg: string, type: 'success' | 'error' = 'success') => {
  toast.msg = msg; toast.type = type; toast.show = true
  setTimeout(() => { toast.show = false }, 3000)
}

// ── Actions ────────────────────────────────────────────────────────────────
const onSearch = () => { page.value = 1 }
const clearSearch = () => { keyword.value = ''; statusFilter.value = ''; page.value = 1 }

const viewDetail = (id: number) => router.push({ name: 'admin.playlistsmanager.detail', params: { id } })

const toggleVisibility = async (pl: AdminPlaylist) => {
  togglingId.value = pl.id
  try {
    await store.updateStatus(pl.id, !pl.is_public)
    showToast(`Playlist set to ${!pl.is_public ? 'public' : 'private'}`)
  } catch {
    showToast('Failed to update visibility', 'error')
  } finally {
    togglingId.value = null
  }
}

const confirmDelete = (pl: AdminPlaylist) => { deleteTarget.value = pl }

const doDelete = async () => {
  if (!deleteTarget.value) return
  deleting.value = true
  try {
    await store.deletePlaylist(deleteTarget.value.id)
    showToast('Playlist deleted')
    deleteTarget.value = null
  } catch {
    showToast('Failed to delete playlist', 'error')
  } finally {
    deleting.value = false
  }
}

// ── Lifecycle ──────────────────────────────────────────────────────────────
onMounted(() => store.fetchAll())
</script>

<style scoped>
.playlists-shell {
  padding: 28px 32px;
  min-height: 100vh;
  color: #e5e7eb;
  position: relative;
}

.bg-grid {
  position: fixed; inset: 0; z-index: 0; pointer-events: none;
  background-image: linear-gradient(rgba(255,255,255,0.015) 1px, transparent 1px),
                    linear-gradient(90deg, rgba(255,255,255,0.015) 1px, transparent 1px);
  background-size: 40px 40px;
}

/* Stats */
.stats-row {
  display: flex; gap: 16px; margin-bottom: 28px; position: relative; z-index: 1;
}
.stat-card {
  display: flex; align-items: center; gap: 14px;
  background: rgba(255,255,255,0.04);
  border: 1px solid rgba(255,255,255,0.07);
  border-radius: 14px; padding: 16px 22px; flex: 1;
}
.stat-icon {
  width: 40px; height: 40px; border-radius: 10px;
  display: flex; align-items: center; justify-content: center;
}
.stat-icon.total   { background: rgba(99,102,241,0.15); color: #818cf8; }
.stat-icon.public  { background: rgba(16,185,129,0.15); color: #34d399; }
.stat-icon.private { background: rgba(245,158,11,0.15); color: #fbbf24; }
.stat-body { display: flex; flex-direction: column; gap: 2px; }
.stat-val { font-size: 24px; font-weight: 700; color: #fff; line-height: 1; }
.stat-lbl { font-size: 12px; color: rgba(255,255,255,0.4); }

/* Header */
.page-header {
  display: flex; align-items: center; justify-content: space-between;
  margin-bottom: 20px; position: relative; z-index: 1; flex-wrap: wrap; gap: 12px;
}
.header-left { display: flex; align-items: center; gap: 12px; }
.page-title { font-size: 22px; font-weight: 700; color: #fff; margin: 0; }
.page-badge {
  background: rgba(99,102,241,0.15); color: #818cf8;
  font-size: 12px; font-weight: 600; padding: 3px 10px; border-radius: 20px;
}
.header-right { display: flex; align-items: center; gap: 10px; }

.search-wrap {
  position: relative; display: flex; align-items: center;
}
.search-ico {
  position: absolute; left: 12px; color: rgba(255,255,255,0.3); pointer-events: none;
}
.search-input {
  background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.08);
  border-radius: 10px; padding: 9px 32px 9px 36px; color: #fff; font-size: 13px;
  outline: none; width: 260px; transition: all 0.2s;
}
.search-input:focus { background: rgba(255,255,255,0.08); border-color: rgba(99,102,241,0.4); width: 320px; }
.search-input::placeholder { color: rgba(255,255,255,0.3); }
.search-clear {
  position: absolute; right: 10px; background: none; border: none;
  color: rgba(255,255,255,0.4); cursor: pointer; font-size: 12px; padding: 2px 4px;
}
.search-clear:hover { color: #fff; }

.filter-select {
  background: rgb(0, 0, 0); border: 1px solid rgba(255,255,255,0.08);
  border-radius: 10px; color: #e5e7eb; font-size: 13px; padding: 9px 14px;
  outline: none; cursor: pointer;
}

/* Table */
.table-card {
  background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07);
  border-radius: 16px; overflow: hidden; position: relative; z-index: 1;
}
.table-wrap { overflow-x: auto; }
.gtable { width: 100%; border-collapse: collapse; }
.gtable thead tr { border-bottom: 1px solid rgba(255,255,255,0.07); }
.gtable th {
  padding: 12px 16px; text-align: left; font-size: 11px; font-weight: 600;
  text-transform: uppercase; letter-spacing: 0.08em; color: rgba(255,255,255,0.35);
}
.g-row { border-bottom: 1px solid rgba(255,255,255,0.04); transition: background 0.15s; }
.g-row:hover { background: rgba(255,255,255,0.03); }
.g-row:last-child { border-bottom: none; }
.gtable td { padding: 12px 16px; font-size: 13px; vertical-align: middle; }

/* Item cell */
.item-cell { display: flex; align-items: center; gap: 12px; }
.item-cover { width: 44px; height: 44px; border-radius: 8px; overflow: hidden; flex-shrink: 0; background: rgba(255,255,255,0.05); }
.item-cover img { width: 100%; height: 100%; object-fit: cover; }
.item-meta { display: flex; flex-direction: column; gap: 2px; min-width: 0; }
.item-name { font-weight: 600; color: #fff; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 220px; }
.item-sub { font-size: 11px; color: rgba(255,255,255,0.4); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 220px; }
.item-slug { font-size: 10px; color: rgba(255,255,255,0.25); font-family: monospace; }

/* Owner */
.owner-cell { display: flex; align-items: center; gap: 8px; }
.owner-avatar { width: 30px; height: 30px; border-radius: 50%; object-fit: cover; border: 1px solid rgba(255,255,255,0.1); flex-shrink: 0; }
.owner-info { display: flex; flex-direction: column; gap: 1px; }
.owner-name { font-size: 13px; font-weight: 500; color: #e5e7eb; }
.owner-email { font-size: 11px; color: rgba(255,255,255,0.35); }
.text-muted { color: rgba(255,255,255,0.3); }

.num-val { font-size: 13px; color: rgba(255,255,255,0.7); font-variant-numeric: tabular-nums; }
.date-val { font-size: 12px; color: rgba(255,255,255,0.4); }

/* Visibility toggle */
.visibility-toggle {
  display: inline-flex; align-items: center; gap: 6px;
  padding: 4px 12px; border-radius: 20px; border: none;
  font-size: 12px; font-weight: 600; cursor: pointer; transition: all 0.2s;
}
.visibility-toggle.is-public  { background: rgba(16,185,129,0.15); color: #34d399; }
.visibility-toggle.is-private { background: rgba(255,255,255,0.07); color: rgba(255,255,255,0.5); }
.visibility-toggle:hover:not(:disabled) { filter: brightness(1.2); transform: scale(1.03); }
.visibility-toggle:disabled { opacity: 0.5; cursor: not-allowed; }
.vis-dot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }

/* Actions */
.actions { display: flex; gap: 6px; }
.act-btn {
  width: 30px; height: 30px; border-radius: 8px; border: none;
  display: flex; align-items: center; justify-content: center;
  cursor: pointer; transition: all 0.15s;
}
.act-btn.view   { color: #60a5fa; border-color: #3b82f6; background: rgba(59,130,246,0.08); }
.act-btn.delete { background: rgba(239,68,68,0.1);   color: #f87171; }
.act-btn.view:hover   { background: rgba(99,102,241,0.25); }
.act-btn.delete:hover { background: rgba(239,68,68,0.22); }

/* Empty */
.empty-row { text-align: center; padding: 60px 20px !important; }
.empty-state { display: flex; flex-direction: column; align-items: center; gap: 12px; color: rgba(255,255,255,0.25); }
.empty-state p { font-size: 14px; margin: 0; }

/* Skeleton */
.skeleton-row td { padding: 14px 16px; }
.skel { height: 14px; border-radius: 6px; background: rgba(255,255,255,0.06); animation: pulse 1.5s infinite; }
.skel-wide { width: 80%; } .skel-med { width: 60%; } .skel-sm { width: 40%; }
@keyframes pulse { 0%,100% { opacity: 0.4; } 50% { opacity: 0.8; } }

/* Pagination */
.pagination { display: flex; justify-content: center; gap: 4px; padding: 16px; }
.pg-btn {
  min-width: 32px; height: 32px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.08);
  background: rgba(255,255,255,0.04); color: rgba(255,255,255,0.6);
  font-size: 13px; cursor: pointer; transition: all 0.15s; padding: 0 8px;
}
.pg-btn:hover:not(:disabled) { background: rgba(255,255,255,0.1); color: #fff; }
.pg-btn.active { background: rgba(99,102,241,0.25); color: #818cf8; border-color: rgba(99,102,241,0.4); }
.pg-btn:disabled { opacity: 0.3; cursor: not-allowed; }

/* Modal */
.modal-backdrop {
  position: fixed; inset: 0; background: rgba(0,0,0,0.7); backdrop-filter: blur(6px);
  display: flex; align-items: center; justify-content: center; z-index: 9999;
}
.confirm-modal {
  background: #141824; border: 1px solid rgba(255,255,255,0.1); border-radius: 20px;
  width: 380px; max-width: 95vw; padding: 36px 28px 28px; text-align: center;
  box-shadow: 0 24px 80px rgba(0,0,0,0.7);
}
.confirm-icon {
  width: 64px; height: 64px; border-radius: 50%;
  background: rgba(239,68,68,0.12); border: 1px solid rgba(239,68,68,0.25);
  display: flex; align-items: center; justify-content: center;
  margin: 0 auto 20px; color: #ef4444;
}
.confirm-modal h3 { font-size: 18px; font-weight: 700; margin: 0 0 10px; color: #fff; }
.confirm-modal p { font-size: 14px; color: rgba(255,255,255,0.5); margin: 0 0 28px; line-height: 1.6; }
.confirm-modal strong { color: rgba(255,255,255,0.85); }
.confirm-actions { display: flex; gap: 10px; justify-content: center; }
.btn-cancel {
  padding: 9px 22px; border-radius: 10px; background: rgba(255,255,255,0.07);
  border: 1px solid rgba(255,255,255,0.1); color: rgba(255,255,255,0.7);
  font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s;
}
.btn-cancel:hover { background: rgba(255,255,255,0.12); color: #fff; }
.btn-delete {
  padding: 9px 24px; border-radius: 10px; background: #ef4444; border: none;
  color: #fff; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.2s;
}
.btn-delete:hover:not(:disabled) { background: #dc2626; }
.btn-delete:disabled { opacity: 0.5; cursor: not-allowed; }

/* Toast */
.toast {
  position: fixed; bottom: 28px; left: 50%; transform: translateX(-50%);
  padding: 12px 24px; border-radius: 12px; font-size: 14px; font-weight: 600;
  z-index: 99999; pointer-events: none; box-shadow: 0 8px 32px rgba(0,0,0,0.4);
}
.toast.success { background: #10b981; color: #fff; }
.toast.error   { background: #ef4444; color: #fff; }

.modal-fade-enter-active, .modal-fade-leave-active { transition: opacity 0.2s; }
.modal-fade-enter-from, .modal-fade-leave-to { opacity: 0; }
.toast-slide-enter-active, .toast-slide-leave-active { transition: all 0.25s; }
.toast-slide-enter-from, .toast-slide-leave-to { opacity: 0; transform: translateX(-50%) translateY(10px); }

@media (max-width: 768px) {
  .playlists-shell { padding: 16px; }
  .stats-row { flex-direction: column; }
  .search-input { width: 180px; }
  .search-input:focus { width: 220px; }
}
</style>

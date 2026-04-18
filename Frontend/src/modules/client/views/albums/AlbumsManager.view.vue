<template>
  <div class="albums-shell">
    <div class="bg-grid" aria-hidden="true"></div>

    <!-- Header -->
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">Albums</h1>
        <span class="page-badge">{{ filteredAlbums.length }} total</span>
      </div>
      <div class="header-right">
        <div class="search-wrap">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15" class="search-ico">
            <path fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11ZM2 9a7 7 0 1 1 12.452 4.391l3.328 3.329a.75.75 0 1 1-1.06 1.06l-3.329-3.328A7 7 0 0 1 2 9Z" clip-rule="evenodd" />
          </svg>
          <input v-model="keyword" type="text" placeholder="Search albums…" class="search-input" />
          <span v-if="keyword" class="search-clear" @click="keyword = ''">✕</span>
        </div>
        <button class="btn-add" @click="CreateAlbum">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15">
            <path d="M10.75 4.75a.75.75 0 0 0-1.5 0v4.5h-4.5a.75.75 0 0 0 0 1.5h4.5v4.5a.75.75 0 0 0 1.5 0v-4.5h4.5a.75.75 0 0 0 0-1.5h-4.5v-4.5Z" />
          </svg>
          Add album
        </button>
      </div>
    </div>

    <!-- Table card -->
    <div class="table-card">
      <div class="table-wrap">
        <table class="gtable">
          <thead>
            <tr>
              <th style="width:35%">Album</th>
              <th>Type</th>
              <th>Tracks</th>
              <th>Plays</th>
              <th>Status</th>
              <th>Release Date</th>
              <th style="width:110px">Actions</th>
            </tr>
          </thead>
          <tbody>
            <template v-if="!loading">
              <tr v-for="album in paginatedAlbums" :key="album.id" class="g-row">
                <!-- Album cell -->
                <td>
                  <div class="item-cell">
                    <div class="item-cover album-cover">
                      <img
                        :src="getFullImageUrl(album.cover_url)"
                        :alt="album.name"
                        loading="lazy"
                      />
                    </div>
                    <div class="item-meta">
                      <span class="item-name">{{ album.name }}</span>
                      <span class="item-sub" v-if="album.label">{{ album.label }}</span>
                      <span class="item-artist" v-if="album.artist">{{ album.artist.name }}</span>
                    </div>
                  </div>
                </td>

                <td>
                   <span :class="['type-badge', `type-${album.album_type || 'album'}`]">
                      {{ formatType(album.album_type) }}
                   </span>
                </td>

                <td>
                  <span class="num-val">{{ formatCompactNumber(album.total_tracks) }}</span>
                </td>

                <td>
                  <span class="num-val">{{ formatCompactNumber(album.total_plays) }}</span>
                </td>

                <td>
                  <span class="status-dot" :class="album.status">
                    <span class="dot-pulse"></span>
                    {{ capitalize(album.status) }}
                  </span>
                </td>

                <td>
                  <span class="date-val">{{ formatDate(album.release_date || album.created_at || '') }}</span>
                </td>

                <td>
                  <div class="actions">
                    <button class="act-btn edit" @click="viewUpdateAlbum(album.slug)" title="Edit">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                        <path d="m5.433 13.917 1.262-3.155A4 4 0 0 1 7.58 9.42l6.92-6.918a2.121 2.121 0 0 1 3 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 0 1-.65-.65Z" />
                        <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0 0 10 3H4.75A2.75 2.75 0 0 0 2 5.75v9.5A2.75 2.75 0 0 0 4.75 18h9.5A2.75 2.75 0 0 0 17 15.25V10a.75.75 0 0 0-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5Z" />
                      </svg>
                    </button>
                    <button class="act-btn delete" @click="deleteAlbum(album.id)" title="Delete">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                        <path fill-rule="evenodd" d="M8.75 1A2.75 2.75 0 0 0 6 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 1 0 .23 1.482l.149-.022.841 10.518A2.75 2.75 0 0 0 7.596 19h4.807a2.75 2.75 0 0 0 2.742-2.53l.841-10.52.149.023a.75.75 0 0 0 .23-1.482A41.03 41.03 0 0 0 14 4.193V3.75A2.75 2.75 0 0 0 11.25 1h-2.5ZM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4ZM8.58 7.72a.75.75 0 0 0-1.5.06l.3 7.5a.75.75 0 1 0 1.5-.06l-.3-7.5Zm4.34.06a.75.75 0 1 0-1.5-.06l-.3 7.5a.75.75 0 1 0 1.5.06l.3-7.5Z" clip-rule="evenodd" />
                      </svg>
                    </button>
                    <button class="act-btn view" @click="viewDetailAlbum(album.slug)" title="View">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                        <path d="M10 12.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z" />
                        <path fill-rule="evenodd" d="M.664 10.59a1.651 1.651 0 0 1 0-1.186A10.004 10.004 0 0 1 10 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0 1 10 17c-4.257 0-7.893-2.66-9.336-6.41ZM14 10a4 4 0 1 1-8 0 4 4 0 0 1 8 0Z" clip-rule="evenodd" />
                      </svg>
                    </button>
                  </div>
                </td>
              </tr>
            </template>
          </tbody>
        </table>

        <!-- Loading -->
        <div v-if="loading" class="state-box">
          <div class="spinner">
            <div class="sp-dot"></div>
            <div class="sp-dot"></div>
            <div class="sp-dot"></div>
          </div>
          <span class="state-text">Loading albums…</span>
        </div>

        <!-- Empty -->
        <div v-if="!loading && filteredAlbums.length === 0" class="state-box">
          <div class="empty-icon">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="40" height="40">
               <path d="M11.5 8.5c0-.828.672-1.5 1.5-1.5s1.5.672 1.5 1.5c0 .524-.269.983-.672 1.252l-.328.219v.529h-1v-.529l-.328-.219a1.501 1.501 0 0 1-.672-1.252Z" />
               <path fill-rule="evenodd" d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20Zm-1 15v-1h2v1h-2Z" clip-rule="evenodd" />
            </svg>
          </div>
          <span class="state-text">{{ keyword ? `No albums matching "${keyword}"` : 'No albums yet' }}</span>
          <button v-if="!keyword" class="btn-add-sm" @click="CreateAlbum">Add first album</button>
        </div>
      </div>

      <!-- Pagination -->
      <div v-if="!loading && filteredAlbums.length > 0" class="pagination">
        <span class="pg-info">
          {{ paginationStart }}–{{ paginationEnd }} of {{ filteredAlbums.length }}
        </span>
        <div class="pg-controls">
          <button class="pg-btn" :disabled="currentPage === 1" @click="currentPage--">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
              <path fill-rule="evenodd" d="M11.78 5.22a.75.75 0 0 1 0 1.06L8.06 10l3.72 3.72a.75.75 0 1 1-1.06 1.06l-4.25-4.25a.75.75 0 0 1 0-1.06l4.25-4.25a.75.75 0 0 1 1.06 0Z" clip-rule="evenodd" />
            </svg>
          </button>

          <div class="pg-pages">
            <button
              v-for="p in visiblePages"
              :key="p"
              class="pg-num"
              :class="{ active: p === currentPage, ellipsis: p === '…' }"
              @click="typeof p === 'number' && (currentPage = p)"
            >{{ p }}</button>
          </div>

          <button class="pg-btn" :disabled="currentPage === totalPages" @click="currentPage++">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
              <path fill-rule="evenodd" d="M8.22 5.22a.75.75 0 0 1 1.06 0l4.25 4.25a.75.75 0 0 1 0 1.06l-4.25 4.25a.75.75 0 0 1-1.06-1.06L11.94 10 8.22 6.28a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd" />
            </svg>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useAlbumStore, getFullImageUrl } from '@/modules/client/stores/albums/albumssStore'
import { useNotificationStore } from "@/store/notificationStore"
import { usePartnerStore } from '@/modules/client/stores/partners/partnersStore'
import Swal from 'sweetalert2'

const router = useRouter()
const notificationStore = useNotificationStore()
const albumStore = useAlbumStore()
const partnerStore = usePartnerStore()

const loading = ref(true)
const keyword = ref('')
const currentPage = ref(1)
const itemsPerPage = 10

const partnerId = ref<number | null>(null)

const filteredAlbums = computed(() => {
  if (!keyword.value) return albumStore.albumsByPartner
  return albumStore.albumsByPartner.filter(album =>
    album.name.toLowerCase().includes(keyword.value.toLowerCase()) ||
    (album.artist?.name && album.artist.name.toLowerCase().includes(keyword.value.toLowerCase()))
  )
})

const totalPages = computed(() => Math.ceil(filteredAlbums.value.length / itemsPerPage))
const paginationStart = computed(() => filteredAlbums.value.length === 0 ? 0 : (currentPage.value - 1) * itemsPerPage + 1)
const paginationEnd = computed(() => Math.min(currentPage.value * itemsPerPage, filteredAlbums.value.length))

const paginatedAlbums = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return filteredAlbums.value.slice(start, end)
})

// Methods
const CreateAlbum = () => router.push({ name: 'client.album.add' })
const viewDetailAlbum = (slug: string) => router.push({ name: 'client.album.detail', params: { slug } })
const viewUpdateAlbum = (slug: string) => router.push({ name: 'client.album.update', params: { slug } })

const deleteAlbum = async (id: number) => {
  const result = await Swal.fire({
    title: 'Delete Album?',
    text: 'This action cannot be undone.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Delete',
    confirmButtonColor: '#e24b4a',
    cancelButtonColor: '#334155',
    reverseButtons: true,
    background: '#0f1923',
    color: '#e8edf2',
  })

  if (!result.isConfirmed) return

  try {
    loading.value = true
    await albumStore.fetchDelete(id)

    if (partnerId.value) {
      await albumStore.fetchAlbumByPartner(partnerId.value)
    }

    notificationStore.notify('Album deleted', 'success')
  } catch (err: any) {
    notificationStore.notify('Failed to delete album', 'error')
    if (err.response?.status === 404) router.push('/404')
  } finally {
    loading.value = false
  }
}

const visiblePages = computed(() => {
  const total = totalPages.value
  const cur = currentPage.value
  if (total <= 7) return Array.from({ length: total }, (_, i) => i + 1)
  const pages: (number | string)[] = [1]
  if (cur > 3) pages.push('…')
  for (let i = Math.max(2, cur - 1); i <= Math.min(total - 1, cur + 1); i++) pages.push(i)
  if (cur < total - 2) pages.push('…')
  pages.push(total)
  return pages
})

const formatType = (type?: string): string => {
  if (!type) return 'Album'
  return type.charAt(0).toUpperCase() + type.slice(1)
}

const formatCompactNumber = (num?: number): string => {
  if (!num) return '0'
  if (num >= 1000000) return (num / 1000000).toFixed(1) + 'M'
  if (num >= 1000) return (num / 1000).toFixed(1) + 'K'
  return num.toString()
}

const capitalize = (str: string): string => str.charAt(0).toUpperCase() + str.slice(1)

const formatDate = (dateString: string): string => {
  if (!dateString) return '—'
  return new Date(dateString).toLocaleDateString('en-US', {
    month: 'short', day: 'numeric', year: 'numeric'
  })
}

watch(keyword, () => { currentPage.value = 1 })

onMounted(async () => {
  try {
    loading.value = true

    await partnerStore.fetchPartnerInfo()


    const id = partnerStore.partnerInfo?.partner?.id 
      || partnerStore.partnerInfo?.partner.id
      || partnerStore.partner?.id


    if (!id) {
      notificationStore.notify('Partner not found', 'error')
      return
    }

    partnerId.value = id

    await albumStore.fetchAlbumByPartner(id)


  } catch (error) {
    console.error('Failed to load albums:', error)
    notificationStore.notify('Failed to load albums', 'error')
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
/* ── Base ───────────────────────────────────────── */
.albums-shell {
  min-height: 100%;
  padding: 24px;
  font-family: 'DM Sans', 'Segoe UI', sans-serif;
  color: #e8edf2;
  position: relative;
}

.bg-grid {
  position: fixed;
  inset: 0;
  background-image:
    linear-gradient(rgba(0,160,255,0.025) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0,160,255,0.025) 1px, transparent 1px);
  background-size: 40px 40px;
  pointer-events: none;
  z-index: 0;
}

/* ── Header ─────────────────────────────────────── */
.page-header {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}

.header-left { display: flex; align-items: center; gap: 12px; }

.page-title {
  font-size: 26px;
  font-weight: 700;
  margin: 0;
  background: linear-gradient(90deg, #fff 30%, #00aaff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.page-badge {
  font-size: 12px;
  font-weight: 600;
  padding: 3px 10px;
  border-radius: 100px;
  background: rgba(0,170,255,0.12);
  border: 1px solid rgba(0,170,255,0.3);
  color: #00aaff;
}

.header-right { display: flex; align-items: center; gap: 10px; }

/* Search */
.search-wrap {
  position: relative;
  display: flex;
  align-items: center;
}
.search-ico {
  position: absolute;
  left: 12px;
  color: rgba(255,255,255,0.3);
  pointer-events: none;
}
.search-input {
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 9px;
  padding: 9px 34px;
  color: #fff;
  font-size: 13px;
  font-family: inherit;
  width: 220px;
  transition: all 0.2s;
}
.search-input:focus { outline: none; border-color: rgba(0,170,255,0.5); background: rgba(255,255,255,0.07); }
.search-input::placeholder { color: rgba(255,255,255,0.2); }
.search-clear {
  position: absolute;
  right: 10px;
  color: rgba(255,255,255,0.3);
  cursor: pointer;
  font-size: 11px;
}
.search-clear:hover { color: #fff; }

/* Add button */
.btn-add {
  display: flex;
  align-items: center;
  gap: 7px;
  background: #00aaff;
  color: #000;
  border: none;
  border-radius: 9px;
  padding: 9px 18px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  font-family: inherit;
  white-space: nowrap;
}
.btn-add:hover { background: #33bbff; transform: translateY(-1px); box-shadow: 0 5px 16px rgba(0,170,255,0.35); }

/* ── Table card ─────────────────────────────────── */
.table-card {
  position: relative;
  z-index: 1;
  background: rgba(255,255,255,0.03);
  border: 1px solid rgba(255,255,255,0.07);
  border-radius: 16px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.table-wrap { overflow-x: auto; flex: 1; }

.gtable {
  width: 100%;
  border-collapse: collapse;
  min-width: 800px;
}

.gtable thead tr {
  background: rgba(0,0,0,0.25);
}

.gtable th {
  padding: 13px 16px;
  text-align: left;
  font-size: 11px;
  font-weight: 600;
  color: rgba(255,255,255,0.35);
  text-transform: uppercase;
  letter-spacing: 0.06em;
  white-space: nowrap;
  border-bottom: 1px solid rgba(255,255,255,0.06);
}

.gtable td {
  padding: 13px 16px;
  border-bottom: 1px solid rgba(255,255,255,0.04);
  vertical-align: middle;
  font-size: 13px;
}

.g-row { transition: background 0.15s; }
.g-row:hover { background: rgba(255,255,255,0.03); }
.g-row:last-child td { border-bottom: none; }

/* ── Item cell ──────────────────────────────────── */
.item-cell { display: flex; align-items: center; gap: 12px; }

.item-cover {
  width: 44px;
  height: 44px;
  overflow: hidden;
  border: 1px solid rgba(255,255,255,0.1);
  flex-shrink: 0;
}
.album-cover { border-radius: 6px; }
.item-cover img { width: 100%; height: 100%; object-fit: cover; display: block; }

.item-meta { display: flex; flex-direction: column; gap: 2px; min-width: 0; }

.item-name {
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 250px;
}

.item-sub, .item-artist {
  font-size: 11px;
  color: rgba(255,255,255,0.35);
}

/* ── Badges & Values ────────────────────────────── */
.type-badge {
    padding: 3px 10px;
    border-radius: 6px;
    font-size: 10px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.03em;
    background: rgba(255,255,255,0.05);
    color: rgba(255,255,255,0.5);
    border: 1px solid rgba(255,255,255,0.1);
}
.type-album  { color: #00aaff; border-color: rgba(0,170,255,0.3); background: rgba(0,170,255,0.1); }
.type-single { color: #bb6bd9; border-color: rgba(187,107,217,0.3); background: rgba(187,107,217,0.1); }
.type-ep     { color: #00ffaa; border-color: rgba(0,255,170,0.3); background: rgba(0,255,170,0.1); }

.num-val { font-size: 13px; color: rgba(255,255,255,0.7); font-variant-numeric: tabular-nums; }
.date-val { font-size: 12px; color: rgba(255,255,255,0.4); white-space: nowrap; }

/* Status Dot */
.status-dot {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 11px;
  font-weight: 600;
  padding: 4px 12px;
  border-radius: 100px;
  text-transform: capitalize;
}
.status-dot.published { background: rgba(0,200,120,0.1); border: 1px solid rgba(0,200,120,0.25); color: #00c87a; }
.status-dot.draft     { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.15); color: rgba(255,255,255,0.4); }
.status-dot.pending   { background: rgba(250,200,0,0.08); border: 1px solid rgba(250,200,0,0.2); color: #fac800; }

.dot-pulse { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
.status-dot.published .dot-pulse { animation: pulse-green 2s infinite; }

@keyframes pulse-green { 0%, 100% { opacity: 1; } 50% { opacity: 0.4; } }

/* Actions */
.actions { display: flex; gap: 6px; }
.act-btn {
  width: 30px;
  height: 30px;
  border-radius: 7px;
  border: 1px solid rgba(255,255,255,0.08);
  background: rgba(255,255,255,0.04);
  color: rgba(255,255,255,0.5);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.15s;
}
.act-btn:hover { transform: translateY(-1px); }
.act-btn.view:hover  { background: rgba(0,170,255,0.15); border-color: rgba(0,170,255,0.4); color: #00aaff; }
.act-btn.edit:hover  { background: rgba(250,200,0,0.12); border-color: rgba(250,200,0,0.35); color: #fac800; }
.act-btn.delete:hover { background: rgba(226,75,74,0.15); border-color: rgba(226,75,74,0.4); color: #e24b4a; }

/* State boxes */
.state-box { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 60px 24px; gap: 12px; }
.spinner { display: flex; gap: 6px; }
.sp-dot { width: 9px; height: 9px; border-radius: 50%; background: #00aaff; animation: bounce 1.4s infinite ease-in-out both; }
.sp-dot:nth-child(1) { animation-delay: -0.32s; }
.sp-dot:nth-child(2) { animation-delay: -0.16s; }
@keyframes bounce { 0%, 80%, 100% { transform: scale(0.3); opacity: 0.4; } 40% { transform: scale(1); opacity: 1; } }
.empty-icon { color: rgba(255,255,255,0.1); }
.state-text { font-size: 14px; color: rgba(255,255,255,0.3); }
.btn-add-sm { margin-top: 4px; background: rgba(0,170,255,0.1); border: 1px solid rgba(0,170,255,0.3); color: #00aaff; border-radius: 8px; padding: 8px 18px; font-size: 13px; font-weight: 500; cursor: pointer; transition: all 0.15s; font-family: inherit; }
.btn-add-sm:hover { background: rgba(0,170,255,0.2); }

/* Pagination */
.pagination { display: flex; align-items: center; justify-content: space-between; padding: 14px 20px; border-top: 1px solid rgba(255,255,255,0.05); }
.pg-info { font-size: 12px; color: rgba(255,255,255,0.3); }
.pg-controls { display: flex; align-items: center; gap: 4px; }
.pg-btn { width: 30px; height: 30px; border-radius: 7px; border: 1px solid rgba(255,255,255,0.08); background: rgba(255,255,255,0.04); color: rgba(255,255,255,0.5); cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.15s; }
.pg-btn:hover:not(:disabled) { background: rgba(255,255,255,0.1); color: #fff; }
.pg-btn:disabled { opacity: 0.3; cursor: not-allowed; }
.pg-pages { display: flex; gap: 3px; }
.pg-num { min-width: 30px; height: 30px; border-radius: 7px; border: 1px solid transparent; background: transparent; color: rgba(255,255,255,0.4); font-size: 13px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.15s; padding: 0 6px; font-family: inherit; }
.pg-num:hover:not(.ellipsis) { background: rgba(255,255,255,0.07); color: #fff; }
.pg-num.active { background: #00aaff; color: #000; font-weight: 600; border-color: #00aaff; }
.pg-num.ellipsis { cursor: default; color: rgba(255,255,255,0.2); }

@media (max-width: 640px) {
  .albums-shell { padding: 16px; }
  .page-header { flex-direction: column; align-items: flex-start; gap: 12px; }
  .header-right { width: 100%; }
  .search-input { width: 100%; }
  .search-wrap { flex: 1; }
  .pg-pages { display: none; }
}
</style>
<template>
  <div class="artists-shell">
    <div class="bg-grid" aria-hidden="true"></div>

    <!-- Header -->
    <div class="page-header">
      <div class="header-left">
        <button class="back-btn-sm" @click="router.back()">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
            <path fill-rule="evenodd" d="M7.793 2.232a.75.75 0 0 1-.025 1.06L3.622 7.25h10.003a5.375 5.375 0 0 1 0 10.75H10.75a.75.75 0 0 1 0-1.5h2.875a3.875 3.875 0 0 0 0-7.75H3.622l4.146 3.957a.75.75 0 0 1-1.036 1.085l-5.5-5.25a.75.75 0 0 1 0-1.085l5.5-5.25a.75.75 0 0 1 1.06.025Z" clip-rule="evenodd" />
          </svg>
        </button>
        <h1 class="page-title">Artists</h1>
        <span class="page-badge">{{ filteredArtists.length }} total</span>
      </div>
      <div class="header-right">
        <div class="search-wrap">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15" class="search-ico">
            <path fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11ZM2 9a7 7 0 1 1 12.452 4.391l3.328 3.329a.75.75 0 1 1-1.06 1.06l-3.329-3.328A7 7 0 0 1 2 9Z" clip-rule="evenodd" />
          </svg>
          <input v-model="keyword" type="text" placeholder="Search artists…" class="search-input" />
          <span v-if="keyword" class="search-clear" @click="keyword = ''">✕</span>
        </div>
        <button class="btn-add" @click="CreateArtist">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15">
            <path d="M10.75 4.75a.75.75 0 0 0-1.5 0v4.5h-4.5a.75.75 0 0 0 0 1.5h4.5v4.5a.75.75 0 0 0 1.5 0v-4.5h4.5a.75.75 0 0 0 0-1.5h-4.5v-4.5Z" />
          </svg>
          Add artist
        </button>
      </div>
    </div>

    <!-- Table card -->
    <div class="table-card">
      <div class="table-wrap">
        <table class="gtable">
          <thead>
            <tr>
              <th style="width:30%">Artist</th>
              <th>Followers</th>
              <th>Songs</th>
              <th>Country</th>
              <th>Status</th>
              <th>Join Date</th>
              <th>Social</th>
              <th style="width:110px">Actions</th>
            </tr>
          </thead>
          <tbody>
            <template v-if="!loading">
              <tr v-for="artist in paginatedArtists" :key="artist.id" class="g-row">
                <!-- Artist cell -->
                <td>
                  <div class="item-cell">
                    <div class="item-cover artist-avatar-wrap">
                      <img
                        :src="getFullImageUrl(artist.avatar_url)"
                        :alt="artist.name"
                        loading="lazy"
                      />
                    </div>
                    <div class="item-meta">
                      <span class="item-name">{{ artist.name }}</span>
                    </div>
                  </div>
                </td>

                <td>
                  <span class="num-val">{{ formatCompactNumber(artist.total_followers) }}</span>
                </td>

                <td>
                  <span class="num-val">{{ formatCompactNumber(artist.total_songs) }}</span>
                </td>

                <td>
                  <span class="country-tag" v-if="artist.country">
                    {{ artist.country }}
                  </span>
                  <span v-else class="date-val">—</span>
                </td>

                <td>
                  <span class="status-dot" :class="artist.status">
                    <span class="dot-pulse"></span>
                    {{ capitalize(artist.status) }}
                  </span>
                </td>

                <td>
                  <span class="date-val">{{ formatDate(artist.created_at || '') }}</span>
                </td>

                <td>
                  <div class="social-links">
                      <a v-if="artist.facebook_url" :href="artist.facebook_url" target="_blank" class="soc-icon fb" title="Facebook">
                        <svg viewBox="0 0 24 24" fill="currentColor" width="14" height="14"><path d="M24 12c0-6.627-5.373-12-12-12S0 5.373 0 12c0 5.99 4.388 10.954 10.125 11.854V15.47H7.078v-3.47h3.047V9.356c0-3.007 1.792-4.688 4.533-4.688 1.312 0 2.686.234 2.686.234v2.953H15.83c-1.49 0-1.955.925-1.955 1.874V12h3.328l-.532 3.469h-2.796v8.385C19.612 22.954 24 17.99 24 12z"/></svg>
                      </a>
                      <a v-if="artist.instagram_url" :href="artist.instagram_url" target="_blank" class="soc-icon ig" title="Instagram">
                        <svg viewBox="0 0 24 24" fill="currentColor" width="14" height="14"><path d="M12 2.163c3.204 0 3.584.012 4.85.07 1.188.054 1.98.257 2.675.545.73.284 1.334.676 1.928 1.27.594.594.986 1.198 1.27 1.928.288.695.49 1.487.545 2.675.058 1.266.07 1.646.07 4.85s-.012 3.584-.07 4.85c-.054 1.188-.257 1.98-.545 2.675-.284.73-.676 1.334-1.27 1.928-.594.594-1.198.986-1.928 1.27-.695.288-1.487.49-2.675.545-1.266.058-1.646.07-4.85.07s-3.584-.012-4.85-.07c-1.188-.054-1.98-.257-2.675-.545-.73-.284-1.334-.676-1.928-1.27-.594-.594-.986-1.198-1.27-1.928-.288-.695-.49-1.487-.545-2.675-.058-1.266-.07-1.646-.07-4.85s.012-3.584.07-4.85c.054-1.188.257-1.98.545-2.675.284-.73.676-1.334 1.27-1.928.594-.594 1.198-.986 1.928-1.27.695-.288 1.487-.49 2.675-.545 1.266-.058 1.646-.07 4.85-.07zM12 0C8.741 0 8.332.014 7.052.072c-1.267.058-2.147.283-2.912.603-.79.33-1.466.78-2.124 1.437-.657.658-1.107 1.334-1.437 2.124-.32.765-.545 1.645-.603 2.912C.014 8.332 0 8.741 0 12s.014 3.668.072 4.948c.058 1.267.283 2.147.603 2.912.33.79.78 1.466 1.437 2.124.658.657 1.334 1.107 2.124 1.437.765.32 1.645.545 2.912.603C8.332 23.986 8.741 24 12 24s3.668-.014 4.948-.072c1.267-.058 2.147-.283 2.912-.603.79-.33 1.466-.78 2.124-1.437.657-.658 1.107-1.334 1.437-2.124.32-.765.545-1.645.603-2.912.058-1.28.072-1.689.072-4.948s-.014-3.668-.072-4.948c-.058-1.267-.283-2.147-.603-2.912-.33-.79-.78-1.466-1.437-2.124-.658-.657-1.334-1.107-2.124-1.437-.765-.32-1.645-.545-2.912-.603C15.668.014 15.259 0 12 0z"/></svg>
                      </a>
                      <a v-if="artist.twitter_url" :href="artist.twitter_url" target="_blank" class="soc-icon tw" title="Twitter/X">
                        <svg viewBox="0 0 24 24" fill="currentColor" width="14" height="14"><path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/></svg>
                      </a>
                  </div>
                </td>

                <td>
                  <div class="actions">
                    <button class="act-btn edit" @click="viewUpdateArtist(artist.id)" title="Edit">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                        <path d="m5.433 13.917 1.262-3.155A4 4 0 0 1 7.58 9.42l6.92-6.918a2.121 2.121 0 0 1 3 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 0 1-.65-.65Z" />
                        <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0 0 10 3H4.75A2.75 2.75 0 0 0 2 5.75v9.5A2.75 2.75 0 0 0 4.75 18h9.5A2.75 2.75 0 0 0 17 15.25V10a.75.75 0 0 0-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5Z" />
                      </svg>
                    </button>
                    <button class="act-btn delete" @click="deleteArtist(artist.id)" title="Delete">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                        <path fill-rule="evenodd" d="M8.75 1A2.75 2.75 0 0 0 6 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 1 0 .23 1.482l.149-.022.841 10.518A2.75 2.75 0 0 0 7.596 19h4.807a2.75 2.75 0 0 0 2.742-2.53l.841-10.52.149.023a.75.75 0 0 0 .23-1.482A41.03 41.03 0 0 0 14 4.193V3.75A2.75 2.75 0 0 0 11.25 1h-2.5ZM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4ZM8.58 7.72a.75.75 0 0 0-1.5.06l.3 7.5a.75.75 0 1 0 1.5-.06l-.3-7.5Zm4.34.06a.75.75 0 1 0-1.5-.06l-.3 7.5a.75.75 0 1 0 1.5.06l.3-7.5Z" clip-rule="evenodd" />
                      </svg>
                    </button>
                    <button class="act-btn view" @click="viewDetailArtist(artist.id)" title="View">
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
          <span class="state-text">Loading artists…</span>
        </div>

        <!-- Empty -->
        <div v-if="!loading && filteredArtists.length === 0" class="state-box">
          <div class="empty-icon">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="40" height="40">
               <path d="M15.75 6a3.75 3.75 0 1 1-7.5 0 3.75 3.75 0 0 1 7.5 0ZM4.501 20.118a7.5 7.5 0 0 1 14.998 0A17.933 17.933 0 0 1 12 21.75c-2.676 0-5.216-.584-7.499-1.632Z" />
            </svg>
          </div>
          <span class="state-text">{{ keyword ? `No artists matching "${keyword}"` : 'No artists yet' }}</span>
          <button v-if="!keyword" class="btn-add-sm" @click="CreateArtist">Add first artist</button>
        </div>
      </div>

      <!-- Pagination -->
      <div v-if="!loading && filteredArtists.length > 0" class="pagination">
        <span class="pg-info">
          {{ paginationStart }}–{{ paginationEnd }} of {{ filteredArtists.length }}
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
import { ref, computed, watch, onMounted } from 'vue'
import { storeToRefs } from 'pinia'
import router from '@/modules/router'
import Swal from 'sweetalert2'
import { useNotificationStore } from '@/store/notificationStore'
import { useArtistStore, getFullImageUrl } from '@/modules/admin/stores/artists/artistsStore'

const keyword = ref('')
const currentPage = ref(1)
const itemsPerPage = 10

const notificationStore = useNotificationStore()
const artistStore = useArtistStore()
const { artists, loading } = storeToRefs(artistStore)

watch(keyword, () => { currentPage.value = 1 })

const filteredArtists = computed(() => {
  if (!keyword.value.trim()) return artists.value
  const k = keyword.value.toLowerCase()
  return artists.value.filter((a: any) => 
    a.name?.toLowerCase().includes(k) || 
    a.country?.toLowerCase().includes(k)
  )
})

const totalPages = computed(() => Math.max(1, Math.ceil(filteredArtists.value.length / itemsPerPage)))
const paginationStart = computed(() => filteredArtists.value.length === 0 ? 0 : (currentPage.value - 1) * itemsPerPage + 1)
const paginationEnd = computed(() => Math.min(currentPage.value * itemsPerPage, filteredArtists.value.length))
const paginatedArtists = computed(() => {
  const s = (currentPage.value - 1) * itemsPerPage
  return filteredArtists.value.slice(s, s + itemsPerPage)
})

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

const formatCompactNumber = (num: number | null | undefined) => {
  if (!num) return '0'
  return new Intl.NumberFormat('en', { notation: 'compact', maximumFractionDigits: 1 }).format(num)
}

const formatDate = (d: string) => {
  if (!d) return '—'
  return new Date(d).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })
}

const capitalize = (s?: string) => s ? s.charAt(0).toUpperCase() + s.slice(1) : ''

const CreateArtist = () => router.push({ name: 'admin.artistsmanager.add' })
const viewDetailArtist = (id: number) => router.push({ name: 'admin.artistsmanager.detail', params: { id } })
const viewUpdateArtist = (id: number) => router.push({ name: 'admin.artistsmanager.update', params: { id } })

const deleteArtist = async (id: number) => {
  const result = await Swal.fire({
    title: 'Delete Artist?',
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
    await artistStore.fetchDelete(id)
    await artistStore.fetchArtists()
    notificationStore.notify('Artist deleted', 'success')
  } catch (err: any) {
    notificationStore.notify('Failed to delete artist', 'error')
    if (err.response?.status === 404) router.push('/404')
  } finally {
    loading.value = false
  }
}

onMounted(() => artistStore.fetchArtists())
</script>

<style scoped>
/* ── Base ───────────────────────────────────────── */
.artists-shell {
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

.back-btn-sm {
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.5);
  width: 32px;
  height: 32px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s;
}
.back-btn-sm:hover { background: rgba(255,255,255,0.1); color: #fff; }

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
  min-width: 900px;
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
  width: 40px;
  height: 40px;
  overflow: hidden;
  border: 1px solid rgba(255,255,255,0.1);
  flex-shrink: 0;
}
.artist-avatar-wrap { border-radius: 50%; }
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

/* ── Social Links ───────────────────────────────── */
.social-links { display: flex; gap: 6px; }
.soc-icon {
  width: 26px;
  height: 26px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255,255,255,0.05);
  color: rgba(255,255,255,0.4);
  transition: all 0.2s;
}
.soc-icon:hover { color: #fff; transform: translateY(-2px); }
.soc-icon.fb:hover { background: #1877f2; }
.soc-icon.ig:hover { background: linear-gradient(45deg, #f09433 0%, #e6683c 25%, #dc2743 50%, #cc2366 75%, #bc1888 100%); }
.soc-icon.tw:hover { background: #000; }

/* ── Badges & Values ────────────────────────────── */
.country-tag {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 4px;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.6);
  font-size: 11px;
  font-weight: 500;
}

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
.status-dot.active    { background: rgba(0,200,120,0.1); border: 1px solid rgba(0,200,120,0.25); color: #00c87a; }
.status-dot.inactive  { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.15); color: rgba(255,255,255,0.4); }
.status-dot.blocked   { background: rgba(255,100,100,0.1); border: 1px solid rgba(255,100,100,0.2); color: #ff7070; }

.dot-pulse { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
.status-dot.active .dot-pulse { animation: pulse-green 2s infinite; }

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
.act-btn.view:hover  { bcolor: #10b981; border-color: #10b981; background: rgba(16, 185, 129, 0.05); }
.act-btn.edit:hover  { color: #3b82f6; border-color: #3b82f6; background: rgba(59, 130, 246, 0.05);  }
.act-btn.delete:hover { color: #ef4444; border-color: #ef4444; background: rgba(239, 68, 68, 0.05); }

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

@media (max-width: 768px) {
  .artists-shell { padding: 16px; }
  .page-header { flex-direction: column; align-items: flex-start; gap: 12px; }
  .header-right { width: 100%; }
  .search-input { width: 100%; }
  .search-wrap { flex: 1; }
  .pg-pages { display: none; }
}
</style>
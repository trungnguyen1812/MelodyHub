<template>
  <div class="genres-shell">
    <div class="bg-grid" aria-hidden="true"></div>

    <!-- Header -->
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">Genres</h1>
        <span class="page-badge">{{ filteredGenres.length }} total</span>
      </div>
      <div class="header-right">
        <div class="search-wrap">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15" class="search-ico">
            <path fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11ZM2 9a7 7 0 1 1 12.452 4.391l3.328 3.329a.75.75 0 1 1-1.06 1.06l-3.329-3.328A7 7 0 0 1 2 9Z" clip-rule="evenodd" />
          </svg>
          <input v-model="keyword" type="text" placeholder="Search genres…" class="search-input" />
          <span v-if="keyword" class="search-clear" @click="keyword = ''">✕</span>
        </div>
        <button class="btn-add" @click="CreateGenre">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15">
            <path d="M10.75 4.75a.75.75 0 0 0-1.5 0v4.5h-4.5a.75.75 0 0 0 0 1.5h4.5v4.5a.75.75 0 0 0 1.5 0v-4.5h4.5a.75.75 0 0 0 0-1.5h-4.5v-4.5Z" />
          </svg>
          Add genre
        </button>
      </div>
    </div>

    <!-- Table card -->
    <div class="table-card">
      <div class="table-wrap">
        <table class="gtable">
          <thead>
            <tr>
              <th style="width:40%">Genre</th>
              <th>Songs</th>
              <th>Order</th>
              <th>Status</th>
              <th>Created</th>
              <th style="width:110px">Actions</th>
            </tr>
          </thead>
          <tbody>
            <template v-if="!loading">
              <tr v-for="genre in paginatedGenres" :key="genre.id" class="g-row">
                <!-- Genre cell -->
                <td>
                  <div class="genre-cell">
                    <div class="genre-cover" :style="{ borderColor: genre.color ? genre.color + '55' : 'rgba(255,255,255,0.1)' }">
                      <img
                        v-if="getFullImageUrl(genre.cover_url)"
                        :src="getFullImageUrl(genre.cover_url)"
                        :alt="genre.name"
                      />
                      <div v-else class="cover-fallback" :style="{ background: genre.color ? genre.color + '22' : 'rgba(255,255,255,0.05)' }">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16" :style="{ color: genre.color || 'rgba(255,255,255,0.2)' }">
                          <path fill-rule="evenodd" d="M17.721 1.599a.75.75 0 0 1 .279.584v11.29a2.25 2.25 0 0 1-1.774 2.198l-2.041.442a2.216 2.216 0 0 1-.938-4.333l2.662-.576a.75.75 0 0 0 .591-.734V6.112l-8 1.73v7.684a2.25 2.25 0 0 1-1.774 2.198l-2.042.44a2.216 2.216 0 0 1-.935-4.332l2.662-.576a.75.75 0 0 0 .589-.734V5.032a.75.75 0 0 1 .591-.733l9.5-2.054a.75.75 0 0 1 .63.354Z" clip-rule="evenodd" />
                        </svg>
                      </div>
                    </div>
                    <div class="genre-meta">
                      <div class="genre-name-row">
                        <div v-if="genre.color" class="color-dot" :style="{ background: genre.color }"></div>
                        <span class="genre-name">{{ genre.name }}</span>
                        <span v-if="genre.parent_id" class="sub-badge">sub</span>
                      </div>
                      <span class="genre-slug">/{{ genre.slug }}</span>
                    </div>
                  </div>
                </td>

                <td>
                  <span class="num-val">{{ formatCompactNumber(genre.total_songs) }}</span>
                </td>

                <td>
                  <span class="order-pill">#{{ genre.order ?? 0 }}</span>
                </td>

                <td>
                  <span class="status-dot" :class="genre.is_active ? 'active' : 'inactive'">
                    <span class="dot-pulse"></span>
                    {{ genre.is_active ? 'Active' : 'Inactive' }}
                  </span>
                </td>

                <td>
                  <span class="date-val">{{ formatDate(genre.created_at ?? '') }}</span>
                </td>

                <td>
                  <div class="actions">
                    <button class="act-btn edit" @click="viewUpdateGenre(genre.id)" title="Edit">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                        <path d="m5.433 13.917 1.262-3.155A4 4 0 0 1 7.58 9.42l6.92-6.918a2.121 2.121 0 0 1 3 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 0 1-.65-.65Z" />
                        <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0 0 10 3H4.75A2.75 2.75 0 0 0 2 5.75v9.5A2.75 2.75 0 0 0 4.75 18h9.5A2.75 2.75 0 0 0 17 15.25V10a.75.75 0 0 0-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5Z" />
                      </svg>
                    </button>
                    <button class="act-btn delete" @click="deleteGenre(genre.id)" title="Delete">
                      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                        <path fill-rule="evenodd" d="M8.75 1A2.75 2.75 0 0 0 6 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 1 0 .23 1.482l.149-.022.841 10.518A2.75 2.75 0 0 0 7.596 19h4.807a2.75 2.75 0 0 0 2.742-2.53l.841-10.52.149.023a.75.75 0 0 0 .23-1.482A41.03 41.03 0 0 0 14 4.193V3.75A2.75 2.75 0 0 0 11.25 1h-2.5ZM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4ZM8.58 7.72a.75.75 0 0 0-1.5.06l.3 7.5a.75.75 0 1 0 1.5-.06l-.3-7.5Zm4.34.06a.75.75 0 1 0-1.5-.06l-.3 7.5a.75.75 0 1 0 1.5.06l.3-7.5Z" clip-rule="evenodd" />
                      </svg>
                    </button>
                    <button class="act-btn view" @click="viewDetailGenre(genre.id)" title="View">
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
          <span class="state-text">Loading genres…</span>
        </div>

        <!-- Empty -->
        <div v-if="!loading && filteredGenres.length === 0" class="state-box">
          <div class="empty-icon">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="40" height="40">
              <path fill-rule="evenodd" d="M19.952 1.651a.75.75 0 0 1 .298.599V16.303a3 3 0 0 1-2.176 2.884l-1.32.377a2.553 2.553 0 1 1-1.403-4.909l2.311-.66a1.5 1.5 0 0 0 1.088-1.442V6.994l-9 2.572V21a3 3 0 0 1-2.176 2.884l-1.32.377a2.553 2.553 0 1 1-1.402-4.909l2.31-.66A1.5 1.5 0 0 0 8.25 17.25V5.251a.75.75 0 0 1 .544-.721l10.5-3a.75.75 0 0 1 .658.121Z" clip-rule="evenodd" />
            </svg>
          </div>
          <span class="state-text">{{ keyword ? `No genres matching "${keyword}"` : 'No genres yet' }}</span>
          <button v-if="!keyword" class="btn-add-sm" @click="CreateGenre">Add first genre</button>
        </div>
      </div>

      <!-- Pagination -->
      <div v-if="!loading && filteredGenres.length > 0" class="pagination">
        <span class="pg-info">
          {{ paginationStart }}–{{ paginationEnd }} of {{ filteredGenres.length }}
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
import { useGenreStore, getFullImageUrl } from '@/modules/admin/stores/genres/genresStore'

const keyword = ref('')
const currentPage = ref(1)
const itemsPerPage = 10

const notificationStore = useNotificationStore()
const genreStore = useGenreStore()
const { genres, loading } = storeToRefs(genreStore)

watch(keyword, () => { currentPage.value = 1 })

const filteredGenres = computed(() => {
  if (!keyword.value.trim()) return genres.value
  const k = keyword.value.toLowerCase()
  return genres.value.filter((g: any) => g.name?.toLowerCase().includes(k) || g.slug?.toLowerCase().includes(k))
})

const totalPages = computed(() => Math.max(1, Math.ceil(filteredGenres.value.length / itemsPerPage)))
const paginationStart = computed(() => filteredGenres.value.length === 0 ? 0 : (currentPage.value - 1) * itemsPerPage + 1)
const paginationEnd = computed(() => Math.min(currentPage.value * itemsPerPage, filteredGenres.value.length))
const paginatedGenres = computed(() => {
  const s = (currentPage.value - 1) * itemsPerPage
  return filteredGenres.value.slice(s, s + itemsPerPage)
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

const formatCompactNumber = (num: number | null) => {
  if (!num) return '0'
  return new Intl.NumberFormat('en', { notation: 'compact', maximumFractionDigits: 1 }).format(num)
}

const formatDate = (d: string) => {
  if (!d) return '—'
  return new Date(d).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })
}

const CreateGenre = () => router.push({ name: 'admin.genresmanager.add' })
const viewDetailGenre = (id: number) => router.push({ name: 'admin.genresmanager.detail', params: { id } })
const viewUpdateGenre = (id: number) => router.push({ name: 'admin.genresmanager.update', params: { id } })

const deleteGenre = async (id: number) => {
  const result = await Swal.fire({
    title: 'Delete genre?',
    text: 'This action cannot be undone.',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Delete',
    cancelButtonText: 'Cancel',
    confirmButtonColor: '#e24b4a',
    cancelButtonColor: '#334155',
    reverseButtons: true,
    background: '#0f1923',
    color: '#e8edf2',
  })
  if (!result.isConfirmed) return
  try {
    loading.value = true
    await genreStore.fetchDelete(id)
    await genreStore.fetchGenres()
    notificationStore.notify('Genre deleted', 'success')
  } catch (err: any) {
    notificationStore.notify('Failed to delete genre', 'error')
    if (err.response?.status === 404) router.push('/404')
  } finally {
    loading.value = false
  }
}

onMounted(() => genreStore.fetchGenres())
</script>

<style scoped>
/* ── Base ───────────────────────────────────────── */
.genres-shell {
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
  min-width: 640px;
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

/* ── Genre cell ─────────────────────────────────── */
.genre-cell { display: flex; align-items: center; gap: 12px; }

.genre-cover {
  width: 42px;
  height: 42px;
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid rgba(255,255,255,0.1);
  flex-shrink: 0;
  transition: border-color 0.3s;
}
.genre-cover img { width: 100%; height: 100%; object-fit: cover; display: block; }

.cover-fallback {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.genre-meta { display: flex; flex-direction: column; gap: 2px; min-width: 0; }

.genre-name-row { display: flex; align-items: center; gap: 6px; }

.color-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  flex-shrink: 0;
}

.genre-name {
  font-size: 14px;
  font-weight: 500;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 200px;
}

.sub-badge {
  font-size: 10px;
  font-weight: 600;
  padding: 1px 6px;
  border-radius: 4px;
  background: rgba(155,81,224,0.15);
  border: 1px solid rgba(155,81,224,0.3);
  color: #bb6bd9;
  flex-shrink: 0;
}

.genre-slug {
  font-size: 11px;
  color: rgba(255,255,255,0.3);
  font-family: 'DM Mono', monospace;
}

/* ── Cells ──────────────────────────────────────── */
.num-val { font-size: 13px; color: rgba(255,255,255,0.7); font-variant-numeric: tabular-nums; }

.order-pill {
  display: inline-block;
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 6px;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.5);
  font-variant-numeric: tabular-nums;
}

.date-val { font-size: 12px; color: rgba(255,255,255,0.4); white-space: nowrap; }

/* Status */
.status-dot {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  font-weight: 500;
  padding: 4px 10px;
  border-radius: 100px;
}
.status-dot.active {
  background: rgba(0,200,120,0.1);
  border: 1px solid rgba(0,200,120,0.25);
  color: #00c87a;
}
.status-dot.inactive {
  background: rgba(255,100,100,0.08);
  border: 1px solid rgba(255,100,100,0.2);
  color: #ff7070;
}

.dot-pulse {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  flex-shrink: 0;
}
.status-dot.active .dot-pulse {
  background: #00c87a;
  animation: pulse-green 2s infinite;
}
.status-dot.inactive .dot-pulse { background: #ff7070; }

@keyframes pulse-green {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.4; }
}

/* ── Action buttons ─────────────────────────────── */
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

/* ── State boxes ────────────────────────────────── */
.state-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 24px;
  gap: 12px;
}

.spinner { display: flex; gap: 6px; }
.sp-dot {
  width: 9px;
  height: 9px;
  border-radius: 50%;
  background: #00aaff;
  animation: bounce 1.4s infinite ease-in-out both;
}
.sp-dot:nth-child(1) { animation-delay: -0.32s; }
.sp-dot:nth-child(2) { animation-delay: -0.16s; }
@keyframes bounce {
  0%, 80%, 100% { transform: scale(0.3); opacity: 0.4; }
  40% { transform: scale(1); opacity: 1; }
}

.empty-icon { color: rgba(255,255,255,0.1); }
.state-text { font-size: 14px; color: rgba(255,255,255,0.3); }
.btn-add-sm {
  margin-top: 4px;
  background: rgba(0,170,255,0.1);
  border: 1px solid rgba(0,170,255,0.3);
  color: #00aaff;
  border-radius: 8px;
  padding: 8px 18px;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.15s;
  font-family: inherit;
}
.btn-add-sm:hover { background: rgba(0,170,255,0.2); }

/* ── Pagination ─────────────────────────────────── */
.pagination {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 20px;
  border-top: 1px solid rgba(255,255,255,0.05);
}

.pg-info { font-size: 12px; color: rgba(255,255,255,0.3); }

.pg-controls { display: flex; align-items: center; gap: 4px; }

.pg-btn {
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
.pg-btn:hover:not(:disabled) { background: rgba(255,255,255,0.1); color: #fff; }
.pg-btn:disabled { opacity: 0.3; cursor: not-allowed; }

.pg-pages { display: flex; gap: 3px; }

.pg-num {
  min-width: 30px;
  height: 30px;
  border-radius: 7px;
  border: 1px solid transparent;
  background: transparent;
  color: rgba(255,255,255,0.4);
  font-size: 13px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.15s;
  padding: 0 6px;
  font-family: inherit;
}
.pg-num:hover:not(.ellipsis) { background: rgba(255,255,255,0.07); color: #fff; }
.pg-num.active { background: #00aaff; color: #000; font-weight: 600; border-color: #00aaff; }
.pg-num.ellipsis { cursor: default; color: rgba(255,255,255,0.2); }

/* ── Responsive ─────────────────────────────────── */
@media (max-width: 640px) {
  .genres-shell { padding: 16px; }
  .page-header { flex-direction: column; align-items: flex-start; gap: 12px; }
  .header-right { width: 100%; }
  .search-input { width: 100%; }
  .search-wrap { flex: 1; }
  .pg-pages { display: none; }
}
</style>
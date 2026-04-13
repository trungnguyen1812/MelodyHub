<template>
  <div class="genre-shell">
    <div class="bg-grid" aria-hidden="true"></div>

    <!-- Topbar -->
    <header class="topbar">
      <button class="back-btn" @click="$router.push({ name: 'admin.genresmanager' })">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M7.793 2.232a.75.75 0 0 1-.025 1.06L3.622 7.25h10.003a5.375 5.375 0 0 1 0 10.75H10.75a.75.75 0 0 1 0-1.5h2.875a3.875 3.875 0 0 0 0-7.75H3.622l4.146 3.957a.75.75 0 0 1-1.036 1.085l-5.5-5.25a.75.75 0 0 1 0-1.085l5.5-5.25a.75.75 0 0 1 1.06.025Z" clip-rule="evenodd" />
        </svg>
        Genres
      </button>

      <div class="topbar-center">
        <span class="topbar-label">Genre Details</span>
      </div>

      <div class="topbar-actions">
        <button v-if="genre" class="edit-btn" @click="$router.push({ name: 'admin.genresmanager.update', params: { id: genre.id } })">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
            <path d="m2.695 14.762-1.262 3.155a.5.5 0 0 0 .65.65l3.155-1.262a4 4 0 0 0 1.343-.886L17.5 5.501a2.121 2.121 0 1 0-3-3L3.58 13.419a4 4 0 0 0-.885 1.343Z" />
          </svg>
          Edit Genre
        </button>
      </div>
    </header>

    <div class="page-body">
      <!-- Loading State -->
      <div v-if="loading" class="state-loading-full">
        <div class="spinner">
          <div class="sp-dot"></div>
          <div class="sp-dot"></div>
          <div class="sp-dot"></div>
        </div>
        <p>Gathering genre information...</p>
      </div>

      <template v-else-if="genre">
        <!-- Main Column -->
        <div class="main-col">
          
          <!-- Identity Card -->
          <div class="card identity-card">
            <div class="id-badge" :style="{ background: genre.color ? genre.color + '22' : 'rgba(255,255,255,0.05)', color: genre.color || '#00aaff' }">
               <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="32" height="32">
                 <path fill-rule="evenodd" d="M19.952 1.651a.75.75 0 0 1 .298.599V16.303a3 3 0 0 1-2.176 2.884l-1.32.377a2.553 2.553 0 1 1-2.772-3.528l.333-.095a.75.75 0 0 1 .407-.018l.37.106V4.829l-9 2.571v11.33a3 3 0 0 1-2.176 2.884l-1.32.377a2.553 2.553 0 1 1-2.772-3.528l.333-.095a.75.75 0 0 1 .407-.018l.37.106V3.829a.75.75 0 0 1 .548-.721l12-3.429a.75.75 0 0 1 .774.235c.1.115.152.264.152.417Z" clip-rule="evenodd" />
               </svg>
            </div>
            <div class="id-content">
              <h1 class="g-name">{{ genre.name }}</h1>
              <div class="g-slug">/{{ genre.slug }}</div>
              <p class="g-desc">{{ genre.description || 'No description provided for this genre.' }}</p>
            </div>
          </div>

          <!-- Configuration & Relation -->
          <div class="card info-card">
            <div class="card-head">
              <h2 class="card-title">Setup & Structure</h2>
            </div>
            <div class="info-grid">
              <div class="info-item">
                <span class="i-label">Theme Color</span>
                <div class="i-value-row">
                  <div class="color-preview" :style="{ background: genre.color || '#1a2530' }"></div>
                  <span>{{ genre.color || 'None' }}</span>
                </div>
              </div>
              <div class="info-item">
                <span class="i-label">Parent Category</span>
                <div class="i-value">{{ parentName }}</div>
              </div>
              <div class="info-item">
                <span class="i-label">Display Order</span>
                <div class="i-value">#{{ genre.order ?? 0 }}</div>
              </div>
              <div class="info-item">
                <span class="i-label">Visibility</span>
                <div class="i-value">
                  <span :class="['v-status', genre.is_active ? 'active' : 'inactive']">
                    {{ genre.is_active ? 'Public' : 'Hidden' }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Songs & Content -->
          <div class="card stats-card">
             <div class="stats-grid">
                <div class="stat-box">
                  <span class="s-label">Total Songs</span>
                  <span class="s-value">{{ genre.total_songs || 0 }}</span>
                </div>
                <div class="stat-box">
                  <span class="s-label">Avg. Popularity</span>
                  <span class="s-value">84%</span>
                </div>
             </div>
          </div>

        </div>

        <!-- Sidebar Column -->
        <div class="side-col">
          <div class="sticky-side">
            
            <!-- Live Preview -->
            <p class="section-hint">Mobile Card Preview</p>
            <div class="genre-preview-card" :style="{ background: genre.color ? genre.color + '22' : 'rgba(255,255,255,0.04)', borderColor: genre.color ? genre.color + '44' : 'rgba(255,255,255,0.1)' }">
               <div class="p-cover">
                 <img v-if="genre.cover_url" :src="getFullImageUrl(genre.cover_url)" alt="cover" />
                 <div v-else class="p-placeholder" :style="{ background: genre.color ? genre.color + '33' : 'rgba(255,255,255,0.06)' }">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="30" height="30" :style="{ color: genre.color || 'rgba(255,255,255,0.15)' }">
                      <path fill-rule="evenodd" d="M1.5 6a2.25 2.25 0 0 1 2.25-2.25h16.5A2.25 2.25 0 0 1 22.5 6v12a2.25 2.25 0 0 1-2.25 2.25H3.75A2.25 2.25 0 0 1 1.5 18V6ZM3 16.06V18c0 .414.336.75.75.75h16.5A.75.75 0 0 0 21 18v-1.94l-2.69-2.689a1.5 1.5 0 0 0-2.12 0l-.88.879.81.81a.75.75 0 1 1-1.06 1.06l-5.16-5.159a1.5 1.5 0 0 0-2.12 0L3 16.061Zm10.125-7.81a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0Z" clip-rule="evenodd" />
                    </svg>
                 </div>
               </div>
               <div class="p-content">
                 <div class="p-dot" :style="{ background: genre.color || '#fff' }"></div>
                 <div class="p-name">{{ genre.name }}</div>
                 <div class="p-meta">{{ genre.total_songs || 0 }} Tracks</div>
               </div>
            </div>

            <!-- Metadata Box -->
            <div class="meta-card">
              <div class="meta-row">
                <span class="m-label">Database ID</span>
                <span class="m-value">#{{ genre.id }}</span>
              </div>
              <div class="meta-row">
                <span class="m-label">Created At</span>
                <span class="m-value">{{ formatDate(genre.created_at) }}</span>
              </div>
              <div class="meta-row">
                <span class="m-label">Modified At</span>
                <span class="m-value">{{ formatDate(genre.updated_at) }}</span>
              </div>
            </div>

          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useGenreStore, getFullImageUrl } from '@/modules/admin/stores/genres/genresStore'
import { GenreInterface } from '@/interfaces/genres.interface'

const route = useRoute()
const router = useRouter()
const genreStore = useGenreStore()

const genre = ref<GenreInterface | null>(null)
const allGenres = ref<GenreInterface[]>([])
const loading = ref(true)

const parentName = computed(() => {
  if (!genre.value?.parent_id) return 'Top-level'
  const parent = allGenres.value.find(g => g.id === genre.value?.parent_id)
  return parent?.name || `Genre #${genre.value.parent_id}`
})

const formatDate = (dateString?: string | null): string => {
  if (!dateString) return '—'
  return new Date(dateString).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric'
  })
}

onMounted(async () => {
  try {
    loading.value = true
    const id = Number(route.params.id)
    
    // Load current genre
    const res = await genreStore.fetchShow(id)
    genre.value = res.data || res
    
    // Load all genres for parent lookup
    await genreStore.fetchGenres()
    allGenres.value = genreStore.genres
    
  } catch (error) {
    console.error('Error loading genre:', error)
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.genre-shell {
  min-height: 100vh;
  background: #080e14;
  color: #e8edf2;
  font-family: 'DM Sans', sans-serif;
  position: relative;
}

.bg-grid {
  position: fixed;
  inset: 0;
  background-image:
    linear-gradient(rgba(0,160,255,0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0,160,255,0.03) 1px, transparent 1px);
  background-size: 40px 40px;
  pointer-events: none;
  z-index: 0;
}

/* --- Topbar --- */
.topbar {
  position: sticky;
  top: 0;
  z-index: 20;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 28px;
  background: rgba(8,14,20,0.8);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid rgba(255,255,255,0.06);
}

.back-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.7);
  padding: 8px 14px;
  border-radius: 10px;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
}
.back-btn:hover { background: rgba(255,255,255,0.12); color: #fff; }

.topbar-center { flex: 1; }
.topbar-label { font-size: 15px; font-weight: 600; color: rgba(255,255,255,0.5);text-align: left; }

.edit-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  background: #00aaff;
  color: #000;
  border: none;
  padding: 8px 18px;
  border-radius: 10px;
  font-weight: 600;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
}
.edit-btn:hover { background: #33bbff; transform: translateY(-1px); box-shadow: 0 4px 15px rgba(0,170,255,0.3); }

/* --- Body Layout --- */
.page-body {
  position: relative;
  z-index: 1;
  max-width: 1200px;
  margin: 0 auto;
  padding: 32px 24px;
  display: grid;
  grid-template-columns: 1fr 340px;
  gap: 32px;
}

/* --- Cards --- */
.card {
  background: rgba(255,255,255,0.03);
  border: 1px solid rgba(255,255,255,0.07);
  border-radius: 20px;
  padding: 24px;
  margin-bottom: 24px;
}

/* Identity Card */
.identity-card {
  display: flex;
  gap: 24px;
  align-items: flex-start;
  background: linear-gradient(135deg, rgba(255,255,255,0.05) 0%, rgba(255,255,255,0.01) 100%);
}

.id-badge {
  width: 72px;
  height: 72px;
  border-radius: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  border: 1px solid rgba(255,255,255,0.1);
}

.id-content { flex: 1; }
.g-name { font-size: 32px; font-weight: 800; margin: 0 0 4px; letter-spacing: -0.02em; }
.g-slug { font-family: 'DM Mono', monospace; font-size: 14px; color: #00aaff; margin-bottom: 16px; opacity: 0.8; }
.g-desc { font-size: 15px; line-height: 1.6; color: rgba(255,255,255,0.6); margin: 0; max-width: 600px; }

/* Info Grid */
.card-head { margin-bottom: 20px; border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 12px; }
.card-title { font-size: 16px; font-weight: 700; color: rgba(255,255,255,0.9); margin: 0; }

.info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24px;
}

.info-item { display: flex; flex-direction: column; gap: 8px; }
.i-label { font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; color: rgba(255,255,255,0.3); }
.i-value { font-size: 15px; color: #fff; }
.i-value-row { display: flex; align-items: center; gap: 10px; font-size: 15px; }

.color-preview { width: 16px; height: 16px; border-radius: 4px; border: 1px solid rgba(255,255,255,0.2); }

.v-status {
  display: inline-flex;
  padding: 2px 10px;
  border-radius: 6px;
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
}
.v-status.active { background: rgba(0,255,120,0.1); color: #00ff78; border: 1px solid rgba(0,255,120,0.2); }
.v-status.inactive { background: rgba(255,255,255,0.05); color: rgba(255,255,255,0.4); border: 1px solid rgba(255,255,255,0.1); }

/* Stats */
.stats-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
.stat-box {
  background: rgba(0,0,0,0.2);
  padding: 20px;
  border-radius: 16px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.s-label { font-size: 12px; color: rgba(255,255,255,0.4); }
.s-value { font-size: 24px; font-weight: 700; color: #00aaff; }

/* --- Sidebar --- */
.sticky-side { position: sticky; top: 100px; display: flex; flex-direction: column; gap: 24px; }
.section-hint { font-size: 11px; font-weight: 700; text-transform: uppercase; color: rgba(255,255,255,0.2); margin: 0; letter-spacing: 0.1em; }

.genre-preview-card {
  border-radius: 20px;
  border: 1px solid;
  overflow: hidden;
  transition: all 0.3s;
}

.p-cover { width: 100%; height: 160px; overflow: hidden; position: relative; }
.p-cover img { width: 100%; height: 100%; object-fit: cover; }
.p-placeholder { width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; }

.p-content { padding: 16px; display: flex; flex-direction: column; gap: 4px; }
.p-dot { width: 6px; height: 6px; border-radius: 50%; margin-bottom: 2px; }
.p-name { font-weight: 700; font-size: 16px; }
.p-meta { font-size: 12px; color: rgba(255,255,255,0.4); }

.meta-card {
  background: rgba(255,255,255,0.02);
  border: 1px solid rgba(255,255,255,0.05);
  border-radius: 16px;
  padding: 16px;
}
.meta-row { display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px solid rgba(255,255,255,0.03); }
.meta-row:last-child { border-bottom: none; }
.m-label { font-size: 12px; color: rgba(255,255,255,0.3); }
.m-value { font-size: 12px; color: rgba(255,255,255,0.8); font-weight: 500; }

/* Loading State */
.state-loading-full {
  grid-column: 1 / -1;
  padding: 100px 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 20px;
  color: rgba(255,255,255,0.4);
}
.spinner { display: flex; gap: 8px; }
.sp-dot { width: 12px; height: 12px; border-radius: 50%; background: #00aaff; animation: bounce 1.4s infinite ease-in-out both; }
.sp-dot:nth-child(1) { animation-delay: -0.32s; }
.sp-dot:nth-child(2) { animation-delay: -0.16s; }

@keyframes bounce { 
  0%, 80%, 100% { transform: scale(0); } 
  40% { transform: scale(1); } 
}

@media (max-width: 900px) {
  .page-body { grid-template-columns: 1fr; }
  .side-col { display: none; }
}
</style>
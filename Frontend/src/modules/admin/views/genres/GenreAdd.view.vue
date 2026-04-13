<template>
  <div class="genre-shell">
    <div class="bg-grid" aria-hidden="true"></div>

    <!-- Header -->
    <header class="topbar">
      <button class="back-btn" @click="$router.back()">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M7.793 2.232a.75.75 0 0 1-.025 1.06L3.622 7.25h10.003a5.375 5.375 0 0 1 0 10.75H10.75a.75.75 0 0 1 0-1.5h2.875a3.875 3.875 0 0 0 0-7.75H3.622l4.146 3.957a.75.75 0 0 1-1.036 1.085l-5.5-5.25a.75.75 0 0 1 0-1.085l5.5-5.25a.75.75 0 0 1 1.06.025Z" clip-rule="evenodd" />
        </svg>
        Genres
      </button>
      <div class="topbar-center">
        <span class="topbar-label">New Genre</span>
      </div>
      <div class="topbar-right"></div>
    </header>

    <div class="page-body">
      <!-- Left: Form -->
      <div class="form-col">

        <!-- Basic info -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon" :style="{ background: form.color ? form.color + '22' : 'rgba(255,255,255,0.05)', borderColor: form.color || 'rgba(255,255,255,0.1)' }">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" :style="{ color: form.color || '#00aaff' }">
                <path fill-rule="evenodd" d="M2.25 5.25a3 3 0 0 1 3-3h13.5a3 3 0 0 1 3 3V15a3 3 0 0 1-3 3h-3v.257c0 .597.237 1.17.659 1.591l.621.622a.75.75 0 0 1-.53 1.28h-9a.75.75 0 0 1-.53-1.28l.621-.622a2.25 2.25 0 0 0 .659-1.59V18h-3a3 3 0 0 1-3-3V5.25Zm1.5 0v7.5a1.5 1.5 0 0 0 1.5 1.5h13.5a1.5 1.5 0 0 0 1.5-1.5v-7.5a1.5 1.5 0 0 0-1.5-1.5H5.25a1.5 1.5 0 0 0-1.5 1.5Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Basic information</h2>
              <p class="card-sub">Name, slug and description</p>
            </div>
          </div>

          <div class="fields">
            <div class="field">
              <label class="flabel required">Genre name</label>
              <input v-model="form.name" type="text" placeholder="e.g. Hip-Hop & Rap" class="fcontrol" />
            </div>

            <div class="field">
              <label class="flabel required">Slug</label>
              <div class="slug-row">
                <input v-model="form.slug" type="text" placeholder="hip-hop-rap" class="fcontrol" disabled="true">
                <button type="button" class="slug-btn" @click="generateSlug" title="Generate from name">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15">
                    <path fill-rule="evenodd" d="M15.312 11.424a5.5 5.5 0 0 1-9.201 2.466l-.312-.311h2.433a.75.75 0 0 0 0-1.5H3.989a.75.75 0 0 0-.75.75v4.242a.75.75 0 0 0 1.5 0v-2.43l.31.31a7 7 0 0 0 11.712-3.138.75.75 0 0 0-1.449-.39Zm1.23-3.723a.75.75 0 0 0 .219-.53V2.929a.75.75 0 0 0-1.5 0V5.36l-.31-.31A7 7 0 0 0 3.239 8.188a.75.75 0 1 0 1.448.389A5.5 5.5 0 0 1 13.89 6.11l.311.31h-2.432a.75.75 0 0 0 0 1.5h4.243a.75.75 0 0 0 .53-.219Z" clip-rule="evenodd" />
                  </svg>
                </button>
              </div>
              <span class="fhint">URL-friendly identifier</span>
            </div>

            <div class="field">
              <label class="flabel">Description</label>
              <textarea v-model="form.description" rows="4" placeholder="Describe this genre…" class="fcontrol"></textarea>
            </div>
          </div>
        </div>

        <!-- Cover & Color -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M1.5 6a2.25 2.25 0 0 1 2.25-2.25h16.5A2.25 2.25 0 0 1 22.5 6v12a2.25 2.25 0 0 1-2.25 2.25H3.75A2.25 2.25 0 0 1 1.5 18V6ZM3 16.06V18c0 .414.336.75.75.75h16.5A.75.75 0 0 0 21 18v-1.94l-2.69-2.689a1.5 1.5 0 0 0-2.12 0l-.88.879.81.81a.75.75 0 1 1-1.06 1.06l-5.16-5.159a1.5 1.5 0 0 0-2.12 0L3 16.061Zm10.125-7.81a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Cover & color</h2>
              <p class="card-sub">Visual identity for this genre</p>
            </div>
          </div>

          <div class="cover-color-layout">
            <!-- Cover upload -->
            <div class="cover-uploader" @click="coverInput?.click()"
              :style="{ borderColor: form.color || 'rgba(255,255,255,0.15)' }">
              <img v-if="coverPreview" :src="coverPreview" alt="cover" class="cover-img" />
              <div v-else class="cover-placeholder" :style="{ background: form.color ? form.color + '18' : '' }">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="32" height="32" :style="{ color: form.color || 'rgba(255,255,255,0.15)' }">
                  <path fill-rule="evenodd" d="M1.5 6a2.25 2.25 0 0 1 2.25-2.25h16.5A2.25 2.25 0 0 1 22.5 6v12a2.25 2.25 0 0 1-2.25 2.25H3.75A2.25 2.25 0 0 1 1.5 18V6ZM3 16.06V18c0 .414.336.75.75.75h16.5A.75.75 0 0 0 21 18v-1.94l-2.69-2.689a1.5 1.5 0 0 0-2.12 0l-.88.879.81.81a.75.75 0 1 1-1.06 1.06l-5.16-5.159a1.5 1.5 0 0 0-2.12 0L3 16.061Zm10.125-7.81a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0Z" clip-rule="evenodd" />
                </svg>
                <span>Upload cover</span>
              </div>
              <div class="cover-overlay">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
                  <path d="M5.433 13.917l1.262-3.155A4 4 0 0 1 7.58 9.42l6.92-6.918a2.121 2.121 0 0 1 3 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 0 1-.65-.65Z" />
                  <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0 0 10 3H4.75A2.75 2.75 0 0 0 2 5.75v9.5A2.75 2.75 0 0 0 4.75 18h9.5A2.75 2.75 0 0 0 17 15.25V10a.75.75 0 0 0-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5Z" />
                </svg>
                <span>{{ coverPreview ? 'Change' : 'Upload' }}</span>
              </div>
            </div>
            <input type="file" ref="coverInput" accept="image/jpeg,image/png,image/webp" @change="handleCoverChange" style="display:none" />

            <!-- Color picker -->
            <div class="color-col">
              <div class="field">
                <label class="flabel">Theme color</label>
                <div class="color-input-row">
                  <div class="color-swatch" :style="{ background: form.color || '#1a2530' }">
                    <input type="color" v-model="form.color" class="color-native" />
                  </div>
                  <input v-model="form.color" type="text" placeholder="#000000" class="fcontrol color-text" maxlength="7" />
                </div>
                <span class="fhint">Used for genre card background</span>
              </div>

              <!-- Preset colors -->
              <div class="color-presets">
                <span class="fhint" style="margin-bottom:8px;display:block">Quick pick</span>
                <div class="preset-grid">
                  <button
                    v-for="c in colorPresets"
                    :key="c"
                    class="preset-dot"
                    :class="{ active: form.color === c }"
                    :style="{ background: c }"
                    @click="form.color = c"
                    :title="c"
                  ></button>
                </div>
              </div>
            </div>
          </div>
          <p class="fhint" style="margin-top:10px">JPG, PNG, WebP · max 5MB · recommended 800×500</p>
        </div>

        <!-- Hierarchy & Settings -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M2.25 5.25a3 3 0 0 1 3-3h1.372c.86 0 1.61.586 1.819 1.42l1.105 4.423a1.875 1.875 0 0 1-.694 1.955l-1.013.812c-.134.108-.184.355-.089.51C9.91 12.835 11.167 14 13.5 14.25V15a.75.75 0 0 0 1.5 0v-.75c2.333-.25 3.59-1.415 4.244-2.63.095-.155.045-.402-.09-.51l-1.012-.812a1.875 1.875 0 0 1-.694-1.955l1.105-4.423A1.875 1.875 0 0 1 20.372 3h1.378a3 3 0 0 1 3 3v1.5a3 3 0 0 1-3 3h-1.5a3 3 0 0 1-3-3V6a.75.75 0 0 0-.75-.75H5.25a.75.75 0 0 0-.75.75v.75c0 .414.336.75.75.75h13.5c.414 0 .75-.336.75-.75V6a.75.75 0 0 0-.75-.75h-1.5A.75.75 0 0 0 16.5 6v1.5a.75.75 0 0 0 .75.75H18a1.5 1.5 0 0 1 0 3h-1.5a.75.75 0 0 0-.75.75v.75c0 .414.336.75.75.75h1.5a3 3 0 0 1 3 3v1.5a3 3 0 0 1-3 3h-1.378a1.875 1.875 0 0 1-1.819-1.42l-1.105-4.422a1.875 1.875 0 0 1 .694-1.956l1.013-.812c.134-.108.184-.355.089-.51C13.59 9.165 12.333 8 10 7.75V7a.75.75 0 0 0-1.5 0v.75C6.167 8 4.91 9.165 4.256 10.38c-.095.155-.045.402.09.51l1.012.812a1.875 1.875 0 0 1 .694 1.956L4.947 18.08A1.875 1.875 0 0 1 3.128 19.5H1.75a3 3 0 0 1-3-3V15a3 3 0 0 1 3-3H3.25a.75.75 0 0 0 .75-.75V9.75A.75.75 0 0 0 3.25 9H1.75a3 3 0 0 1-3-3V4.5a3 3 0 0 1 3-3h1.378a1.875 1.875 0 0 1 1.819 1.42l1.105 4.423c.178.712-.072 1.47-.694 1.955l-1.013.812c-.134.108-.184.355-.089.51C4.91 11.835 6.167 13 8.5 13.25V14a.75.75 0 0 0 1.5 0v-.75c2.333-.25 3.59-1.415 4.244-2.63.095-.155.045-.402-.09-.51l-1.012-.812a1.875 1.875 0 0 1-.694-1.955L13.553 3.42A1.875 1.875 0 0 1 15.372 2h1.378a3 3 0 0 1 3 3v1.5a3 3 0 0 1-3 3H15.25a.75.75 0 0 0-.75.75v.75c0 .414.336.75.75.75h1.5c.414 0 .75-.336.75-.75V9.75a.75.75 0 0 0-.75-.75H15a3 3 0 0 1-3-3V4.5Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Hierarchy & settings</h2>
              <p class="card-sub">Parent genre, order and visibility</p>
            </div>
          </div>

          <div class="fields">
            <div class="field-row two-col">
              <div class="field">
                <label class="flabel">Parent genre</label>
                <select v-model="form.parent_id" class="fcontrol">
                  <option :value="null">None (top-level)</option>
                  <option v-for="g in parentGenres" :key="g.id" :value="g.id">
                    {{ g.name }}
                  </option>
                </select>
                <span class="fhint">Leave empty for top-level genre</span>
              </div>

              <div class="field">
                <label class="flabel">Display order</label>
                <input v-model.number="form.order" type="number" min="0" placeholder="0" class="fcontrol" />
                <span class="fhint">Lower number = appears first</span>
              </div>
            </div>

            <!-- Active toggle -->
            <div
              class="toggle-card"
              :class="{ on: form.is_active }"
              @click="form.is_active = !form.is_active"
            >
              <div class="toggle-thumb" :class="{ on: form.is_active }"></div>
              <div class="toggle-body">
                <span class="toggle-name">Active</span>
                <span class="toggle-desc">Genre is visible to users on the platform</span>
              </div>
              <div class="toggle-badge" :class="{ on: form.is_active }">
                {{ form.is_active ? 'ON' : 'OFF' }}
              </div>
            </div>
          </div>
        </div>

        <!-- Actions -->
        <div class="form-actions">
          <button class="btn ghost" @click="$router.back()">Cancel</button>
          <button class="btn primary" @click="submitForm" :disabled="loading">
            <span v-if="loading" class="btn-spinner"></span>
            <template v-else>
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
                <path d="M10.75 4.75a.75.75 0 0 0-1.5 0v4.5h-4.5a.75.75 0 0 0 0 1.5h4.5v4.5a.75.75 0 0 0 1.5 0v-4.5h4.5a.75.75 0 0 0 0-1.5h-4.5v-4.5Z" />
              </svg>
              Create genre
            </template>
          </button>
        </div>
      </div>

      <!-- Right: Preview -->
      <div class="preview-col">
        <div class="preview-sticky">
          <p class="preview-label">Live preview</p>

          <!-- Genre card preview -->
          <div class="genre-card-preview" :style="{ background: form.color ? form.color + '22' : 'rgba(255,255,255,0.04)', borderColor: form.color ? form.color + '55' : 'rgba(255,255,255,0.08)' }">
            <div class="gcp-cover">
              <img v-if="coverPreview" :src="coverPreview" alt="cover" />
              <div v-else class="gcp-cover-placeholder" :style="{ background: form.color ? form.color + '33' : 'rgba(255,255,255,0.06)' }">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="28" height="28" :style="{ color: form.color || 'rgba(255,255,255,0.15)' }">
                  <path fill-rule="evenodd" d="M1.5 6a2.25 2.25 0 0 1 2.25-2.25h16.5A2.25 2.25 0 0 1 22.5 6v12a2.25 2.25 0 0 1-2.25 2.25H3.75A2.25 2.25 0 0 1 1.5 18V6ZM3 16.06V18c0 .414.336.75.75.75h16.5A.75.75 0 0 0 21 18v-1.94l-2.69-2.689a1.5 1.5 0 0 0-2.12 0l-.88.879.81.81a.75.75 0 1 1-1.06 1.06l-5.16-5.159a1.5 1.5 0 0 0-2.12 0L3 16.061Zm10.125-7.81a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0Z" clip-rule="evenodd" />
                </svg>
              </div>
            </div>
            <div class="gcp-body">
              <div class="gcp-dot" :style="{ background: form.color || 'rgba(255,255,255,0.2)' }"></div>
              <span class="gcp-name">{{ form.name || 'Genre name' }}</span>
              <span class="gcp-slug">/{{ form.slug || 'genre-slug' }}</span>
              <div class="gcp-meta">
                <span class="gcp-tag" v-if="form.parent_id">
                  Sub-genre
                </span>
                <span class="gcp-tag" v-if="!form.is_active" style="color:#ff7070;border-color:rgba(255,100,100,0.3)">
                  Inactive
                </span>
                <span class="gcp-songs">0 songs</span>
              </div>
            </div>
          </div>

          <!-- Field summary -->
          <div class="field-summary">
            <div class="fs-row">
              <span class="fs-key">Status</span>
              <span class="fs-val" :style="{ color: form.is_active ? '#00c87a' : '#ff7070' }">
                {{ form.is_active ? 'Active' : 'Inactive' }}
              </span>
            </div>
            <div class="fs-row">
              <span class="fs-key">Parent</span>
              <span class="fs-val">{{ parentGenreName || 'Top-level' }}</span>
            </div>
            <div class="fs-row">
              <span class="fs-key">Order</span>
              <span class="fs-val">#{{ form.order ?? 0 }}</span>
            </div>
            <div class="fs-row">
              <span class="fs-key">Color</span>
              <div class="fs-val" style="display:flex;align-items:center;gap:6px">
                <div v-if="form.color" class="fs-color-dot" :style="{ background: form.color }"></div>
                <span>{{ form.color || 'None' }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, computed, watch, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useNotificationStore } from '@/store/notificationStore'
import { useGenreStore } from '@/modules/admin/stores/genres/genresStore'
import { storeToRefs } from 'pinia'

const router = useRouter()
const notificationStore = useNotificationStore()
const genreStore = useGenreStore()
const { genres } = storeToRefs(genreStore)

const loading = ref(false)
const coverPreview = ref<string>('')
const coverInput = ref<HTMLInputElement | null>(null)

const colorPresets = [
  '#FF6B6B', '#FF8E53', '#FFC947', '#A8E063',
  '#56CCF2', '#2F80ED', '#BB6BD9', '#F2994A',
  '#EB5757', '#27AE60', '#00aaff', '#9B51E0',
]

interface GenreForm {
  name: string
  slug: string
  description: string
  cover_url: File | null
  color: string
  parent_id: number | null
  order: number
  is_active: boolean
}

const form = reactive<GenreForm>({
  name: '',
  slug: '',
  description: '',
  cover_url: null,
  color: '',
  parent_id: null,
  order: 0,
  is_active: true,
})

// Only top-level genres can be parents
const parentGenres = computed(() =>
  (genres.value || []).filter((g: any) => !g.parent_id)
)

const parentGenreName = computed(() => {
  if (!form.parent_id) return ''
  return parentGenres.value.find((g: any) => g.id === form.parent_id)?.name || ''
})

const generateSlug = () => {
  if (!form.name) return
  form.slug = form.name
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
}

watch(() => form.name, generateSlug)

const handleCoverChange = (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  if (!file) return
  if (!file.type.startsWith('image/')) {
    notificationStore.notify('Please select an image file!', 'error')
    return
  }
  if (file.size > 5 * 1024 * 1024) {
    notificationStore.notify('File too large! Max 5MB', 'error')
    return
  }
  form.cover_url = file
  const reader = new FileReader()
  reader.onload = e => { coverPreview.value = e.target?.result as string }
  reader.readAsDataURL(file)
}

onMounted(async () => {
  await genreStore.fetchGenres()
})

const submitForm = async () => {
  if (!form.name) {
    notificationStore.notify('Genre name is required', 'error')
    return
  }
  if (!form.slug) {
    notificationStore.notify('Slug is required', 'error')
    return
  }
  try {
    loading.value = true
    await genreStore.fetchAddGenre(form)
    notificationStore.notify('Genre created successfully!', 'success')
    router.push({ name: 'admin.genresmanager' })
  } catch (err: any) {
    notificationStore.notify(
      err.response?.data?.message || 'Failed to create genre',
      'error'
    )
  } finally {
    loading.value = false
    setTimeout(() => notificationStore.clear(), 3000)
  }
}
</script>

<style scoped>
/* ── Base ───────────────────────────────────────── */
.genre-shell {
  min-height: 100vh;
  background: #080e14;
  font-family: 'DM Sans', 'Segoe UI', sans-serif;
  color: #e8edf2;
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

/* ── Topbar ─────────────────────────────────────── */
.topbar {
  position: sticky;
  top: 0;
  z-index: 20;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 28px;
  border-bottom: 1px solid rgba(255,255,255,0.06);
  background: rgba(8,14,20,0.85);
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
  font-family: inherit;
}
.back-btn:hover { background: rgba(255,255,255,0.1); color: #fff; }

.topbar-center { flex: 1; }
.topbar-label { font-size: 15px; font-weight: 600; color: rgba(255,255,255,0.5); }
.topbar-right { width: 90px; }

/* ── Page layout ────────────────────────────────── */
.page-body {
  position: relative;
  z-index: 1;
  display: grid;
  grid-template-columns: 1fr 300px;
  gap: 24px;
  max-width: 1100px;
  margin: 0 auto;
  padding: 28px 24px 60px;
}

/* ── Cards ──────────────────────────────────────── */
.card {
  background: rgba(255,255,255,0.03);
  border: 1px solid rgba(255,255,255,0.07);
  border-radius: 16px;
  padding: 24px;
  margin-bottom: 16px;
}

.card-head {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 22px;
  padding-bottom: 18px;
  border-bottom: 1px solid rgba(255,255,255,0.06);
}

.card-icon {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  background: rgba(0,160,255,0.1);
  border: 1px solid rgba(0,160,255,0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: all 0.3s;
}

.card-title { font-size: 16px; font-weight: 600; color: #fff; margin: 0 0 3px; }
.card-sub { font-size: 13px; color: rgba(255,255,255,0.4); margin: 0; }

/* ── Fields ─────────────────────────────────────── */
.fields { display: flex; flex-direction: column; gap: 16px; }

.field { display: flex; flex-direction: column; gap: 6px; }

.field-row.two-col {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.flabel {
  font-size: 13px;
  font-weight: 500;
  color: rgba(255,255,255,0.6);
}
.flabel.required::after { content: ' *'; color: #ff5555; }

.fcontrol {
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 9px;
  padding: 10px 13px;
  color: #fff;
  font-size: 14px;
  font-family: inherit;
  transition: border-color 0.2s;
  width: 100%;
  box-sizing: border-box;
}
.fcontrol:focus { outline: none; border-color: rgba(0,170,255,0.6); background: rgba(255,255,255,0.07); }
.fcontrol::placeholder { color: rgba(255,255,255,0.2); }
.fcontrol option { background: #1a2530; }
textarea.fcontrol { resize: vertical; }

.fhint { font-size: 11px; color: rgba(255,255,255,0.3); }

.slug-row { display: flex; gap: 8px; }
.slug-row .fcontrol { flex: 1; }
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

/* ── Cover & color ──────────────────────────────── */
.cover-color-layout {
  display: grid;
  grid-template-columns: 180px 1fr;
  gap: 20px;
  align-items: start;
}

.cover-uploader {
  width: 180px;
  height: 120px;
  border-radius: 12px;
  overflow: hidden;
  border: 2px dashed rgba(255,255,255,0.15);
  position: relative;
  cursor: pointer;
  transition: border-color 0.2s;
  flex-shrink: 0;
}
.cover-uploader:hover { border-color: #00aaff; }
.cover-uploader:hover .cover-overlay { opacity: 1; }

.cover-img { width: 100%; height: 100%; object-fit: cover; display: block; }

.cover-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  font-size: 12px;
  color: rgba(255,255,255,0.3);
  transition: background 0.3s;
}

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
  font-size: 13px;
  opacity: 0;
  transition: opacity 0.2s;
}

.color-col { display: flex; flex-direction: column; gap: 16px; }

.color-input-row { display: flex; gap: 8px; align-items: center; }

.color-swatch {
  width: 40px;
  height: 40px;
  border-radius: 9px;
  border: 1px solid rgba(255,255,255,0.15);
  overflow: hidden;
  position: relative;
  flex-shrink: 0;
  cursor: pointer;
  transition: border-color 0.2s;
}
.color-swatch:hover { border-color: rgba(255,255,255,0.4); }

.color-native {
  position: absolute;
  inset: -4px;
  width: calc(100% + 8px);
  height: calc(100% + 8px);
  opacity: 0;
  cursor: pointer;
}

.color-text { flex: 1; font-family: 'DM Mono', monospace; }

.preset-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.preset-dot {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  border: 2px solid transparent;
  cursor: pointer;
  transition: all 0.15s;
  padding: 0;
}
.preset-dot:hover { transform: scale(1.2); }
.preset-dot.active { border-color: #fff; transform: scale(1.15); }

/* ── Toggle card ────────────────────────────────── */
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
.toggle-card.on { border-color: rgba(0,200,120,0.3); background: rgba(0,200,120,0.06); }

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
  background: rgba(255,255,255,0.4);
  top: 3px;
  left: 3px;
  transition: all 0.2s;
}
.toggle-thumb.on { background: #00c87a; }
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
.toggle-badge.on { background: rgba(0,200,120,0.15); color: #00c87a; }

/* ── Form actions ───────────────────────────────── */
.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding-top: 4px;
}

.btn {
  display: flex;
  align-items: center;
  gap: 7px;
  padding: 10px 22px;
  border-radius: 10px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  border: none;
  transition: all 0.2s;
  font-family: inherit;
}
.btn:disabled { opacity: 0.4; cursor: not-allowed; }

.btn.ghost {
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.6);
}
.btn.ghost:hover { background: rgba(255,255,255,0.1); color: #fff; }

.btn.primary { background: #00aaff; color: #000; }
.btn.primary:hover:not(:disabled) {
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

/* ── Preview panel ──────────────────────────────── */
.preview-col { position: relative; }

.preview-sticky {
  position: sticky;
  top: 80px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.preview-label {
  font-size: 11px;
  font-weight: 600;
  color: rgba(255,255,255,0.3);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  margin: 0;
}

/* Genre card preview */
.genre-card-preview {
  border-radius: 14px;
  border: 1px solid rgba(255,255,255,0.08);
  overflow: hidden;
  transition: all 0.3s;
}

.gcp-cover {
  width: 100%;
  height: 130px;
  overflow: hidden;
}
.gcp-cover img { width: 100%; height: 100%; object-fit: cover; display: block; }
.gcp-cover-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.3s;
}

.gcp-body {
  padding: 14px 16px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.gcp-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  margin-bottom: 2px;
  transition: background 0.3s;
}

.gcp-name {
  font-size: 15px;
  font-weight: 600;
  color: #fff;
  line-height: 1.2;
}

.gcp-slug {
  font-size: 11px;
  color: rgba(255,255,255,0.3);
  font-family: 'DM Mono', monospace;
}

.gcp-meta {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-top: 6px;
  flex-wrap: wrap;
}

.gcp-tag {
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 100px;
  border: 1px solid rgba(255,255,255,0.15);
  color: rgba(255,255,255,0.5);
}

.gcp-songs {
  font-size: 11px;
  color: rgba(255,255,255,0.3);
  margin-left: auto;
}

/* Field summary */
.field-summary {
  background: rgba(255,255,255,0.02);
  border: 1px solid rgba(255,255,255,0.06);
  border-radius: 12px;
  overflow: hidden;
}

.fs-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 14px;
  border-bottom: 1px solid rgba(255,255,255,0.04);
  gap: 12px;
}
.fs-row:last-child { border-bottom: none; }

.fs-key { font-size: 12px; color: rgba(255,255,255,0.35); }
.fs-val { font-size: 12px; color: rgba(255,255,255,0.7); text-align: right; }

.fs-color-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  flex-shrink: 0;
}

/* ── Responsive ─────────────────────────────────── */
@media (max-width: 860px) {
  .page-body { grid-template-columns: 1fr; }
  .preview-col { order: -1; }
  .preview-sticky { position: static; }
  .genre-card-preview { max-width: 320px; }
  .cover-color-layout { grid-template-columns: 1fr; }
  .cover-uploader { width: 100%; height: 140px; }
  .field-row.two-col { grid-template-columns: 1fr; }
}
</style>
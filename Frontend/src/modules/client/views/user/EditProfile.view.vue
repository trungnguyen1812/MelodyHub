<template>
  <div class="edit-profile-page">
    <div class="edit-profile-page__ambient" />

    <div class="edit-container">
      <!-- Header -->
      <div class="edit-header">
        <button class="btn-back" @click="router.back()">
          <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
          </svg>
          Back
        </button>
        <h1 class="edit-header__title">Edit Profile</h1>
      </div>

      <!-- Form card -->
      <div class="edit-card">
        <div class="edit-card__header">
          <div class="edit-card__icon">
            <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
            </svg>
          </div>
          <h2 class="edit-card__title">Personal Information</h2>
        </div>

        <form class="edit-form" @submit.prevent="handleSubmit">

          <!-- ── Avatar upload ─────────────────────────────────────────── -->
          <div class="avatar-section">
            <!-- Clickable avatar -->
            <div class="avatar-wrap" @click="triggerFileInput" title="Click to change avatar">
              <div class="avatar-ring">
                <img
                  v-if="avatarPreview"
                  :src="avatarPreview"
                  alt="Avatar preview"
                  class="avatar-img"
                  @error="handleAvatarError"
                />
                <div
                  v-else
                  class="avatar-fallback"
                  :style="{ backgroundColor: getAvatarColor(user?.name) }"
                >
                  {{ getInitial(user?.name) }}
                </div>
              </div>
              <!-- Overlay camera icon -->
              <div class="avatar-overlay">
                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"/>
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"/>
                </svg>
              </div>
            </div>

            <!-- Hidden file input -->
            <input
              ref="fileInputRef"
              type="file"
              accept="image/jpeg,image/png,image/gif,image/webp"
              class="file-input-hidden"
              @change="onFileChange"
            />

            <div class="avatar-meta">
              <p class="avatar-meta__name">{{ user?.name || 'Your Name' }}</p>
              <p class="avatar-meta__hint">Click the avatar to upload a new photo</p>
              <p class="avatar-meta__hint">JPG, PNG, GIF, WEBP · max 2 MB</p>
              <button
                v-if="avatarFile"
                type="button"
                class="btn-remove-avatar"
                @click="removeAvatar"
              >
                Remove new photo
              </button>
            </div>
          </div>

          <!-- ── Fields grid ────────────────────────────────────────────── -->
          <div class="form-grid">
            <div class="form-group">
              <label class="form-label">Full Name</label>
              <input
                v-model="form.name"
                type="text"
                class="form-input"
                placeholder="Your full name"
              />
            </div>

            <div class="form-group">
              <label class="form-label">Phone Number</label>
              <input
                v-model="form.phone"
                type="tel"
                class="form-input"
                placeholder="+84 xxx xxx xxx"
              />
            </div>

            <div class="form-group">
              <label class="form-label">Date of Birth</label>
              <input
                v-model="form.date_of_birth"
                type="date"
                class="form-input"
              />
            </div>

            <div class="form-group">
              <label class="form-label">Gender</label>
              <select v-model="form.gender" class="form-input form-select">
                <option value="">— Select —</option>
                <option value="male">Male</option>
                <option value="female">Female</option>
                <option value="other">Other</option>
              </select>
            </div>

            <div class="form-group form-group--full">
              <label class="form-label">Bio</label>
              <textarea
                v-model="form.bio"
                class="form-input form-textarea"
                rows="3"
                placeholder="Tell us a little about yourself..."
              />
            </div>
          </div>

          <!-- Alerts -->
          <div v-if="errorMsg"   class="alert alert--error">{{ errorMsg }}</div>
          <div v-if="successMsg" class="alert alert--success">{{ successMsg }}</div>

          <!-- Actions -->
          <div class="form-actions">
            <button type="button" class="btn btn--ghost" @click="router.back()">Cancel</button>
            <button type="submit" class="btn btn--primary" :disabled="isLoading">
              <span v-if="isLoading" class="spinner" />
              {{ isLoading ? 'Saving...' : 'Save Changes' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore, getFullImageUrl } from '@/store/authStore'

const router    = useRouter()
const authStore = useAuthStore()
const user      = computed(() => authStore.user)

const isLoading  = ref(false)
const errorMsg   = ref('')
const successMsg = ref('')

// ── Avatar state ──────────────────────────────────────────────────────────────
const fileInputRef  = ref<HTMLInputElement | null>(null)
const avatarFile    = ref<File | null>(null)
const avatarPreview = ref<string>('')   // data-URL or existing URL

// ── Form state ────────────────────────────────────────────────────────────────
const form = reactive({
  name:          '',
  phone:         '',
  date_of_birth: '',
  gender:        '' as '' | 'male' | 'female' | 'other',
  bio:           '',
})

onMounted(() => {
  if (user.value) {
    form.name          = user.value.name          ?? ''
    form.phone         = user.value.phone         ?? ''
    form.date_of_birth = user.value.date_of_birth
      ? user.value.date_of_birth.substring(0, 10)
      : ''
    form.gender = (user.value.gender as typeof form.gender) ?? ''
    form.bio    = user.value.bio ?? ''

    // Show existing avatar
    const existing = getFullImageUrl(user.value.avatar_url)
    if (existing) avatarPreview.value = existing
  }
})

// ── Avatar helpers ────────────────────────────────────────────────────────────
const triggerFileInput = () => fileInputRef.value?.click()

const onFileChange = (e: Event) => {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (!file) return

  if (file.size > 2 * 1024 * 1024) {
    errorMsg.value = 'Image must be smaller than 2 MB'
    return
  }

  avatarFile.value    = file
  avatarPreview.value = URL.createObjectURL(file)
  errorMsg.value      = ''
}

const removeAvatar = () => {
  avatarFile.value    = null
  avatarPreview.value = getFullImageUrl(user.value?.avatar_url) ?? ''
  if (fileInputRef.value) fileInputRef.value.value = ''
}

const handleAvatarError = (e: Event) => {
  const img = e.target as HTMLImageElement
  img.src    = '/default-avatar.png'
  img.onerror = null
}

const getInitial = (name?: string) => {
  if (!name) return '?'
  return name.trim().charAt(0).toUpperCase()
}

const getAvatarColor = (name?: string) => {
  if (!name) return '#6b7280'
  const colors = ['#f87171','#fb923c','#fbbf24','#34d399','#60a5fa','#a78bfa','#f472b6','#2dd4bf']
  let hash = 0
  for (let i = 0; i < name.length; i++) {
    hash = ((hash << 5) - hash) + name.charCodeAt(i)
    hash |= 0
  }
  return colors[Math.abs(hash) % colors.length]
}

// ── Submit ────────────────────────────────────────────────────────────────────
const handleSubmit = async () => {
  errorMsg.value   = ''
  successMsg.value = ''
  isLoading.value  = true

  try {
    await authStore.updateProfile({
      name:          form.name          || undefined,
      phone:         form.phone         || undefined,
      date_of_birth: form.date_of_birth || undefined,
      gender:        form.gender        || undefined,
      bio:           form.bio           || undefined,
      avatar:        avatarFile.value   ?? undefined,
    })

    successMsg.value = 'Profile updated successfully!'
    setTimeout(() => router.push('/profile'), 1200)
  } catch (err: any) {
    errorMsg.value =
      err?.response?.data?.message ?? 'Failed to update profile. Please try again.'
  } finally {
    isLoading.value = false
  }
}
</script>

<style scoped>
.edit-profile-page {
  min-height: 100vh;
  background: #080b11;
  color: rgba(255,255,255,0.92);
  position: relative;
  font-family: 'DM Sans', system-ui, sans-serif;
}

.edit-profile-page__ambient {
  position: fixed;
  inset: 0;
  pointer-events: none;
  background:
    radial-gradient(ellipse 60% 40% at 10% 0%, rgba(0,198,255,0.07) 0%, transparent 70%),
    radial-gradient(ellipse 50% 50% at 90% 100%, rgba(167,139,250,0.06) 0%, transparent 70%);
}

.edit-container {
  max-width: 680px;
  margin: 0 auto;
  padding: 40px 24px 80px;
  position: relative;
}

/* ── Header ─────────────────────────────────────────────────────────────────── */
.edit-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 28px;
}

.edit-header__title {
  font-size: 22px;
  font-weight: 700;
  margin: 0;
  background: linear-gradient(90deg, #fff 40%, #00c6ff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.btn-back {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.07);
  color: rgba(255,255,255,0.7);
  font-size: 13px;
  font-weight: 500;
  padding: 7px 14px;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-back:hover {
  background: rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.92);
}

/* ── Card ───────────────────────────────────────────────────────────────────── */
.edit-card {
  background: rgba(255,255,255,0.035);
  border: 1px solid rgba(255,255,255,0.07);
  border-radius: 18px;
  overflow: hidden;
  backdrop-filter: blur(8px);
}

.edit-card__header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 18px 24px;
  border-bottom: 1px solid rgba(255,255,255,0.07);
}

.edit-card__icon {
  width: 34px;
  height: 34px;
  border-radius: 10px;
  background: rgba(0,198,255,0.1);
  color: #00c6ff;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.edit-card__title {
  font-size: 15px;
  font-weight: 600;
  margin: 0;
}

/* ── Form ───────────────────────────────────────────────────────────────────── */
.edit-form {
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

/* ── Avatar section ─────────────────────────────────────────────────────────── */
.avatar-section {
  display: flex;
  align-items: center;
  gap: 24px;
  padding: 20px;
  background: rgba(255,255,255,0.02);
  border: 1px solid rgba(255,255,255,0.06);
  border-radius: 14px;
}

.avatar-wrap {
  position: relative;
  flex-shrink: 0;
  cursor: pointer;
  border-radius: 50%;
}

.avatar-ring {
  width: 88px;
  height: 88px;
  border-radius: 50%;
  padding: 2px;
  background: linear-gradient(135deg, #00c6ff, #a78bfa);
  transition: opacity 0.2s;
}

.avatar-wrap:hover .avatar-ring {
  opacity: 0.85;
}

.avatar-img {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  object-fit: cover;
  background: #1a1f2e;
  display: block;
}

.avatar-fallback {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 28px;
  color: white;
  border-radius: 50%;
}

/* Camera overlay */
.avatar-overlay {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  background: rgba(0,0,0,0.45);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  opacity: 0;
  transition: opacity 0.2s;
}

.avatar-wrap:hover .avatar-overlay {
  opacity: 1;
}

/* Hidden file input */
.file-input-hidden {
  display: none;
}

.avatar-meta {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.avatar-meta__name {
  font-size: 16px;
  font-weight: 600;
  margin: 0;
  color: rgba(255,255,255,0.92);
}

.avatar-meta__hint {
  font-size: 12px;
  color: rgba(255,255,255,0.35);
  margin: 0;
}

.btn-remove-avatar {
  margin-top: 6px;
  background: none;
  border: none;
  font-size: 12px;
  color: #f87171;
  cursor: pointer;
  padding: 0;
  text-align: left;
  transition: opacity 0.2s;
}

.btn-remove-avatar:hover { opacity: 0.75; }

/* ── Form grid ──────────────────────────────────────────────────────────────── */
.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px 24px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-group--full {
  grid-column: 1 / -1;
}

.form-label {
  font-size: 11px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: rgba(255,255,255,0.38);
}

.form-input {
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 10px;
  padding: 10px 14px;
  font-size: 14px;
  color: rgba(255,255,255,0.92);
  outline: none;
  transition: border-color 0.2s, background 0.2s;
  width: 100%;
  box-sizing: border-box;
  font-family: inherit;
}

.form-input:focus {
  border-color: rgba(0,198,255,0.4);
  background: rgba(0,198,255,0.04);
}

.form-input::placeholder {
  color: rgba(255,255,255,0.22);
}

.form-select {
  appearance: none;
  cursor: pointer;
}

.form-select option {
  background: #1a1f2e;
  color: rgba(255,255,255,0.92);
}

.form-textarea {
  resize: vertical;
  min-height: 80px;
}

/* ── Alerts ─────────────────────────────────────────────────────────────────── */
.alert {
  padding: 12px 16px;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 500;
}

.alert--error {
  background: rgba(248,113,113,0.1);
  border: 1px solid rgba(248,113,113,0.2);
  color: #f87171;
}

.alert--success {
  background: rgba(52,211,153,0.1);
  border: 1px solid rgba(52,211,153,0.2);
  color: #34d399;
}

/* ── Actions ────────────────────────────────────────────────────────────────── */
.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.btn {
  padding: 10px 22px;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  border: none;
  transition: all 0.2s;
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.btn--ghost {
  background: rgba(255,255,255,0.06);
  color: rgba(255,255,255,0.92);
  border: 1px solid rgba(255,255,255,0.07);
}

.btn--ghost:hover { background: rgba(255,255,255,0.1); }

.btn--primary {
  background: linear-gradient(135deg, #00c6ff, #0072ff);
  color: #fff;
}

.btn--primary:hover:not(:disabled) { opacity: 0.88; }

.btn--primary:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.spinner {
  width: 14px;
  height: 14px;
  border: 2px solid rgba(255,255,255,0.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}

@keyframes spin { to { transform: rotate(360deg); } }

/* ── Responsive ─────────────────────────────────────────────────────────────── */
@media (max-width: 560px) {
  .form-grid { grid-template-columns: 1fr; }

  .avatar-section {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }

  .avatar-meta { align-items: center; }

  .form-actions { flex-direction: column-reverse; }
  .btn { width: 100%; justify-content: center; }
}
</style>

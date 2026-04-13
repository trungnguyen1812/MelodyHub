<template>
  <div class="user-shell">
    <div class="bg-grid" aria-hidden="true"></div>

    <!-- Header -->
    <header class="topbar">
      <button class="back-btn" @click="$router.back()">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M7.793 2.232a.75.75 0 0 1-.025 1.06L3.622 7.25h10.003a5.375 5.375 0 0 1 0 10.75H10.75a.75.75 0 0 1 0-1.5h2.875a3.875 3.875 0 0 0 0-7.75H3.622l4.146 3.957a.75.75 0 0 1-1.036 1.085l-5.5-5.25a.75.75 0 0 1 0-1.085l5.5-5.25a.75.75 0 0 1 1.06.025Z" clip-rule="evenodd" />
        </svg>
        Users
      </button>
      <div class="topbar-center">
        <span class="topbar-label">New User</span>
      </div>
      <div style="width:90px"></div>
    </header>

    <div class="page-body">
      <!-- Left: form -->
      <div class="form-col">

        <!-- Basic info -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Basic information</h2>
              <p class="card-sub">Account credentials and personal details</p>
            </div>
          </div>

          <div class="fields">
            <div class="field-row two-col">
              <div class="field">
                <label class="flabel required">Full name</label>
                <input v-model="form.name" type="text" placeholder="John Doe" class="fcontrol" />
              </div>
              <div class="field">
                <label class="flabel required">Username</label>
                <input v-model="form.username" type="text" placeholder="johndoe" class="fcontrol" />
                <span class="fhint">Unique identifier for login</span>
              </div>
            </div>

            <div class="field-row two-col">
              <div class="field">
                <label class="flabel required">Email address</label>
                <input v-model="form.email" type="email" placeholder="user@example.com" class="fcontrol" />
              </div>
              <div class="field">
                <label class="flabel">Phone number</label>
                <input v-model="form.phone" type="tel" placeholder="+1 234 567 890" class="fcontrol" />
              </div>
            </div>

            <div class="field-row two-col">
              <div class="field">
                <label class="flabel required">Password</label>
                <div class="pass-row">
                  <input
                    v-model="form.password"
                    :type="showPass ? 'text' : 'password'"
                    placeholder="Min 8 characters"
                    class="fcontrol"
                  />
                  <button type="button" class="pass-toggle" @click="showPass = !showPass">
                    <svg v-if="!showPass" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15">
                      <path d="M10 12.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z" />
                      <path fill-rule="evenodd" d="M.664 10.59a1.651 1.651 0 0 1 0-1.186A10.004 10.004 0 0 1 10 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0 1 10 17c-4.257 0-7.893-2.66-9.336-6.41ZM14 10a4 4 0 1 1-8 0 4 4 0 0 1 8 0Z" clip-rule="evenodd" />
                    </svg>
                    <svg v-else xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15">
                      <path fill-rule="evenodd" d="M3.28 2.22a.75.75 0 0 0-1.06 1.06l14.5 14.5a.75.75 0 1 0 1.06-1.06l-1.745-1.745a10.029 10.029 0 0 0 3.3-4.38 1.651 1.651 0 0 0 0-1.185A10.004 10.004 0 0 0 9.999 3a9.956 9.956 0 0 0-4.744 1.194L3.28 2.22ZM7.752 6.69l1.092 1.092a2.5 2.5 0 0 1 3.374 3.373l1.091 1.092a4 4 0 0 0-5.557-5.557Z" clip-rule="evenodd" />
                      <path d="M10.748 13.93l2.523 2.523a10.055 10.055 0 0 1-3.27.547c-4.258 0-7.894-2.66-9.337-6.41a1.651 1.651 0 0 1 0-1.186A10.007 10.007 0 0 1 2.839 6.02L6.07 9.252a4 4 0 0 0 4.678 4.678Z" />
                    </svg>
                  </button>
                </div>
                <span class="fhint">Minimum 8 characters</span>
              </div>

              <div class="field">
                <label class="flabel">Date of birth</label>
                <input v-model="form.date_of_birth" type="date" class="fcontrol" />
              </div>
            </div>

            <div class="field">
              <label class="flabel">Gender</label>
              <div class="gender-pills">
                <button
                  v-for="g in genderOptions"
                  :key="g.value"
                  type="button"
                  class="gender-pill"
                  :class="{ active: form.gender === g.value }"
                  @click="form.gender = g.value"
                >{{ g.label }}</button>
              </div>
            </div>
          </div>
        </div>

        <!-- Profile -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M1.5 6a2.25 2.25 0 0 1 2.25-2.25h16.5A2.25 2.25 0 0 1 22.5 6v12a2.25 2.25 0 0 1-2.25 2.25H3.75A2.25 2.25 0 0 1 1.5 18V6ZM3 16.06V18c0 .414.336.75.75.75h16.5A.75.75 0 0 0 21 18v-1.94l-2.69-2.689a1.5 1.5 0 0 0-2.12 0l-.88.879.81.81a.75.75 0 1 1-1.06 1.06l-5.16-5.159a1.5 1.5 0 0 0-2.12 0L3 16.061Zm10.125-7.81a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Profile details</h2>
              <p class="card-sub">Avatar and biography</p>
            </div>
          </div>

          <div class="profile-layout">
            <!-- Avatar -->
            <div class="avatar-col">
              <div class="avatar-uploader" @click="fileInput?.click()">
                <img v-if="avatarPreview" :src="avatarPreview" alt="avatar" class="avatar-img" />
                <div v-else class="avatar-placeholder">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="32" height="32" style="color:rgba(255,255,255,0.15)">
                    <path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z" clip-rule="evenodd" />
                  </svg>
                </div>
                <div class="avatar-overlay">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
                    <path d="M5.433 13.917l1.262-3.155A4 4 0 0 1 7.58 9.42l6.92-6.918a2.121 2.121 0 0 1 3 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 0 1-.65-.65Z" />
                    <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0 0 10 3H4.75A2.75 2.75 0 0 0 2 5.75v9.5A2.75 2.75 0 0 0 4.75 18h9.5A2.75 2.75 0 0 0 17 15.25V10a.75.75 0 0 0-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5Z" />
                  </svg>
                  <span>{{ avatarPreview ? 'Change' : 'Upload' }}</span>
                </div>
              </div>
              <input type="file" ref="fileInput" accept="image/jpeg,image/png,image/gif,image/webp" @change="handleAvatarChange" style="display:none" />
              <p class="fhint" style="text-align:center;margin-top:8px">JPG, PNG, GIF · max 5MB</p>
            </div>

            <!-- Bio -->
            <div class="field" style="flex:1">
              <label class="flabel">Biography</label>
              <textarea v-model="form.bio" rows="6" placeholder="Tell us about this user…" class="fcontrol"></textarea>
              <span class="fhint">{{ form.bio?.length || 0 }}/500 characters</span>
            </div>
          </div>
        </div>

        <!-- Location -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="m11.54 22.351.07.04.028.016a.76.76 0 0 0 .723 0l.028-.015.071-.041a16.975 16.975 0 0 0 1.144-.742 19.58 19.58 0 0 0 2.683-2.282c1.944-2.003 3.5-4.697 3.5-8.327a8 8 0 1 0-16 0c0 3.63 1.556 6.324 3.5 8.327a19.592 19.592 0 0 0 2.682 2.282 16.975 16.975 0 0 0 1.144.742ZM12 13.5a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Location & preferences</h2>
              <p class="card-sub">Country and timezone settings</p>
            </div>
          </div>

          <div class="field-row two-col">
            <div class="field">
              <label class="flabel">Country</label>
              <select v-model="form.country" class="fcontrol">
                <option value="">Select country</option>
                <option value="US">United States</option>
                <option value="UK">United Kingdom</option>
                <option value="VN">Vietnam</option>
                <option value="JP">Japan</option>
                <option value="KR">South Korea</option>
                <option value="FR">France</option>
                <option value="DE">Germany</option>
              </select>
            </div>
            <div class="field">
              <label class="flabel">Timezone</label>
              <select v-model="form.timezone" class="fcontrol">
                <option value="">Select timezone</option>
                <option value="UTC">UTC+0</option>
                <option value="Asia/Ho_Chi_Minh">UTC+7 — Vietnam</option>
                <option value="America/New_York">UTC-5 — New York</option>
                <option value="Europe/London">UTC+0 — London</option>
                <option value="Asia/Tokyo">UTC+9 — Tokyo</option>
              </select>
            </div>
          </div>
        </div>

        <!-- Status & settings -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M11.078 2.25c-.917 0-1.699.663-1.85 1.567L9.05 4.889c-.02.12-.115.26-.297.348a7.493 7.493 0 0 0-.986.57c-.166.115-.334.126-.45.083L6.3 5.508a1.875 1.875 0 0 0-2.282.819l-.922 1.597a1.875 1.875 0 0 0 .432 2.385l.84.692c.095.078.17.229.154.43a7.598 7.598 0 0 0 0 1.139c.015.2-.059.352-.153.43l-.841.692a1.875 1.875 0 0 0-.432 2.385l.922 1.597a1.875 1.875 0 0 0 2.282.818l1.019-.382c.115-.043.283-.031.45.082.312.214.641.405.985.57.182.088.277.228.297.35l.178 1.071c.151.904.933 1.567 1.85 1.567h1.844c.916 0 1.699-.663 1.85-1.567l.178-1.072c.02-.12.114-.26.297-.349.344-.165.673-.356.985-.57.167-.114.335-.125.45-.082l1.02.382a1.875 1.875 0 0 0 2.28-.819l.923-1.597a1.875 1.875 0 0 0-.432-2.385l-.84-.692c-.095-.078-.17-.229-.154-.43a7.614 7.614 0 0 0 0-1.139c-.016-.2.059-.352.153-.43l.84-.692c.708-.582.891-1.59.433-2.385l-.922-1.597a1.875 1.875 0 0 0-2.282-.818l-1.02.382c-.114.043-.282.031-.449-.083a7.49 7.49 0 0 0-.985-.57c-.183-.087-.277-.227-.297-.348l-.179-1.072a1.875 1.875 0 0 0-1.85-1.567h-1.843ZM12 15.75a3.75 3.75 0 1 0 0-7.5 3.75 3.75 0 0 0 0 7.5Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Status & settings</h2>
              <p class="card-sub">Account visibility and publish date</p>
            </div>
          </div>

          <div class="fields">
            <div class="field-row two-col">
              <div class="field">
                <label class="flabel">Account status</label>
                <div class="status-pills">
                  <button
                    v-for="s in statusOptions"
                    :key="s.value"
                    type="button"
                    class="status-pill"
                    :class="[s.color, { active: form.status === s.value }]"
                    @click="form.status = s.value"
                  >
                    <span class="spill-dot"></span>
                    {{ s.label }}
                  </button>
                </div>
              </div>
              <div class="field">
                <label class="flabel">Publish date</label>
                <input v-model="form.published_at" type="datetime-local" class="fcontrol" />
              </div>
            </div>
          </div>
        </div>

        <!-- SEO -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M10.5 3.75a6.75 6.75 0 1 0 0 13.5 6.75 6.75 0 0 0 0-13.5ZM2.25 10.5a8.25 8.25 0 1 1 14.59 5.28l4.69 4.69a.75.75 0 1 1-1.06 1.06l-4.69-4.69A8.25 8.25 0 0 1 2.25 10.5Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">SEO information</h2>
              <p class="card-sub">How this profile appears in search engines</p>
            </div>
          </div>

          <div class="fields">
            <div class="field">
              <label class="flabel">SEO title</label>
              <input v-model="form.seo_title" type="text" placeholder="User Name | Platform" class="fcontrol" />
              <span class="fhint">{{ form.seo_title?.length || 0 }}/60 chars</span>
            </div>
            <div class="field">
              <label class="flabel">SEO description</label>
              <textarea v-model="form.seo_description" rows="3" placeholder="Brief description for search engines…" class="fcontrol"></textarea>
              <span class="fhint">{{ form.seo_description?.length || 0 }}/160 chars</span>
            </div>
          </div>
        </div>

        <!-- Actions -->
        <div class="form-actions">
          <button type="button" class="btn ghost" @click="$router.back()">Cancel</button>
          <button type="button" class="btn primary" @click="submitForm" :disabled="loading">
            <span v-if="loading" class="btn-spinner"></span>
            <template v-else>
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
                <path d="M10.75 4.75a.75.75 0 0 0-1.5 0v4.5h-4.5a.75.75 0 0 0 0 1.5h4.5v4.5a.75.75 0 0 0 1.5 0v-4.5h4.5a.75.75 0 0 0 0-1.5h-4.5v-4.5Z" />
              </svg>
              Create user
            </template>
          </button>
        </div>
      </div>

      <!-- Right: preview -->
      <div class="preview-col">
        <div class="preview-sticky">
          <p class="preview-label">Live preview</p>

          <!-- User card -->
          <div class="user-card-preview">
            <div class="ucp-avatar">
              <img v-if="avatarPreview" :src="avatarPreview" alt="avatar" />
              <div v-else class="ucp-avatar-fallback">
                {{ form.name ? form.name.charAt(0).toUpperCase() : '?' }}
              </div>
            </div>
            <div class="ucp-info">
              <span class="ucp-name">{{ form.name || 'Full name' }}</span>
              <span class="ucp-username">@{{ form.username || 'username' }}</span>
              <span class="ucp-email">{{ form.email || 'email@example.com' }}</span>
              <div class="ucp-tags">
                <span class="ucp-status" :class="form.status">{{ form.status || 'active' }}</span>
                <span v-if="form.country" class="ucp-country">{{ form.country }}</span>
              </div>
            </div>
          </div>

          <!-- Summary -->
          <div class="field-summary">
            <div class="fs-row">
              <span class="fs-key">Status</span>
              <span class="fs-val" :style="{ color: statusColor }">{{ form.status || '—' }}</span>
            </div>
            <div class="fs-row">
              <span class="fs-key">Gender</span>
              <span class="fs-val">{{ form.gender || '—' }}</span>
            </div>
            <div class="fs-row">
              <span class="fs-key">Country</span>
              <span class="fs-val">{{ form.country || '—' }}</span>
            </div>
            <div class="fs-row">
              <span class="fs-key">Timezone</span>
              <span class="fs-val">{{ form.timezone || '—' }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, computed } from 'vue'
import router from '@/modules/router'
import type { CreateUserPayload } from '@/modules/admin/interfaces/users/create-user.payload'
import { useUserStore } from '@/modules/admin/stores/users/userStore'
import { useNotificationStore } from '@/store/notificationStore'

const notificationStore = useNotificationStore()
const userStore = useUserStore()
const loading = ref(false)
const showPass = ref(false)
const avatarPreview = ref<string>('')
const fileInput = ref<HTMLInputElement | null>(null)

const genderOptions = [
  { value: 'male', label: 'Male' },
  { value: 'female', label: 'Female' },
  { value: 'other', label: 'Other' },
  { value: 'prefer_not_to_say', label: 'Prefer not to say' },
]as const;

const statusOptions = [
  { value: 'active', label: 'Active', color: 'green' },
  { value: 'inactive', label: 'Inactive', color: 'gray' },
  { value: 'pending', label: 'Pending', color: 'amber' },
  { value: 'suspended', label: 'Suspended', color: 'red' },
]as const;

const form = reactive<CreateUserPayload>({
  name: '',
  username: '',
  email: '',
  password: '',
  phone: '',
  date_of_birth: '',
  gender: '',
  bio: '',
  avatar: null,
  country: '',
  timezone: '',
  status: 'active',
  published_at: '',
  seo_title: '',
  seo_description: '',
})

const statusColor = computed(() => {
  const map: Record<string, string> = {
    active: '#00c87a',
    inactive: 'rgba(255,255,255,0.4)',
    pending: '#fac800',
    suspended: '#e24b4a',
  }
  return map[form.status] || 'rgba(255,255,255,0.4)'
})

const handleAvatarChange = (event: Event) => {
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
  form.avatar = file
  const reader = new FileReader()
  reader.onload = e => { avatarPreview.value = e.target?.result as string }
  reader.readAsDataURL(file)
}

const submitForm = async () => {
  if (!form.name || !form.email || !form.password) {
    notificationStore.notify('Please fill in all required fields', 'error')
    return
  }
  try {
    loading.value = true
    await userStore.fetchAddUser(form)
    await userStore.fetchUsers()
    notificationStore.notify('User created successfully!', 'success')
    router.push({ name: 'admin.usermanager.all' })
  } catch (err: any) {
    notificationStore.notify(err.response?.data?.message || 'Failed to create user', 'error')
  } finally {
    loading.value = false
    setTimeout(() => notificationStore.clear(), 3000)
  }
}
</script>

<style scoped>
/* ── Base ───────────────────────────────────────── */
.user-shell {
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

.flabel { font-size: 13px; font-weight: 500; color: rgba(255,255,255,0.6); }
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

/* Password field */
.pass-row { position: relative; }
.pass-row .fcontrol { padding-right: 42px; }
.pass-toggle {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: rgba(255,255,255,0.3);
  cursor: pointer;
  padding: 4px;
  display: flex;
  align-items: center;
  transition: color 0.15s;
}
.pass-toggle:hover { color: rgba(255,255,255,0.7); }

/* Gender pills */
.gender-pills { display: flex; flex-wrap: wrap; gap: 8px; }
.gender-pill {
  padding: 6px 14px;
  border-radius: 100px;
  border: 1px solid rgba(255,255,255,0.1);
  background: rgba(255,255,255,0.04);
  color: rgba(255,255,255,0.5);
  font-size: 13px;
  cursor: pointer;
  transition: all 0.15s;
  font-family: inherit;
}
.gender-pill:hover { border-color: rgba(255,255,255,0.25); color: #fff; }
.gender-pill.active {
  background: rgba(0,160,255,0.15);
  border-color: rgba(0,160,255,0.5);
  color: #00aaff;
}

/* Status pills */
.status-pills { display: flex; flex-wrap: wrap; gap: 8px; }
.status-pill {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 7px 14px;
  border-radius: 100px;
  border: 1px solid rgba(255,255,255,0.1);
  background: rgba(255,255,255,0.04);
  color: rgba(255,255,255,0.5);
  font-size: 13px;
  cursor: pointer;
  transition: all 0.15s;
  font-family: inherit;
}
.spill-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: currentColor;
  opacity: 0.5;
}
.status-pill.active .spill-dot { opacity: 1; }

.status-pill.green.active  { background: rgba(0,200,120,0.12); border-color: rgba(0,200,120,0.4); color: #00c87a; }
.status-pill.amber.active  { background: rgba(250,200,0,0.1);  border-color: rgba(250,200,0,0.35); color: #fac800; }
.status-pill.red.active    { background: rgba(226,75,74,0.12); border-color: rgba(226,75,74,0.4); color: #e24b4a; }
.status-pill.gray.active   { background: rgba(255,255,255,0.07); border-color: rgba(255,255,255,0.2); color: rgba(255,255,255,0.7); }

/* ── Profile layout ─────────────────────────────── */
.profile-layout {
  display: flex;
  gap: 24px;
  align-items: flex-start;
}

.avatar-col { display: flex; flex-direction: column; align-items: center; }

.avatar-uploader {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  overflow: hidden;
  border: 2px dashed rgba(255,255,255,0.15);
  position: relative;
  cursor: pointer;
  transition: border-color 0.2s;
  flex-shrink: 0;
}
.avatar-uploader:hover { border-color: #00aaff; }
.avatar-uploader:hover .avatar-overlay { opacity: 1; }

.avatar-img { width: 100%; height: 100%; object-fit: cover; display: block; }

.avatar-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255,255,255,0.04);
}

.avatar-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.65);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 5px;
  color: #fff;
  font-size: 12px;
  opacity: 0;
  transition: opacity 0.2s;
}

/* ── Toggle card (shared) ───────────────────────── */
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
.toggle-card.on { border-color: rgba(0,170,255,0.3); background: rgba(0,160,255,0.07); }

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

/* User card preview */
.user-card-preview {
  background: rgba(255,255,255,0.03);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 14px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
}

.ucp-avatar {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  overflow: hidden;
  flex-shrink: 0;
  background: rgba(0,160,255,0.15);
  border: 1px solid rgba(0,160,255,0.2);
  display: flex;
  align-items: center;
  justify-content: center;
}
.ucp-avatar img { width: 100%; height: 100%; object-fit: cover; }
.ucp-avatar-fallback { font-size: 22px; font-weight: 700; color: #00aaff; }

.ucp-info { display: flex; flex-direction: column; gap: 3px; min-width: 0; }
.ucp-name { font-size: 15px; font-weight: 600; color: #fff; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.ucp-username { font-size: 12px; color: rgba(255,255,255,0.4); }
.ucp-email { font-size: 11px; color: rgba(255,255,255,0.3); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

.ucp-tags { display: flex; gap: 6px; flex-wrap: wrap; margin-top: 4px; }
.ucp-status {
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 100px;
  text-transform: capitalize;
}
.ucp-status.active   { background: rgba(0,200,120,0.12);  border: 1px solid rgba(0,200,120,0.3);  color: #00c87a; }
.ucp-status.inactive { background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); color: rgba(255,255,255,0.5); }
.ucp-status.pending  { background: rgba(250,200,0,0.1);    border: 1px solid rgba(250,200,0,0.3);  color: #fac800; }
.ucp-status.suspended{ background: rgba(226,75,74,0.12);   border: 1px solid rgba(226,75,74,0.3);  color: #e24b4a; }

.ucp-country {
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 100px;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.4);
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
.fs-val { font-size: 12px; color: rgba(255,255,255,0.7); text-align: right; text-transform: capitalize; }

/* ── Responsive ─────────────────────────────────── */
@media (max-width: 860px) {
  .page-body { grid-template-columns: 1fr; }
  .preview-col { order: -1; }
  .preview-sticky { position: static; }
  .field-row.two-col { grid-template-columns: 1fr; }
  .profile-layout { flex-direction: column; align-items: center; }
}
</style>
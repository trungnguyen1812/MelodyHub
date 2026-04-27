<template>
  <div class="change-pass-page">
    <div class="change-pass-page__ambient" />

    <div class="change-pass-container">
      <!-- Header -->
      <div class="change-pass-header">
        <button class="btn-back" @click="router.back()">
          <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
          </svg>
          Back
        </button>
        <h1 class="change-pass-header__title">Change Password</h1>
      </div>

      <!-- Card -->
      <div class="change-pass-card">
        <div class="change-pass-card__header">
          <div class="change-pass-card__icon">
            <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
            </svg>
          </div>
          <h2 class="change-pass-card__title">Update your password</h2>
        </div>

        <form class="change-pass-form" @submit.prevent="handleSubmit">
          <!-- Current password -->
          <div class="form-group">
            <label class="form-label">Current Password</label>
            <div class="input-wrap">
              <input
                v-model="form.current_password"
                :type="showCurrent ? 'text' : 'password'"
                class="form-input"
                placeholder="Enter current password"
                autocomplete="current-password"
              />
              <button type="button" class="eye-btn" @click="showCurrent = !showCurrent" tabindex="-1">
                <svg v-if="!showCurrent" width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                </svg>
                <svg v-else width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/>
                </svg>
              </button>
            </div>
            <p v-if="fieldErrors.current_password" class="field-error">
              {{ fieldErrors.current_password }}
            </p>
          </div>

          <!-- New password -->
          <div class="form-group">
            <label class="form-label">New Password</label>
            <div class="input-wrap">
              <input
                v-model="form.new_password"
                :type="showNew ? 'text' : 'password'"
                class="form-input"
                placeholder="At least 8 characters"
                autocomplete="new-password"
              />
              <button type="button" class="eye-btn" @click="showNew = !showNew" tabindex="-1">
                <svg v-if="!showNew" width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                </svg>
                <svg v-else width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/>
                </svg>
              </button>
            </div>
            <!-- Strength bar -->
            <div class="strength-bar">
              <div
                class="strength-bar__fill"
                :style="{ width: strengthPercent + '%' }"
                :class="strengthClass"
              />
            </div>
            <p class="strength-label" :class="strengthClass">{{ strengthLabel }}</p>
            <p v-if="fieldErrors.new_password" class="field-error">
              {{ fieldErrors.new_password }}
            </p>
          </div>

          <!-- Confirm password -->
          <div class="form-group">
            <label class="form-label">Confirm New Password</label>
            <div class="input-wrap">
              <input
                v-model="form.new_password_confirmation"
                :type="showConfirm ? 'text' : 'password'"
                class="form-input"
                :class="{ 'form-input--error': confirmMismatch }"
                placeholder="Repeat new password"
                autocomplete="new-password"
              />
              <button type="button" class="eye-btn" @click="showConfirm = !showConfirm" tabindex="-1">
                <svg v-if="!showConfirm" width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                </svg>
                <svg v-else width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/>
                </svg>
              </button>
            </div>
            <p v-if="confirmMismatch" class="field-error">Passwords do not match</p>
          </div>

          <!-- Alerts -->
          <div v-if="errorMsg" class="alert alert--error">{{ errorMsg }}</div>
          <div v-if="successMsg" class="alert alert--success">{{ successMsg }}</div>

          <!-- Actions -->
          <div class="form-actions">
            <button type="button" class="btn btn--ghost" @click="router.back()">Cancel</button>
            <button
              type="submit"
              class="btn btn--primary"
              :disabled="isLoading || confirmMismatch || !form.current_password || !form.new_password"
            >
              <span v-if="isLoading" class="spinner" />
              {{ isLoading ? 'Updating...' : 'Update Password' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import AuthService from '@/services/auth.service'

const router = useRouter()

const isLoading = ref(false)
const errorMsg = ref('')
const successMsg = ref('')
const fieldErrors = reactive<Record<string, string>>({})

const showCurrent = ref(false)
const showNew = ref(false)
const showConfirm = ref(false)

const form = reactive({
  current_password: '',
  new_password: '',
  new_password_confirmation: '',
})

// Password strength
const strengthPercent = computed(() => {
  const p = form.new_password
  if (!p) return 0
  let score = 0
  if (p.length >= 8)  score += 25
  if (p.length >= 12) score += 15
  if (/[A-Z]/.test(p)) score += 20
  if (/[0-9]/.test(p)) score += 20
  if (/[^A-Za-z0-9]/.test(p)) score += 20
  return Math.min(score, 100)
})

const strengthClass = computed(() => {
  const s = strengthPercent.value
  if (s === 0)   return ''
  if (s <= 30)   return 'strength--weak'
  if (s <= 60)   return 'strength--fair'
  if (s <= 80)   return 'strength--good'
  return 'strength--strong'
})

const strengthLabel = computed(() => {
  const s = strengthPercent.value
  if (s === 0)   return ''
  if (s <= 30)   return 'Weak'
  if (s <= 60)   return 'Fair'
  if (s <= 80)   return 'Good'
  return 'Strong'
})

const confirmMismatch = computed(() =>
  !!form.new_password_confirmation &&
  form.new_password !== form.new_password_confirmation
)

const handleSubmit = async () => {
  errorMsg.value = ''
  successMsg.value = ''
  Object.keys(fieldErrors).forEach(k => delete fieldErrors[k])

  if (form.new_password.length < 8) {
    fieldErrors.new_password = 'Password must be at least 8 characters'
    return
  }

  if (confirmMismatch.value) return

  isLoading.value = true
  try {
    await AuthService.changePassword({
      current_password: form.current_password,
      new_password: form.new_password,
      new_password_confirmation: form.new_password_confirmation,
    })
    successMsg.value = 'Password updated successfully!'
    form.current_password = ''
    form.new_password = ''
    form.new_password_confirmation = ''
    setTimeout(() => router.push('/profile'), 1500)
  } catch (err: any) {
    const data = err?.response?.data
    if (data?.errors) {
      Object.assign(fieldErrors, Object.fromEntries(
        Object.entries(data.errors).map(([k, v]) => [k, (v as string[])[0]])
      ))
    }
    errorMsg.value = data?.message ?? 'Failed to update password. Please try again.'
  } finally {
    isLoading.value = false
  }
}
</script>

<style scoped>
.change-pass-page {
  min-height: 100vh;
  background: #080b11;
  color: rgba(255,255,255,0.92);
  position: relative;
  font-family: 'DM Sans', system-ui, sans-serif;
}

.change-pass-page__ambient {
  position: fixed;
  inset: 0;
  pointer-events: none;
  background:
    radial-gradient(ellipse 60% 40% at 10% 0%, rgba(0,198,255,0.07) 0%, transparent 70%),
    radial-gradient(ellipse 50% 50% at 90% 100%, rgba(167,139,250,0.06) 0%, transparent 70%);
}

.change-pass-container {
  max-width: 520px;
  margin: 0 auto;
  padding: 40px 24px 80px;
  position: relative;
}

/* Header */
.change-pass-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 28px;
}

.change-pass-header__title {
  font-size: 22px;
  font-weight: 700;
  margin: 0;
  background: linear-gradient(90deg, #fff 40%, #a78bfa);
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

/* Card */
.change-pass-card {
  background: rgba(255,255,255,0.035);
  border: 1px solid rgba(255,255,255,0.07);
  border-radius: 18px;
  overflow: hidden;
  backdrop-filter: blur(8px);
}

.change-pass-card__header {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 18px 24px;
  border-bottom: 1px solid rgba(255,255,255,0.07);
}

.change-pass-card__icon {
  width: 34px;
  height: 34px;
  border-radius: 10px;
  background: rgba(167,139,250,0.1);
  color: #a78bfa;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.change-pass-card__title {
  font-size: 15px;
  font-weight: 600;
  margin: 0;
}

/* Form */
.change-pass-form {
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-label {
  font-size: 11px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: rgba(255,255,255,0.38);
}

.input-wrap {
  position: relative;
}

.form-input {
  width: 100%;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.08);
  border-radius: 10px;
  padding: 10px 42px 10px 14px;
  font-size: 14px;
  color: rgba(255,255,255,0.92);
  outline: none;
  transition: border-color 0.2s, background 0.2s;
  box-sizing: border-box;
  font-family: inherit;
}

.form-input:focus {
  border-color: rgba(167,139,250,0.4);
  background: rgba(167,139,250,0.04);
}

.form-input::placeholder {
  color: rgba(255,255,255,0.22);
}

.form-input--error {
  border-color: rgba(248,113,113,0.4) !important;
}

.eye-btn {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  color: rgba(255,255,255,0.35);
  cursor: pointer;
  padding: 2px;
  display: flex;
  align-items: center;
  transition: color 0.2s;
}

.eye-btn:hover {
  color: rgba(255,255,255,0.7);
}

/* Strength bar */
.strength-bar {
  height: 3px;
  background: rgba(255,255,255,0.08);
  border-radius: 2px;
  overflow: hidden;
  margin-top: 4px;
}

.strength-bar__fill {
  height: 100%;
  border-radius: 2px;
  transition: width 0.3s, background 0.3s;
}

.strength--weak   .strength-bar__fill,
.strength-bar__fill.strength--weak   { background: #f87171; }
.strength--fair   .strength-bar__fill,
.strength-bar__fill.strength--fair   { background: #fb923c; }
.strength--good   .strength-bar__fill,
.strength-bar__fill.strength--good   { background: #fbbf24; }
.strength--strong .strength-bar__fill,
.strength-bar__fill.strength--strong { background: #34d399; }

.strength-label {
  font-size: 11px;
  font-weight: 500;
  margin: 0;
}

.strength-label.strength--weak   { color: #f87171; }
.strength-label.strength--fair   { color: #fb923c; }
.strength-label.strength--good   { color: #fbbf24; }
.strength-label.strength--strong { color: #34d399; }

.field-error {
  font-size: 12px;
  color: #f87171;
  margin: 0;
}

/* Alerts */
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

/* Actions */
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

.btn--ghost:hover {
  background: rgba(255,255,255,0.1);
}

.btn--primary {
  background: linear-gradient(135deg, #a78bfa, #7c3aed);
  color: #fff;
}

.btn--primary:hover:not(:disabled) {
  opacity: 0.88;
}

.btn--primary:disabled {
  opacity: 0.45;
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

@keyframes spin {
  to { transform: rotate(360deg); }
}

@media (max-width: 480px) {
  .form-actions {
    flex-direction: column-reverse;
  }
  .btn { width: 100%; justify-content: center; }
}
</style>

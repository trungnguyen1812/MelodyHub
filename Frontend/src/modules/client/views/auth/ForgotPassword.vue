
<template>
  <div class="flex flex-col items-center justify-center min-h-screen px-6 py-8">
    <div class="p-6 rounded-lg shadow-md">

      <!-- Step 1: Enter email -->
      <form v-if="step === 'email'" class="form" @submit.prevent="handleSubmit">
        <!-- Back to login -->
        <button type="button" class="back-btn" @click="goToLogin">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
            <path fill-rule="evenodd" d="M17 10a.75.75 0 0 1-.75.75H5.612l4.158 3.96a.75.75 0 1 1-1.04 1.08l-5.5-5.25a.75.75 0 0 1 0-1.08l5.5-5.25a.75.75 0 1 1 1.04 1.08L5.612 9.25H16.25A.75.75 0 0 1 17 10Z" clip-rule="evenodd" />
          </svg>
          Back to Login
        </button>

        <div class="form-icon-wrap">
          <div class="form-icon">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="32" height="32">
              <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 1 0-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 0 0 2.25-2.25v-6.75a2.25 2.25 0 0 0-2.25-2.25H6.75a2.25 2.25 0 0 0-2.25 2.25v6.75a2.25 2.25 0 0 0 2.25 2.25Z" />
            </svg>
          </div>
        </div>

        <h2 class="form-title">Forgot Password?</h2>
        <p class="form-subtitle">Enter your email address and we'll send you a new password.</p>

        <div class="flex-column">
          <label>Email Address</label>
        </div>
        <div class="inputForm" :class="{ 'inputForm--error': emailError }">
          <svg height="20" viewBox="0 0 32 32" width="20" xmlns="http://www.w3.org/2000/svg">
            <g id="Layer_3" data-name="Layer 3">
              <path d="m30.853 13.87a15 15 0 0 0 -29.729 4.082 15.1 15.1 0 0 0 12.876 12.918 15.6 15.6 0 0 0 2.016.13 14.85 14.85 0 0 0 7.715-2.145 1 1 0 1 0 -1.031-1.711 13.007 13.007 0 1 1 5.458-6.529 2.149 2.149 0 0 1 -4.158-.759v-10.856a1 1 0 0 0 -2 0v1.726a8 8 0 1 0 .2 10.325 4.135 4.135 0 0 0 7.83.274 15.2 15.2 0 0 0 .823-7.455zm-14.853 8.13a6 6 0 1 1 6-6 6.006 6.006 0 0 1 -6 6z"></path>
            </g>
          </svg>
          <input
            v-model="email"
            type="email"
            class="input"
            placeholder="Enter your email address"
            :disabled="isLoading"
            @input="emailError = ''"
            autocomplete="email"
          />
        </div>
        <p v-if="emailError" class="error-msg">{{ emailError }}</p>

        <!-- Error alert -->
        <div v-if="errorMsg" class="alert alert--error">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
            <path fill-rule="evenodd" d="M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-8-5a.75.75 0 0 1 .75.75v4.5a.75.75 0 0 1-1.5 0v-4.5A.75.75 0 0 1 10 5Zm0 10a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z" clip-rule="evenodd" />
          </svg>
          {{ errorMsg }}
        </div>

        <button class="button-submit" type="submit" :disabled="isLoading">
          <span v-if="!isLoading">Send New Password</span>
          <span v-else class="button-loading">
            <span class="button-spinner"></span>
            Sending...
          </span>
        </button>

        <p class="p">
          Remember your password?
          <button type="button" class="span" @click="goToLogin">Sign In</button>
        </p>
      </form>

      <!-- Step 2: Success -->
      <div v-else class="form success-card">
        <div class="success-icon">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="48" height="48">
            <path stroke-linecap="round" stroke-linejoin="round" d="M21.75 6.75v10.5a2.25 2.25 0 0 1-2.25 2.25h-15a2.25 2.25 0 0 1-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0 0 19.5 4.5h-15a2.25 2.25 0 0 0-2.25 2.25m19.5 0v.243a2.25 2.25 0 0 1-1.07 1.916l-7.5 4.615a2.25 2.25 0 0 1-2.36 0L3.32 8.91a2.25 2.25 0 0 1-1.07-1.916V6.75" />
          </svg>
        </div>
        <h2 class="form-title">Check Your Email!</h2>
        <p class="form-subtitle">
          We've sent a new password to <strong>{{ email }}</strong>.
          Please check your inbox and log in with the new password.
        </p>
        <p class="form-hint">Don't forget to change your password after logging in.</p>

        <button class="button-submit" type="button" @click="goToLogin">
          Back to Login
        </button>

        <p class="p resend-text">
          Didn't receive the email?
          <button type="button" class="span" @click="step = 'email'; errorMsg = ''" :disabled="isLoading">
            Try again
          </button>
        </p>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import AuthService from '@/services/auth.service'

const router   = useRouter()
const step     = ref<'email' | 'success'>('email')
const email    = ref('')
const isLoading = ref(false)
const emailError = ref('')
const errorMsg  = ref('')

const goToLogin = () => router.push({ name: 'Login' })

const validateEmail = (val: string): boolean => {
  if (!val.trim()) {
    emailError.value = 'Email is required.'
    return false
  }
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) {
    emailError.value = 'Please enter a valid email address.'
    return false
  }
  return true
}

const handleSubmit = async () => {
  emailError.value = ''
  errorMsg.value   = ''

  if (!validateEmail(email.value)) return

  isLoading.value = true
  try {
    await AuthService.forgotPassword(email.value.trim())
    step.value = 'success'
  } catch (err: any) {
    const msg = err?.response?.data?.message
    if (err?.response?.status === 429) {
      errorMsg.value = msg || 'Too many attempts. Please wait a moment and try again.'
    } else {
      errorMsg.value = msg || 'Something went wrong. Please try again.'
    }
  } finally {
    isLoading.value = false
  }
}
</script>

<style scoped>
.form {
  display: flex;
  flex-direction: column;
  gap: 10px;
  background-color: #ffffff;
  padding: 30px;
  width: 450px;
  border-radius: 20px;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
}

::placeholder {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
}

/* Back button */
.back-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background: none;
  border: none;
  color: #6b7280;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  padding: 0;
  margin-bottom: 8px;
  transition: color 0.2s;
  align-self: flex-start;
}
.back-btn:hover { color: #2d79f3; }

/* Icon */
.form-icon-wrap {
  display: flex;
  justify-content: center;
  margin: 8px 0 4px;
}
.form-icon {
  width: 72px;
  height: 72px;
  border-radius: 50%;
  background: linear-gradient(135deg, #e8f0fe 0%, #d2e3fc 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #2d79f3;
}

/* Title */
.form-title {
  text-align: center;
  font-size: 22px;
  font-weight: 700;
  color: #151717;
  margin: 4px 0 0;
}
.form-subtitle {
  text-align: center;
  font-size: 14px;
  color: #6b7280;
  margin: 0 0 8px;
  line-height: 1.5;
}
.form-hint {
  text-align: center;
  font-size: 12px;
  color: #9ca3af;
  margin: 0;
  font-style: italic;
}

/* Label */
.flex-column > label {
  color: #151717;
  font-weight: 600;
  font-size: 14px;
}

/* Input */
.inputForm {
  border: 1.5px solid #ecedec;
  border-radius: 10px;
  height: 50px;
  display: flex;
  align-items: center;
  padding-left: 10px;
  transition: 0.2s ease-in-out;
}
.inputForm:focus-within { border: 1.5px solid #2d79f3; }
.inputForm--error { border-color: #ef4444 !important; }

.input {
  margin-left: 10px;
  border-radius: 10px;
  color: #151717;
  border: none;
  width: 85%;
  height: 100%;
  font-size: 14px;
}
.input:focus { outline: none; }
.input:disabled { background-color: #f5f5f5; cursor: not-allowed; }

/* Error */
.error-msg {
  font-size: 12px;
  color: #ef4444;
  margin: -4px 0 0;
}

/* Alert */
.alert {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  padding: 12px 14px;
  border-radius: 10px;
  font-size: 13px;
  line-height: 1.5;
}
.alert--error {
  background: #fef2f2;
  border: 1px solid #fecaca;
  color: #dc2626;
}

/* Submit button */
.button-submit {
  margin: 12px 0 6px;
  background-color: #151717;
  border: none;
  color: white;
  font-size: 15px;
  font-weight: 500;
  border-radius: 10px;
  height: 50px;
  width: 100%;
  cursor: pointer;
  transition: all 0.3s ease;
}
.button-submit:hover:not(:disabled) { background-color: #252727; }
.button-submit:disabled { opacity: 0.7; cursor: not-allowed; }

.button-loading {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}
.button-spinner {
  width: 18px;
  height: 18px;
  border: 2px solid rgba(255,255,255,0.3);
  border-top: 2px solid white;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

/* Footer text */
.p {
  text-align: center;
  color: black;
  font-size: 14px;
  margin: 4px 0;
}
.span {
  font-size: 14px;
  margin-left: 4px;
  color: #2d79f3;
  font-weight: 500;
  cursor: pointer;
  background: none;
  border: none;
  padding: 0;
}
.span:hover { text-decoration: underline; }
.span:disabled { opacity: 0.6; cursor: not-allowed; }

/* Success card */
.success-card { gap: 14px; }
.success-icon {
  display: flex;
  justify-content: center;
  margin: 8px 0 4px;
}
.success-icon svg {
  color: #10b981;
  background: #d1fae5;
  border-radius: 50%;
  padding: 12px;
  width: 72px;
  height: 72px;
}
.resend-text { margin-top: 4px; }

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

@media (max-width: 480px) {
  .form { width: 100%; max-width: 400px; padding: 24px 20px; }
}
</style>

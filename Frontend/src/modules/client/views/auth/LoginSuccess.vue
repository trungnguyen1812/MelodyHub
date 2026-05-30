<template>
  <div class="login-loading">
    <div v-if="!errorMsg" class="loader-wrap">
      <div class="loader"></div>
      <p>Signing in with Google...</p>
    </div>
    <div v-else class="error-wrap">
      <svg width="48" height="48" fill="none" stroke="#f87171" stroke-width="1.5" viewBox="0 0 24 24">
        <circle cx="12" cy="12" r="10"/>
        <line x1="12" y1="8" x2="12" y2="12"/>
        <line x1="12" y1="16" x2="12.01" y2="16"/>
      </svg>
      <p>{{ errorMsg }}</p>
      <button @click="goToLogin">Back to Login</button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '@/store/authStore'
import { useUserStore } from '@/modules/client/stores/users/UserStore'

const route     = useRoute()
const router    = useRouter()
const authStore = useAuthStore()
const userStore = useUserStore()
const errorMsg  = ref('')

const goToLogin = () => router.push({ name: 'Login' })

onMounted(async () => {
  const token = route.query.token as string | undefined
  const error = route.query.error as string | undefined

  // Handle error from backend
  if (error) {
    const messages: Record<string, string> = {
      oauth_failed:   'Google sign-in failed. Please try again.',
      account_banned: 'Your account has been suspended. Please contact support.',
    }
    errorMsg.value = messages[error] ?? 'An error occurred during sign-in.'
    setTimeout(() => router.push({ name: 'Login' }), 3000)
    return
  }

  if (!token) {
    errorMsg.value = 'No authentication token received.'
    setTimeout(() => router.push({ name: 'Login' }), 2000)
    return
  }

  // Save token
  localStorage.setItem('client_token', token)
  authStore.token = token
  authStore.isAuthenticated = true

  try {
    // Load full user info + permissions
    const data = await authStore.checkPermission()

    // Save user to localStorage
    if (authStore.user) {
      localStorage.setItem('auth_user', JSON.stringify(authStore.user))
    }

    // Load subscription status
    try {
      await userStore.fetchSubscriptionStatus()
    } catch {
      // non-critical
    }

    // Redirect based on role
    const isAdmin = data?.is_admin ?? authStore.isAdmin
    router.replace(isAdmin ? '/admin/dashboard' : '/')
  } catch (err: any) {
    // Token might be valid but checkPermission failed — still go home
    console.error('Post-Google-login setup error:', err)
    router.replace('/')
  }
})
</script>

<style scoped>
.login-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: #080e14;
  color: #fff;
  font-family: 'Inter', sans-serif;
  gap: 20px;
}

.loader-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
}

.loader-wrap p {
  font-size: 16px;
  color: rgba(255,255,255,0.6);
}

.loader {
  width: 48px;
  height: 48px;
  border: 4px solid rgba(255,255,255,0.1);
  border-top-color: #4285f4;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

.error-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
  text-align: center;
  padding: 32px;
}

.error-wrap p {
  font-size: 15px;
  color: rgba(255,255,255,0.7);
  max-width: 320px;
}

.error-wrap button {
  padding: 10px 24px;
  background: #4285f4;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s;
}

.error-wrap button:hover {
  background: #5a95f5;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>

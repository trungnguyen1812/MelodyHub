<template>
  <div class="profile-page">
    <!-- Ambient background -->
    <div class="profile-page__ambient" />

    <div class="profile-container">

      <!-- ── Hero section ─────────────────────────────────────────────────── -->
      <div class="profile-hero">
        <div class="profile-hero__avatar-wrap">
          <div class="profile-hero__avatar-ring">
            <img
                v-if="user?.avatar_url && user.avatar_url !== ''"
                :src="getFullImageUrl(user.avatar_url)"
                :alt="user?.name"
                class="profile-hero__avatar"
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
          <button class="profile-hero__avatar-btn" @click="openChangeAvatar" title="Change avatar">
            <svg width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"/>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"/>
            </svg>
          </button>
        </div>

        <div class="profile-hero__meta">
          <div class="profile-hero__badges">
            <span v-if="rolesFlags.is_boss" class="badge badge--boss">👑 Boss</span>
            <span v-if="rolesFlags.is_admin" class="badge badge--admin">Admin</span>
            <span v-if="rolesFlags.is_partner" class="badge badge--partner">Partner</span>
            <span v-if="partnerInfo?.status === 'active'" class="badge badge--active">
              <span class="badge__dot" /> Active
            </span>
          </div>
          <h1 class="profile-hero__name">{{ user?.name }}</h1>
          <p class="profile-hero__handle">@{{ user?.name }}</p>

          <div class="profile-hero__stats">
            <div class="hero-stat">
              <span class="hero-stat__value">{{ formatCurrency(user?.wallet_balance) }}</span>
              <span class="hero-stat__label">Balance</span>
            </div>
            <div class="hero-stat__divider" />
            <div class="hero-stat">
              <span class="hero-stat__value">{{ formatDate(user?.created_at) }}</span>
              <span class="hero-stat__label">Member since</span>
            </div>
            <div class="hero-stat__divider" />
            <div class="hero-stat">
              <span class="hero-stat__value hero-stat__value--status">{{ user?.status }}</span>
              <span class="hero-stat__label">Status</span>
            </div>
          </div>
        </div>

        <div class="profile-hero__actions">
          <button class="btn btn--ghost" @click="changePassword">Change Password</button>
          <button class="btn btn--danger" @click="logout">Logout</button>
        </div>
      </div>

      <!-- ── Content grid ──────────────────────────────────────────────────── -->
      <div class="profile-grid">

        <!-- Personal Information -->
        <section class="profile-card">
          <div class="profile-card__header">
            <div class="profile-card__header-left">
              <div class="profile-card__icon">
                <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                </svg>
              </div>
              <h2 class="profile-card__title">Personal Information</h2>
            </div>
            <button class="btn-link" @click="editPersonalInfo">Edit</button>
          </div>

          <div class="profile-card__body">
            <div class="info-grid">
              <div class="info-item">
                <span class="info-item__label">Full Name</span>
                <span class="info-item__value">{{ user?.name || '—' }}</span>
              </div>
              <div class="info-item">
                <span class="info-item__label">Username</span>
                <span class="info-item__value">{{ user?.username || '—' }}</span>
              </div>
              <div class="info-item">
                <span class="info-item__label">Email Address</span>
                <span class="info-item__value">{{ user?.email || '—' }}</span>
              </div>
              <div class="info-item">
                <span class="info-item__label">Phone Number</span>
                <span class="info-item__value">{{ user?.phone || '—' }}</span>
              </div>
              <div class="info-item">
                <span class="info-item__label">Date of Birth</span>
                <span class="info-item__value">{{ formatDate(user?.date_of_birth) || '—' }}</span>
              </div>
              <div class="info-item">
                <span class="info-item__label">Gender</span>
                <span class="info-item__value">{{ formatGender(user?.gender) || '—' }}</span>
              </div>
              <div class="info-item">
                <span class="info-item__label">Country</span>
                <span class="info-item__value">{{ user?.country || '—' }}</span>
              </div>
              <div class="info-item">
                <span class="info-item__label">Timezone</span>
                <span class="info-item__value">{{ user?.timezone || '—' }}</span>
              </div>
            </div>
          </div>
        </section>

        <!-- Partner Information -->
        <section v-if="partnerInfo" class="profile-card profile-card--partner">
          <div class="profile-card__header">
            <div class="profile-card__header-left">
              <div class="profile-card__icon profile-card__icon--partner">
                <svg width="16" height="16" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                </svg>
              </div>
              <div>
                <h2 class="profile-card__title">Partner Information</h2>
                <p class="profile-card__subtitle">{{ partnerInfo.partner_type?.name }}</p>
              </div>
            </div>
            <span class="badge badge--partner">{{ partnerInfo.status }}</span>
          </div>

          <div class="profile-card__body">
            <div class="info-grid">
              <div class="info-item">
                <span class="info-item__label">Company Name</span>
                <span class="info-item__value">{{ partnerInfo.company_name || '—' }}</span>
              </div>
              <div class="info-item">
                <span class="info-item__label">Company Email</span>
                <span class="info-item__value">{{ partnerInfo.company_email || '—' }}</span>
              </div>
              <div class="info-item">
                <span class="info-item__label">Company Address</span>
                <span class="info-item__value">{{ partnerInfo.company_address || '—' }}</span>
              </div>
              <div class="info-item">
                <span class="info-item__label">Tax Code</span>
                <span class="info-item__value mono">{{ partnerInfo.tax_code || '—' }}</span>
              </div>
              <div class="info-item">
                <span class="info-item__label">Website</span>
                <a v-if="partnerInfo.website" :href="partnerInfo.website" target="_blank" class="info-item__link">
                  {{ partnerInfo.website }}
                </a>
                <span v-else class="info-item__value">—</span>
              </div>
              <div class="info-item">
                <span class="info-item__label">Contract Number</span>
                <span class="info-item__value mono">{{ partnerInfo.contract_number || '—' }}</span>
              </div>
              <div class="info-item info-item--full">
                <span class="info-item__label">Contract Period</span>
                <span class="info-item__value">
                  {{ formatDate(partnerInfo.contract_start_date) }}
                  <span class="info-item__arrow">→</span>
                  {{ formatDate(partnerInfo.contract_end_date) }}
                </span>
              </div>
              <div class="info-item info-item--full">
                <span class="info-item__label">Contract File</span>
                <a v-if="partnerInfo.contract_file_url" :href="partnerInfo.contract_file_url" target="_blank" class="info-item__link info-item__link--file">
                  <svg width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M12 10v6m0 0l-3-3m3 3l3-3M3 17V7a2 2 0 012-2h6l2 2h6a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2z"/>
                  </svg>
                  View Contract
                </a>
                <span v-else class="info-item__value">—</span>
              </div>
            </div>

            <!-- Financial strip -->
            <div class="financial-strip">
              <div class="financial-item">
                <span class="financial-item__label">Revenue Share</span>
                <span class="financial-item__value financial-item__value--accent">{{ partnerInfo.revenue_share_percentage }}%</span>
              </div>
              <div class="financial-item">
                <span class="financial-item__label">Payment Threshold</span>
                <span class="financial-item__value">{{ formatCurrency(partnerInfo.payment_threshold) }}</span>
              </div>
              <div class="financial-item">
                <span class="financial-item__label">Frequency</span>
                <span class="financial-item__value" style="text-transform: capitalize">{{ partnerInfo.payment_frequency }}</span>
              </div>
            </div>

            <!-- Bank info -->
            <div class="bank-section">
              <p class="bank-section__title">Banking Details</p>
              <div class="info-grid">
                <div class="info-item">
                  <span class="info-item__label">Bank Name</span>
                  <span class="info-item__value">{{ partnerInfo.bank_name || '—' }}</span>
                </div>
                <div class="info-item">
                  <span class="info-item__label">Branch</span>
                  <span class="info-item__value">{{ partnerInfo.bank_branch || '—' }}</span>
                </div>
                <div class="info-item">
                  <span class="info-item__label">Account Number</span>
                  <span class="info-item__value mono">{{ partnerInfo.bank_account_number || '—' }}</span>
                </div>
                <div class="info-item">
                  <span class="info-item__label">Account Name</span>
                  <span class="info-item__value">{{ partnerInfo.bank_account_name || '—' }}</span>
                </div>
              </div>
            </div>
          </div>
        </section>

      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useAuthStore, getFullImageUrl } from '@/store/authStore'
import { useRouter } from 'vue-router'

const authStore = useAuthStore()
const router = useRouter()
const isLoading = ref(true)

const partnerInfo = computed(() => {
  if (!authStore.partners || authStore.partners.length === 0) {
    return null
  }
  return authStore.partners[0]
})


const user = computed(() => authStore.user)
const rolesFlags = computed(() => authStore.rolesFlags || {})

const isBoss = computed(() => rolesFlags.value.is_boss || false)
const isAdmin = computed(() => rolesFlags.value.is_admin || false)
const isPartner = computed(() => rolesFlags.value.is_partner || false)

const getAvatarUrl = (url: string | null | undefined) => {
  if (!url) return '/default-avatar.png'
  if (url.startsWith('http')) return url
  if (url.startsWith('/storage')) return `${import.meta.env.VITE_API_URL}${url}`
  return `${import.meta.env.VITE_API_URL}/storage/${url}`
}

const handleAvatarError = (e: Event) => {
  const img = e.target as HTMLImageElement
  img.src = '/default-avatar.png'
  img.onerror = null // Tránh loop
}

const formatCurrency = (amount: string | number | undefined) => {
  if (!amount) return '0 ₫'
  const num = typeof amount === 'string' ? parseFloat(amount) : amount
  if (isNaN(num)) return '0 ₫'
  return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(num)
}

const formatDate = (date: string | Date | undefined) => {
  if (!date) return ''
  try {
    return new Date(date).toLocaleDateString('vi-VN')
  } catch {
    return ''
  }
}

const formatGender = (gender: string | undefined) => {
  const map: Record<string, string> = { 
    male: 'Male', 
    female: 'Female', 
    other: 'Other' 
  }
  return gender ? (map[gender] || gender) : ''
}

const getInitial = (name?: string) => {
  if (!name) return '?'
  return name.trim().charAt(0).toUpperCase()
}

const getAvatarColor = (name?: string) => {
  if (!name) return '#6b7280'
  
  const colors = [
    '#f87171', // đỏ
    '#fb923c', // cam
    '#fbbf24', // vàng
    '#34d399', // xanh lá
    '#60a5fa', // xanh dương
    '#a78bfa', // tím
    '#f472b6', // hồng
    '#2dd4bf', // xanh ngọc
    '#818cf8', // indigo
    '#f43f5e', // hồng đậm
  ]

  let hash = 0
  for (let i = 0; i < name.length; i++) {
    hash = ((hash << 5) - hash) + name.charCodeAt(i)
    hash |= 0 // Convert to 32-bit integer
  }

  return colors[Math.abs(hash) % colors.length]
}

// Actions
const openChangeAvatar = () => {
  // TODO: Implement avatar upload
}

const editPersonalInfo = () => {
  router.push('/profile/edit')
}

const changePassword = () => {
  router.push('/profile/change-password')
}

const logout = async () => {
  try {
    await authStore.logout()
    router.push('/login')
  } catch (error) {
    console.error('Logout failed:', error)
  }
}

// Lifecycle
onMounted(async () => {
  try {
    isLoading.value = true
    await authStore.checkPermission()
  } catch (error) {
    console.error('Failed to load profile:', error)
  } finally {
    isLoading.value = false
  }
})
</script>

<style scoped>
/* ── Variables ──────────────────────────────────────────────────────────────── */
:root {
  --c-bg: #080b11;
  --c-surface: rgba(255,255,255,0.035);
  --c-border: rgba(255,255,255,0.07);
  --c-border-hover: rgba(255,255,255,0.14);
  --c-text: rgba(255,255,255,0.92);
  --c-muted: rgba(255,255,255,0.38);
  --c-accent: #00c6ff;
  --c-accent2: #a78bfa;
  --c-green: #34d399;
  --c-red: #f87171;
}

/* ── Page shell ─────────────────────────────────────────────────────────────── */
.profile-page {
  min-height: 100vh;
  background: #080b11;
  color: var(--c-text);
  position: relative;
  font-family: 'DM Sans', system-ui, sans-serif;
}

.profile-page__ambient {
  position: fixed;
  inset: 0;
  pointer-events: none;
  background:
    radial-gradient(ellipse 60% 40% at 10% 0%, rgba(0,198,255,0.07) 0%, transparent 70%),
    radial-gradient(ellipse 50% 50% at 90% 100%, rgba(167,139,250,0.06) 0%, transparent 70%);
}

.profile-container {
  max-width: 960px;
  margin: 0 auto;
  padding: 40px 24px 80px;
  position: relative;
}

/* ── Hero ───────────────────────────────────────────────────────────────────── */
.profile-hero {
  display: flex;
  align-items: flex-start;
  gap: 28px;
  margin-bottom: 36px;
  padding: 32px;
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 20px;
  backdrop-filter: blur(12px);
  position: relative;
  overflow: hidden;
}

.profile-hero::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(0,198,255,0.4), rgba(167,139,250,0.3), transparent);
}

.profile-hero__avatar-wrap {
  position: relative;
  flex-shrink: 0;
}

.profile-hero__avatar-ring {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  padding: 2px;
  background: linear-gradient(135deg, #00c6ff, #a78bfa);
}

.profile-hero__avatar {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  object-fit: cover;
  background: #1a1f2e;
  display: block;
}

.profile-hero__avatar-btn {
  position: absolute;
  bottom: 2px; right: 2px;
  width: 28px; height: 28px;
  border-radius: 50%;
  border: none;
  background: #1e2333;
  color: var(--c-muted);
  cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  transition: background 0.2s, color 0.2s;
}

.profile-hero__avatar-btn:hover {
  background: #00c6ff22;
  color: var(--c-accent);
}

.profile-hero__meta {
  flex: 1;
  min-width: 0;
}

.profile-hero__badges {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-bottom: 10px;
}

.profile-hero__name {
  font-size: 26px;
  font-weight: 700;
  letter-spacing: -0.5px;
  margin: 0 0 2px;
  background: linear-gradient(90deg, #fff 40%, #00c6ff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.profile-hero__handle {
  font-size: 13px;
  color: var(--c-muted);
  margin: 0 0 20px;
}

.profile-hero__stats {
  display: flex;
  align-items: center;
  gap: 20px;
  flex-wrap: wrap;
}

.hero-stat {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.hero-stat__value {
  font-size: 14px;
  font-weight: 600;
  color: var(--c-text);
}

.hero-stat__value--status {
  color: var(--c-green);
  text-transform: capitalize;
}

.hero-stat__label {
  font-size: 11px;
  color: var(--c-muted);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.hero-stat__divider {
  width: 1px;
  height: 28px;
  background: var(--c-border);
}

.profile-hero__actions {
  display: flex;
  flex-direction: column;
  gap: 8px;
  flex-shrink: 0;
}

/* ── Badges ─────────────────────────────────────────────────────────────────── */
.badge {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-size: 11px;
  font-weight: 600;
  padding: 3px 10px;
  border-radius: 20px;
  letter-spacing: 0.03em;
}

.badge--boss {
  background: linear-gradient(135deg, #f59e0b, #ef4444);
  color: #000;
}

.badge--admin {
  background: rgba(248,113,113,0.12);
  color: var(--c-red);
  border: 1px solid rgba(248,113,113,0.25);
}

.badge--partner {
  background: rgba(167,139,250,0.12);
  color: var(--c-accent2);
  border: 1px solid rgba(167,139,250,0.25);
  text-transform: capitalize;
}

.badge--active {
  background: rgba(52,211,153,0.1);
  color: var(--c-green);
  border: 1px solid rgba(52,211,153,0.2);
}

.badge__dot {
  width: 6px; height: 6px;
  border-radius: 50%;
  background: var(--c-green);
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.4; }
}

/* ── Buttons ────────────────────────────────────────────────────────────────── */
.btn {
  padding: 8px 18px;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  border: none;
  transition: all 0.2s;
  white-space: nowrap;
}

.btn--ghost {
  background: rgba(255,255,255,0.06);
  color: var(--c-text);
  border: 1px solid var(--c-border);
}

.btn--ghost:hover {
  background: rgba(255,255,255,0.1);
  border-color: var(--c-border-hover);
}

.btn--danger {
  background: rgba(248,113,113,0.1);
  color: var(--c-red);
  border: 1px solid rgba(248,113,113,0.2);
}

.btn--danger:hover {
  background: rgba(248,113,113,0.18);
}

.btn-link {
  background: none;
  border: none;
  font-size: 13px;
  font-weight: 600;
  color: var(--c-accent);
  cursor: pointer;
  padding: 0;
  transition: opacity 0.2s;
}

.btn-link:hover { opacity: 0.7; }

/* ── Grid ───────────────────────────────────────────────────────────────────── */
.profile-grid {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* ── Card ───────────────────────────────────────────────────────────────────── */
.profile-card {
  background: var(--c-surface);
  border: 1px solid var(--c-border);
  border-radius: 18px;
  overflow: hidden;
  backdrop-filter: blur(8px);
  transition: border-color 0.2s;
}

.profile-card:hover {
  border-color: var(--c-border-hover);
}

.profile-card--partner {
  border-color: rgba(167,139,250,0.15);
}

.profile-card--partner:hover {
  border-color: rgba(167,139,250,0.28);
}

.profile-card__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 24px;
  border-bottom: 1px solid var(--c-border);
}

.profile-card__header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.profile-card__icon {
  width: 34px; height: 34px;
  border-radius: 10px;
  background: rgba(0,198,255,0.1);
  color: var(--c-accent);
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
}

.profile-card__icon--partner {
  background: rgba(167,139,250,0.1);
  color: var(--c-accent2);
}

.profile-card__title {
  font-size: 15px;
  font-weight: 600;
  margin: 0;
}

.profile-card__subtitle {
  font-size: 12px;
  color: var(--c-muted);
  margin: 2px 0 0;
}

.profile-card__body {
  padding: 24px;
}

/* ── Info grid ──────────────────────────────────────────────────────────────── */
.info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px 32px;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-item--full {
  grid-column: 1 / -1;
}

.info-item__label {
  font-size: 11px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--c-muted);
}

.info-item__value {
  font-size: 14px;
  color: var(--c-text);
  font-weight: 500;
}

.info-item__value.mono {
  font-family: 'JetBrains Mono', monospace;
  font-size: 13px;
  letter-spacing: 0.05em;
}

.info-item__arrow {
  margin: 0 8px;
  color: var(--c-muted);
}

.info-item__link {
  font-size: 13px;
  color: var(--c-accent);
  text-decoration: none;
  word-break: break-all;
}

.info-item__link:hover { text-decoration: underline; }

.info-item__link--file {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-weight: 600;
}

/* ── Financial strip ────────────────────────────────────────────────────────── */
.financial-strip {
  display: flex;
  gap: 0;
  margin: 24px 0;
  border: 1px solid rgba(167,139,250,0.15);
  border-radius: 12px;
  overflow: hidden;
}

.financial-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 16px;
  gap: 4px;
  background: rgba(167,139,250,0.04);
  border-right: 1px solid rgba(167,139,250,0.1);
}

.financial-item:last-child { border-right: none; }

.financial-item__label {
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--c-muted);
}

.financial-item__value {
  font-size: 18px;
  font-weight: 700;
  color: var(--c-text);
}

.financial-item__value--accent {
  color: var(--c-accent2);
}

/* ── Bank section ───────────────────────────────────────────────────────────── */
.bank-section {
  padding-top: 20px;
  border-top: 1px solid var(--c-border);
}

.bank-section__title {
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--c-muted);
  margin: 0 0 16px;
}

/* ── Responsive ─────────────────────────────────────────────────────────────── */
@media (max-width: 640px) {
  .profile-hero {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }

  .profile-hero__stats {
    justify-content: center;
  }

  .profile-hero__actions {
    flex-direction: row;
    width: 100%;
  }

  .btn { flex: 1; text-align: center; }

  .info-grid {
    grid-template-columns: 1fr;
  }

  .financial-strip {
    flex-direction: column;
  }

  .financial-item {
    border-right: none;
    border-bottom: 1px solid rgba(167,139,250,0.1);
  }

  .financial-item:last-child { border-bottom: none; }
}
.avatar-fallback {
  width: 100%;
  height: 100%;
  display: flex !important;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 16px;
  color: white !important;
  text-transform: uppercase;
  border-radius: 50%;
}
</style>
<template>
  <div class="partner-dashboard">
    <div class="bg-grid"></div>
    <div class="bg-glow"></div>
    <div class="container">
      <!-- Header -->
      <div class="header">
        <h1 class="title">Welcome back, {{ partnerName }}</h1>
        <p class="subtitle">Please select your partner type to continue</p>
      </div>

      <!-- 2 Cards Selection -->
      <div class="cards-container">
        <!-- Music Distribution Partner Card -->
        <div
          v-if="musicPartner"
          class="partner-card music-card"
          :class="{
            selected: selectedType === musicPartner.code,
            locked: !isMusiceDistrib
          }"
          @click="selectPartnerType(musicPartner.code)"
        >
          <div class="card-glow"></div>

          <!-- Lock overlay -->
          <div class="lock-overlay" v-if="!isMusiceDistrib">
            <div class="lock-icon-wrap">
              <svg width="32" height="32" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                <rect x="3" y="11" width="18" height="11" rx="2" />
                <path d="M7 11V7a5 5 0 0 1 10 0v4" />
              </svg>
            </div>
            <p class="lock-text">Not available for your account</p>
          </div>

          <div class="card-content">
            <div class="icon-wrapper">
              <svg class="card-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                  d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3" />
              </svg>
            </div>
            <h2 class="card-title">{{ musicPartner.name }}</h2>
            <p class="card-description">
              {{ musicPartner.description || 'Manage your music catalog, track releases, and monitor streaming performance' }}
            </p>
            <div class="card-stats">
              <div class="stat">
                <span class="stat-value">{{ musicPartner.default_revenue_share }}%</span>
                <span class="stat-label">Default Revenue Share</span>
              </div>
              <div class="stat">
                <span class="stat-value">{{ musicPartner.default_payment_threshold }}USD</span>
                <span class="stat-label">Default Payment Threshold</span>
              </div>
            </div>
            <button class="select-btn" :disabled="!isMusiceDistrib">
              {{ selectedType === musicPartner.code ? 'Selected' : 'Select' }}
              <svg v-if="selectedType === musicPartner.code" class="check-icon" fill="none" stroke="currentColor"
                viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
            </button>
          </div>
        </div>

        <!-- Advertising Partner Card -->
        <div
          v-if="adPartner"
          class="partner-card ad-card"
          :class="{
            selected: selectedType === adPartner.code,
            locked: !isAdvertising
          }"
          @click="selectPartnerType(adPartner.code)"
        >
          <div class="card-glow"></div>

          <!-- Lock overlay -->
          <div class="lock-overlay" v-if="!isAdvertising">
            <div class="lock-icon-wrap">
              <svg width="32" height="32" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                <rect x="3" y="11" width="18" height="11" rx="2" />
                <path d="M7 11V7a5 5 0 0 1 10 0v4" />
              </svg>
            </div>
            <p class="lock-text">Not available for your account</p>
          </div>

          <div class="card-content">
            <div class="icon-wrapper">
              <svg class="card-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                  d="M11 3.055A9.001 9.001 0 1020.945 13H11V3.055zM20.488 9H15V3.512A9.001 9.001 0 0120.488 9zM3 12a9 9 0 109-9" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 12l3-3" />
              </svg>
            </div>
            <h2 class="card-title">{{ adPartner.name }}</h2>
            <p class="card-description">
              {{ adPartner.description || 'Manage ad campaigns, track impressions, and optimize your marketing ROI' }}
            </p>
            <div class="card-stats">
              <div class="stat">
                <span class="stat-value">{{ adPartner.default_revenue_share }}%</span>
                <span class="stat-label">Default Revenue Share</span>
              </div>
              <div class="stat">
                <span class="stat-value">{{ adPartner.default_payment_threshold }}USD</span>
                <span class="stat-label">Default Payment Threshold</span>
              </div>
            </div>
            <button class="select-btn" :disabled="!isAdvertising">
              {{ selectedType === adPartner.code ? 'Selected' : 'Select' }}
              <svg v-if="selectedType === adPartner.code" class="check-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
            </button>
          </div>
        </div>
      </div>

      <!-- Continue Button -->
      <div class="action-footer" v-if="selectedType">
        <button class="continue-btn" @click="continueToDashboard">
          Continue to {{ selectedType === musicPartner?.code ? musicPartner?.name : adPartner?.name }} Dashboard
          <svg class="arrow-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
          </svg>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { storeToRefs } from 'pinia'
import clientApi from '@/plugins/axios'
import { useTypePartnerstore } from '@/modules/client/stores/typePartners/typePartnersStore' 

const router = useRouter()
const typePartnerStore = useTypePartnerstore()
const { TypePartners } = storeToRefs(typePartnerStore)

const partnerName = ref('Partner')
const selectedType = ref<string | null>(null)
const isMusiceDistrib = ref(false)
const isAdvertising = ref(false)
const loadingPermission = ref(true)

// Lấy thông tin partner từ store
const musicPartner = computed(() => {
  return TypePartners.value?.find((p: any) => p.code === 'music_distribution')
})

const adPartner = computed(() => {
  return TypePartners.value?.find((p: any) => p.code === 'advertising')
})


// Stats từ partner data
const musicStats = ref({ releases: 0, streams: '0' })
const adStats = ref({ campaigns: 0, impressions: '0' })

onMounted(async () => {
  try {
    if (!TypePartners.value?.length) {
      await typePartnerStore.fetchTypePartners() 
    }

    const res = await clientApi.get('/check-permission')
    const data = res.data

    partnerName.value = data.user?.name ?? 'Partner'
    isMusiceDistrib.value = data.is_music_distribution
    isAdvertising.value = data.is_advertising

    if (data.is_music_distribution && !data.is_advertising) {
      selectedType.value = musicPartner.value?.code || 'music_distribution'
    }
    if (data.is_advertising && !data.is_music_distribution) {
      selectedType.value = adPartner.value?.code || 'advertising'
    }

    if (data.partner) {
      musicStats.value.releases = data.partner.total_songs ?? 0
      musicStats.value.streams = formatNumber(data.partner.total_streams ?? 0)
      adStats.value.campaigns = data.partner.total_campaigns ?? 0
      adStats.value.impressions = formatNumber(data.partner.total_impressions ?? 0)
    }
  } catch {
    router.push({ name: 'login' })
  } finally {
    loadingPermission.value = false
  }
})

const formatNumber = (num: number): string => {
  if (num >= 1000000) return (num / 1000000).toFixed(1) + 'M'
  if (num >= 1000) return (num / 1000).toFixed(1) + 'K'
  return num.toString()
}

const selectPartnerType = (type: string) => {
  if (type === musicPartner.value?.code && !isMusiceDistrib.value) return
  if (type === adPartner.value?.code && !isAdvertising.value) return
  selectedType.value = type
}

const continueToDashboard = () => {
  if (selectedType.value === musicPartner.value?.code) {
    router.push({ name: 'client.partner.music' })
  } else if (selectedType.value === adPartner.value?.code) {
    router.push({ name: 'client.partner.Advertisingd.dashboard' })
  }
}
</script>

<style scoped>
/* Giữ nguyên style của bạn, thêm một số style bổ sung */

.partner-dashboard {
  min-height: 100vh;
  background: #080e14;
  color: #e8eaed;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}

.bg-grid {
  position: fixed;
  inset: 0;
  background-image:
    linear-gradient(rgba(255, 255, 255, .025) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255, 255, 255, .025) 1px, transparent 1px);
  background-size: 40px 40px;
  pointer-events: none;
}

.bg-glow {
  position: fixed;
  top: -200px;
  left: 50%;
  transform: translateX(-50%);
  width: 600px;
  height: 500px;
  background: radial-gradient(ellipse, rgba(99, 102, 241, .12) 0%, transparent 70%);
  pointer-events: none;
}

.container {
  max-width: 1200px;
  width: 100%;
}

/* Header Styles */
.header {
  text-align: center;
  margin-bottom: 4rem;
}

.title {
  font-size: 2.5rem;
  font-weight: 700;
  background: linear-gradient(135deg, #fff 0%, #94a3b8 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 0.5rem;
}

.subtitle {
  color: #94a3b8;
  font-size: 1.1rem;
}

/* Cards Container */
.cards-container {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 2rem;
  margin-bottom: 3rem;
}

/* Partner Card Styles */
.partner-card {
  position: relative;
  background: rgba(30, 41, 59, 0.5);
  backdrop-filter: blur(10px);
  border-radius: 2rem;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 2px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
}

.partner-card:not(.locked):hover {
  transform: translateY(-8px);
  border-color: rgba(255, 255, 255, 0.3);
}

.partner-card.selected {
  border-color: #3b82f6;
  background: rgba(59, 130, 246, 0.1);
  box-shadow: 0 0 30px rgba(59, 130, 246, 0.3);
}

.music-card.selected .card-glow {
  background: radial-gradient(circle at 50% 0%, rgba(59, 130, 246, 0.4), transparent);
}

.ad-card.selected .card-glow {
  background: radial-gradient(circle at 50% 0%, rgba(139, 92, 246, 0.4), transparent);
}

.card-glow {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 100%;
  pointer-events: none;
  transition: opacity 0.3s ease;
  opacity: 0;
}

.partner-card.selected .card-glow {
  opacity: 1;
}

.card-content {
  padding: 2rem;
  position: relative;
  z-index: 1;
}

.icon-wrapper {
  width: 80px;
  height: 80px;
  background: rgba(59, 130, 246, 0.1);
  border-radius: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 1.5rem;
}

.music-card .icon-wrapper {
  background: rgba(59, 130, 246, 0.1);
}

.ad-card .icon-wrapper {
  background: rgba(139, 92, 246, 0.1);
}

.card-icon {
  width: 48px;
  height: 48px;
  stroke-width: 1.5;
}

.music-card .card-icon {
  color: #3b82f6;
  stroke: #3b82f6;
}

.ad-card .card-icon {
  color: #8b5cf6;
  stroke: #8b5cf6;
}

.card-title {
  font-size: 1.75rem;
  font-weight: 700;
  color: white;
  margin-bottom: 0.75rem;
}

.card-description {
  color: #94a3b8;
  line-height: 1.6;
  margin-bottom: 1.5rem;
}

.card-stats {
  display: flex;
  gap: 1.5rem;
  margin-bottom: 1.5rem;
  padding: 1rem 0;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.stat {
  display: flex;
  flex-direction: column;
}

.stat-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: white;
}

.stat-label {
  font-size: 0.875rem;
  color: #64748b;
}

.select-btn {
  width: 100%;
  padding: 0.875rem;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 1rem;
  color: white;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.select-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.partner-card.selected .select-btn {
  background: #3b82f6;
  border-color: #3b82f6;
}

.ad-card.selected .select-btn {
  background: #8b5cf6;
  border-color: #8b5cf6;
}

.select-btn:hover:not(:disabled) {
  background: rgba(255, 255, 255, 0.1);
  transform: scale(0.98);
}

.check-icon {
  width: 1.25rem;
  height: 1.25rem;
}

/* Continue Button */
.action-footer {
  display: flex;
  justify-content: center;
}

.continue-btn {
  padding: 1rem 2rem;
  background: linear-gradient(135deg, #3b82f6, #8b5cf6);
  border: none;
  border-radius: 2rem;
  color: white;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: inline-flex;
  align-items: center;
  gap: 0.75rem;
}

.continue-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(59, 130, 246, 0.3);
}

.arrow-icon {
  width: 1.25rem;
  height: 1.25rem;
}

/* Locked Card Styles */
.partner-card.locked {
  opacity: 0.6;
  cursor: not-allowed;
  pointer-events: auto;
}

.lock-overlay {
  position: absolute;
  inset: 0;
  z-index: 10;
  background: rgba(8, 14, 20, 0.85);
  backdrop-filter: blur(4px);
  border-radius: 2rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
}

.lock-icon-wrap {
  width: 64px;
  height: 64px;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #64748b;
}

.lock-text {
  color: #64748b;
  font-size: 0.875rem;
  font-weight: 500;
}

/* Responsive */
@media (max-width: 768px) {
  .cards-container {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }

  .title {
    font-size: 1.75rem;
  }

  .card-content {
    padding: 1.5rem;
  }

  .icon-wrapper {
    width: 60px;
    height: 60px;
  }

  .card-icon {
    width: 36px;
    height: 36px;
  }

  .card-title {
    font-size: 1.5rem;
  }
}
</style>
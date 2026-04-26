<template>
  <Teleport to="body">
    <Transition name="modal-fade">
      <div v-if="visible" class="ad-modal-overlay" @click.self="handleSkip">
        <div class="ad-modal">
          <!-- Header -->
          <div class="ad-modal__header">
            <span class="ad-modal__sponsored">
              <span class="ad-modal__dot" />
              Sponsored
            </span>
            <button
              class="ad-modal__skip"
              :disabled="countdown > 0"
              @click="handleSkip"
            >
              <template v-if="countdown > 0">
                Skip in {{ countdown }}s
              </template>
              <template v-else>
                Skip
                <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
                  <path d="M2 6h8M7 3l3 3-3 3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </template>
            </button>
          </div>

          <!-- Ad content -->
          <div v-if="currentAd" class="ad-modal__body" @click="handleClick">
            <img
              v-if="currentAd.thumbnail"
              :src="currentAd.thumbnail"
              :alt="currentAd.title || 'Advertisement'"
              class="ad-modal__image"
              @error="handleImageError"
            />
            <div v-else class="ad-modal__image-placeholder">
              <svg width="40" height="40" viewBox="0 0 24 24" fill="none">
                <rect x="3" y="3" width="18" height="18" rx="3" stroke="currentColor" stroke-width="1.5"/>
                <circle cx="8.5" cy="8.5" r="1.5" fill="currentColor"/>
                <path d="M21 15l-5-5L5 21" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
              </svg>
            </div>

            <div class="ad-modal__info">
              <p v-if="currentAd.title" class="ad-modal__title">{{ currentAd.title }}</p>
              <p v-if="currentAd.description" class="ad-modal__desc">{{ currentAd.description }}</p>
              <span v-if="currentAd.cta_text || currentAd.target_url" class="ad-modal__cta">
                {{ currentAd.cta_text || 'Learn more' }}
                <svg width="14" height="14" viewBox="0 0 12 12" fill="none">
                  <path d="M2 6h8M7 3l3 3-3 3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
              </span>
            </div>
          </div>

          <!-- Progress bar -->
          <div class="ad-modal__progress">
            <div
              class="ad-modal__progress-bar"
              :style="{ animationDuration: `${SKIP_DELAY}ms` }"
            />
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, watch } from 'vue'
import { useAdManager } from '@/composables/useAdManager'

const SKIP_DELAY = 5000
const SHOW_DELAY = 1500
const SESSION_KEY = 'ad_modal_shown'

const { bannerAds, trackImpression, trackClick } = useAdManager()

const visible = ref(false)
const countdown = ref(Math.ceil(SKIP_DELAY / 1000))
const currentAd = ref<any>(null)

let countdownTimer: ReturnType<typeof setInterval> | null = null

// ─── Handlers ─────────────────────────────────────────────────────────────────
const handleSkip = () => {
  if (countdown.value > 0) return
  close()
}

const handleClick = () => {
  if (!currentAd.value) return
  trackClick(currentAd.value.id)
  if (currentAd.value.target_url) {
    window.open(currentAd.value.target_url, '_blank', 'noopener,noreferrer')
  }
}

const handleImageError = (e: Event) => {
  (e.target as HTMLImageElement).style.display = 'none'
}

const close = () => {
  visible.value = false
  sessionStorage.setItem(SESSION_KEY, '1')
  if (countdownTimer) clearInterval(countdownTimer)
}

const startCountdown = () => {
  countdown.value = Math.ceil(SKIP_DELAY / 1000)
  countdownTimer = setInterval(() => {
    countdown.value--
    if (countdown.value <= 0) {
      clearInterval(countdownTimer!)
      countdownTimer = null
    }
  }, 1000)
}

// ─── Core: show modal ─────────────────────────────────────────────────────────
const tryShow = () => {
  if (sessionStorage.getItem(SESSION_KEY)) return
  if (bannerAds.value.length === 0) return

  currentAd.value = bannerAds.value[Math.floor(Math.random() * bannerAds.value.length)] ?? null
  if (!currentAd.value) return

  visible.value = true
  startCountdown()
  trackImpression(currentAd.value.id)
}

onMounted(() => {
  if (sessionStorage.getItem(SESSION_KEY)) return

  // Ads đã có sẵn → show sau delay
  if (bannerAds.value.length > 0) {
    setTimeout(tryShow, SHOW_DELAY)
    return
  }

  // Chưa có → watch đợi fetch về rồi mới show
  const stop = watch(bannerAds, (ads) => {
    if (ads.length === 0) return
    setTimeout(tryShow, SHOW_DELAY)
    stop() // unwatch sau khi trigger 1 lần
  })
})

onUnmounted(() => {
  if (countdownTimer) clearInterval(countdownTimer)
})
</script>

<style scoped>
.ad-modal-overlay {
  position: fixed;
  inset: 0;
  z-index: 9999;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(6px);
  display: flex;
  align-items: center;
  justify-content: center;
}

.ad-modal {
  position: relative;
  width: min(480px, calc(100vw - 32px));
  background: rgba(18, 18, 24, 0.97);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 24px 64px rgba(0, 0, 0, 0.6);
}

.ad-modal__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
}

.ad-modal__sponsored {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 10px;
  font-weight: 500;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: rgba(255, 255, 255, 0.35);
}

.ad-modal__dot {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: currentColor;
}

.ad-modal__skip {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-size: 12px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.4);
  background: transparent;
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 20px;
  padding: 4px 12px;
  cursor: default;
  transition: color 0.2s, border-color 0.2s, background 0.2s;
}

.ad-modal__skip:not(:disabled) {
  color: rgba(255, 255, 255, 0.85);
  border-color: rgba(255, 255, 255, 0.3);
  cursor: pointer;
}

.ad-modal__skip:not(:disabled):hover {
  background: rgba(255, 255, 255, 0.08);
}

.ad-modal__body {
  cursor: pointer;
  transition: background 0.2s;
}

.ad-modal__body:hover {
  background: rgba(255, 255, 255, 0.02);
}

.ad-modal__image {
  width: 100%;
  max-height: 240px;
  object-fit: cover;
  display: block;
}

.ad-modal__image-placeholder {
  width: 100%;
  height: 200px;
  background: rgba(255, 255, 255, 0.04);
  display: flex;
  align-items: center;
  justify-content: center;
  color: rgba(255, 255, 255, 0.15);
}

.ad-modal__info {
  padding: 16px 20px 20px;
}

.ad-modal__title {
  font-size: 16px;
  font-weight: 700;
  color: rgba(255, 255, 255, 0.92);
  margin: 0 0 6px;
}

.ad-modal__desc {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.45);
  margin: 0 0 14px;
  line-height: 1.5;
}

.ad-modal__cta {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  font-weight: 600;
  color: #1db954;
  letter-spacing: 0.02em;
}

.ad-modal__progress {
  height: 3px;
  background: rgba(255, 255, 255, 0.08);
}

.ad-modal__progress-bar {
  height: 100%;
  width: 100%;
  background: #1db954;
  transform-origin: left;
  animation: progress-fill linear forwards;
}

@keyframes progress-fill {
  from { transform: scaleX(0); }
  to   { transform: scaleX(1); }
}

.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.3s ease;
}

.modal-fade-enter-active .ad-modal,
.modal-fade-leave-active .ad-modal {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.modal-fade-enter-from,
.modal-fade-leave-to {
  opacity: 0;
}

.modal-fade-enter-from .ad-modal {
  transform: scale(0.95) translateY(12px);
}

.modal-fade-leave-to .ad-modal {
  transform: scale(0.95) translateY(12px);
}
</style>
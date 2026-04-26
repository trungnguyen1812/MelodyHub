<template>
  <div
    v-if="visibleAds.length > 0"
    class="ad-carousel"
    @mouseenter="pauseRotation"
    @mouseleave="resumeRotation"
  >
    <!-- Slide -->
    <Transition name="carousel-slide" mode="out-in">
      <div
        v-if="currentAd"
        :key="currentAd.id"
        class="ad-banner"
        :class="[
          `ad-banner--${currentAd.display_position || 'inline'}`,
          { 'ad-banner--clickable': !!currentAd.target_url }
        ]"
        @click="handleClick"
      >
        <!-- Sponsored label -->
        <div class="ad-banner__label">
          <span class="ad-banner__label-dot" />
          Sponsored
        </div>

        <!-- Close button -->
        <button class="ad-banner__close" aria-label="Close advertisement" @click.stop="handleDismiss">
          <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
            <path d="M1 1l10 10M11 1L1 11" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
        </button>

        <!-- Image -->
        <div class="ad-banner__media">
          <img
            v-if="currentAd.thumbnail"
            :src="currentAd.thumbnail"
            :alt="currentAd.title || 'Advertisement'"
            class="ad-banner__image"
            @load="handleImpression"
            @error="handleImageError"
          />
          <div v-else class="ad-banner__placeholder">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
              <rect x="3" y="3" width="18" height="18" rx="3" stroke="currentColor" stroke-width="1.5"/>
              <circle cx="8.5" cy="8.5" r="1.5" fill="currentColor"/>
              <path d="M21 15l-5-5L5 21" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
          </div>
        </div>

        <!-- Content -->
        <div class="ad-banner__content">
          <p v-if="currentAd.title" class="ad-banner__title">{{ currentAd.title }}</p>
          <p v-if="currentAd.description" class="ad-banner__desc">{{ currentAd.description }}</p>
          <span v-if="currentAd.cta_text || currentAd.target_url" class="ad-banner__cta">
            {{ currentAd.cta_text || 'Learn more' }}
            <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
              <path d="M2 6h8M7 3l3 3-3 3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </span>
        </div>
      </div>
    </Transition>

    <!-- Dots — only if more than 1 ad -->
    <div v-if="visibleAds.length > 1" class="ad-carousel__dots">
      <button
        v-for="(_, idx) in visibleAds"
        :key="idx"
        class="ad-carousel__dot"
        :class="{ 'ad-carousel__dot--active': idx === activeIdx }"
        :aria-label="`Go to ad ${idx + 1}`"
        @click="goTo(idx)"
      />
    </div>

    <!-- Progress bar — only if more than 1 ad -->
    <div v-if="visibleAds.length > 1" class="ad-carousel__progress">
      <div
        class="ad-carousel__progress-bar"
        :class="{ 'ad-carousel__progress-bar--paused': isPaused }"
        :key="activeIdx"
        :style="{ animationDuration: `${ROTATE_INTERVAL}ms` }"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useAdManager } from '@/composables/useAdManager'

const ROTATE_INTERVAL = 7000

const { bannerAds, trackImpression, trackClick, trackDismiss } = useAdManager()

// ─── Dismissed tracking (local) ───────────────────────────────────────────────
const dismissedIds = ref<Set<string | number>>(new Set())

const visibleAds = computed(() =>
  bannerAds.value.filter(ad => !dismissedIds.value.has(ad.id))
)

// ─── Active index within visibleAds ──────────────────────────────────────────
const activeIdx = ref(0)

const currentAd = computed(() => visibleAds.value[activeIdx.value] ?? null)

// ─── Impression dedup per ad ──────────────────────────────────────────────────
const impressionTracked = ref<Set<string | number>>(new Set())

const handleImpression = () => {
  if (!currentAd.value) return
  const id = currentAd.value.id
  if (impressionTracked.value.has(id)) return
  impressionTracked.value.add(id)
  trackImpression(id)
}

// ─── Interaction handlers ─────────────────────────────────────────────────────
const handleClick = () => {
  if (!currentAd.value) return
  trackClick(currentAd.value.id)
  if (currentAd.value.target_url) {
    window.open(currentAd.value.target_url, '_blank', 'noopener,noreferrer')
  }
}

const handleDismiss = () => {
  if (!currentAd.value) return
  trackDismiss(currentAd.value.id)
  dismissedIds.value.add(currentAd.value.id)
  // Clamp index sau khi bỏ ad
  if (activeIdx.value >= visibleAds.value.length) {
    activeIdx.value = Math.max(0, visibleAds.value.length - 1)
  }
}

const handleImageError = (e: Event) => {
  (e.target as HTMLImageElement).style.display = 'none'
}

// ─── Rotation ─────────────────────────────────────────────────────────────────
const isPaused = ref(false)
let timer: ReturnType<typeof setInterval> | null = null

const rotate = () => {
  if (!isPaused.value && visibleAds.value.length > 1) {
    activeIdx.value = (activeIdx.value + 1) % visibleAds.value.length
  }
}

const startRotation = () => {
  if (timer) clearInterval(timer)
  timer = setInterval(rotate, ROTATE_INTERVAL)
}

const pauseRotation = () => { isPaused.value = true }
const resumeRotation = () => { isPaused.value = false }

const goTo = (idx: number) => {
  activeIdx.value = idx
  startRotation() // reset timer khi navigate thủ công
}

// ─── IntersectionObserver để track impression khi ad visible ─────────────────
let observer: IntersectionObserver | null = null

onMounted(() => {
  startRotation()
  observer = new IntersectionObserver(
    (entries) => { if (entries[0]?.isIntersecting) handleImpression() },
    { threshold: 0.5 }
  )
  const el = document.querySelector('.ad-carousel')
  if (el) observer.observe(el)
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
  observer?.disconnect()
})
</script>

<style scoped>
/* ─── Carousel wrapper ─────────────────────────────────────────────────────── */
.ad-carousel {
  position: relative;
  width: 100%;
}

/* ─── Banner card ──────────────────────────────────────────────────────────── */
.ad-banner {
  position: relative;
  display: flex;
  align-items: center;
  gap: 14px;
  background: rgba(255, 255, 255, 0.04);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 12px;
  padding: 14px 16px;
  overflow: hidden;
  transition: background 0.2s ease, border-color 0.2s ease;
  margin: 16px 0;
}

.ad-banner::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, rgba(255,255,255,0.02) 0%, transparent 60%);
  pointer-events: none;
}

.ad-banner--clickable { cursor: pointer; }

.ad-banner--clickable:hover {
  background: rgba(255, 255, 255, 0.07);
  border-color: rgba(255, 255, 255, 0.14);
}

.ad-banner--sticky-bottom {
  position: fixed;
  bottom: 80px;
  left: 50%;
  transform: translateX(-50%);
  width: calc(100% - 48px);
  max-width: 720px;
  z-index: 100;
  box-shadow: 0 8px 32px rgba(0,0,0,0.4);
}

/* ─── Sponsored label ──────────────────────────────────────────────────────── */
.ad-banner__label {
  position: absolute;
  top: 8px;
  left: 14px;
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 10px;
  font-weight: 500;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: rgba(255, 255, 255, 0.35);
  pointer-events: none;
}

.ad-banner__label-dot {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: currentColor;
}

/* ─── Close ────────────────────────────────────────────────────────────────── */
.ad-banner__close {
  position: absolute;
  top: 8px;
  right: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 22px;
  height: 22px;
  border-radius: 50%;
  border: none;
  background: transparent;
  color: rgba(255, 255, 255, 0.3);
  cursor: pointer;
  transition: color 0.15s, background 0.15s;
  padding: 0;
}

.ad-banner__close:hover {
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.7);
}

/* ─── Media ────────────────────────────────────────────────────────────────── */
.ad-banner__media {
  flex-shrink: 0;
  margin-top: 12px;
}

.ad-banner__image {
  width: 72px;
  height: 72px;
  object-fit: cover;
  border-radius: 8px;
  display: block;
}

.ad-banner__placeholder {
  width: 72px;
  height: 72px;
  border-radius: 8px;
  background: rgba(255, 255, 255, 0.06);
  display: flex;
  align-items: center;
  justify-content: center;
  color: rgba(255, 255, 255, 0.2);
}

/* ─── Content ──────────────────────────────────────────────────────────────── */
.ad-banner__content {
  flex: 1;
  min-width: 0;
  margin-top: 10px;
}

.ad-banner__title {
  font-size: 14px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.9);
  margin: 0 0 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.ad-banner__desc {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.45);
  margin: 0 0 10px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.ad-banner__cta {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-size: 12px;
  font-weight: 600;
  color: #1db954;
  letter-spacing: 0.02em;
  transition: gap 0.15s;
}

.ad-banner--clickable:hover .ad-banner__cta { gap: 8px; }

/* ─── Dots ─────────────────────────────────────────────────────────────────── */
.ad-carousel__dots {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 6px;
  margin-top: 4px;
}

.ad-carousel__dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  border: none;
  background: rgba(255, 255, 255, 0.2);
  padding: 0;
  cursor: pointer;
  transition: background 0.2s, width 0.2s, border-radius 0.2s;
}

.ad-carousel__dot--active {
  width: 18px;
  border-radius: 3px;
  background: rgba(255, 255, 255, 0.7);
}

.ad-carousel__dot:hover:not(.ad-carousel__dot--active) {
  background: rgba(255, 255, 255, 0.4);
}

/* ─── Progress bar ─────────────────────────────────────────────────────────── */
.ad-carousel__progress {
  height: 2px;
  background: rgba(255, 255, 255, 0.08);
  border-radius: 1px;
  overflow: hidden;
  margin-top: 6px;
}

.ad-carousel__progress-bar {
  height: 100%;
  width: 100%;
  background: rgba(255, 255, 255, 0.35);
  transform-origin: left;
  animation: progress-fill linear forwards;
}

.ad-carousel__progress-bar--paused {
  animation-play-state: paused;
}

@keyframes progress-fill {
  from { transform: scaleX(0); }
  to   { transform: scaleX(1); }
}

/* ─── Slide transition ─────────────────────────────────────────────────────── */
.carousel-slide-enter-active,
.carousel-slide-leave-active {
  transition: opacity 0.35s ease, transform 0.35s ease;
}

.carousel-slide-enter-from {
  opacity: 0;
  transform: translateX(16px);
}

.carousel-slide-leave-to {
  opacity: 0;
  transform: translateX(-16px);
}
</style>
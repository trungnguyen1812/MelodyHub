<template>
  <Transition name="audio-ad-slide">
    <div v-if="visible && ad" class="audio-ad">
      <!-- Header -->
      <div class="audio-ad__header">
        <div class="audio-ad__label">
          <span class="audio-ad__dot" />
          Advertisement
        </div>
        <div class="audio-ad__timer-wrap">
          <span v-if="!canSkip" class="audio-ad__timer">
            Skip in {{ skipCountdown }}s
          </span>
          <button v-else class="audio-ad__skip" @click="handleSkip">
            Skip ad
            <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
              <path d="M2 2l8 4-8 4V2z" fill="currentColor"/>
              <path d="M10 2v8" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
          </button>
        </div>
      </div>

      <!-- Progress bar -->
      <div class="audio-ad__progress-track">
        <div class="audio-ad__progress-bar" :style="{ width: progressPercent + '%' }" />
      </div>

      <!-- Body -->
      <div class="audio-ad__body">
        <div v-if="ad.media_url" class="audio-ad__thumb">
          <img :src="ad.media_url" :alt="ad.title || 'Ad'" />
        </div>
        <div class="audio-ad__info">
          <p class="audio-ad__title">{{ ad.title || 'Sponsored Content' }}</p>
          <p v-if="ad.description" class="audio-ad__desc">{{ ad.description }}</p>
        </div>
        <a
          v-if="ad.target_url"
          :href="ad.target_url"
          target="_blank"
          rel="noopener noreferrer"
          class="audio-ad__cta"
          @click="emit('click', ad.id)"
        >
          {{ ad.cta_text || 'Learn more' }}
        </a>
      </div>

      <!-- Hidden audio element -->
      <audio
        ref="audioRef"
        :src="ad.audio_url"
        autoplay
        @timeupdate="onTimeUpdate"
        @ended="handleComplete"
        @error="handleAudioError"
      />
    </div>
  </Transition>
</template>

<script setup lang="ts">
import { ref, computed, watch, onUnmounted } from 'vue'
import type { Ad } from '@/composables/useAdManager'

interface Props {
  ad: Ad | null
  skipAfter?: number // override skip_after from ad object, seconds
}

const props = withDefaults(defineProps<Props>(), {
  skipAfter: 5,
})

const emit = defineEmits<{
  skip: [adId: string | number]
  complete: [adId: string | number]
  click: [adId: string | number]
  dismiss: []
}>()

const visible = ref(true)
const audioRef = ref<HTMLAudioElement | null>(null)
const currentTime = ref(0)
const duration = ref(0)
const skipAfterSeconds = computed(() => props.ad?.skip_after ?? props.skipAfter)

const progressPercent = computed(() => {
  if (!duration.value) return 0
  return Math.min(100, (currentTime.value / duration.value) * 100)
})

const canSkip = computed(() => currentTime.value >= skipAfterSeconds.value)

const skipCountdown = computed(() =>
  Math.ceil(skipAfterSeconds.value - currentTime.value)
)

const onTimeUpdate = () => {
  const audio = audioRef.value
  if (!audio) return
  currentTime.value = audio.currentTime
  duration.value = audio.duration || props.ad?.duration || 30
}

const handleSkip = () => {
  if (!props.ad || !canSkip.value) return
  audioRef.value?.pause()
  visible.value = false
  emit('skip', props.ad.id)
}

const handleComplete = () => {
  if (!props.ad) return
  visible.value = false
  emit('complete', props.ad.id)
}

const handleAudioError = () => {
  // If audio fails to load, auto-dismiss after 2s
  setTimeout(() => {
    visible.value = false
    emit('dismiss')
  }, 2000)
}

// Reset state when a new ad is passed
watch(() => props.ad?.id, () => {
  currentTime.value = 0
  duration.value = 0
  visible.value = true
})

onUnmounted(() => audioRef.value?.pause())
</script>

<style scoped>
.audio-ad {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  overflow: hidden;
  margin: 12px 0;
}

/* Header row */
.audio-ad__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 14px 6px;
}

.audio-ad__label {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 10px;
  font-weight: 500;
  letter-spacing: 0.07em;
  text-transform: uppercase;
  color: rgba(255, 255, 255, 0.35);
}

.audio-ad__dot {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  background: currentColor;
  animation: pulse 1.5s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50%       { opacity: 0.3; }
}

.audio-ad__timer-wrap {
  display: flex;
  align-items: center;
}

.audio-ad__timer {
  font-size: 11px;
  color: rgba(255, 255, 255, 0.35);
  font-variant-numeric: tabular-nums;
}

.audio-ad__skip {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-size: 12px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.75);
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 20px;
  padding: 4px 10px;
  cursor: pointer;
  transition: background 0.15s, color 0.15s;
}

.audio-ad__skip:hover {
  background: rgba(255, 255, 255, 0.14);
  color: #fff;
}

/* Progress */
.audio-ad__progress-track {
  height: 2px;
  background: rgba(255, 255, 255, 0.1);
}

.audio-ad__progress-bar {
  height: 100%;
  background: #1db954;
  transition: width 0.3s linear;
}

/* Body */
.audio-ad__body {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 14px 14px;
}

.audio-ad__thumb {
  flex-shrink: 0;
}

.audio-ad__thumb img {
  width: 52px;
  height: 52px;
  border-radius: 6px;
  object-fit: cover;
}

.audio-ad__info {
  flex: 1;
  min-width: 0;
}

.audio-ad__title {
  font-size: 13px;
  font-weight: 600;
  color: rgba(255, 255, 255, 0.9);
  margin: 0 0 3px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.audio-ad__desc {
  font-size: 11px;
  color: rgba(255, 255, 255, 0.4);
  margin: 0;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.audio-ad__cta {
  flex-shrink: 0;
  font-size: 12px;
  font-weight: 600;
  color: #1db954;
  text-decoration: none;
  padding: 6px 14px;
  border: 1px solid rgba(29, 185, 84, 0.4);
  border-radius: 20px;
  transition: background 0.15s;
}

.audio-ad__cta:hover {
  background: rgba(29, 185, 84, 0.12);
}

/* Transition */
.audio-ad-slide-enter-active,
.audio-ad-slide-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.audio-ad-slide-enter-from,
.audio-ad-slide-leave-to {
  opacity: 0;
  transform: translateY(-8px);
}
</style>
import { ref, computed } from 'vue'
import AdvertisingService, { Ad } from '@/modules/client/services/ad/advertising.service'
import { useUserStore } from '@/modules/client/stores/users/UserStore'

const PLAYS_BEFORE_AUDIO_AD = 3

// ─── Module-scope singleton state ─────────────────────────────────────────────
const bannerAds = ref<Ad[]>([])
const audioAds = ref<Ad[]>([])
const isLoading = ref(false)
const playCount = ref(0)
const currentAudioAd = ref<Ad | null>(null)
const isPlayingAd = ref(false)
const currentBannerIdx = ref(0) // ← moved out to stay consistent with other refs

export const useAdManager = () => {
  // ─── Fetch ────────────────────────────────────────────────────────────────
  const fetchAds = async (type: 'banner' | 'audio' | 'all' = 'all') => {
    // VIP users never see ads — clear and skip fetch
    const userStore = useUserStore()
    if (userStore.isVip) {
      bannerAds.value = []
      audioAds.value  = []
      return
    }

    isLoading.value = true
    try {
      const data: Ad[] = await AdvertisingService.getCampaigns()


      if (type === 'all' || type === 'banner') {
        bannerAds.value = data.filter(a => a.type === 'banner')
        currentBannerIdx.value = 0 // reset index on fresh fetch to avoid out-of-bounds
      }

      if (type === 'all' || type === 'audio') {
        audioAds.value = data.filter(a => a.type === 'audio')
      }
    } catch (err) {
    } finally {
      isLoading.value = false
    }
  }

  // ─── Banner carousel helpers ──────────────────────────────────────────────
  const activeBanner = computed(() => bannerAds.value[currentBannerIdx.value] ?? null)

  const rotateBanner = () => {
    if (bannerAds.value.length > 1) {
      currentBannerIdx.value = (currentBannerIdx.value + 1) % bannerAds.value.length
    }
  }

  // ─── Audio ad logic ───────────────────────────────────────────────────────
  const onSongPlayed = (): boolean => {
    // VIP users never get audio ads
    const userStore = useUserStore()
    if (userStore.isVip) return false

    playCount.value++

    if (playCount.value % PLAYS_BEFORE_AUDIO_AD === 0 && audioAds.value.length > 0) {
      const randomIdx = Math.floor(Math.random() * audioAds.value.length)
      currentAudioAd.value = audioAds.value[randomIdx]
      isPlayingAd.value = true

      if (currentAudioAd.value) {
        trackEvent(currentAudioAd.value.id, 'impression')
      }

      return true
    }
    return false
  }

  const finishAudioAd = () => {
    if (currentAudioAd.value) trackEvent(currentAudioAd.value.id, 'complete')
    isPlayingAd.value = false
    currentAudioAd.value = null
  }

  const skipAudioAd = () => {
    if (currentAudioAd.value) trackEvent(currentAudioAd.value.id, 'skip')
    isPlayingAd.value = false
    currentAudioAd.value = null
  }

  // ─── Tracking ─────────────────────────────────────────────────────────────
  const trackEvent = async (
    adId: string | number,
    eventType: 'impression' | 'click' | 'dismiss' | 'skip' | 'complete'
  ) => {
    try {
      await AdvertisingService.trackEvent(adId, eventType)
    } catch (error) {
      console.debug('[AdManager] Track failed:', error)
    }
  }

  const trackImpression = (adId: string | number) => trackEvent(adId, 'impression')
  const trackClick    = (adId: string | number) => trackEvent(adId, 'click')
  const trackDismiss  = (adId: string | number) => trackEvent(adId, 'dismiss')
  const trackSkip     = (adId: string | number) => trackEvent(adId, 'skip')
  const trackComplete = (adId: string | number) => trackEvent(adId, 'complete')

  // ─── Premium guard ────────────────────────────────────────────────────────
  const shouldShowAds = (isPremium: boolean) => !isPremium

  // ─── Init ─────────────────────────────────────────────────────────────────
  const init = async () => {
    await fetchAds('all')
  }

  return {
    // state
    bannerAds,
    audioAds,
    isLoading,
    activeBanner,
    currentBannerIdx,
    currentAudioAd,
    isPlayingAd,

    // methods
    fetchAds,
    init,
    rotateBanner,
    onSongPlayed,
    finishAudioAd,
    skipAudioAd,

    // tracking
    trackImpression,
    trackClick,
    trackDismiss,
    trackSkip,
    trackComplete,

    // util
    shouldShowAds,
  }
}
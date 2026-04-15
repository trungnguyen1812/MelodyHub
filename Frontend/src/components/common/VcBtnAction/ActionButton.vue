<template>
  <button
    @click="handleClick"
    :disabled="isLoading"
    :class="[
      'action-btn',
      `action-btn--${type}`,
      {
        'action-btn--active': optimisticActive,
        'action-btn--loading': isLoading,
        'action-btn--disabled': isLoading
      }
    ]"
    :aria-label="`${typeConfig.label} (${optimisticCount})`"
    :aria-pressed="optimisticActive"
  >
    <slot :isActive="optimisticActive" :count="optimisticCount" :isLoading="isLoading">
      <!-- Default UI -->
      <span class="action-btn__inner">
        <span class="action-btn__icon" :class="{ 'action-btn__icon--spin': isLoading }">
          <component :is="currentIcon" />
        </span>
        <span class="action-btn__label">
          {{ typeConfig.label }}
        </span>
        <span v-if="optimisticCount > 0" class="action-btn__count">
          {{ formatCount(optimisticCount) }}
        </span>
      </span>
    </slot>
  </button>
</template>

<script setup lang="ts">
import { ref, computed, watch, nextTick, onUnmounted, h } from 'vue'
import { useMutation, useQueryCache } from '@pinia/colada'
import SongActionService from '@/services/songAction.Service'
import { debounce, throttle } from 'lodash-es'
import { useShareModalStore } from '@/store/shareModal'
import QRCode from 'qrcode'

// ─── Types ────────────────────────────────────────────────────────────────────

type ActionType = 'like' | 'download' | 'comment_like' | 'share' | 'follow'


interface ItemProps {
  id: number | string
  isActive?: boolean
  count?: number
  slug?: string   // thêm slug để gen URL đẹp
}

interface ExtraProps {
  quality?: 'standard' | 'high' | 'lossless'
  parentId?: number
  [key: string]: any
}

interface TypeConfig {
  label: string
  serviceFn: (id: number | string, newValue: boolean, extra?: ExtraProps) => Promise<any>
  invalidateKeys: string[][]
  behavior: 'toggle' | 'once'
  spamStrategy: 'debounce' | 'throttle'
  delay: number
}

// ─── Props ────────────────────────────────────────────────────────────────────

const props = withDefaults(defineProps<{
  type: ActionType
  item: ItemProps
  extra?: ExtraProps
  debounceDelay?: number
}>(), {
  debounceDelay: 600
})

const emit = defineEmits<{
  success: [result: any]
  error: [err: Error]
  click: [newValue: boolean]
}>()

// ─── Share modal state ────────────────────────────────────────────────────────

const showShareModal = ref(false)
const copied = ref(false)
const qrCanvas = ref<HTMLCanvasElement | null>(null)

const shareUrl = computed(() => {
  const id = props.item.slug ?? props.item.id
  return `${window.location.origin}/songs/${id}`
})

const fbUrl = computed(() =>
  `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(shareUrl.value)}`
)
const twUrl = computed(() =>
  `https://twitter.com/intent/tweet?url=${encodeURIComponent(shareUrl.value)}`
)

// Gen QR khi modal mở
watch(showShareModal, async (val) => {
  if (!val) return
  await nextTick()
  if (qrCanvas.value) {
    await QRCode.toCanvas(qrCanvas.value, shareUrl.value, {
      width: 180,
      margin: 2,
      color: { dark: '#ffffff', light: '#18182a' },
    })
  }
})

const copyLink = async () => {
  await navigator.clipboard.writeText(shareUrl.value)
  copied.value = true
  setTimeout(() => (copied.value = false), 2000)
}

// ─── Config ───────────────────────────────────────────────────────────────────

const TYPE_CONFIG: Record<ActionType, TypeConfig> = {
  like: {
    label: 'Like',
    serviceFn: (id, newValue) => SongActionService.likeSong(Number(id), newValue),
    invalidateKeys: [['songs'], ['song_likes']],
    behavior: 'toggle',
    spamStrategy: 'debounce',
    delay: 600,
  },
  share: {
    label: 'Share',
    serviceFn: (id) => SongActionService.shareSong(Number(id)),
    invalidateKeys: [['songs']],
    behavior: 'once',
    spamStrategy: 'throttle',
    delay: 2000,
  },
  download: {
    label: 'Download',
    serviceFn: (id, _newValue, extra) =>
      SongActionService.downloadSong(Number(id), extra?.quality ?? 'standard'),
    invalidateKeys: [['songs'], ['song_downloads']],
    behavior: 'once',
    spamStrategy: 'throttle',
    delay: 3000,
  },
  comment_like: {
    label: 'Like comment',
    serviceFn: (id, newValue) => SongActionService.likeComment(Number(id), newValue),
    invalidateKeys: [['comments']],
    behavior: 'toggle',
    spamStrategy: 'debounce',
    delay: 400,
  },
  follow: {
    label: 'Follow',
    serviceFn: (id, newValue) => SongActionService.FollowArtist(Number(id), newValue),    
    invalidateKeys: [['artists'], ['song_follows']],
    behavior: 'toggle',
    spamStrategy: 'debounce',
    delay: 600,
  },
}

// ─── State ────────────────────────────────────────────────────────────────────

const queryCache = useQueryCache()
const typeConfig = computed(() => TYPE_CONFIG[props.type])

const optimisticActive = ref<boolean>(props.item.isActive ?? false)
const optimisticCount  = ref<number>(props.item.count ?? 0)
const isPendingSync    = ref(false)
    
let rollbackSnapshot = {
  active: optimisticActive.value,
  count: optimisticCount.value,
}

// ─── Mutation ─────────────────────────────────────────────────────────────────

const { mutate, isLoading } = useMutation({
  mutation: async ({ id, newValue, extra }: { id: number | string; newValue: boolean; extra?: ExtraProps }) => {
    return typeConfig.value.serviceFn(id, newValue, extra)
  },
  onSuccess(result, variables) {
    rollbackSnapshot = { active: optimisticActive.value, count: optimisticCount.value }
    isPendingSync.value = true 
    const cacheKey = props.type === 'like' ? ['songs'] : typeConfig.value.invalidateKeys[0]
    queryCache.setQueryData(cacheKey, (oldData: any) => {
      if (!oldData) return oldData
      
      if (Array.isArray(oldData)) {
        return oldData.map((item: any) => {
          if (item.id === props.item.id) {
            return {
              ...item,
              isLiked: optimisticActive.value,
              likeCount: optimisticCount.value
            }
          }
          return item
        })
      }
      return oldData
    })
    
    typeConfig.value.invalidateKeys.forEach((key) => 
      queryCache.invalidateQueries({ key })
    )
    setTimeout(() => { isPendingSync.value = false }, 1000)
    emit('success', result)
  },
  onError(err) {
    isPendingSync.value = false
    optimisticActive.value = rollbackSnapshot.active
    optimisticCount.value  = rollbackSnapshot.count
    emit('error', err as Error)
  },
})

// ─── Spam guard ───────────────────────────────────────────────────────────────

const fireMutation = (newValue: boolean) => {
  mutate({ id: props.item.id, newValue, extra: props.extra })
}

const createSpamGuard = () => {
  const config = typeConfig.value
  return config.spamStrategy === 'debounce'
    ? debounce(fireMutation, config.delay)
    : throttle(fireMutation, config.delay, { leading: true, trailing: false })
}

let spamGuard = createSpamGuard()
watch(() => props.type, () => { spamGuard.cancel?.(); spamGuard = createSpamGuard() })

// ─── Click handler ────────────────────────────────────────────────────────────
const shareModalStore = useShareModalStore()

const handleClick = () => {
   if (props.type === 'share') {
    const slug = props.item.slug ?? props.item.id
    shareModalStore.open(`${window.location.origin}/songs/${slug}`)
    spamGuard(true)
    emit('click', true)
    return
  }

  if (typeConfig.value.behavior === 'once') {
    optimisticCount.value++
    emit('click', true)
    spamGuard(true)
    return
  }

  const newValue = !optimisticActive.value
  optimisticActive.value = newValue
  optimisticCount.value = newValue
    ? optimisticCount.value + 1
    : Math.max(0, optimisticCount.value - 1)
  emit('click', newValue)
  spamGuard(newValue)
}

// ─── Sync props ───────────────────────────────────────────────────────────────

watch(
  [() => props.item.isActive, () => props.item.count],
  ([newActive, newCount]) => {
    if (isLoading.value || isPendingSync.value) return
    optimisticActive.value = newActive ?? false
    optimisticCount.value  = newCount ?? 0
    rollbackSnapshot = { active: optimisticActive.value, count: optimisticCount.value }
  }
)

onUnmounted(() => { spamGuard.cancel?.() })

// ─── Helpers ──────────────────────────────────────────────────────────────────

const formatCount = (n: number): string => {
  if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`
  if (n >= 1_000)     return `${(n / 1_000).toFixed(1)}K`
  return String(n)
}

// ─── Icons ────────────────────────────────────────────────────────────────────

const currentIcon = computed(() => {
  if (isLoading.value) return SpinnerIcon
  switch (props.type) {
    case 'like':         return optimisticActive.value ? HeartFilledIcon : HeartIcon
    case 'download':     return DownloadIcon
    case 'comment_like': return optimisticActive.value ? ThumbFilledIcon : ThumbIcon
    case 'share':        return ShareIcon
    case 'follow':       return optimisticActive.value ? FollowedIcon : FollowIcon
    default:             return HeartIcon
  }
})

const HeartIcon = () => h('svg', { width: 18, height: 18, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2 }, [
  h('path', { d: 'M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z' })
])
const HeartFilledIcon = () => h('svg', { width: 18, height: 18, viewBox: '0 0 24 24', fill: 'currentColor', stroke: 'currentColor', 'stroke-width': 2 }, [
  h('path', { d: 'M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z' })
])
const DownloadIcon = () => h('svg', { width: 18, height: 18, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2 }, [
  h('path', { d: 'M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4' }),
  h('polyline', { points: '7 10 12 15 17 10' }),
  h('line', { x1: 12, y1: 15, x2: 12, y2: 3 }),
])
const ThumbIcon = () => h('svg', { width: 18, height: 18, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2 }, [
  h('path', { d: 'M14 9V5a3 3 0 0 0-3-3l-4 9v11h11.28a2 2 0 0 0 2-1.7l1.38-9a2 2 0 0 0-2-2.3H14z' }),
  h('path', { d: 'M7 22H4a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h3' }),
])
const ThumbFilledIcon = () => h('svg', { width: 18, height: 18, viewBox: '0 0 24 24', fill: 'currentColor', stroke: 'currentColor', 'stroke-width': 2 }, [
  h('path', { d: 'M14 9V5a3 3 0 0 0-3-3l-4 9v11h11.28a2 2 0 0 0 2-1.7l1.38-9a2 2 0 0 0-2-2.3H14z' }),
  h('path', { d: 'M7 22H4a2 2 0 0 1-2-2v-7a2 2 0 0 1 2-2h3' }),
])
const ShareIcon = () => h('svg', { width: 18, height: 18, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2 }, [
  h('circle', { cx: 18, cy: 5, r: 3 }),
  h('circle', { cx: 6, cy: 12, r: 3 }),
  h('circle', { cx: 18, cy: 19, r: 3 }),
  h('line', { x1: '8.59', y1: '13.51', x2: '15.42', y2: '17.49' }),
  h('line', { x1: '15.41', y1: '6.51', x2: '8.59', y2: '10.49' }),
])
const SpinnerIcon = () => h('svg', { width: 18, height: 18, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, style: 'animation: spin 0.8s linear infinite' }, [
  h('circle', { cx: 12, cy: 12, r: 10, 'stroke-opacity': 0.25 }),
  h('path', { d: 'M12 2a10 10 0 0 1 10 10', 'stroke-linecap': 'round' }),
])
const CloseIcon = () => h('svg', { width: 16, height: 16, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2 }, [
  h('line', { x1: 18, y1: 6, x2: 6, y2: 18 }),
  h('line', { x1: 6, y1: 6, x2: 18, y2: 18 }),
])
const FollowIcon = () => h('svg', { width: 18, height: 18, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2 }, [
  h('path', { d: 'M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2' }),
  h('circle', { cx: 9, cy: 7, r: 4 }),
  h('line', { x1: 19, y1: 8, x2: 19, y2: 14 }),
  h('line', { x1: 22, y1: 11, x2: 16, y2: 11 }),
])

const FollowedIcon = () => h('svg', { width: 18, height: 18, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2 }, [
  h('path', { d: 'M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2' }),
  h('circle', { cx: 9, cy: 7, r: 4 }),
  h('polyline', { points: '16 11 18 13 22 9' }),
])
</script>

<style scoped>
/* Spinner animation (dùng cho SpinnerIcon) */
@keyframes spin {
  to { transform: rotate(360deg); }
}

.action-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  padding: 8px 14px;
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 30px;
  background: rgba(255, 255, 255, 0.05);
  color: rgba(255, 255, 255, 0.7);
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  user-select: none;
  outline: none;
}

.action-btn:hover:not(:disabled) {
  background: rgba(255, 255, 255, 0.1);
  border-color: rgba(255, 255, 255, 0.2);
  color: #fff;
  transform: translateY(-1px);
}

.action-btn:active:not(:disabled) {
  transform: translateY(0) scale(0.97);
}

/* Disabled / loading */
.action-btn--disabled,
.action-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none !important;
}

/* ── Active states theo type ── */
.action-btn--like.action-btn--active {
  color: #ef4444;
  border-color: rgba(239, 68, 68, 0.4);
  background: rgba(239, 68, 68, 0.12);
}
.action-btn--like:hover:not(:disabled) {
  border-color: rgba(239, 68, 68, 0.3);
  color: #ef4444;
}

.action-btn--download.action-btn--active,
.action-btn--download:hover:not(:disabled) {
  color: #10b981;
  border-color: rgba(16, 185, 129, 0.4);
  background: rgba(16, 185, 129, 0.12);
}

.action-btn--comment_like.action-btn--active {
  color: #3b82f6;
  border-color: rgba(59, 130, 246, 0.4);
  background: rgba(59, 130, 246, 0.12);
}

.action-btn--share:hover:not(:disabled) {
  color: #a78bfa;
  border-color: rgba(167, 139, 250, 0.4);
  background: rgba(167, 139, 250, 0.12);
}

/* ── Inner layout ── */
.action-btn__inner {
  display: inline-flex;
  align-items: center;
  gap: 5px;
}

.action-btn__icon {
  display: flex;
  align-items: center;
  flex-shrink: 0;
  transition: transform 0.15s ease;
}

.action-btn--like:active:not(:disabled) .action-btn__icon {
  transform: scale(1.3);
}

.action-btn__icon--spin svg {
  animation: spin 0.8s linear infinite;
}

.action-btn__count {
  font-size: 12px;
  font-variant-numeric: tabular-nums;
  opacity: 0.85;
}

/* Follow */
.action-btn--follow {
  padding: 6px 16px;
  font-size: 12px;
  font-weight: 600;
  border-radius: 20px;
}

.action-btn--follow:hover:not(:disabled) {
  color: #3b82f6;
  border-color: rgba(59, 130, 246, 0.4);
  background: rgba(59, 130, 246, 0.12);
}

.action-btn--follow.action-btn--active {
  color: #3b82f6;
  border-color: rgba(59, 130, 246, 0.5);
  background: rgba(59, 130, 246, 0.15);
}

/* Đổi label thành "Following" khi active */
.action-btn--follow.action-btn--active .action-btn__label::before {
  content: 'Following';
}
.action-btn--follow.action-btn--active .action-btn__label {
  font-size: 0; /* ẩn text gốc "Follow" */
}
.action-btn--follow.action-btn--active .action-btn__label::before {
  font-size: 12px;
}
</style>
<!-- components/ActionButton.vue -->
<!--
  USAGE EXAMPLES:
  
  Like button (song_likes table):
  <ActionButton
    type="like"
    :item="{ id: song.id, isActive: song.isLiked, count: song.likeCount }"
  />

  Download button (song_downloads table):
  <ActionButton
    type="download"
    :item="{ id: song.id, isActive: song.isDownloaded, count: song.downloadCount }"
    :extra="{ quality: 'high' }"
  />

  Comment like button (comments.total_likes):
  <ActionButton
    type="comment_like"
    :item="{ id: comment.id, isActive: comment.isLiked, count: comment.total_likes }"
  />

  Custom slot:
  <ActionButton type="like" :item="{ id: song.id, isActive: song.isLiked, count: song.likeCount }">
    <template #default="{ isActive, count, isLoading }">
      <MyCustomIcon :active="isActive" />
      <span>{{ count }}</span>
    </template>
  </ActionButton>
-->

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
import { ref, computed, watch, onUnmounted, h } from 'vue'
import { useMutation, useQueryCache } from '@pinia/colada'
import SongActionService from '@/services/songAction.Service'
import { debounce, throttle } from 'lodash-es'

// ─── Types ────────────────────────────────────────────────────────────────────

type ActionType = 'like' | 'download' | 'comment_like' | 'share'

interface ItemProps {
  id: number | string
  isActive?: boolean
  count?: number
}

interface ExtraProps {
  quality?: 'standard' | 'high' | 'lossless'  // dùng cho download
  parentId?: number                              // dùng cho comment
  [key: string]: any
}

interface TypeConfig {
  label: string
  // Thay buildBody + endpoint bằng serviceFn gọi thẳng vào SongActionService
  serviceFn: (id: number | string, newValue: boolean, extra?: ExtraProps) => Promise<any>
  invalidateKeys: string[][]
  // 'toggle' = like/bookmark, 'once' = download/share (không rollback)
  behavior: 'toggle' | 'once'
  // chống spam: 'debounce' = gộp nhiều click, 'throttle' = giới hạn tần suất
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

// ─── Config map theo từng loại action ────────────────────────────────────────
//
// Mỗi action map sang đúng bảng DB:
//   like         → song_likes   (user_id, song_id)
//   download     → song_downloads (user_id, song_id, quality, ...)
//   comment_like → comments.total_likes
//   share        → song_plays / analytics (chỉ ghi nhận, không toggle)
//
const TYPE_CONFIG: Record<ActionType, TypeConfig> = {
  like: {
    label: 'Like',
    serviceFn: (id, newValue) => SongActionService.likeSong(Number(id), newValue),
    invalidateKeys: [['songs'], ['song_likes']],
    behavior: 'toggle',
    spamStrategy: 'debounce',    // gộp nhiều click nhanh → chỉ gửi 1 request cuối
    delay: 600,
  },

  share: {
    label: 'Share',
    serviceFn: (id) => SongActionService.shareSong(Number(id)),
    invalidateKeys: [['songs']],
    behavior: 'once',
    spamStrategy: 'throttle',    // tránh spam share
    delay: 2000,
  },

  download: {
    label: 'Download',
    // song_downloads cần thêm quality + ghi nhận device
    serviceFn: (id, _newValue, extra) =>
      SongActionService.downloadSong(Number(id), extra?.quality ?? 'standard'),
    invalidateKeys: [['songs'], ['song_downloads']],
    behavior: 'once',            // không toggle được, chỉ trigger 1 lần
    spamStrategy: 'throttle',    // cho phép tải lại nhưng giới hạn tần suất
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
}

// ─── State ────────────────────────────────────────────────────────────────────

const queryCache = useQueryCache()
const typeConfig = computed(() => TYPE_CONFIG[props.type])

// Optimistic state — update ngay lập tức trước khi API trả về
const optimisticActive = ref<boolean>(props.item.isActive ?? false)
const optimisticCount  = ref<number>(props.item.count ?? 0)

// Snapshot để rollback nếu API lỗi
let rollbackSnapshot = {
  active: optimisticActive.value,
  count: optimisticCount.value,
}

// ─── Mutation (Pinia Colada) ──────────────────────────────────────────────────

const { mutate, isLoading, error } = useMutation({
  mutation: async ({ id, newValue, extra }: { id: number | string; newValue: boolean; extra?: ExtraProps }) => {
    // Gọi qua service thay vì fetch trực tiếp
    return typeConfig.value.serviceFn(id, newValue, extra)
  },

  onSuccess(result) {
    // Cập nhật snapshot sau khi API thành công
    rollbackSnapshot = {
      active: optimisticActive.value,
      count: optimisticCount.value,
    }
    // Invalidate các query liên quan để refetch fresh data
    typeConfig.value.invalidateKeys.forEach((key) => {
      queryCache.invalidateQueries({ key })
    })
    emit('success', result)
  },

  onError(err) {
    // Rollback về state trước đó
    optimisticActive.value = rollbackSnapshot.active
    optimisticCount.value  = rollbackSnapshot.count
    emit('error', err as Error)
    console.error(`[ActionButton:${props.type}] Error:`, err)
  },
})

// ─── Chống spam: Debounce vs Throttle ────────────────────────────────────────
//
// DEBOUNCE (like, comment_like):
//   User click liên tục → chỉ gửi request sau khi dừng click `delay`ms
//   Ví dụ: click 5 lần trong 500ms → chỉ 1 request với giá trị cuối cùng
//   Phù hợp: toggle like (tránh like/unlike liên tục gây race condition)
//
// THROTTLE (download, share):
//   Cho phép request đầu tiên đi qua, chặn các request tiếp theo trong `delay`ms
//   Ví dụ: click liên tục → request đầu đi qua, 3s sau mới cho phép lại
//   Phù hợp: download/share (1 hành động thực sự, không cần toggle)
//

const fireMutation = (newValue: boolean) => {
  mutate({
    id: props.item.id,
    newValue,
    extra: props.extra,
  })
}

// Tạo hàm chống spam dựa theo config của từng type
const createSpamGuard = () => {
  const config = typeConfig.value
  if (config.spamStrategy === 'debounce') {
    return debounce(fireMutation, config.delay)
  } else {
    // throttle với leading=true (request đầu đi ngay), trailing=false (bỏ request cuối)
    return throttle(fireMutation, config.delay, { leading: true, trailing: false })
  }
}

let spamGuard = createSpamGuard()

// Recreate khi type thay đổi
watch(() => props.type, () => {
  spamGuard.cancel?.()
  spamGuard = createSpamGuard()
})

// ─── Click handler ────────────────────────────────────────────────────────────

const handleClick = () => {
  const config = typeConfig.value

  if (config.behavior === 'once') {
    // Download / Share: không toggle, chỉ gọi 1 lần
    // Optimistic: tăng count ngay
    optimisticCount.value++
    emit('click', true)
    spamGuard(true)
    return
  }

  // Toggle (like, comment_like): Optimistic update ngay
  const newValue = !optimisticActive.value
  optimisticActive.value = newValue
  optimisticCount.value  = newValue
    ? optimisticCount.value + 1
    : Math.max(0, optimisticCount.value - 1)

  emit('click', newValue)
  spamGuard(newValue)
}

// ─── Sync props → state (khi parent cập nhật data từ server) ─────────────────

watch(
  [() => props.item.isActive, () => props.item.count],
  ([newActive, newCount]) => {
    // Không sync khi đang mutating (tránh flash rollback)
    if (isLoading.value) return
    optimisticActive.value = newActive ?? false
    optimisticCount.value  = newCount ?? 0
    rollbackSnapshot = { active: optimisticActive.value, count: optimisticCount.value }
  }
)

// ─── Cleanup ──────────────────────────────────────────────────────────────────

onUnmounted(() => {
  spamGuard.cancel?.()
})

// ─── Helpers ──────────────────────────────────────────────────────────────────

const formatCount = (n: number): string => {
  if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`
  if (n >= 1_000)     return `${(n / 1_000).toFixed(1)}K`
  return String(n)
}

// SVG Icons (inline, không cần thư viện)
const currentIcon = computed(() => {
  const active = optimisticActive.value
  const loading = isLoading.value

  if (loading) return SpinnerIcon

  switch (props.type) {
    case 'like':
      return active ? HeartFilledIcon : HeartIcon
    case 'download':
      return DownloadIcon
    case 'comment_like':
      return active ? ThumbFilledIcon : ThumbIcon
    case 'share':
      return ShareIcon
    default:
      return HeartIcon
  }
})

// ── SVG icon components (dùng h() để tránh thêm file) ────────────────────────

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

const SpinnerIcon = () => h('svg', {
  width: 18, height: 18, viewBox: '0 0 24 24', fill: 'none',
  stroke: 'currentColor', 'stroke-width': 2,
  style: 'animation: spin 0.8s linear infinite'
}, [
  h('circle', { cx: 12, cy: 12, r: 10, 'stroke-opacity': 0.25 }),
  h('path', { d: 'M12 2a10 10 0 0 1 10 10', 'stroke-linecap': 'round' }),
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
</style>
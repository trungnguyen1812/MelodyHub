<template>
  <section class="hot-albums-section px-6 py-8">
    <!-- Header -->
    <div class="flex items-center justify-between mb-8">
      <h2 class="text-3xl font-bold text-white">Hot Albums</h2>
      <div class="flex items-center gap-4">
        <button
          @click="scrollLeft"
          :disabled="currentIndex === 0"
          class="w-10 h-10 rounded-full bg-gray-800 hover:bg-gray-700 disabled:opacity-30 disabled:cursor-not-allowed text-white flex items-center justify-center transition-all duration-200"
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z" />
          </svg>
        </button>
        <button
          @click="scrollRight"
          :disabled="isAtEnd"
          class="w-10 h-10 rounded-full bg-gray-800 hover:bg-gray-700 disabled:opacity-30 disabled:cursor-not-allowed text-white flex items-center justify-center transition-all duration-200"
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M8.59 16.59L10 18l6-6-6-6-1.41 1.41L13.17 12z" />
          </svg>
        </button>
        <button
          class="text-gray-400 hover:text-white transition-colors duration-200 text-sm font-medium"
          @click="goToAllAlbums"
        >
          SEE ALL
        </button>
      </div>
    </div>

    <!-- Carousel -->
    <div class="overflow-hidden" ref="containerRef">
      <div
        class="flex gap-6 transition-transform duration-500 ease-out"
        :style="{ transform: `translateX(-${translateX}px)` }"
      >
        <div
          v-for="album in albums"
          :key="album.id"
          class="flex-shrink-0 flex flex-col cursor-pointer group"
          :style="{ width: `${ITEM_WIDTH}px` }"
          @click="navigateToAlbum(album.slug)"
        >
          <!-- Album Card -->
          <div class="relative rounded-2xl overflow-hidden shadow-2xl bg-zinc-900 transition-all duration-300 group-hover:scale-[1.03] group-hover:shadow-purple-500/20 h-full flex flex-col">            
            <!-- Album Cover -->
            <div class="relative w-full pt-[100%] overflow-hidden">
              <img
                :src="getAlbumThumbnail(album)"
                :alt="album.name"
                class="absolute inset-0 w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                @error="handleImageError"
              />

              <!-- Gradient overlay -->
              <div class="absolute inset-0 bg-gradient-to-b from-transparent via-transparent to-black/70" />

              <!-- Badge ALBUM -->
              <div class="absolute top-3 left-3 bg-black/70 text-white text-[10px] font-bold tracking-widest px-2 py-0.5 rounded-md backdrop-blur-sm">
                ALBUM
              </div>

              <!-- Play Button Overlay -->
              <div
                class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 bg-black/40"
              >
                <button
                  @click.stop="playAlbum(album)"
                  class="w-16 h-16 rounded-full bg-white text-black flex items-center justify-center shadow-2xl hover:scale-110 active:scale-95 transition-all duration-200"
                >
                  <svg width="28" height="28" viewBox="0 0 24 24" fill="currentColor" class="ml-0.5">
                    <path d="M8 5v14l11-7z" />
                  </svg>
                </button>
              </div>
            </div>

            <!-- Info -->
            <div class="p-4 flex-1 flex flex-col">
              <p class="font-semibold text-white text-base leading-tight line-clamp-2 group-hover:text-white-400 transition-colors duration-200" :title="album.name">
                {{ album.name }}
              </p>
              <p class="text-gray-400 text-sm mt-1.5 line-clamp-1" :title="album.artist?.name">
                {{ album.artist?.name }}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import router from '@/modules/router'
import type { AlbumInterface } from '@/interfaces/albums.interface'

const props = defineProps<{
  albums: AlbumInterface[]
}>()

const emit = defineEmits<{
  (e: 'playAlbum', album: AlbumInterface): void
}>()

// Constants
const ITEM_WIDTH = 210   // tăng một chút để card đẹp hơn
const SCROLL_STEP = 2

// State
const containerRef = ref<HTMLDivElement | null>(null)
const currentIndex = ref(0)
const visibleCount = ref(5)   // mặc định desktop

// Computed
const maxIndex = computed(() => Math.max(0, props.albums.length - visibleCount.value))
const isAtEnd = computed(() => currentIndex.value >= maxIndex.value)
const translateX = computed(() => currentIndex.value * ITEM_WIDTH)

// Navigation
const scrollLeft = () => {
  currentIndex.value = Math.max(0, currentIndex.value - SCROLL_STEP)
}

const scrollRight = () => {
  currentIndex.value = Math.min(maxIndex.value, currentIndex.value + SCROLL_STEP)
}

// Helpers
const goToAllAlbums = () => router.push({ name: 'client.album.allList' })

const navigateToAlbum = (slug: string) =>
  router.push({ name: 'client.album.detail', params: { slug } })

const handleImageError = (e: Event) => {
  (e.target as HTMLImageElement).src = '/default-album.jpg'
}

const getAlbumThumbnail = (album: AlbumInterface): string =>
  album.cover_url ?? '/default-album.jpg'

const playAlbum = (album: AlbumInterface) => emit('playAlbum', album)



// Responsive
const updateVisibleCount = () => {
  if (!containerRef.value) return
  const w = containerRef.value.offsetWidth

  if (w < 480) visibleCount.value = 2
  else if (w < 640) visibleCount.value = 3
  else if (w < 900) visibleCount.value = 4
  else if (w < 1200) visibleCount.value = 5
  else visibleCount.value = 6

  currentIndex.value = Math.min(currentIndex.value, maxIndex.value)
}

let ro: ResizeObserver | null = null

onMounted(() => {
  updateVisibleCount()
  ro = new ResizeObserver(updateVisibleCount)
  if (containerRef.value) ro.observe(containerRef.value)
})

onUnmounted(() => ro?.disconnect())

watch(() => props.albums, () => {
  currentIndex.value = 0
})
</script>

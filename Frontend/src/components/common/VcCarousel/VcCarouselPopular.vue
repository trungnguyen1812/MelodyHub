<template>
  <section class="hot-artists-section px-6 py-8">
    <!-- Header with title and navigation -->
    <div class="flex items-center justify-between mb-8">
      <h2 class="text-3xl font-bold text-white">Popular Music</h2>
      <div class="flex items-center gap-4">
        <button
          @click="scrollLeft"
          class="nav-btn prev-btn w-10 h-10 rounded-full bg-gray-800 hover:bg-gray-700 text-white flex items-center justify-center transition-all duration-200"
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z" />
          </svg>
        </button>
        <button
          @click="scrollRight"
          class="nav-btn next-btn w-10 h-10 rounded-full bg-gray-800 hover:bg-gray-700 text-white flex items-center justify-center transition-all duration-200"
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
            <path d="M8.59 16.59L10 18l6-6-6-6-1.41 1.41L13.17 12z" />
          </svg>
        </button>
        <button
          class="see-all-btn text-gray-400 hover:text-white transition-colors duration-200 text-sm font-medium"
          @click="AllNewMusicView"
        >
          SEE ALL
        </button>
      </div>
    </div>

    <!-- Songs Carousel -->
    <div class="carousel-container relative overflow-hidden">
      <div
        ref="carouselInner"
        class="carousel-inner flex transition-transform duration-500 ease-out gap-8"
        :style="{ transform: `translateX(-${currentOffset}px)` }"
      >
        <div
          v-for="song in populars"
          :key="song.id"
          class="song-card flex-shrink-0 flex flex-col items-center cursor-pointer group"
          :class="{ 'is-playing': isCurrentSongPlaying(song) }"
        >
          <div
            class="song-cover relative w-50 h-50 rounded-lg overflow-hidden mb-4"
            :class="{ 'playing-ring': isCurrentSongPlaying(song) && player.isPlaying }"
          >
            <img
              :src="getSongCover(song)"
              :alt="song.title"
              class="object-cover w-full h-full transition duration-300 transform group-hover:scale-105"
              :class="{ 
                'brightness-75': isCurrentSongPlaying(song) || isHovered === song.id,
                'animate-pulse-slow': isCurrentSongPlaying(song) && player.isPlaying
              }"
              @error="handleImageError"
            />

            <!-- Playing indicator badge -->
            <div 
              v-if="isCurrentSongPlaying(song) && player.isPlaying" 
              class="playing-badge absolute top-2 right-2 bg-green-500 rounded-full px-2 py-1 text-xs font-bold text-white flex items-center gap-1 shadow-lg z-10"
            >
              <span class="relative flex h-2 w-2">
                <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-white opacity-75"></span>
                <span class="relative inline-flex rounded-full h-2 w-2 bg-white"></span>
              </span>
              <span>PLAYING</span>
            </div>

            <!-- Play button overlay -->
            <div
              class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 bg-black/40"
              :class="{ 'opacity-100': isCurrentSongPlaying(song) && !player.isPlaying }"
            >
              <button
                class="play-btn w-14 h-14 rounded-full bg-white text-black flex items-center justify-center shadow-xl hover:scale-110 transition-transform duration-200"
                :class="{ 
                  'bg-green-500 text-white': isCurrentSongPlaying(song) && player.isPlaying,
                  'animate-bounce-subtle': isCurrentSongPlaying(song) && !player.isPlaying
                }"
                @click="playSong(song)"
              >
                <!-- Play icon -->
                <svg 
                  v-if="!isCurrentSongPlaying(song) || !player.isPlaying" 
                  width="20" 
                  height="20" 
                  viewBox="0 0 24 24" 
                  fill="currentColor"
                >
                  <path d="M8 5v14l11-7z" />
                </svg>
                <!-- Pause icon -->
                <svg 
                  v-else 
                  width="20" 
                  height="20" 
                  viewBox="0 0 24 24" 
                  fill="currentColor"
                >
                  <rect x="6" y="4" width="4" height="16" rx="1" />
                  <rect x="14" y="4" width="4" height="16" rx="1" />
                </svg>
              </button>
            </div>

            <!-- Vinyl effect when playing -->
            <div 
              v-if="isCurrentSongPlaying(song) && player.isPlaying" 
              class="vinyl-effect absolute inset-0 pointer-events-none"
            >
              <div class="vinyl-disc"></div>
            </div>
          </div>
          
          <div class="text-center">
            <p
              class="font-semibold text-white text-lg transition-all duration-200"
              :class="{ 
                'text-green-400': isCurrentSongPlaying(song) && player.isPlaying,
                'group-hover:opacity-60': !isCurrentSongPlaying(song)
              }"
            >
              {{ song.title }}
              <span 
                v-if="isCurrentSongPlaying(song) && player.isPlaying" 
                class="inline-block ml-2 text-green-400 animate-pulse"
              >
                ♪
              </span>
            </p>
            <p
              class="text-sm text-gray-400 mt-1 transition duration-200"
              :class="{ 'text-green-500': isCurrentSongPlaying(song) && player.isPlaying }"
            >
              {{ song.artist?.name }}
            </p>
          </div>

          <!-- Wave animation for playing song -->
          <div 
            v-if="isCurrentSongPlaying(song) && player.isPlaying" 
            class="wave-animation mt-2 flex gap-0.5 items-center justify-center"
          >
            <span class="wave-bar"></span>
            <span class="wave-bar"></span>
            <span class="wave-bar"></span>
            <span class="wave-bar"></span>
            <span class="wave-bar"></span>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import router from "@/modules/router";
import { ref, watch, onMounted, onUnmounted, computed } from "vue";
import { usePlayerStore } from '@/store/playerStore'
import { useSongStore } from '@/modules/client/stores/songs/songsStore'
import type {
    Song,
    SongMeta,
    SongFilterParams,
    SongStats,
    SongGenre,
    SongArtist
} from '@/interfaces/songs.interface'

type artist = SongArtist;
const player    = usePlayerStore()
const songStore = useSongStore()

const props = defineProps<{
  populars: Song[];
}>();

// Emits
const emit = defineEmits<{
  (e: 'playSong', song: Song): void;
}>();

const AllNewMusicView = () => {
  router.push({ name: "AllNewMusicView" });
};

const carouselInner = ref<HTMLDivElement | null>(null);
const currentOffset = ref<number>(0);
const isHovered = ref<string | number | null>(null);

const itemWidth = 192; 
const visibleItems = 6;

const isCurrentSongPlaying = (song: Song): boolean => {
  return player.currentSong?.id === song.id;
};

const getSongCover = (song: Song): string | undefined => {
  return song.cover_url ?? undefined;
};

const scrollLeft = (): void => {
  currentOffset.value = Math.max(0, currentOffset.value - itemWidth * 2);
};

const scrollRight = (): void => {
  const maxOffset = Math.max(
    0,
    (props.populars.length - visibleItems) * itemWidth
  );
  currentOffset.value = Math.min(
    currentOffset.value + itemWidth * 2,
    maxOffset
  );
};

const handleImageError = (event: Event): void => {
  const imgElement = event.target as HTMLImageElement;
  imgElement.src = "/default-album.jpg";
};

const playSong = (song: Song) => {
  if (isCurrentSongPlaying(song) && player.isPlaying) {
    player.toggle();
  } else {
    player.play(song, props.populars);
    emit('playSong', song);
  }
};

watch(() => props.populars, () => {
  currentOffset.value = 0;
});

let resizeObserver: ResizeObserver | null = null;

onMounted(() => {
  if (carouselInner.value) {
    resizeObserver = new ResizeObserver(() => {
      currentOffset.value = 0;
    });
    resizeObserver.observe(carouselInner.value);
  }
});

onUnmounted(() => {
  if (resizeObserver) {
    resizeObserver.disconnect();
  }
});
</script>

<style scoped>
.carousel-container {
  max-width: 100%;
  overflow-x: hidden;
}

.carousel-inner {
  padding-top: 10px;
  will-change: transform;
  gap: 2rem;
}

.song-card {
  width: 200px;
  transition: all 0.3s ease;
}

.song-card.is-playing {
  transform: translateY(-4px);
}

.song-cover {
  transition: all 0.3s ease;
  position: relative;
}

.song-cover.playing-ring {
  box-shadow: 0 0 0 0 rgba(74, 222, 128, 0.7);
  animation: ring-pulse 1.5s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

/* Playing badge */
.playing-badge {
  animation: slideIn 0.3s ease-out;
  backdrop-filter: blur(4px);
  background: rgba(34, 197, 94, 0.9);
}

/* Vinyl effect */
.vinyl-effect {
  animation: spin-slow 8s linear infinite;
}

.vinyl-disc {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 120%;
  height: 120%;
  background: radial-gradient(circle at 30% 30%, rgba(0,0,0,0.8) 0%, rgba(0,0,0,0.6) 100%);
  border-radius: 50%;
  opacity: 0.3;
  pointer-events: none;
}

/* Play button */
.play-btn {
  transition: all 0.2s ease;
  z-index: 20;
}

.play-btn:hover {
  transform: scale(1.1);
  background: #3b82f6;
  color: white;
}

/* Wave animation */
.wave-animation {
  height: 20px;
}

.wave-bar {
  width: 3px;
  height: 100%;
  background: linear-gradient(to top, #4ade80, #22c55e);
  border-radius: 2px;
  animation: wave 0.8s ease-in-out infinite;
}

.wave-bar:nth-child(1) { animation-delay: 0s; height: 8px; }
.wave-bar:nth-child(2) { animation-delay: 0.1s; height: 12px; }
.wave-bar:nth-child(3) { animation-delay: 0.2s; height: 16px; }
.wave-bar:nth-child(4) { animation-delay: 0.3s; height: 12px; }
.wave-bar:nth-child(5) { animation-delay: 0.4s; height: 8px; }

/* Animations */
@keyframes ring-pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(74, 222, 128, 0.7);
  }
  70% {
    box-shadow: 0 0 0 10px rgba(74, 222, 128, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(74, 222, 128, 0);
  }
}

@keyframes wave {
  0%, 100% {
    transform: scaleY(0.5);
    opacity: 0.5;
  }
  50% {
    transform: scaleY(1);
    opacity: 1;
  }
}

@keyframes spin-slow {
  from {
    transform: translate(-50%, -50%) rotate(0deg);
  }
  to {
    transform: translate(-50%, -50%) rotate(360deg);
  }
}

@keyframes slideIn {
  from {
    transform: translateX(20px);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

/* Pulse animation cho ảnh */
@keyframes pulse-slow {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.85;
  }
}

.animate-pulse-slow {
  animation: pulse-slow 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

.animate-bounce-subtle {
  animation: bounce-subtle 0.5s ease-in-out infinite;
}

@keyframes bounce-subtle {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-3px);
  }
}

/* Responsive */
@media (max-width: 1280px) {
  .song-card {
    width: 180px;
  }
}

@media (max-width: 1024px) {
  .song-card {
    width: 160px;
  }
  .carousel-inner {
    gap: 1.5rem;
  }
}

@media (max-width: 768px) {
  .song-card {
    width: 140px;
  }
  .carousel-inner {
    gap: 1rem;
  }
  .play-btn {
    width: 40px;
    height: 40px;
  }
}

@media (max-width: 640px) {
  .song-card {
    width: 120px;
  }
  .song-card p {
    font-size: 14px;
  }
}

/* Navigation buttons */
.nav-btn {
  transition: all 0.2s ease;
}

.nav-btn:hover {
  transform: scale(1.05);
  background: #3b82f6;
}

.nav-btn:active {
  transform: scale(0.95);
}

.see-all-btn {
  position: relative;
}

.see-all-btn::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 0;
  height: 1px;
  background: #3b82f6;
  transition: width 0.2s ease;
}

.see-all-btn:hover::after {
  width: 100%;
}
</style>
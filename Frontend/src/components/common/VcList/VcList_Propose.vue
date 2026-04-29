<template>
  <section class="px-6 py-8 bg-black rounded-[10px]">
    <!-- Header with title and navigation -->
    <div class="flex items-center justify-between mb-8">
      <div>
        <h2
          class="text-3xl font-bold text-white mb-1 bg-gradient-to-r from-[#22d3ee] to-[#0ea5e9] bg-clip-text text-transparent"
        >
          Propose
        </h2>
        <p class="text-gray-400 text-sm">Handpicked recommendations for you</p>
      </div>
      <div class="flex items-center gap-4">
        <button
          @click="refreshSongs"
          class="refresh-btn px-4 py-2 bg-gradient-to-r from-[#22d3ee] to-black hover:from-[#22d3ee] hover:to-gray-900 text-white text-sm font-medium rounded-full border-none transition-all duration-300 transform hover:scale-105 flex items-center gap-2"
        >
          <svg
            :class="[
              'w-4 h-4 transition-transform duration-500',
              isRefreshing ? 'animate-spin' : '',
            ]"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
            ></path>
          </svg>
          REFRESH
        </button>
      </div>
    </div>

    <!-- List songs in 3 columns -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div
        v-for="(song, index) in songs"
        :key="song.id || index"
        class="song-card bg-gradient-to-br from-black to-gray-800 backdrop-blur-sm rounded-2xl shadow-lg p-6 flex items-center gap-4 cursor-pointer group border border-gray-700/50 hover:border-[#22d3ee]/50 transition-all duration-300 transform hover:scale-[1.02] hover:shadow-2xl relative overflow-hidden"
        @click="selectSong(song)"
      >
        <!-- Background gradient overlay on hover -->
        <div
          class="absolute inset-0 bg-gradient-to-r from-[#22d3ee]/20 to-black/20 opacity-0 group-hover:opacity-100 transition-opacity duration-300 rounded-2xl"
        ></div>

        <!-- Album cover with play overlay -->
        <div class="relative z-10">
          <div
            class="relative w-16 h-16 rounded-xl overflow-hidden shadow-lg group"
          >
            <img
              :src="song.image || song.cover"
              :alt="song.title"
              class="w-full h-full object-cover transition-all duration-300 transform group-hover:scale-110 group-hover:brightness-75"
              @error="handleImageError"
            />
            <!-- Play overlay -->
            <div
              class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 bg-black/50"
            >
              <div
                :class="[
                  'w-8 h-8 rounded-full flex items-center justify-center shadow-xl transition-all duration-200 transform hover:scale-110',
                  currentPlaying?.id === song.id && isPlaying
                    ? 'bg-[#22d3ee] text-black'
                    : 'bg-white text-black hover:bg-[#22d3ee]/80',
                ]"
              >
                <svg
                  v-if="currentPlaying?.id === song.id && isPlaying"
                  class="w-4 h-4"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zM7 8a1 1 0 012 0v4a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v4a1 1 0 102 0V8a1 1 0 00-1-1z"
                    clip-rule="evenodd"
                  ></path>
                </svg>
                <svg
                  v-else
                  class="w-4 h-4 ml-0.5"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z"
                    clip-rule="evenodd"
                  ></path>
                </svg>
              </div>
            </div>
          </div>
        </div>

        <!-- Song info -->
        <div class="flex-1 min-w-0 relative z-10">
          <div class="flex items-center gap-2 mb-1">
            <h3
              class="font-semibold text-white group-hover:text-[#22d3ee] transition-colors duration-300 truncate"
            >
              {{ song.title || song.name }}
            </h3>
            <!-- Playing indicator -->
            <span
              v-if="currentPlaying?.id === song.id && isPlaying"
              class="flex items-center gap-1"
            >
              <div
                class="w-1 h-3 bg-[#22d3ee] rounded-full animate-pulse"
              ></div>
              <div
                class="w-1 h-4 bg-[#22d3ee] rounded-full animate-pulse"
                style="animation-delay: 0.2s"
              ></div>
              <div
                class="w-1 h-2 bg-[#22d3ee] rounded-full animate-pulse"
                style="animation-delay: 0.4s"
              ></div>
            </span>
          </div>
          <div
            class="text-xs uppercase font-semibold text-gray-400 group-hover:text-[#22d3ee]/80 transition-colors duration-300 truncate"
          >
            {{ song.artistName }}
          </div>
          <!-- Additional info on hover -->
          <div
            class="text-xs text-gray-500 opacity-0 group-hover:opacity-100 transition-all duration-300 transform translate-y-1 group-hover:translate-y-0 mt-1"
          >
            {{ song.displayDuration || "3:45" }} • {{ song.playsStr || "1.2M plays" }}
          </div>
        </div>

        <!-- Action buttons -->
        <div
          class="flex gap-2 relative z-10 opacity-60 group-hover:opacity-100 transition-opacity duration-300"
        >
          <button
            @click.stop="togglePlay(song)"
            class="btn-action p-2 rounded-full bg-white/10 hover:bg-[#22d3ee]/20 text-white hover:text-[#22d3ee] transition-all duration-200 hover:scale-110"
            :title="
              player.currentSong?.id === song.id && player.isPlaying ? 'Pause' : 'Play'
            "
          >
            <svg
              v-if="player.currentSong?.id === song.id && player.isPlaying"
              class="w-5 h-5"
              fill="currentColor"
              viewBox="0 0 20 20"
            >
              <path
                fill-rule="evenodd"
                d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zM7 8a1 1 0 012 0v4a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v4a1 1 0 102 0V8a1 1 0 00-1-1z"
                clip-rule="evenodd"
              ></path>
            </svg>
            <svg v-else class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M6 3L20 12 6 21 6 3z"></path>
            </svg>
          </button>

        </div>
      </div>
    </div>

    <!-- Removed internal player bar to use Global Mini Player -->
  </section>
</template>

<script setup>
import { ref, onMounted, computed, watch } from "vue";
import { toRefs } from "vue";
import { usePlayerStore } from '@/store/playerStore';
import ActionButton from '@/components/common/VcBtnAction/ActionButton.vue'

const props = defineProps({
  songs: {
    type: Array,
    required: true,
  },
});

const { songs } = toRefs(props);
const player = usePlayerStore();
const isRefreshing = ref(false);

// Methods
const handleImageError = (event) => {
  event.target.src =
    "https://via.placeholder.com/200x200/6B7280/FFFFFF?text=No+Image";
};

// Map raw object back to Song interface for playerStore if needed
const mapToPlayer = (s) => ({
  ...s,
  urls: s.urls || {
    standard: s.song_url ?? null,
  }
});

const selectSong = (song) => {
  player.play(song, songs.value);
};

const togglePlay = (song) => {
  selectSong(song);
};

const toggleFavorite = (song) => {
  song.isFavorite = !song.isFavorite;
  console.log(
    `${song.isFavorite ? "Added to" : "Removed from"} favorites: ${
      song.title || song.name
    }`
  );
};

const refreshSongs = async () => {
  if (isRefreshing.value) return;
  isRefreshing.value = true;
  emit('refresh');
  // Tự tắt spinner sau 800ms phòng parent không callback
  setTimeout(() => { isRefreshing.value = false; }, 800);
};

// Emits for parent component
const emit = defineEmits(["play", "pause", "songChange", "favorite", "refresh"]);
</script>

<style scoped>
.song-card {
  backdrop-filter: blur(10px);
}

.song-card:hover {
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5),
    0 0 0 1px rgba(34, 211, 238, 0.4);
}

.btn-action {
  backdrop-filter: blur(10px);
}

/* Custom range slider */
.slider::-webkit-slider-thumb {
  appearance: none;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  background: #ffffff;
  cursor: pointer;
  box-shadow: 0 0 10px #22d3ee;
}

.slider::-moz-range-thumb {
  width: 16px;
  height: 16px;
  border-radius: 50%;
  background: #ffffff;
  cursor: pointer;
  border: none;
  box-shadow: 0 0 10px #22d3ee;
}

/* Animation for playing bars */
@keyframes pulse {
  0%,
  100% {
    transform: scaleY(1);
  }
  50% {
    transform: scaleY(0.5);
  }
}

.animate-pulse {
  animation: pulse 1s ease-in-out infinite;
}

/* Refresh button animation */
.refresh-btn:hover {
  box-shadow: 0 10px 25px rgba(34, 211, 238, 0.3);
}

:deep(.action-btn) {
  padding: 6px 12px !important;
  min-width: 70px;
}

:deep(.action-btn__inner) {
  gap: 4px;
}

:deep(.action-btn__icon svg) {
  width: 16px;
  height: 16px;
}

:deep(.action-btn__label) {
  font-size: 12px;
}

:deep(.action-btn__count) {
  font-size: 11px;
}
</style>
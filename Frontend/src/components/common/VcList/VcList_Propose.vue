<template>
  <section class="px-6 py-8 bg-black">
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
            {{ song.artist }}
          </div>
          <!-- Additional info on hover -->
          <div
            class="text-xs text-gray-500 opacity-0 group-hover:opacity-100 transition-all duration-300 transform translate-y-1 group-hover:translate-y-0 mt-1"
          >
            {{ song.duration || "3:45" }} • {{ song.plays || "1.2M plays" }}
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
              currentPlaying?.id === song.id && isPlaying ? 'Pause' : 'Play'
            "
          >
            <svg
              v-if="currentPlaying?.id === song.id && isPlaying"
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

          <button
            @click.stop="toggleFavorite(song)"
            :class="[
              'btn-action p-2 rounded-full transition-all duration-200 hover:scale-110',
              song.isFavorite
                ? 'bg-red-500/20 text-red-400 hover:bg-red-500/30'
                : 'bg-white/10 hover:bg-red-500/20 text-white hover:text-red-400',
            ]"
            title="Add to favorites"
          >
            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"
              ></path>
            </svg>
          </button>
        </div>
      </div>
    </div>

    <!-- Currently Playing Bar -->
    <Transition
      enter-active-class="transition-all duration-500 ease-out"
      enter-from-class="transform translate-y-full opacity-0"
      enter-to-class="transform translate-y-0 opacity-100"
      leave-active-class="transition-all duration-300 ease-in"
      leave-from-class="transform translate-y-0 opacity-100"
      leave-to-class="transform translate-y-full opacity-0"
    >
      <div
        v-if="currentPlaying"
        class="fixed bottom-0 left-0 right-0 bg-gradient-to-r from-[#22d3ee]/95 to-black/95 backdrop-blur-xl border-t border-[#22d3ee]/30 p-4 z-50 shadow-2xl"
      >
        <div class="flex items-center justify-between max-w-7xl mx-auto">
          <!-- Song info -->
          <div class="flex items-center gap-4 flex-1 min-w-0">
            <div class="relative">
              <img
                :src="currentPlaying.image || currentPlaying.cover"
                :alt="currentPlaying.title"
                class="w-14 h-14 rounded-xl object-cover shadow-lg"
              />
              <div
                v-if="isPlaying"
                class="absolute -top-1 -right-1 w-4 h-4 bg-[#22d3ee] rounded-full flex items-center justify-center"
              >
                <div class="w-2 h-2 bg-black rounded-full animate-pulse"></div>
              </div>
            </div>
            <div class="min-w-0 flex-1">
              <p class="text-white font-semibold truncate">
                {{ currentPlaying.title || currentPlaying.name }}
              </p>
              <p class="text-[#22d3ee]/80 text-sm truncate">
                {{ currentPlaying.artist }}
              </p>
            </div>
          </div>

          <!-- Control buttons -->
          <div class="flex items-center gap-6 mx-8">
            <button
              @click="previousSong"
              class="p-2 text-white hover:text-[#22d3ee] transition-colors duration-200"
              title="Previous"
            >
              <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
                <path
                  fill-rule="evenodd"
                  d="M15.707 15.707a1 1 0 01-1.414 0l-5-5a1 1 0 010-1.414l5-5a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 010 1.414zm-6 0a1 1 0 01-1.414 0l-5-5a1 1 0 010-1.414l5-5a1 1 0 111.414 1.414L5.414 10l4.293 4.293a1 1 0 010 1.414z"
                  clip-rule="evenodd"
                ></path>
              </svg>
            </button>

            <button
              @click="togglePlay(currentPlaying)"
              class="p-3 bg-white rounded-full text-black hover:bg-[#22d3ee]/80 transition-all duration-200 transform hover:scale-105 shadow-lg"
            >
              <svg
                v-if="isPlaying"
                class="w-6 h-6"
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
                class="w-6 h-6"
                fill="currentColor"
                viewBox="0 0 20 20"
              >
                <path
                  fill-rule="evenodd"
                  d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z"
                  clip-rule="evenodd"
                ></path>
              </svg>
            </button>

            <button
              @click="nextSong"
              class="p-2 text-white hover:text-[#22d3ee] transition-colors duration-200"
              title="Next"
            >
              <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
                <path
                  fill-rule="evenodd"
                  d="M4.293 4.293a1 1 0 011.414 0l5 5a1 1 0 010 1.414l-5 5a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414zm6 0a1 1 0 011.414 0l5 5a1 1 0 010 1.414l-5 5a1 1 0 01-1.414-1.414L14.586 10l-4.293-4.293a1 1 0 010-1.414z"
                  clip-rule="evenodd"
                ></path>
              </svg>
            </button>
          </div>

          <!-- Volume and close -->
          <div class="flex items-center gap-4">
            <div class="flex items-center gap-2">
              <svg
                class="w-5 h-5 text-white"
                fill="currentColor"
                viewBox="0 0 20 20"
              >
                <path
                  fill-rule="evenodd"
                  d="M9.383 3.076A1 1 0 0110 4v12a1 1 0 01-1.707.707L4.586 13H2a1 1 0 01-1-1V8a1 1 0 011-1h2.586l3.707-3.707a1 1 0 011.09-.217zM12.293 7.293a1 1 0 011.414 0L15 8.586l1.293-1.293a1 1 0 111.414 1.414L16.414 10l1.293 1.293a1 1 0 01-1.414 1.414L15 11.414l-1.293 1.293a1 1 0 01-1.414-1.414L13.586 10l-1.293-1.293a1 1 0 010-1.414z"
                  clip-rule="evenodd"
                ></path>
              </svg>
              <input
                v-model="volume"
                type="range"
                min="0"
                max="100"
                class="w-20 h-1 bg-[#22d3ee]/50 rounded-lg appearance-none cursor-pointer slider"
              />
            </div>
            <button
              @click="closeMusicPlayer"
              class="p-2 text-white hover:text-red-400 transition-colors duration-200"
              title="Close player"
            >
              <svg
                class="w-5 h-5"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M6 18L18 6M6 6l12 12"
                ></path>
              </svg>
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </section>
</template>

<script setup>
import { ref, onMounted, computed } from "vue";
import { toRefs } from "vue";

const props = defineProps({
  songs: {
    type: Array,
    required: true,
  },
});

const { songs } = toRefs(props);

// Player state
const currentPlaying = ref(null);
const isPlaying = ref(false);
const volume = ref(75);
const isRefreshing = ref(false);

// Methods
const handleImageError = (event) => {
  event.target.src =
    "https://via.placeholder.com/200x200/6B7280/FFFFFF?text=No+Image";
};

const selectSong = (song) => {
  if (currentPlaying.value?.id === song.id) {
    isPlaying.value = !isPlaying.value;
  } else {
    currentPlaying.value = song;
    isPlaying.value = true;
  }
  console.log(
    `${isPlaying.value ? "Playing" : "Paused"}: ${song.title || song.name}`
  );
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
  isRefreshing.value = true;
  await new Promise((resolve) => setTimeout(resolve, 1000));
  isRefreshing.value = false;
  console.log("Songs refreshed!");
};

const closeMusicPlayer = () => {
  currentPlaying.value = null;
  isPlaying.value = false;
};

const nextSong = () => {
  if (!currentPlaying.value || !songs.value?.length) return;

  const currentIndex = songs.value.findIndex(
    (song) => song.id === currentPlaying.value.id
  );
  const nextIndex = (currentIndex + 1) % songs.value.length;
  selectSong(songs.value[nextIndex]);
};

const previousSong = () => {
  if (!currentPlaying.value || !songs.value?.length) return;

  const currentIndex = songs.value.findIndex(
    (song) => song.id === currentPlaying.value.id
  );
  const prevIndex =
    currentIndex === 0 ? songs.value.length - 1 : currentIndex - 1;
  selectSong(songs.value[prevIndex]);
};

// Emits for parent component
const emit = defineEmits(["play", "pause", "songChange", "favorite"]);

// Watch for changes
import { watch } from "vue";

watch(
  [currentPlaying, isPlaying],
  ([newSong, newIsPlaying], [oldSong, oldIsPlaying]) => {
    if (newSong && newSong !== oldSong) {
      emit("songChange", newSong);
    }

    if (newIsPlaying !== oldIsPlaying) {
      if (newIsPlaying && newSong) {
        emit("play", newSong);
      } else if (newSong) {
        emit("pause", newSong);
      }
    }
  }
);
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
</style>
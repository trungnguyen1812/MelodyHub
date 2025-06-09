```vue
<template>
  <section class="music-player-section px-6 py-8 bg-gradient-to-br from-black via-gray-900 to-black min-h-screen">
    <!-- Header -->
    <div class="flex items-center justify-between mb-8">
      <div>
        <h2 class="text-4xl font-bold text-white mb-2 bg-gradient-to-r from-[#22d3ee] to-[#0ea5e9] bg-clip-text text-transparent">
          Popular Music
        </h2>
        <p class="text-gray-400 text-lg">Discover the most popular songs</p>
      </div>
    </div>

    <!-- Music List -->
    <div class="space-y-4">
      <div
        v-for="(song, index) in populars"
        :key="song.id"
        class="music-item flex items-center gap-6 p-4 rounded-xl bg-gradient-to-r from-black/50 to-gray-800/30 backdrop-blur-sm border border-gray-700/50 cursor-pointer group hover:from-[#22d3ee]/30 hover:to-black/20 hover:border-[#22d3ee]/50 transition-all duration-300 transform hover:scale-[1.02] hover:shadow-2xl"
      >
        <!-- Track Number -->
        <div class="flex items-center justify-center w-8 h-8 text-gray-400 font-bold group-hover:text-white transition-colors duration-300">
          <span class="group-hover:hidden">{{ String(index + 1).padStart(2, '0') }}</span>
          <svg class="w-5 h-5 hidden group-hover:block text-[#22d3ee]" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd"></path>
          </svg>
        </div>

        <!-- Album Cover -->
        <div class="relative w-16 h-16 rounded-lg overflow-hidden flex-shrink-0 shadow-lg">
          <img
            :src="song.cover || song.image"
            :alt="song.title"
            class="object-cover w-full h-full transition-all duration-300 transform group-hover:scale-110 group-hover:brightness-75"
            @error="handleImageError"
          />
          <div
            class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 bg-black/50"
          >
            <button
              @click="togglePlay(song)"
              :class="[
                'play-btn w-8 h-8 rounded-full flex items-center justify-center shadow-xl transition-all duration-200 transform hover:scale-110',
                currentPlaying?.id === song.id && isPlaying 
                  ? 'bg-[#22d3ee] text-black' 
                  : 'bg-white text-black hover:bg-[#22d3ee]/80'
              ]"
            >
              <svg v-if="currentPlaying?.id === song.id && isPlaying" class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zM7 8a1 1 0 012 0v4a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v4a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd"></path>
              </svg>
              <svg v-else class="w-4 h-4 ml-0.5" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd"></path>
              </svg>
            </button>
          </div>
        </div>

        <!-- Song Info -->
        <div class="flex-1 min-w-0">
          <div class="flex items-center gap-2 mb-1">
            <h3 class="font-semibold text-white text-lg group-hover:text-[#22d3ee] transition-colors duration-300 truncate">
              {{ song.title || song.name }}
            </h3>
            <span v-if="currentPlaying?.id === song.id && isPlaying" class="flex items-center gap-1 text-[#22d3ee]">
              <div class="w-1 h-3 bg-[#22d3ee] rounded-full animate-pulse"></div>
              <div class="w-1 h-4 bg-[#22d3ee] rounded-full animate-pulse" style="animation-delay: 0.2s"></div>
              <div class="w-1 h-2 bg-[#22d3ee] rounded-full animate-pulse" style="animation-delay: 0.4s"></div>
            </span>
          </div>
          <div class="flex items-center gap-2 text-sm text-gray-400">
            <span class="group-hover:text-[#22d3ee]/80 transition-colors duration-300">{{ song.artist }}</span>
            <span>•</span>
            <span>{{ song.album }}</span>
          </div>
        </div>

        <!-- Song Stats -->
        <div class="hidden md:flex items-center gap-6 text-sm text-gray-400">
          <div class="flex items-center gap-1">
            <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M9.383 3.076A1 1 0 0110 4v12a1 1 0 01-1.707.707L4.586 13H2a1 1 0 01-1-1V8a1 1 0 011-1h2.586l3.707-3.707a1 1 0 011.09-.217zM15.657 6.343a1 1 0 011.414 0A9.972 9.972 0 0119 12a9.972 9.972 0 01-1.929 5.657 1 1 0 11-1.414-1.414A7.971 7.971 0 0017 12c0-2.21-.895-4.21-2.343-5.657a1 1 0 010-1.414zm-2.829 2.828a1 1 0 011.415 0A5.983 5.983 0 0115 12a5.983 5.983 0 01-.757 2.829 1 1 0 11-1.415-1.414A3.987 3.987 0 0013 12a3.987 3.987 0 00-.172-1.415 1 1 0 010-1.414z" clip-rule="evenodd"></path>
            </svg>
            <span>{{ song.plays }}</span>
          </div>
          <div class="flex items-center gap-1">
            <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"></path>
            </svg>
            <span>{{ song.duration }}</span>
          </div>
        </div>

        <!-- Actions -->
        <div class="flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-all duration-300">
          <button class="p-2 hover:bg-[#22d3ee]/20 rounded-full transition-colors duration-200" title="Add to favorites">
            <svg class="w-5 h-5 text-gray-400 hover:text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path>
            </svg>
          </button>
          <button class="p-2 hover:bg-[#22d3ee]/20 rounded-full transition-colors duration-200" title="More options">
            <svg class="w-5 h-5 text-gray-400 hover:text-[#22d3ee]" fill="currentColor" viewBox="0 0 20 20">
              <path d="M10 6a2 2 0 110-4 2 2 0 010 4zM10 12a2 2 0 110-4 2 2 0 010 4zM10 18a2 2 0 110-4 2 2 0 010 4z"></path>
            </svg>
          </button>
        </div>
      </div>
    </div>

    <!-- Currently Playing Bar (if any) -->
    <div 
      v-if="currentPlaying && isPlaying" 
      class="fixed bottom-0 left-0 right-0 bg-gradient-to-r from-[#22d3ee]/95 to-black/95 backdrop-blur-md border-t border-[#22d3ee]/30 p-4 z-50"
    >
      <div class="flex items-center justify-between max-w-6xl mx-auto">
        <div class="flex items-center gap-4">
          <img 
            :src="currentPlaying.cover || currentPlaying.image" 
            :alt="currentPlaying.title"
            class="w-12 h-12 rounded-lg object-cover"
          />
          <div>
            <p class="text-white font-semibold">{{ currentPlaying.title }}</p>
            <p class="text-[#22d3ee]/80 text-sm">{{ currentPlaying.artist }}</p>  
          </div>
        </div>
        <div class="flex items-center gap-4">
          <button @click="togglePlay(currentPlaying)" class="p-3 bg-white rounded-full text-black hover:bg-[#22d3ee]/80 transition-colors duration-200">
            <svg v-if="isPlaying" class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zM7 8a1 1 0 012 0v4a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v4a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd"></path>
            </svg>
            <svg v-else class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd"></path>
            </svg>
          </button>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, toRefs } from "vue";

// Props
const props = defineProps({
  populars: {
    type: Array,
    required: true,
  },
});

const { populars } = toRefs(props);

// Player state
const currentPlaying = ref(null);
const isPlaying = ref(false);

// Methods
const handleImageError = (event) => {
  event.target.src = "https://via.placeholder.com/200x200/22d3ee/FFFFFF?text=No+Image";
};

const togglePlay = (song) => {
  if (currentPlaying.value?.id === song.id) {
    // Toggle play/pause for current song
    isPlaying.value = !isPlaying.value;
  } else {
    // Play new song
    currentPlaying.value = song;
    isPlaying.value = true;
  }
  
  // Here you would integrate with actual audio player
  console.log(isPlaying.value ? `Playing: ${song.title}` : `Paused: ${song.title}`);
};

// Emits (for parent component integration)
const emit = defineEmits(['play', 'pause', 'songChange']);

// Watch for state changes to emit events
import { watch } from 'vue';

watch([currentPlaying, isPlaying], ([newSong, newIsPlaying], [oldSong, oldIsPlaying]) => {
  if (newSong && newSong !== oldSong) {
    emit('songChange', newSong);
  }
  
  if (newIsPlaying !== oldIsPlaying) {
    if (newIsPlaying) {
      emit('play', newSong);
    } else {
      emit('pause', newSong);
    }
  }
});
</script>

<style scoped>
.music-item:hover {
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3), 0 10px 10px -5px rgba(34, 211, 238, 0.2);
}

.play-btn {
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.3), 0 4px 6px -2px rgba(34, 211, 238, 0.2);
}

/* Custom scrollbar */
.music-player-section::-webkit-scrollbar {
  width: 8px;
}

.music-player-section::-webkit-scrollbar-track {
  background: #1f2937;
  border-radius: 4px;
}

.music-player-section::-webkit-scrollbar-thumb {
  background: #22d3ee;
  border-radius: 4px;
}

.music-player-section::-webkit-scrollbar-thumb:hover {
  background: #0ea5e9;
}

/* Animation for playing indicator */
@keyframes pulse {
  0%, 100% {
    transform: scaleY(1);
  }
  50% {
    transform: scaleY(0.5);
  }
}

.animate-pulse {
  animation: pulse 1s ease-in-out infinite;
}
</style>
```
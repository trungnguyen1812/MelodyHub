<template>
  <div v-if="loading" class="loading-screen">
    <div class="loading-inner">
      <div class="loading-bars">
        <span></span><span></span><span></span><span></span><span></span>
      </div>
      <p class="loading-text">Loading your music...</p>
    </div>
  </div>

  <div v-else class="space-y-8">
    <div class="relative w-full overflow-hidden h-[250px] mt-[20px]">
      <VcSlide :slides="slideList" />
    </div>

    <!-- Main Sections -->
    <div class="content-container pb-20">
      <VcCarouselArtists :artists="dataArtist" />
      <VcNewMusic :songs="dataNewSong" />
      <VcCarouselPopular :populars="PopularSong" />
      
      <!-- Chart and Propose Section -->
      <div class="grid grid-cols-1 xl:grid-cols-1 gap-8 mt-12">
        <VcListPropose :songs="proposeSongs" @refresh="refreshPropose" />
        <VcChart :songs="chartSongs" />
      </div>

      <VcTypeMusic />
    </div>
  </div>
</template>


<script setup lang="ts">
import { onMounted, computed, ref } from 'vue'
import VcSlide from "@/components/common/VcSlide/VcSlide.vue";
import VcCarouselArtists from "@/components/common/VcCarousel/VcCarouselArtists.vue";
import VcNewMusic from "@/components/common/VcCarousel/VcCarouselNewMusic.vue";
import VcCarouselPopular from "@/components/common/VcCarousel/VcCarouselPopular.vue";
import VcListPropose from "@/components/common/VcList/VcList_Propose.vue";
import VcChart from '@/components/common/VcChart/VcChart.vue';
import VcTypeMusic from "@/components/common/VcList/Vclist_Categories.vue";

import { useArtistStore, getFullImageUrl } from '@/modules/client/stores/artists/artistsStore'
import { useSongStore } from '@/modules/client/stores/songs/songsStore'
import bg1 from "@/assets/images/bg-img/preview-page2.jpg";
import bg2 from "@/assets/images/bg-img/preview-page1.jpg";
import bg3 from "@/assets/images/bg-img/preview-page0.jpg";

const artistStore = useArtistStore()
const dataArtist = computed(() =>
  artistStore.artists.map(a => ({
    ...a,
    avatar_url: getFullImageUrl(a.avatar_url),
    banner_url: getFullImageUrl(a.banner_url)
  }))
)

const songStore = useSongStore()
const dataNewSong = computed(() => songStore.newSongs)
const PopularSong = computed(() => songStore.popularSongs)

// Mapping for VcChart & VcListPropose - Standardizing metadata
const formatDuration = (seconds: number) => {
  const mins = Math.floor(seconds / 60)
  const secs = seconds % 60
  return `${mins}:${secs.toString().padStart(2, '0')}`
}

const formatNumber = (n: number) =>
  n >= 1_000_000 ? (n / 1_000_000).toFixed(1) + 'M'
  : n >= 1_000   ? (n / 1_000).toFixed(1) + 'K'
  : String(n)

const chartSongs = computed(() => {
  return songStore.popularSongs.slice(0, 5).map(s => ({
    ...s, // Preserve all original fields
    artistName: s.artist?.name || 'Unknown Artist',
    popularity: Math.floor(Math.random() * 20) + 80,
    cover: getFullImageUrl(s.cover_url),
    displayDuration: formatDuration(s.duration),
    totalPlaysStr: formatNumber(s.stats?.total_plays || s.total_plays || 0)
  }))
})

const proposeSongs = computed(() => {
  return songStore.suggestedSongs.map(s => ({
    ...s, // Preserve all original fields
    artistName: s.artist?.name || 'Unknown Artist',
    image: getFullImageUrl(s.cover_url),
    displayDuration: formatDuration(s.duration),
    playsStr: formatNumber(s.stats?.total_plays || s.total_plays || 0) + ' plays'
  }))
})

// Only show full-page loading if initial essential data is missing
const isInitialLoading = ref(true)
const loading = computed(() => {
  const isEssentialDataLoading = artistStore.loading && artistStore.artists.length === 0;
  return isInitialLoading.value || isEssentialDataLoading;
})

const refreshPropose = () => {
  songStore.fetchSuggestedSongs(9)
}

onMounted(async () => {
  // Synchronous-looking but parallel fetches
  await Promise.allSettled([
    artistStore.fetchArtists(10),
    songStore.fetchNewSongs(10),
    songStore.fetchPopularSongs(10),
    songStore.fetchSuggestedSongs(9)
  ])
  isInitialLoading.value = false
})

const slideList = [
  { bg: bg1, title: "Beyond Time",      subtitle: "LATEST ALBUM", button: "Discover"   },
  { bg: bg2, title: "Echoes of Nature", subtitle: "NEW RELEASE",  button: "Listen Now" },
  { bg: bg3, title: "Rise Again",       subtitle: "FEATURED",     button: "Explore"    },
]
</script>

<style scoped>
/* General Buttons */
.nav-btn {
  @apply w-10 h-10 rounded-full bg-gray-800 hover:bg-gray-700 text-white flex items-center justify-center transition-all duration-200;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}
.nav-btn:hover {
  transform: scale(1.05);
}

/* See All */
.see-all-btn {
  @apply text-gray-400 hover:text-white transition-colors duration-200 text-sm font-medium font-semibold;
}

/* Artist Carousel */
.artist-card {
  width: 160px;
  min-width: 160px;
}
.artist-avatar {
  border: 3px solid transparent;
  transition: border-color 0.3s ease;
}
.artist-card:hover .artist-avatar {
  border-color: white;
}
.play-btn {
  @apply w-14 h-14 rounded-full bg-white text-black flex items-center justify-center hover:scale-110 transition-transform duration-200;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
}

.carousel-inner {
  will-change: transform;
  scroll-behavior: smooth;
  gap: 2rem;
}

/* Hide scrollbar */
.carousel-container::-webkit-scrollbar {
  display: none;
}
.carousel-container {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

/* Responsive Design */
@media (max-width: 1024px) {
  .artist-card {
    width: 140px;
    min-width: 140px;
  }
  .artist-avatar {
    width: 8.5rem;
    height: 8.5rem;
  }
}
@media (max-width: 768px) {
  .hot-artists-section {
    padding: 1.5rem 1rem;
  }
  .artist-card {
    width: 120px;
    min-width: 120px;
  }
  .artist-avatar {
    width: 7rem;
    height: 7rem;
  }
}
.loading-screen {
  position: fixed;
  inset: 0;
  background: #000;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}

.loading-inner {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 24px;
}

.loading-bars {
  display: flex;
  align-items: flex-end;
  gap: 5px;
  height: 48px;
}

.loading-bars span {
  display: block;
  width: 5px;
  background: #00aaff;
  border-radius: 3px;
  animation: bar-bounce 1s ease-in-out infinite;
}

.loading-bars span:nth-child(1) { animation-delay: 0s;    height: 20px; }
.loading-bars span:nth-child(2) { animation-delay: 0.15s; height: 32px; }
.loading-bars span:nth-child(3) { animation-delay: 0.3s;  height: 48px; background: #22d3ee; }
.loading-bars span:nth-child(4) { animation-delay: 0.45s; height: 32px; }
.loading-bars span:nth-child(5) { animation-delay: 0.6s;  height: 20px; }

@keyframes bar-bounce {
  0%, 100% { transform: scaleY(0.4); opacity: 0.5; }
  50%       { transform: scaleY(1);   opacity: 1;   }
}

.loading-text {
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: rgba(255, 255, 255, 0.35);
}
</style>

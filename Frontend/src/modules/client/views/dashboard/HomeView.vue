<template>
  <div v-if="loading" class="flex justify-center items-center h-screen">
    <span class="loading loading-spinner loading-lg text-black"></span>
  </div>

  <div v-else>
    <div class="relative w-full overflow-hidden h-[250px] mt-[20px]">
      <VcSlide :slides="slideList" />
    </div>
    <VcCarouselArtists :artists="dataArtist" />
    <VcNewMusic :songs="dataNewSong" />
    <VcCarouselPopular :populars="PopularSong" />
    <!-- <VcListPropose :songs="songs"/>
    <VcChart :songs="songs"/> -->
    <VcTypeMusic />
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

const loading = computed(() => artistStore.loading || songStore.loading)

onMounted(() => {
  artistStore.fetchArtists(10)
  songStore.fetchNewSongs(10)
  songStore.fetchPopularSongs(10)
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
</style>

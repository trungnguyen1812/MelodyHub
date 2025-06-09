<template>
  <section class="hot-artists-section px-6 py-8 bg-gradient-to-br from-gray-900 via-black to-gray-800 min-h-screen relative">
    <!-- Header with title and navigation -->
    <div class="flex items-center justify-between mb-8">
      <div>
        <h2 class="text-3xl font-bold text-white mb-1 bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent">
          Hot Artists
        </h2>
        <p class="text-gray-400 text-sm">discover the hottest singers</p>
      </div>
    </div>

    <!-- Artist List -->
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
      <div
        v-for="artist in enhancedArtists"
        :key="artist.id"
        class="artist-card flex items-center space-x-4 p-4 bg-gray-800 rounded-lg hover:bg-gray-700 transition"
        @click="goToArtistSongs(artist)"
      >
        <div class="relative w-20 h-20 rounded-full overflow-hidden flex-shrink-0 group">
          <img
            :src="artist.image"
            :alt="artist.name"
            class="object-cover w-full h-full transition duration-300 group-hover:brightness-75"
            @error="handleImageError"
          />
          <div class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition duration-300">
            <button
              class="play-btn w-10 h-10 rounded-full bg-white text-black flex items-center justify-center shadow-xl hover:scale-110 transition-transform duration-200"
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path d="M8 5v14l11-7z" />
              </svg>
            </button>
          </div>
        </div>
        <div>
          <p class="font-semibold text-white text-lg group-hover:opacity-60 transition-colors duration-200">
            {{ artist.name }}
          </p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import router from "@/modules/router";
import { toRefs , computed  } from "vue";

const generateSlug = (name) => {
  return name
    .normalize("NFD")                       // bỏ dấu
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/\s+/g, "-")
    .replace(/[^\w-]+/g, "");
};

const enhancedArtists = computed(() =>
  artists.value.map((artist) => ({
    ...artist,
    slug: generateSlug(artist.name),
  }))
);


// Props
const props = defineProps({
  artists: {
    type: Array,
    required: true,
  },
});
const { artists } = toRefs(props);

// Xử lý lỗi ảnh
const handleImageError = (event) => {
  event.target.src = "/default-artist.jpg";
};

// Chuyển sang trang artist song
const goToArtistSongs = (artist) => {
  router.push({
    name: "ArtistSongs",
    params: { artistSlug: artist.slug },
  });
};
</script>

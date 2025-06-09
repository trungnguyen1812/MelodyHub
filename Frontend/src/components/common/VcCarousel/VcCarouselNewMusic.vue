<template>
  <section class="hot-artists-section px-6 py-8">
    <!-- Header with title and navigation -->
    <div class="flex items-center justify-between mb-8">
      <h2 class="text-3xl font-bold text-white">Release New Music</h2>
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

    <!-- Artists Carousel -->
    <div class="carousel-container relative overflow-hidden">
      <div
        ref="carouselInner"
        class="carousel-inner flex transition-transform duration-500 ease-out gap-8"
        :style="{ transform: `translateX(-${currentOffset}px)` }"
      >
        <div
          v-for="newMusic in newMusics"
          :key="newMusics.id"
          class="artist-card flex-shrink-0 flex flex-col items-center cursor-pointer group"
        >
          <div
            class="artist-avatar relative w-50 h-50 rounded-lg overflow-hidden mb-4"
          >
            <img
              :src="newMusic.image"
              :alt="newMusic.name"
              class="object-cover w-full h-full transition duration-300 transform group-hover:scale-105 group-hover:brightness-75"
              @error="handleImageError"
            />

            <div
              class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition duration-300"
            >
              <button
                class="play-btn w-14 h-14 rounded-full bg-white text-black flex items-center justify-center shadow-xl hover:scale-110 transition-transform duration-200"
              >
                <svg
                  width="20"
                  height="20"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                >
                  <path d="M8 5v14l11-7z" />
                </svg>
              </button>
            </div>
          </div>
          <div class="text-center">
            <p
              class="font-semibold text-white text-lg group-hover:opacity-60 transition-colors duration-200"
            >
              {{ newMusic.name }}
            </p>
            <p
              class="text-sm text-gray-400 mt-1 group-hover:opacity-50 transition duration-200"
            >
              {{ newMusic.artist }}
            </p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import router from "@/modules/router";
import { ref, onMounted, watch } from "vue";
import { toRefs } from "vue";

// Props nhận từ ngoài
const props = defineProps({
  newMusics: {
    type: Array,
    required: true,
  },
});

const AllNewMusicView =()=>{
  router.push({name: "AllNewMusicView"})
}

const { newMusics } = toRefs(props);

const carouselInner = ref(null);
const currentOffset = ref(0);

const itemWidth = 192; // 40*4.8 + gap (kiểm tra lại css nếu khác)
const visibleItems = 6;

// Scroll trái
const scrollLeft = () => {
  currentOffset.value = Math.max(0, currentOffset.value - itemWidth * 2);
};

// Scroll phải
const scrollRight = () => {
  const maxOffset = Math.max(
    0,
    (newMusics.value.length - visibleItems) * itemWidth
  );
  currentOffset.value = Math.min(
    currentOffset.value + itemWidth * 2,
    maxOffset
  );
};

// Xử lý ảnh lỗi
const handleImageError = (event) => {
  event.target.src = "/default-artist.jpg";
};

// Nếu dữ liệu artists thay đổi hoặc resize cửa sổ => reset offset hoặc tính lại offset nếu cần
watch(newMusics, () => {
  currentOffset.value = 0;
});
</script>

<style scoped>
/* Bạn có thể thêm CSS tùy chỉnh tại đây nếu cần */
</style>

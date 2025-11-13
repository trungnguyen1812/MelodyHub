<template>
  <div class="relative w-full overflow-hidden h-[250px] mt-[20px]">
    <div
      class="flex transition-transform duration-700 ease-in-out"
      :style="{ transform: `translateX(-${currentIndex * 100}%)` }"
    >
      <SlideItem
        v-for="(slide, index) in slides"
        :key="index"
        v-bind="slide"
      />
    </div>

    <!-- Nút điều hướng -->
    <button
      class="absolute top-1/2 left-4 transform -translate-y-1/2 bg-gray-800 text-white px-2 py-1 rounded disabled:opacity-40 disabled:cursor-not-allowed"
      @click="prevSlide"
      :disabled="currentIndex === 0"
    >
      <i class="bx bx-chevron-left"></i>
    </button>

    <button
      class="absolute top-1/2 right-4 transform -translate-y-1/2 bg-gray-800 text-white px-2 py-1 rounded disabled:opacity-40 disabled:cursor-not-allowed"
      @click="nextSlide"
      :disabled="currentIndex === slides.length - 1"
    >
      <i class="bx bx-chevron-right"></i>
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import SlideItem from "@/components/common/VcSlide/SlideItem.vue";

interface Slide {
  bg: string;
  title: string;
  subtitle: string;
  button: string;
}

const props = defineProps<{
  slides: Slide[];
}>();

const currentIndex = ref(0); // bắt đầu từ slide đầu tiên

function nextSlide() {
  if (currentIndex.value < props.slides.length - 1) {
    currentIndex.value++;
  }
}

function prevSlide() {
  if (currentIndex.value > 0) {
    currentIndex.value--;
  }
}
</script>

<style scoped>
button:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}
</style>

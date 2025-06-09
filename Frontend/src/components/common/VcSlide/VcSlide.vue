<template>
  <div class="relative w-full overflow-hidden h-[250px] mt-[20px]">
    <div
      class="flex transition-transform duration-700 ease-in-out"
      :style="{ transform: `translateX(-${currentIndex * 100}%)` }"
      :class="{ 'transition-none': !isTransitioning }"
      @transitionend="handleTransitionEnd"
    >
      <!-- Clone last slide -->
      <SlideItem v-bind="slides[slides.length - 1]" />

      <!-- Real slides -->
      <SlideItem v-for="(slide, index) in slides" :key="index" v-bind="slide" />

      <!-- Clone first slide -->
      <SlideItem v-bind="slides[0]" />
    </div>

    <!-- Nút điều hướng -->
    <button
      class="absolute top-1/2 left-4 transform -translate-y-1/2 bg-gray-800 text-white px-2 py-1 rounded"
      @click="prevSlide"
    >
     <i class='bx  bx-keyframe-ease-in bx-rotate-180'  ></i> 
    </button>
    <button
      class="absolute top-1/2 right-4 transform -translate-y-1/2 bg-gray-800 text-white px-2 py-1 rounded"
      @click="nextSlide"
    >
      <i class='bx  bx-keyframe-ease-out bx-rotate-180'  ></i>  
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref, nextTick } from "vue";
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

const currentIndex = ref(1); // Bắt đầu từ slide thật đầu tiên
const isTransitioning = ref(true);

function nextSlide() {
  if (isTransitioning.value) {
    currentIndex.value++;
  }
}

function prevSlide() {
  if (isTransitioning.value) {
    currentIndex.value--;
  }
}

function handleTransitionEnd() {
  if (currentIndex.value === props.slides.length + 1) {
    // Khi đến slide clone đầu tiên (sau slide cuối thật)
    isTransitioning.value = false;
    currentIndex.value = 1; // Nhảy về slide đầu thật
    nextTick(() => {
      isTransitioning.value = true; // Bật lại transition
    });
  } else if (currentIndex.value === 0) {
    // Khi đến slide clone cuối (trước slide đầu thật)
    isTransitioning.value = false;
    currentIndex.value = props.slides.length; // Nhảy về slide cuối thật
    nextTick(() => {
      isTransitioning.value = true; // Bật lại transition
    });
  }
}
</script>

<style scoped>
.transition-none {
  transition: none !important;
}
</style>
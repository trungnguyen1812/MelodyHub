<template>
  <div
    class="min-w-full hero bg-cover bg-center"
    :style="{ backgroundImage: `url(${bg})` }"
  >
    <div class="hero-overlay bg-opacity-60"></div>
    <div class="hero-content text-center text-neutral-content">
      <div class="max-w-md">
        <p class="mb-3 text-sm">{{ subtitle }}</p>
        <h1 class="mb-4 text-3xl font-bold fadeInUp">{{ title }}</h1>
        <button class="btn btn-outline">{{ button }}</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  bg: string;
  title: string;
  subtitle: string;
  button: string;
}>();
</script>

<style scoped>
@keyframes fadeInUp {
  0% {
    opacity: 0;
    transform: translateY(20px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}
.fadeInUp {
  animation: fadeInUp 1s ease forwards;
}
</style>

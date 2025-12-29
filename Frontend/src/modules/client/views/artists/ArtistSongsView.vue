<template>
  <section class="px-6 py-8">
    <h2 class="text-3xl font-bold text-white mb-6">
      Songs by {{ artist?.name || artistSlug }}
    </h2>
    <div v-if="songs.length" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
      <div v-for="song in songs" :key="song.id" class="p-4 bg-gray-800 rounded-lg hover:bg-gray-700">
        <p class="text-white text-lg font-semibold mb-1">{{ song.title }}</p>
        <p class="text-sm text-gray-400">Duration: {{ song.duration }}</p>
      </div>
    </div>
    <div v-else class="text-gray-400">No songs found for this artist.</div>
  </section>
</template>

<script setup lang="ts">
import { onMounted, ref } from "vue";
import { useRoute } from "vue-router";

const route = useRoute();
const artistSlug = route.params.artistSlug as string;

const artist = ref<any>(null);
const songs = ref<any[]>([]);

onMounted(async () => {
});
</script>

<style scoped>

</style>
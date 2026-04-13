<template>
  <div class="all-genres-page">
    <div class="header-section">
      
      <h1 class="page-title">Discover Music Genres</h1>
      <p class="page-subtitle">Explore our diverse collection of music categories</p>
      
      <div class="search-wrap">
        <div class="search-box">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
          </svg>
          <input 
            type="text" 
            v-model="searchQuery" 
            placeholder="Search genres..." 
            class="search-input"
          />
        </div>
      </div>
    </div>

    <div v-if="genreStore.loading" class="loading-state">
      <div class="spinner"></div>
      <p>Loading genres...</p>
    </div>

    <div v-else class="genres-grid">
      <div 
        v-for="genre in filteredGenres" 
        :key="genre.id"
        class="genre-card"
        :style="{ '--accent-color': genre.color || '#3b82f6' }"
        @click="navigateToGenre(genre.slug)"
      >
        <div class="card-image-wrap">
          <img :src="getFullImageUrl(genre.cover_url)" :alt="genre.name" class="genre-image" @error="handleImageError" />
          <div class="card-overlay">
            <div class="play-icon">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                <polygon points="5 3 19 12 5 21 5 3"/>
              </svg>
            </div>
          </div>
        </div>
        <div class="card-info">
          <h3 class="genre-name">{{ genre.name }}</h3>
          <p class="genre-desc">{{ genre.description || 'Explore the best of ' + genre.name }}</p>
        </div>
        <div class="card-glow"></div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useGenrestore, getFullImageUrl } from '@/modules/client/stores/genres/genresStore';

const genreStore = useGenrestore();
const router = useRouter();
const searchQuery = ref('');

onMounted(async () => {
  if (genreStore.Genres.length === 0) {
    await genreStore.fetchGenres();
  }
});

const filteredGenres = computed(() => {
  if (!searchQuery.value) return genreStore.Genres;
  const query = searchQuery.value.toLowerCase();
  return genreStore.Genres.filter(g => 
    g.name.toLowerCase().includes(query) || 
    (g.description && g.description.toLowerCase().includes(query))
  );
});

const navigateToGenre = (slug: string) => {
  router.push({ name: 'genre.detail', params: { slug } });
};

const handleImageError = (e: any) => {
  e.target.src = '/images/default-genre.png';
};
</script>

<style scoped>
.all-genres-page {
  padding: 40px 60px;
  min-height: 100vh;
}

.header-section {
  text-align: center;
  margin-bottom: 60px;
}

.page-title {
  font-size: 3.5rem;
  font-weight: 800;
  background: linear-gradient(to right, #60a5fa, #a78bfa, #f472b6);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  margin-bottom: 12px;
}

.page-subtitle {
  color: #94a3b8;
  font-size: 1.1rem;
  margin-bottom: 32px;
}

.search-wrap {
  display: flex;
  justify-content: center;
}

.search-box {
  display: flex;
  align-items: center;
  padding: 12px 24px;
  background: rgba(30, 41, 59, 0.5);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 99px;
  width: 100%;
  max-width: 500px;
  color: #fff;
  transition: all 0.3s;
}

.search-box:focus-within {
  border-color: #3b82f6;
  box-shadow: 0 0 20px rgba(59, 130, 246, 0.3);
  background: rgba(30, 41, 59, 0.8);
}

.search-box svg {
  color: #64748b;
  margin-right: 12px;
}

.search-input {
  background: transparent;
  border: none;
  outline: none;
  color: white;
  width: 100%;
  font-size: 1rem;
}

.genres-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 32px;
}

.genre-card {
  position: relative;
  background: rgba(30, 41, 59, 0.4);
  backdrop-filter: blur(16px);
  border: 1px solid rgba(255, 255, 255, 0.05);
  border-radius: 24px;
  padding: 16px;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  overflow: hidden;
}

.genre-card:hover {
  transform: translateY(-10px) scale(1.02);
  border-color: var(--accent-color);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.4);
}

.card-image-wrap {
  position: relative;
  width: 100%;
  height: 180px;
  border-radius: 18px;
  overflow: hidden;
  margin-bottom: 20px;
}

.genre-image {
  width: 100%;
  height: 100%;
  object-cover: cover;
  transition: transform 0.6s;
}

.genre-card:hover .genre-image {
  transform: scale(1.1);
}

.card-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s;
}

.genre-card:hover .card-overlay {
  opacity: 1;
}

.play-icon {
  width: 60px;
  height: 60px;
  background: var(--accent-color);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  transform: scale(0.5) translateY(20px);
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.genre-card:hover .play-icon {
  transform: scale(1) translateY(0);
  box-shadow: 0 0 30px var(--accent-color);
}

.card-info {
  position: relative;
  z-index: 2;
}

.genre-name {
  color: white;
  font-size: 1.4rem;
  font-weight: 700;
  margin-bottom: 8px;
}

.genre-desc {
  color: #94a3b8;
  font-size: 0.9rem;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  line-height: 1.5;
}

.card-glow {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(800px circle at var(--mouse-x) var(--mouse-y), rgba(255, 255, 255, 0.06), transparent 40%);
  z-index: 1;
  pointer-events: none;
}

.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100px 0;
  color: #94a3b8;
}

.spinner {
  width: 50px;
  height: 50px;
  border: 3px solid rgba(255, 255, 255, 0.1);
  border-top-color: #3b82f6;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 16px;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

@media (max-width: 768px) {
  .all-genres-page {
    padding: 30px 20px;
  }
  .page-title {
    font-size: 2.5rem;
  }
  .genres-grid {
    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  }
}
</style>

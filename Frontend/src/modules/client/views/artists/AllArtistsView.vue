<template>
  <div class="artists-explorer">
    <div class="glow-bg" aria-hidden="true"></div>

    <!-- Header Section -->
    <header class="section-header">
      <div class="header-content">
        <button class="back-nav-btn" @click="$router.back()">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
            <path fill-rule="evenodd" d="M17 10a.75.75 0 0 1-.75.75H5.612l4.158 3.96a.75.75 0 1 1-1.04 1.08l-5.5-5.25a.75.75 0 0 1 0-1.08l5.5-5.25a.75.75 0 1 1 1.04 1.08L5.612 9.25H16.25A.75.75 0 0 1 17 10Z" clip-rule="evenodd" />
          </svg>
          Back
        </button>
        <h1 class="page-title">
          <span class="gradient-text">Artist</span>
          <span class="count-badge" v-if="artists.length">{{ filteredArtists.length }} / {{ artists.length }}</span>
        </h1>
        <p class="page-desc">Discover your favorite artists on MelodyHub</p>
      </div>
      
      <div class="search-wrapper">
        <div class="search-box">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="18" height="18" class="search-icon">
            <path fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11ZM2 9a7 7 0 1 1 12.452 4.391l3.328 3.329a.75.75 0 1 1-1.06 1.06l-3.329-3.328A7 7 0 0 1 2 9Z" clip-rule="evenodd" />
          </svg>
          <input 
            type="text" 
            v-model="searchQuery" 
            placeholder="Tìm kiếm nghệ sĩ..." 
            class="search-input"
          />
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="page-container">
      
      <!-- Loading State -->
      <div v-if="loading" class="artists-grid">
        <div v-for="i in 12" :key="i" class="skeleton-card">
          <div class="skeleton-avatar"></div>
          <div class="skeleton-text"></div>
          <div class="skeleton-subtext"></div>
        </div>
      </div>

      <!-- Content Grid -->
      <template v-else>
        <div v-if="filteredArtists.length > 0" class="artists-grid" >
          <div 
            v-for="artist in filteredArtists" 
            :key="artist.id" 
            class="artist-card" 
            @click="navigateToArtist(artist.slug)"
          >
            <div class="avatar-container">
              <img 
                :src="getFullImageUrl(artist.avatar_url)" 
                :alt="artist.name" 
                class="artist-avatar"
                @error="handleImageError"
              />
              <div class="play-overlay">
                <div class="play-btn">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="24" height="24">
                    <path fill-rule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clip-rule="evenodd" />
                  </svg>
                </div>
              </div>
            </div>
            <div class="artist-info">
              <h3 class="artist-name">
                {{ artist.name }}
                <svg v-if="artist.verified" class="verified-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm3.857-9.809a.75.75 0 0 0-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 1 0-1.06 1.061l2.5 2.5a.75.75 0 0 0 1.137-.089l4-5.5Z" clip-rule="evenodd" />
                </svg>
              </h3>
              <span class="artist-type">Artist</span>
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-else class="empty-state">
          <div class="empty-icon">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" width="64" height="64">
              <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
            </svg>
          </div>
          <h2>No artists found.</h2>
          <p>Try searching with a different name or explore other categories..</p>
          <button @click="searchQuery = ''" class="reset-btn">Delete search</button>
        </div>
      </template>

    </main>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import { useArtistStore, getFullImageUrl } from '@/modules/client/stores/artists/artistsStore';
import { storeToRefs } from 'pinia';

const router = useRouter();
const artistStore = useArtistStore();
const { artists, loading } = storeToRefs(artistStore);

const searchQuery = ref('');

const filteredArtists = computed(() => {
  if (!searchQuery.value) return artists.value;
  const q = searchQuery.value.toLowerCase();
  return artists.value.filter(a => a.name.toLowerCase().includes(q));
});

const navigateToArtist = (slug: string) => {
  router.push({ name: 'client.artist.songs', params: { slug } });
};

const handleImageError = (e: Event) => {
  const img = e.target as HTMLImageElement;
  img.src = '/images/default-avatar.png';
};



onMounted(async () => {
  if (artists.value.length === 0) {
    await artistStore.fetchAllArtists();
  }
});
</script>

<style scoped>
.artists-explorer {
  min-height: 100vh;
  color: #fff;
  padding-bottom: 60px;
  position: relative;
  overflow: hidden;
}

.glow-bg {
  position: absolute;
  top: -100px;
  right: -100px;
  width: 500px;
  height: 500px;
  background: radial-gradient(circle, rgba(0, 160, 255, 0.1) 0%, transparent 70%);
  z-index: 0;
  pointer-events: none;
}

.page-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 40px;
  position: relative;
  z-index: 1;
}

/* Header */
.section-header {
  padding: 60px 40px 40px;
  max-width: 1400px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  gap: 30px;
  position: relative;
  z-index: 2;
}

.header-content { flex: 1; }

.page-title {
  font-size: 40px;
  font-weight: 800;
  margin: 0 0 8px;
  display: flex;
  align-items: center;
  gap: 16px;
}

.gradient-text {
  background: linear-gradient(135deg, #fff 0%, rgba(255,255,255,0.7) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.count-badge {
  background: rgba(0, 160, 255, 0.1);
  color: #00aaff;
  padding: 4px 12px;
  border-radius: 99px;
  font-size: 14px;
  font-weight: 600;
  border: 1px solid rgba(0, 160, 255, 0.2);
}

.page-desc {
  color: rgba(255,255,255,0.5);
  font-size: 16px;
  margin: 0;
}

/* Search */
.search-wrapper { min-width: 320px; }

.search-box {
  position: relative;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 12px;
  display: flex;
  align-items: center;
  padding: 0 16px;
  transition: all 0.3s;
}

.search-box:focus-within {
  background: rgba(255,255,255,0.08);
  border-color: rgba(0, 160, 255, 0.5);
  box-shadow: 0 0 20px rgba(0, 160, 255, 0.1);
}

.search-icon { color: rgba(255,255,255,0.3); flex-shrink: 0; }

.search-input {
  background: transparent;
  border: none;
  color: #fff;
  padding: 12px 10px;
  width: 100%;
  font-size: 14px;
  outline: none;
}

/* Grid */
.artists-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 32px;
}

/* Artist Card */
.artist-card {
  background: rgba(255,255,255,0.03);
  padding: 24px;
  border-radius: 20px;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(255,255,255,0.03);
  text-align: center;
}

.artist-card:hover {
  background: rgba(255,255,255,0.07);
  transform: translateY(-8px);
  border-color: rgba(255,255,255,0.1);
  box-shadow: 0 20px 40px rgba(0,0,0,0.4);
}

.avatar-container {
  width: 160px;
  height: 160px;
  margin: 0 auto 20px;
  position: relative;
  border-radius: 50%;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(0,0,0,0.3);
}

.artist-avatar {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.6s;
}

.artist-card:hover .artist-avatar { transform: scale(1.1); }

.play-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s;
}

.artist-card:hover .play-overlay { opacity: 1; }

.play-btn {
  background: #00aaff;
  color: #000;
  width: 56px;
  height: 56px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transform: translateY(20px);
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  box-shadow: 0 8px 20px rgba(0, 160, 255, 0.4);
}

.artist-card:hover .play-btn { transform: translateY(0); }

.artist-info { margin-top: 10px; }

.artist-name {
  font-size: 18px;
  font-weight: 700;
  margin: 0 0 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  color: #fff;
}

.verified-icon { color: #00aaff; flex-shrink: 0; }

.artist-type {
  font-size: 14px;
  color: rgba(255,255,255,0.4);
  font-weight: 500;
}

/* Skeleton */
.skeleton-card {
  background: rgba(255,255,255,0.03);
  padding: 24px;
  border-radius: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.skeleton-avatar {
  width: 160px;
  height: 160px;
  border-radius: 50%;
  background: rgba(255,255,255,0.05);
  margin-bottom: 20px;
  animation: pulse 1.5s infinite;
}

.skeleton-text {
  width: 100px;
  height: 18px;
  background: rgba(255,255,255,0.05);
  border-radius: 4px;
  margin-bottom: 8px;
  animation: pulse 1.5s infinite;
}

.skeleton-subtext {
  width: 60px;
  height: 14px;
  background: rgba(255,255,255,0.05);
  border-radius: 4px;
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0% { opacity: 0.5; }
  50% { opacity: 1; }
  100% { opacity: 0.5; }
}

/* Empty State */
.empty-state {
  grid-column: 1 / -1;
  text-align: center;
  padding: 100px 0;
  color: rgba(255,255,255,0.4);
}

.empty-icon { margin-bottom: 20px; }
.empty-state h2 { color: #fff; margin-bottom: 12px; }
.reset-btn {
  margin-top: 20px;
  background: rgba(255,255,255,0.1);
  color: #fff;
  border: none;
  padding: 10px 24px;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s;
}
.reset-btn:hover { background: rgba(255,255,255,0.2); }

/* Responsive */
@media (max-width: 900px) {
  .section-header { flex-direction: column; align-items: flex-start; padding: 40px 20px; }
  .search-wrapper { width: 100%; min-width: unset; }
  .page-container { padding: 0 20px; }
  .artists-grid { grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 20px; }
  .avatar-container { width: 120px; height: 120px; }
}
.back-nav-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  color: #fff;
  padding: 10px 18px;
  border-radius: 99px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  margin-bottom: 32px;
  transition: all 0.2s;
  width: fit-content;
}

.back-nav-btn:hover {
  background: rgba(255,255,255,0.1);
  transform: translateX(-4px);
}
</style>

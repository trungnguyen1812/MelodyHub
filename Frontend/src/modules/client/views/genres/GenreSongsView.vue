<template>
  <div class="genre-detail-page">
    <div class="bg-blur-container">
      <div v-if="genre?.cover_url" class="banner-blur" :style="{ backgroundImage: `url(${getFullImageUrl(genre.cover_url)})` }"></div>
      <div v-else class="banner-blur-placeholder"></div>
    </div>

    <div class="content-container">
      <!-- Back Button -->
      <button class="back-nav-btn" @click="$router.push({ name: 'genres.all' })">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M17 10a.75.75 0 0 1-.75.75H5.612l4.158 3.96a.75.75 0 1 1-1.04 1.08l-5.5-5.25a.75.75 0 0 1 0-1.08l5.5-5.25a.75.75 0 1 1 1.04 1.08L5.612 9.25H16.25A.75.75 0 0 1 17 10Z" clip-rule="evenodd" />
        </svg>
        All Genres
      </button>

      <!-- Loading State -->
      <div v-if="genreStore.loading" class="loading-overlay">
        <div class="spinner"></div>
        <p>Loading genre music...</p>
      </div>

      <template v-else-if="genre">
        <!-- Genre Header -->
        <header class="genre-header">
          <div class="profile-main">
            <div class="avatar-wrap">
              <img :src="getFullImageUrl(genre.cover_url)" :alt="genre.name" class="profile-avatar border-glow" :style="{ '--accent-color': genre.color || '#3b82f6' }" />
            </div>
            <div class="profile-info">
              <div class="type-pill">Genre Exploration</div>
              <h1 class="genre-name">{{ genre.name }}</h1>
              <p class="genre-tagline">{{ genre.description || 'Discover the latest and greatest in ' + genre.name + ' music.' }}</p>
              <div class="stats-row">
                <span class="stat-item">
                  <b>{{ songs.length }}</b>
                  <span>Songs</span>
                </span>
                <span class="dot">·</span>
                <span class="stat-item">
                  <b>{{ formatNumbers(totalPlays) }}</b>
                  <span>Plays</span>
                </span>
              </div>
            </div>
          </div>

          <div class="header-actions">
            <button class="play-all-btn" :style="{ background: genre.color || '#3b82f6' }" @click="playAll">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                <path fill-rule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clip-rule="evenodd" />
              </svg>
              Play all
            </button>
            <button class="fav-btn">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
              </svg>
            </button>
          </div>
        </header>

        <!-- Song List Section -->
        <section class="songs-section glass-container">
          <div v-if="songs.length" class="songs-list">
            <!-- Header row -->
            <div class="songs-list-header">
              <span>#</span>
              <span>Title</span>
              <span class="col-plays">Plays</span>
              <span class="col-duration">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm.75-13a.75.75 0 0 0-1.5 0v5c0 .414.336.75.75.75h4a.75.75 0 0 0 0-1.5h-3.25V5Z" clip-rule="evenodd" />
                </svg>
              </span>
              <span></span>
            </div>

            <div
              v-for="(song, index) in songs"
              :key="song.id"
              class="song-row"
              :class="{ 'is-active': player.currentSong?.id === song.id }"
              @click="playSong(song)"
            >
              <!-- Rank / Wave -->
              <div class="s-rank">
                <span class="rank-num" v-if="!(player.currentSong?.id === song.id && player.isPlaying)">
                  {{ (index as number) + 1 }}
                </span>
                <span class="rank-wave" v-else>
                  <span :style="{ background: genre.color || '#3b82f6' }"></span>
                  <span :style="{ background: genre.color || '#3b82f6' }"></span>
                  <span :style="{ background: genre.color || '#3b82f6' }"></span>
                </span>
              </div>

              <!-- Cover + Info -->
              <div class="s-info">
                <div class="s-cover">
                  <img :src="getFullImageUrl(song.cover_url)" alt="cover" />
                  <div class="s-cover-overlay">
                    <svg v-if="!(player.currentSong?.id === song.id && player.isPlaying)"
                      xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
                      <path fill-rule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clip-rule="evenodd" />
                    </svg>
                    <svg v-else xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="16" height="16">
                      <path fill-rule="evenodd" d="M6.75 5.25a.75.75 0 0 1 .75-.75H9a.75.75 0 0 1 .75.75v13.5a.75.75 0 0 1-.75.75H7.5a.75.75 0 0 1-.75-.75V5.25Zm7.5 0A.75.75 0 0 1 15 4.5h1.5a.75.75 0 0 1 .75.75v13.5a.75.75 0 0 1-.75.75H15a.75.75 0 0 1-.75-.75V5.25Z" clip-rule="evenodd" />
                    </svg>
                  </div>
                </div>
                <div class="s-details">
                  <div class="s-title">{{ song.title }}</div>
                  <div class="s-artist">{{ song.artist?.name || 'Unknown Artist' }}</div>
                </div>
              </div>

              <!-- Plays -->
              <div class="s-plays col-plays">
                {{ formatNumbers(song.total_plays || (song.stats?.total_plays) || 0) }}
              </div>

              <!-- Duration -->
              <div class="s-duration col-duration">{{ formatDuration(song.duration) }}</div>

              <!-- Actions -->
              <div class="s-actions">
                <button class="row-action-btn" @click.stop>
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
                    <path d="M10 3a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM10 8.5a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3ZM11.5 15.5a1.5 1.5 0 1 0-3 0 1.5 1.5 0 0 0 3 0Z" />
                  </svg>
                </button>
              </div>
            </div>
          </div>

          <div v-else class="empty-songs">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.2" stroke="currentColor" width="48" height="48">
              <path stroke-linecap="round" stroke-linejoin="round" d="m9 9 10.5-3m0 6.553v3.75a2.25 2.25 0 0 1-1.632 2.163l-1.32.377a1.803 1.803 0 1 1-2.8-1.452l.328-.094a1.125 1.125 0 0 0 .764-1.235V5.11a.75.75 0 0 0-.272-.578l-7.5 5.75a.75.75 0 0 0-.228.531V16.65c0 .543-.321 1.03-.815 1.235l-1.32.378a1.803 1.803 0 1 1-2.8-1.452l.328-.094a1.125 1.125 0 0 0 .764-1.235V10.5c0-.621.504-1.125 1.125-1.125h1.5" />
            </svg>
            <p>No songs found in this genre yet.</p>
          </div>
        </section>
      </template>

      <!-- Error State -->
      <div v-else class="error-state">
        <h2>Genre not found.</h2>
        <p>Return to explore our available music categories.</p>
        <button @click="$router.push({ name: 'genres.all' })" class="back-btn">Browse Genres</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRoute } from 'vue-router';
import { useGenrestore, getFullImageUrl } from '@/modules/client/stores/genres/genresStore';
import { usePlayerStore } from '@/store/playerStore';
import type { Song } from '@/interfaces/songs.interface';

const route = useRoute();
const genreStore = useGenrestore();
const player = usePlayerStore();

const genre = computed(() => genreStore.currentGenre);
const songs = computed(() => genreStore.currentSongs);

const totalPlays = computed(() => {
  return songs.value.reduce((acc, song) => acc + (song.total_plays || (song.stats?.total_plays) || 0), 0);
});

// Map song to player format
const mapSong = (song: any): Song => {
  return {
    ...song,
    urls: song.urls || {
      standard: song.song_url ?? null,
      hq: song.song_url_hq ?? null,
      lossless: song.song_url_lossless ?? null,
    }
  };
};

const playSong = (song: any): void => {
  const mapped = mapSong(song);
  const queue = songs.value.map(mapSong);
  player.play(mapped, queue);
};

const playAll = (): void => {
  if (!songs.value.length) return;
  const queue = songs.value.map(mapSong);
  player.play(queue[0], queue);
};

const formatDuration = (seconds: number): string => {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${mins}:${secs.toString().padStart(2, '0')}`;
};

const formatNumbers = (n: number | string): string => {
  const num = typeof n === 'string' ? parseInt(n) : n;
  if (isNaN(num)) return '0';
  return num >= 1_000_000 ? (num / 1_000_000).toFixed(1) + 'M'
    : num >= 1_000 ? (num / 1_000).toFixed(1) + 'K'
      : String(num);
};

onMounted(async () => {
  const slug = route.params.slug as string;
  await genreStore.fetchGenreDetail(slug);
});
</script>

<style scoped>
.genre-detail-page {
  min-height: 100vh;
  color: #fff;
  position: relative;
  overflow-x: hidden;
  background: #080e14;
}

.bg-blur-container {
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 600px;
  overflow: hidden;
  z-index: 0;
  mask-image: linear-gradient(to bottom, black 40%, transparent 100%);
}

.banner-blur {
  width: 100%; height: 100%;
  background-size: cover;
  background-position: center;
  filter: blur(80px) saturate(1.8) opacity(0.2);
  transform: scale(1.1);
}

.banner-blur-placeholder {
  width: 100%; height: 100%;
  background: radial-gradient(circle at 30% 50%, #1a2a3a 0%, #080e14 100%);
  filter: blur(60px);
}

.content-container {
  position: relative;
  z-index: 1;
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 40px 100px;
}

.back-nav-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  color: #94a3b8;
  padding: 8px 16px;
  border-radius: 99px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  margin-bottom: 40px;
  transition: all 0.3s;
}

.back-nav-btn:hover {
  background: rgba(255,255,255,0.1);
  color: #fff;
  transform: translateX(-5px);
}

.genre-header {
  display: flex;
  flex-direction: column;
  gap: 32px;
  margin-bottom: 48px;
}

.profile-main {
  display: flex;
  align-items: center;
  gap: 40px;
}

.avatar-wrap {
  width: 240px;
  height: 240px;
  flex-shrink: 0;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 20px 40px rgba(0,0,0,0.4);
}

.profile-avatar {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.border-glow {
  border: 2px solid var(--accent-color);
  box-shadow: 0 0 20px var(--accent-color);
}

.profile-info {
  flex: 1;
}

.type-pill {
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
  color: #94a3b8;
  letter-spacing: 2px;
  margin-bottom: 8px;
}

.genre-name {
  font-size: 4.5rem;
  font-weight: 900;
  margin: 0 0 12px;
  line-height: 1;
  letter-spacing: -2px;
}

.genre-tagline {
  color: #94a3b8;
  font-size: 1.1rem;
  margin-bottom: 24px;
  max-width: 600px;
}

.stats-row {
  display: flex;
  align-items: center;
  gap: 20px;
  color: #64748b;
}

.stat-item { display: flex; align-items: center; gap: 8px; }
.stat-item b { color: #fff; font-size: 1.2rem; }
.dot { font-size: 20px; }

.header-actions {
  display: flex;
  align-items: center;
  gap: 20px;
}

.play-all-btn {
  padding: 14px 32px;
  border-radius: 99px;
  font-weight: 700;
  color: #fff;
  border: none;
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.play-all-btn:hover {
  transform: scale(1.05);
  box-shadow: 0 10px 20px rgba(0,0,0,0.3);
}

.fav-btn {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s;
}

.fav-btn:hover {
  background: rgba(255,255,255,0.15);
  color: #ef4444;
}

/* Song List Section */
.glass-container {
  background: rgba(15, 23, 42, 0.3);
  backdrop-filter: blur(20px);
  border-radius: 24px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  padding: 24px;
}

.songs-list-header {
  display: grid;
  grid-template-columns: 50px 1fr 150px 100px 50px;
  padding: 12px 16px;
  color: #64748b;
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 1px;
  border-bottom: 1px solid rgba(255,255,255,0.05);
  margin-bottom: 8px;
}

.song-row {
  display: grid;
  grid-template-columns: 50px 1fr 150px 100px 50px;
  align-items: center;
  padding: 12px 16px;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s;
}

.song-row:hover {
  background: rgba(255,255,255,0.05);
}

.song-row.is-active {
  background: rgba(255,255,255,0.08);
}

.s-rank {
  display: flex;
  justify-content: center;
}

.rank-num { color: #64748b; }

.rank-wave {
  display: flex;
  align-items: flex-end;
  gap: 3px;
  height: 16px;
}

.rank-wave span {
  width: 3px;
  border-radius: 2px;
  animation: wave 1s ease-in-out infinite;
}

@keyframes wave {
  0%, 100% { height: 4px; }
  50% { height: 16px; }
}

.s-info {
  display: flex;
  align-items: center;
  gap: 16px;
}

.s-cover {
  width: 48px;
  height: 48px;
  border-radius: 8px;
  overflow: hidden;
  position: relative;
}

.s-cover img { width: 100%; height: 100%; object-fit: cover; }

.s-cover-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: 0.2s;
}

.song-row:hover .s-cover-overlay { opacity: 1; }

.s-details {
  display: flex;
  flex-direction: column;
}

.s-title { font-weight: 600; color: #fff; margin-bottom: 2px; }
.s-artist { font-size: 13px; color: #64748b; }

.song-row.is-active .s-title { color: #fff; text-shadow: 0 0 10px rgba(255,255,255,0.5); }

.s-plays, .s-duration { color: #64748b; font-size: 14px; text-align: right; }

.row-action-btn {
  background: transparent;
  border: none;
  color: #64748b;
  cursor: pointer;
  opacity: 0;
  transition: 0.2s;
}

.song-row:hover .row-action-btn { opacity: 1; }
.row-action-btn:hover { color: #fff; }

.loading-overlay {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100px 0;
  color: #94a3b8;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 3px solid rgba(255,255,255,0.1);
  border-top-color: #3b82f6;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 16px;
}

@keyframes spin { to { transform: rotate(360deg); } }

@media (max-width: 900px) {
  .genre-name { font-size: 3rem; }
  .profile-main { flex-direction: column; text-align: center; }
  .header-actions { justify-content: center; }
  .songs-list-header, .song-row {
    grid-template-columns: 40px 1fr 100px 40px;
  }
  .col-plays { display: none; }
}
</style>

<template>
  <div class="popular-music-shell">
    <!-- Background Blur Effect -->
    <div class="bg-blur-container">
      <div 
        v-if="topSongCover" 
        class="banner-blur" 
        :style="{ backgroundImage: `url(${getFullImageUrl(topSongCover)})` }"
      ></div>
      <div v-else class="banner-blur-placeholder"></div>
    </div>

    <div class="content-container">
      <!-- Navigation Header -->
      <div class="header-nav">
        <button class="back-nav-btn" @click="$router.back()">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="18" height="18">
            <path fill-rule="evenodd" d="M17 10a.75.75 0 0 1-.75.75H5.612l4.158 3.96a.75.75 0 1 1-1.04 1.08l-5.5-5.25a.75.75 0 0 1 0-1.08l5.5-5.25a.75.75 0 1 1 1.04 1.08L5.612 9.25H16.25A.75.75 0 0 1 17 10Z" clip-rule="evenodd" />
          </svg>
          Back
        </button>

        <div class="search-wrapper">
          <div class="search-box">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="18" height="18" class="search-icon">
              <path fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11ZM2 9a7 7 0 1 1 12.452 4.391l3.328 3.329a.75.75 0 1 1-1.06 1.06l-3.329-3.328A7 7 0 0 1 2 9Z" clip-rule="evenodd" />
            </svg>
            <input 
              v-model="searchQuery" 
              type="text" 
              placeholder="Search popular tracks..." 
              class="search-input"
            />
          </div>
        </div>
      </div>

      <!-- Main Header -->
      <header class="section-header">
        <div class="header-main">
          <div class="type-pill">Trending Now</div>
          <h1 class="page-title">
            <span class="gradient-text">Popular Music</span>
            <span class="count-badge" v-if="filteredSongs.length">{{ filteredSongs.length }}</span>
          </h1>
          <p class="page-desc">The most played and loved tracks across the MelodyHub community.</p>
        </div>

        <div class="header-actions">
          <button class="play-all-btn" @click="playAll" :disabled="!filteredSongs.length">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
              <path fill-rule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clip-rule="evenodd" />
            </svg>
            Play All
          </button>
        </div>
      </header>

      <!-- Loading State -->
      <div v-if="loading" class="loading-grid">
        <div v-for="i in 12" :key="i" class="skeleton-card"></div>
      </div>

      <!-- Songs List -->
      <template v-else>
        <div v-if="filteredSongs.length" class="songs-list">
          <div class="list-header">
            <span class="col-rank">#</span>
            <span class="col-info">Track</span>
            <span class="col-album hide-mobile">Album</span>
            <span class="col-plays hide-mobile">
               <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                <path d="M10 12.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z" />
                <path fill-rule="evenodd" d="M.664 10.59a1.651 1.651 0 0 1 0-1.186A10.004 10.004 0 0 1 10 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0 1 10 17c-4.257 0-7.893-2.66-9.336-6.41ZM14 10a4 4 0 1 1-8 0 4 4 0 0 1 8 0Z" clip-rule="evenodd" />
              </svg>
            </span>
            <span class="col-duration">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                <path fill-rule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm.75-13a.75.75 0 0 0-1.5 0v5c0 .414.336.75.75.75h4a.75.75 0 0 0 0-1.5h-3.25V5Z" clip-rule="evenodd" />
              </svg>
            </span>
          </div>

          <div 
            v-for="(song, index) in filteredSongs" 
            :key="song.id" 
            class="song-row"
            :class="{ 'is-active': player.currentSong?.id === song.id }"
            @click="playSong(song)"
          >
            <!-- Rank -->
            <div class="s-rank">
              <span class="rank-num" v-if="!(player.currentSong?.id === song.id && player.isPlaying)">{{ index + 1 }}</span>
              <div class="rank-wave" v-else>
                <span></span><span></span><span></span>
              </div>
            </div>

            <!-- Basic Info -->
            <div class="s-info">
              <div class="s-cover">
                <img :src="getFullImageUrl(song.cover_url)" :alt="song.title" />
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
                <div class="s-artist" @click.stop="goToArtist(song.artist?.slug)">{{ song.artist?.name }}</div>
              </div>
            </div>

            <!-- Album -->
            <div class="s-album hide-mobile">{{ song.album?.title || 'Single' }}</div>

            <!-- Plays -->
            <div class="s-plays hide-mobile">{{ formatNumber(player.currentSong?.stats?.total_plays ?? 0) }}</div>

            <!-- Duration -->
            <div class="s-duration">{{ formatDuration(song.duration) }}</div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-else class="empty-state">
          <h3>No matches found</h3>
          <p>We couldn't find any popular songs matching your search.</p>
          <button class="reset-btn" @click="searchQuery = ''">See all popular</button>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import { useSongStore } from '@/modules/client/stores/songs/songsStore';
import { usePlayerStore } from '@/store/playerStore';
import { getFullImageUrl } from '@/modules/client/stores/artists/artistsStore';
import type { Song } from '@/interfaces/songs.interface';

const router = useRouter();
const songStore = useSongStore();
const player = usePlayerStore();

const searchQuery = ref('');
const loading = ref(true);

// Computed: Latest cover for background
const topSongCover = computed(() => {
  if (songStore.popularSongs.length > 0) {
    return songStore.popularSongs[0].cover_url;
  }
  return null;
});

// Computed: Filtered songs
const filteredSongs = computed(() => {
  if (!searchQuery.value.trim()) return songStore.popularSongs;
  const q = searchQuery.value.toLowerCase();
  return songStore.popularSongs.filter(s => 
    s.title.toLowerCase().includes(q) || 
    s.artist?.name.toLowerCase().includes(q)
  );
});

// Helper: Format duration
const formatDuration = (seconds: number) => {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${mins}:${secs.toString().padStart(2, '0')}`;
};

const formatNumber = (n: number) =>
  n >= 1_000_000 ? (n / 1_000_000).toFixed(1) + 'M'
  : n >= 1_000   ? (n / 1_000).toFixed(1) + 'K'
  : String(n)

// Map song to player format - standardized for SongResource
const mapSong = (song: any): Song => {
  return {
    ...song,
    urls: song.urls || {
      standard: song.song_url ?? null,
      hq:       song.song_url_hq ?? null,
      lossless: song.song_url_lossless ?? null,
    },
    artist: song.artist ? {
      id: song.artist.id,
      name: song.artist.name,
      slug: song.artist.slug,
      avatar_url: song.artist.avatar_url ?? null
    } : null
  };
};

// Navigation
const goToArtist = (slug: string | undefined) => {
  if (slug) router.push({ name: 'client.artist.songs', params: { slug } });
};

// Actions
const playSong = (song: any) => {
  const mapped = mapSong(song);
  const queue = filteredSongs.value.map(mapSong);
  player.play(mapped, queue);
};

const playAll = () => {
  if (!filteredSongs.value.length) return;
  const queue = filteredSongs.value.map(mapSong);
  player.play(queue[0], queue);
};

onMounted(async () => {
  loading.value = true;
  try {
    await songStore.fetchPopularSongs(50);
  } finally {
    loading.value = false;
  }
});
</script>

<style scoped>
.popular-music-shell {
  min-height: 100vh;
  color: #fff;
  position: relative;
  overflow-x: hidden;
  padding-bottom: 100px;
}

.bg-blur-container {
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 550px;
  overflow: hidden;
  z-index: 0;
  mask-image: linear-gradient(to bottom, black 50%, transparent 100%);
}

.banner-blur {
  width: 100%; height: 100%;
  background-size: cover;
  background-position: center;
  filter: blur(100px) saturate(1.8) opacity(0.2);
  transform: scale(1.3);
}

.banner-blur-placeholder {
  width: 100%; height: 100%;
  background: radial-gradient(circle at 30% 30%, #2a1a3a 0%, #080e14 100%);
  filter: blur(80px);
}

.content-container {
  position: relative;
  z-index: 1;
  max-width: 1280px;
  margin: 0 auto;
  padding: 40px 40px;
}

.header-nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 48px;
}

.back-nav-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.7);
  padding: 8px 18px;
  border-radius: 99px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
}

.search-box {
  position: relative;
  width: 300px;
}

.search-icon {
  position: absolute;
  left: 14px;
  top: 50%;
  transform: translateY(-50%);
  color: rgba(255,255,255,0.3);
}

.search-input {
  width: 100%;
  background: rgba(255,255,255,0.05);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 12px;
  padding: 10px 14px 10px 42px;
  color: #fff;
  font-size: 13px;
  outline: none;
}

.section-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  margin-bottom: 40px;
}

.type-pill {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  color: #ffaa00;
}

.page-title {
  font-size: 64px;
  font-weight: 900;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 20px;
}

.gradient-text {
  background: linear-gradient(135deg, #fff 0%, rgba(255,255,255,0.6) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.count-badge {
  font-size: 18px;
  background: rgba(255,255,255,0.1);
  padding: 4px 14px;
  border-radius: 99px;
  color: rgba(255,255,255,0.5);
}

.play-all-btn {
  background: #fff;
  color: #000;
  border: none;
  padding: 14px 32px;
  border-radius: 99px;
  font-weight: 800;
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
}

.list-header {
  display: grid;
  grid-template-columns: 48px 1fr 200px 120px 80px;
  padding: 8px 16px;
  border-bottom: 1px solid rgba(255,255,255,0.06);
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  color: rgba(255,255,255,0.3);
  margin-bottom: 10px;
}

.song-row {
  display: grid;
  grid-template-columns: 48px 1fr 200px 120px 80px;
  align-items: center;
  padding: 10px 16px;
  border-radius: 12px;
  cursor: pointer;
  transition: 0.2s;
}

.song-row:hover { background: rgba(255,255,255,0.05); }
.song-row.is-active { background: rgba(255,170,0,0.1); }

.s-rank { display: flex; justify-content: center; color: rgba(255,255,255,0.3); font-family: monospace; }

.s-info { display: flex; align-items: center; gap: 16px; }
.s-cover { width: 44px; height: 44px; border-radius: 6px; overflow: hidden; position: relative; }
.s-cover img { width: 100%; height: 100%; object-fit: cover; }
.s-cover-overlay { position: absolute; inset: 0; background: rgba(0,0,0,0.4); display: flex; align-items: center; justify-content: center; opacity: 0; }
.song-row:hover .s-cover-overlay { opacity: 1; }

.s-title { font-weight: 600; font-size: 15px; }
.s-artist { font-size: 13px; color: rgba(255,255,255,0.5); }
.s-artist:hover { text-decoration: underline; color: #fff; }

.s-album, .s-plays, .s-duration { font-size: 13px; color: rgba(255,255,255,0.4); }
.s-duration { text-align: right; font-family: monospace; }

/* Wave animation */
.rank-wave { display: flex; align-items: flex-end; gap: 2px; height: 14px; }
.rank-wave span { display: block; width: 2px; background: #ffaa00; border-radius: 1px; animation: wave 1s ease-in-out infinite; }
.rank-wave span:nth-child(2) { animation-delay: 0.2s; }
.rank-wave span:nth-child(3) { animation-delay: 0.4s; }
@keyframes wave { 0%, 100% { height: 4px; } 50% { height: 14px; } }

.loading-grid { display: flex; flex-direction: column; gap: 12px; }
.skeleton-card { height: 60px; background: rgba(255,255,255,0.03); border-radius: 12px; animation: pulse 1.5s infinite; }
@keyframes pulse { 0%, 100% { opacity: 0.5; } 50% { opacity: 1; } }

@media (max-width: 1024px) {
  .list-header, .song-row { grid-template-columns: 48px 1fr 150px 80px; }
  .s-plays { display: none; }
}
</style>

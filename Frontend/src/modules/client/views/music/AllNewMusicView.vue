<template>
  <div class="new-releases-shell">
    <!-- Background Blur Effect -->
    <div class="bg-blur-container">
      <div 
        v-if="latestSongCover" 
        class="banner-blur" 
        :style="{ backgroundImage: `url(${getFullImageUrl(latestSongCover)})` }"
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
              placeholder="Search in new releases..." 
              class="search-input"
            />
          </div>
        </div>
      </div>

      <!-- Main Header -->
      <header class="section-header">
        <div class="header-main">
          <div class="type-pill">Discovery</div>
          <h1 class="page-title">
            <span class="gradient-text">New Releases</span>
            <span class="count-badge" v-if="filteredSongs.length">{{ filteredSongs.length }}</span>
          </h1>
          <p class="page-desc">Stay ahead of the curve with the latest tracks on MelodyHub.</p>
        </div>

        <!-- ← gom lại -->
        <div class="header-actions">
          <button class="play-all-btn" @click="playAll" :disabled="!filteredSongs.length">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
              <path fill-rule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clip-rule="evenodd" />
            </svg>
            Play All
          </button>

          <div class="view-toggle">
            <button :class="{ active: viewMode === 'grid' }" @click="viewMode = 'grid'" title="Grid view">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
                <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
              </svg>
            </button>
            <button
              :class="{ active: showLikedSongs }"
              @click="toggleLikedFilter"
              title="Liked songs"
              :style="showLikedSongs ? 'color: #ef4444;' : ''"
            >
              <svg width="15" height="15" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
              </svg>
            </button>
          </div>
        </div>
      </header>

      <!-- Loading State -->
      <div v-if="loading" class="loading-grid">
        <div v-for="i in 12" :key="i" class="skeleton-card"></div>
      </div>

      <!-- Songs List/Grid -->
      <template v-else>
        <div v-if="filteredSongs.length" class="songs-list">
          <!-- List Headers -->
          <div class="list-header">
            <span class="col-rank">#</span>
            <span class="col-info">Title / Artist</span>
            <span class="col-album hide-mobile">Album</span>
            <span class="col-date hide-mobile">Release Date</span>
            <span class="col-duration">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                <path fill-rule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm.75-13a.75.75 0 0 0-1.5 0v5c0 .414.336.75.75.75h4a.75.75 0 0 0 0-1.5h-3.25V5Z" clip-rule="evenodd" />
              </svg>
            </span>
            <span class="col-actions"></span>
          </div>

          <div 
            v-for="(song, index) in filteredSongs" 
            :key="song.id" 
            class="song-row"
            :class="{ 'is-active': player.currentSong?.id === song.id }"
            @click="playSong(song)"
          >
            <!-- Rank / Playing Indicator -->
            <div class="s-rank">
              <span class="rank-num" v-if="!(player.currentSong?.id === song.id && player.isPlaying)">{{ index + 1 }}</span>
              <div class="rank-wave" v-else>
                <span></span><span></span><span></span>
              </div>
            </div>

            <!-- Title & Artist -->
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

            <!-- Date -->
            <div class="s-date hide-mobile">{{ formatDate(song.created_at) }}</div>

            <!-- Duration -->
            <div class="s-duration">{{ formatDuration(song.duration) }}</div>

          </div>
        </div>

        <!-- Empty State -->
        <div v-else class="empty-state">
          <div class="empty-icon">...</div>
          <h3>No new releases found</h3>
          <p v-if="showLikedSongs && !searchQuery">You haven't liked any songs yet.</p>
          <p v-else-if="searchQuery">No results for <em>"{{ searchQuery }}"</em></p>
          <p v-else>We couldn't find any songs matching your search.</p>
          <div style="display:flex; gap:8px; justify-content:center;">
            <button v-if="showLikedSongs" class="reset-btn" @click="toggleLikedFilter">Show All</button>
            <button v-if="searchQuery" class="reset-btn" @click="searchQuery = ''">Clear Search</button>
          </div>
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
const viewMode = ref<'grid' | 'list'>('grid')
const showLikedSongs = ref(false)

// Toggle liked filter và refetch để đảm bảo is_liked đúng với token hiện tại
const toggleLikedFilter = async () => {
  showLikedSongs.value = !showLikedSongs.value
  loading.value = true
  try {
    await songStore.fetchNewSongs(50)
  } finally {
    loading.value = false
  }
}

// Computed: Latest cover for background
const latestSongCover = computed(() => {
  if (songStore.newSongs.length > 0) {
    return songStore.newSongs[0].cover_url;
  }
  return null;
});

// Computed: Filtered songs
const filteredSongs = computed(() => {
  let list = [...songStore.newSongs]

  if (showLikedSongs.value) {
    list = list.filter(s => s.is_liked === true)
  }

  if (searchQuery.value.trim()) {
    const q = searchQuery.value.toLowerCase()
    list = list.filter(s =>
      s.title.toLowerCase().includes(q) ||
      s.artist?.name.toLowerCase().includes(q)
    )
  }

  return list
})

// Format: MM:SS
const formatDuration = (seconds: number) => {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${mins}:${secs.toString().padStart(2, '0')}`;
};

// Format: Date
const formatDate = (iso: string | null) => {
  if (!iso) return '—';
  return new Date(iso).toLocaleDateString('en-US', { 
    month: 'short', 
    day: 'numeric', 
    year: 'numeric' 
  });
};

// Map song to player format - standardized for SongResource
const mapSong = (song: any): Song => {
  return {
    ...song,
    // Fallback if urls nested incorrectly (already standardized in Resource though)
    urls: song.urls || {
      standard: song.song_url ?? null,
      hq:       song.song_url_hq ?? null,
      lossless: song.song_url_lossless ?? null,
    },
    // Ensure artist is in expected format for player display
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

const toggleLike = (song: Song) => {
  // Logic to toggle like will be implemented with interaction controller
  console.log('Toggle like:', song.title);
};

onMounted(async () => {
  loading.value = true;
  try {
    // Fetch 50 new releases
    await songStore.fetchNewSongs(50);
  } finally {
    loading.value = false;
  }
});
</script>

<style scoped>
/* ─── Layout Shell ───────────────────────────────────────── */
.new-releases-shell {
  min-height: 100vh;
  color: #fff;
  position: relative;
  overflow-x: hidden;
  padding-bottom: 100px;
}

/* ─── Background blur ─────────────────────────────────────── */
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
  filter: blur(100px) saturate(1.5) opacity(0.25);
  transform: scale(1.3);
}

.banner-blur-placeholder {
  width: 100%; height: 100%;
  background: radial-gradient(circle at 30% 30%, #1a2a4a 0%, #080e14 100%);
  filter: blur(80px);
}

/* ─── Content ─────────────────────────────────────────────── */
.content-container {
  position: relative;
  z-index: 1;
  max-width: 1280px;
  margin: 0 auto;
  padding: 40px 40px;
}

/* ─── Navigation Header ───────────────────────────────────── */
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
  transition: all 0.2s;
}

.back-nav-btn:hover {
  background: rgba(255,255,255,0.1);
  color: #fff;
  transform: translateX(-3px);
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
  transition: all 0.2s;
}

.search-input:focus {
  background: rgba(255,255,255,0.08);
  border-color: rgba(255,255,255,0.2);
  width: 360px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.2);
}

/* ─── Section Header ───────────────────────────────────────── */
.section-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  margin-bottom: 40px;
}

.header-main {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.type-pill {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  color: #00aaff;
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
  background: linear-gradient(135deg, #fff 0%, rgba(255,255,255,0.5) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.count-badge {
  font-size: 18px;
  background: rgba(255,255,255,0.1);
  padding: 4px 14px;
  border-radius: 99px;
  color: rgba(255,255,255,0.5);
  font-weight: 700;
  vertical-align: middle;
}

.page-desc {
  font-size: 16px;
  color: rgba(255,255,255,0.5);
  max-width: 600px;
  line-height: 1.6;
}

.play-all-btn {
  background: #fff;
  color: #000;
  border: none;
  padding: 14px 32px;
  border-radius: 99px;
  font-weight: 800;
  font-size: 15px;
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  transition: all 0.2s;
}

.play-all-btn:hover:not(:disabled) {
  transform: scale(1.05);
  box-shadow: 0 10px 30px rgba(255,255,255,0.2);
}

.play-all-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* ─── List Layout ─────────────────────────────────────────── */
.list-header {
  display: grid;
  grid-template-columns: 48px 1fr 200px 180px 80px 100px;
  padding: 8px 16px;
  border-bottom: 1px solid rgba(255,255,255,0.06);
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  color: rgba(255,255,255,0.3);
  letter-spacing: 0.1em;
  margin-bottom: 10px;
}

.col-duration { text-align: right; }

.song-row {
  display: grid;
  grid-template-columns: 48px 1fr 200px 180px 80px 100px;
  align-items: center;
  padding: 8px 16px;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.2s;
  position: relative;
}

.song-row:hover {
  background: rgba(255,255,255,0.05);
}

.song-row.is-active {
  background: rgba(0,170,255,0.08);
}

.s-rank {
  display: flex;
  justify-content: center;
  color: rgba(255,255,255,0.3);
  font-size: 14px;
  font-family: monospace;
}

.s-info {
  display: flex;
  align-items: center;
  gap: 16px;
}

.s-cover {
  width: 48px; height: 48px;
  border-radius: 8px;
  overflow: hidden;
  position: relative;
  flex-shrink: 0;
  background: rgba(255,255,255,0.05);
}

.s-cover img { width: 100%; height: 100%; object-fit: cover; }

.s-cover-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  opacity: 0;
  transition: 0.2s;
}

.song-row:hover .s-cover-overlay,
.song-row.is-active .s-cover-overlay { opacity: 1; }

.s-details { display: flex; flex-direction: column; gap: 4px; overflow: hidden; }
.s-title { font-weight: 600; font-size: 15px; color: #fff; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.s-artist { font-size: 13px; color: rgba(255,255,255,0.5); width: fit-content; }
.s-artist:hover { text-decoration: underline; color: #fff; }

.song-row.is-active .s-title { color: #00aaff; }

.s-album, .s-date { font-size: 13px; color: rgba(255,255,255,0.4); }

.s-duration { font-size: 13px; color: rgba(255,255,255,0.4); text-align: right; font-family: monospace; }

.s-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 12px;
  opacity: 0;
  transition: 0.2s;
}

.song-row:hover .s-actions { opacity: 1; }

.action-item-btn {
  background: none;
  border: none;
  color: rgba(255,255,255,0.4);
  cursor: pointer;
  padding: 4px;
  border-radius: 50%;
  transition: all 0.2s;
}

.action-item-btn:hover { color: #fff; background: rgba(255,255,255,0.1); }
.action-item-btn.liked { color: #ff3366; }

/* ─── Wave animation ─── */
.rank-wave { display: flex; align-items: flex-end; gap: 2px; height: 14px; }
.rank-wave span { display: block; width: 2px; background: #00aaff; border-radius: 1px; animation: wave 1s ease-in-out infinite; }
.rank-wave span:nth-child(2) { animation-delay: 0.2s; }
.rank-wave span:nth-child(3) { animation-delay: 0.4s; }
@keyframes wave { 0%, 100% { height: 4px; } 50% { height: 14px; } }

/* ─── Loading State ─── */
.loading-grid { display: flex; flex-direction: column; gap: 12px; }
.skeleton-card { height: 64px; background: rgba(255,255,255,0.03); border-radius: 12px; animation: pulse 1.5s infinite ease-in-out; }
@keyframes pulse { 0% { opacity: 0.5; } 50% { opacity: 1; } 100% { opacity: 0.5; } }

/* ─── Empty State ─── */
.empty-state { text-align: center; padding: 100px 0; color: rgba(255,255,255,0.4); }
.empty-icon { margin-bottom: 24px; opacity: 0.2; }
.empty-state h3 { font-size: 24px; color: #fff; margin-bottom: 8px; }
.empty-state p { font-size: 16px; margin-bottom: 32px; }
.reset-btn { background: rgba(255,255,255,0.1); color: #fff; border: none; padding: 10px 24px; border-radius: 9px; cursor: pointer; transition: 0.2s; }
.reset-btn:hover { background: rgba(255,255,255,0.15); }

/* ─── Responsive ─── */
@media (max-width: 1024px) {
  .list-header, .song-row { grid-template-columns: 48px 1fr 180px 80px 60px; }
  .s-date { display: none; }
  .hide-mobile { display: none; }
  .search-box { width: 200px; }
  .search-input:focus { width: 240px; }
  .page-title { font-size: 48px; }
}

@media (max-width: 768px) {
  .list-header, .song-row { grid-template-columns: 40px 1fr 60px 40px; }
  .s-album, .s-actions { display: none; }
  .header-actions { display: none; }
  .section-header { flex-direction: column; align-items: flex-start; gap: 20px; }
  .content-container { padding: 20px; }
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.view-toggle {
  display: flex;
  align-items: center;
  background: rgba(255, 255, 255, 0.04);
  border: 1px solid rgba(255, 255, 255, 0.07);
  border-radius: 10px;
  padding: 4px;
  gap: 2px;
}

.view-toggle button {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  background: transparent;
  border: none;
  color: #6b7280;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.15s;
}

.view-toggle button.active {
  background: rgba(0, 170, 255, 0.2);
  color: #00aaff;
}
</style>

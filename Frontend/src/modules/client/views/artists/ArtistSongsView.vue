<template>
  <div class="artist-songs-shell">
    <div class="bg-blur-container">
      <div v-if="artist?.banner_url" class="banner-blur" :style="{ backgroundImage: `url(${getFullImageUrl(artist.banner_url)})` }"></div>
      <div v-else class="banner-blur-placeholder"></div>
    </div>

    <div class="content-container">
      <!-- Back Button -->
      <button class="back-nav-btn" @click="$router.back()">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M17 10a.75.75 0 0 1-.75.75H5.612l4.158 3.96a.75.75 0 1 1-1.04 1.08l-5.5-5.25a.75.75 0 0 1 0-1.08l5.5-5.25a.75.75 0 1 1 1.04 1.08L5.612 9.25H16.25A.75.75 0 0 1 17 10Z" clip-rule="evenodd" />
        </svg>
        Back
      </button>

      <!-- Loading State -->
      <div v-if="loading" class="loading-overlay">
        <div class="spinner"></div>
        <p>Loading artist...</p>
      </div>

      <template v-else-if="artist">
        <!-- Artist Header -->
        <header class="artist-header">
          <div class="profile-main">
            <div class="avatar-wrap">
              <img :src="getFullImageUrl(artist.avatar_url)" :alt="artist.name" class="profile-avatar" />
              <div v-if="artist.verified" class="verified-badge" title="Verified Artist">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="18" height="18">
                  <path fill-rule="evenodd" d="M10 18a8 8 0 1 0 0-16 8 8 0 0 0 0 16Zm3.857-9.809a.75.75 0 0 0-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 1 0-1.06 1.061l2.5 2.5a.75.75 0 0 0 1.137-.089l4-5.5Z" clip-rule="evenodd" />
                </svg>
              </div>
            </div>
            <div class="profile-info">
              <div class="type-pill">Artist</div>
              <h1 class="artist-name">{{ artist.name }}</h1>
              <div class="stats-row">
                <span class="stat-item">
                  <b>{{ formatNumbers(artist.monthly_listeners || 0) }}</b>
                  <span>Monthly listeners</span>
                </span>
                <span class="dot">·</span>
                <span class="stat-item">
                  <b>{{ formatNumbers(artist.total_followers || 0) }}</b>
                  <span>Followers</span>
                </span>
              </div>
            </div>
          </div>

          <div class="header-actions">
            <button class="play-all-btn" @click="playAll">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="20" height="20">
                <path fill-rule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clip-rule="evenodd" />
              </svg>
              Play all
            </button>
            <button class="follow-btn" :class="{ 'is-following': isFollowing }" @click="isFollowing = !isFollowing">
              <svg v-if="isFollowing" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
                <path d="M10 2a6 6 0 0 0-6 6v3.586l-.707.707A1 1 0 0 0 4 14h12a1 1 0 0 0 .707-1.707L16 11.586V8a6 6 0 0 0-6-6ZM10 18a3 3 0 0 1-3-3h6a3 3 0 0 1-3 3Z" />
              </svg>
              {{ isFollowing ? 'Following' : 'Follow' }}
            </button>
          </div>
        </header>

        <!-- Song List Section -->
        <section class="songs-section">
          <div class="section-head">
            <h2 class="section-title">Popular</h2>
            <span class="song-count" v-if="artist.songs?.length">{{ artist.songs.length }} songs</span>
          </div>

          <div v-if="artist.songs && artist.songs.length" class="songs-list">
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
              v-for="(song, index) in (artist.songs ?? [])"
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
                  <span></span><span></span><span></span>
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
                  <div class="s-tags">
                    <span v-if="song.is_premium" class="tag tag-premium">Premium</span>
                    <span v-if="song.is_explicit" class="tag tag-explicit">E</span>
                  </div>
                </div>
              </div>

              <!-- Plays -->
              <div class="s-plays col-plays">
                {{ formatNumbers(song.total_plays || 0) }}
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
            <p>No songs released yet.</p>
          </div>
        </section>
      </template>

      <!-- Error State -->
      <div v-else class="error-state">
        <h2>Artist not found.</h2>
        <p>This link may no longer exist or has been changed.</p>
        <button @click="$router.push({ name: 'client.artists' })" class="back-btn">Go back</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import { getFullImageUrl } from '@/modules/client/stores/artists/artistsStore';
import ArtistService from '@/modules/client/services/artists/artists.service';
import { ArtistInterface } from '@/interfaces/artists.interface';
import { usePlayerStore } from '@/store/playerStore';
import type { Song } from '@/interfaces/songs.interface';

const route      = useRoute();
const artist     = ref<ArtistInterface | null>(null);
const loading    = ref(true);
const isFollowing = ref(false);
const player     = usePlayerStore();

// Map song to player format - now simpler thanks toized backend Resource
const mapSong = (song: any): Song => {
  return {
    ...song,
    // Use resource urls or fallback to raw properties
    urls: song.urls || {
      standard: song.song_url ?? null,
      hq:       song.song_url_hq ?? null,
      lossless: song.song_url_lossless ?? null,
    },
    // Artist is now correctly loaded via backend relationship
    artist: song.artist ? {
      id: song.artist.id,
      name: song.artist.name,
      slug: song.artist.slug,
      avatar_url: song.artist.avatar_url ?? null
    } : {
      id:         artist.value?.id ?? 0,
      name:       artist.value?.name ?? 'Unknown Artist',
      slug:       artist.value?.slug ?? '',
      avatar_url: artist.value?.avatar_url ?? null,
    }
  };
};

const playSong = (song: any): void => {
  const mapped = mapSong(song);
  const queue  = (artist.value?.songs ?? []).map(mapSong);
  player.play(mapped, queue);
};

const playAll = (): void => {
  const songs = artist.value?.songs;
  if (!songs?.length) return;
  const queue = songs.map(mapSong);
  player.play(queue[0], queue);
};

const formatDuration = (seconds: number): string => {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${mins}:${secs.toString().padStart(2, '0')}`;
};

const formatNumbers = (n: number): string =>
  n >= 1_000_000 ? (n / 1_000_000).toFixed(1) + 'M'
  : n >= 1_000   ? (n / 1_000).toFixed(1) + 'K'
  : String(n);

onMounted(async () => {
  try {
    loading.value = true;
    const slug = route.params.slug as string;
    const res  = await ArtistService.detailArtist(slug);
    artist.value = res.data.data || res.data;
  } catch (error) {
    console.error('Failed to fetch artist details:', error);
  } finally {
    loading.value = false;
  }
});
</script>

<style scoped>
/* ─── Shell ──────────────────────────────────────────────── */
.artist-songs-shell {
  min-height: 100vh;
  color: #fff;
  position: relative;
  overflow-x: hidden;
}

/* ─── Background blur ─────────────────────────────────────── */
.bg-blur-container {
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 520px;
  overflow: hidden;
  z-index: 0;
  mask-image: linear-gradient(to bottom, black 40%, transparent 100%);
}

.banner-blur {
  width: 100%; height: 100%;
  background-size: cover;
  background-position: center;
  filter: blur(90px) saturate(1.4) opacity(0.28);
  transform: scale(1.25);
}

.banner-blur-placeholder {
  width: 100%; height: 100%;
  background: radial-gradient(circle at 30% 50%, #1a2a3a 0%, #080e14 100%);
  filter: blur(60px);
}

/* ─── Content ─────────────────────────────────────────────── */
.content-container {
  position: relative;
  z-index: 1;
  max-width: 1280px;
  margin: 0 auto;
  padding: 56px 40px 100px;
}

/* ─── Back button ─────────────────────────────────────────── */
.back-nav-btn {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.7);
  padding: 8px 16px;
  border-radius: 99px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  margin-bottom: 36px;
  transition: background 0.2s, color 0.2s, transform 0.2s;
}

.back-nav-btn:hover {
  background: rgba(255,255,255,0.1);
  color: #fff;
  transform: translateX(-3px);
}

/* ─── Header ──────────────────────────────────────────────── */
.artist-header {
  display: flex;
  flex-direction: column;
  gap: 36px;
  margin-bottom: 56px;
}

.profile-main {
  display: flex;
  align-items: flex-end;
  gap: 28px;
}

.avatar-wrap {
  position: relative;
  width: 220px; height: 220px;
  flex-shrink: 0;
  border-radius: 50%;
  box-shadow: 0 24px 60px rgba(0,0,0,0.6);
}

.profile-avatar {
  width: 100%; height: 100%;
  object-fit: cover;
  border-radius: 50%;
  border: 3px solid rgba(255,255,255,0.08);
}

.verified-badge {
  position: absolute;
  bottom: 14px; right: 14px;
  background: #fff;
  color: #00aaff;
  width: 32px; height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(0,0,0,0.3);
}

.profile-info {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding-bottom: 12px;
}

.type-pill {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.12em;
  color: rgba(255,255,255,0.5);
}

.artist-name {
  font-size: clamp(42px, 7vw, 80px);
  font-weight: 900;
  margin: 0;
  letter-spacing: -0.03em;
  line-height: 1;
}

.stats-row {
  display: flex;
  align-items: center;
  gap: 14px;
  font-size: 14px;
  color: rgba(255,255,255,0.55);
}

.stat-item { display: flex; align-items: center; gap: 5px; }
.stat-item b { color: #fff; font-weight: 700; }
.dot { color: rgba(255,255,255,0.2); }

/* ─── Actions ─────────────────────────────────────────────── */
.header-actions {
  display: flex;
  align-items: center;
  gap: 14px;
}

.play-all-btn {
  background: #00aaff;
  color: #000;
  border: none;
  padding: 13px 28px;
  border-radius: 99px;
  font-weight: 800;
  font-size: 14px;
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  transition: transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1), background 0.2s, box-shadow 0.2s;
}

.play-all-btn:hover {
  transform: scale(1.04);
  background: #29bbff;
  box-shadow: 0 0 28px rgba(0, 170, 255, 0.35);
}

.play-all-btn:active { transform: scale(0.98); }

.follow-btn {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  background: transparent;
  color: #fff;
  border: 1px solid rgba(255,255,255,0.25);
  padding: 12px 24px;
  border-radius: 99px;
  font-weight: 700;
  font-size: 14px;
  cursor: pointer;
  transition: all 0.2s;
}

.follow-btn:hover {
  background: rgba(255,255,255,0.06);
  border-color: rgba(255,255,255,0.5);
}

.follow-btn.is-following {
  background: rgba(0,170,255,0.1);
  border-color: rgba(0,170,255,0.4);
  color: #00aaff;
}

/* ─── Songs section ───────────────────────────────────────── */
.songs-section { margin-top: 36px; }

.section-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid rgba(255,255,255,0.06);
  padding-bottom: 14px;
  margin-bottom: 4px;
}

.section-title {
  font-size: 20px;
  font-weight: 800;
  margin: 0;
}

.song-count {
  font-size: 12px;
  color: rgba(255,255,255,0.3);
}

/* ─── List header ─────────────────────────────────────────── */
.songs-list-header {
  display: grid;
  grid-template-columns: 44px 1fr 120px 72px 40px;
  align-items: center;
  padding: 6px 12px;
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: rgba(255,255,255,0.25);
  margin-bottom: 2px;
}

/* ─── Song row ────────────────────────────────────────────── */
.song-row {
  display: grid;
  grid-template-columns: 44px 1fr 120px 72px 40px;
  align-items: center;
  padding: 6px 12px;
  border-radius: 10px;
  cursor: pointer;
  transition: background 0.15s;
  position: relative;
}

.song-row:hover { background: rgba(255,255,255,0.05); }

.song-row.is-active { background: rgba(0,170,255,0.07); }

/* ─── Rank ────────────────────────────────────────────────── */
.s-rank {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
}

.rank-num {
  font-size: 13px;
  color: rgba(255,255,255,0.3);
  font-variant-numeric: tabular-nums;
}

/* Wave bars for currently playing */
.rank-wave {
  display: flex;
  align-items: flex-end;
  gap: 2px;
  height: 16px;
}

.rank-wave span {
  display: block;
  width: 3px;
  background: #00aaff;
  border-radius: 2px;
  animation: wave 0.85s ease-in-out infinite;
}

.rank-wave span:nth-child(1) { animation-delay: 0s;    animation-duration: 0.9s; }
.rank-wave span:nth-child(2) { animation-delay: 0.18s; animation-duration: 0.72s; }
.rank-wave span:nth-child(3) { animation-delay: 0.34s; animation-duration: 1.0s; }

@keyframes wave {
  0%, 100% { height: 3px; }
  50%       { height: 16px; }
}

/* ─── Cover ───────────────────────────────────────────────── */
.s-info {
  display: flex;
  align-items: center;
  gap: 14px;
  min-width: 0;
}

.s-cover {
  position: relative;
  width: 42px; height: 42px;
  border-radius: 7px;
  overflow: hidden;
  flex-shrink: 0;
  background: rgba(255,255,255,0.05);
}

.s-cover img {
  width: 100%; height: 100%;
  object-fit: cover;
  display: block;
}

.s-cover-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.58);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  opacity: 0;
  transition: opacity 0.15s;
}

.song-row:hover .s-cover-overlay,
.song-row.is-active .s-cover-overlay { opacity: 1; }

/* ─── Details ─────────────────────────────────────────────── */
.s-details {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}

.s-title {
  font-size: 14px;
  font-weight: 600;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  transition: color 0.15s;
}

.song-row.is-active .s-title { color: #00aaff; }

.s-tags {
  display: flex;
  gap: 5px;
  align-items: center;
}

.tag {
  font-size: 10px;
  font-weight: 700;
  padding: 1px 5px;
  border-radius: 4px;
  text-transform: uppercase;
  letter-spacing: 0.03em;
}

.tag-premium {
  background: rgba(251,192,45,0.12);
  color: #fbc02d;
  border: 1px solid rgba(251,192,45,0.2);
}

.tag-explicit {
  background: rgba(255,255,255,0.07);
  color: rgba(255,255,255,0.45);
  border: 1px solid rgba(255,255,255,0.1);
}

/* ─── Plays / Duration ────────────────────────────────────── */
.s-plays, .s-duration {
  font-size: 13px;
  color: rgba(255,255,255,0.38);
  font-variant-numeric: tabular-nums;
  text-align: right;
}

.col-plays, .col-duration { text-align: right; }

/* ─── Actions ─────────────────────────────────────────────── */
.row-action-btn {
  background: transparent;
  border: none;
  color: rgba(255,255,255,0.2);
  cursor: pointer;
  padding: 5px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.15s, color 0.15s, background 0.15s;
}

.song-row:hover .row-action-btn { opacity: 1; }
.row-action-btn:hover { color: #fff; background: rgba(255,255,255,0.08); }

/* ─── Empty ───────────────────────────────────────────────── */
.empty-songs {
  text-align: center;
  padding: 80px 0;
  color: rgba(255,255,255,0.28);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 14px;
  font-size: 14px;
}

/* ─── Loading ─────────────────────────────────────────────── */
.loading-overlay {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 120px 0;
  gap: 18px;
  color: rgba(255,255,255,0.35);
  font-size: 14px;
}

.spinner {
  width: 44px; height: 44px;
  border: 3px solid rgba(0,170,255,0.12);
  border-left-color: #00aaff;
  border-radius: 50%;
  animation: spin 0.9s linear infinite;
}

@keyframes spin { to { transform: rotate(360deg); } }

/* ─── Error ───────────────────────────────────────────────── */
.error-state {
  text-align: center;
  padding: 80px 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  color: rgba(255,255,255,0.4);
}

.error-state h2 { color: #fff; margin: 0; font-size: 22px; }

.back-btn {
  margin-top: 8px;
  background: rgba(255,255,255,0.08);
  color: #fff;
  border: 1px solid rgba(255,255,255,0.15);
  padding: 10px 22px;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  transition: background 0.2s;
}

.back-btn:hover { background: rgba(255,255,255,0.13); }

/* ─── Responsive ──────────────────────────────────────────── */
@media (max-width: 900px) {
  .content-container { padding: 36px 20px 80px; }
  .profile-main { flex-direction: column; align-items: center; text-align: center; }
  .artist-name { font-size: 42px; }
  .avatar-wrap { width: 160px; height: 160px; }
  .stats-row { justify-content: center; }
  .header-actions { justify-content: center; }
  .song-row,
  .songs-list-header { grid-template-columns: 36px 1fr 68px 36px; }
  .col-plays { display: none; }
}

@media (max-width: 480px) {
  .song-row,
  .songs-list-header { grid-template-columns: 32px 1fr 56px; }
  .s-actions { display: none; }
}
</style>
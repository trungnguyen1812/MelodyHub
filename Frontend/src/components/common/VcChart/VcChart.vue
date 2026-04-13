<template>
  <section class="vc-chart">
    <!-- Header -->
    <div class="chart-header">
      <div>
        <h2 class="chart-title">Top Charts</h2>
        <p class="chart-subtitle">Most played this week</p>
      </div>
      <button class="see-all-btn" @click="$router.push({ name: 'client.charts' })">SEE ALL</button>
    </div>

    <!-- Two column layout -->
    <div class="chart-body">
      <!-- Left: Bar chart -->
      <div class="bars-panel">
        <div
          v-for="(song, index) in topSongs"
          :key="song.id || index"
          class="bar-row"
          :class="{ 'is-active': player.currentSong?.id === song.id }"
          @click="handlePlay(song)"
        >
          <!-- Rank -->
          <div class="bar-rank">
            <span class="rank-wave" v-if="player.currentSong?.id === song.id && player.isPlaying">
              <span></span><span></span><span></span>
            </span>
            <span class="rank-num" v-else>{{ index + 1 }}</span>
          </div>

          <!-- Cover -->
          <div class="bar-cover">
            <img :src="song.cover || song.image" :alt="song.title" @error="handleImageError" />
            <div class="bar-cover-overlay">
              <svg v-if="!(player.currentSong?.id === song.id && player.isPlaying)" fill="currentColor" viewBox="0 0 24 24" width="14" height="14">
                <path d="M8 5v14l11-7z"/>
              </svg>
              <svg v-else fill="currentColor" viewBox="0 0 24 24" width="14" height="14">
                <path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/>
              </svg>
            </div>
          </div>

          <!-- Info + Bar -->
          <div class="bar-info">
            <div class="bar-meta">
              <span class="bar-title">{{ song.title || 'Unknown' }}</span>
              <span class="bar-plays">{{ song.totalPlaysStr || '0' }}</span>
            </div>
            <div class="bar-track">
              <div
                class="bar-fill"
                :style="{
                  width: getBarWidth(song) + '%',
                  background: barColors[index % barColors.length]
                }"
              ></div>
            </div>
            <span class="bar-artist">{{ song.artistName || 'Unknown Artist' }}</span>
          </div>
        </div>
      </div>

      <!-- Right: Podium top 3 -->
      <div class="podium-panel">
        <div class="podium-label">Top 3</div>

        <div class="podium-cards">
          <div
            v-for="(song, i) in topSongs.slice(0, 3)"
            :key="'pod-' + song.id"
            class="podium-card"
            :class="['rank-' + (i + 1)]"
            @click="handlePlay(song)"
          >
            <div class="podium-crown" v-if="i === 0">
              <svg viewBox="0 0 24 24" fill="currentColor" width="18" height="18">
                <path d="M2 19h20v2H2v-2zm2-4l4-8 4 4 4-8 4 8H4zm4.5-2.5l-2 4h11l-2-4-3 6-3-6-1 0z"/>
              </svg>
            </div>
            <div class="podium-avatar">
              <img :src="song.cover || song.image" :alt="song.title" @error="handleImageError" />
              <div class="podium-play-overlay">
                <svg fill="currentColor" viewBox="0 0 24 24" width="20" height="20">
                  <path d="M8 5v14l11-7z"/>
                </svg>
              </div>
            </div>
            <div class="podium-badge">{{ i + 1 }}</div>
            <div class="podium-info">
              <div class="podium-title">{{ song.title }}</div>
              <div class="podium-artist">{{ song.artistName }}</div>
              <div class="podium-plays">{{ song.totalPlaysStr }}</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, computed, watch, toRefs } from 'vue'
import { usePlayerStore } from '@/store/playerStore'


interface Song {
  id: number
  title: string
  artistName?: string
  popularity?: number
  cover?: string
  image?: string
  duration?: number
  displayDuration?: string
  totalPlaysStr?: string
  stats?: any
  artist?: any
  urls?: any
  song_url?: string
  [key: string]: any
}

const props = defineProps<{ songs: Song[] }>()
const { songs } = toRefs(props)
const player = usePlayerStore()

const barColors = [
  'linear-gradient(90deg, #00aaff, #0077cc)',
  'linear-gradient(90deg, #22d3ee, #0891b2)',
  'linear-gradient(90deg, #a78bfa, #7c3aed)',
  'linear-gradient(90deg, #34d399, #059669)',
  'linear-gradient(90deg, #f472b6, #db2777)',
  'linear-gradient(90deg, #fb923c, #ea580c)',
  'linear-gradient(90deg, #facc15, #ca8a04)',
  'linear-gradient(90deg, #00aaff, #a78bfa)',
  'linear-gradient(90deg, #22d3ee, #34d399)',
  'linear-gradient(90deg, #f472b6, #fb923c)',
]

// Parse plays string → number for sorting
const parsePlays = (str?: string): number => {
  if (!str) return 0
  const n = parseFloat(str)
  if (str.includes('M')) return n * 1_000_000
  if (str.includes('K')) return n * 1_000
  return n
}

const topSongs = computed(() => {
  return [...(songs.value || [])]
    .sort((a, b) => parsePlays(b.totalPlaysStr) - parsePlays(a.totalPlaysStr))
    .slice(0, 10)
})

const maxPlays = computed(() =>
  Math.max(...topSongs.value.map(s => parsePlays(s.totalPlaysStr)), 1)
)

const getBarWidth = (song: Song) => {
  const val = parsePlays(song.totalPlaysStr)
  return Math.max(4, Math.round((val / maxPlays.value) * 100))
}

const mapToPlayer = (s: Song) => ({
  ...s,
  urls: s.urls || { standard: s.song_url ?? null },
})

const handlePlay = (song: Song) => {
  const mapped = mapToPlayer(song)
  const queue  = topSongs.value.map(mapToPlayer)
  if (player.currentSong?.id === song.id) {
    player.isPlaying 
  } else {
    player.play(mapped, queue)
  }
}

const handleImageError = (e: Event) => {
  (e.target as HTMLImageElement).src = 'https://via.placeholder.com/50/111/fff?text=♪'
}
</script>

<style scoped>
/* ─── Shell ───────────────────────────────────────────── */
.vc-chart {
  padding: 32px 24px 40px;
  color: #fff;
  background-color: black;
  border-radius:10px ;
}

/* ─── Header ──────────────────────────────────────────── */
.chart-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  margin-bottom: 32px;
}

.chart-title {
  font-size: 26px;
  font-weight: 900;
  margin: 0 0 4px;
  letter-spacing: -0.02em;
}

.chart-subtitle {
  font-size: 13px;
  color: rgba(255,255,255,0.38);
  margin: 0;
}

.see-all-btn {
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.55);
  padding: 7px 16px;
  border-radius: 99px;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.05em;
  cursor: pointer;
  transition: all 0.2s;
}
.see-all-btn:hover {
  background: rgba(255,255,255,0.1);
  color: #fff;
}

/* ─── Body layout ─────────────────────────────────────── */
.chart-body {
  display: grid;
  grid-template-columns: 1fr 340px;
  gap: 32px;
  align-items: start;
}

/* ─── Bars panel ──────────────────────────────────────── */
.bars-panel {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.bar-row {
  display: grid;
  grid-template-columns: 32px 40px 1fr;
  align-items: center;
  gap: 12px;
  padding: 8px 12px;
  border-radius: 10px;
  cursor: pointer;
  transition: background 0.15s;
}

.bar-row:hover { background: rgba(255,255,255,0.04); }
.bar-row.is-active { background: rgba(0,170,255,0.07); }

/* Rank */
.bar-rank {
  display: flex;
  align-items: center;
  justify-content: center;
}
.rank-num {
  font-size: 13px;
  font-weight: 700;
  color: rgba(255,255,255,0.25);
  font-variant-numeric: tabular-nums;
  width: 20px;
  text-align: center;
}

/* Wave for playing */
.rank-wave {
  display: flex;
  align-items: flex-end;
  gap: 2px;
  height: 14px;
}
.rank-wave span {
  display: block;
  width: 3px;
  background: #00aaff;
  border-radius: 2px;
  animation: wv 0.8s ease-in-out infinite;
}
.rank-wave span:nth-child(1) { animation-delay: 0s;    animation-duration: 0.9s; }
.rank-wave span:nth-child(2) { animation-delay: 0.15s; animation-duration: 0.7s; }
.rank-wave span:nth-child(3) { animation-delay: 0.3s;  animation-duration: 1.0s; }
@keyframes wv {
  0%,100% { height: 3px; }
  50%      { height: 14px; }
}

/* Cover */
.bar-cover {
  position: relative;
  width: 40px; height: 40px;
  border-radius: 7px;
  overflow: hidden;
  flex-shrink: 0;
  background: rgba(255,255,255,0.05);
}
.bar-cover img { width: 100%; height: 100%; object-fit: cover; display: block; }
.bar-cover-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  opacity: 0;
  transition: opacity 0.15s;
}
.bar-row:hover .bar-cover-overlay,
.bar-row.is-active .bar-cover-overlay { opacity: 1; }

/* Info + bar */
.bar-info {
  display: flex;
  flex-direction: column;
  gap: 5px;
  min-width: 0;
}

.bar-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}

.bar-title {
  font-size: 13px;
  font-weight: 600;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  flex: 1;
  min-width: 0;
  transition: color 0.15s;
}
.bar-row.is-active .bar-title { color: #00aaff; }

.bar-plays {
  font-size: 11px;
  color: rgba(255,255,255,0.35);
  font-variant-numeric: tabular-nums;
  white-space: nowrap;
  flex-shrink: 0;
}

.bar-track {
  width: 100%;
  height: 4px;
  background: rgba(255,255,255,0.07);
  border-radius: 99px;
  overflow: hidden;
}

.bar-fill {
  height: 100%;
  border-radius: 99px;
  transition: width 0.8s cubic-bezier(0.4, 0, 0.2, 1);
}

.bar-artist {
  font-size: 11px;
  color: rgba(255,255,255,0.32);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* ─── Podium panel ────────────────────────────────────── */
.podium-panel {
  position: relative;
  background: rgba(255,255,255,0.02);
  border: 1px solid rgba(255,255,255,0.06);
  border-radius: 16px;
  padding: 20px 16px 80px;
  overflow: hidden;
}

.podium-label {
  font-size: 11px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: rgba(255,255,255,0.3);
  margin-bottom: 16px;
}

.podium-cards {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.podium-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 12px;
  border-radius: 12px;
  cursor: pointer;
  position: relative;
  transition: background 0.15s;
  border: 1px solid transparent;
}

.podium-card:hover { background: rgba(255,255,255,0.04); }

.podium-card.rank-1 {
  background: rgba(251,192,45,0.07);
  border-color: rgba(251,192,45,0.15);
}
.podium-card.rank-2 {
  background: rgba(156,163,175,0.06);
  border-color: rgba(156,163,175,0.12);
}
.podium-card.rank-3 {
  background: rgba(180,83,9,0.07);
  border-color: rgba(180,83,9,0.15);
}

.podium-crown {
  position: absolute;
  top: -8px; left: 12px;
  color: #fbbf24;
}

.podium-avatar {
  position: relative;
  width: 52px; height: 52px;
  border-radius: 10px;
  overflow: hidden;
  flex-shrink: 0;
}
.podium-avatar img { width: 100%; height: 100%; object-fit: cover; display: block; }

.podium-play-overlay {
  position: absolute;
  inset: 0;
  background: rgba(0,0,0,0.55);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  opacity: 0;
  transition: opacity 0.15s;
}
.podium-card:hover .podium-play-overlay { opacity: 1; }

.podium-badge {
  position: absolute;
  bottom: 6px; left: 14px;
  font-size: 10px;
  font-weight: 800;
  width: 18px; height: 18px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}
.rank-1 .podium-badge { background: #fbbf24; color: #000; }
.rank-2 .podium-badge { background: #9ca3af; color: #000; }
.rank-3 .podium-badge { background: #b45309; color: #fff; }

.podium-info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.podium-title {
  font-size: 13px;
  font-weight: 700;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.podium-artist {
  font-size: 11px;
  color: rgba(255,255,255,0.4);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.podium-plays {
  font-size: 11px;
  color: #00aaff;
  font-weight: 600;
  font-variant-numeric: tabular-nums;
}

/* ─── Wave decoration ─────────────────────────────────── */
.wave-deco {
  position: absolute;
  bottom: 0; left: 0; right: 0;
  height: 56px;
  display: flex;
  align-items: flex-end;
  gap: 2px;
  padding: 0 8px 8px;
  pointer-events: none;
}

.wave-deco span {
  flex: 1;
  background: rgba(0,170,255,0.12);
  border-radius: 2px 2px 0 0;
  animation: wv2 1.5s ease-in-out infinite;
}

@keyframes wv2 {
  0%,100% { transform: scaleY(0.3); opacity: 0.4; }
  50%      { transform: scaleY(1);   opacity: 0.8; }
}

/* Stagger wave-deco children */
.wave-deco span:nth-child(odd)  { animation-delay: 0.3s; }
.wave-deco span:nth-child(3n)   { animation-delay: 0.6s; }
.wave-deco span:nth-child(4n)   { animation-delay: 0.1s; }
.wave-deco span:nth-child(5n)   { animation-delay: 0.8s; }

/* ─── Responsive ──────────────────────────────────────── */
@media (max-width: 1100px) {
  .chart-body { grid-template-columns: 1fr; }
  .podium-panel { display: none; }
}

@media (max-width: 640px) {
  .vc-chart { padding: 24px 16px 32px; }
  .bar-row { grid-template-columns: 24px 36px 1fr; gap: 8px; }
}
</style>
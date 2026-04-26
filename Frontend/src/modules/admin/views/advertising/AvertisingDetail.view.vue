<template>
  <div class="ad-detail-page">

    <!-- Back bar -->
    <div class="topbar">
      <button class="back-btn" @click="$router.back()">
        <span class="back-icon">←</span>
        <span>Back to Campaigns</span>
      </button>
      <div class="topbar-right" v-if="ad">
        <span class="badge" :class="'badge-' + ad.status">{{ statusLabel[ad.status] ?? ad.status }}</span>
        <button
          class="btn-toggle"
          :class="ad.status === 'active' ? 'btn-pause' : 'btn-resume'"
          :disabled="advertisingStore.togglingId === ad.id"
          @click="handleToggle"
        >
          {{ advertisingStore.togglingId === ad.id ? 'Updating...' : ad.status === 'active' ? 'Pause Campaign' : 'Resume Campaign' }}
        </button>
      </div>
    </div>

    <!-- Loading -->
    <div v-if="advertisingStore.loadingDetail" class="loading-state">
      <div class="spinner"></div>
      <span>Loading campaign detail...</span>
    </div>

    <!-- Error -->
    <div v-else-if="advertisingStore.error" class="error-state">
      <span class="error-icon">⚠</span>
      <p>{{ advertisingStore.error }}</p>
      <button class="btn-retry" @click="load">Retry</button>
    </div>

    <!-- Content -->
    <template v-else-if="ad">

      <!-- Hero -->
      <div class="hero">
        <div class="hero-left">
          <div class="campaign-avatar">{{ initials(ad.name) }}</div>
          <div>
            <h1 class="campaign-name">{{ ad.name }}</h1>
            <div class="campaign-meta">
              <span class="meta-tag">{{ ad.type?.toUpperCase() }}</span>
              <span class="meta-dot">·</span>
              <a v-if="ad.advertiser_url" :href="ad.advertiser_url" target="_blank" class="meta-link">
                {{ ad.advertiser_name }}
              </a>
              <span v-else class="meta-dim">{{ ad.advertiser_name }}</span>
              <span class="meta-dot">·</span>
              <span class="meta-dim">ID #{{ ad.id }}</span>
            </div>
          </div>
        </div>

        <!-- Thumbnail preview -->
        <div v-if="ad.thumbnail_url" class="thumb-preview">
          <img :src="ad.thumbnail_url" :alt="ad.name" />
          <a v-if="ad.media_url" :href="ad.media_url" target="_blank" class="media-link-btn">
            View Media ↗
          </a>
        </div>
      </div>

      <!-- Budget highlight bar -->
      <div class="budget-hero">
        <div class="budget-hero-item">
          <span class="bh-label">Total Budget</span>
          <span class="bh-value">₫{{ fmt(ad.budget?.total) }}</span>
        </div>
        <div class="budget-divider"></div>
        <div class="budget-hero-item">
          <span class="bh-label">Spent</span>
          <span class="bh-value spent">₫{{ fmt(ad.budget?.spent) }}</span>
        </div>
        <div class="budget-divider"></div>
        <div class="budget-hero-item">
          <span class="bh-label">Remaining</span>
          <span class="bh-value remaining">₫{{ fmt(ad.budget?.remaining) }}</span>
        </div>
        <div class="budget-divider"></div>
        <div class="budget-hero-item fill">
          <div class="bh-progress-header">
            <span class="bh-label">Budget Used</span>
            <span class="bh-pct">{{ ad.budget?.used_percent }}</span>
          </div>
          <div class="bh-track">
            <div class="bh-bar" :style="{ width: ad.budget?.used_percent }"></div>
          </div>
        </div>
      </div>

      <!-- Main grid -->
      <div class="detail-grid">

        <!-- Left column -->
        <div class="col-left">

          <!-- Pricing -->
          <div class="card">
            <div class="card-title">Pricing</div>
            <div class="kv-list">
              <div class="kv-row">
                <span class="kv-key">Cost per Play</span>
                <span class="kv-val accent">₫{{ fmt(ad.cost_per_play) }}</span>
              </div>
              <div class="kv-row">
                <span class="kv-key">Cost per Click</span>
                <span class="kv-val accent">₫{{ fmt(ad.cost_per_click) }}</span>
              </div>
              <div class="kv-row">
                <span class="kv-key">Priority</span>
                <span class="kv-val">
                  <span class="priority-pill">{{ ad.priority }}</span>
                </span>
              </div>
            </div>
          </div>

          <!-- Limits -->
          <div class="card">
            <div class="card-title">Frequency Limits</div>
            <div class="kv-list">
              <div class="kv-row">
                <span class="kv-key">Max Plays / User / Day</span>
                <span class="kv-val">{{ ad.max_plays_per_user_per_day ?? '—' }}</span>
              </div>
              <div class="kv-row">
                <span class="kv-key">Frequency Cap</span>
                <span class="kv-val">{{ ad.frequency_cap ?? '—' }}</span>
              </div>
            </div>
          </div>

          <!-- Media info -->
          <div class="card">
            <div class="card-title">Media</div>
            <div class="kv-list">
              <div class="kv-row">
                <span class="kv-key">Duration</span>
                <span class="kv-val">{{ ad.duration ? ad.duration + 's' : '—' }}</span>
              </div>
              <div class="kv-row">
                <span class="kv-key">File Size</span>
                <span class="kv-val">{{ ad.file_size_readable ?? '—' }}</span>
              </div>
              <div class="kv-row">
                <span class="kv-key">Click URL</span>
                <a v-if="ad.click_url" :href="ad.click_url" target="_blank" class="kv-val kv-link">
                  {{ truncate(ad.click_url, 40) }}
                </a>
                <span v-else class="kv-val dim">—</span>
              </div>
            </div>
          </div>

        </div>

        <!-- Right column -->
        <div class="col-right">

          <!-- Schedule -->
          <div class="card">
            <div class="card-title">Schedule</div>
            <div class="schedule-row">
              <div class="schedule-block">
                <span class="sch-label">Start Date</span>
                <span class="sch-date">{{ fmtDate(ad.schedule?.start_date) }}</span>
              </div>
              <div class="sch-arrow">→</div>
              <div class="schedule-block">
                <span class="sch-label">End Date</span>
                <span class="sch-date" :class="{ expired: ad.schedule?.is_expired }">
                  {{ fmtDate(ad.schedule?.end_date) ?? '∞' }}
                </span>
              </div>
              <div class="schedule-block days-block">
                <span class="sch-label">Days Remaining</span>
                <span class="sch-days" :class="ad.schedule?.is_expired ? 'expired' : 'active-days'">
                  {{ ad.schedule?.is_expired ? 'Expired' : (ad.schedule?.days_remaining ?? '∞') }}
                </span>
              </div>
            </div>
          </div>

          <!-- Targeting -->
          <div class="card">
            <div class="card-title">Targeting</div>
            <div class="targeting-grid">
              <div class="target-block">
                <span class="t-label">Age Range</span>
                <span class="t-val">
                  {{ ad.targeting?.age_min ?? '—' }} – {{ ad.targeting?.age_max ?? '—' }}
                </span>
              </div>
              <div class="target-block">
                <span class="t-label">Gender</span>
                <span class="t-val">{{ ad.targeting?.gender ?? 'All' }}</span>
              </div>
              <div class="target-block full">
                <span class="t-label">Locations</span>
                <div class="tag-list">
                  <template v-if="Array.isArray(ad.targeting?.location) && ad.targeting.location.length">
                    <span v-for="loc in ad.targeting.location" :key="loc" class="tag tag-loc">{{ loc }}</span>
                  </template>
                  <span v-else class="t-val">{{ ad.targeting?.location ?? 'All' }}</span>
                </div>
              </div>
              <div class="target-block full">
                <span class="t-label">Genres</span>
                <div class="tag-list">
                  <template v-if="Array.isArray(ad.targeting?.genres) && ad.targeting.genres.length">
                    <span v-for="g in ad.targeting.genres" :key="g" class="tag tag-genre">{{ g }}</span>
                  </template>
                  <span v-else class="t-val">All</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Timestamps -->
          <div class="card card-dim">
            <div class="kv-list">
              <div class="kv-row">
                <span class="kv-key">Created</span>
                <span class="kv-val dim">{{ ad.created_at }}</span>
              </div>
              <div class="kv-row">
                <span class="kv-key">Last Updated</span>
                <span class="kv-val dim">{{ ad.updated_at }}</span>
              </div>
            </div>
          </div>

        </div>
      </div>
    </template>

  </div>
</template>

<script setup>
import { computed, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAdvertisingStore } from '@/modules/admin/stores/avertising/avertisingsStore'

const route = useRoute()
const router = useRouter()
const advertisingStore = useAdvertisingStore()

const ad = computed(() => advertisingStore.currentAd)

const statusLabel = {
  active: 'Active', paused: 'Paused', completed: 'Completed', draft: 'Draft'
}

const load = async () => {
  await advertisingStore.fetchById(route.params.id)
}

onMounted(load)
onUnmounted(() => advertisingStore.clearCurrentAd())

const handleToggle = async () => {
  if (!ad.value?.id) return
  try {
    await advertisingStore.toggleStatus(ad.value.id)
  } catch { /* error in store */ }
}

// ── Helpers ───────────────────────────────────────────────
const fmt = (val) => {
  if (val === null || val === undefined) return '—'
  return Number(val).toLocaleString('vi-VN')
}

const fmtDate = (iso) => {
  if (!iso) return null
  return iso.slice(0, 10)
}

const initials = (name) =>
  (name ?? '?').split(' ').map(w => w[0]).join('').slice(0, 2).toUpperCase()

const truncate = (str, n) =>
  str && str.length > n ? str.slice(0, n) + '…' : str
</script>

<style scoped>
.ad-detail-page {
  min-height: 100vh;
  background: #10131a;
  color: #e2e8f0;
  font-family: 'DM Sans', 'Inter', sans-serif;
  font-size: 14px;
  padding: 0 0 60px;
}

/* ── Topbar ── */
.topbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 32px;
  border-bottom: 0.5px solid #1e2535;
  background: #10131a;
  position: sticky;
  top: 0;
  z-index: 10;
  backdrop-filter: blur(8px);
}
.back-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  background: transparent;
  border: none;
  color: #64748b;
  cursor: pointer;
  font-size: 13px;
  font-family: inherit;
  transition: color 0.15s;
}
.back-btn:hover { color: #94a3b8; }
.back-icon { font-size: 16px; }
.topbar-right { display: flex; align-items: center; gap: 12px; }

/* ── Badge ── */
.badge { display:inline-block; padding:3px 12px; border-radius:20px; font-size:11px; font-weight:600; letter-spacing:0.04em; }
.badge-active   { background:#064e3b; color:#34d399; }
.badge-paused   { background:#3b1f00; color:#f59e0b; }
.badge-completed{ background:#1f1f2e; color:#64748b; }
.badge-draft    { background:#1e1e35; color:#818cf8; }

/* ── Toggle button ── */
.btn-toggle {
  padding: 7px 18px;
  border-radius: 8px;
  border: none;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  font-family: inherit;
  transition: opacity 0.15s;
}
.btn-toggle:disabled { opacity: 0.5; cursor: not-allowed; }
.btn-pause  { background: #3b1f00; color: #f59e0b; }
.btn-resume { background: #064e3b; color: #34d399; }
.btn-pause:hover:not(:disabled)  { opacity: 0.8; }
.btn-resume:hover:not(:disabled) { opacity: 0.8; }

/* ── Loading / Error ── */
.loading-state {
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  gap: 16px; height: 40vh; color: #475569;
}
.spinner {
  width: 32px; height: 32px;
  border: 2px solid #1e2535;
  border-top-color: #3a80f5;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }
.error-state {
  display: flex; flex-direction: column; align-items: center; gap: 12px;
  padding: 60px; color: #f87171; text-align: center;
}
.error-icon { font-size: 32px; }
.btn-retry {
  background: #1e2535; border: 0.5px solid #334155; border-radius: 8px;
  padding: 8px 20px; color: #94a3b8; cursor: pointer; font-family: inherit; font-size: 13px;
}

/* ── Hero ── */
.hero {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 24px;
  padding: 32px 32px 24px;
}
.hero-left { display: flex; align-items: center; gap: 18px; }
.campaign-avatar {
  width: 56px; height: 56px; border-radius: 14px;
  background: linear-gradient(135deg, #1e2a45, #2d3f6b);
  border: 0.5px solid #2d3f6b;
  display: flex; align-items: center; justify-content: center;
  font-size: 18px; font-weight: 600; color: #818cf8;
  flex-shrink: 0;
}
.campaign-name { font-size: 22px; font-weight: 600; color: #f1f5f9; margin: 0 0 6px; }
.campaign-meta { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
.meta-tag {
  background: #1e2535; border: 0.5px solid #2d3748;
  border-radius: 4px; padding: 2px 8px; font-size: 10px;
  font-weight: 600; color: #818cf8; letter-spacing: 0.06em;
}
.meta-dot { color: #334155; }
.meta-link { color: #3a80f5; text-decoration: none; font-size: 13px; }
.meta-link:hover { text-decoration: underline; }
.meta-dim { color: #475569; font-size: 13px; }

.thumb-preview {
  display: flex; flex-direction: column; align-items: flex-end; gap: 8px; flex-shrink: 0;
}
.thumb-preview img {
  width: 200px; height: 112px; object-fit: cover;
  border-radius: 10px; border: 0.5px solid #2d3748;
}
.media-link-btn {
  font-size: 11px; color: #3a80f5; text-decoration: none;
  border: 0.5px solid #1e3a6e; border-radius: 6px; padding: 4px 10px;
  transition: background 0.15s;
}
.media-link-btn:hover { background: #1e2a45; }

/* ── Budget hero bar ── */
.budget-hero {
  display: flex;
  align-items: center;
  gap: 0;
  margin: 0 32px 28px;
  background: #131720;
  border: 0.5px solid #1e2535;
  border-radius: 12px;
  padding: 20px 28px;
}
.budget-hero-item {
  display: flex; flex-direction: column; gap: 6px;
  padding: 0 24px;
}
.budget-hero-item.fill { flex: 1; }
.budget-hero-item:first-child { padding-left: 0; }
.bh-label { font-size: 10px; color: #475569; text-transform: uppercase; letter-spacing: 0.06em; }
.bh-value { font-size: 20px; font-weight: 600; color: #f1f5f9; }
.bh-value.spent { color: #f87171; }
.bh-value.remaining { color: #34d399; }
.budget-divider { width: 0.5px; height: 40px; background: #1e2535; flex-shrink: 0; }
.bh-progress-header { display: flex; justify-content: space-between; align-items: center; }
.bh-pct { font-size: 13px; font-weight: 600; color: #3a80f5; }
.bh-track {
  width: 100%; background: #1e2535; border-radius: 6px;
  height: 8px; overflow: hidden; margin-top: 4px;
}
.bh-bar {
  height: 100%; border-radius: 6px;
  background: linear-gradient(90deg, #3a80f5, #818cf8);
  transition: width 0.6s ease;
}

/* ── Main grid ── */
.detail-grid {
  display: grid;
  grid-template-columns: 1fr 1.4fr;
  gap: 20px;
  padding: 0 32px;
}
.col-left, .col-right { display: flex; flex-direction: column; gap: 16px; }

/* ── Card ── */
.card {
  background: #13172075;
  border: 0.5px solid #1e2535;
  border-radius: 12px;
  padding: 20px;
}
.card-dim { background: transparent; }
.card-title {
  font-size: 11px; font-weight: 600; color: #475569;
  text-transform: uppercase; letter-spacing: 0.07em;
  margin-bottom: 16px;
  padding-bottom: 10px;
  border-bottom: 0.5px solid #1e2535;
}

/* ── KV list ── */
.kv-list { display: flex; flex-direction: column; gap: 12px; }
.kv-row { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
.kv-key { font-size: 12px; color: #64748b; }
.kv-val { font-size: 13px; color: #cbd5e1; font-weight: 500; }
.kv-val.accent { color: #818cf8; }
.kv-val.dim { color: #475569; }
.kv-link { color: #3a80f5; text-decoration: none; font-size: 12px; }
.kv-link:hover { text-decoration: underline; }

.priority-pill {
  background: #1e2535; border: 0.5px solid #3a80f5;
  border-radius: 20px; padding: 2px 12px;
  font-size: 12px; font-weight: 600; color: #3a80f5;
}

/* ── Schedule ── */
.schedule-row {
  display: flex; align-items: center; gap: 16px; flex-wrap: wrap;
}
.schedule-block { display: flex; flex-direction: column; gap: 4px; }
.sch-label { font-size: 10px; color: #475569; text-transform: uppercase; letter-spacing: 0.05em; }
.sch-date { font-size: 15px; font-weight: 500; color: #e2e8f0; }
.sch-date.expired { color: #f87171; }
.sch-arrow { color: #334155; font-size: 18px; }
.days-block { margin-left: auto; text-align: right; }
.sch-days { font-size: 28px; font-weight: 700; }
.active-days { color: #34d399; }
.sch-days.expired { color: #f87171; font-size: 18px; }

/* ── Targeting ── */
.targeting-grid {
  display: grid; grid-template-columns: 1fr 1fr; gap: 16px;
}
.target-block { display: flex; flex-direction: column; gap: 6px; }
.target-block.full { grid-column: 1 / -1; }
.t-label { font-size: 10px; color: #475569; text-transform: uppercase; letter-spacing: 0.05em; }
.t-val { font-size: 13px; color: #cbd5e1; font-weight: 500; text-transform: capitalize; }
.tag-list { display: flex; flex-wrap: wrap; gap: 6px; }
.tag {
  padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 500;
}
.tag-loc { background: #1e2a45; color: #3a80f5; border: 0.5px solid #1e3a6e; }
.tag-genre { background: #1e1e35; color: #818cf8; border: 0.5px solid #2d2d5e; }

/* ── Responsive ── */
@media (max-width: 900px) {
  .detail-grid { grid-template-columns: 1fr; }
  .hero { flex-direction: column; }
  .thumb-preview { align-items: flex-start; }
  .thumb-preview img { width: 100%; height: auto; }
  .budget-hero { flex-wrap: wrap; gap: 16px; }
  .budget-divider { display: none; }
  .budget-hero-item { padding: 0; }
}
@media (max-width: 600px) {
  .topbar { padding: 12px 16px; }
  .hero { padding: 20px 16px; }
  .budget-hero { margin: 0 16px 20px; padding: 16px; }
  .detail-grid { padding: 0 16px; }
  .campaign-name { font-size: 18px; }
}
</style>
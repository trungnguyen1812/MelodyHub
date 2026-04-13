<template>
  <div class="user-shell">
    <div class="bg-grid" aria-hidden="true"></div>

    <!-- Header -->
    <header class="topbar">
      <button class="back-btn" @click="$router.push({ name: 'admin.artistsmanager.all' })">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M7.793 2.232a.75.75 0 0 1-.025 1.06L3.622 7.25h10.003a5.375 5.375 0 0 1 0 10.75H10.75a.75.75 0 0 1 0-1.5h2.875a3.875 3.875 0 0 0 0-7.75H3.622l4.146 3.957a.75.75 0 0 1-1.036 1.085l-5.5-5.25a.75.75 0 0 1 0-1.085l5.5-5.25a.75.75 0 0 1 1.06.025Z" clip-rule="evenodd" />
        </svg>
        Artists
      </button>
      <div class="topbar-center">
        <span class="topbar-label">Artist Profile: {{ form.name }}</span>
      </div>
      <button class="edit-btn" @click="$router.push({ name: 'admin.artistsmanager.update', params: { id: route.params.id } })">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path d="m5.433 13.917 1.262-3.155A4 4 0 0 1 7.58 9.42l6.92-6.918a2.121 2.121 0 0 1 3 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 0 1-.65-.65Z" />
          <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0 0 10 3H4.75A2.75 2.75 0 0 0 2 5.75v9.5A2.75 2.75 0 0 0 4.75 18h9.5A2.75 2.75 0 0 0 17 15.25V10a.75.75 0 0 0-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5Z" />
        </svg>
        Edit Artist
      </button>
    </header>

    <div v-if="loading" class="loading-overlay">
      <div class="spinner-large"></div>
      <p>Fetching artist intelligence...</p>
    </div>

    <div v-else class="page-body">
      <!-- Left: Details -->
      <div class="form-col">

        <!-- Analytics Dashboard -->
        <div class="card analytics-card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M2.25 13.5a8.25 8.25 0 0 1 8.25-8.25.75.75 0 0 1 .75.75v6.75H18a.75.75 0 0 1 .75.75 8.25 8.25 0 0 1-16.5 0Z" clip-rule="evenodd" />
                <path fill-rule="evenodd" d="M12.75 3a.75.75 0 0 1 .75-.75 8.25 8.25 0 0 1 8.25 8.25.75.75 0 0 1-.75.75h-7.5a.75.75 0 0 1-.75-.75V3Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Engagement intelligence</h2>
              <p class="card-sub">Platform-wide statistics and metrics</p>
            </div>
          </div>

          <div class="stats-grid">
            <div class="stat-item">
              <span class="stat-label">Total Songs</span>
              <span class="stat-value">{{ form.stats?.songs_count || 0 }}</span>
              <div class="stat-progress songs"></div>
            </div>
            <div class="stat-item">
              <span class="stat-label">Total Albums</span>
              <span class="stat-value">{{ form.stats?.albums_count || 0 }}</span>
              <div class="stat-progress albums"></div>
            </div>
            <div class="stat-item">
              <span class="stat-label">Followers</span>
              <span class="stat-value">{{ formatLargeNumber(form.stats?.followers_count) }}</span>
              <div class="stat-progress followers"></div>
            </div>
            <div class="stat-item">
              <span class="stat-label">Monthly Listeners</span>
              <span class="stat-value">{{ formatLargeNumber(form.stats?.monthly_listeners) }}</span>
              <div class="stat-progress listeners"></div>
            </div>
          </div>
        </div>

        <!-- Identity -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
               <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Identity & Public URL</h2>
              <p class="card-sub">Core biographical identifiers</p>
            </div>
          </div>

          <div class="details-view-grid">
            <div class="detail-item">
              <span class="dlabel">Artist Name</span>
              <p class="dvalue highlight">{{ form.name }}</p>
            </div>
            <div class="detail-item">
              <span class="dlabel">URL Slug</span>
              <p class="dvalue mono">@{{ form.slug }}</p>
            </div>
            <div class="detail-item">
              <span class="dlabel">Origin Country</span>
              <p class="dvalue">{{ form.country || '—' }}</p>
            </div>
            <div class="detail-item">
              <span class="dlabel">Official Website</span>
              <p class="dvalue">
                <a v-if="form.website" :href="form.website" target="_blank" class="external-link">
                  {{ form.website }}
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="12" height="12">
                    <path fill-rule="evenodd" d="M4.25 5.5a.75.75 0 0 0-.75.75v8.5c0 .414.336.75.75.75h8.5a.75.75 0 0 0 .75-.75v-4a.75.75 0 0 1 1.5 0v4A2.25 2.25 0 0 1 12.75 17h-8.5A2.25 2.25 0 0 1 2 14.75v-8.5A2.25 2.25 0 0 1 4.25 4h5a.75.75 0 0 1 0 1.5h-5z" clip-rule="evenodd" />
                    <path fill-rule="evenodd" d="M6.194 12.753a.75.75 0 0 0 1.06.053L16.5 4.44v2.81a.75.75 0 0 0 1.5 0v-4.5a.75.75 0 0 0-.75-.75h-4.5a.75.75 0 0 0 0 1.5h2.553l-9.056 8.194a.75.75 0 0 0-.053 1.06z" clip-rule="evenodd" />
                  </svg>
                </a>
                <span v-else>—</span>
              </p>
            </div>
          </div>
        </div>

        <!-- Biography -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M5.625 1.5c-1.036 0-1.875.84-1.875 1.875v17.25c0 1.035.84 1.875 1.875 1.875h12.75c1.035 0 1.875-.84 1.875-1.875V12.75A3.75 3.75 0 0 0 16.5 9h-1.875V1.5H5.625ZM7.5 9.75a.75.75 0 0 1 .75-.75h4.5a.75.75 0 0 1 0 1.5h-4.5a.75.75 0 0 1-.75-.75Zm.75 2.25a.75.75 0 0 0 0 1.5h7.5a.75.75 0 0 0 0-1.5h-7.5Zm0 3a.75.75 0 0 0 0 1.5h7.5a.75.75 0 0 0 0-1.5h-7.5Z" clip-rule="evenodd" />
                <path d="M16.5 7.5h1.875a3.75 3.75 0 0 1 3.75 3.75V1.5h-5.625V7.5Z" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Biography & Narrative</h2>
              <p class="card-sub">Visual storytelling and career history</p>
            </div>
          </div>
          <p class="bio-text">{{ form.bio || 'This artist has not provided a biography yet.' }}</p>
        </div>

        <!-- Social Presence -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M19.902 4.098a3.75 3.75 0 0 0-5.304 0l-4.5 4.5a3.75 3.75 0 0 0 1.035 6.037.75.75 0 0 1-.646 1.353 5.25 5.25 0 0 1-1.449-8.45l4.5-4.5a5.25 5.25 0 1 1 7.424 7.424l-1.757 1.757a.75.75 0 1 1-1.06-1.06l1.757-1.757a3.75 3.75 0 0 0 0-5.304Zm-7.398 7.398a.75.75 0 0 1 1.06 0 5.25 5.25 0 0 1 1.449 8.45l-4.5 4.5a5.25 5.25 0 1 1-7.424-7.424l1.757-1.757a.75.75 0 1 1 1.06 1.06l-1.757 1.757a3.75 3.75 0 1 0 5.304 5.304l4.5-4.5a3.75 3.75 0 0 0-1.035-6.037.75.75 0 0 1 .646-1.353Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Digital social profile</h2>
              <p class="card-sub">Connected external networks</p>
            </div>
          </div>
          <div class="social-links-display">
            <a v-if="form.facebook_url" :href="form.facebook_url" target="_blank" class="social-pill fb">Facebook</a>
            <a v-if="form.instagram_url" :href="form.instagram_url" target="_blank" class="social-pill ig">Instagram</a>
            <a v-if="form.twitter_url" :href="form.twitter_url" target="_blank" class="social-pill tw">X / Twitter</a>
            <a v-if="form.youtube_url" :href="form.youtube_url" target="_blank" class="social-pill yt">YouTube</a>
            <p v-if="!hasSocials" class="no-data-hint">No social links configured</p>
          </div>
        </div>
      </div>

      <!-- Right: Intelligence -->
      <div class="preview-col">
        <div class="preview-sticky">
           <p class="preview-label">Digital Profile Card</p>

           <!-- Artist Card -->
           <div class="artist-preview-card">
             <div class="apc-banner">
               <img :src="displayBanner" class="apc-banner-img" />
             </div>
             <div class="apc-body">
               <div class="apc-avatar-wrap shadowed">
                 <img :src="displayAvatar" class="apc-avatar-img" />
               </div>
               <div class="apc-info">
                 <div class="apc-name-row">
                   <span class="apc-name">{{ form.name }}</span>
                   <svg v-if="form.verified" class="apc-verified-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="#00aaff" width="16" height="16">
                      <path fill-rule="evenodd" d="M16.403 12.652a3 3 0 0 0 0-5.304 3 3 0 0 0-3.75-3.751 3 3 0 0 0-5.305 0 3 3 0 0 0-3.751 3.75 3 3 0 0 0 0 5.305 3 3 0 0 0 3.75 3.751 3 3 0 0 0 5.305 0 3 3 0 0 0 3.751-3.75Zm-2.546-4.46a.75.75 0 0 0-1.214-.883L9.16 12.1l-1.88-1.88a.75.75 0 1 0-1.06 1.061l2.5 2.5a.75.75 0 0 0 1.137-.089l3-4.128Z" clip-rule="evenodd" />
                   </svg>
                 </div>
                 <span class="apc-slug">@{{ form.slug }}</span>
               </div>
               <div class="apc-badges">
                 <span class="apc-tag" :class="form.status">{{ form.status }}</span>
                 <span v-if="form.is_featured" class="apc-tag featured">Featured</span>
               </div>
             </div>
           </div>

           <!-- System Info -->
           <div class="card system-card">
              <div class="sys-row">
                 <span class="sys-label">Partner Access</span>
                 <span class="sys-val">{{ form.partner_id || 'System Primary' }}</span>
              </div>
              <div class="sys-row">
                 <span class="sys-label">Index Status</span>
                 <span class="sys-val success">Searchable</span>
              </div>
              <div class="divider"></div>
              <div class="sys-row">
                 <span class="sys-label">Registration</span>
                 <span class="sys-val">{{ formatDate(form.created_at) }}</span>
              </div>
              <div class="sys-row">
                 <span class="sys-label">Last Synchronization</span>
                 <span class="sys-val">{{ formatDate(form.updated_at) }}</span>
              </div>
           </div>

           <!-- SEO Recap -->
           <div class="card seo-mini">
              <span class="mini-title">SEO Optimization</span>
              <p class="mini-desc">{{ form.seo_title || form.name }}</p>
              <div class="keywords-row">
                <span v-for="k in keywords" :key="k" class="k-tag">#{{ k }}</span>
              </div>
           </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed, reactive } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useArtistStore, getFullImageUrl } from '@/modules/admin/stores/artists/artistsStore'
import { useNotificationStore } from "@/store/notificationStore"

const route = useRoute()
const router = useRouter()
const notificationStore = useNotificationStore()
const artistStore = useArtistStore()

const loading = ref(true)
const form = reactive<any>({
    name: "",
    slug: "",
    bio: "",
    country: "",
    website: "",
    facebook_url: "",
    instagram_url: "",
    twitter_url: "",
    youtube_url: "",
    verified: false,
    is_featured: false,
    status: "active",
    partner_id: null,
    stats: {
      songs_count: 0,
      albums_count: 0,
      followers_count: 0,
      monthly_listeners: 0
    },
    created_at: null,
    updated_at: null,
    seo_title: "",
    seo_keywords: "",
    seo_description: "",
});

const defaultAvatar = 'https://via.placeholder.com/500?text=Artist'
const defaultBanner = 'https://via.placeholder.com/1920x500?text=Banner'

const displayAvatar = computed(() => {
    if (form.avatar_url) return getFullImageUrl(form.avatar_url);
    if (form.avatar) return getFullImageUrl(form.avatar);
    return defaultAvatar;
});

const displayBanner = computed(() => {
    if (form.banner_url) return getFullImageUrl(form.banner_url);
    if (form.banner) return getFullImageUrl(form.banner);
    return defaultBanner;
});

const hasSocials = computed(() => {
  return form.facebook_url || form.instagram_url || form.twitter_url || form.youtube_url;
});

const keywords = computed(() => {
  if (!form.seo_keywords) return [];
  return form.seo_keywords.split(',').map((k: string) => k.trim()).filter((k: string) => k);
});

const formatLargeNumber = (num?: number): string => {
    if (!num) return '0'
    if (num >= 1000000) return (num / 1000000).toFixed(1) + 'M'
    if (num >= 1000) return (num / 1000).toFixed(1) + 'K'
    return num.toString()
}

const formatDate = (dateString?: string): string => {
    if (!dateString) return '—'
    return new Date(dateString).toLocaleDateString('en-US', {
        month: 'short', day: 'numeric', year: 'numeric'
    })
}

const loadArtistIntelligence = async () => {
    try {
        loading.value = true;
        const id = Number(route.params.id);
        const res = await artistStore.fetchShow(id);
        if (res && res.data) {
            Object.assign(form, res.data);
            // Patch for potential different API schemas
            if (res.data.avatar_url) form.avatar_url = res.data.avatar_url;
            if (res.data.banner_url) form.banner_url = res.data.banner_url;
        }
    } catch (error: any) {
        notificationStore.notify("Inteligence retrieval failed", "error");
        router.back();
    } finally {
        loading.value = false;
    }
};

onMounted(loadArtistIntelligence);
</script>

<style scoped>
/* ── Base ───────────────────────────────────────── */
.user-shell {
  min-height: 100vh; background: #080e14;
  font-family: 'DM Sans', 'Segoe UI', sans-serif; color: #e8edf2;
  position: relative;
}
.bg-grid {
  position: fixed; inset: 0; pointer-events: none; z-index: 0;
  background-image:
    linear-gradient(rgba(0,160,255,0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0,160,255,0.03) 1px, transparent 1px);
  background-size: 40px 40px;
}

/* ── Topbar ─────────────────────────────────────── */
.topbar {
  position: sticky; top: 0; z-index: 20;
  display: flex; align-items: center; justify-content: space-between;
  padding: 16px 28px; border-bottom: 1px solid rgba(255,255,255,0.06);
  background: rgba(8,14,20,0.85); backdrop-filter: blur(12px);
}
.back-btn {
  display: flex; align-items: center; gap: 6px; padding: 7px 14px;
  background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1);
  color: rgba(255,255,255,0.7); border-radius: 8px; cursor: pointer; font-size: 13px;
}
.edit-btn {
  display: flex; align-items: center; gap: 6px; padding: 7px 16px;
  background: #00aaff; border: none; color: #000; border-radius: 8px;
  cursor: pointer; font-size: 13px; font-weight: 700; transition: 0.2s;
}
.edit-btn:hover { background: #33bbff; transform: translateY(-1px); }
.topbar-center { flex: 1; margin-left: 24px; }
.topbar-label { font-size: 15px; font-weight: 600; color: rgba(255,255,255,0.6); }

/* ── Page Body ───────────────────────────────────── */
.page-body {
  position: relative; z-index: 1; display: grid;
  grid-template-columns: 1fr 340px; gap: 24px;
  max-width: 1200px; margin: 0 auto; padding: 28px 24px 60px;
}

.card {
  background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07);
  border-radius: 16px; padding: 24px; margin-bottom: 20px;
}
.card-head {
  display: flex; align-items: center; gap: 14px; margin-bottom: 22px;
  padding-bottom: 18px; border-bottom: 1px solid rgba(255,255,255,0.06);
}
.card-icon {
  width: 44px; height: 44px; border-radius: 12px; background: rgba(0,160,255,0.1);
  border: 1px solid rgba(0,160,255,0.2); display: flex; align-items: center; justify-content: center;
}
.card-title { font-size: 16px; font-weight: 600; color: #fff; margin:0 0 3px; }
.card-sub { font-size: 13px; color: rgba(255,255,255,0.4); margin:0; }

/* ── Analytics Card ────────────────────────────── */
.analytics-card { background: linear-gradient(135deg, rgba(0,170,255,0.05) 0%, rgba(255,255,255,0.02) 100%); }
.stats-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
.stat-item { padding: 16px; background: rgba(255,255,255,0.03); border-radius: 12px; position: relative; overflow: hidden; }
.stat-label { font-size: 11px; font-weight: 600; color: rgba(255,255,255,0.4); text-transform: uppercase; margin-bottom: 4px; display: block; }
.stat-value { font-size: 20px; font-weight: 800; color: #fff; }
.stat-progress { position: absolute; bottom: 0; left: 0; height: 3px; background: #00aaff; opacity: 0.3; width: 0; transition: 1s ease-out; }
.songs { width: 65%; } .albums { width: 40%; } .followers { width: 85%; } .listeners { width: 70%; }

/* ── Details View ───────────────────────────────── */
.details-view-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
.detail-item { display: flex; flex-direction: column; gap: 6px; }
.dlabel { font-size: 12px; font-weight: 600; color: rgba(255,255,255,0.3); text-transform: uppercase; }
.dvalue { font-size: 15px; color: rgba(255,255,255,0.8); }
.dvalue.highlight { color: #fff; font-weight: 600; font-size: 16px; }
.dvalue.mono { font-family: 'JetBrains Mono', monospace; color: #00aaff; font-size: 14px; }
.external-link { color: #00aaff; text-decoration: none; display: flex; align-items: center; gap: 4px; }
.external-link:hover { text-decoration: underline; }

.bio-text { font-size: 15px; line-height: 1.7; color: rgba(255,255,255,0.6); white-space: pre-wrap; margin: 0; }

.social-links-display { display: flex; flex-wrap: wrap; gap: 10px; }
.social-pill {
  padding: 8px 16px; border-radius: 100px; font-size: 13px; font-weight: 600; color: #fff; text-decoration: none; transition: 0.2s;
}
.social-pill.fb { background: #1877f2; } .social-pill.ig { background: #e4405f; }
.social-pill.tw { background: #000; border: 1px solid rgba(255,255,255,0.2); } .social-pill.yt { background: #ff0000; }
.social-pill:hover { transform: translateY(-2px); filter: brightness(1.2); }
.no-data-hint { font-size: 13px; color: rgba(255,255,255,0.25); font-style: italic; }

/* ── Right Sidebar Items ────────────────────────── */
.artist-preview-card {
  background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; overflow: hidden; margin-bottom: 16px;
}
.apc-banner { height: 100px; background: rgba(255,255,255,0.05); }
.apc-banner-img { width: 100%; height: 100%; object-fit: cover; }
.apc-body { padding: 0 20px 20px; margin-top: -30px; position: relative; }
.apc-avatar-wrap {
  width: 64px; height: 64px; border-radius: 50%; border: 3px solid #0f1216; overflow: hidden; background: #222; margin-bottom: 12px;
}
.apc-avatar-img { width: 100%; height: 100%; object-fit: cover; }
.apc-name-row { display: flex; align-items: center; gap: 6px; }
.apc-name { font-size: 16px; font-weight: 700; color: #fff; }
.apc-slug { font-size: 12px; color: rgba(255,255,255,0.4); display: block; margin-top: -2px; }
.apc-badges { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 12px; }
.apc-tag { font-size: 10px; padding: 2px 8px; border-radius: 100px; text-transform: capitalize; background: rgba(255,255,255,0.06); color: rgba(255,255,255,0.5); }
.apc-tag.active { color: #00c87a; background: rgba(0,200,120,0.1); }
.apc-tag.featured { color: #fac800; background: rgba(250,200,0,0.1); }

.system-card { padding: 20px; }
.sys-row { display: flex; justify-content: space-between; font-size: 13px; margin-bottom: 10px; }
.sys-label { color: rgba(255,255,255,0.3); }
.sys-val { color: rgba(255,255,255,0.7); font-weight: 500; }
.sys-val.success { color: #00c87a; }
.divider { height: 1px; background: rgba(255,255,255,0.06); margin: 15px 0; }

.seo-mini { padding: 18px; }
.mini-title { display: block; font-size: 12px; font-weight: 700; color: rgba(255,255,255,0.4); margin-bottom: 8px; }
.mini-desc { font-size: 13px; color: rgba(255,255,255,0.7); margin-bottom: 12px; line-height: 1.5; }
.keywords-row { display: flex; flex-wrap: wrap; gap: 6px; }
.k-tag { font-size: 11px; color: #00aaff; opacity: 0.8; }

.preview-col { position: relative; }
.preview-sticky { position: sticky; top: 80px; }
.preview-label { font-size: 11px; font-weight: 600; color: rgba(255,255,255,0.3); text-transform: uppercase; margin-bottom: 12px; }

.loading-overlay { display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 400px; gap: 16px; }
.spinner-large { width: 40px; height: 40px; border: 3px solid rgba(255,255,255,0.05); border-top-color: #00aaff; border-radius: 50%; animation: spin 1s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

@media (max-width: 900px) {
  .page-body { grid-template-columns: 1fr; }
  .preview-col { display: none; }
}
</style>
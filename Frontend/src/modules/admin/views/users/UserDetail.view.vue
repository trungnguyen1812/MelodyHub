<template>
  <div class="user-shell">
    <div class="bg-grid" aria-hidden="true"></div>

    <!-- Header -->
    <header class="topbar">
      <button class="back-btn" @click="$router.back()">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M7.793 2.232a.75.75 0 0 1-.025 1.06L3.622 7.25h10.003a5.375 5.375 0 0 1 0 10.75H10.75a.75.75 0 0 1 0-1.5h2.875a3.875 3.875 0 0 0 0-7.75H3.622l4.146 3.957a.75.75 0 0 1-1.036 1.085l-5.5-5.25a.75.75 0 0 1 0-1.085l5.5-5.25a.75.75 0 0 1 1.06.025Z" clip-rule="evenodd" />
        </svg>
        Users
      </button>
      <div class="topbar-center">
        <span class="topbar-label">User profile: {{ form.username }}</span>
      </div>
      <button class="edit-btn" @click="$router.push({ name: 'admin.usermanager.update', params: { id: form.id } })">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path d="m5.433 13.917 1.262-3.155A4 4 0 0 1 7.58 9.42l6.92-6.918a2.121 2.121 0 0 1 3 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 0 1-.65-.65Z" />
          <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0 0 10 3H4.75A2.75 2.75 0 0 0 2 5.75v9.5A2.75 2.75 0 0 0 4.75 18h9.5A2.75 2.75 0 0 0 17 15.25V10a.75.75 0 0 0-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5Z" />
        </svg>
        Edit Profile
      </button>
    </header>

    <div v-if="loading" class="loading-overlay">
      <div class="spinner-large"></div>
      <p>Loading user data...</p>
    </div>

    <div v-else class="page-body">
      <!-- Left: form-like display -->
      <div class="form-col">

        <!-- Basic info -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Basic information</h2>
              <p class="card-sub">Core account details and identification</p>
            </div>
          </div>

          <div class="fields">
            <div class="field-row two-col">
              <div class="field">
                <label class="flabel">Full name</label>
                <div class="fval">{{ form.name || '—' }}</div>
              </div>
              <div class="field">
                <label class="flabel">Username</label>
                <div class="fval text-accent">@{{ form.username || '—' }}</div>
              </div>
            </div>

            <div class="field-row two-col">
              <div class="field">
                <label class="flabel">Email address</label>
                <div class="fval">{{ form.email || '—' }}</div>
              </div>
              <div class="field">
                <label class="flabel">Phone number</label>
                <div class="fval">{{ form.phone || '—' }}</div>
              </div>
            </div>

            <div class="field-row two-col">
              <div class="field">
                <label class="flabel">Date of birth</label>
                <div class="fval">{{ formatDate(form.date_of_birth) }}</div>
              </div>
              <div class="field">
                <label class="flabel">Gender</label>
                <div class="fval">{{ formatGender(form.gender) }}</div>
              </div>
            </div>
          </div>
        </div>

        <!-- Profile -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M1.5 6a2.25 2.25 0 0 1 2.25-2.25h16.5A2.25 2.25 0 0 1 22.5 6v12a2.25 2.25 0 0 1-2.25 2.25H3.75A2.25 2.25 0 0 1 1.5 18V6ZM3 16.06V18c0 .414.336.75.75.75h16.5A.75.75 0 0 0 21 18v-1.94l-2.69-2.689a1.5 1.5 0 0 0-2.12 0l-.88.879.81.81a.75.75 0 1 1-1.06 1.06l-5.16-5.159a1.5 1.5 0 0 0-2.12 0L3 16.061Zm10.125-7.81a1.125 1.125 0 1 1 2.25 0 1.125 1.125 0 0 1-2.25 0Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Profile details</h2>
              <p class="card-sub">Visuals and public biography</p>
            </div>
          </div>

          <div class="profile-layout">
            <div class="avatar-col">
              <div class="avatar-view shadowed">
                <img :src="displayAvatar" alt="avatar" class="avatar-img" />
              </div>
            </div>
            <div class="field" style="flex:1">
              <label class="flabel">Biography</label>
              <div class="bio-box">{{ form.bio || 'This user hasn\'t added a biography yet.' }}</div>
            </div>
          </div>
        </div>

        <!-- Statistics -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                 <path d="M18.375 2.25c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h.75c.621 0 1.125-.504 1.125-1.125V3.375c0-.621-.504-1.125-1.125-1.125h-.75ZM9.375 7.5c-.621 0-1.125.504-1.125 1.125v12c0 .621.504 1.125 1.125 1.125h.75c.621 0 1.125-.504 1.125-1.125v-12c0-.621-.504-1.125-1.125-1.125h-.75Zm-9 5.25c-.621 0-1.125.504-1.125 1.125v6.75c0 .621.504 1.125 1.125 1.125h.75c.621 0 1.125-.504 1.125-1.125v-6.75c0-.621-.504-1.125-1.125-1.125h-.75Z" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Engagement statistics</h2>
              <p class="card-sub">Play activity and content reach</p>
            </div>
          </div>
          <div class="stats-grid-modern">
            <div class="stat-box">
              <span class="sb-label">Last 24h</span>
              <span class="sb-val">{{ form.play_count_last_24h || 0 }}</span>
            </div>
            <div class="stat-box">
              <span class="sb-label">Last 7d</span>
              <span class="sb-val">{{ form.play_count_last_7d || 0 }}</span>
            </div>
            <div class="stat-box">
              <span class="sb-label">Last 30d</span>
              <span class="sb-val">{{ form.play_count_last_30d || 0 }}</span>
            </div>
            <div class="stat-box trending">
              <span class="sb-label">Trending Score</span>
              <span class="sb-val">{{ (form.trending_score || 0).toFixed(1) }}</span>
            </div>
          </div>
        </div>

        <!-- Location -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="m11.54 22.351.07.04.028.016a.76.76 0 0 0 .723 0l.028-.015.071-.041a16.975 16.975 0 0 0 1.144-.742 19.58 19.58 0 0 0 2.683-2.282c1.944-2.003 3.5-4.697 3.5-8.327a8 8 0 1 0-16 0c0 3.63 1.556 6.324 3.5 8.327a19.592 19.592 0 0 0 2.682 2.282 16.975 16.975 0 0 0 1.144.742ZM12 13.5a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Location & preferences</h2>
              <p class="card-sub">Regional and temporal settings</p>
            </div>
          </div>

          <div class="field-row two-col">
            <div class="field">
              <label class="flabel">Country</label>
              <div class="fval">{{ formatCountry(form.country) }}</div>
            </div>
            <div class="field">
              <label class="flabel">Timezone</label>
              <div class="fval">{{ form.timezone || '—' }}</div>
            </div>
          </div>
        </div>

        <!-- System & Status -->
        <div class="card">
           <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="m11.54 22.351.07.04.028.016a.76.76 0 0 0 .723 0l.028-.015.071-.041a16.975 16.975 0 0 0 1.144-.742 19.58 19.58 0 0 0 2.683-2.282c1.944-2.003 3.5-4.697 3.5-8.327a8 8 0 1 0-16 0c0 3.63 1.556 6.324 3.5 8.327a19.592 19.592 0 0 0 2.682 2.282 16.975 16.975 0 0 0 1.144.742ZM12 13.5a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">Account visibility</h2>
              <p class="card-sub">Creation and maintenance history</p>
            </div>
          </div>
          <div class="fields">
             <div class="field-row two-col">
               <div class="field">
                <label class="flabel">Publish date</label>
                <div class="fval">{{ formatDateTime(form.published_at) }}</div>
              </div>
               <div class="field">
                <label class="flabel">Registration date</label>
                <div class="fval">{{ formatDateTime(form.created_at) }}</div>
              </div>
            </div>
             <div class="field-row two-col">
               <div class="field">
                <label class="flabel">Last modified</label>
                <div class="fval">{{ formatDateTime(form.updated_at) }}</div>
              </div>
               <div class="field">
                <label class="flabel">Deletion status</label>
                <div class="fval" :class="{ 'text-danger': form.deleted_at }">
                  {{ form.deleted_at ? `Deleted on ${formatDateTime(form.deleted_at)}` : 'Not deleted' }}
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- SEO -->
        <div class="card">
          <div class="card-head">
            <div class="card-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" width="22" height="22" style="color:#00aaff">
                <path fill-rule="evenodd" d="M10.5 3.75a6.75 6.75 0 1 0 0 13.5 6.75 6.75 0 0 0 0-13.5ZM2.25 10.5a8.25 8.25 0 1 1 14.59 5.28l4.69 4.69a.75.75 0 1 1-1.06 1.06l-4.69-4.69A8.25 8.25 0 0 1 2.25 10.5Z" clip-rule="evenodd" />
              </svg>
            </div>
            <div>
              <h2 class="card-title">SEO information</h2>
              <p class="card-sub">Search visibility and snippets</p>
            </div>
          </div>

          <div class="fields">
            <div class="field">
              <label class="flabel">SEO title</label>
              <div class="fval">{{ form.seo_title || '—' }}</div>
            </div>
            <div class="field">
              <label class="flabel">SEO description</label>
              <div class="fval seo-desc">{{ form.seo_description || '—' }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Right: preview -->
      <div class="preview-col">
        <div class="preview-sticky">
          <p class="preview-label">User profile card</p>

          <!-- User card -->
          <div class="user-card-preview">
            <div class="ucp-avatar">
              <img :src="displayAvatar" alt="avatar" />
            </div>
            <div class="ucp-info">
              <span class="ucp-name">{{ form.name || 'Full name' }}</span>
              <span class="ucp-username">@{{ form.username || 'username' }}</span>
              <span class="ucp-email">{{ form.email || 'email@example.com' }}</span>
              <div class="ucp-tags">
                <span class="ucp-status" :class="form.status">{{ form.status || 'inactive' }}</span>
                <span v-if="form.country" class="ucp-country">{{ form.country }}</span>
              </div>
            </div>
          </div>

          <!-- Summary -->
          <div class="field-summary">
            <div class="fs-row">
              <span class="fs-key">ID</span>
              <span class="fs-val">#{{ form.id }}</span>
            </div>
            <div class="fs-row">
              <span class="fs-key">Status</span>
              <span class="fs-val" :style="{ color: statusColor }">{{ formatStatus(form.status) }}</span>
            </div>
            <div class="fs-row">
              <span class="fs-key">Gender</span>
              <span class="fs-val">{{ formatGender(form.gender) }}</span>
            </div>
            <div class="fs-row">
              <span class="fs-key">Country</span>
              <span class="fs-val">{{ formatCountry(form.country) }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, onMounted, ref, computed } from "vue";
import { useRoute } from "vue-router";
import { useUserStore, getFullImageUrl } from "@/modules/admin/stores/users/userStore";
import router from "@/modules/router";
import defaultAvatar from '@/assets/images/DefaultImg/avatarDefault.png';

const route = useRoute();
const userStore = useUserStore();
const loading = ref(true);

const form = reactive<any>({
    id: "",
    name: "",
    username: "",
    email: "",
    phone: "",
    date_of_birth: "",
    gender: "",
    bio: "",
    avatar_url: null,
    country: "",
    timezone: "",
    status: "",
    published_at: "",
    seo_title: "",
    seo_description: "",
    slug: "",
    play_count_last_24h: 0,
    play_count_last_7d: 0,
    play_count_last_30d: 0,
    trending_score: 0,
    created_at: "",
    updated_at: "",
    deleted_at: null
});

const loadUserData = async () => {
    try {
        loading.value = true;
        const id = Number(route.params.id);
        const res = await userStore.fetchShow(id);
        if (res && res.data) {
            Object.assign(form, res.data);
            if (!form.avatar_url && res.data.avatar) {
               form.avatar_url = res.data.avatar;
            }
        }
    } catch (err: any) {
        router.push({ name: 'admin.usermanager.all' });
    } finally {
        loading.value = false;
    }
};

const formatDate = (date: string) => {
    if (!date) return '—';
    return new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
};

const formatDateTime = (datetime: string) => {
    if (!datetime) return '—';
    return new Date(datetime).toLocaleString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
};

const formatGender = (gender: string) => {
    const map: Record<string, string> = {
        male: '♂️ Male',
        female: '♀️ Female',
        other: '⚧ Other',
        prefer_not_to_say: '🤫 Not said'
    };
    return map[gender] || gender || '—';
};

const formatCountry = (cc: string) => {
    const map: Record<string, string> = {
        US: '🇺🇸 United States',
        UK: '🇬🇧 United Kingdom',
        VN: '🇻🇳 Vietnam',
        JP: '🇯🇵 Japan',
        KR: '🇰🇷 South Korea',
        FR: '🇫🇷 France',
        DE: '🇩🇪 Germany'
    };
    return map[cc] || cc || '—';
};

const formatStatus = (s: string) => {
    const map: Record<string, string> = {
        active: 'Active',
        inactive: 'Inactive',
        suspended: 'Suspended',
        pending: 'Pending'
    };
    return map[s] || s || '—';
};

const statusColor = computed(() => {
  const map: Record<string, string> = {
    active: '#00c87a',
    inactive: 'rgba(255,255,255,0.4)',
    pending: '#fac800',
    suspended: '#e24b4a',
  }
  return map[form.status] || 'rgba(255,255,255,0.4)'
})

const displayAvatar = computed(() => {
    if (form.avatar_url) return getFullImageUrl(form.avatar_url);
    return defaultAvatar;
});

onMounted(loadUserData);
</script>

<style scoped>
/* ── Base ───────────────────────────────────────── */
.user-shell {
  min-height: 100vh;
  background: #080e14;
  font-family: 'DM Sans', 'Segoe UI', sans-serif;
  color: #e8edf2;
  position: relative;
}

.bg-grid {
  position: fixed; inset: 0;
  background-image:
    linear-gradient(rgba(0,160,255,0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0,160,255,0.03) 1px, transparent 1px);
  background-size: 40px 40px;
  pointer-events: none; z-index: 0;
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
  color: rgba(255,255,255,0.7); border-radius: 8px; font-size: 13px; cursor: pointer;
}

.edit-btn {
  display: flex; align-items: center; gap: 7px; padding: 8px 16px;
  background: #00aaff; color: #000; border: none; border-radius: 8px;
  font-size: 13px; font-weight: 600; cursor: pointer; transition: all 0.2s;
}
.edit-btn:hover { background: #33bbff; transform: translateY(-1px); box-shadow: 0 4px 12px rgba(0,170,255,0.3); }

.topbar-center { flex: 1; }
.topbar-label { font-size: 15px; font-weight: 600; color: rgba(255,255,255,0.5); }

/* ── Page layout ────────────────────────────────── */
.page-body {
  position: relative; z-index: 1; display: grid;
  grid-template-columns: 1fr 300px; gap: 24px;
  max-width: 1100px; margin: 0 auto; padding: 28px 24px 60px;
}

/* ── Cards ──────────────────────────────────────── */
.card {
  background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07);
  border-radius: 16px; padding: 24px; margin-bottom: 16px;
}

.card-head {
  display: flex; align-items: center; gap: 14px; margin-bottom: 22px;
  padding-bottom: 18px; border-bottom: 1px solid rgba(255,255,255,0.06);
}

.card-icon {
  width: 44px; height: 44px; border-radius: 12px; background: rgba(0,160,255,0.1);
  border: 1px solid rgba(0,160,255,0.2); display: flex; align-items: center; justify-content: center;
}

.card-title { font-size: 16px; font-weight: 600; color: #fff; margin: 0 0 3px; }
.card-sub { font-size: 13px; color: rgba(255,255,255,0.4); margin: 0; }

/* ── Fields ─────────────────────────────────────── */
.fields { display: flex; flex-direction: column; gap: 16px; }
.field { display: flex; flex-direction: column; gap: 6px; }
.field-row.two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.flabel { font-size: 12px; font-weight: 500; color: rgba(255,255,255,0.3); text-transform: uppercase; letter-spacing: 0.05em; }

.fval {
  background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.06);
  border-radius: 9px; padding: 10px 14px; color: #fff; font-size: 14px; min-height: 40px; display: flex; align-items: center;
}
.text-accent { color: #00aaff; font-weight: 600; }
.text-danger { color: #ff5555; }
.seo-desc { line-height: 1.5; align-items: flex-start; padding-top: 10px; padding-bottom: 10px; }

/* ── Profile layout ─────────────────────────────── */
.profile-layout { display: flex; gap: 24px; align-items: flex-start; }
.avatar-col { display: flex; flex-direction: column; align-items: center; }
.avatar-view { width: 120px; height: 120px; border-radius: 50%; overflow: hidden; border: 4px solid rgba(255,255,255,0.05); }
.shadowed { box-shadow: 0 8px 24px rgba(0,0,0,0.5); }
.avatar-img { width: 100%; height: 100%; object-fit: cover; }
.bio-box {
  background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.06);
  border-radius: 12px; padding: 16px; color: rgba(255,255,255,0.8); font-size: 14px; line-height: 1.6; min-height: 120px;
}

/* ── Stats Grid ─────────────────────────────── */
.stats-grid-modern { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; }
.stat-box {
  background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.06);
  border-radius: 12px; padding: 16px; display: flex; flex-direction: column; align-items: center; gap: 4px;
}
.stat-box.trending { border-color: rgba(0,170,255,0.3); background: rgba(0,160,255,0.05); }
.sb-label { font-size: 11px; color: rgba(255,255,255,0.3); text-transform: uppercase; }
.sb-val { font-size: 24px; font-weight: 700; color: #fff; }
.trending .sb-val { color: #00aaff; }

/* ── Preview panel ──────────────────────────────── */
.preview-col { position: relative; }
.preview-sticky { position: sticky; top: 80px; display: flex; flex-direction: column; gap: 12px; }
.preview-label { font-size: 11px; font-weight: 600; color: rgba(255,255,255,0.3); text-transform: uppercase; margin: 0; }

.user-card-preview {
  background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08);
  border-radius: 14px; padding: 20px; display: flex; align-items: center; gap: 16px;
}
.ucp-avatar { width: 56px; height: 56px; border-radius: 50%; overflow: hidden; background: rgba(0,160,255,0.15); }
.ucp-avatar img { width: 100%; height: 100%; object-fit: cover; }
.ucp-info { display: flex; flex-direction: column; gap: 3px; min-width: 0; }
.ucp-name { font-size: 15px; font-weight: 600; color: #fff; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.ucp-username { font-size: 12px; color: rgba(255,255,255,0.4); }
.ucp-email { font-size: 11px; color: rgba(255,255,255,0.3); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

.ucp-tags { display: flex; gap: 6px; flex-wrap: wrap; margin-top: 4px; }
.ucp-status { font-size: 10px; padding: 2px 8px; border-radius: 100px; text-transform: capitalize; }
.ucp-status.active { background: rgba(0,200,120,0.12); color: #00c87a; }
.ucp-status.inactive { background: rgba(255,255,255,0.06); color: rgba(255,255,255,0.5); }
.ucp-status.pending { background: rgba(250,200,0,0.1); color: #fac800; }
.ucp-status.suspended { background: rgba(226,75,74,0.12); color: #e24b4a; }
.ucp-country { font-size: 10px; padding: 2px 8px; border-radius: 100px; background: rgba(255,255,255,0.06); color: rgba(255,255,255,0.5); }

.field-summary { padding: 8px 16px; display: flex; flex-direction: column; gap: 8px; }
.fs-row { display: flex; justify-content: space-between; font-size: 12px; }
.fs-key { color: rgba(255,255,255,0.3); }
.fs-val { color: rgba(255,255,255,0.7); font-weight: 500; }

.loading-overlay { display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 400px; gap: 16px; }
.spinner-large { width: 40px; height: 40px; border: 3px solid rgba(255,255,255,0.05); border-top-color: #00aaff; border-radius: 50%; animation: spin 1s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

@media (max-width: 900px) {
  .page-body { grid-template-columns: 1fr; }
  .preview-col { display: none; }
  .stats-grid-modern { grid-template-columns: repeat(2, 1fr); }
}
</style>
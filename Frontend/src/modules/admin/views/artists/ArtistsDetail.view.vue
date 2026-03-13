<template>
    <div class="artist-detail-view">
        <!-- Header -->
        <div class="page-header">
            <div class="header-left">
                <h1 class="page-header-title">Artist Management</h1>
                <span class="header-badge">Detail</span>
            </div>
            <div class="header-actions">
                <button class="btn btn-secondary" @click="$router.back()">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="18" height="18">
                        <path fill-rule="evenodd" d="M7.793 2.232a.75.75 0 0 1-.025 1.06L3.622 7.25h10.003a5.375 5.375 0 0 1 0 10.75H10.75a.75.75 0 0 1 0-1.5h2.875a3.875 3.875 0 0 0 0-7.75H3.622l4.146 3.957a.75.75 0 0 1-1.036 1.085l-5.5-5.25a.75.75 0 0 1 0-1.085l5.5-5.25a.75.75 0 0 1 1.06.025Z" clip-rule="evenodd" />
                    </svg>
                    Back to Artists
                </button>
            </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="loading-state">
            <div class="spinner-large"></div>
            <p>Loading artist details...</p>
        </div>

        <!-- Error State -->
        <div v-else-if="error" class="error-state">
            <div class="error-icon">⚠️</div>
            <h3>Failed to load artist</h3>
            <p>{{ error }}</p>
            <button class="btn btn-primary" @click="">Retry</button>
        </div>

        <!-- Main Content -->
        <div v-else class="content-card">
            <div class="card-header">
                <div class="header-icon">🎤</div>
                <div class="header-text">
                    <h2>Artist Profile</h2>
                    <p class="subtitle">View artist details and information</p>
                </div>
                <div class="header-status" v-if="form">
                    <span :class="['status-badge', form.status]">
                        {{ getStatusText(form.status) }}
                    </span>
                    <span v-if="form.verified" class="verified-badge" title="Verified Artist">✓ Verified</span>
                    <span v-if="form.is_featured" class="featured-badge" title="Featured Artist">⭐ Featured</span>
                </div>
            </div>

            <!-- Artist Info Display -->
            <div v-if="form" class="artist-display">
                <!-- Media Section -->
                <div class="media-section">
                    <div class="media-grid">
                        <!-- Avatar -->
                        <div class="media-display avatar-display">
                            <div class="display-preview avatar-preview">
                                <img 
                                    :src="displayAvatar || defaultAvatar" 
                                    :alt="form.name"
                                    class="preview-img"
                                />
                            </div>
                        </div>

                        <!-- Banner -->
                        <div class="media-display banner-display">
                            <div class="display-preview banner-preview">
                                <img 
                                    :src="displayBanner || defaultBanner"
                                    :alt="form.name + ' banner'"
                                    class="preview-img"
                                />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Basic Information -->
                <div class="info-section">
                    <h3 class="section-title">
                        <span class="section-icon">📋</span>
                        Basic Information
                    </h3>
                    <div class="info-grid">
                        <div class="info-item">
                            <label>Artist Name</label>
                            <div class="info-value">{{ form.name }}</div>
                        </div>

                        <div class="info-item">
                            <label>Slug</label>
                            <div class="info-value slug-value">{{ form.slug }}</div>
                        </div>

                        <div class="info-item">
                            <label>Country</label>
                            <div class="info-value">
                                {{ form.country ? getCountryFlag(form.country) + ' ' + form.country : '—' }}
                            </div>
                        </div>

                        <div class="info-item">
                            <label>Website</label>
                            <div class="info-value">
                                <a v-if="form.website" :href="form.website" target="_blank" class="link-value">
                                    {{ form.website }}
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
                                        <path fill-rule="evenodd" d="M4.25 5.5a.75.75 0 00-.75.75v8.5c0 .414.336.75.75.75h8.5a.75.75 0 00.75-.75v-4a.75.75 0 011.5 0v4A2.25 2.25 0 0112.75 17h-8.5A2.25 2.25 0 012 14.75v-8.5A2.25 2.25 0 014.25 4h5a.75.75 0 010 1.5h-5z" />
                                        <path fill-rule="evenodd" d="M6.194 12.753a.75.75 0 001.06.053L16.5 4.44v2.81a.75.75 0 001.5 0v-4.5a.75.75 0 00-.75-.75h-4.5a.75.75 0 000 1.5h2.553l-9.056 8.194a.75.75 0 00-.053 1.06z" />
                                    </svg>
                                </a>
                                <span v-else>—</span>
                            </div>
                        </div>

                        <div class="info-item full-width">
                            <label>Biography</label>
                            <div class="info-value bio-value">{{ form.bio || 'No biography provided' }}</div>
                        </div>
                    </div>
                </div>

                <!-- Social Links -->
                <div class="info-section">
                    <h3 class="section-title">
                        <span class="section-icon">🌐</span>
                        Social Links
                    </h3>
                    <div class="social-grid">
                        <div v-if="form.facebook_url" class="social-item facebook">
                            <svg viewBox="0 0 24 24" fill="#1877f2" width="20" height="20">
                                <path d="M24 12c0-6.627-5.373-12-12-12S0 5.373 0 12c0 5.99 4.388 10.954 10.125 11.854V15.47H7.078v-3.47h3.047V9.356c0-3.007 1.792-4.688 4.533-4.688 1.312 0 2.686.234 2.686.234v2.953H15.83c-1.49 0-1.955.925-1.955 1.874V12h3.328l-.532 3.469h-2.796v8.385C19.612 22.954 24 17.99 24 12z"/>
                            </svg>
                            <a :href="form.facebook_url" target="_blank" class="social-link">Facebook</a>
                        </div>
                        <div v-else class="social-item empty">
                            <span>No Facebook link</span>
                        </div>

                        <div v-if="form.instagram_url" class="social-item instagram">
                            <svg viewBox="0 0 24 24" fill="#e4405f" width="20" height="20">
                                <path d="M12 2.163c3.204 0 3.584.012 4.85.07 1.188.054 1.98.257 2.675.545.73.284 1.334.676 1.928 1.27.594.594.986 1.198 1.27 1.928.288.695.49 1.487.545 2.675.058 1.266.07 1.646.07 4.85s-.012 3.584-.07 4.85c-.054 1.188-.257 1.98-.545 2.675-.284.73-.676 1.334-1.27 1.928-.594.594-1.198.986-1.928 1.27-.695.288-1.487.49-2.675.545-1.266.058-1.646.07-4.85.07s-3.584-.012-4.85-.07c-1.188-.054-1.98-.257-2.675-.545-.73-.284-1.334-.676-1.928-1.27-.594-.594-.986-1.198-1.27-1.928-.288-.695-.49-1.487-.545-2.675-.058-1.266-.07-1.646-.07-4.85s.012-3.584.07-4.85c.054-1.188.257-1.98.545-2.675.284-.73.676-1.334 1.27-1.928.594-.594 1.198-.986 1.928-1.27.695-.288 1.487-.49 2.675-.545 1.266-.058 1.646-.07 4.85-.07zM12 0C8.741 0 8.332.014 7.052.072c-1.267.058-2.147.283-2.912.603-.79.33-1.466.78-2.124 1.437-.657.658-1.107 1.334-1.437 2.124-.32.765-.545 1.645-.603 2.912C.014 8.332 0 8.741 0 12s.014 3.668.072 4.948c.058 1.267.283 2.147.603 2.912.33.79.78 1.466 1.437 2.124.658.657 1.334 1.107 2.124 1.437.765.32 1.645.545 2.912.603C8.332 23.986 8.741 24 12 24s3.668-.014 4.948-.072c1.267-.058 2.147-.283 2.912-.603.79-.33 1.466-.78 2.124-1.437.657-.658 1.107-1.334 1.437-2.124.32-.765.545-1.645.603-2.912.058-1.28.072-1.689.072-4.948s-.014-3.668-.072-4.948c-.058-1.267-.283-2.147-.603-2.912-.33-.79-.78-1.466-1.437-2.124-.658-.657-1.334-1.107-2.124-1.437-.765-.32-1.645-.545-2.912-.603C15.668.014 15.259 0 12 0z"/>
                            </svg>
                            <a :href="form.instagram_url" target="_blank" class="social-link">Instagram</a>
                        </div>
                        <div v-else class="social-item empty">
                            <span>No Instagram link</span>
                        </div>

                        <div v-if="form.twitter_url" class="social-item twitter">
                            <svg viewBox="0 0 24 24" fill="#1da1f2" width="20" height="20">
                                <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
                            </svg>
                            <a :href="form.twitter_url" target="_blank" class="social-link">X (Twitter)</a>
                        </div>
                        <div v-else class="social-item empty">
                            <span>No Twitter link</span>
                        </div>

                        <div v-if="form.youtube_url" class="social-item youtube">
                            <svg viewBox="0 0 24 24" fill="#ff0000" width="20" height="20">
                                <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/>
                            </svg>
                            <a :href="form.youtube_url" target="_blank" class="social-link">YouTube</a>
                        </div>
                        <div v-else class="social-item empty">
                            <span>No YouTube link</span>
                        </div>
                    </div>
                </div>

                <!-- Status & Settings -->
                <div class="info-section">
                    <h3 class="section-title">
                        <span class="section-icon">⚙️</span>
                        Status & Settings
                    </h3>
                    <div class="settings-grid">
                        <div class="info-item">
                            <label>Account Status</label>
                            <div class="info-value">
                                <span :class="['status-badge', form.status]">
                                    {{ getStatusText(form.status) }}
                                </span>
                            </div>
                        </div>

                        <div class="info-item">
                            <label>Partner ID</label>
                            <div class="info-value">{{ form.partner_id || '—' }}</div>
                        </div>

                        <div class="info-item">
                            <label>Verified Artist</label>
                            <div class="info-value">
                                <span :class="['badge', form.verified ? 'badge-success' : 'badge-secondary']">
                                    {{ form.verified ? '✓ Verified' : '✗ Not Verified' }}
                                </span>
                            </div>
                        </div>

                        <div class="info-item">
                            <label>Featured Artist</label>
                            <div class="info-value">
                                <span :class="['badge', form.is_featured ? 'badge-featured' : 'badge-secondary']">
                                    {{ form.is_featured ? '⭐ Featured' : '○ Not Featured' }}
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- SEO Information -->
                <div class="info-section">
                    <h3 class="section-title">
                        <span class="section-icon">🔍</span>
                        SEO Information
                    </h3>
                    <div class="info-grid">
                        <div class="info-item">
                            <label>SEO Title</label>
                            <div class="info-value">{{ form.seo_title || '—' }}</div>
                        </div>

                        <div class="info-item">
                            <label>SEO Keywords</label>
                            <div class="info-value">{{ form.seo_keywords || '—' }}</div>
                        </div>

                        <div class="info-item full-width">
                            <label>SEO Description</label>
                            <div class="info-value">{{ form.seo_description || '—' }}</div>
                        </div>
                    </div>
                </div>

                <!-- Stats Preview (if available) -->
                <div v-if="form.stats" class="stats-preview">
                    <div class="stat-item">
                        <span class="stat-label">Songs</span>
                        <span class="stat-value">{{ form.stats.songs_count || 0 }}</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Albums</span>
                        <span class="stat-value">{{ form.stats.albums_count || 0 }}</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Followers</span>
                        <span class="stat-value">{{ formatNumber(form.stats.followers_count) || 0 }}</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-label">Monthly Listeners</span>
                        <span class="stat-value">{{ formatNumber(form.stats.monthly_listeners) || 0 }}</span>
                    </div>
                </div>

                <!-- Metadata -->
                <div class="metadata-section">
                    <div class="metadata-item">
                        <span class="metadata-label">Created at:</span>
                        <span class="metadata-value">{{ formatDate(form.created_at) }}</span>
                    </div>
                    <div class="metadata-item">
                        <span class="metadata-label">Last updated:</span>
                        <span class="metadata-value">{{ formatDate(form.updated_at) }}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted ,computed , reactive } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useArtistStore , getFullImageUrl} from '@/modules/admin/stores/artists/artistsStore'
import { useNotificationStore } from "@/store/notificationStore"

const form = reactive<any>({
    name: "",
    slug: "",
    bio: "",
    avatar: null,
    banner: null,
    country: "",
    website: "",
    facebook_url: "",
    instagram_url: "",
    twitter_url: "",
    youtube_url: "",
    verified: false,
    is_featured: false,
    partner_id: null,
    status: "active",
    seo_title: "",
    seo_description: "",
    seo_keywords: "",
});
const route = useRoute()
const router = useRouter()
const notificationStore = useNotificationStore()
const artistStore = useArtistStore()

const loading = ref(true)
const error = ref<string | null>(null)

const defaultAvatar = 'https://via.placeholder.com/500?text=Artist'
const defaultBanner = 'https://via.placeholder.com/1920x500?text=Banner'


// Methods
const getStatusText = (status: string): string => {
    const statusMap: Record<string, string> = {
        active: '🟢 Active',
        inactive: '⚪ Inactive',
        pending: '🟡 Pending',
        rejected: '🔴 Rejected'
    }
    return statusMap[status] || status
}

const getCountryFlag = (country: string): string => {
    const flagMap: Record<string, string> = {
        'USA': '🇺🇸',
        'UK': '🇬🇧',
        'Vietnam': '🇻🇳',
        'Japan': '🇯🇵',
        'Korea': '🇰🇷',
        'France': '🇫🇷',
        'Germany': '🇩🇪',
        'Canada': '🇨🇦',
        'Australia': '🇦🇺',
        'Other': '🌍'
    }
    return flagMap[country] || '🌍'
}

const formatNumber = (num?: number): string => {
    if (!num) return '0'
    if (num >= 1000000) {
        return (num / 1000000).toFixed(1) + 'M'
    }
    if (num >= 1000) {
        return (num / 1000).toFixed(1) + 'K'
    }
    return num.toString()
}

const formatDate = (dateString?: string): string => {
    if (!dateString) return '—'
    return new Date(dateString).toLocaleString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    })
}


const displayAvatar = computed(() => {
    if (form.avatar_url) {
        return getFullImageUrl(form.avatar_url);
    }
    return defaultAvatar;
});

const displayBanner = computed(()=>{
    if (form.banner_url) {
        return getFullImageUrl(form.banner_url);
    }
    return defaultBanner;
});

// Lifecycle
onMounted(async () => {
    try {
        loading.value = true;
        const id = Number(route.params.id);
        const res = await artistStore.fetchShow(id);
        if (res) {
            Object.assign(form, res);
        }
        
        // Assign new data
        Object.assign(form, res.data);

    } catch (error: any) {
        const err = error as { response?: { status?: number } };

        if (err.response?.status === 404) {
            router.push('/404');
        } else if (err.response?.status === 401) {
            router.push('/login');
        } else {
            console.error('Error loading artist:', error);
        }

    } finally {
        loading.value = false;
    }
});


</script>

<style scoped>
.artist-detail-view {
    padding: 24px;
    min-height: 100vh;
    background: linear-gradient(135deg, #0a1219 0%, #1a2a35 100%);
    font-family: 'Inter', sans-serif;
}

/* Header */
.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

.header-left {
    display: flex;
    align-items: center;
    gap: 12px;
}

.page-header-title {
    font-size: 28px;
    font-weight: 700;
    color: white;
    margin: 0;
    background: linear-gradient(135deg, #fff 0%, #00aaff 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

.header-badge {
    background: #1d455e;
    color: #00aaff;
    padding: 4px 12px;
    border-radius: 100px;
    font-size: 12px;
    font-weight: 600;
    border: 1px solid #00aaff;
}

.header-actions {
    display: flex;
    gap: 12px;
}

/* Loading & Error States */
.loading-state,
.error-state {
    background: rgba(255, 255, 255, 0.05);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(0, 170, 255, 0.2);
    border-radius: 24px;
    padding: 60px 32px;
    text-align: center;
    color: white;
}

.spinner-large {
    width: 48px;
    height: 48px;
    border: 4px solid rgba(255, 255, 255, 0.1);
    border-top-color: #00aaff;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin: 0 auto 16px;
}

.error-icon {
    font-size: 48px;
    margin-bottom: 16px;
}

.error-state h3 {
    font-size: 20px;
    margin-bottom: 8px;
}

.error-state p {
    color: rgba(255, 255, 255, 0.7);
    margin-bottom: 24px;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

/* Content Card */
.content-card {
    background: rgba(255, 255, 255, 0.05);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(0, 170, 255, 0.2);
    border-radius: 24px;
    padding: 32px;
    color: white;
}

.card-header {
    display: flex;
    align-items: center;
    gap: 16px;
    margin-bottom: 32px;
    padding-bottom: 24px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.header-icon {
    font-size: 48px;
    background: rgba(0, 170, 255, 0.1);
    width: 80px;
    height: 80px;
    border-radius: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 1px solid #00aaff;
}

.header-text {
    flex: 1;
}

.header-text h2 {
    font-size: 24px;
    font-weight: 600;
    margin: 0 0 8px 0;
    color: white;
}

.subtitle {
    color: rgba(255, 255, 255, 0.7);
    margin: 0;
    font-size: 14px;
}

.header-status {
    display: flex;
    gap: 8px;
    align-items: center;
}

/* Badges */
.status-badge {
    padding: 6px 12px;
    border-radius: 100px;
    font-size: 13px;
    font-weight: 500;
}

.status-badge.active {
    background: rgba(0, 255, 0, 0.1);
    color: #00ff00;
    border: 1px solid #00ff00;
}

.status-badge.inactive {
    background: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.7);
    border: 1px solid rgba(255, 255, 255, 0.3);
}

.status-badge.pending {
    background: rgba(255, 255, 0, 0.1);
    color: #ffff00;
    border: 1px solid #ffff00;
}

.status-badge.rejected {
    background: rgba(255, 0, 0, 0.1);
    color: #ff4444;
    border: 1px solid #ff4444;
}

.verified-badge {
    background: #00aaff;
    color: white;
    padding: 4px 10px;
    border-radius: 100px;
    font-size: 12px;
    font-weight: 600;
}

.featured-badge {
    background: #ffaa00;
    color: #0a1219;
    padding: 4px 10px;
    border-radius: 100px;
    font-size: 12px;
    font-weight: 600;
}

.badge {
    padding: 4px 10px;
    border-radius: 100px;
    font-size: 12px;
    font-weight: 500;
}

.badge-success {
    background: rgba(0, 255, 0, 0.1);
    color: #00ff00;
    border: 1px solid #00ff00;
}

.badge-featured {
    background: #ffaa00;
    color: #0a1219;
}

.badge-secondary {
    background: rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.7);
    border: 1px solid rgba(255, 255, 255, 0.3);
}

/* Info Sections */
.info-section {
    margin-bottom: 32px;
    padding: 24px;
    background: rgba(0, 0, 0, 0.2);
    border-radius: 16px;
    border: 1px solid rgba(255, 255, 255, 0.05);
}

.section-title {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 18px;
    font-weight: 600;
    color: white;
    margin-bottom: 24px;
}

.section-icon {
    font-size: 20px;
}

/* Media Section */
.media-section {
    margin-bottom: 32px;
}

.media-grid {
    display: grid;
    grid-template-columns: 1fr 2fr;
    gap: 24px;
}

.media-display {
    display: flex;
    flex-direction: column;
}

.media-display label {
    font-size: 14px;
    font-weight: 500;
    color: rgba(255, 255, 255, 0.9);
    margin-bottom: 8px;
}

.display-preview {
    border-radius: 12px;
    overflow: hidden;
    border: 2px solid rgba(255, 255, 255, 0.2);
    background: rgba(0, 0, 0, 0.3);
}

.avatar-preview {
    width: 200px;
    height: 200px;
    border-radius: 50%;
}

.banner-preview {
    width: 100%;
    height: 200px;
    border-radius: 12px;
}

.preview-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

/* Info Grids */
.info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 20px;
}

.info-item {
    display: flex;
    flex-direction: column;
}

.info-item.full-width {
    grid-column: 1 / -1;
}

.info-item label {
    font-size: 13px;
    font-weight: 500;
    color: rgba(255, 255, 255, 0.6);
    margin-bottom: 6px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.info-value {
    font-size: 15px;
    color: white;
    line-height: 1.5;
    padding: 8px 12px;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 8px;
    border: 1px solid rgba(255, 255, 255, 0.1);
}

.slug-value {
    font-family: monospace;
    background: rgba(0, 170, 255, 0.1);
    color: #00aaff;
}

.bio-value {
    white-space: pre-wrap;
    line-height: 1.6;
}

.link-value {
    color: #00aaff;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    transition: all 0.2s;
}

.link-value:hover {
    color: #0088cc;
    text-decoration: underline;
}

/* Social Grid */
.social-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;
}

.social-item {
    padding: 12px 16px;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    display: flex;
    align-items: center;
    gap: 10px;
}

.social-item.facebook {
    border-left: 4px solid #1877f2;
}

.social-item.instagram {
    border-left: 4px solid #e4405f;
}

.social-item.twitter {
    border-left: 4px solid #1da1f2;
}

.social-item.youtube {
    border-left: 4px solid #ff0000;
}

.social-item.empty {
    border-left: 4px solid rgba(255, 255, 255, 0.3);
    color: rgba(255, 255, 255, 0.5);
}

.social-link {
    color: white;
    text-decoration: none;
    flex: 1;
}

.social-link:hover {
    color: #00aaff;
}

/* Settings Grid */
.settings-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;
}

/* Stats Preview */
.stats-preview {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 16px;
    margin-top: 32px;
    padding: 20px;
    background: rgba(0, 0, 0, 0.3);
    border-radius: 16px;
    border: 1px solid rgba(0, 170, 255, 0.2);
}

.stat-item {
    text-align: center;
    padding: 16px;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 12px;
}

.stat-label {
    display: block;
    font-size: 13px;
    color: rgba(255, 255, 255, 0.6);
    margin-bottom: 8px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.stat-value {
    font-size: 24px;
    font-weight: 700;
    color: #00aaff;
}

/* Metadata */
.metadata-section {
    margin-top: 24px;
    padding-top: 20px;
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    display: flex;
    gap: 24px;
    font-size: 13px;
    color: rgba(255, 255, 255, 0.5);
}

.metadata-label {
    margin-right: 4px;
}

.metadata-value {
    color: rgba(255, 255, 255, 0.8);
}

/* Buttons */
.btn {
    padding: 12px 24px;
    border-radius: 100px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    border: none;
    transition: all 0.2s;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

.btn-primary {
    background: linear-gradient(135deg, #00aaff, #0088cc);
    color: white;
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(0, 170, 255, 0.4);
}

.btn-secondary {
    background: rgba(255, 255, 255, 0.1);
    color: white;
    border: 1px solid rgba(255, 255, 255, 0.2);
}

.btn-secondary:hover {
    background: rgba(255, 255, 255, 0.15);
}

/* Responsive */
@media (max-width: 768px) {
    .artist-detail-view {
        padding: 16px;
    }
    
    .page-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 16px;
    }
    
    .header-actions {
        width: 100%;
    }
    
    .btn {
        flex: 1;
        justify-content: center;
    }
    
    .card-header {
        flex-direction: column;
        text-align: center;
    }
    
    .header-status {
        flex-wrap: wrap;
        justify-content: center;
    }
    
    .media-grid {
        grid-template-columns: 1fr;
        justify-items: center;
    }
    
    .avatar-preview {
        width: 150px;
        height: 150px;
    }
    
    .social-grid,
    .settings-grid {
        grid-template-columns: 1fr;
    }
    
    .stats-preview {
        grid-template-columns: repeat(2, 1fr);
    }
    
    .metadata-section {
        flex-direction: column;
        gap: 8px;
    }
}
</style>
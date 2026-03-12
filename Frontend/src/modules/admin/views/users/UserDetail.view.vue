<template>
    <div class="user-detail-view">
        <!-- Header -->
        <div class="page-header">
            <div class="header-left">
                <h1 class="page-header-title">User Details</h1>
                <span class="header-badge">Profile</span>
            </div>
            <div class="header-actions">
                <button class="btn btn-secondary" @click="$router.back()">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="18" height="18">
                        <path fill-rule="evenodd" d="M7.793 2.232a.75.75 0 0 1-.025 1.06L3.622 7.25h10.003a5.375 5.375 0 0 1 0 10.75H10.75a.75.75 0 0 1 0-1.5h2.875a3.875 3.875 0 0 0 0-7.75H3.622l4.146 3.957a.75.75 0 0 1-1.036 1.085l-5.5-5.25a.75.75 0 0 1 0-1.085l5.5-5.25a.75.75 0 0 1 1.06.025Z" clip-rule="evenodd" />
                    </svg>
                    Back to Users
                </button>
            </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading" class="loading-state">
            <div class="spinner-large"></div>
            <p>Loading user data...</p>
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
                <div class="header-icon">👤</div>
                <div class="header-text">
                    <h2>User Profile: {{ form.username || 'N/A' }}</h2>
                    <p class="subtitle">View user information and details</p>
                </div>
            </div>

            <!-- User Information Display -->
            <div class="user-detail-container">
                <!-- Avatar and Basic Info Row -->
                <div class="profile-summary">
                    <div class="avatar-large">
                        <img :src="displayAvatar" alt="User avatar" class="avatar-large-img" />
                    </div>
                    <div class="summary-info">
                        <h3>{{ form.name || 'N/A' }}</h3>
                        <p>@{{ form.username || 'N/A' }}</p>
                        <span :class="['status-badge', `status-${form.status}`]">
                            {{ formatStatus(form.status) }}
                        </span>
                    </div>
                </div>

                <!-- Basic Information Section -->
                <div class="detail-section">
                    <h3 class="section-title">
                        <span class="section-icon">📋</span>
                        Basic Information
                    </h3>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <span class="detail-label">Full Name</span>
                            <span class="detail-value">{{ form.name || 'N/A' }}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Username</span>
                            <span class="detail-value">{{ form.username || 'N/A' }}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Email Address</span>
                            <span class="detail-value">{{ form.email || 'N/A' }}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Phone Number</span>
                            <span class="detail-value">{{ form.phone || 'N/A' }}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Date of Birth</span>
                            <span class="detail-value">{{ formatDate(form.date_of_birth) }}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Gender</span>
                            <span class="detail-value">{{ formatGender(form.gender) }}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">User ID</span>
                            <span class="detail-value">{{ form.id || 'N/A' }}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Slug</span>
                            <span class="detail-value">{{ form.slug || 'N/A' }}</span>
                        </div>
                    </div>
                </div>

                <!-- Profile Details Section -->
                <div class="detail-section">
                    <h3 class="section-title">
                        <span class="section-icon">📝</span>
                        Profile Details
                    </h3>
                    <div class="detail-grid">
                        <div class="detail-item full-width">
                            <span class="detail-label">Bio</span>
                            <div class="bio-text">{{ form.bio || 'No bio available' }}</div>
                        </div>
                    </div>
                </div>

                <!-- Location & Preferences -->
                <div class="detail-section">
                    <h3 class="section-title">
                        <span class="section-icon">📍</span>
                        Location & Preferences
                    </h3>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <span class="detail-label">Country</span>
                            <span class="detail-value">{{ formatCountry(form.country) }}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Timezone</span>
                            <span class="detail-value">{{ form.timezone || 'N/A' }}</span>
                        </div>
                    </div>
                </div>

                <!-- Play Statistics -->
                <div class="detail-section">
                    <h3 class="section-title">
                        <span class="section-icon">📊</span>
                        Play Statistics
                    </h3>
                    <div class="stats-grid">
                        <div class="stat-card">
                            <span class="stat-label">Last 24 Hours</span>
                            <span class="stat-value">{{ form.play_count_last_24h || 0 }}</span>
                        </div>
                        <div class="stat-card">
                            <span class="stat-label">Last 7 Days</span>
                            <span class="stat-value">{{ form.play_count_last_7d || 0 }}</span>
                        </div>
                        <div class="stat-card">
                            <span class="stat-label">Last 30 Days</span>
                            <span class="stat-value">{{ form.play_count_last_30d || 0 }}</span>
                        </div>
                        <div class="stat-card">
                            <span class="stat-label">Trending Score</span>
                            <span class="stat-value">{{ form.trending_score || 0 }}</span>
                        </div>
                    </div>
                </div>

                <!-- Status & Settings -->
                <div class="detail-section">
                    <h3 class="section-title">
                        <span class="section-icon">⚙️</span>
                        Account Status
                    </h3>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <span class="detail-label">Account Status</span>
                            <span class="detail-value">
                                <span :class="['status-badge', `status-${form.status}`]">
                                    {{ formatStatus(form.status) }}
                                </span>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Publish Date</span>
                            <span class="detail-value">{{ formatDateTime(form.published_at) }}</span>
                        </div>
                    </div>
                </div>

                <!-- SEO Information -->
                <div class="detail-section">
                    <h3 class="section-title">
                        <span class="section-icon">🔍</span>
                        SEO Information
                    </h3>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <span class="detail-label">SEO Title</span>
                            <span class="detail-value">{{ form.seo_title || 'N/A' }}</span>
                        </div>
                        <div class="detail-item full-width">
                            <span class="detail-label">SEO Description</span>
                            <span class="detail-value">{{ form.seo_description || 'N/A' }}</span>
                        </div>
                    </div>
                </div>

                <!-- System Information -->
                <div class="detail-section">
                    <h3 class="section-title">
                        <span class="section-icon">🕒</span>
                        System Information
                    </h3>
                    <div class="detail-grid">
                        <div class="detail-item">
                            <span class="detail-label">Created At</span>
                            <span class="detail-value">{{ formatDateTime(form.created_at) }}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Last Updated</span>
                            <span class="detail-value">{{ formatDateTime(form.updated_at) }}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Deleted At</span>
                            <span class="detail-value">
                                <span v-if="form.deleted_at" class="text-danger">{{ formatDateTime(form.deleted_at) }}</span>
                                <span v-else class="text-success">Not deleted</span>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="detail-actions">
                    <button type="button" class="btn btn-secondary" @click="$router.back()">
                        Cancel
                    </button>
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
const error = ref<string | null>(null)

const route = useRoute();
const userStore = useUserStore();

const loading = ref(false);

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

const formatDate = (date: string) => {
    if (!date) return 'N/A';
    try {
        return new Date(date).toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    } catch {
        return 'Invalid date';
    }
};

const formatDateTime = (datetime: string) => {
    if (!datetime) return 'N/A';
    try {
        return new Date(datetime).toLocaleString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    } catch {
        return 'Invalid date';
    }
};

const formatGender = (gender: string) => {
    const genders: Record<string, string> = {
        male: '♂️ Male',
        female: '♀️ Female',
        other: '⚧ Other',
        prefer_not_to_say: '🤫 Prefer not to say'
    };
    return genders[gender] || gender || 'N/A';
};

const formatCountry = (countryCode: string) => {
    const countries: Record<string, string> = {
        US: '🇺🇸 United States',
        UK: '🇬🇧 United Kingdom',
        VN: '🇻🇳 Vietnam',
        JP: '🇯🇵 Japan',
        KR: '🇰🇷 South Korea',
        FR: '🇫🇷 France',
        DE: '🇩🇪 Germany'
    };
    return countries[countryCode] || countryCode || 'N/A';
};

const formatStatus = (status: string) => {
    const statusMap: Record<string, string> = {
        active: 'Active',
        inactive: 'Inactive',
        suspended: 'Suspended',
        pending: 'Pending'
    };
    return statusMap[status] || status || 'N/A';
};

const displayAvatar = computed(() => {
    if (form.avatar_url) {
        return getFullImageUrl(form.avatar_url);
    }
    return defaultAvatar;
});



onMounted(async () => {
    try {
        loading.value = true;
        const id = Number(route.params.id);
        
        const res = await userStore.fetchShow(id);
        
        if (res && res.data) {
            // Clear form first
            Object.keys(form).forEach(key => {
                delete form[key];
            });
            
            // Assign new data
            Object.assign(form, res.data);
        }
    } catch (error: any) {
        const err = error as { response?: { status?: number } };
        
        if (err.response?.status === 404) {
            router.push('/404');
        } else if (err.response?.status === 401) {
            router.push('/login');
        } else {
            console.error('Error loading user:', error);
        }
    } finally {
        loading.value = false;
    }
});
</script>

<style scoped>
.user-detail-view {
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
    max-height: 80vh;
    overflow-y: auto;
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

/* Profile Summary */
.profile-summary {
    display: flex;
    align-items: center;
    gap: 24px;
    padding: 24px;
    background: rgba(0, 0, 0, 0.2);
    border-radius: 16px;
    margin-bottom: 32px;
    border: 1px solid rgba(255, 255, 255, 0.05);
}

.avatar-large {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    overflow: hidden;
    border: 3px solid #00aaff;
}

.avatar-large-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.summary-info h3 {
    font-size: 24px;
    font-weight: 600;
    margin: 0 0 4px 0;
    color: white;
}

.summary-info p {
    color: #00aaff;
    margin: 0 0 12px 0;
    font-size: 14px;
}

/* Detail Sections */
.detail-section {
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

.detail-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 16px;
}

.detail-item {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.detail-item.full-width {
    grid-column: 1 / -1;
}

.detail-label {
    font-size: 12px;
    color: rgba(255, 255, 255, 0.5);
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.detail-value {
    font-size: 14px;
    color: white;
    padding: 8px 12px;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 8px;
    border: 1px solid rgba(255, 255, 255, 0.1);
}

.bio-text {
    white-space: pre-wrap;
    line-height: 1.6;
    min-height: 60px;
}

/* Stats Grid */
.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 16px;
}

.stat-card {
    background: rgba(0, 170, 255, 0.1);
    border: 1px solid rgba(0, 170, 255, 0.2);
    border-radius: 12px;
    padding: 16px;
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
}

.stat-label {
    font-size: 12px;
    color: rgba(255, 255, 255, 0.7);
    margin-bottom: 8px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.stat-value {
    font-size: 28px;
    font-weight: 700;
    color: #00aaff;
}

/* Status Badge */
.status-badge {
    display: inline-block;
    padding: 4px 12px;
    border-radius: 100px;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.status-active {
    background: rgba(0, 255, 0, 0.1);
    color: #00ff00;
    border: 1px solid #00ff00;
}

.status-inactive {
    background: rgba(255, 255, 255, 0.1);
    color: #ffffff;
    border: 1px solid rgba(255, 255, 255, 0.3);
}

.status-suspended {
    background: rgba(255, 0, 0, 0.1);
    color: #ff4444;
    border: 1px solid #ff4444;
}

.status-pending {
    background: rgba(255, 255, 0, 0.1);
    color: #ffff00;
    border: 1px solid #ffff00;
}

/* Action Buttons */
.detail-actions {
    display: flex;
    justify-content: flex-end;
    gap: 16px;
    margin-top: 32px;
    padding-top: 24px;
    border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.btn {
    padding: 12px 24px;
    border-radius: 100px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    border: none;
    transition: all 0.2s;
    display: flex;
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

.text-success {
    color: #00ff00;
}

.text-danger {
    color: #ff4444;
}

/* Scrollbar */
.content-card::-webkit-scrollbar {
    width: 6px;
}

.content-card::-webkit-scrollbar-thumb {
    background: rgba(0, 170, 255, 0.6);
    border-radius: 3px;
}

.content-card::-webkit-scrollbar-track {
    background: transparent;
}

/* Responsive */
@media (max-width: 768px) {
    .user-detail-view {
        padding: 16px;
    }
    
    .profile-summary {
        flex-direction: column;
        text-align: center;
    }
    
    .stats-grid {
        grid-template-columns: 1fr;
    }
    
    .detail-grid {
        grid-template-columns: 1fr;
    }
    
    .card-header {
        flex-direction: column;
        text-align: center;
    }
    
    .detail-actions {
        flex-direction: column;
    }
    
    .btn {
        width: 100%;
        justify-content: center;
    }
}
</style>
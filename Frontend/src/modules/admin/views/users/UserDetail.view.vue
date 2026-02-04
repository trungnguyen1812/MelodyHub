<template>
    <div class="user-detail-view">
        <!-- Header -->
        <div class="page-header">
            <h1 class="page-header-title" style="color: white;">User Details</h1>
            <div class="header-actions">
                <button class="btn btn-secondary" @click="$router.back()">
                    ← Back to Users
                </button>
            </div>
        </div>

        <!-- Main Content -->
        <div class="content-card">
            <div class="card-header">
                <h2>User Profile</h2>
                <p class="subtitle">View user information and details</p>
            </div>

            <!-- Loading State -->
            <div v-if="loading" class="loading-overlay">
                <div class="spinner"></div>
                <span>Loading user data...</span>
            </div>

            <!-- User Information Display -->
            <div v-else class="user-detail-container">
                <!-- Basic Information Section -->
                <div class="detail-section">
                    <h3 class="section-title">Basic Information</h3>
                    <div class="detail-grid">
                        <div class="detail-group">
                            <label>Full Name</label>
                            <div class="detail-value">{{ form.name || 'N/A' }}</div>
                        </div>
                        <div class="detail-group">
                            <label>Username</label>
                            <div class="detail-value">{{ form.username || 'N/A' }}</div>
                        </div>
                        <div class="detail-group">
                            <label>Email Address</label>
                            <div class="detail-value">{{ form.email || 'N/A' }}</div>
                        </div>
                        <div class="detail-group">
                            <label>Phone Number</label>
                            <div class="detail-value">{{ form.phone || 'N/A' }}</div>
                        </div>
                        <div class="detail-group">
                            <label>Date of Birth</label>
                            <div class="detail-value">{{ formatDate(form.date_of_birth) }}</div>
                        </div>
                        <div class="detail-group">
                            <label>Gender</label>
                            <div class="detail-value">{{ formatGender(form.gender) }}</div>
                        </div>
                        <div class="detail-group">
                            <label>User ID</label>
                            <div class="detail-value">{{ form.id || 'N/A' }}</div>
                        </div>
                        <div class="detail-group">
                            <label>Slug</label>
                            <div class="detail-value">{{ form.slug || 'N/A' }}</div>
                        </div>
                    </div>
                </div>

                <!-- Profile Details Section -->
                <div class="detail-section">
                    <h3 class="section-title">Profile Details</h3>
                    <div class="detail-grid">
                        <div class="detail-group">
                            <label>Bio</label>
                            <div class="detail-value bio-text">{{ form.bio || 'No bio available' }}</div>
                        </div>
                        
                        <div class="detail-group avatar-display">
                            <label>Avatar</label>
                            <div class="avatar-container">
                                <img :src="displayAvatar" alt="Avatar preview" class="avatar-img" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Location & Preferences -->
                <div class="detail-section">
                    <h3 class="section-title">Location & Preferences</h3>
                    <div class="detail-grid">
                        <div class="detail-group">
                            <label>Country</label>
                            <div class="detail-value">{{ formatCountry(form.country) }}</div>
                        </div>
                        <div class="detail-group">
                            <label>Timezone</label>
                            <div class="detail-value">{{ form.timezone || 'N/A' }}</div>
                        </div>
                    </div>
                </div>

                <!-- Play Statistics -->
                <div class="detail-section">
                    <h3 class="section-title">Play Statistics</h3>
                    <div class="detail-grid">
                        <div class="detail-group">
                            <label>Last 24 Hours</label>
                            <div class="detail-value">{{ form.play_count_last_24h || 0 }} plays</div>
                        </div>
                        <div class="detail-group">
                            <label>Last 7 Days</label>
                            <div class="detail-value">{{ form.play_count_last_7d || 0 }} plays</div>
                        </div>
                        <div class="detail-group">
                            <label>Last 30 Days</label>
                            <div class="detail-value">{{ form.play_count_last_30d || 0 }} plays</div>
                        </div>
                        <div class="detail-group">
                            <label>Trending Score</label>
                            <div class="detail-value">{{ form.trending_score || 0 }}</div>
                        </div>
                    </div>
                </div>

                <!-- Status & Settings -->
                <div class="detail-section">
                    <h3 class="section-title">Account Status</h3>
                    <div class="detail-grid">
                        <div class="detail-group">
                            <label>Account Status</label>
                            <div class="detail-value">
                                <span :class="['status-badge', `status-${form.status}`]">
                                    {{ formatStatus(form.status) }}
                                </span>
                            </div>
                        </div>
                        <div class="detail-group">
                            <label>Publish Date</label>
                            <div class="detail-value">{{ formatDateTime(form.published_at) }}</div>
                        </div>
                    </div>
                </div>

                <!-- SEO Information -->
                <div class="detail-section">
                    <h3 class="section-title">SEO Information</h3>
                    <div class="detail-grid">
                        <div class="detail-group">
                            <label>SEO Title</label>
                            <div class="detail-value">{{ form.seo_title || 'N/A' }}</div>
                        </div>
                        <div class="detail-group">
                            <label>SEO Description</label>
                            <div class="detail-value">{{ form.seo_description || 'N/A' }}</div>
                        </div>
                    </div>
                </div>

                <!-- System Information -->
                <div class="detail-section">
                    <h3 class="section-title">System Information</h3>
                    <div class="detail-grid">
                        <div class="detail-group">
                            <label>Created At</label>
                            <div class="detail-value">{{ formatDateTime(form.created_at) }}</div>
                        </div>
                        <div class="detail-group">
                            <label>Last Updated</label>
                            <div class="detail-value">{{ formatDateTime(form.updated_at) }}</div>
                        </div>
                        <div class="detail-group">
                            <label>Deleted At</label>
                            <div class="detail-value">{{ form.deleted_at ? formatDateTime(form.deleted_at) : 'Not deleted' }}</div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="detail-actions">
                    <button type="button" class="btn btn-secondary" @click="$router.back()">
                        Back
                    </button>
                    <button type="button" class="btn btn-primary" @click="editUser">
                        Edit User
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { reactive, onMounted, ref,computed } from "vue";
import { useRoute } from "vue-router";
import { useUserStore , getFullImageUrl } from "@/modules/admin/stores/users/userStore";
import router from "@/modules/router";
import defaultAvatar from '@/assets/images/DefaultImg/avatarDefault.png';

const route = useRoute();
const userStore = useUserStore();

const avatarFile = ref<File | null>(null);

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
    if (!date) return 'N/A'
    try {
        return new Date(date).toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        })
    } catch {
        return 'Invalid date'
    }
}

const formatDateTime = (datetime: string) => {
    if (!datetime) return 'N/A'
    try {
        return new Date(datetime).toLocaleString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        })
    } catch {
        return 'Invalid date'
    }
}

const formatGender = (gender: string) => {
    const genders: Record<string, string> = {
        male: 'Male',
        female: 'Female',
        other: 'Other',
        prefer_not_to_say: 'Prefer not to say'
    }
    return genders[gender] || gender || 'N/A'
}

const formatCountry = (countryCode: string) => {
    const countries: Record<string, string> = {
        US: 'United States',
        UK: 'United Kingdom',
        VN: 'Vietnam'
    }
    return countries[countryCode] || countryCode || 'N/A'
}

const formatStatus = (status: string) => {
    const statusMap: Record<string, string> = {
        active: 'Active',
        inactive: 'Inactive',
        suspended: 'Suspended',
        pending: 'Pending'
    }
    return statusMap[status] || status || 'N/A'
}

const displayAvatar = computed(() => {
    if (avatarFile.value) {
        return URL.createObjectURL(avatarFile.value);
    }
    
    if (form.avatar_url) {
        return getFullImageUrl(form.avatar_url);
    }
    
    return defaultAvatar;
});

const editUser = () => {
    router.push(`/users/edit/${route.params.id}`)
}

onMounted(async () => {
    try {
        loading.value = true;
        const id = Number(route.params.id);
        
        const res = await userStore.fetchShow(id);
        
        if (res && res.data) {
            
            Object.keys(form).forEach(key => {
                delete form[key];
            });
            
            Object.keys(res.data).forEach(key => {
                form[key] = res.data[key];
            });
            
        }
    } catch (error: any) {
        const err = error as { response?: { status?: number } }
        
        if (err.response?.status === 404) {
            router.push('/404')
        } else if (err.response?.status === 401) {
            router.push('/login')
        } else {
            console.error('Error loading user:', error)
        }
    } finally {
        loading.value = false;
    }
});
</script>

<style scoped>
.user-detail-view {
    padding: 20px;
    margin-top: 10px;
    height: 82vh;
    color: #000000;
    border-radius: 14px;
    background: rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
}

.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

.page-header-title {
    font-size: 24px;
    font-weight: 600;
    color: #1a1a1a;
    margin: 0;
}

.content-card {
    height: 68vh;
    overflow-y: auto;
    background: white;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    padding: 24px;
    padding-bottom: 10px;
    position: relative;
}

.card-header {
    margin-bottom: 32px;
}

.card-header h2 {
    font-size: 20px;
    font-weight: 600;
    color: #1a1a1a;
    margin-bottom: 8px;
}

.subtitle {
    color: #666;
    font-size: 14px;
    margin: 0;
}

.loading-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(255, 255, 255, 0.8);
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    z-index: 10;
}

.spinner {
    width: 40px;
    height: 40px;
    border: 4px solid #f3f3f3;
    border-top: 4px solid #4a90e2;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin-bottom: 16px;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

.detail-section {
    margin-bottom: 32px;
    padding-bottom: 24px;
    border-bottom: 1px solid #eaeaea;
}

.detail-section:last-child {
    border-bottom: none;
    margin-bottom: 0;
}

.section-title {
    font-size: 16px;
    font-weight: 600;
    color: #333;
    margin-bottom: 20px;
}

.detail-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
}

.detail-group {
    display: flex;
    flex-direction: column;
}

.detail-group label {
    font-size: 14px;
    font-weight: 500;
    color: #333;
    margin-bottom: 8px;
}

.detail-value {
    padding: 10px 12px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 14px;
    background: #f9f9f9;
    min-height: 40px;
    display: flex;
    align-items: center;
}

.bio-text {
    white-space: pre-wrap;
    line-height: 1.6;
    min-height: 60px;
}

.avatar-display {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.avatar-container {
    display: flex;
    justify-content: center;
}

.avatar-img {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    object-fit: cover;
    border: 4px solid #eee;
}

.status-badge {
    display: inline-block;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.status-active {
    background-color: #d1fae5;
    color: #065f46;
}

.status-inactive {
    background-color: #fee2e2;
    color: #991b1b;
}

.status-suspended {
    background-color: #fef3c7;
    color: #92400e;
}

.status-pending {
    background-color: #e0e7ff;
    color: #3730a3;
}

.detail-actions {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    padding-top: 24px;
    margin-top: 24px;
    border-top: 1px solid #eaeaea;
}

.btn {
    padding: 10px 24px;
    border-radius: 6px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    border: none;
    transition: all 0.3s;
}

.btn-primary {
    background: #4a90e2;
    color: white;
}

.btn-primary:hover {
    background: #3a80d2;
}

.btn-secondary {
    background: #f0f0f0;
    color: #333;
}

.btn-secondary:hover {
    background: #e0e0e0;
}

@media (max-width: 768px) {
    .detail-grid {
        grid-template-columns: 1fr;
    }
    
    .page-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 12px;
    }
}
</style>
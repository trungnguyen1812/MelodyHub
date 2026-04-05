<template>
    <div class="artist-add-view">
        <!-- Header -->
        <div class="page-header">
            <div class="header-left">
                <h1 class="page-header-title">Artist Management</h1>
                <span class="header-badge">Add New</span>
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
                <div class="header-icon">✏️</div>
                <div class="header-text">
                    <h2>Edit Artist: {{ form.name || 'Loading...' }}</h2>
                    <p class="subtitle">Update artist information and preferences</p>
                </div>
            </div>

            <form class="artist-form" @submit.prevent="handleSubmit">
                <!-- Basic Information -->
                <div class="form-section">
                    <h3 class="section-title">
                        <span class="section-icon">📋</span>
                        Basic Information
                    </h3>
                    <div class="form-grid">
                        <div class="form-group required">
                            <label for="name">Artist Name</label>
                            <input 
                                type="text" 
                                id="name" 
                                v-model="form.name"
                                placeholder="e.g. Taylor Swift, Ed Sheeran" 
                                required 
                               @input="autoSlug()"
                            />
                            <small class="helper-text">This will be the public display name</small>
                        </div>

                        <div class="form-group required">
                            <label for="slug">Slug</label>
                            <div class="slug-input-group">
                                <input 
                                    type="text" 
                                    id="slug" 
                                    v-model="form.slug"
                                    placeholder="artist-name" 
                                    required 
                                    disabled
                                />
                            </div>
                            <small class="helper-text">URL-friendly name (auto-generated)</small>
                        </div>

                        <div class="form-group">
                            <label for="country">Country</label>
                            <select id="country" v-model="form.country">
                                <option value="" class="form-group_option">Select country</option>
                                <option value="USA" class="form-group_option">🇺🇸 United States</option>
                                <option value="UK" class="form-group_option">🇬🇧 United Kingdom</option>
                                <option value="Vietnam" class="form-group_option">🇻🇳 Vietnam</option>
                                <option value="Japan" class="form-group_option">🇯🇵 Japan</option>
                                <option value="Korea" class="form-group_option">🇰🇷 South Korea</option>
                                <option value="France" class="form-group_option">🇫🇷 France</option>
                                <option value="Germany" class="form-group_option">🇩🇪 Germany</option>
                                <option value="Canada" class="form-group_option">🇨🇦 Canada</option>
                                <option value="Australia" class="form-group_option">🇦🇺 Australia</option>
                                <option value="Other" class="form-group_option">🌍 Other</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="website">Website</label>
                            <input 
                                type="url" 
                                id="website"
                                v-model="form.website"
                                placeholder="https://www.artist.com" 
                            />
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label for="bio">Biography</label>
                        <textarea 
                            id="bio" 
                            v-model="form.bio"
                            placeholder="Tell the story of the artist, their career highlights, musical style, etc..."
                            rows="4"
                        ></textarea>
                        <small class="helper-text">Max 1000 characters</small>
                    </div>
                </div>

                <!-- Media Section -->
                <div class="form-section">
                    <h3 class="section-title">
                        <span class="section-icon">🖼️</span>
                        Media
                    </h3>
                    <div class="media-grid">
                        <!-- Avatar -->
                        <div class="media-upload avatar-upload">
                            <label>Profile Avatar</label>
                            <div class="upload-preview avatar-preview" @click="avatarInput?.click()">
                                <img 
                                    :src="displayAvatar || defaultAvatar" 
                                    alt="Avatar" 
                                    class="preview-img"
                                />
                                <div class="upload-overlay">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="24" height="24">
                                        <path d="M5.433 13.917l1.262-3.155A4 4 0 017.58 9.42l6.92-6.918a2.121 2.121 0 013 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 01-.65-.65z" />
                                        <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0010 3H4.75A2.75 2.75 0 002 5.75v9.5A2.75 2.75 0 004.75 18h9.5A2.75 2.75 0 0017 15.25V10a.75.75 0 00-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5z" />
                                    </svg>
                                    <span>{{ avatarPreview ? 'Change' : 'Upload' }} Avatar</span>
                                </div>
                            </div>
                            <input 
                                type="file" 
                                ref="avatarInput" 
                                accept="image/jpeg,image/png,image/gif,image/webp"
                                @change="handleAvatarChange"
                                style="display: none" 
                            />
                            <small class="helper-text">JPG, PNG, GIF, WebP • Max 5MB • Square 500x500</small>
                        </div>

                        <!-- Banner -->
                        <div class="media-upload banner-upload">
                            <label>Banner Image</label>
                            <div class="upload-preview banner-preview" @click="bannerInput?.click()">
                                <img 
                                    :src="displayBanner || defaultBanner"
                                    alt="Banner" 
                                    class="preview-img"
                                />
                                <div class="upload-overlay">
                                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="24" height="24">
                                        <path d="M5.433 13.917l1.262-3.155A4 4 0 017.58 9.42l6.92-6.918a2.121 2.121 0 013 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 01-.65-.65z" />
                                        <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0010 3H4.75A2.75 2.75 0 002 5.75v9.5A2.75 2.75 0 004.75 18h9.5A2.75 2.75 0 0017 15.25V10a.75.75 0 00-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5z" />
                                    </svg>
                                    <span>{{ bannerPreview ? 'Change' : 'Upload' }} Banner</span>
                                </div>
                            </div>
                            <input 
                                type="file" 
                                ref="bannerInput" 
                                accept="image/jpeg,image/png,image/gif,image/webp"
                                @change="handleBannerChange"
                                style="display: none" 
                            />
                            <small class="helper-text">JPG, PNG, GIF, WebP • Max 10MB • 1920x500 recommended</small>
                        </div>
                    </div>
                </div>

                <!-- Social Links -->
                <div class="form-section">
                    <h3 class="section-title">
                        <span class="section-icon">🌐</span>
                        Social Links
                    </h3>
                    <div class="social-grid">
                        <div class="form-group social-input facebook">
                            <label>
                                <svg viewBox="0 0 24 24" fill="#1877f2" width="18" height="18">
                                    <path d="M24 12c0-6.627-5.373-12-12-12S0 5.373 0 12c0 5.99 4.388 10.954 10.125 11.854V15.47H7.078v-3.47h3.047V9.356c0-3.007 1.792-4.688 4.533-4.688 1.312 0 2.686.234 2.686.234v2.953H15.83c-1.49 0-1.955.925-1.955 1.874V12h3.328l-.532 3.469h-2.796v8.385C19.612 22.954 24 17.99 24 12z"/>
                                </svg>
                                Facebook
                            </label>
                            <input 
                                type="url" 
                                v-model="form.facebook_url"
                                placeholder="https://facebook.com/artist"
                            />
                        </div>

                        <div class="form-group social-input instagram">
                            <label>
                                <svg viewBox="0 0 24 24" fill="#e4405f" width="18" height="18">
                                    <path d="M12 2.163c3.204 0 3.584.012 4.85.07 1.188.054 1.98.257 2.675.545.73.284 1.334.676 1.928 1.27.594.594.986 1.198 1.27 1.928.288.695.49 1.487.545 2.675.058 1.266.07 1.646.07 4.85s-.012 3.584-.07 4.85c-.054 1.188-.257 1.98-.545 2.675-.284.73-.676 1.334-1.27 1.928-.594.594-1.198.986-1.928 1.27-.695.288-1.487.49-2.675.545-1.266.058-1.646.07-4.85.07s-3.584-.012-4.85-.07c-1.188-.054-1.98-.257-2.675-.545-.73-.284-1.334-.676-1.928-1.27-.594-.594-.986-1.198-1.27-1.928-.288-.695-.49-1.487-.545-2.675-.058-1.266-.07-1.646-.07-4.85s.012-3.584.07-4.85c.054-1.188.257-1.98.545-2.675.284-.73.676-1.334 1.27-1.928.594-.594 1.198-.986 1.928-1.27.695-.288 1.487-.49 2.675-.545 1.266-.058 1.646-.07 4.85-.07zM12 0C8.741 0 8.332.014 7.052.072c-1.267.058-2.147.283-2.912.603-.79.33-1.466.78-2.124 1.437-.657.658-1.107 1.334-1.437 2.124-.32.765-.545 1.645-.603 2.912C.014 8.332 0 8.741 0 12s.014 3.668.072 4.948c.058 1.267.283 2.147.603 2.912.33.79.78 1.466 1.437 2.124.658.657 1.334 1.107 2.124 1.437.765.32 1.645.545 2.912.603C8.332 23.986 8.741 24 12 24s3.668-.014 4.948-.072c1.267-.058 2.147-.283 2.912-.603.79-.33 1.466-.78 2.124-1.437.657-.658 1.107-1.334 1.437-2.124.32-.765.545-1.645.603-2.912.058-1.28.072-1.689.072-4.948s-.014-3.668-.072-4.948c-.058-1.267-.283-2.147-.603-2.912-.33-.79-.78-1.466-1.437-2.124-.658-.657-1.334-1.107-2.124-1.437-.765-.32-1.645-.545-2.912-.603C15.668.014 15.259 0 12 0z"/>
                                </svg>
                                Instagram
                            </label>
                            <input 
                                type="url" 
                                v-model="form.instagram_url"
                                placeholder="https://instagram.com/artist"
                            />
                        </div>

                        <div class="form-group social-input twitter">
                            <label>
                                <svg viewBox="0 0 24 24" fill="#1da1f2" width="18" height="18">
                                    <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
                                </svg>
                                X (Twitter)
                            </label>
                            <input 
                                type="url" 
                                v-model="form.twitter_url"
                                placeholder="https://twitter.com/artist"
                            />
                        </div>

                        <div class="form-group social-input youtube">
                            <label>
                                <svg viewBox="0 0 24 24" fill="#ff0000" width="18" height="18">
                                    <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z"/>
                                </svg>
                                YouTube
                            </label>
                            <input 
                                type="url" 
                                v-model="form.youtube_url"
                                placeholder="https://youtube.com/@artist"
                            />
                        </div>
                    </div>
                </div>

                <!-- Status & Settings -->
                <div class="form-section">
                    <h3 class="section-title">
                        <span class="section-icon">⚙️</span>
                        Status & Settings
                    </h3>
                    <div class="settings-grid">
                        <div class="form-group">
                            <label for="status">Account Status</label>
                            <select id="status" v-model="form.status">
                                <option value="active" class="form-group_option">🟢 Active</option>
                                <option value="inactive" class="form-group_option">⚪ Inactive</option>
                                <option value="pending" class="form-group_option">🟡 Pending</option>
                                <option value="rejected" class="form-group_option">🔴 Rejected</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="partner_id">Partner ID</label>
                            <input 
                                type="number" 
                                id="partner_id" 
                                v-model="form.partner_id"
                                placeholder="Enter partner ID"
                            />
                        </div>

                        <div class="checkbox-group">
                            <label class="checkbox-label">
                                <input type="checkbox"  v-model="form.verified"/>
                                <span class="checkbox-text">✓ Verified Artist</span>
                                <small class="helper-text">Mark as verified (blue checkmark)</small>
                            </label>
                        </div>

                        <div class="checkbox-group">
                            <label class="checkbox-label">
                                <input type="checkbox" v-model="form.is_featured"/>
                                <span class="checkbox-text">⭐ Featured Artist</span>
                                <small class="helper-text">Show on homepage and featured sections</small>
                            </label>
                        </div>
                    </div>
                </div>

                <!-- SEO Section -->
                <div class="form-section">
                    <h3 class="section-title">
                        <span class="section-icon">🔍</span>
                        SEO Information
                    </h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="seo_title">SEO Title</label>
                            <input 
                                type="text" 
                                id="seo_title" 
                                v-model="form.seo_title"
                                placeholder="Artist Name | Music Platform" 
                            />
                            <small class="helper-text">Title for search engines (50-60 chars)</small>
                        </div>

                        <div class="form-group">
                            <label for="seo_keywords">SEO Keywords</label>
                            <input 
                                type="text" 
                                id="seo_keywords" 
                                v-model="form.seo_keywords"
                                placeholder="artist, music, songs, genre" 
                            />
                            <small class="helper-text">Comma-separated keywords</small>
                        </div>

                        <div class="form-group full-width">
                            <label for="seo_description">SEO Description</label>
                            <textarea 
                                id="seo_description" 
                                v-model="form.seo_description"
                                placeholder="Brief description for search engines (150-160 chars)"
                                rows="2"
                            ></textarea>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" @click="$router.back()">
                        Cancel
                    </button>
                    <button type="submit" class="btn btn-primary" :disabled="submitting">
                        <span v-if="submitting" class="spinner-small"></span>
                        <span v-else>💾 Save Changes</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</template>

<script setup lang="ts">
import { reactive, ref ,watch , onMounted ,computed} from 'vue'
import router from "@/modules/router";
import { useRoute } from "vue-router";
import type { CreateArtistPayload } from "@/modules/client/interfaces/artists/create-artist.payload";
import { useArtistStore , getFullImageUrl } from '@/modules/client/stores/artists/artistsStore';
import { useNotificationStore } from "@/store/notificationStore";

const notificationStore = useNotificationStore();
const artistStore = useArtistStore();
const loading = ref(false);

// Media refs
const avatarPreview = ref<string>('')
const bannerPreview = ref<string>('')
const avatarInput = ref<HTMLInputElement | null>(null)
const bannerInput = ref<HTMLInputElement | null>(null)
const avatarFile = ref<File | null>(null);
const bannerFile = ref<File | null>(null);
const defaultAvatar = 'https://via.placeholder.com/500?text=Artist'
const defaultBanner = 'https://via.placeholder.com/1920x500?text=Banner'
const errors = reactive<Record<string, string>>({});
const error = ref<string | null>(null);
const route = useRoute();
const submitting = ref(false);


// Form
const form = reactive<CreateArtistPayload>({
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

// Methods
// Load user data
const loadArtistData = async () => {
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

        const status = error?.response?.status;

        if (status === 404) {
            router.push('/404');
        } else if (status === 401) {
            router.push('/login');
        } else {
            console.error('Error loading artist:', error);
        }

    } finally {
        loading.value = false;
    }
};

const handleAvatarChange = (event: Event) => {
    const target = event.target as HTMLInputElement;
    const file = target.files?.[0];
    
    if (!file) return;
    
    // Validate file type
    if (!file.type.startsWith('image/')) {
        notificationStore.notify('Please select an image file!', 'error');
        target.value = '';
        return;
    }
    
    // Validate file size (max 10MB)
    if (file.size > 10 * 1024 * 1024) {
        notificationStore.notify('File too large! Maximum 10MB', 'error');
        target.value = '';
        return;
    }
    
    // Check image resolution
    const img = new Image();
    const objectUrl = URL.createObjectURL(file);
    
    img.onload = () => {
        URL.revokeObjectURL(objectUrl);
        avatarFile.value = file;
    };
    
    img.onerror = () => {
        URL.revokeObjectURL(objectUrl);
        notificationStore.notify('Cannot read image file!', 'error');
        target.value = '';
    };
    
    img.src = objectUrl;
};

const handleBannerChange = (event: Event) => {
    const target = event.target as HTMLInputElement;
    const file = target.files?.[0];
    
    if (!file) return;
    
    // Validate file type
    if (!file.type.startsWith('image/')) {
        notificationStore.notify('Please select an image file!', 'error');
        target.value = '';
        return;
    }
    
    // Validate file size (max 15MB for banner)
    if (file.size > 15 * 1024 * 1024) {
        notificationStore.notify('File too large! Maximum 15MB', 'error');
        target.value = '';
        return;
    }
    
    // Check image resolution
    const img = new Image();
    const objectUrl = URL.createObjectURL(file);
    
    img.onload = () => {
        URL.revokeObjectURL(objectUrl);
        bannerFile.value = file;
    };
    
    img.onerror = () => {
        URL.revokeObjectURL(objectUrl);
        notificationStore.notify('Cannot read image file!', 'error');
        target.value = '';
    };
    
    img.src = objectUrl;
};

const handleSubmit = async () => {
    try {
        submitting.value = true;
        error.value = null;
        
        Object.keys(errors).forEach(key => delete errors[key]);
        
        const payload: CreateArtistPayload = { ...form };
        
        if (avatarInput.value) {
            payload.avatar = avatarFile.value;
        }
        if (bannerFile.value) {
            payload.banner = bannerFile.value;
        }
        
        // Remove empty strings
        Object.keys(payload).forEach(key => {
            if (key !== 'password' && key !== 'avatar' && key !== 'banner' && payload[key as keyof CreateArtistPayload] === '') {
                delete payload[key as keyof CreateArtistPayload];
            }
        });
        
        const id = Number(route.params.id);
        
        await artistStore.fetchUpdate(id, payload);
        
        notificationStore.notify("User updated successfully", "success");
        router.push({ name: "client.partner.artists" });
        
    } catch (error: any) {
        console.error('=== UPDATE ERROR ===', error.response?.data);
        
        if (error.response?.data?.errors) {
            Object.keys(error.response.data.errors).forEach(key => {
                errors[key] = error.response.data.errors[key][0];
            });
        } else {
            error.value = error.response?.data?.message || 'Failed to update user';
        }
    } finally {
        submitting.value = false;
    }
};

const displayAvatar = computed(() => {
    if (avatarFile.value) {
        return URL.createObjectURL(avatarFile.value);
    }
    
    if (form.avatar_url) {
        return getFullImageUrl(form.avatar_url);
    }
    
    return defaultAvatar;
});

const displayBanner = computed(()=>{
    if (bannerFile.value) {
        return URL.createObjectURL(bannerFile.value);
    }
    
    if (form.banner_url) {
        return getFullImageUrl(form.banner_url);
    }
    
    return defaultBanner;
});

onMounted(() => {
    loadArtistData();
});

function autoSlug(): void {
  form.slug = form.name
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9\s-]/g, '')
    .trim()
    .replace(/\s+/g, '-')
}

watch(
    () => form.name,
    () => {
        autoSlug()
    }
)
</script>

<style scoped>
.artist-add-view {
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

/* Form Sections */
.form-section {
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

/* Form Grids */
.form-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 20px;
}

.media-grid {
    display: grid;
    grid-template-columns: 1fr 2fr;
    gap: 24px;
}

.social-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
}

.settings-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
}

/* Form Groups */
.form-group {
    display: flex;
    flex-direction: column;
}

.form-group.required label::after {
    content: '*';
    color: #ff4444;
    margin-left: 4px;
}

.form-group label {
    font-size: 14px;
    font-weight: 500;
    color: rgba(255, 255, 255, 0.9);
    margin-bottom: 8px;
    display: flex;
    align-items: center;
    gap: 6px;
}

.form-group input,
.form-group select,
.form-group textarea {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 8px;
    padding: 10px 12px;
    color: white;
    font-size: 14px;
    transition: all 0.2s;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
    outline: none;
    border-color: #00aaff;
    background: rgba(255, 255, 255, 0.1);
}

.form-group input::placeholder,
.form-group textarea::placeholder {
    color: rgba(255, 255, 255, 0.3);
}


.form-group .form-group_option{
    color: black;
}

.full-width {
    grid-column: 1 / -1;
}

/* Slug Input */
.slug-input-group {
    display: flex;
    gap: 8px;
}

.slug-input-group input {
    flex: 1;
}

.btn-refresh-slug {
    width: 38px;
    height: 38px;
    border-radius: 8px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    background: rgba(255, 255, 255, 0.05);
    color: rgba(255, 255, 255, 0.7);
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
}

.btn-refresh-slug:hover {
    background: #00aaff;
    color: white;
    border-color: #00aaff;
}

/* Media Upload */
.media-upload {
    display: flex;
    flex-direction: column;
}

.upload-preview {
    position: relative;
    border-radius: 12px;
    overflow: hidden;
    border: 2px dashed rgba(255, 255, 255, 0.2);
    cursor: pointer;
    transition: all 0.2s;
}

.upload-preview:hover {
    border-color: #00aaff;
}

.upload-preview:hover .upload-overlay {
    opacity: 1;
}

.preview-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
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

.upload-overlay {
    position: absolute;
    inset: 0;
    background: rgba(0, 0, 0, 0.7);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 8px;
    color: white;
    opacity: 0;
    transition: opacity 0.2s;
    backdrop-filter: blur(4px);
}

/* Social Inputs */
.social-input input {
    padding-left: 40px;
    background-position: 12px center;
    background-repeat: no-repeat;
    background-size: 16px;
}

.social-input label {
    display: flex;
    align-items: center;
    gap: 6px;
}

/* Checkbox Group */
.checkbox-group {
    display: flex;
    flex-direction: column;
}

.checkbox-label {
    display: flex;
    flex-direction: column;
    padding: 12px;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 8px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    cursor: pointer;
}

.checkbox-label input[type="checkbox"] {
    width: 18px;
    height: 18px;
    margin-right: 10px;
    accent-color: #00aaff;
}

.checkbox-text {
    font-weight: 500;
    margin-bottom: 4px;
}

/* Stats Preview */
.stats-preview {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 16px;
    margin-top: 20px;
    padding: 16px;
    background: rgba(0, 0, 0, 0.3);
    border-radius: 12px;
}

.stat-item {
    text-align: center;
    padding: 12px;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 8px;
}

.stat-label {
    display: block;
    font-size: 12px;
    color: rgba(255, 255, 255, 0.6);
    margin-bottom: 4px;
}

.stat-value {
    font-size: 20px;
    font-weight: 600;
    color: #00aaff;
}

/* Helper Text */
.helper-text {
    color: rgba(255, 255, 255, 0.5);
    font-size: 12px;
    margin-top: 4px;
}

/* Form Actions */
.form-actions {
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

.btn-primary:hover:not(:disabled) {
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

.btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

/* Loading Spinner */
.spinner-small {
    width: 16px;
    height: 16px;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-top-color: white;
    border-radius: 50%;
    animation: spin 0.6s linear infinite;
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

/* Responsive */
@media (max-width: 768px) {
    .artist-add-view {
        padding: 16px;
    }
    
    .media-grid {
        grid-template-columns: 1fr;
    }
    
    .social-grid,
    .settings-grid {
        grid-template-columns: 1fr;
    }
    
    .stats-preview {
        grid-template-columns: repeat(2, 1fr);
    }
    
    .card-header {
        flex-direction: column;
        text-align: center;
    }
    
    .form-actions {
        flex-direction: column;
    }
    
    .btn {
        width: 100%;
        justify-content: center;
    }
}
</style>
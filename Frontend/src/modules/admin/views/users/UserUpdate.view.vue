<template>
    <div class="user-update-view">
        <!-- Header -->
        <div class="page-header">
            <h1 class="page-header-title" style="color: white;">User Management</h1>
            <div class="header-actions">
                <button class="btn btn-secondary" @click="$router.back()">
                    ← Back to Users
                </button>
            </div>
        </div>

        <!-- Main Content -->
        <div class="content-card">
            <div class="card-header">
                <h2>Edit User Profile</h2>
                <p class="subtitle">Update user account information</p>
            </div>

            <!-- Loading State -->
            <div v-if="loading" class="loading-overlay">
                <div class="spinner"></div>
                <span>Loading user data...</span>
            </div>

            <!-- Error Message -->
            <div v-if="error" class="alert alert-danger">
                {{ error }}
            </div>

            <!-- Update Form -->
            <form v-else @submit.prevent="handleSubmit" class="user-form">
                <!-- Basic Information Section -->
                <div class="form-section">
                    <h3 class="section-title">Basic Information</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="name">Full Name <span class="obligatory">*</span></label>
                            <input 
                                type="text" 
                                id="name" 
                                v-model="form.name" 
                                placeholder="Enter full name"
                                :class="{ 'is-invalid': errors.name }"
                                required 
                            />
                            <div v-if="errors.name" class="invalid-feedback">{{ errors.name }}</div>
                        </div>

                        <div class="form-group">
                            <label for="username">Username <span class="obligatory">*</span></label>
                            <input 
                                type="text" 
                                id="username" 
                                v-model="form.username" 
                                placeholder="Enter username"
                                :class="{ 'is-invalid': errors.username }"
                                required 
                            />
                            <div v-if="errors.username" class="invalid-feedback">{{ errors.username }}</div>
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address <span class="obligatory">*</span></label>
                            <input 
                                type="email" 
                                id="email" 
                                v-model="form.email" 
                                placeholder="user@example.com"
                                :class="{ 'is-invalid': errors.email }"
                                required 
                            />
                            <div v-if="errors.email" class="invalid-feedback">{{ errors.email }}</div>
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input 
                                type="tel" 
                                id="phone" 
                                v-model="form.phone" 
                                placeholder="+1234567890"
                                :class="{ 'is-invalid': errors.phone }"
                            />
                            <div v-if="errors.phone" class="invalid-feedback">{{ errors.phone }}</div>
                        </div>


                        <div class="form-group">
                            <label for="date_of_birth">Date of Birth</label>
                            <input type="date" id="date_of_birth" v-model="formattedDateOfBirth" />
                        </div>

                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <select id="gender" v-model="form.gender">
                                <option value="">Select gender</option>
                                <option value="male">Male</option>
                                <option value="female">Female</option>
                                <option value="other">Other</option>
                                <option value="prefer_not_to_say">Prefer not to say</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Profile Details Section -->
                <div class="form-section">
                    <h3 class="section-title">Profile Details</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="bio">Bio</label>
                            <textarea 
                                id="bio" 
                                v-model="form.bio" 
                                placeholder="Tell us about yourself..." 
                                rows="3"
                                maxlength="500"
                            ></textarea>
                            <small class="helper-text">{{ form.bio?.length || 0 }}/500 characters</small>
                        </div>

                        <div class="form-group avatar-group">
                            <label>Avatar</label>

                            <div class="avatar-preview" @click="fileInput?.click()">
                                <img :src="displayAvatar" alt="Avatar preview" class="avatar-img" />
                                <div class="avatar-overlay">
                                    <span>{{ (avatarFile || form.avatar_url) ? 'Change image' : 'Click to select image'}}</span>
                                </div>
                            </div>

                            <!-- Input file ẩn -->
                            <input 
                                type="file" 
                                ref="fileInput" 
                                accept="image/jpeg,image/png,image/gif,image/webp"
                                @change="handleAvatarChange" 
                                style="display: none" 
                            />

                            <!-- Tên file đã chọn -->
                            <small v-if="selectedFileName" class="helper-text">
                                Đã chọn: {{ selectedFileName }}
                            </small>

                            <small class="helper-text">JPG, PNG, GIF, WebP - Tối đa 5MB</small>
                        </div>
                    </div>
                </div>

                <!-- Location & Preferences -->
                <div class="form-section">
                    <h3 class="section-title">Location & Preferences</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="country">Country</label>
                            <select id="country" v-model="form.country">
                                <option value="">Select country</option>
                                <option value="US">United States</option>
                                <option value="UK">United Kingdom</option>
                                <option value="VN">Vietnam</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="timezone">Timezone</label>
                            <select id="timezone" v-model="form.timezone">
                                <option value="">Select timezone</option>
                                <option value="UTC">UTC</option>
                                <option value="Asia/Ho_Chi_Minh">UTC+7 (Vietnam)</option>
                                <option value="America/New_York">UTC-5 (EST)</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Status & Settings -->
                <div class="form-section">
                    <h3 class="section-title">Status & Settings</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="status">Account Status</label>
                            <select id="status" v-model="form.status">
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                                <option value="suspended">Suspended</option>
                                <option value="pending">Pending</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="published_at">Publish Date</label>
                            <input type="datetime-local" id="published_at" v-model="form.published_at" />
                        </div>
                    </div>
                </div>

                <!-- SEO Section -->
                <div class="form-section">
                    <h3 class="section-title">SEO Information</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="seo_title">SEO Title</label>
                            <input 
                                type="text" 
                                id="seo_title" 
                                v-model="form.seo_title" 
                                placeholder="SEO title for profile page"
                                maxlength="255"
                            />
                            <small class="helper-text">{{ form.seo_title?.length || 0 }}/255 characters</small>
                        </div>

                        <div class="form-group full-width">
                            <label for="seo_description">SEO Description</label>
                            <textarea 
                                id="seo_description" 
                                v-model="form.seo_description" 
                                placeholder="Meta description for profile page" 
                                rows="2"
                                maxlength="500"
                            ></textarea>
                            <small class="helper-text">{{ form.seo_description?.length || 0 }}/500 characters</small>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button 
                        type="button" 
                        class="btn btn-secondary" 
                        @click="$router.back()"
                        :disabled="submitting"
                    >
                        Cancel
                    </button>
                    <button 
                        type="submit" 
                        class="btn btn-primary"
                        :disabled="submitting"
                    >
                        <span v-if="submitting">
                            <span class="spinner-border spinner-border-sm mr-2"></span>
                            Updating...
                        </span>
                        <span v-else>Update User</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</template>

<script setup lang="ts">
import { reactive, ref, onMounted ,computed} from "vue";
import { useRoute } from "vue-router";
import { useUserStore,getFullImageUrl } from "@/modules/admin/stores/users/userStore";
import { useNotificationStore } from "@/store/notificationStore";
import router from "@/modules/router";
import type { CreateUserPayload } from "@/modules/admin/interfaces/users/create-user.payload";
import defaultAvatar from '@/assets/images/DefaultImg/avatarDefault.png';


const avatarPreview = ref<string>('');
const fileInput = ref<HTMLInputElement | null>(null);
const route = useRoute();
const userStore = useUserStore();
const notificationStore = useNotificationStore();
const selectedFileName = ref<string>('');

const loading = ref(false);
const submitting = ref(false);
const error = ref<string | null>(null);
const errors = reactive<Record<string, string>>({});

const avatarFile = ref<File | null>(null);

const form = reactive<CreateUserPayload>({
    name: "",
    username: "",
    email: "",
    password: "",
    phone: "",
    date_of_birth: "",
    gender: "",
    bio: "",
    avatar_url: null,
    country: "",
    timezone: "",
    status: "active",
    published_at: "",
    seo_title: "",
    seo_description: "",
});

// Load user data
const loadUserData = async () => {
    try {
        loading.value = true;
        error.value = null;
        
        const id = Number(route.params.id);
        const res = await userStore.fetchShow(id);
        
        if (res && res.data) {
            const basicFields = [
                'name', 'username', 'email', 'phone', 'date_of_birth',
                'gender', 'bio', 'country', 'timezone',
                'status', 'published_at', 'seo_title', 'seo_description',
                'slug'
            ];
            
            basicFields.forEach(field => {
                if (field in res.data && res.data[field] !== undefined) {
                    // @ts-ignore
                    form[field] = res.data[field];
                }
            });

            // Set avatar preview if exists
            if (res.data.avatar_url) {
                form.avatar_url = res.data.avatar_url; 
            } else if (res.data.avatar) {
                form.avatar_url = res.data.avatar;
            }
        }
        
    } catch (error: any) {
        const err = error as { response?: { status?: number } };
        
        if (err.response?.status === 404) {
            router.push('/404');
        } else if (err.response?.status === 401) {
            router.push('/login');
        } else {
            error.value = 'Failed to load user data';
            if (error) {
                notificationStore.notify("Failed to load user data", "error");
            }
        }
    } finally {
        loading.value = false;
    }
};

// Handle form submit
const handleSubmit = async () => {
    try {
        submitting.value = true;
        error.value = null;
        
        Object.keys(errors).forEach(key => delete errors[key]);
        
        const payload: CreateUserPayload = { ...form };
        
        if (avatarFile.value) {
            payload.avatar = avatarFile.value;
        }
        
        // Remove empty strings
        Object.keys(payload).forEach(key => {
            if (key !== 'password' && key !== 'avatar' && payload[key as keyof CreateUserPayload] === '') {
                delete payload[key as keyof CreateUserPayload];
            }
        });
        
        const id = Number(route.params.id);
        await userStore.fetchUpdate(id, payload);
        
        notificationStore.notify("User updated successfully", "success");
        router.push({ name: "admin.usermanager.all" });
        
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

const handleAvatarChange = (event: Event) => {
    const target = event.target as HTMLInputElement;
    const file = target.files?.[0];
    if (file) {
        avatarFile.value = file;
    }
};



const formattedDateOfBirth = computed({
    get() {
        if (!form.date_of_birth) return '';
        return form.date_of_birth.split('T')[0];
    },
    set(value) {
        form.date_of_birth = value ? value + 'T00:00:00.000Z' : '';
    }
});

onMounted(() => {
    loadUserData();
});
</script>

<style scoped>
.user-update-view {
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

.page-header h1 {
    font-size: 24px;
    font-weight: 600;
    color: #1a1a1a;
}

.content-card {
    height: 68vh;
    overflow-y: auto;
    background: white;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    padding: 24px;
    padding-bottom: 10px;
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
}

.loading-overlay {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 60px 20px;
    gap: 16px;
}

.spinner {
    width: 40px;
    height: 40px;
    border: 4px solid #f3f3f3;
    border-top: 4px solid #4a90e2;
    border-radius: 50%;
    animation: spin 1s linear infinite;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

.alert {
    padding: 12px 16px;
    border-radius: 6px;
    margin-bottom: 20px;
}

.alert-danger {
    background-color: #fee;
    color: #c33;
    border: 1px solid #fcc;
}

.form-section {
    margin-bottom: 32px;
    padding-bottom: 24px;
    border-bottom: 1px solid #eaeaea;
}

.form-section:last-of-type {
    border-bottom: none;
}

.section-title {
    font-size: 16px;
    font-weight: 600;
    color: #333;
    margin-bottom: 20px;
}

.form-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
}

.form-group {
    display: flex;
    flex-direction: column;
}

.form-group.full-width {
    grid-column: 1 / -1;
}

.form-group.avatar-group {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
}

.form-group label {
    font-size: 14px;
    font-weight: 500;
    color: #333;
    margin-bottom: 8px;
}

.form-group input,
.form-group select,
.form-group textarea {
    padding: 10px 12px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 14px;
    transition: border-color 0.3s;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
    outline: none;
    border-color: #4a90e2;
    box-shadow: 0 0 0 2px rgba(74, 144, 226, 0.1);
}

.form-group input.is-invalid,
.form-group select.is-invalid,
.form-group textarea.is-invalid {
    border-color: #dc3545;
}

.invalid-feedback {
    color: #dc3545;
    font-size: 12px;
    margin-top: 4px;
}

.avatar-preview {
    position: relative;
    width: 120px;
    height: 120px;
    border-radius: 50%;
    overflow: hidden;
    margin-bottom: 16px;
    border: 4px solid #eee;
    background-color: #f9f9f9;
    cursor: pointer;
    transition: all 0.3s;
}

.avatar-preview:hover {
    border-color: #4a90e2;
}

.avatar-preview:hover .avatar-overlay {
    opacity: 1;
}

.avatar-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.avatar-overlay {
    position: absolute;
    inset: 0;
    background: rgba(0, 0, 0, 0.5);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 14px;
    opacity: 0;
    transition: opacity 0.3s;
    pointer-events: none;
    padding: 10px;
    text-align: center;
}

.helper-text {
    color: #888;
    font-size: 12px;
    margin-top: 4px;
}

.form-actions {
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

.btn:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

.btn-primary {
    background: #4a90e2;
    color: white;
}

.btn-primary:hover:not(:disabled) {
    background: #3a80d2;
}

.btn-secondary {
    background: #f0f0f0;
    color: #333;
}

.btn-secondary:hover:not(:disabled) {
    background: #e0e0e0;
}

.obligatory {
    color: red;
}

.spinner-border {
    display: inline-block;
    width: 1rem;
    height: 1rem;
    vertical-align: text-bottom;
    border: 0.15em solid currentColor;
    border-right-color: transparent;
    border-radius: 50%;
    animation: spin 0.75s linear infinite;
}

.spinner-border-sm {
    width: 0.875rem;
    height: 0.875rem;
    border-width: 0.1em;
}

.mr-2 {
    margin-right: 0.5rem;
}

@media (max-width: 768px) {
    .form-grid {
        grid-template-columns: 1fr;
    }

    .page-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 12px;
    }
}
</style>
<template>
    <div class="user-add-view">
        <!-- Header -->
        <div class="page-header">
            <div class="header-left">
                <h1 class="page-header-title">User Management</h1>
                <span class="header-badge">Add New</span>
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

        <!-- Main Content -->
        <div class="content-card">
            <div class="card-header">
                <div class="header-icon">👤</div>
                <div class="header-text">
                    <h2>Add New User</h2>
                    <p class="subtitle">Create a new user account in the system</p>
                </div>
            </div>

            <form @submit.prevent="submitForm" class="user-form">
                <!-- Basic Information -->
                <div class="form-section">
                    <h3 class="section-title">
                        <span class="section-icon">📋</span>
                        Basic Information
                    </h3>
                    <div class="form-grid">
                        <div class="form-group required">
                            <label for="name">Full Name</label>
                            <input 
                                type="text" 
                                id="name" 
                                v-model="form.name" 
                                placeholder="Enter full name" 
                                required 
                            />
                        </div>

                        <div class="form-group required">
                            <label for="username">Username</label>
                            <input 
                                type="text" 
                                id="username" 
                                v-model="form.username" 
                                placeholder="Enter username" 
                                required 
                            />
                            <small class="helper-text">Unique username for login</small>
                        </div>

                        <div class="form-group required">
                            <label for="email">Email Address</label>
                            <input 
                                type="email" 
                                id="email" 
                                v-model="form.email" 
                                placeholder="user@example.com" 
                                required 
                            />
                        </div>

                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input 
                                type="tel" 
                                id="phone" 
                                v-model="form.phone" 
                                placeholder="+1234567890" 
                            />
                        </div>

                        <div class="form-group required">
                            <label for="password">Password</label>
                            <input 
                                type="password" 
                                id="password" 
                                v-model="form.password" 
                                placeholder="Enter password" 
                                required 
                            />
                            <small class="helper-text">Min 8 characters</small>
                        </div>

                        <div class="form-group">
                            <label for="date_of_birth">Date of Birth</label>
                            <input 
                                type="date" 
                                id="date_of_birth" 
                                v-model="form.date_of_birth" 
                            />
                        </div>

                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <select id="gender" v-model="form.gender">
                                <option value="" class="form-group_option">Select gender</option>
                                <option value="male" class="form-group_option">♂️ Male</option>
                                <option value="female" class="form-group_option">♀️ Female</option>
                                <option value="other" class="form-group_option">⚧ Other</option>
                                <option value="prefer_not_to_say" class="form-group_option">🤫 Prefer not to say</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Profile Details -->
                <div class="form-section">
                    <h3 class="section-title">
                        <span class="section-icon">🖼️</span>
                        Profile Details
                    </h3>
                    <div class="profile-grid">
                        <!-- Avatar Upload -->
                        <div class="avatar-upload-section">
                            <label>Profile Avatar</label>
                            <div class="avatar-upload">
                                <div class="avatar-preview" @click="fileInput?.click()">
                                    <img 
                                        :src="avatarPreview || defaultAvatar" 
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
                                    ref="fileInput" 
                                    accept="image/jpeg,image/png,image/gif,image/webp"
                                    @change="handleAvatarChange" 
                                    style="display: none" 
                                />
                                <small class="helper-text">JPG, PNG, GIF, WebP • Max 5MB</small>
                            </div>
                        </div>

                        <!-- Bio -->
                        <div class="bio-section">
                            <div class="form-group full-width">
                                <label for="bio">Biography</label>
                                <textarea 
                                    id="bio" 
                                    v-model="form.bio" 
                                    placeholder="Tell us about yourself..."
                                    rows="4"
                                ></textarea>
                                <small class="helper-text">Max 500 characters</small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Location & Preferences -->
                <div class="form-section">
                    <h3 class="section-title">
                        <span class="section-icon">📍</span>
                        Location & Preferences
                    </h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="country">Country</label>
                            <select id="country" v-model="form.country">
                                <option value="" class="form-group_option">Select country</option>
                                <option value="US" class="form-group_option">🇺🇸 United States</option>
                                <option value="UK" class="form-group_option">🇬🇧 United Kingdom</option>
                                <option value="VN" class="form-group_option">🇻🇳 Vietnam</option>
                                <option value="JP" class="form-group_option">🇯🇵 Japan</option>
                                <option value="KR" class="form-group_option">🇰🇷 South Korea</option>
                                <option value="FR" class="form-group_option">🇫🇷 France</option>
                                <option value="DE" class="form-group_option">🇩🇪 Germany</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="timezone">Timezone</label>
                            <select id="timezone" v-model="form.timezone">
                                <option value="" class="form-group_option">Select timezone</option>
                                <option value="UTC" class="form-group_option">🌐 UTC</option>
                                <option value="Asia/Ho_Chi_Minh" class="form-group_option">🇻🇳 UTC+7 (Vietnam)</option>
                                <option value="America/New_York" class="form-group_option">🇺🇸 UTC-5 (EST)</option>
                                <option value="Europe/London" class="form-group_option">🇬🇧 UTC+0 (London)</option>
                                <option value="Asia/Tokyo" class="form-group_option">🇯🇵 UTC+9 (Tokyo)</option>
                            </select>
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
                                <option value="suspended" class="form-group_option">🔴 Suspended</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="published_at">Publish Date</label>
                            <input 
                                type="datetime-local" 
                                id="published_at" 
                                v-model="form.published_at" 
                            />
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
                                placeholder="User Name | Platform" 
                            />
                            <small class="helper-text">Title for search engines (50-60 chars)</small>
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
                    <button type="submit" class="btn btn-primary" :disabled="loading">
                        <span v-if="loading" class="spinner-small"></span>
                        <span v-else>➕ Create User</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</template> 

<script setup lang="ts">
import { reactive, ref } from 'vue'
import router from "@/modules/router";
import type { CreateUserPayload } from "@/modules/admin/interfaces/users/create-user.payload";
import { useUserStore } from '@/modules/admin/stores/users/userStore';
import { useNotificationStore } from "@/store/notificationStore";

const notificationStore = useNotificationStore();
const userStore = useUserStore();
const loading = ref(false);

// Avatar
const avatarPreview = ref<string>('')
const fileInput = ref<HTMLInputElement | null>(null)
const defaultAvatar = 'https://via.placeholder.com/500?text=User'

// Form
const form = reactive<CreateUserPayload>({
    name: "",
    username: "",
    email: "",
    password: "",
    phone: "",
    date_of_birth: "",
    gender: "",
    bio: "",
    avatar: null,
    country: "",
    timezone: "",
    status: "active",
    published_at: "",
    seo_title: "",
    seo_description: "",
});



// Methods
const handleAvatarChange = (event: Event) => {
    const target = event.target as HTMLInputElement
    const file = target.files?.[0]

    if (!file) return

    if (!file.type.startsWith('image/')) {
        notificationStore.notify('Please select an image file!', 'error')
        return
    }

    if (file.size > 10 * 1024 * 1024) {
        console.log('code da den da');

        notificationStore.notify('File too large! Max 5MB', 'error')
        return
    }

    form.avatar = file

    const reader = new FileReader()
    reader.onload = (e) => {
        avatarPreview.value = e.target?.result as string
    }
    reader.readAsDataURL(file)

   
};

const submitForm = async () => {
    try {
        loading.value = true;
        
        await userStore.fetchAddUser(form);
        await userStore.fetchUsers();
        notificationStore.notify("User created successfully!", "success");
        router.push({ name: "admin.usermanager.all" });
    } catch (err: any) {
        notificationStore.notify(
            err.response?.data?.message || "Failed to create user",
            "error"
        );
    } finally {
        loading.value = false;
        setTimeout(() => notificationStore.clear(), 3000);
    }
};
</script>

<style scoped>
.user-add-view {
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

.profile-grid {
    display: grid;
    grid-template-columns: 200px 1fr;
    gap: 24px;
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

/* Avatar Upload */
.avatar-upload-section {
    display: flex;
    flex-direction: column;
}

.avatar-upload-section label {
    font-size: 14px;
    font-weight: 500;
    color: rgba(255, 255, 255, 0.9);
    margin-bottom: 12px;
}

.avatar-preview {
    position: relative;
    width: 200px;
    height: 200px;
    border-radius: 50%;
    overflow: hidden;
    border: 2px dashed rgba(255, 255, 255, 0.2);
    cursor: pointer;
    transition: all 0.2s;
}

.avatar-preview:hover {
    border-color: #00aaff;
}

.avatar-preview:hover .upload-overlay {
    opacity: 1;
}

.preview-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
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

/* Bio Section */
.bio-section {
    display: flex;
    flex-direction: column;
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

@keyframes spin {
    to { transform: rotate(360deg); }
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
    .user-add-view {
        padding: 16px;
    }
    
    .profile-grid {
        grid-template-columns: 1fr;
        justify-items: center;
    }
    
    .settings-grid {
        grid-template-columns: 1fr;
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
    
    .avatar-preview {
        margin: 0 auto;
    }
}
</style>
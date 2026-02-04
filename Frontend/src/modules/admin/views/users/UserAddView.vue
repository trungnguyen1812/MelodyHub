<template>
    <div class="user-add-view">
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
                <h2>Add New User</h2>
                <p class="subtitle">Create a new user account in the system</p>
            </div>

            <form @submit.prevent="submitForm" class="user-form">
                <!-- Basic Information Section -->
                <div class="form-section">
                    <h3 class="section-title">Basic Information</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="name">Full Name <span class="obligatory">*</span></label>
                            <input type="text" id="name" v-model="form.name" placeholder="Enter full name" required />
                        </div>
                        <div class="form-group">
                            <label for="username">Username <span class="obligatory">*</span></label>
                            <input type="text" id="username" v-model="form.username" placeholder="Enter username"
                                required />
                        </div>
                        <div class="form-group">
                            <label for="email">Email Address <span class="obligatory">*</span></label>
                            <input type="email" id="email" v-model="form.email" placeholder="user@example.com"
                                required />
                        </div>
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="tel" id="phone" v-model="form.phone" placeholder="+1234567890" />
                        </div>
                        <div class="form-group">
                            <label for="password">Password <span class="obligatory">*</span></label>
                            <input type="password" id="password" v-model="form.password" placeholder="Enter password"
                                required />
                        </div>
                        <div class="form-group">
                            <label for="date_of_birth">Date of Birth</label>
                            <input type="date" id="date_of_birth" v-model="form.date_of_birth" />
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
                            <textarea id="bio" v-model="form.bio" placeholder="Tell us about yourself..."
                                rows="3"></textarea>
                        </div>

                        <div class="form-group avatar-group">
                            <label>Avatar</label>

                            <!-- Vòng tròn preview - click để chọn ảnh -->
                            <div class="avatar-preview" @click="fileInput?.click()">
                                <img :src="avatarPreview || defaultAvatar" alt="Avatar preview" class="avatar-img" />
                                <div class="avatar-overlay">
                                    <span>{{ avatarPreview ? 'Thay đổi ảnh' : 'Click để chọn ảnh' }}</span>
                                </div>
                            </div>

                            <!-- Input file ẩn -->
                            <input type="file" ref="fileInput" accept="image/jpeg,image/png,image/gif,image/webp"
                                @change="handleAvatarChange" style="display: none" />

                            <!-- Tên file đã chọn (tùy chọn) -->
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
                            <input type="text" id="seo_title" v-model="form.seo_title"
                                placeholder="SEO title for profile page" />
                        </div>
                        <div class="form-group full-width">
                            <label for="seo_description">SEO Description</label>
                            <textarea id="seo_description" v-model="form.seo_description"
                                placeholder="Meta description for profile page" rows="2"></textarea>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" @click="$router.back()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Create User</button>
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

// Avatar refs
const avatarPreview = ref<string>('')
const selectedFileName = ref<string>('')
const fileInput = ref<HTMLInputElement | null>(null)
const defaultAvatar = 'https://via.placeholder.com/120?text=Avatar'  // ← sửa ở đây

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

const submitForm = async () => {
    try {
        await userStore.fetchAddUser(form);
        await userStore.fetchUsers();
        notificationStore.notify("Add user successful", "success");
        router.push({ name: "admin.usermanager.all" });
    } catch (err: any) {
        notificationStore.notify(
            err.response?.data?.message || "Add user failed",
            "error"
        );
    } finally {
        setTimeout(() => notificationStore.clear(), 3000);
    }
};


const handleAvatarChange = (event: Event) => {
    const target = event.target as HTMLInputElement
    const file = target.files?.[0]

    if (!file) return

    if (!file.type.startsWith('image/')) {
        alert('Please select an image file!')
        return
    }

    if (file.size > 50 * 1024 * 1024) {
        alert('The file is too large! Please choose an image under 50MB.')
        return
    }

    form.avatar = file

    selectedFileName.value = file.name

    const reader = new FileReader()
    reader.onload = (e) => {
        avatarPreview.value = e.target?.result as string
    }
    reader.readAsDataURL(file)

    if (target) target.value = ''
}
</script>


<style scoped>
.user-add-view {
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

.form-section {
    margin-bottom: 32px;
    padding-bottom: 24px;
    border-bottom: 1px solid #eaeaea;
}

.avatar-group {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
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
    border-color: #007bff;
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
}

.helper-text {
    color: #666;
    margin-top: 8px;
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

.helper-text {
    color: #888;
    font-size: 12px;
    margin-top: 4px;
}

.checkbox-group {
    flex-direction: row;
    align-items: center;
    gap: 8px;
}

.checkbox-group input[type="checkbox"] {
    width: 18px;
    height: 18px;
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

.obligatory {
    color: red;
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
<template>
    <div class="dashboard-container">
        <div class="header-section">
            <div class="title-container">
                <h1>Users Management</h1>
                <p class="subtitle">Manage All User Accounts</p>
            </div>
            <div class="header-actions">
                <button @click="CreateUser" class="btn-add-user">
                    <span class="btn-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v6m3-3H9m12 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                        </svg>
                    </span>
                    Add New User
                </button>
               
                 <div class="search-box">
                    <input type="text" placeholder="Search users..." v-model="keyword" @input="onSearch">
                    <span class="search-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
                            <path stroke-linecap="round" stroke-linejoin="round" d="m21 21-5.197-5.197m0 0A7.5 7.5 0 1 0 5.196 5.196a7.5 7.5 0 0 0 10.607 10.607Z" />
                        </svg>
                    </span>
                </div>
            </div>
        </div>
        <!-- Recent Users Table -->
        <div class="table-section">
            <div class="section-header">
                <h2>Recent Users</h2>
                <button class="btn-view-all" @click="router.back()">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                        <path fill-rule="evenodd" d="M7.793 2.232a.75.75 0 0 1-.025 1.06L3.622 7.25h10.003a5.375 5.375 0 0 1 0 10.75H10.75a.75.75 0 0 1 0-1.5h2.875a3.875 3.875 0 0 0 0-7.75H3.622l4.146 3.957a.75.75 0 0 1-1.036 1.085l-5.5-5.25a.75.75 0 0 1 0-1.085l5.5-5.25a.75.75 0 0 1 1.06.025Z" clip-rule="evenodd" />
                    </svg>
                    Back
                </button>
            </div>
            <div class="table-container">
                <table class="users-table">
                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" class="table-checkbox">
                            </th>
                            <th>User</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Join Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="user in users" :key="user.id">
                              <td>
                                <input type="checkbox" class="table-checkbox">
                            </td>
                            <td class="user-cell">
                                <div class="user-avatar">
                                    <img :src="getFullImageUrl(user.avatar_url)" :alt="user.name" class="avatar-img" />
                                </div>
                                <div class="user-info">
                                    <p class="user-name">{{ user.name }}</p>
                                    <p class="user-id">ID: {{ user.id }}</p>
                                </div>
                            </td>
                            <td>{{ user.email }}</td>
                             <td>
                                <span
                                    :class="`role-badge role-${(user.roles?.[0]?.name ?? 'user_free').toLowerCase()}`"
                                >
                                    {{ user.role_display_name ?? "Free User" }}
                                </span>
                            </td>
                            <td>
                                <span :class="`status-badge status-${user.status}`">
                                    {{ user.status }}
                                </span>
                            </td>
                            <td>{{ formatDate(user.created_at ?? "") }}</td>
                            <td>
                                <div class="action-buttons">
                                    <button class="btn-action btn-edit" @click="viewUpdateUser(user.id)">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                            <path d="m5.433 13.917 1.262-3.155A4 4 0 0 1 7.58 9.42l6.92-6.918a2.121 2.121 0 0 1 3 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 0 1-.65-.65Z" />
                                            <path d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0 0 10 3H4.75A2.75 2.75 0 0 0 2 5.75v9.5A2.75 2.75 0 0 0 4.75 18h9.5A2.75 2.75 0 0 0 17 15.25V10a.75.75 0 0 0-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5Z" />
                                        </svg>
                                    </button>
                                    <button class="btn-action btn-delete" @click="deleteUser(user.id)">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                            <path fill-rule="evenodd" d="M8.75 1A2.75 2.75 0 0 0 6 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 1 0 .23 1.482l.149-.022.841 10.518A2.75 2.75 0 0 0 7.596 19h4.807a2.75 2.75 0 0 0 2.742-2.53l.841-10.52.149.023a.75.75 0 0 0 .23-1.482A41.03 41.03 0 0 0 14 4.193V3.75A2.75 2.75 0 0 0 11.25 1h-2.5ZM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4ZM8.58 7.72a.75.75 0 0 0-1.5.06l.3 7.5a.75.75 0 1 0 1.5-.06l-.3-7.5Zm4.34.06a.75.75 0 1 0-1.5-.06l-.3 7.5a.75.75 0 1 0 1.5.06l.3-7.5Z" clip-rule="evenodd" />
                                        </svg>
                                    </button>
                                    <button class="btn-action btn-view" @click="viewDetailUser(user.id)">
                                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="size-5">
                                            <path d="M10 12.5a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z" />
                                            <path fill-rule="evenodd" d="M.664 10.59a1.651 1.651 0 0 1 0-1.186A10.004 10.004 0 0 1 10 3c4.257 0 7.893 2.66 9.336 6.41.147.381.146.804 0 1.186A10.004 10.004 0 0 1 10 17c-4.257 0-7.893-2.66-9.336-6.41ZM14 10a4 4 0 1 1-8 0 4 4 0 0 1 8 0Z" clip-rule="evenodd" />
                                        </svg>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div v-if="loading" class="loading-state">
        Loading users...
    </div>
    <div v-else-if="users.length === 0" class="empty-state">
        <div class="empty-icon">👥</div>
        <p>No users found</p>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useUserStore ,getFullImageUrl } from '@/modules/admin/stores/users/userStore';
import { storeToRefs } from "pinia";
import router from '@/modules/router';
import Swal from 'sweetalert2';
import { useNotificationStore } from "@/store/notificationStore";

const keyword = ref("");
const notificationStore = useNotificationStore();
let searchTimeout: number | null = null;    
const userStore = useUserStore();
const { users, loading } = storeToRefs(userStore);

const CreateUser =()=>{
    router.push({name:"admin.usermanager.add"});
}

const onSearch = ()=>{
    if (searchTimeout)clearTimeout(searchTimeout);
    searchTimeout = window.setTimeout(async() => {
        if (!keyword.value.trim()) {
            await userStore.fetchUsers();
            return;
        }
         await userStore.fetchSearchUser(
            keyword.value
        );
    }, 300);
}

function viewDetailUser(id: number) {
    router.push({
        name:"admin.usermanager.detail",
        params: { id }
    });
}

function viewUpdateUser(id: number) {
    router.push({
        name:"admin.usermanager.update",
        params: { id }
    });
}

function formatDate(date: string) {
    if (!date) return "";
    return new Date(date).toLocaleDateString("vi-VN");
}

async function deleteUser(id: number) {
    try {
        const result = await Swal.fire({
            title: 'Delete User',
            text: 'Are you sure you want to delete this user? This action cannot be undone.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'Cancel',
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            reverseButtons: true,
            customClass: {
                confirmButton: 'btn btn-danger',
                cancelButton: 'btn btn-secondary'
            }
        });
    
        if (!result.isConfirmed) return;
        
        loading.value = true;
        await userStore.fetchDelete(id);
        await userStore.fetchUsers();
        notificationStore.notify("Delete user successful", "success");
        
        router.push({name:"admin.usermanager.all"});
    
    } catch (error: any) {
        const err = error as { response?: { status?: number } }
        
        if (err.response?.status === 404) {
            router.push('/404')
        } else if (err.response?.status === 401) {
            router.push('/login')
        } else {
            
        }
        
    } finally {
        loading.value = false;
    }
}

onMounted(() => {
    userStore.fetchUsers();
});
</script>

<style scoped>
/* Base Styles */
.dashboard-container {
    height: 82vh;
    width: 100%;
    border-radius: 14px;
    margin-top: 7px;
    display: block;
    background: rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    display: flex;
    flex-direction: column;
    padding: 25px;
    position: relative;
   
    font-family: 'Afacad', sans-serif;
    color: white;
}

.header-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}


.user-avatar {
    width: 45px;
    height: 45px;
    overflow: hidden;
    border-radius: 50%;
    background: #f0f0f0;
}

.avatar-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.title-container h1 {
    font-size: 28px;
    font-weight: 600;
    margin: 0;
    background: linear-gradient(90deg, #00aaff, #00ffaa);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.subtitle {
    font-size: 14px;
    color: rgba(255, 255, 255, 0.7);
    margin-top: 5px;
    margin-bottom: 0;
}

.header-actions {
    display: flex;
    gap: 20px;
    align-items: center;
}

.btn-add-user {
    background: linear-gradient(135deg, #00aaff, #0088cc);
    border: none;
    color: white;
    padding: 10px 20px;
    border-radius: 8px;
    font-weight: 500;
    cursor: pointer;
    display: flex;
    align-items: center;
    gap: 8px;
    transition: all 0.3s ease;
    font-family: 'Afacad', sans-serif;
}

.btn-add-user:hover {
    background: linear-gradient(135deg, #0088cc, #006699);
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(0, 170, 255, 0.4);
}

.btn-icon {
    font-size: 18px;
    font-weight: bold;
}

.search-box {
    position: relative;
}

.search-box input {
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(0, 170, 255, 0.3);
    border-radius: 8px;
    padding: 10px 40px 10px 15px;
    color: white;
    width: 250px;
    font-family: 'Afacad', sans-serif;
    transition: all 0.3s ease;
}

.search-box input:focus {
    outline: none;
    border-color: #00aaff;
    box-shadow: 0 0 10px rgba(0, 170, 255, 0.3);
}

.search-icon {
    position: absolute;
    right: 15px;
    top: 50%;
    transform: translateY(-50%);
    color: rgba(255, 255, 255, 0.6);
}

/* Stats Grid */
.stats-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 20px;
    margin-bottom: 30px;
}

.stat-card {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    padding: 20px;
    display: flex;
    align-items: center;
    gap: 15px;
    border: 1px solid rgba(0, 170, 255, 0.2);
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
}

.stat-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 3px;
    opacity: 0.8;
}

.card-neon-blue::before {
    background: linear-gradient(90deg, #00aaff, #00ccff);
}

.card-neon-green::before {
    background: linear-gradient(90deg, #00ffaa, #00cc88);
}

.card-neon-purple::before {
    background: linear-gradient(90deg, #aa00ff, #cc00ff);
}

.card-neon-orange::before {
    background: linear-gradient(90deg, #ffaa00, #ff8800);
}

.stat-card:hover {
    transform: translateY(-5px);
    background: rgba(255, 255, 255, 0.08);
    border-color: rgba(0, 170, 255, 0.4);
    box-shadow: 0 10px 20px rgba(0, 170, 255, 0.1);
}

.stat-icon {
    font-size: 32px;
    width: 60px;
    height: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 10px;
}

.stat-content h3 {
    font-size: 14px;
    color: rgba(255, 255, 255, 0.7);
    margin: 0 0 5px 0;
    font-weight: 500;
}

.stat-number {
    font-size: 28px;
    font-weight: 600;
    margin: 0 0 5px 0;
}

.stat-change {
    font-size: 12px;
    margin: 0;
    color: rgba(255, 255, 255, 0.6);
}

.stat-change.positive {
    color: #00ffaa;
}

.stat-change.neutral {
    color: #aaaaff;
}

/* Table Section */
.table-section {
    flex: 1;
    background: rgba(0, 0, 0, 0.2);
    border-radius: 12px;
    padding: 20px;
    border: 1px solid rgba(0, 170, 255, 0.2);
    display: flex;
    height: 20vh;
    flex-direction: column;
    overflow-y: auto;
    overflow-x: hidden;
}

.table-section .section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.table-section .section-header h2 {
    font-size: 20px;
    margin: 0;
    color: rgba(255, 255, 255, 0.9);
}

.table-container {
    flex: 1;
    overflow-y: auto;
}

.users-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
}

.users-table thead {
    background: rgb(29, 69, 94);
    position: sticky;
    top: 0;
    z-index: 10;
}

.users-table th {
    padding: 15px;
    text-align: left;
    font-weight: 500;
    color: rgba(255, 255, 255, 0.7);
    border-bottom: 1px solid rgba(0, 170, 255, 0.3);
    white-space: nowrap;
}

.users-table td {
    padding: 15px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    vertical-align: middle;
}

.table-checkbox {
    width: 18px;
    height: 18px;
    cursor: pointer;
    accent-color: #00aaff;
}

.user-cell {
    display: flex;
    align-items: center;
    gap: 12px;
}

.user-avatar {
    width: 40px;
    height: 40px;
    background: linear-gradient(135deg, #00aaff, #00ffaa);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    font-size: 14px;
    color: white;
}

.user-info {
    display: flex;
    flex-direction: column;
}

.user-name {
    margin: 0;
    font-weight: 500;
    color: white;
}

.user-id {
    margin: 0;
    font-size: 12px;
    color: rgba(255, 255, 255, 0.6);
}

/* Badges */
.role-badge,
.status-badge {
    padding: 5px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 500;
    display: inline-block;
    white-space: nowrap;
}

/* Role badges - fixed for your data structure */
/* Boss / Owner */
.role-badge.role-boss {
    background: rgba(124, 58, 237, 0.2);
    color: #a78bfa;
    border: 1px solid rgba(124, 58, 237, 0.3);
}

/* Administrator */
.role-badge.role-admin {
    background: rgba(255, 0, 0, 0.2);
    color: #ff6666;
    border: 1px solid rgba(255, 0, 0, 0.3);
}

/* Content Manager */
.role-badge.role-content_manager {
    background: rgba(0, 170, 255, 0.2);
    color: #66ccff;
    border: 1px solid rgba(0, 170, 255, 0.3);
}

/* Partner / Producer */
.role-badge.role-partner {
    background: rgba(0, 255, 170, 0.2);
    color: #66ffcc;
    border: 1px solid rgba(0, 255, 170, 0.3);
}

/* Moderator */
.role-badge.role-moderator {
    background: rgba(255, 153, 0, 0.2);
    color: #ffb366;
    border: 1px solid rgba(255, 153, 0, 0.3);
}

/* VIP Yearly */
.role-badge.role-user_vip_yearly {
    background: rgba(234, 179, 8, 0.2);
    color: #facc15;
    border: 1px solid rgba(234, 179, 8, 0.3);
}

/* VIP Monthly */
.role-badge.role-user_vip_monthly {
    background: rgba(202, 138, 4, 0.2);
    color: #eab308;
    border: 1px solid rgba(202, 138, 4, 0.3);
}

/* Free User */
.role-badge.role-user_free {
    background: rgba(153, 153, 153, 0.2);
    color: #cccccc;
    border: 1px solid rgba(153, 153, 153, 0.3);
}

/* Status badges - fixed for your data structure */
.status-badge.status-active {
    background: rgba(0, 255, 0, 0.2);
    color: #66ff66;
    border: 1px solid rgba(0, 255, 0, 0.3);
}

.status-badge.status-inactive {
    background: rgba(255, 255, 0, 0.2);
    color: #ffff66;
    border: 1px solid rgba(255, 255, 0, 0.3);
}

.status-badge.status-pending {
    background: rgba(255, 165, 0, 0.2);
    color: #ffcc66;
    border: 1px solid rgba(255, 165, 0, 0.3);
}

/* Default status badge if status is unknown */
.status-badge {
    background: rgba(153, 153, 153, 0.2);
    color: #cccccc;
    border: 1px solid rgba(153, 153, 153, 0.3);
}

/* Action Buttons */
.action-buttons {
    display: flex;
    gap: 8px;
}

.btn-action {
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.2);
    color: white;
    width: 32px;
    height: 32px;
    border-radius: 6px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s ease;
    font-size: 14px;
}

.btn-action:hover {
    background: rgba(255, 255, 255, 0.2);
    transform: scale(1.1);
}

.btn-edit:hover {
    background: rgba(0, 170, 255, 0.3);
    border-color: #00aaff;
}

.btn-delete:hover {
    background: rgba(255, 0, 0, 0.3);
    border-color: #ff0000;
}

.btn-view:hover {
    background: rgba(0, 255, 0, 0.3);
    border-color: #00ff00;
}

.btn-view-all {
    background: transparent;
    border: 1px solid rgba(0, 170, 255, 0.5);
    color: #00aaff;
    padding: 8px 16px;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s ease;
    font-family: 'Afacad', sans-serif;
    font-size: 14px;
}

.btn-view-all:hover {
    background: rgba(0, 170, 255, 0.1);
    transform: translateX(5px);
}

/* Loading State */
.loading-state {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 200px;
    color: rgba(255, 255, 255, 0.7);
}

/* Empty State */
.empty-state {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    min-height: 200px;
    color: rgba(255, 255, 255, 0.7);
    text-align: center;
    padding: 40px;
}

.empty-state .empty-icon {
    font-size: 48px;
    margin-bottom: 20px;
    opacity: 0.5;
}

/* Scrollbar Styling */
.dashboard-container::-webkit-scrollbar,
.table-container::-webkit-scrollbar {
    width: 6px;
}

.dashboard-container::-webkit-scrollbar-thumb,
.table-container::-webkit-scrollbar-thumb {
    background: rgba(0, 170, 255, 0.6);
    border-radius: 3px;
}

.dashboard-container::-webkit-scrollbar-track,
.table-container::-webkit-scrollbar-track {
    background: transparent;
}

/* Neon Pulse Animation */
@keyframes neonPulse {

    0%,
    100% {
        box-shadow:
            0 0 8px rgba(0, 170, 255, 0.7),
            0 0 16px rgba(0, 170, 255, 0.55),
            0 0 24px rgba(0, 170, 255, 0.35),
            0 8px 25px rgba(0, 0, 0, 0.45);
    }

    50% {
        box-shadow:
            0 0 12px rgba(0, 170, 255, 0.8),
            0 0 20px rgba(0, 170, 255, 0.65),
            0 0 30px rgba(0, 170, 255, 0.45),
            0 8px 30px rgba(0, 0, 0, 0.5);
    }
}

/* Responsive Design */
@media (max-width: 1400px) {
    .stats-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 1200px) {
    .dashboard-container {
        padding: 20px;
    }

    .users-table th,
    .users-table td {
        padding: 12px;
        font-size: 14px;
    }
}

@media (max-width: 1024px) {
    .header-section {
        flex-direction: column;
        align-items: flex-start;
        gap: 20px;
    }

    .header-actions {
        width: 100%;
        justify-content: space-between;
    }

    .search-box input {
        width: 200px;
    }
}

@media (max-width: 768px) {
    .dashboard-container {
        padding: 15px;
        height: auto;
        min-height: 82vh;
    }

    .stats-grid {
        grid-template-columns: 1fr;
    }

    .header-actions {
        flex-direction: column;
        gap: 15px;
        align-items: flex-start;
    }

    .search-box input {
        width: 100%;
    }

    .users-table {
        display: block;
        overflow-x: auto;
    }

    .action-buttons {
        flex-wrap: wrap;
        justify-content: center;
    }

    .table-section .section-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 15px;
    }

    .btn-view-all {
        align-self: flex-end;
    }
}

@media (max-width: 480px) {
    .dashboard-container {
        padding: 12px;
    }

    .title-container h1 {
        font-size: 24px;
    }

    .stat-card {
        flex-direction: column;
        text-align: center;
        padding: 15px;
    }

    .stat-icon {
        width: 50px;
        height: 50px;
        font-size: 24px;
        margin-bottom: 10px;
    }

    .users-table th,
    .users-table td {
        padding: 8px;
        font-size: 13px;
    }

    .user-avatar {
        width: 35px;
        height: 35px;
        font-size: 13px;
    }

    .role-badge,
    .status-badge {
        padding: 4px 8px;
        font-size: 11px;
    }

    .btn-action {
        width: 28px;
        height: 28px;
        font-size: 12px;
    }
}
</style>
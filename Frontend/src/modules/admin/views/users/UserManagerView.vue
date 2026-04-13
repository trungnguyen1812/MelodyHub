<template>
  <div class="users-management">
    <!-- Header -->
    <div class="header">
      <div class="header-left">
        <h1 class="title">Users Management</h1>
        <p class="subtitle">Overview and statistics of all user accounts</p>
      </div>
      <div class="header-right">
        <button class="btn-add" @click="CreateUser">
          <span class="btn-icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <circle cx="12" cy="12" r="10"/>
              <line x1="12" y1="8" x2="12" y2="16"/>
              <line x1="8" y1="12" x2="16" y2="12"/>
            </svg>
          </span>
          Add New User
        </button>
      </div>
    </div>

    <!-- Stats Grid -->
    <div class="stats-grid">
      <!-- Total Users -->
      <div class="stat-card stat-card--blue">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Total Users</span>
          <CountUp 
            :key="userStore.safeStatistics?.total_users|0"
            :endVal="userStore.safeStatistics?.total_users|0" 
            :duration="1" 
            class="stat-value"
          />
          <span v-if="userStore.totalGrowthInfo" :class="['stat-change', userStore.totalGrowthInfo.class]">
            {{ userStore.totalGrowthInfo.text }}
          </span>
        </div>
      </div>

      <!-- User VIP -->
      <div class="stat-card stat-card--green">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
             <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">User VIP</span>
          <CountUp 
            :key="userStore.safeStatistics?.vip_users|0"
            :endVal="userStore.safeStatistics?.vip_users|0" 
            :duration="1" 
            class="stat-value"
          />
           <span v-if="userStore.vipGrowthInfo" :class="['stat-change', userStore.vipGrowthInfo.class]">
            {{ userStore.vipGrowthInfo.text }}
          </span>
        </div>
      </div>

      <!-- Partner -->
      <div class="stat-card stat-card--purple">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Partner</span>
          <CountUp 
            :key="userStore.safeStatistics?.partners|0"
            :endVal="userStore.safeStatistics?.partners|0" 
            :duration="1" 
            class="stat-value"
          />
          <span v-if="userStore.partnerGrowthInfo" :class="['stat-change', userStore.partnerGrowthInfo.class]">
            {{ userStore.partnerGrowthInfo.text }}
          </span>
        </div>
      </div>

      <!-- Admins -->
      <div class="stat-card stat-card--orange">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Admins</span>
          <CountUp 
            :key="userStore.safeStatistics?.admins|0"
            :endVal="userStore.safeStatistics?.admins|0" 
            :duration="1" 
            class="stat-value"
          />
          <span v-if="userStore.adminGrowthInfo" :class="['stat-change', userStore.adminGrowthInfo.class]">
            {{ userStore.adminGrowthInfo.text }}
          </span>
        </div>
      </div>
    </div>

    <!-- Users List Section -->
    <div class="users-list-page">
      <div class="toolbar">
        <div class="toolbar__left">
           <h2 class="section-title">Recent Users</h2>
        </div>
        <div class="toolbar__right">
           <div class="search-box">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="search-icon">
              <circle cx="11" cy="11" r="8"/>
              <line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <input v-model="keyword" type="text" placeholder="Search users..." @input="onSearch" />
          </div>
          <button class="btn-view-all" @click="ViewAllUser">View All Users →</button>
        </div>
      </div>

      <!-- Table Section -->
      <div class="table-section">
        <div class="table-wrapper">
          <table class="users-table">
            <thead>
              <tr>
                <th>User</th>
                <th>Email</th>
                <th>Role</th>
                <th>Status</th>
                <th>Join Date</th>
                <th class="th-actions">Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="user in paginatedUsers" :key="user.id" class="table-row">
                <td class="td-user">
                  <div class="user-cell">
                    <div class="user-avatar">
                        <img :src="getFullImageUrl(user.avatar_url)" :alt="user.name" />
                    </div>
                    <div class="user-info">
                      <p class="user-name">{{ user.name }}</p>
                      <p class="user-id">ID: {{ user.id }}</p>
                    </div>
                  </div>
                </td>
                <td class="td-text">{{ user.email }}</td>
                <td>
                  <span :class="['role-badge', `role-${(user.roles?.[0]?.name ?? 'user_free').toLowerCase()}`]">
                    {{ user.role_display_name ?? "Free User" }}
                  </span>
                </td>
                <td>
                  <span class="status-btn" :class="'status--' + user.status">
                    <span class="status-dot"></span>
                    {{ user.status }}
                  </span>
                </td>
                <td class="td-text td-mono">{{ formatDate(user.created_at ?? "") }}</td>
                <td class="td-actions">
                  <div class="action-btns">
                    <button class="act-btn act-btn--edit" title="Edit" @click="viewUpdateUser(user.id)">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                      </svg>
                    </button>
                    <button class="act-btn act-btn--delete" title="Delete" @click="deleteUser(user.id)">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="3 6 5 6 21 6"/>
                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                      </svg>
                    </button>
                    <button class="act-btn act-btn--view" title="View Details" @click="viewDetailUser(user.id)">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                      </svg>
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Loading state inside table -->
        <div v-if="loading" class="loading-overlay">
            <div class="spinner">
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="dot"></div>
            </div>
            <span>Loading data...</span>
        </div>
      </div>

      <!-- Pagination (Brief for Dashboard) -->
      <div class="pagination" v-if="users.length > 0">
        <div class="pagination-info">
          Showing <strong>{{ paginationStart }}</strong> to <strong>{{ paginationEnd }}</strong> of <strong>{{ users.length }}</strong> users
        </div>
        <div class="pagination-controls">
          <button class="page-btn" :disabled="currentPage === 1" @click="currentPage--">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
          </button>
          <span class="page-current">{{ currentPage }} / {{ totalPages }}</span>
          <button class="page-btn" :disabled="currentPage === totalPages" @click="currentPage++">
             <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { getFullImageUrl, useUserStore } from '@/modules/admin/stores/users/userStore';
import { storeToRefs } from "pinia";
import router from '@/modules/router';
import Swal from 'sweetalert2';
import { useNotificationStore } from "@/store/notificationStore";
import CountUp from '@/components/common/VcCountUp/CountUp.vue';

const userStore = useUserStore();
const notificationStore = useNotificationStore();
const keyword = ref("");
let searchTimeout: number | null = null;
const { loading } = storeToRefs(userStore);
const users = computed(() => userStore.users ?? []);
const currentPage = ref(1);
const itemsPerPage = 8;

const CreateUser = () => {
    router.push({ name: "admin.usermanager.add" });
}

const ViewAllUser = () => {
    router.push({ name: "admin.usermanager.all" });
}

function viewDetailUser(id: number) {
    router.push({
        name: "admin.usermanager.detail",
        params: { id }
    });
}

function viewUpdateUser(id: number) {
    router.push({
        name: "admin.usermanager.update",
        params: { id }
    });
}

const onSearch = () => {
    if (searchTimeout) clearTimeout(searchTimeout);
    searchTimeout = window.setTimeout(async () => {
        currentPage.value = 1;
        if (!keyword.value.trim()) {
            await userStore.fetchUsers();
            return;
        }
        await userStore.fetchSearchUser(keyword.value);
    }, 300);
}

function formatDate(date: string) {
    if (!date) return "—";
    return new Date(date).toLocaleDateString("en-GB", { day: '2-digit', month: 'short', year: 'numeric' });
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
            confirmButtonColor: '#ef4444',
            cancelButtonColor: '#334155',
            reverseButtons: true,
            background: '#181c22',
            color: '#f0f4f8'
        });

        if (!result.isConfirmed) return;

        loading.value = true;
        await userStore.fetchDelete(id);
        await userStore.fetchUsers();
        notificationStore.notify("User deleted successfully", "success");
    } catch (error: any) {
        notificationStore.notify("Error deleting user", "error");
    } finally {
        loading.value = false;
    }
}

const totalPages = computed(() => Math.max(1, Math.ceil(users.value.length / itemsPerPage)));
const paginationStart = computed(() => users.value.length === 0 ? 0 : ((currentPage.value - 1) * itemsPerPage) + 1);
const paginationEnd = computed(() => Math.min(currentPage.value * itemsPerPage, users.value.length));

const paginatedUsers = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    return users.value.slice(start, end);
});

onMounted(() => {
    userStore.fetchUsers();
    userStore.fetchShowStatistics();
});
</script>

<style scoped>
.users-management {
  background-color: #0f1216;
  min-height: 100vh;
  padding: 32px 36px;
  font-family: 'DM Sans', system-ui, sans-serif;
  color: #e2e8f0;
}

/* ── Header ── */
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 32px;
}

.title {
  font-size: 26px;
  font-weight: 700;
  margin: 0;
  background: linear-gradient(90deg, #fff 30%, #00aaff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.subtitle {
  font-size: 13px;
  color: #64748b;
  margin-top: 4px;
}

.btn-add {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  background: linear-gradient(90deg, #3b82f6, #2563eb);
  border: none;
  border-radius: 10px;
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-add:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}

/* ── Stats Grid ── */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 30px;
}

.stat-card {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.05);
  border-radius: 14px;
  padding: 24px 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  border-top: 3px solid transparent;
  transition: transform 0.2s;
}

.stat-card:hover {
  transform: translateY(-4px);
  background: rgba(255, 255, 255, 0.05);
}

.stat-card--blue  { border-top-color: #3b82f6; }
.stat-card--green { border-top-color: #10b981; }
.stat-card--purple{ border-top-color: #8b5cf6; }
.stat-card--orange{ border-top-color: #f59e0b; }

.stat-icon {
  width: 52px;
  height: 52px;
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.05);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #94a3b8;
}

.stat-info { display: flex; flex-direction: column; gap: 4px; }
.stat-label { font-size: 12px; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; }
.stat-value { font-size: 28px; font-weight: 700; color: #f1f5f9; line-height: 1.1; }
.stat-change { font-size: 12px; }
.stat-change.positive { color: #10b981; }
.stat-change.negative { color: #ef4444; }

/* ── Main List Box ── */
.users-list-page {
  background: #111418;
  border-radius: 16px;
  border: 1px solid #1e2530;
  padding: 24px;
}

.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.section-title { font-size: 18px; font-weight: 600; color: #f1f5f9; }

.toolbar__right { display: flex; align-items: center; gap: 12px; }

.search-box {
  position: relative;
  display: flex;
  align-items: center;
}

.search-icon {
  position: absolute;
  left: 12px;
  color: #4a5568;
  pointer-events: none;
}

.search-box input {
  background: #181c22;
  border: 1px solid #2d3748;
  border-radius: 10px;
  padding: 9px 12px 9px 36px;
  color: #e2e8f0;
  font-size: 13px;
  width: 240px;
  outline: none;
  transition: all 0.2s;
}

.search-box input:focus {
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.btn-view-all {
  background: transparent;
  border: 1px solid rgba(59, 130, 246, 0.3);
  color: #3b82f6;
  padding: 8px 16px;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-view-all:hover {
  background: rgba(59, 130, 246, 0.05);
  border-color: #3b82f6;
}

/* ── Table ── */
.table-section {
  position: relative;
  background: #181c22;
  border-radius: 12px;
  border: 1px solid #252d3a;
  overflow: hidden;
}

.table-wrapper { overflow-x: auto; }

.users-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
}

.users-table thead tr {
  background: #1e2530;
  border-bottom: 1px solid #252d3a;
}

.users-table th {
  padding: 12px 16px;
  text-align: left;
  font-size: 11px;
  font-weight: 600;
  color: #94a3b8;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.users-table td {
  padding: 12px 16px;
  border-bottom: 1px solid #252d3a;
  vertical-align: middle;
}

.table-row:hover { background: rgba(255, 255, 255, 0.02); }

.user-cell { display: flex; align-items: center; gap: 12px; }
.user-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  overflow: hidden;
  background: #1e2530;
}
.user-avatar img { width: 100%; height: 100%; object-fit: cover; }
.user-name { font-weight: 600; color: #f1f5f9; margin: 0; }
.user-id { font-size: 11px; color: #64748b; margin: 0; }

.td-text { color: #94a3b8; }
.td-mono { font-family: ui-monospace, monospace; }

.role-badge {
  display: inline-flex;
  padding: 3px 10px;
  border-radius: 6px;
  font-size: 10px;
  font-weight: 700;
  text-transform: uppercase;
  background: rgba(255, 255, 255, 0.05);
  color: #94a3b8;
}

.role-admin { background: rgba(239, 68, 68, 0.1); color: #f87171; }
.role-partner { background: rgba(16, 185, 129, 0.1); color: #34d399; }
.role-user_vip_yearly { background: rgba(245, 158, 11, 0.1); color: #fbbf24; }

.status-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 10px;
  border-radius: 20px;
  font-size: 11px;
  font-weight: 600;
  text-transform: capitalize;
}

.status--active { background: rgba(16, 185, 129, 0.1); color: #34d399; }
.status--inactive { background: rgba(100, 116, 139, 0.1); color: #94a3b8; }
.status-dot { width: 5px; height: 5px; border-radius: 50%; background: currentColor; }

.td-actions { width: 120px; }
.action-btns { display: flex; gap: 6px; justify-content: flex-end; }

.act-btn {
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  background: #1e2530;
  border: 1px solid #2d3748;
  color: #64748b;
  cursor: pointer;
  transition: all 0.2s;
}

.act-btn:hover { color: #f1f5f9; border-color: #4a5568; transform: translateY(-1px); }
.act-btn--edit:hover { color: #3b82f6; border-color: #3b82f6; background: rgba(59, 130, 246, 0.05); }
.act-btn--delete:hover { color: #ef4444; border-color: #ef4444; background: rgba(239, 68, 68, 0.05); }
.act-btn--view:hover { color: #10b981; border-color: #10b981; background: rgba(16, 185, 129, 0.05); }

/* ── Pagination ── */
.pagination {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 16px;
  font-size: 13px;
  color: #64748b;
}

.pagination-controls { display: flex; align-items: center; gap: 12px; }

.page-btn {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  background: #181c22;
  border: 1px solid #2d3748;
  color: #64748b;
  cursor: pointer;
}

.page-btn:hover:not(:disabled) { border-color: #3b82f6; color: #3b82f6; }
.page-btn:disabled { opacity: 0.3; cursor: not-allowed; }

.loading-overlay {
  position: absolute;
  inset: 0;
  background: rgba(15, 18, 22, 0.7);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  z-index: 10;
}

.spinner { display: flex; gap: 4px; }
.dot { width: 8px; height: 8px; border-radius: 50%; background: #3b82f6; animation: bounce 1.4s infinite ease-in-out; }
.dot:nth-child(1) { animation-delay: -0.32s; }
.dot:nth-child(2) { animation-delay: -0.16s; }

@keyframes bounce { 0%, 80%, 100% { transform: scale(0); } 40% { transform: scale(1.0); } }

@media (max-width: 1024px) {
  .stats-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 640px) {
  .users-management { padding: 20px 16px; }
  .header { flex-direction: column; align-items: flex-start; gap: 16px; }
  .stats-grid { grid-template-columns: 1fr; }
  .toolbar { flex-direction: column; align-items: stretch; gap: 12px; }
  .search-box input { width: 100%; }
}
</style>
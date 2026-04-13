<template>
  <div class="users-management">
    <!-- Header -->
    <div class="header">
      <div class="header-left">
        <button class="back-btn" @click="router.back()">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <polyline points="15 18 9 12 15 6"/>
          </svg>
        </button>
        <div class="header-titles">
          <h1 class="title">All Users</h1>
          <p class="subtitle">Complete list of registered accounts</p>
        </div>
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

    <!-- Main Content Shell -->
    <div class="users-list-page">
      <!-- Toolbar -->
      <div class="toolbar">
        <div class="toolbar__left">
          <div class="search-box">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="search-icon">
              <circle cx="11" cy="11" r="8"/>
              <line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <input v-model="keyword" type="text" placeholder="Search name or email..." @input="onSearch" />
             <button v-if="keyword" class="search-clear" @click="keyword = ''; onSearch()">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
              </svg>
            </button>
          </div>

          <select v-model="selectedRole" class="filter-select" @change="onFilterChange">
            <option value="">All Roles</option>
            <option value="admin">Admin</option>
            <option value="partner">Partner</option>
            <option value="user_vip_yearly">VIP Yearly</option>
            <option value="user_free">Free User</option>
          </select>

          <select v-model="selectedStatus" class="filter-select" @change="onFilterChange">
            <option value="">All Status</option>
            <option value="active">Active</option>
            <option value="inactive">Inactive</option>
          </select>

          <div v-if="hasActiveFilters" class="filter-indicator">
            <span class="filter-dot"></span>
            <button class="filter-clear-all" @click="clearFilters">Clear all</button>
          </div>
        </div>

        <div class="toolbar__right">
          <div class="page-info-badge">
             {{ filteredUsers.length }} Users Found
          </div>
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

        <!-- Empty State -->
        <div v-if="!loading && filteredUsers.length === 0" class="empty-state">
          <div class="empty-icon">
            <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
               <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>
            </svg>
          </div>
          <p class="empty-title">No users found</p>
          <p class="empty-subtitle">Try adjusting your filters or search query</p>
          <button v-if="hasActiveFilters" class="btn-clear-filters" @click="clearFilters">Clear All Filters</button>
        </div>

        <!-- Loading state -->
        <div v-if="loading" class="loading-overlay">
          <div class="spinner">
            <div class="dot"></div>
            <div class="dot"></div>
            <div class="dot"></div>
          </div>
          <span>Loading users...</span>
        </div>
      </div>

      <!-- Pagination -->
      <div class="pagination" v-if="filteredUsers.length > 0">
        <div class="pagination-info">
          Page <strong>{{ currentPage }}</strong> of <strong>{{ totalPages }}</strong>
          <span class="pagination-sep">·</span>
          <strong>{{ filteredUsers.length }}</strong> users
        </div>
        <div class="pagination-controls">
          <button class="page-btn" :disabled="currentPage === 1" @click="currentPage--">
             <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
          </button>
          
          <div class="pagination-numbers">
            <button 
              v-for="p in visiblePages" 
              :key="p" 
              class="num-btn"
              :class="{ active: p === currentPage, ellipsis: p === '...' }"
              @click="typeof p === 'number' && (currentPage = p)"
            >
              {{ p }}
            </button>
          </div>

          <button class="page-btn" :disabled="currentPage === totalPages" @click="currentPage++">
             <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import { storeToRefs } from 'pinia'
import router from '@/modules/router'
import Swal from 'sweetalert2'
import { useNotificationStore } from '@/store/notificationStore'
import { useUserStore, getFullImageUrl } from '@/modules/admin/stores/users/userStore'

const keyword = ref('')
const selectedRole = ref('')
const selectedStatus = ref('')
const currentPage = ref(1)
const itemsPerPage = 12
let searchTimeout: any = null

const notificationStore = useNotificationStore()
const userStore = useUserStore()
const { users, loading } = storeToRefs(userStore)

const onSearch = () => {
    if (searchTimeout) clearTimeout(searchTimeout)
    searchTimeout = setTimeout(async () => {
        currentPage.value = 1
        if (!keyword.value.trim()) {
            await userStore.fetchUsers()
            return
        }
        await userStore.fetchSearchUser(keyword.value)
    }, 300)
}

const onFilterChange = () => {
    currentPage.value = 1
}

const clearFilters = () => {
    keyword.value = ''
    selectedRole.value = ''
    selectedStatus.value = ''
    onSearch()
}

const hasActiveFilters = computed(() => !!keyword.value || !!selectedRole.value || !!selectedStatus.value)

const filteredUsers = computed(() => {
    let list = [...users.value]
    
    if (selectedRole.value) {
        list = list.filter(u => u.roles?.some(r => r.name.toLowerCase() === selectedRole.value))
    }
    
    if (selectedStatus.value) {
        list = list.filter(u => u.status === selectedStatus.value)
    }
    
    return list
})

const totalPages = computed(() => Math.max(1, Math.ceil(filteredUsers.value.length / itemsPerPage)))

const paginatedUsers = computed(() => {
    const s = (currentPage.value - 1) * itemsPerPage
    return filteredUsers.value.slice(s, s + itemsPerPage)
})

const visiblePages = computed(() => {
    const total = totalPages.value
    const cur = currentPage.value
    if (total <= 7) return Array.from({ length: total }, (_, i) => i + 1)
    const pages: (number | string)[] = [1]
    if (cur > 3) pages.push('...')
    for (let i = Math.max(2, cur - 1); i <= Math.min(total - 1, cur + 1); i++) pages.push(i)
    if (cur < total - 2) pages.push('...')
    pages.push(total)
    return pages
})

const formatDate = (date: string) => {
    if (!date) return "—";
    return new Date(date).toLocaleDateString("en-GB", { day: '2-digit', month: 'short', year: 'numeric' });
}

const CreateUser = () => router.push({ name: 'admin.usermanager.add' })
const viewDetailUser = (id: number) => router.push({ name: 'admin.usermanager.detail', params: { id } })
const viewUpdateUser = (id: number) => router.push({ name: 'admin.usermanager.update', params: { id } })

const deleteUser = async (id: number) => {
    const result = await Swal.fire({
        title: 'Delete User?',
        text: 'This action cannot be undone and will permanently remove the user.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, Delete',
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#334155',
        reverseButtons: true,
        background: '#181c22',
        color: '#f0f4f8',
    })
    
    if (!result.isConfirmed) return
    
    try {
        loading.value = true
        await userStore.fetchDelete(id)
        await userStore.fetchUsers()
        notificationStore.notify('User deleted successfully', 'success')
    } catch (err: any) {
        notificationStore.notify('Failed to delete user', 'error')
    } finally {
        loading.value = false
    }
}

onMounted(() => userStore.fetchUsers())
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
  margin-bottom: 24px;
}

.header-left { display: flex; align-items: center; gap: 16px; }

.back-btn {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 12px;
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.08);
  color: #94a3b8;
  cursor: pointer;
  transition: all 0.2s;
}

.back-btn:hover { background: rgba(255, 255, 255, 0.08); color: #f1f5f9; transform: translateX(-2px); }

.title {
  font-size: 26px;
  font-weight: 700;
  margin: 0;
  background: linear-gradient(90deg, #fff 30%, #00aaff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.subtitle { font-size: 13px; color: #64748b; margin-top: 2px; }

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

.btn-add:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3); }

/* ── List Page ── */
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
  flex-wrap: wrap;
  gap: 16px;
}

.toolbar__left { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
.toolbar__right { display: flex; align-items: center; }

.search-box {
  position: relative;
  display: flex;
  align-items: center;
}

.search-icon { position: absolute; left: 12px; color: #4a5568; pointer-events: none; }
.search-clear { position: absolute; right: 10px; background: none; border: none; color: #64748b; cursor: pointer; }
.search-clear:hover { color: #f1f5f9; }

.search-box input {
  background: #181c22;
  border: 1px solid #2d3748;
  border-radius: 10px;
  padding: 9px 34px 9px 36px;
  color: #e2e8f0;
  font-size: 13px;
  width: 240px;
  outline: none;
  transition: all 0.2s;
}

.search-box input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1); }

.filter-select {
  background: #181c22;
  border: 1px solid #2d3748;
  border-radius: 10px;
  padding: 9px 12px;
  color: #94a3b8;
  font-size: 13px;
  outline: none;
  cursor: pointer;
}

.filter-select:hover { border-color: #4a5568; }

.filter-indicator { display: flex; align-items: center; gap: 8px; }
.filter-dot { width: 6px; height: 6px; border-radius: 50%; background: #3b82f6; box-shadow: 0 0 8px rgba(59, 130, 246, 0.6); }
.filter-clear-all { background: none; border: none; color: #3b82f6; font-size: 12px; font-weight: 500; cursor: pointer; padding: 0; }
.filter-clear-all:hover { color: #60a5fa; text-decoration: underline; }

.page-info-badge {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.08);
    padding: 6px 12px;
    border-radius: 8px;
    font-size: 12px;
    color: #94a3b8;
}

/* ── Table ── */
.table-section {
  position: relative;
  background: #181c22;
  border-radius: 12px;
  border: 1px solid #252d3a;
  overflow: hidden;
  min-height: 400px;
}

.table-wrapper { overflow-x: auto; }

.users-table { width: 100%; border-collapse: collapse; font-size: 13px; }
.users-table thead tr { background: #1e2530; border-bottom: 1px solid #252d3a; }
.users-table th { padding: 14px 16px; text-align: left; font-size: 11px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; }
.users-table td { padding: 12px 16px; border-bottom: 1px solid #252d3a; vertical-align: middle; }
.table-row:hover { background: rgba(255, 255, 255, 0.02); }

.user-cell { display: flex; align-items: center; gap: 12px; }
.user-avatar { width: 38px; height: 38px; border-radius: 50%; overflow: hidden; background: #1e2530; border: 1px solid rgba(255, 255, 255, 0.1); }
.user-avatar img { width: 100%; height: 100%; object-fit: cover; }
.user-name { font-weight: 600; color: #f1f5f9; margin: 0; }
.user-id { font-size: 11px; color: #64748b; margin: 0; }

.td-text { color: #94a3b8; }
.td-mono { font-family: ui-monospace, monospace; }

.role-badge { display: inline-flex; padding: 4px 10px; border-radius: 6px; font-size: 10px; font-weight: 700; text-transform: uppercase; background: rgba(255, 255, 255, 0.05); color: #94a3b8; }
.role-admin { background: rgba(239, 68, 68, 0.1); color: #f87171; }
.role-partner { background: rgba(16, 185, 129, 0.1); color: #34d399; }
.role-user_vip_yearly { background: rgba(245, 158, 11, 0.1); color: #fbbf24; }

.status-btn { display: inline-flex; align-items: center; gap: 6px; padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; text-transform: capitalize; }
.status--active { background: rgba(16, 185, 129, 0.1); color: #34d399; }
.status--inactive { background: rgba(100, 116, 139, 0.1); color: #94a3b8; }
.status-dot { width: 5px; height: 5px; border-radius: 50%; background: currentColor; }

.td-actions { width: 120px; }
.action-btns { display: flex; gap: 6px; justify-content: flex-end; }
.act-btn { width: 30px; height: 30px; display: flex; align-items: center; justify-content: center; border-radius: 8px; background: #1e2530; border: 1px solid #2d3748; color: #64748b; cursor: pointer; transition: all 0.2s; }
.act-btn:hover { color: #f1f5f9; border-color: #4a5568; transform: translateY(-1px); }
.act-btn--edit:hover { color: #3b82f6; border-color: #3b82f6; background: rgba(59, 130, 246, 0.05); }
.act-btn--delete:hover { color: #ef4444; border-color: #ef4444; background: rgba(239, 68, 68, 0.05); }
.act-btn--view:hover { color: #10b981; border-color: #10b981; background: rgba(16, 185, 129, 0.05); }

/* ── Pagination ── */
.pagination { 
    display: flex; align-items: center; justify-content: space-between; margin-top: 20px; 
    padding-top: 16px; border-top: 1px solid rgba(255, 255, 255, 0.05);
}
.pagination-info { font-size: 13px; color: #64748b; }
.pagination-sep { margin: 0 8px; opacity: 0.3; }
.pagination-controls { display: flex; align-items: center; gap: 8px; }

.pagination-numbers { display: flex; gap: 4px; }
.num-btn {
  min-width: 32px; height: 32px; border-radius: 8px; border: 1px solid #2d3748; background: #181c22;
  color: #64748b; font-size: 13px; cursor: pointer; transition: all 0.2s;
}
.num-btn:hover:not(.active):not(.ellipsis) { border-color: #3b82f6; color: #3b82f6; }
.num-btn.active { background: #3b82f6; border-color: #3b82f6; color: #fff; font-weight: 600; }
.num-btn.ellipsis { cursor: default; border-color: transparent; background: transparent; }

.page-btn {
  width: 32px; height: 32px; display: flex; align-items: center; justify-content: center;
  border-radius: 8px; background: #181c22; border: 1px solid #2d3748; color: #64748b; cursor: pointer;
}
.page-btn:hover:not(:disabled) { border-color: #3b82f6; color: #3b82f6; }
.page-btn:disabled { opacity: 0.3; cursor: not-allowed; }

/* ── Empty State ── */
.empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 80px 24px; text-align: center; }
.empty-icon { color: #252d3a; margin-bottom: 16px; }
.empty-title { font-size: 18px; font-weight: 600; color: #f1f5f9; margin-bottom: 4px; }
.empty-subtitle { font-size: 14px; color: #64748b; margin-bottom: 20px; }
.btn-clear-filters { background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59, 130, 246, 0.3); color: #3b82f6; padding: 8px 20px; border-radius: 10px; font-size: 13px; font-weight: 500; cursor: pointer; }

.loading-overlay { position: absolute; inset: 0; background: rgba(15, 18, 22, 0.7); display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 12px; z-index: 10; font-size: 14px; color: #94a3b8; }
.spinner { display: flex; gap: 4px; }
.dot { width: 8px; height: 8px; border-radius: 50%; background: #3b82f6; animation: bounce 1.4s infinite ease-in-out; }
.dot:nth-child(1) { animation-delay: -0.32s; }
.dot:nth-child(2) { animation-delay: -0.16s; }
@keyframes bounce { 0%, 80%, 100% { transform: scale(0); } 40% { transform: scale(1.0); } }

@media (max-width: 768px) {
  .users-management { padding: 20px 16px; }
  .header { flex-direction: column; align-items: flex-start; gap: 16px; }
  .toolbar { flex-direction: column; align-items: stretch; }
  .search-box input { width: 100%; }
}
</style>
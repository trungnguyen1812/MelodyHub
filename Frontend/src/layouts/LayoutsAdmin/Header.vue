<template>
    <header class="header">
        <!-- Left section -->
        <div class="header-left">
            <button class="menu-btn">
                <img src="@/assets/images/icon/menu.png" alt="Menu">
            </button>
            <div class="logo-section">
                <img class="logo-icon" src="@/assets/images/logo/melody-high-resolution-logo-white.png" alt="MelodyHub">
                <span class="logo-text">MELODYHUB</span>
            </div>
        </div>

        <!-- Right section -->
        <div class="header-right">

            <!-- Notification button + dropdown -->
            <div class="notif-wrap" ref="notifWrapRef">
                <button
                    class="notification-btn"
                    :class="{ 'notification-btn--active': dropdownOpen }"
                    @click="toggleDropdown"
                    :title="`${dashStore.notificationCount} pending items`"
                >
                    <img src="@/assets/images/icon/bell.png" alt="Notifications">
                    <span
                        v-if="dashStore.notificationCount > 0"
                        class="notification-badge"
                        :class="{ 'badge-pulse': dashStore.notificationCount > 0 }"
                    >
                        {{ dashStore.notificationCount > 9 ? '9+' : dashStore.notificationCount }}
                    </span>
                </button>

                <!-- Dropdown panel -->
                <Transition name="notif-drop">
                    <div v-if="dropdownOpen" class="notif-dropdown">
                        <!-- Header -->
                        <div class="notif-drop__header">
                            <span class="notif-drop__title">Pending Approvals</span>
                            <div class="notif-drop__actions">
                                <button
                                    v-if="dashStore.notificationCount > 0"
                                    class="notif-drop__mark-all"
                                    @click="dashStore.dismissAll()"
                                >
                                    Mark all read
                                </button>
                                <router-link
                                    :to="{ name: 'admin.dashboard' }"
                                    class="notif-drop__view-all"
                                    @click="dropdownOpen = false"
                                >
                                    View all
                                </router-link>
                            </div>
                        </div>

                        <!-- Loading -->
                        <div v-if="dashStore.loading" class="notif-drop__loading">
                            <div class="notif-drop__spinner"></div>
                            <span>Loading...</span>
                        </div>

                        <!-- Empty -->
                        <div v-else-if="dashStore.notificationCount === 0" class="notif-drop__empty">
                            <svg width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                    d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            <p>All caught up!</p>
                        </div>

                        <!-- List -->
                        <div v-else class="notif-drop__list">
                            <div
                                v-for="n in dashStore.activeNotifications.slice(0, 8)"
                                :key="n.id"
                                class="notif-drop__item"
                                :class="'notif-drop__item--' + n.type"
                            >
                                <!-- Icon -->
                                <div class="notif-drop__icon" :class="'notif-drop__icon--' + n.type">
                                    <!-- Partner -->
                                    <svg v-if="n.type === 'partner_pending'" width="15" height="15" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                                    </svg>
                                    <!-- Payment -->
                                    <svg v-else-if="n.type === 'payment_pending'" width="15" height="15" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                </div>

                                <!-- Content -->
                                <div class="notif-drop__content">
                                    <p class="notif-drop__item-title">{{ n.title }}</p>
                                    <p class="notif-drop__item-msg">{{ n.message }}</p>
                                    <span class="notif-drop__item-time">{{ timeAgo(n.created_at) }}</span>
                                </div>

                                <!-- Actions -->
                                <div class="notif-drop__item-actions">
                                    <router-link
                                        :to="{ name: n.route }"
                                        class="notif-drop__review"
                                        @click="dropdownOpen = false"
                                        title="Review"
                                    >
                                        <svg width="13" height="13" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                                        </svg>
                                    </router-link>
                                    <button
                                        class="notif-drop__dismiss"
                                        @click.stop="dashStore.dismiss(n.id)"
                                        title="Dismiss"
                                    >
                                        <svg width="11" height="11" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                                        </svg>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Footer count if more than 8 -->
                        <div
                            v-if="dashStore.notificationCount > 8"
                            class="notif-drop__footer"
                        >
                            <router-link :to="{ name: 'admin.dashboard' }" @click="dropdownOpen = false">
                                +{{ dashStore.notificationCount - 8 }} more — View all on dashboard
                            </router-link>
                        </div>
                    </div>
                </Transition>
            </div>

            <button class="user-btn">
                <img src="@/assets/images/icon/user.png" alt="User" class="user-avatar">
                <div class="user-info">
                    <span class="user-name">Admin</span>
                    <span class="user-role">Administrator</span>
                </div>
                <img src="@/assets/images/icon/down.png" alt="Dropdown" class="dropdown-icon">
            </button>
        </div>
    </header>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { useDashboardStore } from '@/modules/admin/stores/dashboard/dashboardStore'

const dashStore    = useDashboardStore()
const dropdownOpen = ref(false)
const notifWrapRef = ref<HTMLElement | null>(null)

const toggleDropdown = () => {
    dropdownOpen.value = !dropdownOpen.value
    // Fetch nếu chưa có data
    if (dropdownOpen.value && !dashStore.stats && !dashStore.loading) {
        dashStore.fetch()
    }
}

const timeAgo = (iso: string): string => {
    const diff  = Date.now() - new Date(iso).getTime()
    const mins  = Math.floor(diff / 60000)
    const hours = Math.floor(diff / 3600000)
    const days  = Math.floor(diff / 86400000)
    if (mins < 1)   return 'just now'
    if (mins < 60)  return `${mins}m ago`
    if (hours < 24) return `${hours}h ago`
    return `${days}d ago`
}

// Close on outside click
const onClickOutside = (e: MouseEvent) => {
    if (notifWrapRef.value && !notifWrapRef.value.contains(e.target as Node)) {
        dropdownOpen.value = false
    }
}

onMounted(() => document.addEventListener('click', onClickOutside))
onBeforeUnmount(() => document.removeEventListener('click', onClickOutside))
</script>

<style scoped>
.header {
    height: 70px;
    width: 98%;
    top: 20px;
    margin: 1%;
    border-radius: 14px;
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    border: 1px solid rgba(0,170,255,0.65);
    box-shadow:
        0 0 8px rgba(0,170,255,0.7),
        0 0 16px rgba(0,170,255,0.55),
        0 0 24px rgba(0,170,255,0.35),
        0 8px 25px rgba(0,0,0,0.45);
    animation: neonPulse 1.8s infinite ease-in-out;
    
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 20px;
    position: relative;
    z-index: 10;
    font-family: 'Afacad', sans-serif;
}

/* Left section */
.header-left {
    display: flex;
    align-items: center;
    gap: 15px;
    flex: 1;
}

.menu-btn {
    background: transparent;
    border: 1px solid rgba(0,170,255,0.4);
    border-radius: 10px;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s ease;
}

.menu-btn:hover {
    background: rgba(0,170,255,0.15);
    border-color: rgba(0,170,255,0.8);
    box-shadow: 0 0 10px rgba(0,170,255,0.4);
}

.menu-btn img {
    width: 20px;
    height: 20px;
    filter: brightness(0) invert(1);
}

.logo-section {
    display: flex;
    align-items: center;
    gap: 10px;
}

.logo-icon {
    height: 32px;
    width: auto;
}

.logo-text {
    font-size: 1.5rem;
    font-weight: 700;
    background: white;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    text-shadow: 0 0 10px rgba(0,170,255,0.3);
}

/* Center section - Search */
.header-center {
    flex: 2;
    display: flex;
    justify-content: center;
}

.search-container {
    position: relative;
    width: 100%;
    max-width: 500px;
}

.search-icon {
    position: absolute;
    left: 15px;
    top: 50%;
    transform: translateY(-50%);
    width: 18px;
    height: 18px;
    filter: brightness(0) invert(0.7);
}

.search-input {
    width: 100%;
    height: 42px;
    padding: 0 20px 0 45px;
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(0,170,255,0.4);
    border-radius: 12px;
    color: white;
    font-size: 14px;
    font-family: 'Afacad', sans-serif;
    transition: all 0.3s ease;
}

.search-input:focus {
    outline: none;
    border-color: rgba(0,170,255,0.8);
    background: rgba(255,255,255,0.1);
    box-shadow: 0 0 15px rgba(0,170,255,0.3);
}

.search-input::placeholder {
    color: rgba(255,255,255,0.5);
}

/* Right section */
.header-right {
    display: flex;
    align-items: center;
    gap: 20px;
    flex: 1;
    justify-content: flex-end;
}

.notification-btn {
    position: relative;
    background: transparent;
    border: 1px solid rgba(0,170,255,0.4);
    border-radius: 10px;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s ease;
}

.notification-btn:hover {
    background: rgba(0,170,255,0.15);
    border-color: rgba(0,170,255,0.8);
    box-shadow: 0 0 10px rgba(0,170,255,0.4);
}

.notification-btn img {
    width: 20px;
    height: 20px;
    filter: brightness(0) invert(1);
}

.notification-badge {
    position: absolute;
    top: -5px;
    right: -5px;
    background: #ff4757;
    color: white;
    font-size: 10px;
    font-weight: bold;
    width: 18px;
    height: 18px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 2px solid rgba(0,170,255,0.65);
}

.user-btn {
    display: flex;
    align-items: center;
    gap: 12px;
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(0,170,255,0.4);
    border-radius: 12px;
    padding: 6px 15px;
    cursor: pointer;
    transition: all 0.3s ease;
}

.user-btn:hover {
    background: rgba(0,170,255,0.15);
    border-color: rgba(0,170,255,0.8);
    box-shadow: 0 0 15px rgba(0,170,255,0.3);
}

.user-avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    border: 2px solid rgba(0,170,255,0.6);
}

.user-info {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}

.user-name {
    color: white;
    font-weight: 600;
    font-size: 14px;
}

.user-role {
    color: rgba(255,255,255,0.6);
    font-size: 11px;
    margin-top: 2px;
}

.dropdown-icon {
    width: 16px;
    height: 16px;
    filter: brightness(0) invert(0.6);
    transition: transform 0.3s ease;
}

.user-btn:hover .dropdown-icon {
    transform: rotate(180deg);
}

/* Neon pulse animation */

/* Responsive adjustments */
@media (max-width: 1200px) {
    .header-center {
        flex: 1.5;
    }
    
    .search-container {
        max-width: 400px;
    }
}

@media (max-width: 768px) {
    .header {
        padding: 0 15px;
    }
    
    .logo-text {
        display: none;
    }
    
    .search-container {
        max-width: 300px;
    }
    
    .user-info {
        display: none;
    }
    
    .user-btn {
        padding: 6px 10px;
    }
}

/* ── Notification dropdown ──────────────────────────────────────────────────── */
.notif-wrap {
    position: relative;
}

.notification-btn--active {
    background: rgba(0,170,255,0.15) !important;
    border-color: rgba(0,170,255,0.8) !important;
    box-shadow: 0 0 10px rgba(0,170,255,0.4) !important;
}

/* Badge pulse animation */
.badge-pulse {
    animation: badgePulse 2s ease-in-out infinite;
}

@keyframes badgePulse {
    0%, 100% { box-shadow: 0 0 0 0 rgba(255,71,87,0.6); }
    50%       { box-shadow: 0 0 0 5px rgba(255,71,87,0); }
}

/* Dropdown panel */
.notif-dropdown {
    position: absolute;
    top: calc(100% + 12px);
    right: 0;
    width: 360px;
    background: rgba(10, 15, 28, 0.97);
    border: 1px solid rgba(0,170,255,0.35);
    border-radius: 16px;
    box-shadow:
        0 0 20px rgba(0,170,255,0.15),
        0 20px 60px rgba(0,0,0,0.6);
    backdrop-filter: blur(20px);
    overflow: hidden;
    z-index: 9999;
}

/* Dropdown header */
.notif-drop__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 14px 16px 12px;
    border-bottom: 1px solid rgba(255,255,255,0.07);
}

.notif-drop__title {
    font-size: 13px;
    font-weight: 700;
    color: rgba(255,255,255,0.9);
    letter-spacing: 0.02em;
}

.notif-drop__actions {
    display: flex;
    align-items: center;
    gap: 10px;
}

.notif-drop__mark-all {
    font-size: 11px;
    color: rgba(255,255,255,0.35);
    background: none;
    border: none;
    cursor: pointer;
    padding: 0;
    transition: color 0.2s;
}
.notif-drop__mark-all:hover { color: rgba(255,255,255,0.7); }

.notif-drop__view-all {
    font-size: 11px;
    color: #00aaff;
    text-decoration: none;
    transition: opacity 0.2s;
}
.notif-drop__view-all:hover { opacity: 0.75; }

/* Loading */
.notif-drop__loading {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    padding: 28px 16px;
    color: rgba(255,255,255,0.35);
    font-size: 13px;
}

.notif-drop__spinner {
    width: 18px;
    height: 18px;
    border: 2px solid rgba(0,170,255,0.2);
    border-top-color: #00aaff;
    border-radius: 50%;
    animation: spin 0.7s linear infinite;
}

@keyframes spin { to { transform: rotate(360deg); } }

/* Empty */
.notif-drop__empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    padding: 32px 16px;
    color: rgba(255,255,255,0.2);
    font-size: 13px;
}

/* List */
.notif-drop__list {
    max-height: 380px;
    overflow-y: auto;
    padding: 6px 0;
}

.notif-drop__list::-webkit-scrollbar { width: 4px; }
.notif-drop__list::-webkit-scrollbar-track { background: transparent; }
.notif-drop__list::-webkit-scrollbar-thumb { background: rgba(0,170,255,0.2); border-radius: 2px; }

/* Item */
.notif-drop__item {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    padding: 10px 14px;
    transition: background 0.15s;
    position: relative;
    border-left: 2px solid transparent;
}

.notif-drop__item--partner_pending { border-left-color: #a78bfa; }
.notif-drop__item--payment_pending  { border-left-color: #fbbf24; }

.notif-drop__item:hover { background: rgba(255,255,255,0.04); }

/* Icon */
.notif-drop__icon {
    width: 32px;
    height: 32px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    margin-top: 1px;
}

.notif-drop__icon--partner_pending {
    background: rgba(167,139,250,0.12);
    color: #a78bfa;
}

.notif-drop__icon--payment_pending {
    background: rgba(251,191,36,0.12);
    color: #fbbf24;
}

/* Content */
.notif-drop__content {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 2px;
}

.notif-drop__item-title {
    font-size: 12px;
    font-weight: 600;
    color: rgba(255,255,255,0.85);
    margin: 0;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.notif-drop__item-msg {
    font-size: 11px;
    color: rgba(255,255,255,0.4);
    margin: 0;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.notif-drop__item-time {
    font-size: 10px;
    color: rgba(255,255,255,0.22);
}

/* Item actions */
.notif-drop__item-actions {
    display: flex;
    align-items: center;
    gap: 4px;
    flex-shrink: 0;
    opacity: 0;
    transition: opacity 0.15s;
}

.notif-drop__item:hover .notif-drop__item-actions { opacity: 1; }

.notif-drop__review {
    width: 26px;
    height: 26px;
    border-radius: 6px;
    background: rgba(0,170,255,0.12);
    color: #00aaff;
    display: flex;
    align-items: center;
    justify-content: center;
    text-decoration: none;
    transition: background 0.15s;
}
.notif-drop__review:hover { background: rgba(0,170,255,0.25); }

.notif-drop__dismiss {
    width: 26px;
    height: 26px;
    border-radius: 6px;
    background: rgba(255,255,255,0.05);
    color: rgba(255,255,255,0.3);
    border: none;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.15s;
}
.notif-drop__dismiss:hover {
    background: rgba(248,113,113,0.12);
    color: #f87171;
}

/* Footer */
.notif-drop__footer {
    padding: 10px 16px;
    border-top: 1px solid rgba(255,255,255,0.06);
    text-align: center;
}

.notif-drop__footer a {
    font-size: 12px;
    color: #00aaff;
    text-decoration: none;
    transition: opacity 0.2s;
}
.notif-drop__footer a:hover { opacity: 0.75; }

/* Transition */
.notif-drop-enter-active { transition: opacity 0.18s ease, transform 0.18s ease; }
.notif-drop-leave-active { transition: opacity 0.14s ease, transform 0.14s ease; }
.notif-drop-enter-from   { opacity: 0; transform: translateY(-8px) scale(0.97); }
.notif-drop-leave-to     { opacity: 0; transform: translateY(-6px) scale(0.97); }
</style>
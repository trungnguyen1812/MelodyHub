<template>
  <div class="layout-container min-h-screen bg-gray-900 text-white">
    <!-- Header -->
    <header
      class="fixed top-0 left-0 w-full flex items-center justify-between px-4 sm:px-6 h-16 bg-transparent backdrop-blur-sm z-50">
      <!-- Left Side: Logo + Menu -->
      <div class="flex items-center space-x-4 sm:space-x-6">
        <!-- Logo -->
        <div class="flex items-center h-10 w-24 sm:h-16 sm:w-32 flex-shrink-0">
          <router-link to="/">
            <img :src="logo" alt="Melody Logo" class="h-full w-full object-contain" />
          </router-link>
        </div>
        <!-- Navigation (Hidden on mobile) -->
        <nav class="hidden sm:flex items-center space-x-4">
          <router-link to="/"
            class="text-sm font-medium text-white hover:text-cyan-400 drop-shadow-[0_0_10px_#22d3ee] transition-colors duration-200">
            Home
          </router-link>
          <div class="relative" ref="dropdown">
            <a href="#"
              class="text-sm font-medium text-white hover:text-cyan-400 drop-shadow-[0_0_10px_#22d3ee] transition-colors duration-200 flex items-center"
              @click.prevent="toggleDropdown" aria-haspopup="true" :aria-expanded="isDropdownOpen">
              Library
              <span class="ml-1 text-xs">▼</span>
            </a>
            <!-- Dropdown menu -->
            <div v-show="isDropdownOpen"
              class="absolute left-0 mt-2 w-40 bg-gray-800/75 text-white rounded-lg shadow-lg z-50 transition-all duration-200"
              role="menu">
              <router-link to="/albums/allList"
                class="block px-4 py-2 text-sm hover:text-cyan-400 drop-shadow-[0_0_10px_#22d3ee] hover:text-white transition-colors duration-200"
                role="menuitem">
                Albums
              </router-link>
              <router-link to="/music/new"
                class="block px-4 py-2 text-sm hover:text-cyan-400 drop-shadow-[0_0_10px_#22d3ee] hover:text-white transition-colors duration-200"
                role="menuitem">
                Music
              </router-link>
              <router-link to="/playlist/allList"
                class="block px-4 py-2 text-sm hover:text-cyan-400 drop-shadow-[0_0_10px_#22d3ee] hover:text-white transition-colors duration-200"
                role="menuitem">
                Playlist
              </router-link>
            </div>
          </div>
          <button @click="goToCollaborations"
            class="text-sm font-medium text-white hover:text-cyan-400 drop-shadow-[0_0_10px_#22d3ee] transition-colors duration-200 cursor-pointer">
            Collaborations
          </button>
        </nav>
      </div>

      <!-- Center: Search Bar -->
      <div class="flex-1 max-w-md mx-4 hidden sm:block relative" ref="searchWrapRef">
        <div class="search-box">
          <svg class="search-icon" width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
          </svg>
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search songs, artists..."
            class="search-input"
            @focus="searchFocused = true"
            @keydown.escape="closeSearch"
            @keydown.enter="goToFirstResult"
            autocomplete="off"
          />
          <button v-if="searchQuery" class="search-clear" @click="clearSearch">
            <svg width="12" height="12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
          </button>
        </div>

        <!-- Live search dropdown -->
        <Transition name="search-drop">
          <div
            v-if="searchFocused && (searchQuery.length >= 1)"
            class="search-dropdown"
          >
            <!-- Loading -->
            <div v-if="searchLoading" class="search-state">
              <div class="search-spinner" />
              <span>Searching...</span>
            </div>

            <!-- No results -->
            <div v-else-if="searchResults.length === 0 && searchQuery.length >= 2" class="search-state">
              <svg width="32" height="32" fill="none" stroke="currentColor" viewBox="0 0 24 24" style="opacity:0.3">
                <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
              </svg>
              <span>No results for "{{ searchQuery }}"</span>
            </div>

            <!-- Hint when only 1 char -->
            <div v-else-if="searchQuery.length < 2" class="search-state search-state--hint">
              <span>Type at least 2 characters...</span>
            </div>

            <!-- Results -->
            <template v-else>
              <div class="search-section-label">Songs · {{ searchResults.length }} found</div>
              <div
                v-for="song in searchResults"
                :key="song.id"
                class="search-item"
                @click="goToSong(song)"
              >
                <!-- Cover -->
                <div class="search-item__cover">
                  <img
                    v-if="song.cover_url"
                    :src="getFullImageUrl(song.cover_url)"
                    :alt="song.title"
                    @error="(e) => ((e.target as HTMLImageElement).style.display='none')"
                  />
                  <div v-else class="search-item__cover-fallback">
                    <svg width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3"/>
                    </svg>
                  </div>
                </div>

                <!-- Info -->
                <div class="search-item__info">
                  <span class="search-item__title" v-html="highlight(song.title, searchQuery)" />
                  <div class="search-item__meta">
                    <!-- Artist avatar -->
                    <img
                      v-if="song.artist?.avatar_url"
                      :src="getFullImageUrl(song.artist.avatar_url)"
                      class="search-item__artist-avatar"
                      :alt="song.artist.name"
                    />
                    <span class="search-item__artist" v-html="highlight(song.artist?.name ?? 'Unknown', searchQuery)" />
                    <span class="search-item__dot">·</span>
                    <span class="search-item__duration">{{ song.duration_format }}</span>
                  </div>
                </div>

                <!-- Play icon on hover -->
                <div class="search-item__play">
                  <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M8 5v14l11-7z"/>
                  </svg>
                </div>
              </div>

              <!-- View all -->
              <div class="search-view-all" @click="viewAllResults">
                View all results for "{{ searchQuery }}"
                <svg width="12" height="12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                </svg>
              </div>
            </template>
          </div>
        </Transition>
      </div>

      <!-- Right Side: Auth + Hamburger Menu -->
      <div class="flex items-center space-x-3">
        <!-- Auth Buttons (Hidden on mobile) -->
        <!-- Display the Try for Free button if you are not logged in. -->
        <div class="hidden sm:flex space-x-3" v-if="!authStore.isAuthenticated">
          <button @click="handleLogin"
            class="text-cyan-400 drop-shadow-[0_0_10px_#22d3ee] px-3 py-1.5 rounded-md hover:bg-white/10 transition-colors duration-200 text-sm font-medium"
            aria-label="Register">
            Try for Free
          </button>
        </div>

        <!-- If you are already logged in, please display your avatar or menu. -->
        <div class="hidden sm:flex relative" ref="profileDropdownRef" v-else>
          <!-- Trigger dropdown -->
          <button @click.prevent="toggleProfileDropdown"
              class="flex items-center space-x-2 text-white text-sm font-medium hover:text-cyan-400 drop-shadow-[0_0_10px_#22d3ee] transition-colors duration-200 focus:outline-none">
              <div class="relative">
                  <!-- Chỉ hiển thị 1 avatar, có frame VIP nếu là VIP -->
                  <div class="relative" :class="{'vip-frame': subscriptionStore.isVip}">
                      <div class="vip-frame-inner" v-if="subscriptionStore.isVip">
                          <!-- Avatar VIP: ảnh nếu có, fallback theo tên -->
                          <img
                              v-if="authStore.user?.avatar_url && authStore.user.avatar_url !== ''"
                              :src="getFullImageUrl(authStore.user.avatar_url)"
                              alt="avatar"
                              class="w-full h-full rounded-full object-cover"
                              @error="(e) => { (e.target as HTMLImageElement).style.display='none'; (e.target as HTMLImageElement).nextElementSibling?.removeAttribute('style') }"
                          />
                          <div
                              v-else
                              class="nav-avatar-fallback"
                              :style="{ backgroundColor: getAvatarColor(authStore.user?.name) }"
                          >{{ getInitial(authStore.user?.name) }}</div>
                          <div class="vip-crown-frame">
                              👑
                          </div>
                      </div>

                      <!-- Avatar cho non-VIP: ảnh nếu có, fallback theo tên -->
                      <template v-else>
                          <img
                              v-if="authStore.user?.avatar_url && authStore.user.avatar_url !== ''"
                              :src="getFullImageUrl(authStore.user.avatar_url)"
                              alt="avatar"
                              class="w-7 h-7 rounded-full object-cover"
                              @error="(e) => { (e.target as HTMLImageElement).style.display='none' }"
                          />
                          <div
                              v-else
                              class="nav-avatar-fallback"
                              :style="{ backgroundColor: getAvatarColor(authStore.user?.name) }"
                          >{{ getInitial(authStore.user?.name) }}</div>
                      </template>
                  </div>
              </div>
              <span>{{ authStore.user?.name?.split(' ').pop() || 'User' }}</span>
              <span class="ml-1 text-xs">▼</span>
          </button>


          <!-- Dropdown menu -->
          <div v-show="dropdownProfileOpen"
            class="absolute right-[-70px] mt-[48px] w-44 bg-[#161f2b]/90 text-white rounded-lg shadow-lg z-50 transition-all duration-200 origin-top overflow-hidden"
          >
            <button @click="profilePage"
              class="block w-full text-left px-4 py-2 text-sm text-gray-300 hover:text-[#22d3ee] hover:bg-white/10 transition-all duration-200"
              role="menuitem">
              Profile
            </button>
            
            <button v-if="authStore.permissionLoaded && authStore.isAdmin" @click="adminPage"
              class="block w-full text-left px-4 py-2 text-sm text-gray-300 hover:text-[#22d3ee] hover:bg-white/10 transition-all duration-200"
              role="menuitem">
              Admin
            </button>
            
            <hr class="border-gray-700 my-1">
            
            <button @click="handleLogout"
              class="block w-full text-left px-4 py-2 text-sm text-red-400 hover:text-red-300 hover:bg-white/10 transition-all duration-200"
              role="menuitem">
              Logout
            </button>
          </div>
        </div>
        <button class="Btn_vip" v-if="!subscriptionStore.isVip" @click="ToUpgrade">
          <svg viewBox="0 0 576 512" height="1em" class="logoIcon">
            <path
              d="M309 106c11.4-7 19-19.7 19-34c0-22.1-17.9-40-40-40s-40 17.9-40 40c0 14.4 7.6 27 19 34L209.7 220.6c-9.1 18.2-32.7 23.4-48.6 10.7L72 160c5-6.7 8-15 8-24c0-22.1-17.9-40-40-40S0 113.9 0 136s17.9 40 40 40c.2 0 .5 0 .7 0L86.4 427.4c5.5 30.4 32 52.6 63 52.6H426.6c30.9 0 57.4-22.1 63-52.6L535.3 176c.2 0 .5 0 .7 0c22.1 0 40-17.9 40-40s-17.9-40-40-40s-40 17.9-40 40c0 9 3 17.3 8 24l-89.1 71.3c-15.9 12.7-39.5 7.5-48.6-10.7L309 106z">
            </path>
          </svg>
          GO PREMIUM
        </button>
        <!-- Hamburger Menu (Visible on mobile) -->
        <button class="sm:hidden text-white focus:outline-none" @click="toggleMobileMenu"
          aria-label="Toggle mobile menu">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
          </svg>
        </button>
      </div>

      <!-- Mobile Menu (Visible when toggled) -->
      <div v-show="isMobileMenuOpen"
        class="sm:hidden absolute top-16 left-0 w-full bg-gray-800 p-4 flex flex-col space-y-4">
        <input type="text" placeholder="Search music..."
          class="w-full px-4 py-2 bg-gray-700 text-white rounded-full focus:outline-none focus:ring-2 focus:ring-blue-400 text-sm" />
        <a href="#" class="text-sm font-medium text-white hover:text-blue-400">
          Home
        </a>
        <a href="#" class="text-sm font-medium text-white hover:text-blue-400">
          Browse
        </a>
        <button @click="handleRegister"
          class="bg-blue-600 text-white px-3 py-1.5 rounded-md hover:bg-blue-700 text-sm font-medium">
          Try for Free
        </button>

        <button @click="handleLogin"
          class="bg-gray-700 text-white px-3 py-1.5 rounded-md hover:bg-gray-600 text-sm font-medium">
          Sign In
        </button>
      </div>
    </header>

    <!-- Main Content -->
    <main class="main-content pt-20 pb-6 px-4 sm:px-6 bg-gradient-to-b from-gray-900 to-gray-800">
      <router-view />
    </main>

    <!-- Footer -->
    <footer class="footer sm:footer-horizontal bg-neutral text-neutral-content items-center p-4">
      <aside class="grid-flow-col items-center">
        <div class="flex items-center h-10 w-24 sm:h-16 sm:w-32 flex-shrink-0">
          <router-link to="/">
            <img :src="logo" alt="Melody Logo" class="h-full w-full object-contain" />
          </router-link>
        </div>
        <p>Copyright © {new Date().getFullYear()} - All right reserved</p>
      </aside>
      <nav class="grid-flow-col gap-4 md:place-self-center md:justify-self-end">
        <a>
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" class="fill-current">
            <path
              d="M24 4.557c-.883.392-1.832.656-2.828.775 1.017-.609 1.798-1.574 2.165-2.724-.951.564-2.005.974-3.127 1.195-.897-.957-2.178-1.555-3.594-1.555-3.179 0-5.515 2.966-4.797 6.045-4.091-.205-7.719-2.165-10.148-5.144-1.29 2.213-.669 5.108 1.523 6.574-.806-.026-1.566-.247-2.229-.616-.054 2.281 1.581 4.415 3.949 4.89-.693.188-1.452.232-2.224.084.626 1.956 2.444 3.379 4.6 3.419-2.07 1.623-4.678 2.348-7.29 2.04 2.179 1.397 4.768 2.212 7.548 2.212 9.142 0 14.307-7.721 13.995-14.646.962-.695 1.797-1.562 2.457-2.549z">
            </path>
          </svg>
        </a>
        <a>
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" class="fill-current">
            <path
              d="M19.615 3.184c-3.604-.246-11.631-.245-15.23 0-3.897.266-4.356 2.62-4.385 8.816.029 6.185.484 8.549 4.385 8.816 3.6.245 11.626.246 15.23 0 3.897-.266 4.356-2.62 4.385-8.816-.029-6.185-.484-8.549-4.385-8.816zm-10.615 12.816v-8l8 3.993-8 4.007z">
            </path>
          </svg>
        </a>
        <a>
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" class="fill-current">
            <path
              d="M9 8h-3v4h3v12h5v-12h3.642l.358-4h-4v-1.667c0-.955.192-1.333 1.115-1.333h2.885v-5h-3.808c-3.596 0-5.192 1.583-5.192 4.615v3.385z">
            </path>
          </svg>
        </a>
      </nav>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, onBeforeUnmount } from "vue";
import { useAuthStore, getFullImageUrl } from "@/store/authStore";
import { useRouter } from "vue-router";
import { useUserStore } from '@/modules/client/stores/users/UserStore';
import { useCheckPermission } from '@/composables/useCheckPermission'
import SongService from '@/modules/client/services/songs/songs.service'

const subscriptionStore = useUserStore();
const router = useRouter();
const authStore = useAuthStore();
const { goToCollaborations } = useCheckPermission()

// ── Live Search ───────────────────────────────────────────────────────────────
const searchQuery   = ref('')
const searchResults = ref<any[]>([])
const searchLoading = ref(false)
const searchFocused = ref(false)
const searchWrapRef = ref<HTMLElement | null>(null)

let searchTimer: ReturnType<typeof setTimeout> | null = null

watch(searchQuery, (val) => {
  if (searchTimer) clearTimeout(searchTimer)
  if (val.trim().length < 2) {
    searchResults.value = []
    return
  }
  searchLoading.value = true
  searchTimer = setTimeout(async () => {
    try {
      const res = await SongService.getAllSongs({ search: val.trim() })
      searchResults.value = res.data?.data ?? []
    } catch {
      searchResults.value = []
    } finally {
      searchLoading.value = false
    }
  }, 300)
})

const highlight = (text: string, query: string): string => {
  if (!query || !text) return text
  const escaped = query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
  return text.replace(new RegExp(`(${escaped})`, 'gi'), '<mark>$1</mark>')
}

const goToSong = (song: any) => {
  closeSearch()
  router.push({ name: 'client.song.detail', params: { id: song.id } })
}

const goToFirstResult = () => {
  if (searchResults.value.length > 0) goToSong(searchResults.value[0])
}

const viewAllResults = () => {
  closeSearch()
  router.push({ name: 'client.music.new', query: { search: searchQuery.value } })
}

const clearSearch = () => {
  searchQuery.value = ''
  searchResults.value = []
}

const closeSearch = () => {
  searchFocused.value = false
}

// ── Logout ────────────────────────────────────────────────────────────────────
const handleLogout = async () => {
  await authStore.logout();
  router.push({ name: "Login" });
};

const ToUpgrade = () => {
  router.push({ name: "client.user.upgrade" });
}

const isDropdownOpen      = ref(false);
const isMobileMenuOpen    = ref(false);
const dropdownProfileOpen = ref(false);
const profileDropdownRef  = ref<HTMLElement | null>(null);
const dropdown            = ref<HTMLElement | null>(null);

const logo = new URL(
  "../assets/images/logo/melody-high-resolution-logo-white.png",
  import.meta.url
).href;

const toggleDropdown        = () => { isDropdownOpen.value = !isDropdownOpen.value }
const toggleMobileMenu      = () => { isMobileMenuOpen.value = !isMobileMenuOpen.value }
const toggleProfileDropdown = () => { dropdownProfileOpen.value = !dropdownProfileOpen.value }

const handleRegister = () => { alert("Register clicked!") }
const handleLogin    = () => { router.push({ name: "Login" }) }

const handleClickOutside = (event: MouseEvent) => {
  if (dropdown.value && !dropdown.value.contains(event.target as Node)) {
    isDropdownOpen.value = false
  }
  if (profileDropdownRef.value && !profileDropdownRef.value.contains(event.target as Node)) {
    dropdownProfileOpen.value = false
  }
  if (searchWrapRef.value && !searchWrapRef.value.contains(event.target as Node)) {
    searchFocused.value = false
  }
}

const adminPage   = () => { router.push({ name: "admin.dashboard" }) }
const profilePage = () => { router.push({ name: "client.profile" }) }

// ── Avatar helpers ────────────────────────────────────────────────────────────
const getInitial = (name?: string) => {
  if (!name) return '?'
  return name.trim().charAt(0).toUpperCase()
}

const getAvatarColor = (name?: string) => {
  if (!name) return '#6b7280'
  const colors = [
    '#f87171', '#fb923c', '#fbbf24', '#34d399',
    '#60a5fa', '#a78bfa', '#f472b6', '#2dd4bf',
    '#818cf8', '#f43f5e',
  ]
  let hash = 0
  for (let i = 0; i < name.length; i++) {
    hash = ((hash << 5) - hash) + name.charCodeAt(i)
    hash |= 0
  }
  return colors[Math.abs(hash) % colors.length]
}

onMounted(() => { document.addEventListener("click", handleClickOutside) })
onBeforeUnmount(() => { document.removeEventListener("click", handleClickOutside) })
</script>

<style scoped>
/* Tailwind CSS is used in template, so minimal custom CSS */

header {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 80px;
  background: rgba(7, 13, 20, 0.3);
  /* nền ánh xanh có độ trong suốt */
  backdrop-filter: blur(10px);
  /* hiệu ứng mờ đẹp hơn (optional) */
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  /* luôn nằm trên */
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  /* line mờ dưới */
}

.main-content {
  grid-area: main;
  background: linear-gradient(to bottom, #000000, #0f2024);
  height: auto;
}

.footer {
  grid-area: footer;
}

/* From Uiverse.io by vinodjangid07 */
.Btn_vip {
  width: auto;
  padding: 10px;
  height: 40px;
  border: none;
  border-radius: 5px;
  background: linear-gradient(to right, #bf953f, #fcf6ba, #b38728, #fbf5b7, #aa771c);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  font-size: 0.8em;
  color: rgb(121, 103, 3);
  font-weight: 600;
  cursor: pointer;
  position: relative;
  z-index: 2;
  transition-duration: 3s;
  box-shadow: 5px 5px 10px rgba(0, 0, 0, 0.144);
  background-size: 200% 200%;
}

.logoIcon path {
  fill: rgb(121, 103, 3);
}

.Btn_vip:hover {
  transform: scale(0.95);
  transition-duration: 3s;
  animation: gradient 5s ease infinite;
  background-position: right;
}

.vip-frame {
  position: relative;
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 3px;
  background: linear-gradient(45deg,
      #facc15,
      #fbbf24,
      #f59e0b,
      #facc15);
  border-radius: 50%;
  box-shadow:
    0 0 15px rgba(250, 204, 21, 0.6),
    inset 0 0 10px rgba(255, 255, 255, 0.3);
}

.vip-frame-inner {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  overflow: hidden;
  background: white;
  padding: 2px;
}

.vip-frame-inner img {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  object-fit: cover;
}

.vip-crown-frame {
  position: absolute;
  top: -6px;
  right: -6px;
  font-size: 14px;
  width: 22px;
  height: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #fffefc, #ffffff);
  color: white;
  border-radius: 50%;
  box-shadow:
    0 2px 8px rgba(217, 119, 6, 0.6),
    0 0 0 2px white;

  z-index: 10;
}

@keyframes frameGlow {

  0%,
  100% {
    box-shadow:
      0 0 15px rgba(250, 204, 21, 0.6),
      inset 0 0 10px rgba(255, 255, 255, 0.3);
  }

  50% {
    box-shadow:
      0 0 25px rgba(250, 204, 21, 0.9),
      0 0 30px rgba(250, 204, 21, 0.4),
      inset 0 0 15px rgba(255, 255, 255, 0.4);
  }
}

/* ── Live Search ─────────────────────────────────────────────────────────── */
.search-box {
  position: relative;
  display: flex;
  align-items: center;
}

.search-icon {
  position: absolute;
  left: 14px;
  color: rgba(255,255,255,0.35);
  pointer-events: none;
  flex-shrink: 0;
}

.search-input {
  width: 100%;
  background: rgba(255,255,255,0.07);
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 24px;
  padding: 9px 36px 9px 36px;
  font-size: 13px;
  color: rgba(255,255,255,0.9);
  outline: none;
  transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
  font-family: inherit;
}

.search-input:focus {
  border-color: rgba(0,198,255,0.5);
  background: rgba(0,198,255,0.06);
  box-shadow: 0 0 0 3px rgba(0,198,255,0.1);
}

.search-input::placeholder { color: rgba(255,255,255,0.28); }

.search-clear {
  position: absolute;
  right: 12px;
  background: rgba(255,255,255,0.1);
  border: none;
  color: rgba(255,255,255,0.5);
  width: 18px; height: 18px;
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  cursor: pointer;
  transition: all 0.15s;
}
.search-clear:hover { background: rgba(255,255,255,0.2); color: #fff; }

/* Dropdown */
.search-dropdown {
  position: absolute;
  top: calc(100% + 8px);
  left: 0; right: 0;
  background: #111827;
  border: 1px solid rgba(255,255,255,0.1);
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0,0,0,0.6), 0 0 0 1px rgba(0,198,255,0.08);
  z-index: 9999;
  max-height: 420px;
  overflow-y: auto;
}

.search-dropdown::-webkit-scrollbar { width: 4px; }
.search-dropdown::-webkit-scrollbar-track { background: transparent; }
.search-dropdown::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 2px; }

.search-section-label {
  padding: 10px 16px 6px;
  font-size: 10px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: rgba(255,255,255,0.3);
}

/* State (loading / empty / hint) */
.search-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 28px 16px;
  color: rgba(255,255,255,0.35);
  font-size: 13px;
}

.search-state--hint { padding: 14px 16px; flex-direction: row; justify-content: center; }

.search-spinner {
  width: 20px; height: 20px;
  border: 2px solid rgba(255,255,255,0.1);
  border-top-color: #00c6ff;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* Result item */
.search-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 16px;
  cursor: pointer;
  transition: background 0.15s;
  position: relative;
}

.search-item:hover { background: rgba(255,255,255,0.05); }
.search-item:hover .search-item__play { opacity: 1; }

.search-item__cover {
  width: 44px; height: 44px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
  background: rgba(255,255,255,0.06);
  display: flex; align-items: center; justify-content: center;
}

.search-item__cover img {
  width: 100%; height: 100%;
  object-fit: cover;
  display: block;
}

.search-item__cover-fallback {
  color: rgba(255,255,255,0.2);
  display: flex; align-items: center; justify-content: center;
  width: 100%; height: 100%;
}

.search-item__info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.search-item__title {
  font-size: 13px;
  font-weight: 500;
  color: rgba(255,255,255,0.9);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.search-item__title :deep(mark) {
  background: transparent;
  color: #00c6ff;
  font-weight: 700;
}

.search-item__meta {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 11px;
  color: rgba(255,255,255,0.38);
}

.search-item__artist-avatar {
  width: 16px; height: 16px;
  border-radius: 50%;
  object-fit: cover;
  flex-shrink: 0;
}

.search-item__artist :deep(mark) {
  background: transparent;
  color: rgba(255,255,255,0.7);
  font-weight: 600;
}

.search-item__dot { opacity: 0.4; }

.search-item__duration { font-variant-numeric: tabular-nums; }

.search-item__play {
  width: 28px; height: 28px;
  border-radius: 50%;
  background: rgba(0,198,255,0.15);
  color: #00c6ff;
  display: flex; align-items: center; justify-content: center;
  opacity: 0;
  transition: opacity 0.15s;
  flex-shrink: 0;
}

/* View all */
.search-view-all {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  padding: 12px 16px;
  font-size: 12px;
  font-weight: 500;
  color: #00c6ff;
  cursor: pointer;
  border-top: 1px solid rgba(255,255,255,0.06);
  transition: background 0.15s;
}
.search-view-all:hover { background: rgba(0,198,255,0.06); }

/* Transition */
.search-drop-enter-active { transition: opacity 0.15s ease, transform 0.15s ease; }
.search-drop-leave-active { transition: opacity 0.1s ease, transform 0.1s ease; }
.search-drop-enter-from  { opacity: 0; transform: translateY(-6px); }
.search-drop-leave-to    { opacity: 0; transform: translateY(-4px); }

/* ── Nav Avatar Fallback ─────────────────────────────────────────────────── */
.nav-avatar-fallback {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 700;
  color: #fff;
  text-transform: uppercase;
  flex-shrink: 0;
}
</style>

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
          <div class="relative" ref="dropdownLibrary">
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
          <div class="relative" ref="dropdownCenter">
            <a href="#"
              class="text-sm font-medium text-white transition-all duration-200 flex items-center gap-1.5 px-3 py-1 rounded-md
                    border border-cyan-400/60 hover:border-cyan-400 hover:text-cyan-400
                    drop-shadow-[0_0_6px_rgba(34,211,238,0.3)] hover:drop-shadow-[0_0_10px_#22d3ee]
                    bg-cyan-400/5 hover:bg-cyan-400/10"
              @click.prevent="toggleDropdownCenter"
              aria-haspopup="true"
              :aria-expanded="isDropdownCenter">
              
              <!-- Icon nhạc -->
              <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5 flex-shrink-0" viewBox="0 0 24 24" fill="currentColor">
                <rect x="3" y="3" width="7" height="7" rx="1.5"/>
                <rect x="14" y="3" width="7" height="7" rx="1.5"/>
                <rect x="3" y="14" width="7" height="7" rx="1.5"/>
                <rect x="14" y="14" width="7" height="7" rx="1.5"/>
              </svg>

              MelodyHub Center

              <span class="text-xs opacity-70">▼</span>
            </a>
            <!-- Dropdown menu -->
            <div v-show="isDropdownCenter"
              class="center-dropdown absolute left-0 mt-2 text-white rounded-2xl shadow-2xl z-50 border border-white/10"
              role="menu">
              <!-- Header -->
              <div class="center-dropdown__header">Select a feature</div>

              <!-- Item 1: Copyright Registration -->
              <router-link to="/center/copyright-registration" class="center-dropdown__item" role="menuitem">
                <div class="center-dropdown__icon center-dropdown__icon--blue">
                  <svg width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                    <rect x="4" y="3" width="16" height="18" rx="2"/>
                    <path stroke-linecap="round" d="M8 7h8M8 11h8M8 15h5"/>
                    <circle cx="17" cy="16" r="3" fill="currentColor" stroke="none" opacity="0.3"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.5 16l1 1 2-2"/>
                  </svg>
                </div>
                <div class="center-dropdown__content">
                  <div class="center-dropdown__title">
                    Copyright Registration
                    <span class="center-dropdown__badge center-dropdown__badge--free">Free</span>
                  </div>
                  <div class="center-dropdown__desc">
                    Step-by-step guide to protect your work on MelodyHub.
                  </div>
                </div>
                <svg class="center-dropdown__arrow" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7"/>
                </svg>
              </router-link>

              <!-- Item 2: Copyright Violation Report -->
              <router-link to="/center/copyright-report" class="center-dropdown__item" role="menuitem">
                <div class="center-dropdown__icon center-dropdown__icon--red">
                  <svg width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="9"/>
                    <line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/>
                  </svg>
                </div>
                <div class="center-dropdown__content">
                  <div class="center-dropdown__title">
                    Copyright Violation Report
                    <span class="center-dropdown__badge center-dropdown__badge--new">New</span>
                  </div>
                  <div class="center-dropdown__desc">
                    Detected duplicate songs? AI auto-comparison and report submission to MelodyHub for review.
                  </div>
                </div>
                <svg class="center-dropdown__arrow" width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7"/>
                </svg>
              </router-link>

              <!-- Footer -->
              <div class="center-dropdown__footer">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                  <circle cx="12" cy="12" r="10"/>
                  <line x1="12" y1="8" x2="12" y2="12"/>
                  <line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
                Need help? Contact MelodyHub at
                <a href="mailto:support@melodyhub.vn" class="center-dropdown__footer-link">support@melodyhub.vn</a>
              </div>
            </div>
          </div>
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
        <!-- Notification Bell (chỉ hiện khi đã login) -->
        <div v-if="authStore.isAuthenticated" class="relative hidden sm:block" ref="notifDropdownRef">
          <button
            class="client-notif-btn"
            :class="{ 'client-notif-btn--active': notifDropdownOpen }"
            @click="toggleNotifDropdown"
            aria-label="Notifications"
          >
            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
            </svg>
            <span v-if="unreadCount > 0" class="client-notif-badge" :class="{ 'badge-pulse': unreadCount > 0 }">
              {{ unreadCount > 9 ? '9+' : unreadCount }}
            </span>
          </button>

          <!-- Notification Dropdown -->
          <Transition name="notif-drop">
            <div v-if="notifDropdownOpen" class="client-notif-panel">

              <!-- Header -->
              <div class="cnotif__header">
                <div class="cnotif__header-left">
                  <span class="cnotif__title">Copyright</span>
                  <span v-if="unreadCount > 0" class="cnotif__unread-badge">{{ unreadCount }} unread</span>
                </div>
                <button v-if="unreadCount > 0" class="cnotif__mark-all" @click.stop="markAllRead">
                  Mark all read
                </button>
              </div>

              <!-- Tabs -->
              <div class="cnotif__tabs">
                <button
                  v-for="tab in notifTabs"
                  :key="tab.key"
                  class="cnotif__tab"
                  :class="{ 'cnotif__tab--active': activeNotifTab === tab.key }"
                  @click.stop="activeNotifTab = tab.key"
                >
                  {{ tab.label }}
                </button>
              </div>

              <!-- Loading -->
              <div v-if="notifLoading" class="cnotif__state">
                <div class="cnotif__spinner"></div>
                <span>Loading...</span>
              </div>

              <!-- Empty -->
              <div v-else-if="filteredNotifications.length === 0" class="cnotif__state">
                <svg width="32" height="32" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24" style="opacity:0.2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <span>All caught up!</span>
              </div>

              <!-- List -->
              <div v-else class="cnotif__list">
                <div
                  v-for="n in filteredNotifications"
                  :key="n.id"
                  class="cnotif__item"
                  :class="[
                    'cnotif__item--' + n.type,
                    { 'cnotif__item--unread': !n.is_read }
                  ]"
                  @click="handleNotifClick(n)"
                >
                  <!-- Icon -->
                  <div class="cnotif__icon" :class="notifIconClass(n.type)">
                    <!-- copyright_unverified → warning -->
                    <svg v-if="n.type === 'copyright_unverified'" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                    </svg>
                    <!-- copyright_approved → success -->
                    <svg v-else-if="n.type === 'copyright_approved'" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <!-- copyright_rejected → danger -->
                    <svg v-else-if="n.type === 'copyright_rejected'" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <!-- copyright_disputed → warn -->
                    <svg v-else-if="n.type === 'copyright_disputed'" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <!-- copyright_pending → info -->
                    <svg v-else width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                  </div>

                  <!-- Content -->
                  <div class="cnotif__content">
                    <p class="cnotif__item-title">{{ n.title }}</p>
                    <p class="cnotif__item-msg">{{ n.message }}</p>
                    <div class="cnotif__item-footer">
                      <span class="cnotif__item-time">{{ timeAgo(n.created_at) }}</span>
                      <!-- CTA for unverified copyright -->
                      <router-link
                        v-if="n.type === 'copyright_unverified' && n.action_url"
                        :to="n.action_url"
                        class="cnotif__cta"
                        @click.stop="notifDropdownOpen = false"
                      >
                        Register now
                      </router-link>
                      <router-link
                        v-else-if="n.type === 'copyright_rejected' && n.action_url"
                        :to="n.action_url"
                        class="cnotif__cta cnotif__cta--danger"
                        @click.stop="notifDropdownOpen = false"
                      >
                        Resubmit
                      </router-link>
                      <router-link
                        v-else-if="n.type === 'copyright_disputed' && n.action_url"
                        :to="n.action_url"
                        class="cnotif__cta cnotif__cta--warn"
                        @click.stop="notifDropdownOpen = false"
                      >
                        View report
                      </router-link>
                    </div>
                  </div>

                  <!-- Unread dot -->
                  <div v-if="!n.is_read" class="cnotif__dot"></div>
                </div>
              </div>

              <!-- Footer -->
              <div class="cnotif__footer" @click="notifDropdownOpen = false">
                <router-link to="/center/copyright-registration" class="cnotif__footer-link">
                  View all copyright notifications →
                </router-link>
              </div>
            </div>
          </Transition>
        </div>
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
import { ref, watch, onMounted, onBeforeUnmount, computed } from "vue";
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
const isDropdownCenter    = ref(false);
const isMobileMenuOpen    = ref(false);
const dropdownProfileOpen = ref(false);
const profileDropdownRef  = ref<HTMLElement | null>(null);
const dropdown            = ref<HTMLElement | null>(null);
const dropdownLibrary     = ref<HTMLElement | null>(null);
const dropdownCenter      = ref<HTMLElement | null>(null);

// ── Notification tabs ─────────────────────────────────────────────────────────
const activeNotifTab = ref<'all' | 'unread' | 'copyright'>('all')
const notifTabs = [
  { key: 'all',       label: 'All' },
  { key: 'unread',    label: 'Unread' },
  { key: 'copyright', label: 'Copyright' },
] as const

const logo = new URL(
  "../assets/images/logo/melody-high-resolution-logo-white.png",
  import.meta.url
).href;

const toggleDropdown        = () => { isDropdownOpen.value = !isDropdownOpen.value }
const toggleMobileMenu      = () => { isMobileMenuOpen.value = !isMobileMenuOpen.value }
const toggleProfileDropdown = () => { dropdownProfileOpen.value = !dropdownProfileOpen.value }
const toggleDropdownCenter        = () => { isDropdownCenter.value = !isDropdownCenter.value }

const handleRegister = () => { alert("Register clicked!") }
const handleLogin    = () => { router.push({ name: "Login" }) }

const handleClickOutside = (event: MouseEvent) => {
  if (dropdownLibrary.value && !dropdownLibrary.value.contains(event.target as Node)) {
    isDropdownOpen.value = false
  }
  if (dropdownCenter.value && !dropdownCenter.value.contains(event.target as Node)) {
    isDropdownCenter.value = false
  }
  if (profileDropdownRef.value && !profileDropdownRef.value.contains(event.target as Node)) {
    dropdownProfileOpen.value = false
  }
  if (searchWrapRef.value && !searchWrapRef.value.contains(event.target as Node)) {
    searchFocused.value = false
  }
  if (notifDropdownRef.value && !notifDropdownRef.value.contains(event.target as Node)) {
    notifDropdownOpen.value = false
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

// ── Notifications ─────────────────────────────────────────────────────────────
import clientApi from '@/plugins/axios'

interface NotifItem {
  id: number
  type: string
  title: string
  message: string
  action_url: string | null
  is_read: boolean
  created_at: string
}

const notifications     = ref<NotifItem[]>([])
const unreadCount       = ref(0)
const notifLoading      = ref(false)
const notifDropdownOpen = ref(false)
const notifDropdownRef  = ref<HTMLElement | null>(null)
let   notifPollTimer: ReturnType<typeof setInterval> | null = null

const fetchNotifications = async () => {
  if (!authStore.isAuthenticated) return
  try {
    notifLoading.value = true
    const res = await clientApi.get('/notifications')
    notifications.value = res.data?.data ?? []
    unreadCount.value   = res.data?.unread_count ?? 0
  } catch {
    // silent fail — không làm crash layout
  } finally {
    notifLoading.value = false
  }
}

const toggleNotifDropdown = () => {
  notifDropdownOpen.value = !notifDropdownOpen.value
  if (notifDropdownOpen.value) {
    fetchNotifications()
  }
}

// Computed filtered list by tab
const filteredNotifications = computed(() => {
  if (activeNotifTab.value === 'unread')    return notifications.value.filter(n => !n.is_read)
  if (activeNotifTab.value === 'copyright') return notifications.value.filter(n => n.type.startsWith('copyright'))
  return notifications.value
})

const markAllRead = async () => {
  try {
    await clientApi.patch('/notifications/read-all')
    notifications.value.forEach(n => { n.is_read = true })
    unreadCount.value = 0
  } catch { /* silent */ }
}

const handleNotifClick = async (n: NotifItem) => {
  if (!n.is_read) {
    try {
      await clientApi.patch(`/notifications/${n.id}/read`)
      n.is_read = true
      unreadCount.value = Math.max(0, unreadCount.value - 1)
    } catch { /* silent */ }
  }
  notifDropdownOpen.value = false
  if (n.action_url) router.push(n.action_url)
}

const notifIconClass = (type: string) => ({
  'notif-item__icon--warn':    type === 'copyright_unverified' || type === 'copyright_disputed',
  'notif-item__icon--success': type === 'copyright_approved'  || type === 'report_resolved',
  'notif-item__icon--danger':  type === 'copyright_rejected',
  'notif-item__icon--info':    type === 'system' || type === 'copyright_pending',
})

const timeAgo = (dateStr: string): string => {
  const diff = Date.now() - new Date(dateStr).getTime()
  const m = Math.floor(diff / 60000)
  if (m < 1)  return 'Just now'
  if (m < 60) return `${m}m ago`
  const h = Math.floor(m / 60)
  if (h < 24) return `${h}h ago`
  return `${Math.floor(h / 24)}d ago`
}

onMounted(() => {
  document.addEventListener("click", handleClickOutside)
  if (authStore.isAuthenticated) {
    fetchNotifications()
    // Poll unread count mỗi 60s
    notifPollTimer = setInterval(async () => {
      if (!authStore.isAuthenticated) return
      try {
        const res = await clientApi.get('/notifications/unread-count')
        unreadCount.value = res.data?.unread_count ?? 0
      } catch { /* silent */ }
    }, 60000)
  }
})

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside)
  if (notifPollTimer) clearInterval(notifPollTimer)
})
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

/* ── MelodyHub Center Dropdown ───────────────────────────────────────────── */
.center-dropdown {
  width: 420px;
  padding: 0;
  overflow: hidden;
  background: #1c2734 !important;
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
}

.center-dropdown__header {
  padding: 16px 20px 12px;
  font-size: 13px;
  font-weight: 600;
  color: rgba(255,255,255,0.5);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  border-bottom: 1px solid rgba(255,255,255,0.06);
}

.center-dropdown__item {
  display: flex;
  align-items: flex-start;
  gap: 14px;
  padding: 18px 20px;
  cursor: pointer;
  transition: background 0.2s;
  border-bottom: 1px solid rgba(255,255,255,0.04);
  text-decoration: none;
  color: inherit;
}

.center-dropdown__item:hover {
  background: rgba(255,255,255,0.04);
}

.center-dropdown__item:hover .center-dropdown__arrow {
  transform: translateX(3px);
  opacity: 1;
}

.center-dropdown__icon {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.center-dropdown__icon--blue {
  background: rgba(59, 130, 246, 0.15);
  color: #3b82f6;
}

.center-dropdown__icon--red {
  background: rgba(239, 68, 68, 0.15);
  color: #ef4444;
}

.center-dropdown__content {
  flex: 1;
  min-width: 0;
}

.center-dropdown__title {
  font-size: 14px;
  font-weight: 600;
  color: rgba(255,255,255,0.95);
  margin-bottom: 6px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.center-dropdown__badge {
  font-size: 10px;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: 6px;
  text-transform: uppercase;
  letter-spacing: 0.03em;
}

.center-dropdown__badge--free {
  background: rgba(34, 197, 94, 0.15);
  color: #22c55e;
}

.center-dropdown__badge--new {
  background: rgba(249, 115, 22, 0.15);
  color: #f97316;
}

.center-dropdown__desc {
  font-size: 12px;
  line-height: 1.5;
  color: rgba(255,255,255,0.45);
}

.center-dropdown__arrow {
  color: rgba(255,255,255,0.25);
  flex-shrink: 0;
  margin-top: 12px;
  transition: transform 0.2s, opacity 0.2s;
  opacity: 0.5;
}

.center-dropdown__footer {
  padding: 14px 20px;
  font-size: 11px;
  color: rgba(255,255,255,0.4);
  display: flex;
  align-items: center;
  gap: 6px;
  background: rgba(0,0,0,0.2);
}

.center-dropdown__footer svg {
  flex-shrink: 0;
  opacity: 0.6;
}

.center-dropdown__footer-link {
  color: #3b82f6;
  text-decoration: none;
  font-weight: 500;
}

.center-dropdown__footer-link:hover {
  text-decoration: underline;
}

/* ═══════════════════════════════════════════════════════════════════════════
   CLIENT NOTIFICATION BELL + PANEL
   Mirrors admin Header.vue but adapted for the transparent client header
═══════════════════════════════════════════════════════════════════════════ */

/* Bell button */
.client-notif-btn {
  position: relative;
  background: transparent;
  border: 1px solid rgba(0,198,255,0.4);
  border-radius: 10px;
  width: 38px;
  height: 38px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  color: rgba(255,255,255,0.8);
  transition: all 0.25s ease;
}

.client-notif-btn:hover,
.client-notif-btn--active {
  background: rgba(0,198,255,0.12);
  border-color: rgba(0,198,255,0.8);
  box-shadow: 0 0 10px rgba(0,198,255,0.35);
  color: #fff;
}

/* Badge */
.client-notif-badge {
  position: absolute;
  top: -5px;
  right: -5px;
  background: #ff4757;
  color: #fff;
  font-size: 9px;
  font-weight: 700;
  min-width: 17px;
  height: 17px;
  padding: 0 4px;
  border-radius: 9px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px solid rgba(7,13,20,0.9);
  line-height: 1;
}

.badge-pulse {
  animation: badgePulse 2s ease-in-out infinite;
}

@keyframes badgePulse {
  0%, 100% { box-shadow: 0 0 0 0 rgba(255,71,87,0.6); }
  50%       { box-shadow: 0 0 0 5px rgba(255,71,87,0); }
}

/* Dropdown panel */
.client-notif-panel {
  position: absolute;
  top: calc(100% + 12px);
  right: 0;
  width: 370px;
  background: rgba(8, 14, 26, 0.97);
  border: 1px solid rgba(0,198,255,0.3);
  border-radius: 16px;
  box-shadow:
    0 0 20px rgba(0,198,255,0.12),
    0 24px 64px rgba(0,0,0,0.7);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  overflow: hidden;
  z-index: 9999;
}

/* ── Header ── */
.cnotif__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 14px 16px 10px;
  border-bottom: 1px solid rgba(255,255,255,0.07);
}

.cnotif__header-left {
  display: flex;
  align-items: center;
  gap: 8px;
}

.cnotif__title {
  font-size: 13px;
  font-weight: 700;
  color: rgba(255,255,255,0.9);
  letter-spacing: 0.02em;
}

.cnotif__unread-badge {
  font-size: 10px;
  font-weight: 700;
  background: rgba(0,198,255,0.15);
  color: #00c6ff;
  padding: 2px 7px;
  border-radius: 8px;
  letter-spacing: 0.02em;
}

.cnotif__mark-all {
  font-size: 11px;
  color: rgba(255,255,255,0.35);
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  transition: color 0.2s;
}
.cnotif__mark-all:hover { color: rgba(255,255,255,0.7); }

/* ── Tabs ── */
.cnotif__tabs {
  display: flex;
  gap: 2px;
  padding: 8px 12px;
  border-bottom: 1px solid rgba(255,255,255,0.06);
}

.cnotif__tab {
  flex: 1;
  background: transparent;
  border: none;
  cursor: pointer;
  font-size: 11px;
  font-weight: 600;
  color: rgba(255,255,255,0.35);
  padding: 5px 10px;
  border-radius: 8px;
  transition: all 0.18s;
  letter-spacing: 0.02em;
}

.cnotif__tab:hover {
  background: rgba(255,255,255,0.05);
  color: rgba(255,255,255,0.7);
}

.cnotif__tab--active {
  background: rgba(0,198,255,0.12);
  color: #00c6ff;
}

/* ── State (loading / empty) ── */
.cnotif__state {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 32px 16px;
  color: rgba(255,255,255,0.25);
  font-size: 13px;
}

.cnotif__spinner {
  width: 18px;
  height: 18px;
  border: 2px solid rgba(0,198,255,0.15);
  border-top-color: #00c6ff;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}

/* ── List ── */
.cnotif__list {
  max-height: 380px;
  overflow-y: auto;
  padding: 4px 0;
}

.cnotif__list::-webkit-scrollbar { width: 4px; }
.cnotif__list::-webkit-scrollbar-track { background: transparent; }
.cnotif__list::-webkit-scrollbar-thumb { background: rgba(0,198,255,0.18); border-radius: 2px; }

/* ── Item ── */
.cnotif__item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  padding: 11px 14px;
  cursor: pointer;
  transition: background 0.15s;
  position: relative;
  border-left: 2px solid transparent;
}

.cnotif__item--unread                 { background: rgba(0,198,255,0.03); }
.cnotif__item--copyright_unverified   { border-left-color: #fbbf24; }
.cnotif__item--copyright_approved     { border-left-color: #34d399; }
.cnotif__item--copyright_rejected     { border-left-color: #f87171; }
.cnotif__item--copyright_disputed     { border-left-color: #fb923c; }
.cnotif__item--copyright_pending      { border-left-color: #60a5fa; }

.cnotif__item:hover { background: rgba(255,255,255,0.04); }

/* ── Icon ── */
.cnotif__icon {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  margin-top: 1px;
}

/* reuse notifIconClass from script */
.notif-item__icon--warn    { background: rgba(251,191,36,0.12);  color: #fbbf24; }
.notif-item__icon--success { background: rgba(52,211,153,0.12);  color: #34d399; }
.notif-item__icon--danger  { background: rgba(248,113,113,0.12); color: #f87171; }
.notif-item__icon--info    { background: rgba(96,165,250,0.12);  color: #60a5fa; }

/* ── Content ── */
.cnotif__content {
  flex: 1;
  min-width: 0;
}

.cnotif__item-title {
  font-size: 12px;
  font-weight: 600;
  color: rgba(255,255,255,0.88);
  margin: 0 0 2px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.cnotif__item-msg {
  font-size: 11px;
  color: rgba(255,255,255,0.42);
  margin: 0 0 5px;
  line-height: 1.5;
  /* allow 2 lines */
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.cnotif__item-footer {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.cnotif__item-time {
  font-size: 10px;
  color: rgba(255,255,255,0.2);
}

/* ── CTA buttons ── */
.cnotif__cta {
  font-size: 10px;
  font-weight: 700;
  padding: 3px 9px;
  border-radius: 6px;
  background: rgba(0,198,255,0.15);
  color: #00c6ff;
  text-decoration: none;
  letter-spacing: 0.03em;
  transition: background 0.15s;
  white-space: nowrap;
}
.cnotif__cta:hover { background: rgba(0,198,255,0.28); }

.cnotif__cta--danger {
  background: rgba(248,113,113,0.15);
  color: #f87171;
}
.cnotif__cta--danger:hover { background: rgba(248,113,113,0.28); }

.cnotif__cta--warn {
  background: rgba(251,191,36,0.15);
  color: #fbbf24;
}
.cnotif__cta--warn:hover { background: rgba(251,191,36,0.28); }

/* ── Unread dot ── */
.cnotif__dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: #00c6ff;
  flex-shrink: 0;
  margin-top: 6px;
  box-shadow: 0 0 6px rgba(0,198,255,0.6);
}

/* ── Footer ── */
.cnotif__footer {
  padding: 10px 16px;
  border-top: 1px solid rgba(255,255,255,0.06);
  text-align: center;
  background: rgba(0,0,0,0.15);
}

.cnotif__footer-link {
  font-size: 12px;
  font-weight: 500;
  color: #00c6ff;
  text-decoration: none;
  opacity: 0.8;
  transition: opacity 0.2s;
}
.cnotif__footer-link:hover { opacity: 1; }

/* Transition (reuse existing notif-drop keyframes already defined above) */

</style>

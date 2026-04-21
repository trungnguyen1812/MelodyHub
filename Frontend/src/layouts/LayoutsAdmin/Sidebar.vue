<template>
  <div class="main">
    <div class="disc"></div>
    <div class="disc disc-2"></div>

    <!-- TOP: Logo -->
    <div class="topSidebar">
      <a @click="homepage" class="logo-wrap">
        <img class="logo" src="@/assets/images/logo/melody-high-resolution-logo-white.png" alt="logoMelodyHub" />
      </a>
    </div>

    <!-- DIVIDER -->
    <div class="divider"></div>

    <!-- MAIN MENU -->
    <div class="mainSidebar">
      <p class="section-label">MENU</p>
      <ul>
        <router-link :to="{ name: 'admin.dashboard' }" custom v-slot="{ navigate, isActive }">
          <li :class="{ active: isActive }" @click="navigate" @keyup.enter="navigate" role="link" tabindex="0">
            <span class="icon-wrap"><img src="@/assets/images/icon/dashboard.svg" alt="" /></span>
            <span>Dashboard</span>
          </li>
        </router-link>

        <router-link :to="{ name: 'admin.usermanager' }" custom v-slot="{ navigate, isActive }">
          <li :class="{ active: isActive }" @click="navigate" @keyup.enter="navigate" role="link" tabindex="0">
            <span class="icon-wrap"><img src="@/assets/images/icon/customer.svg" alt="" /></span>
            <span>User Management</span>
          </li>
        </router-link>
      </ul>

      <p class="section-label" style="margin-top: 18px;">CONTENT</p>
      <ul>
        <!-- Dropdown: click to toggle -->
        <li class="dropdown" :class="{ open: dropdownOpen }" @click="toggleDropdown">
          <span class="icon-wrap"><img src="@/assets/images/icon/content.svg" alt="" /></span>
          <span>Content Management</span>
          <span class="arrow" :class="{ rotated: dropdownOpen }">
            <svg width="10" height="10" viewBox="0 0 10 10" fill="none">
              <path d="M2 3.5L5 6.5L8 3.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </span>
        </li>

        <transition name="submenu-slide">
          <ul v-if="dropdownOpen" class="submenu">
            <router-link :to="{ name: 'admin.songsmanager' }" custom v-slot="{ navigate, isActive }">
              <li :class="{ active: isActive }" @click.stop="navigate" @keyup.enter="navigate" role="link" tabindex="0">
                <span class="icon-wrap sub"><img src="@/assets/images/icon/songs.svg" alt="" /></span>
                <span>Songs</span>
              </li>
            </router-link>
            <router-link :to="{ name: 'admin.artistsmanager' }" custom v-slot="{ navigate, isActive }">
              <li :class="{ active: isActive }" @click.stop="navigate" @keyup.enter="navigate" role="link" tabindex="0">
                <span class="icon-wrap sub"><img src="@/assets/images/icon/artist.svg" alt="" /></span>
                <span>Artists</span>
              </li>
            </router-link>
            <router-link :to="{ name: 'admin.albumsmanager' }" custom v-slot="{ navigate, isActive }">
              <li :class="{ active: isActive }" @click.stop="navigate" @keyup.enter="navigate" role="link" tabindex="0">
                <span class="icon-wrap sub"><img src="@/assets/images/icon/album.svg" alt="" /></span>
                <span>Albums</span>
              </li>
            </router-link>
            <router-link :to="{ name: 'admin.genresmanager' }" custom v-slot="{ navigate, isActive }">
              <li :class="{ active: isActive }" @click.stop="navigate" @keyup.enter="navigate" role="link" tabindex="0">
                <span class="icon-wrap sub"><img src="@/assets/images/icon/Genres.png" alt="" /></span>
                <span>Genres</span>
              </li>
            </router-link>
          </ul>
        </transition>
      </ul>

      <p class="section-label" style="margin-top: 18px;">MANAGE</p>
      <ul>
        <li><span class="icon-wrap"><img src="@/assets/images/icon/heart.png" alt="" /></span><span>Social Interaction</span></li>
        <li><span class="icon-wrap"><img src="@/assets/images/icon/playlist.svg" alt="" /></span><span>Playlists</span></li>
        <li><span class="icon-wrap"><img src="@/assets/images/icon/payment.svg" alt="" /></span><span>Payment</span></li>
        <router-link :to="{ name: 'admin.partnersmanager' }" custom v-slot="{ navigate, isActive }">
          <li :class="{ active: isActive }" @click="navigate" @keyup.enter="navigate" role="link" tabindex="0">
            <span class="icon-wrap"><img src="@/assets/images/icon/deal.png" alt="" /></span>
            <span>Partners</span>
          </li>
        </router-link>
        <router-link :to="{ name: 'admin.advtisingmanager' }" custom v-slot="{ navigate, isActive }">
          <li :class="{ active: isActive }" @click="navigate" @keyup.enter="navigate" role="link" tabindex="0">
            <span class="icon-wrap"><img src="@/assets/images/icon/ad.png" alt="" /></span>
            <span>Advertising</span>
          </li>
        </router-link>
        
      </ul>
    </div>

    <!-- DIVIDER -->
    <div class="divider"></div>

    <!-- BOTTOM: Setting -->
    <div class="bottomSidebar">
      <div class="setting-btn">
        <span class="icon-wrap"><img src="@/assets/images/icon/setting.svg" alt="" /></span>
        <span>Settings</span>
      </div>
    </div>
  </div>
</template>

<script setup>
import router from '@/modules/router';
import { ref } from 'vue';

const dropdownOpen = ref(false);

const toggleDropdown = () => {
  dropdownOpen.value = !dropdownOpen.value;
};

const homepage = () => {
  router.push({ name: 'client.home' });
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Afacad:wght@400;500;600&display=swap');

/* ── ROOT ─────────────────────────────────── */
.main {
  width: 20%;
  height: 93%;
  margin: 2%;
  border-radius: 16px;
  background: rgba(255, 255, 255, 0.06);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  border: 1px solid rgba(0, 170, 255, 0.55);
  font-family: 'Afacad', sans-serif;
  box-shadow:
    0 0 10px rgba(0, 170, 255, 0.6),
    0 0 22px rgba(0, 170, 255, 0.4),
    0 0 36px rgba(0, 170, 255, 0.2),
    0 10px 30px rgba(0, 0, 0, 0.5);
  animation: neonPulse 2s infinite ease-in-out;
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

/* ── DECORATIVE DISCS ─────────────────────── */
.disc {
  position: absolute;
  width: 200px;
  height: 200px;
  border-radius: 50%;
  right: -55px;
  bottom: -55px;
  background: radial-gradient(circle, #1a1a2e 0%, #000 55%);
  opacity: 0.55;
  z-index: 1;
  animation: spin 14s linear infinite;
  pointer-events: none;
}
.disc::after {
  content: '';
  position: absolute;
  top: 50%; left: 50%;
  transform: translate(-50%, -50%);
  width: 18px; height: 18px;
  border-radius: 50%;
  background: #fff;
  border: 2px solid rgba(0, 170, 255, 0.7);
  box-shadow: 0 0 8px rgba(0, 170, 255, 0.7);
}
.disc-2 {
  width: 100px; height: 100px;
  right: auto; bottom: auto;
  left: -30px; top: -30px;
  opacity: 0.25;
  animation-duration: 20s;
  animation-direction: reverse;
}

/* ── DIVIDER ──────────────────────────────── */
.divider {
  width: calc(100% - 32px);
  margin: 0 16px;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(0,170,255,0.45), transparent);
  flex-shrink: 0;
}

/* ── TOP SIDEBAR ──────────────────────────── */
.topSidebar {
  position: relative;
  z-index: 2;
  padding: 18px 12px 14px;
  flex-shrink: 0;
}
.logo-wrap {
  cursor: pointer;
  display: block;
}
.logo {
  width: 72%;
  max-width: 150px;
  display: block;
  margin: 0 auto;
  filter: drop-shadow(0 0 6px rgba(0,170,255,0.5));
  transition: filter 0.3s ease;
}
.logo:hover {
  filter: drop-shadow(0 0 12px rgba(0,170,255,0.85));
}

/* ── MAIN SIDEBAR ─────────────────────────── */
.mainSidebar {
  position: relative;
  z-index: 2;
  flex: 1;
  overflow-y: auto;
  padding: 12px 10px 8px;
  min-height: 0;
}
.mainSidebar::-webkit-scrollbar { width: 4px; }
.mainSidebar::-webkit-scrollbar-thumb {
  background: rgba(0,170,255,0.5);
  border-radius: 4px;
}
.mainSidebar::-webkit-scrollbar-track { background: transparent; }

/* Section labels */
.section-label {
  font-size: 9.5pt;
  font-weight: 600;
  letter-spacing: 0.12em;
  color: rgba(0,170,255,0.55);
  padding: 0 12px;
  margin: 6px 0 4px;
}

/* ── MENU LISTS ───────────────────────────── */
ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

/* Shared row style */
.mainSidebar > ul > li,
.mainSidebar ul > li {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 9px 14px;
  margin: 2px 0;
  border-radius: 10px;
  cursor: pointer;
  color: rgba(255,255,255,0.75);
  font-size: 12.5pt;
  font-weight: 400;
  transition: background 0.25s ease, color 0.25s ease, padding-left 0.2s ease;
  user-select: none;
}

.mainSidebar > ul > li:hover,
.mainSidebar ul > li:hover {
  background: rgba(0,170,255,0.13);
  color: #fff;
}

.mainSidebar > ul > li.active,
.mainSidebar ul > li.active {
  background: rgba(0,170,255,0.2);
  color: #00aaff;
  font-weight: 600;
  border-left: 3px solid #00aaff;
  padding-left: 11px;
  box-shadow: inset 0 0 10px rgba(0,170,255,0.1);
}

/* Icon wrap */
.icon-wrap {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 22px;
  height: 22px;
  flex-shrink: 0;
}
.icon-wrap img {
  width: 18px;
  height: 18px;
  object-fit: contain;
  opacity: 0.85;
}
.icon-wrap.sub img {
  width: 15px;
  height: 15px;
  opacity: 0.7;
}

/* ── DROPDOWN ─────────────────────────────── */
.dropdown {
  position: relative;
  border-radius: 10px !important;
  /* keeps flex-row, no column switch */
}

.dropdown .arrow {
  margin-left: auto;
  color: rgba(0,170,255,0.7);
  display: flex;
  align-items: center;
  transition: transform 0.3s ease;
}
.dropdown .arrow.rotated {
  transform: rotate(180deg);
}

.dropdown.open {
  background: rgba(0,170,255,0.1);
  color: #fff;
}

/* Submenu */
.submenu {
  margin: 2px 0 4px 28px !important;
  background: rgba(0, 0, 0, 0.25);
  border-left: 1px solid rgba(0,170,255,0.3);
  border-radius: 0 0 8px 8px;
  padding: 4px 0 !important;
}

.submenu li {
  font-size: 11.5pt !important;
  padding: 7px 12px !important;
  margin: 1px 4px !important;
  color: rgba(255,255,255,0.65) !important;
  border-radius: 7px !important;
}
.submenu li:hover {
  background: rgba(0,170,255,0.18) !important;
  color: #fff !important;
  padding-left: 16px !important;
}
.submenu li.active {
  color: #00aaff !important;
  border-left: 2px solid #00aaff !important;
  padding-left: 10px !important;
}

/* Vue transition for submenu */
.submenu-slide-enter-active,
.submenu-slide-leave-active {
  transition: all 0.28s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
}
.submenu-slide-enter-from,
.submenu-slide-leave-to {
  max-height: 0;
  opacity: 0;
  transform: translateY(-6px);
}
.submenu-slide-enter-to,
.submenu-slide-leave-from {
  max-height: 300px;
  opacity: 1;
  transform: translateY(0);
}

/* ── BOTTOM SIDEBAR ───────────────────────── */
.bottomSidebar {
  position: relative;
  z-index: 2;
  padding: 10px 10px 14px;
  flex-shrink: 0;
}
.setting-btn {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 9px 14px;
  border-radius: 10px;
  cursor: pointer;
  color: rgba(255,255,255,0.75);
  font-size: 12.5pt;
  transition: background 0.25s, color 0.25s;
}
.setting-btn:hover {
  background: rgba(0,170,255,0.13);
  color: #fff;
}
.setting-btn .icon-wrap img {
  width: 18px;
  height: 18px;
  opacity: 0.85;
}

/* ── ANIMATIONS ───────────────────────────── */
@keyframes spin {
  to { transform: rotate(360deg); }
}

@keyframes neonPulse {
  0%, 100% {
    box-shadow:
      0 0 10px rgba(0,170,255,0.6),
      0 0 22px rgba(0,170,255,0.4),
      0 0 36px rgba(0,170,255,0.2),
      0 10px 30px rgba(0,0,0,0.5);
  }
  50% {
    box-shadow:
      0 0 14px rgba(0,170,255,0.75),
      0 0 28px rgba(0,170,255,0.5),
      0 0 44px rgba(0,170,255,0.28),
      0 12px 35px rgba(0,0,0,0.55);
  }
}
</style>
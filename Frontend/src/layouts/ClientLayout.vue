<template>
  <div class="layout-container min-h-screen bg-gray-900 text-white">
    <!-- Header -->
    <header
      class="fixed top-0 left-0 w-full flex items-center justify-between px-4 sm:px-6 h-16 bg-transparent backdrop-blur-sm z-50"
    >
      <!-- Left Side: Logo + Menu -->
      <div class="flex items-center space-x-4 sm:space-x-6">
        <!-- Logo -->
        <div class="flex items-center h-10 w-24 sm:h-16 sm:w-32 flex-shrink-0">
          <router-link to="/">
            <img
              :src="logo"
              alt="Melody Logo"
              class="h-full w-full object-contain"
            />
          </router-link>
        </div>
        <!-- Navigation (Hidden on mobile) -->
        <nav class="hidden sm:flex items-center space-x-4">
          <router-link
            to="/"
            class="text-sm font-medium text-white hover:text-cyan-400 drop-shadow-[0_0_10px_#22d3ee] transition-colors duration-200"
          >
            Home
          </router-link>
          <div class="relative" ref="dropdown">
            <a
              href="#"
              class="text-sm font-medium text-white hover:text-cyan-400 drop-shadow-[0_0_10px_#22d3ee] transition-colors duration-200 flex items-center"
              @click.prevent="toggleDropdown"
              aria-haspopup="true"
              :aria-expanded="isDropdownOpen"
            >
              Library
              <span class="ml-1 text-xs">▼</span>
            </a>
            <!-- Dropdown menu -->
            <div
              v-show="isDropdownOpen"
              class="absolute left-0 mt-2 w-40 bg-gray-800/75 text-white rounded-lg shadow-lg z-50 transition-all duration-200"
              role="menu"
            >
              <a
                href="#"
                class="block px-4 py-2 text-sm hover:text-cyan-400 drop-shadow-[0_0_10px_#22d3ee] hover:text-white transition-colors duration-200"
                role="menuitem"
              >
                Music
              </a>
              <a
                href="#"
                class="block px-4 py-2 text-sm hover:text-cyan-400 drop-shadow-[0_0_10px_#22d3ee] hover:text-white transition-colors duration-200"
                role="menuitem"
              >
                Playlist
              </a>
            </div>
          </div>
        </nav>
      </div>

      <!-- Center: Search Bar -->
      <div class="flex-1 max-w-md mx-4 hidden sm:block">
        <input
          type="text"
          placeholder="Search music..."
          class="w-full px-4 py-2 bg-gray-800 text-white rounded-full focus:outline-none focus:ring-2 focus:ring-blue-400 text-sm"
        />
      </div>

      <!-- Right Side: Auth + Hamburger Menu -->
      <div class="flex items-center space-x-3">
        <!-- Auth Buttons (Hidden on mobile) -->
        <!-- Display the Try for Free button if you are not logged in. -->
        <div class="hidden sm:flex space-x-3" v-if="!authStore.isAuthenticated">
          <button
            @click="handleLogin"
            class="text-cyan-400 drop-shadow-[0_0_10px_#22d3ee] px-3 py-1.5 rounded-md hover:bg-white/10 transition-colors duration-200 text-sm font-medium"
            aria-label="Register"
          >
            Try for Free
          </button>
        </div>

        <!-- If you are already logged in, please display your avatar or menu. -->
        <div class="hidden sm:flex relative" ref="profileDropdownRef" v-else>
          <!-- Trigger dropdown -->
          <button
            @click.prevent="toggleProfileDropdown"
            class="flex items-center space-x-2 text-white text-sm font-medium hover:text-cyan-400 drop-shadow-[0_0_10px_#22d3ee] transition-colors duration-200 focus:outline-none"
          >
            <img
              :src="authStore.user?.avatar || '../../public/default-avatar.jpg'"
              alt="avatar"
              class="w-6 h-6 rounded-full object-cover"
            />
            <span>{{ authStore.user?.name?.split(' ').pop() || 'User' }}</span>
            <span class="ml-1 text-xs">▼</span>
          </button>

          <!-- Dropdown menu -->
          <div
            v-show="dropdownProfileOpen"
            class="absolute right-[-70px] mt-[28px] w-44 bg-[#161f2b]/90 text-white rounded-lg shadow-lg z-50 transition-all duration-200 origin-top "
          >
            <button
              @click=""
              class="block w-full text-left px-4 py-2 text-sm hover:text-white transition-colors duration-200 drop-shadow-[0_0_10px_#22d3ee]"
              role="menuitem"
            >
              Profile
            </button>
            <button
              v-if="authStore.permissionLoaded && authStore.isAdmin"
              @click="adminPage"
              class="block w-full text-left px-4 py-2 text-sm hover:text-white transition-colors duration-200 drop-shadow-[0_0_10px_#22d3ee]"
              role="menuitem"
            >
              Admin
            </button>
            <hr>
            <button
              @click="handleLogout"
              class="block w-full text-left px-4 py-2 text-sm text-red-500 hover:text-white transition-colors duration-200 drop-shadow-[0_0_10px_#22d3ee]"
              role="menuitem"
            >
              Logout
            </button>
          </div>
        </div>

        <!-- Hamburger Menu (Visible on mobile) -->
        <button
          class="sm:hidden text-white focus:outline-none"
          @click="toggleMobileMenu"
          aria-label="Toggle mobile menu"
        >
          <svg
            class="w-6 h-6"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M4 6h16M4 12h16M4 18h16"
            />
          </svg>
        </button>
      </div>

      <!-- Mobile Menu (Visible when toggled) -->
      <div
        v-show="isMobileMenuOpen"
        class="sm:hidden absolute top-16 left-0 w-full bg-gray-800 p-4 flex flex-col space-y-4"
      >
        <input
          type="text"
          placeholder="Search music..."
          class="w-full px-4 py-2 bg-gray-700 text-white rounded-full focus:outline-none focus:ring-2 focus:ring-blue-400 text-sm"
        />
        <a href="#" class="text-sm font-medium text-white hover:text-blue-400">
          Home
        </a>
        <a href="#" class="text-sm font-medium text-white hover:text-blue-400">
          Browse
        </a>
        <button
          @click="handleRegister"
          class="bg-blue-600 text-white px-3 py-1.5 rounded-md hover:bg-blue-700 text-sm font-medium"
        >
          Try for Free
        </button>
       
        <button
          @click="handleLogin"
          class="bg-gray-700 text-white px-3 py-1.5 rounded-md hover:bg-gray-600 text-sm font-medium"
        >
          Sign In
        </button>
      </div>
    </header>

    <!-- Main Content -->
    <main
      class="main-content pt-20 pb-6 px-4 sm:px-6 bg-gradient-to-b from-gray-900 to-gray-800"
    >
      <router-view />
    </main>

    <!-- Footer -->
    <footer
      class="footer sm:footer-horizontal bg-neutral text-neutral-content items-center p-4"
    >
      <aside class="grid-flow-col items-center">
        <div class="flex items-center h-10 w-24 sm:h-16 sm:w-32 flex-shrink-0">
          <router-link to="/">
            <img
              :src="logo"
              alt="Melody Logo"
              class="h-full w-full object-contain"
            />
          </router-link>
        </div>
        <p>Copyright © {new Date().getFullYear()} - All right reserved</p>
      </aside>
      <nav class="grid-flow-col gap-4 md:place-self-center md:justify-self-end">
        <a>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            class="fill-current"
          >
            <path
              d="M24 4.557c-.883.392-1.832.656-2.828.775 1.017-.609 1.798-1.574 2.165-2.724-.951.564-2.005.974-3.127 1.195-.897-.957-2.178-1.555-3.594-1.555-3.179 0-5.515 2.966-4.797 6.045-4.091-.205-7.719-2.165-10.148-5.144-1.29 2.213-.669 5.108 1.523 6.574-.806-.026-1.566-.247-2.229-.616-.054 2.281 1.581 4.415 3.949 4.89-.693.188-1.452.232-2.224.084.626 1.956 2.444 3.379 4.6 3.419-2.07 1.623-4.678 2.348-7.29 2.04 2.179 1.397 4.768 2.212 7.548 2.212 9.142 0 14.307-7.721 13.995-14.646.962-.695 1.797-1.562 2.457-2.549z"
            ></path>
          </svg>
        </a>
        <a>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            class="fill-current"
          >
            <path
              d="M19.615 3.184c-3.604-.246-11.631-.245-15.23 0-3.897.266-4.356 2.62-4.385 8.816.029 6.185.484 8.549 4.385 8.816 3.6.245 11.626.246 15.23 0 3.897-.266 4.356-2.62 4.385-8.816-.029-6.185-.484-8.549-4.385-8.816zm-10.615 12.816v-8l8 3.993-8 4.007z"
            ></path>
          </svg>
        </a>
        <a>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            viewBox="0 0 24 24"
            class="fill-current"
          >
            <path
              d="M9 8h-3v4h3v12h5v-12h3.642l.358-4h-4v-1.667c0-.955.192-1.333 1.115-1.333h2.885v-5h-3.808c-3.596 0-5.192 1.583-5.192 4.615v3.385z"
            ></path>
          </svg>
        </a>
      </nav>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from "vue";
import { useAuthStore } from "@/store/authStore";
import { useRouter } from "vue-router";



const router = useRouter();
const authStore = useAuthStore();

//hadle logout client 
const handleLogout = async() =>{
  await authStore.logout();
  router.push({name: "Login"});
};

const isDropdownOpen = ref(false);
const isMobileMenuOpen = ref(false);
const dropdownProfileOpen = ref(false);
const profileDropdownRef = ref<HTMLElement | null>(null);
const dropdown = ref<HTMLElement | null>(null);


const logo = new URL(
  "../assets/images/logo/melody-high-resolution-logo-white.png",
  import.meta.url
).href;


const toggleDropdown = () => {
  isDropdownOpen.value = !isDropdownOpen.value;
};

const toggleMobileMenu = () => {
  isMobileMenuOpen.value = !isMobileMenuOpen.value;
};

const toggleProfileDropdown = () => {
  dropdownProfileOpen.value = !dropdownProfileOpen.value;
};


const handleRegister = () => {
  alert("Register clicked!");
};

const handleLogin = () => {
  router.push({ name: "Login" });
};

const handleClickOutside = (event: MouseEvent) => {
  if (dropdown.value && !dropdown.value.contains(event.target as Node)) {
    isDropdownOpen.value  = false;
  }
   if (profileDropdownRef.value && !profileDropdownRef.value.contains(event.target as Node)) {
    dropdownProfileOpen.value = false;
  }
};

const adminPage =()=>{
  router.push({name: "admin.dashboard"})
}

onMounted(() => {
  document.addEventListener("click", handleClickOutside);
});



onBeforeUnmount(() => {
  document.removeEventListener("click", handleClickOutside);
});
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
</style>

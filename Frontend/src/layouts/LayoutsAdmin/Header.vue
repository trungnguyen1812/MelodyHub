<template>
  <header
    :class="[
      'bg-gray-800 border-b border-gray-700 h-16 fixed top-0 right-0 z-20 transition-all duration-300 ease-in-out shadow-md',
      sidebarCollapsed ? 'left-16' : 'left-64',
    ]"
  >
    <div class="flex items-center justify-between h-full px-6">
      <!-- Left Section - Page Title & Breadcrumb -->
      <div class="flex items-center space-x-4">
        <div>
          <h1 class="text-xl font-semibold text-white">{{ pageTitle }}</h1>
          <div class="flex items-center space-x-2 text-sm text-gray-400">
            <span>Admin</span>
            <i class="bx bx-chevron-right text-xs"></i>
            <span>{{ pageTitle }}</span>
          </div>
        </div>
      </div>

      <!-- Center Section - Search Bar -->
      <div class="hidden md:flex flex-1 max-w-md mx-8">
        <div class="relative w-full">
          <input
            type="text"
            placeholder="Search music, artists, albums..."
            class="w-full bg-gray-700 border border-gray-600 rounded-lg pl-10 pr-4 py-2 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            v-model="searchQuery"
          />
          <i
            class="bx bx-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"
          ></i>
        </div>
      </div>

      <!-- Right Section - Notifications & User Menu -->
      <div class="flex items-center space-x-4">
        <!-- Mobile Search Button -->
        <button
          class="md:hidden p-2 rounded-lg bg-gray-700 hover:bg-gray-600 text-gray-300 hover:text-white transition-colors duration-200"
          @click="toggleMobileSearch"
        >
          <i class="bx bx-search text-xl"></i>
        </button>

        <!-- Notifications -->
        <div class="relative">
          <button
            class="p-2 rounded-lg bg-gray-700 hover:bg-gray-600 text-gray-300 hover:text-white transition-colors duration-200 relative"
            @click="toggleNotifications"
          >
            <i class="bx bx-bell text-xl"></i>
            <span
              class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center"
              >3</span
            >
          </button>

          <!-- Notifications Dropdown -->
          <div
            v-if="showNotifications"
            class="absolute right-0 top-12 w-80 bg-gray-800 border border-gray-700 rounded-lg shadow-xl z-50"
          >
            <div class="p-4 border-b border-gray-700">
              <h3 class="text-white font-semibold">Notifications</h3>
            </div>
            <div class="max-h-64 overflow-y-auto">
              <div
                v-for="notification in notifications"
                :key="notification.id"
                class="p-4 border-b border-gray-700 hover:bg-gray-700"
              >
                <div class="flex items-start space-x-3">
                  <div class="w-2 h-2 bg-blue-500 rounded-full mt-2"></div>
                  <div>
                    <p class="text-white text-sm">{{ notification.message }}</p>
                    <p class="text-gray-400 text-xs mt-1">
                      {{ notification.time }}
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Messages -->
        <button
          class="p-2 rounded-lg bg-gray-700 hover:bg-gray-600 text-gray-300 hover:text-white transition-colors duration-200"
        >
          <i class="bx bx-message-dots text-xl"></i>
        </button>

        <!-- User Profile Dropdown -->
        <div class="relative">
          <button
            @click="toggleUserMenu"
            class="flex items-center space-x-3 p-2 rounded-lg bg-gray-700 hover:bg-gray-600 transition-colors duration-200"
          >
            <div
              class="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center"
            >
              <i class="bx bx-user text-white"></i>
            </div>
            <div class="hidden sm:block text-left">
              <p class="text-white text-sm font-medium">Admin User</p>
              <p class="text-gray-400 text-xs">Administrator</p>
            </div>
            <i class="bx bx-chevron-down text-gray-400"></i>
          </button>

          <!-- User Menu Dropdown -->
          <div
            v-if="showUserMenu"
            class="absolute right-0 top-12 w-48 bg-gray-800 border border-gray-700 rounded-lg shadow-xl z-50"
          >
            <div class="py-2">
              <a
                href="#"
                class="flex items-center px-4 py-2 text-gray-300 hover:bg-gray-700 hover:text-white"
              >
                <i class="bx bx-user mr-3"></i>
                Profile
              </a>
              <a
                href="#"
                class="flex items-center px-4 py-2 text-gray-300 hover:bg-gray-700 hover:text-white"
              >
                <i class="bx bx-cog mr-3"></i>
                Settings
              </a>
              <div class="border-t border-gray-700 my-2"></div>
              <button
                type="button"
                @click="handleLogout"
                class="flex items-center px-4 py-2 text-gray-300 hover:bg-gray-700 hover:text-white w-full text-left"
              >
                <i class="bx bx-log-out mr-3"></i>
                Logout
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Mobile Search Bar -->
    <div
      v-if="showMobileSearch"
      class="md:hidden absolute top-16 left-0 right-0 bg-gray-800 border-b border-gray-700 p-4"
    >
      <div class="relative">
        <input
          type="text"
          placeholder="Search music, artists, albums..."
          class="w-full bg-gray-700 border border-gray-600 rounded-lg pl-10 pr-4 py-2 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          v-model="searchQuery"
        />
        <i
          class="bx bx-search absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400"
        ></i>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from "vue";
import { useAuthStore } from "@admin/auth/stores/auth.store";
import { useRouter } from "vue-router"; 
// Props
defineProps({
  sidebarCollapsed: {
    type: Boolean,
    default: false,
  },
  pageTitle: {
    type: String,
    default: "Dashboard",
  },
});

// State
const authStore = useAuthStore();
const router = useRouter();
const searchQuery = ref("");
const showNotifications = ref(false);
const showUserMenu = ref(false);
const showMobileSearch = ref(false);
const notifications = ref([
  {
    id: 1,
    message: "New song uploaded by Artist John",
    time: "5 minutes ago",
  },
  {
    id: 2,
    message: 'Album "Summer Vibes" approved',
    time: "1 hour ago",
  },
  {
    id: 3,
    message: "User reported inappropriate content",
    time: "2 hours ago",
  },
]);

// Methods
const toggleNotifications = () => {
  showNotifications.value = !showNotifications.value;
  showUserMenu.value = false;
};

const toggleUserMenu = () => {
  showUserMenu.value = !showUserMenu.value;
  showNotifications.value = false;
};

const toggleMobileSearch = () => {
  showMobileSearch.value = !showMobileSearch.value;
};

// Close dropdowns when clicking outside
const closeDropdowns = (event) => {
  if (!event.target.closest("header")) {
    showNotifications.value = false;
    showUserMenu.value = false;
  }
};

//handle logout ư
const handleLogout = async () =>{
  await authStore.logout();
  await authStore.clearAuth();
  router.push({name:'admin.login'});
}

// Lifecycle hooks
onMounted(() => {
  document.addEventListener("click", closeDropdowns);
});

onUnmounted(() => {
  document.removeEventListener("click", closeDropdowns);
});
</script>

<style scoped>
/* Custom scrollbar for notifications */
::-webkit-scrollbar {
  width: 4px;
}

::-webkit-scrollbar-track {
  background: #374151;
}

::-webkit-scrollbar-thumb {
  background: #6b7280;
  border-radius: 2px;
}

::-webkit-scrollbar-thumb:hover {
  background: #9ca3af;
}
</style>

<template>
  <footer 
    :class="[
      'bg-gray-900 border-t border-gray-700 transition-all duration-300 ease-in-out',
      sidebarCollapsed ? 'ml-16' : 'ml-64'
    ]"
  >
    <div class="px-6 py-4">
      <!-- Main Footer Content -->
      <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between">
        <!-- Left Section - Copyright & Links -->
        <div class="flex flex-col sm:flex-row sm:items-center space-y-2 sm:space-y-0 sm:space-x-6">
          
          <div class="flex items-center space-x-4 text-sm">
            <span class="text-gray-400">
              © {{ currentYear }} MELODY HUB. All rights reserved.
            </span>
          </div>
        </div>

        <!-- Center Section - Quick Links -->
        <div class="hidden lg:flex items-center space-x-6 my-4 lg:my-0">
          <a 
            v-for="link in quickLinks" 
            :key="link.id"
            :href="link.href" 
            class="text-gray-400 hover:text-white text-sm transition-colors duration-200 flex items-center space-x-1"
          >
            <i :class="link.icon" class="text-sm"></i>
            <span>{{ link.title }}</span>
          </a>
        </div>

        <!-- Right Section - System Info & Status -->
        <div class="flex flex-col sm:flex-row sm:items-center space-y-2 sm:space-y-0 sm:space-x-4 text-sm">
          <!-- System Status -->
          <div class="flex items-center space-x-2">
            <div class="flex items-center space-x-1">
              <div class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
              <span class="text-gray-400">System Status:</span>
              <span class="text-green-400 font-medium">Online</span>
            </div>
          </div>

          <!-- Version Info -->
          <div class="flex items-center space-x-2">
            <span class="text-gray-400">Version:</span>
            <span class="text-blue-400 font-medium">v2.1.0</span>
          </div>

          <!-- Last Updated -->
          <div class="flex items-center space-x-2">
            <i class="bx bx-time text-gray-400"></i>
            <span class="text-gray-400">Last updated: {{ lastUpdated }}</span>
          </div>
        </div>
      </div>

      <!-- Mobile Quick Links -->
      <div class="lg:hidden mt-4 pt-4 border-t border-gray-700">
        <div class="grid grid-cols-2 sm:grid-cols-4 gap-3">
          <a 
            v-for="link in quickLinks" 
            :key="link.id"
            :href="link.href" 
            class="text-gray-400 hover:text-white text-sm transition-colors duration-200 flex items-center space-x-2 p-2 rounded hover:bg-gray-800"
          >
            <i :class="link.icon" class="text-sm"></i>
            <span>{{ link.title }}</span>
          </a>
        </div>
      </div>

      <!-- Additional Info for Mobile -->
      <div class="lg:hidden mt-4 pt-4 border-t border-gray-700">
        <div class="flex flex-col space-y-2 text-xs text-gray-500">
          <div class="flex items-center justify-between">
            <span>Server Response Time:</span>
            <span class="text-green-400">{{ serverResponseTime }}ms</span>
          </div>
          <div class="flex items-center justify-between">
            <span>Active Users:</span>
            <span class="text-blue-400">{{ activeUsers }}</span>
          </div>
          <div class="flex items-center justify-between">
            <span>Total Songs:</span>
            <span class="text-purple-400">{{ totalSongs.toLocaleString() }}</span>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue';

// Methods (defined first to avoid initialization issues)
const formatDate = (date) => {
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
};

// Props
defineProps({
  sidebarCollapsed: {
    type: Boolean,
    default: false
  }
});

// State
const currentYear = ref(new Date().getFullYear());
const lastUpdated = ref(formatDate(new Date()));
const serverResponseTime = ref(45);
const activeUsers = ref(1247);
const totalSongs = ref(125430);
const quickLinks = ref([

  {
    id: 2,
    title: 'Support',
    icon: 'bx bx-help-circle',
    href: '#'
  },
  {
    id: 3,
    title: 'API Status',
    icon: 'bx bx-server',
    href: '#'
  },
  {
    id: 4,
    title: 'Privacy Policy',
    icon: 'bx bx-shield',
    href: '#'
  }
]);

// Periodic server stats update
let intervalId = null;
onMounted(() => {
  intervalId = setInterval(() => {
    serverResponseTime.value = Math.floor(Math.random() * 100) + 20;
    activeUsers.value = Math.floor(Math.random() * 500) + 1000;
  }, 30000); // Update every 30 seconds
});

onUnmounted(() => {
  if (intervalId) {
    clearInterval(intervalId);
  }
});
</script>

<style scoped>
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
</style>
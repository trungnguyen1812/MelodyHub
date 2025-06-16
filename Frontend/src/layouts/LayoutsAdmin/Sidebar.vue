<template>
  <div
    class="bg-gray-900 text-white h-screen w-64 fixed left-0 top-0 z-30 shadow-xl"
  >
    <!-- Logo Section -->
    <div class="flex items-center justify-center h-16 border-b border-gray-700">
      <div v-if="!isCollapsed" class="flex items-center space-x-2">
        <i class="bx bx-music text-2xl text-blue-400"></i>
        <span class="text-xl font-bold text-white">MELODY HUB</span>
      </div>
      <div v-else class="flex items-center justify-center">
        <i class="bx bx-music text-2xl text-blue-400"></i>
      </div>
    </div>


    <!-- Navigation Menu -->
    <nav class="mt-6">
      <ul class="space-y-2 px-3">
        <li v-for="item in menuItems" :key="item.id">
          <a
            :href="item.href"
            :class="[
              'flex items-center py-3 px-3 rounded-lg transition-all duration-200 hover:bg-gray-800 group',
              item.active
                ? 'bg-blue-600 text-white'
                : 'text-gray-300 hover:text-white',
            ]"
          >
            <i :class="item.icon" class="text-xl"></i>
            <transition name="slide-fade">
              <span v-if="!isCollapsed" class="ml-3 font-medium">{{
                item.title
              }}</span>
            </transition>
            <div
              v-if="isCollapsed"
              class="tooltip tooltip-right"
              :data-tip="item.title"
            ></div>
          </a>
        </li>
      </ul>
    </nav>

    <!-- User Profile Section -->
    <div class="absolute bottom-4 left-0 right-0 px-3">
      <div
        :class="[
          'flex items-center p-3 rounded-lg bg-gray-800 border border-gray-700',
          isCollapsed ? 'justify-center' : '',
        ]"
      >
        <div
          class="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center"
        >
          <i class="bx bx-user text-white"></i>
        </div>
        <transition name="slide-fade">
          <div v-if="!isCollapsed" class="ml-3">
            <p class="text-sm font-medium text-white">Admin User</p>
            <p class="text-xs text-gray-400">admin@melodyhub.com</p>
          </div>
        </transition>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";

// Emits
const emit = defineEmits(["sidebar-toggle"]);

// State
const isCollapsed = ref(false);
const menuItems = ref([
  {
    id: 1,
    title: "Dashboard",
    icon: "bx bx-home-alt",
    href: "#",
    active: true,
  },
  {
    id: 2,
    title: "Music Library",
    icon: "bx bx-music",
    href: "#",
    active: false,
  },
  {
    id: 3,
    title: "Artists",
    icon: "bx bx-user-voice",
    href: "#",
    active: false,
  },
  {
    id: 4,
    title: "Albums",
    icon: "bx bx-album",
    href: "#",
    active: false,
  },
  {
    id: 5,
    title: "Playlists",
    icon: "bx bx-list-ul",
    href: "#",
    active: false,
  },
  {
    id: 6,
    title: "Users",
    icon: "bx bx-group",
    href: "#",
    active: false,
  },
  {
    id: 7,
    title: "Analytics",
    icon: "bx bx-bar-chart-alt-2",
    href: "#",
    active: false,
  },
  {
    id: 8,
    title: "Settings",
    icon: "bx bx-cog",
    href: "#",
    active: false,
  },
]);

// Methods
const toggleSidebar = () => {
  isCollapsed.value = !isCollapsed.value;
  emit("sidebar-toggle", isCollapsed.value);
};
</script>

<style scoped>
.slide-fade-enter-active,
.slide-fade-leave-active {
  transition: all 0.3s ease;
}

.slide-fade-enter-from,
.slide-fade-leave-to {
  opacity: 0;
  transform: translateX(-10px);
}

.tooltip {
  position: relative;
}

.tooltip:hover::after {
  content: attr(data-tip);
  position: absolute;
  left: 100%;
  top: 50%;
  transform: translateY(-50%);
  background: #374151;
  color: white;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  white-space: nowrap;
  z-index: 1000;
  margin-left: 8px;
}
</style>

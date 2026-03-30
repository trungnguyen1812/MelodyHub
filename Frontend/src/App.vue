<template>
  <Notification />
  <component :is="layout">
    <router-view />
  </component>
  <GlobalMiniPlayer/>
</template>

<script setup lang="ts">
import { useRoute } from "vue-router";
import { computed, onMounted } from "vue";
import { useAuthStore } from "@/store/authStore";

import DefaultLayout from "@/layouts/ClientLayout.vue";
import AdminLayout from "@/layouts/AdminLayout.vue";
import Notification from '@/components/common/VcNotification/Notification.vue'; 
import GlobalMiniPlayer from '@/components/common/VcGlobalMiniPlayer/GlobalMiniPlayer.vue'

const route = useRoute();
const authStore = useAuthStore();

const layout = computed(() => {
  const l = route.meta.layout;
  if (l === "admin") return AdminLayout;
  if (l === "none" || !l) return "EmptyLayout";
  return DefaultLayout;
});

const isAdminLayout  = computed(() => layout.value === AdminLayout)
const isClientLayout = computed(() => layout.value === DefaultLayout)

onMounted(async () => {
  if (authStore.isAuthenticated && !authStore.permissionLoaded) {
    try {
      await authStore.checkPermission();
    } catch {
      authStore.permissionLoaded = true;
    }
  } else {
    authStore.permissionLoaded = true;
  }
});
</script>

<style>
html, body {
  height: 100%;
  margin: 0;
  padding: 0;
  background: linear-gradient(to bottom, #081019, #0c191c);
  color: #ffffff;
  font-family: sans-serif;
}
</style>
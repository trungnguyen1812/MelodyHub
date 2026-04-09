<template>
  <Notification />
  <component :is="layout">
    <router-view />
  </component>
  <GlobalMiniPlayer/>
  <ShareModal /> 
</template>

<script setup lang="ts">
import { useRoute } from "vue-router";
import { computed, onMounted } from "vue";
import { useAuthStore } from "@/store/authStore";

import DefaultLayout from "@/layouts/ClientLayout.vue";
import AdminLayout from "@/layouts/AdminLayout.vue";
import Notification from '@/components/common/VcNotification/Notification.vue'; 
import GlobalMiniPlayer from '@/components/common/VcGlobalMiniPlayer/GlobalMiniPlayer.vue'
import { useUserStore } from '@/modules/client/stores/users/UserStore';
import ShareModal  from '@/components/common/VcBtnAction/ShareModal.vue';

const route = useRoute();
const authStore = useAuthStore();
const userStore = useUserStore();

const layout = computed(() => {
  const l = route.meta.layout;
  if (l === "admin") return AdminLayout;
  if (l === "none" || !l) return "EmptyLayout";
  return DefaultLayout;
});


onMounted(async () => {
  if (!authStore.isAuthenticated) {
    authStore.permissionLoaded = true;
    return;
  }

  if (authStore.permissionLoaded) return;

  try {
    await Promise.all([
      authStore.checkPermission(),    
      userStore.fetchSubscriptionStatus(),
    ]);
  } catch {
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
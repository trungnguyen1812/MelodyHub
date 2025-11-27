<template>
   <Notification />
  <component :is="layout">
    <router-view />
  </component>
 
</template>

<script setup lang="ts">
import { useRoute } from "vue-router";
import { computed } from "vue";

// Layouts
import DefaultLayout from "@/layouts/ClientLayout.vue";
import AdminLayout from "@/layouts/AdminLayout.vue";
import NoneLayout from '@/layouts/NoneLayout.vue';
import Notification from '@/components/common/VcNotification/Notification.vue'; 

const route = useRoute();

const layout = computed(() => {
  const layoutType = route.meta.layout;
  if (layoutType === "admin") return AdminLayout;
  else if (layoutType === 'none') {
    return NoneLayout;
  }
  return DefaultLayout; // mặc định là client
});
</script>

<style>
html,
body {
  height: 100%;
  margin: 0;
  padding: 0;
  background: linear-gradient(to bottom, #081019, #0c191c);
  color: #ffffff; /* màu chữ trắng nếu cần */
  font-family: sans-serif; /* tùy chọn */
}
</style>
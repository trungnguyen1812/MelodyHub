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
import Notification from '@/components/common/VcNotification/Notification.vue'; 

const route = useRoute();

const layout = computed(() => {
  const l = route.meta.layout;
  if (l === "admin") return AdminLayout;
  if (l === "none" || !l) return "EmptyLayout"; // ← fallback an toàn
  return DefaultLayout;
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
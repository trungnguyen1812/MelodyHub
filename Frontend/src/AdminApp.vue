<template>
  <AdminLayout>
    <router-view />
  </AdminLayout>
</template>

<script setup lang="ts">
import AdminLayout from "@/layouts/AdminLayout.vue";
</script>

<style lang="scss">
// Admin SCSS
@use 'styles/style';
@use 'styles/examples';
</style>

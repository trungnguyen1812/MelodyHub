<!-- src/layouts/AdminLayout.vue -->
<template>
  <div class="admin-layout">
    <Sidebar />
    <div class="main-content">
      <Header />
      <main class="page-view">
        <router-view />
      </main>
      <Footer />
    </div>
  </div>
</template>

<script setup lang="ts">
import Sidebar from '@/layouts/LayoutsAdmin/Sidebar.vue';
import Header from '@/layouts/LayoutsAdmin/Header.vue';
import Footer from '@/layouts/LayoutsAdmin/Footer.vue';
</script>

<style scoped>
.admin-layout {
  display: flex;
  height: 100vh;
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.page-view {
  flex: 1;
  padding: 1rem;
  overflow-y: auto;
}
</style>

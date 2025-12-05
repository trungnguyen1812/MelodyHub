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
  font-family: 'Afacad', sans-serif;
  background: linear-gradient(to bottom, #000000, #0f2024);
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

.permission-checking {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.loading-container {
  background: white;
  padding: 3rem;
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
  text-align: center;
  max-width: 400px;
  width: 90%;
}

/* Spinner Animation */
.spinner {
  display: flex;
  justify-content: center;
  gap: 12px;
  margin-bottom: 2rem;
}

.spinner-circle {
  width: 16px;
  height: 16px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  animation: bounce 1.4s infinite ease-in-out both;
}

.spinner-circle:nth-child(1) { animation-delay: -0.32s; }
.spinner-circle:nth-child(2) { animation-delay: -0.16s; }

@keyframes bounce {
  0%, 80%, 100% { transform: scale(0); }
  40% { transform: scale(1); }
}

/* Progress Bar */
.progress-container {
  width: 100%;
  height: 4px;
  background: #f1f5f9;
  border-radius: 2px;
  margin-top: 2rem;
  overflow: hidden;
}

.progress-bar {
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, #667eea 0%, #061c52 100%);
  border-radius: 2px;
  animation: progress 2s ease-in-out infinite;
}

@keyframes progress {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(100%); }
}

/* Text Styles */
.text-primary {
  color: #1e293b;
  font-size: 1.5rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
}

.text-muted {
  color: #64748b;
  font-size: 0.95rem;
}
</style>
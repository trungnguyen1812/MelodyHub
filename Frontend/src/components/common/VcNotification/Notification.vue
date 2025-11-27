<template>
    <div 
        v-if="message" 
        class="fixed top-20 right-4 max-w-sm w-full p-4 rounded-lg shadow-lg transition-all duration-300 z-50"
        :class="{
        'bg-green-500 text-white': type === 'success',
        'bg-red-500 text-white': type === 'error',
        'bg-blue-500 text-white': type === ''
        }"
    >
    <div class="flex items-center justify-between">
      <div class="flex items-center">
        <svg v-if="type === 'success'" class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path>
        </svg>
        <svg v-if="type === 'error'" class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
        </svg>
        <span>{{ message }}</span>
      </div>
      <button @click="handleClose" class="text-white hover:text-gray-200">
        <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
        </svg>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useNotificationStore } from '@/store/notificationStore';
import { storeToRefs } from 'pinia';

const notificationStore = useNotificationStore();
const { message, type } = storeToRefs(notificationStore);

const handleClose = () => {
  notificationStore.clear();
};

import { watch } from 'vue';

watch(
  () => message.value,
  (newMessage) => {
    if (newMessage) {
      setTimeout(() => {
        notificationStore.clear();
      }, 3000);
    }
  }
);
</script>
<style scoped>
.notification-container {
  position: fixed !important;
  top: 1rem !important;
  right: 1rem !important;
  max-width: 24rem !important;
  width: 100% !important;
  padding: 1rem !important;
  border-radius: 0.5rem !important;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05) !important;
  transition: all 0.3s !important;
  z-index: 9999 !important;
}
</style>
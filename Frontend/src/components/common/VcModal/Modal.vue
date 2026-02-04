<template>
  <div v-if="modelValue" class="modal-backdrop" @click.self="$emit('update:modelValue', false)">
    <div class="modal" :class="{ 'modal-visible': modelValue }">
      <header class="modal-header">
        <h3>{{ title }}</h3>
        <button @click="$emit('update:modelValue', false)" class="modal-close-btn">×</button>
      </header>
      <section class="modal-body">
        <slot></slot>
      </section>
      <footer class="modal-footer">
        <slot name="footer"></slot>
      </footer>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  modelValue: boolean;
  title?: string;
}>();

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
}>();
</script>

<style scoped>
/* QUAN TRỌNG: Reset opacity và z-index */
.modal-backdrop {
  position: fixed;
  top: 0; 
  left: 0;
  width: 100vw; 
  height: 100vh;
  background: rgba(0, 0, 0, 0.85); /* Tăng opacity lên 0.85 */
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 99999; /* Tăng z-index rất cao */
  animation: fadeIn 0.3s ease;
  opacity: 1 !important; /* Force hiển thị */
  visibility: visible !important;
}

.modal {
  background: rgba(20, 25, 35, 0.98); /* Nền tối hơn, opacity cao hơn */
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  padding: 2rem;
  border-radius: 16px;
  width: 500px;
  max-width: 90%;
  max-height: 80vh;
  overflow-y: auto;
  border: 2px solid rgba(0, 170, 255, 0.8); /* Viền dày hơn, sáng hơn */
  box-shadow: 
    0 0 30px rgba(0, 170, 255, 0.7),
    0 0 60px rgba(0, 170, 255, 0.4),
    0 20px 80px rgba(0, 0, 0, 0.8),
    inset 0 0 20px rgba(0, 170, 255, 0.1);
  animation: modalPop 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  font-family: 'Afacad', sans-serif;
  color: white;
  opacity: 1 !important;
  transform: scale(1) !important;
  z-index: 100000;
}

/* Thêm class để chắc chắn modal hiển thị */
.modal-visible {
  opacity: 1 !important;
  visibility: visible !important;
  transform: scale(1) !important;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 1rem;
  border-bottom: 2px solid rgba(0, 170, 255, 0.4);
  margin-bottom: 1.5rem;
}

.modal-header h3 {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 600;
  background: linear-gradient(90deg, #00aaff, #00ffaa);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: 0 0 10px rgba(0, 170, 255, 0.5);
}

.modal-close-btn {
  background: rgba(255, 255, 255, 0.15);
  border: 2px solid rgba(0, 170, 255, 0.5);
  color: white;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.8rem;
  font-weight: 300;
  transition: all 0.3s ease;
  line-height: 1;
  padding-bottom: 4px;
}

.modal-close-btn:hover {
  background: rgba(0, 170, 255, 0.3);
  border-color: #00aaff;
  transform: rotate(90deg) scale(1.1);
  box-shadow: 0 0 15px rgba(0, 170, 255, 0.5);
}

.modal-body {
  margin: 1.5rem 0;
  opacity: 1 !important;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 1rem;
  padding-top: 1.5rem;
  border-top: 2px solid rgba(0, 170, 255, 0.4);
}

/* Scrollbar styling cho modal */
.modal::-webkit-scrollbar {
  width: 8px;
}

.modal::-webkit-scrollbar-thumb {
  background: linear-gradient(to bottom, #00aaff, #00ffaa);
  border-radius: 4px;
}

.modal::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 4px;
}

/* Animations mạnh hơn */
@keyframes fadeIn {
  from {
    opacity: 0;
    background: rgba(0, 0, 0, 0);
  }
  to {
    opacity: 1;
    background: rgba(0, 0, 0, 0.85);
  }
}

@keyframes modalPop {
  0% {
    opacity: 0;
    transform: scale(0.8) translateY(20px);
  }
  50% {
    transform: scale(1.05);
  }
  100% {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

/* Responsive */
@media (max-width: 768px) {
  .modal {
    width: 90%;
    padding: 1.5rem;
    margin: 20px;
  }
  
  .modal-header h3 {
    font-size: 1.3rem;
  }
}

@media (max-width: 480px) {
  .modal {
    width: 95%;
    padding: 1.2rem;
    margin: 10px;
  }
  
  .modal-footer {
    flex-direction: column;
  }
  
  .modal-footer button {
    width: 100%;
  }
}
</style>
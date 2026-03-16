<template>
  <span>{{ currentValue.toLocaleString() }}</span>
</template>

<script setup>
import { ref, watch, onUnmounted } from 'vue';

const props = defineProps({
  endVal: { type: Number, required: true },
  duration: { type: Number, default: 2 }
});

const currentValue = ref(0);
let interval = null;

const startAnimation = (target) => {
  // Clear interval cũ
  if (interval) clearInterval(interval);
  
  const start = currentValue.value;
  const end = target;
  const steps = 60; // 60fps
  const totalSteps = Math.ceil(props.duration * 30);
  const increment = (end - start) / totalSteps;
  let step = 0;
  
  interval = setInterval(() => {
    step++;
    if (step >= totalSteps) {
      currentValue.value = end;
      clearInterval(interval);
      interval = null;
    } else {
      currentValue.value = Math.floor(start + increment * step);
    }
  }, 1000 / 60);
};

watch(() => props.endVal, (newVal) => {
  if (newVal > 0) {
    startAnimation(newVal);
  } else {
    currentValue.value = 0;
  }
}, { immediate: true });

onUnmounted(() => {
  if (interval) clearInterval(interval);
});
</script>
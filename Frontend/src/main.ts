import { createApp } from 'vue';
import { createPinia } from 'pinia';
import { PiniaColada } from '@pinia/colada'
import VueApexCharts from 'vue3-apexcharts';
import router from './modules/router';
import Notification from '@/components/common/VcNotification/Notification.vue';
import App from './App.vue';
import api from '@/utils/axios';

// ─── 1.  app & pinia   ───────────────────────────────────────────
const app = createApp(App);
const pinia = createPinia();

// ─── 2.  Pinia  ───────────────────
app.use(pinia);

// ─── 3.  Router ───────────────────────────────────────────────────────────
app.use(router);

// ─── 3.  colada ───────────────────────────────────────────────────────────
app.use(PiniaColada);

// ─── 4. Global properties ────────────────────────────────────────────────────
app.config.globalProperties.$api = api;

declare module 'vue' {
  interface ComponentCustomProperties {
    $api: typeof api;
  }
}

// ─── 5. Global components ────────────────────────────────────────────────────
app.component('apexchart', VueApexCharts);
app.component('Notification', Notification);

// ─── 6. Custom directive: v-count-up ─────────────────────────────────────────
function runCountUp(el: HTMLElement, startVal: number, endVal: number, duration: number) {
  let current = startVal;
  const increment = (endVal - startVal) / (duration * 60); // 60fps

  const update = () => {
    current += increment;
    if (current < endVal) {
      el.textContent = Math.floor(current).toLocaleString();
      requestAnimationFrame(update);
    } else {
      el.textContent = endVal.toLocaleString();
    }
  };

  update();
}

app.directive('count-up', {
  mounted(el, binding) {
    const { startVal = 0, endVal = 0, duration = 2 } = binding.value ?? {};
    runCountUp(el, startVal, endVal, duration);
  },
  updated(el, binding) {
    if (binding.value?.endVal !== binding.oldValue?.endVal) {
      const { startVal = 0, endVal = 0, duration = 2 } = binding.value ?? {};
      runCountUp(el, startVal, endVal, duration);
    }
  },
});

// ─── 7. Mount  ───────────────────────────────────────────────────────
app.mount('#app');
import { createApp } from 'vue';
import { createPinia } from "pinia";
import VueApexCharts from "vue3-apexcharts";
import router from "./modules/router";
import Notification from '@/components/common/VcNotification/Notification.vue';
import App from './App.vue';
import api from '@/utils/axios';

const app = createApp(App);
const pinia = createPinia();

// Gắn axios vào global
app.config.globalProperties.$api = api;

declare module 'vue' {
  interface ComponentCustomProperties {
    $api: typeof api;
  }
}

// Tạo custom directive cho count-up
app.directive('count-up', {
  mounted(el, binding) {
    const { startVal = 0, endVal, duration = 2 } = binding.value;
    let current = startVal;
    const increment = (endVal - startVal) / (duration * 60); // 60fps
    
    const updateNumber = () => {
      current += increment;
      if (current < endVal) {
        el.textContent = Math.floor(current).toLocaleString();
        requestAnimationFrame(updateNumber);
      } else {
        el.textContent = endVal.toLocaleString();
      }
    };
    
    updateNumber();
  },
  updated(el, binding) {
    if (binding.value.endVal !== binding.oldValue?.endVal) {
      // Cập nhật khi giá trị thay đổi
      const { startVal = 0, endVal, duration = 2 } = binding.value;
      let current = startVal;
      const increment = (endVal - startVal) / (duration * 60);
      
      const updateNumber = () => {
        current += increment;
        if (current < endVal) {
          el.textContent = Math.floor(current).toLocaleString();
          requestAnimationFrame(updateNumber);
        } else {
          el.textContent = endVal.toLocaleString();
        }
      };
      
      updateNumber();
    }
  }
});

app.component("apexchart", VueApexCharts);
app.component('Notification', Notification);

app.use(pinia);
app.use(router);

app.mount('#app');
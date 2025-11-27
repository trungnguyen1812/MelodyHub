import { createApp } from 'vue';
import { createPinia } from "pinia";
import VueApexCharts from "vue3-apexcharts";
import router from "./modules/router";
import Notification from '@/components/common/VcNotification/Notification.vue'; // Thêm dòng này

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
app.component("apexchart", VueApexCharts);
app.component('Notification', Notification); // Thêm dòng này
app.use(pinia);
app.use(router);
app.mount('#app');

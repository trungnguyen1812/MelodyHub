// import './assets/main.css'
import { createApp } from "vue";
import { createPinia } from 'pinia';
import App from "./App.vue";
import VueApexCharts from "vue3-apexcharts";
import router from "./modules/router";

const pinia = createPinia();
const app = createApp(App);

app.use(pinia);
app.component("apexchart", VueApexCharts);
app.use(router);
app.mount("#app");

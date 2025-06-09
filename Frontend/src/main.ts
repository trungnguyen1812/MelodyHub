// import './assets/main.css'
import { createApp } from "vue";
import App from "./App.vue";
import VueApexCharts from "vue3-apexcharts";
import router from "./modules/router";
const app = createApp(App);
app.component("apexchart", VueApexCharts);
app.use(router);
app.mount("#app");

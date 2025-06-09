import type { RouteRecordRaw } from "vue-router";
import HomeView from "@client/dashboard/views/HomeView.vue";

// ========================== ROUTER =============================
export const ROUTER_DASHBOARD: RouteRecordRaw[] = [
  {
    path: "/",
    name: "Home",
    component: HomeView,
    meta: {
      layout: "client",
    },
  },
];

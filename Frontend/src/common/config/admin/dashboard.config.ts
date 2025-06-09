import dashboardView from '@admin/dashboard/views/DashboardView.vue';


export const ROUTER_DASHBOARD = [
    {
        path: "/admin",
        name: "admin",
        component: dashboardView,
        meta: { layout: "admin" },
    },
];
import DashboardView  from '@admin/auth/views/LoginAdminView.vue';

export const ROUTER_AUTH_ADMIN = [
     {
        path: "/admin/login",
        name: "admin.login",
        component: DashboardView,
        meta: { 
            layout: "none",
            requiresAuth: true 
        },
    },
];
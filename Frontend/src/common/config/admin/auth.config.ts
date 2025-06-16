import LoginAdminView from '@admin/auth/views/LoginAdminView.vue';

export const ROUTER_AUTH_ADMIN = [
    {
        path:"/admin/login",
        name:"LoginAdmin",
        component:LoginAdminView,
        meta:{layout: "none"}
    }
];
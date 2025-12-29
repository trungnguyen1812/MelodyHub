import LoginAdminView from '@/modules/admin/views/auth/LoginAdminView.vue'; 

export const ROUTER_AUTH_ADMIN = [
  {
    path: "/admin/login",
    name: "admin.login",
    component: LoginAdminView, 
    meta: { 
      layout: "none",
      requiresAuth: false 
    },
  },
];

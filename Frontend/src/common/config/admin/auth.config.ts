import LoginAdminView from '@admin/auth/views/LoginAdminView.vue'; 

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

export default ROUTER_AUTH_ADMIN;
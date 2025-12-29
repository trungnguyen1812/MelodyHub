import LoginView from "@/modules/client/views/auth/login.vue";
import RegisterView from "@/modules/client/views/auth/register.vue";
import LoginSuccessView from '@/modules/client/views/auth/LoginSuccess.vue';

// ========================== ROUTER =============================
export const ROUTER_AUTH = [
  {
    path: "/Login",
    name: "Login",
    component: LoginView,
    meta: { layout: "none" },
  },
 
  {
    path: "/Register",
    name: "Register",
    component: RegisterView,
    meta: { layout: "none" },
  },

  {
    path: "/login-success",
    name: "login.success",
    component: LoginSuccessView,
    meta: {
      layout: "none",
    },
  },
];

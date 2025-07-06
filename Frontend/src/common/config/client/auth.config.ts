import LoginView from "@client/auth/views/login.vue";
import RegisterView from "@client/auth/views/register.vue";
import LoginSuccessView from '@client/auth/views/LoginSuccess.vue';

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

import LoginView from "@client/auth/views/login.vue";
import RegisterView from "@client/auth/views/register.vue";

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
];

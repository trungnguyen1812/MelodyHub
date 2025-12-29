import { createRouter, createWebHistory } from "vue-router";
import NProgress from 'nprogress';
import 'nprogress/nprogress.css';
import api from '@/plugins/axios';

import DefaultRoutes from '@/modules/default/routers/index.default.router';
// impoort router admin
import {ROUTER_ADMIN} from '@/common/config/admin/admin.config';
import {ROUTER_AUTH_ADMIN} from '@/common/config/admin/auth.config';
// impoort router client
import {CLIENT_ROUTES} from '@/common/config/client/client.config';
import {ROUTER_AUTH} from '@/common/config/client/auth.config';

import { useAuthStore } from "@/store/authStore";
import {ref} from 'vue';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    // router default
    ...DefaultRoutes,
    // router client
    ...CLIENT_ROUTES,
    ...ROUTER_AUTH,
    // router admin
    ...ROUTER_ADMIN,
    ...ROUTER_AUTH_ADMIN,
  ],
});

let permissionCache: { isAdmin: boolean; timestamp: number } | null = null;
const CACHE_DURATION = 5 * 60 * 1000; 

router.beforeEach(async (to, from) => {
  NProgress.start();

  // Không phải admin → cho đi thẳng
  if (!to.path.startsWith('/admin')) {
    NProgress.done();
    return true;
  }

  const client_token = localStorage.getItem('client_token');
  const admin_token  = localStorage.getItem('admin_token');
  const auth = useAuthStore();

  // Chưa login client
  if (!client_token) {
    NProgress.done();
    return { path: '/login' };
  }

  try {
    const now = Date.now();
    let isAdmin = false;

    if (permissionCache && now - permissionCache.timestamp < CACHE_DURATION) {
      isAdmin = permissionCache.isAdmin;
    } else {
      const data = await auth.checkPermission();
      isAdmin = data.is_admin;
      permissionCache = { isAdmin, timestamp: now };
    }

    if (!isAdmin) {
      NProgress.done();
      return { path: '/403' };
    }

    if (!admin_token && !to.path.startsWith('/admin/login')) {
      const rawUser = localStorage.getItem('auth_user');
      if (!rawUser) {
        NProgress.done();
        return { path: '/login' };
      }
      const user = JSON.parse(rawUser);
      const email = user.email;
      await auth.sendEmail(email);
      NProgress.done();
      return { path: '/admin/login' };
    }

    NProgress.done();
    return true;

  } catch (error) {
    console.error(error);
    NProgress.done();
    return { path: '/admin/login' };
  }
});

router.afterEach(() => {
  NProgress.done();
});

export default router;
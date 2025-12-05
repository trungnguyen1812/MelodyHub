import { createRouter, createWebHistory } from "vue-router";
import NProgress from 'nprogress';
import 'nprogress/nprogress.css';
import api from '@/plugins/axios'; // ✅ Import axios instance

// Import các module routes
import DefaultRoutes from '@/modules/default/routers/index.default.router';
import ClientRoutes from "@client/dashboard/routers/index.dashboard.router";
import AuthRoutes from '@client/auth/routers/index.auth.router';
import ArtistsRoutes from '@client/artists/routers/index.allartists.router';
import MusicsRoutes from '@client/music/routers/index.allmusic.router';
import DashboardAdminRoutes from '@admin/dashboard/routers/index.dashboard.router';
import AuthAdminRoutes from '@admin/auth/routers/index.auth.router';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    ...DefaultRoutes,
    ...ClientRoutes,
    ...AuthRoutes,
    ...ArtistsRoutes,
    ...MusicsRoutes,
    ...DashboardAdminRoutes,
    ...AuthAdminRoutes,
  ],
});
let permissionCache: { isAdmin: boolean; timestamp: number } | null = null;
const CACHE_DURATION = 5 * 60 * 1000; 

// Navigation guard
router.beforeEach(async (to, from, next) => {
  NProgress.start();
  if (!to.path.startsWith('/admin')) {
    return next();
  }
  const token = localStorage.getItem('auth_token');
  if (to.path === '/admin/login') {
    if (!token) {
      return next();
    }
    try {
      const response = await api.get('/admin/check-permission');
      if (response.status === 200 && response.data.is_admin === true) {
        const userData = response.data.user;
        localStorage.setItem('auth_user', JSON.stringify({
          ...userData,
          roles_flags: response.data.roles_flags || userData.roles_flags
        }));
        NProgress.done();
        return next({ path: '/admin' });
      } else {
        NProgress.done();
        return next({ path: '/403' });
      }
    } catch (err: any) {
      console.error('Permission check error:', err);
      if (err.response?.status === 401) {
        localStorage.removeItem('auth_token');
        localStorage.removeItem('auth_user');
        return next();
      }
      return next();
    }
  }

  if (!token) {
    NProgress.done();
    return next({ path: '/admin/login' });
  }
  try {
    const now = Date.now();
    if (permissionCache && (now - permissionCache.timestamp) < CACHE_DURATION) {
      if (permissionCache.isAdmin) {
        return next();
      } else {
        NProgress.done();
        return next({ path: '/403' });
      }
    }
    const response = await api.get('/admin/check-permission');
    if (response.status === 200 && response.data.is_admin === true) {
      const userData = response.data.user;
      localStorage.setItem('auth_user', JSON.stringify({
        ...userData,
        roles_flags: response.data.roles_flags || userData.roles_flags
      }));
      permissionCache = {
        isAdmin: true,
        timestamp: now
      };
      return next();
    } else {
      permissionCache = {
        isAdmin: false,
        timestamp: now
      };
      NProgress.done();
      return next({ path: '/403' });
    }
    
  } catch (err: any) {
    console.error('Permission check error:', err);
    if (err.response?.status === 401) {
      localStorage.removeItem('auth_token');
      localStorage.removeItem('auth_user');
      permissionCache = null;
      NProgress.done();
      return next({ path: '/admin/login' });
    } else if (err.response?.status === 403) {
      NProgress.done();
      return next({ path: '/403' });
    } else {
      console.error('Network error, redirecting to login');
      NProgress.done();
      return next({ path: '/admin/login' });
    }
  }
});

router.afterEach(() => {
  NProgress.done();
});

export default router;
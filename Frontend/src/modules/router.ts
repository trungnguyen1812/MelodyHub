import { createRouter, createWebHistory } from "vue-router";
import NProgress from 'nprogress'
import 'nprogress/nprogress.css' // quan trọng: import CSS
import client from "@client/dashboard/routers/index.dashboard.router";
import Auth from '@client/auth/routers/index.auth.router';
import Artists from '@client/artists/routers/index.allartists.router';
import Musics from '@client/music/routers/index.allmusic.router';
// router admin
import DashboardAdmin from '@admin/dashboard/routers/index.dashboard.router';
import AuthAdmin from '@admin/auth/routers/index.auth.router';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    //router client
    ...client,
    ...Auth,
    ...Artists,
    ...Musics,
    //router admin 
    ...DashboardAdmin,
    ...AuthAdmin,
  ],
});

// Bắt đầu khi chuyển route
router.beforeEach((to, from, next) => {
  NProgress.start();

  const token = localStorage.getItem('auth_token');

  // Nếu vào /admin (hoặc bất kỳ route nào bắt đầu bằng /admin) mà chưa có token
  if (to.path.startsWith('/admin') && to.path !== '/admin/login' && !token) {
    return next({ path: '/admin/login' });
  }

  next(); // Cho phép chuyển route nếu hợp lệ
});

// Kết thúc khi chuyển xong
router.afterEach(() => {
  NProgress.done()
})

export default router;
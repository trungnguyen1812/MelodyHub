import AdminLayout from '@/layouts/AdminLayout.vue';
import DashboardView from '@/modules/admin/views/dashboard/DashboardView.vue';
import UserManagerView from '@/modules/admin/views/users/UserManagerView.vue';

// ĐẢM BẢO EXPORT ĐÚNG
export const ROUTER_ADMIN = [
  {
    path: "/admin",
    component: AdminLayout,
    meta: { 
      layout: "none",
      requiresAuth: true 
    },
    children: [
      {
        path: "",
        name: "admin.dashboard",
        component: DashboardView,
        meta: { 
          requiresAuth: true,
          requiresAdmin: true 
        }
      },
      {
        path: "usermanager",
        name: "admin.usermanager",
        component: UserManagerView,
        meta: { 
          requiresAuth: true,
          requiresAdmin: true 
        }
      }
    ]
  },
];

import AdminLayout from '@/layouts/AdminLayout.vue';
import DashboardView from '@admin/dashboard/views/DashboardView.vue';

// ĐẢM BẢO EXPORT ĐÚNG
export const ROUTER_DASHBOARD = [
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
      }
    ]
  },
];

// Export default để config import
export default ROUTER_DASHBOARD;
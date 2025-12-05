import View403 from '@/modules/default/403View.vue';
import View404 from '@/modules/default/404View.vue';

export const ROUTER_DEFAULT_ADMIN = [
    {
        path: "/404",
        name: "404",
        component:View404,
        meta: { 
            layout: "none",
            requiresAuth: true 
        },
    },
    {
        path: "/403",
        name: "403",
        component:View403,
        meta: { 
            layout: "none",
            requiresAuth: true 
        },
    },
]
import AllNewMusicView from '@/modules/client/music/views/AllNewMusicView.vue';
import AllPopularMusicView from '@/modules/client/music/views/AllPopularMusicView.vue';

// ========================== ROUTER =============================
export const ROUTER_MUSIC= [
  {
    path: "/AllNewMusicView",
    name: "AllNewMusicView",
    component: AllNewMusicView,
    meta:{
      layout: 'client',
    }
  },

  {
    path: "/AllPopularMusicView",
    name: "AllPopularMusicView",
    component: AllPopularMusicView,
    meta:{
      layout: 'client',
    }
  },
];

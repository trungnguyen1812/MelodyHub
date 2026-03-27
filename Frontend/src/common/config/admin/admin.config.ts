import AdminLayout from '@/layouts/AdminLayout.vue';
import DashboardView from '@/modules/admin/views/dashboard/DashboardView.vue';
// managerment user
import UserManagerView from '@/modules/admin/views/users/UserManagerView.vue';
import UserManagerAddView from '@/modules/admin/views/users/UserAddView.vue';
import UserManagerAllView from '@/modules/admin/views/users/AllListUser.view.vue';
import UserManagerDetailView from '@/modules/admin/views/users/UserDetail.view.vue';
import UserManagerUpdateView from '@/modules/admin/views/users/UserUpdate.view.vue';
// managerment artists
import ArtistsManagerView from '@/modules/admin/views/artists/ArtistsManager.view.vue';
import ArtistsDetailView from '@/modules/admin/views/artists/ArtistsDetail.view.vue';
import ArtistsAddView from '@/modules/admin/views/artists/ArtistsAdd.view.vue';
import AllListArtistsView from '@/modules/admin/views/artists/AllListArtists.view.vue';
import ArtistsUpdateView from '@/modules/admin/views/artists/ArtistsUpdate.view.vue';
// managerment songs
import SongsManagerView from '@/modules/admin/views/songs/SongsManagerView.vue';
import SongDetailView from '@/modules/admin/views/songs/SongDetail.view.vue';
import SongAddView from '@/modules/admin/views/songs/SongAddView.vue';
import AllListSongsView from '@/modules/admin/views/songs/AllListSongsview.vue';
import SongsUpdateView from '@/modules/admin/views/songs/SongUpdate.view.vue';
import SongLyrisView from '@/components/common/VcGlobalMiniPlayer/GlobalLyrisPlayer.vue';

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
      /*================================================ USER ================================================*/
      {
        path: "users",
        name: "admin.usermanager",
        component: UserManagerView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: "users/create",
        name: "admin.usermanager.add",
        component: UserManagerAddView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: "users/all",
        name: "admin.usermanager.all",
        component: UserManagerAllView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: 'users/:id',
        name: "admin.usermanager.detail",
        component: UserManagerDetailView,
        props: true,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: 'users/update/:id',
        name: "admin.usermanager.update",
        component: UserManagerUpdateView,
        props: true,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      /* ================================================ ARTISTS ================================================*/
      {
        path: "artists",
        name: "admin.artistsmanager",
        component: ArtistsManagerView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: "artists/create",
        name: "admin.artistsmanager.add",
        component: ArtistsAddView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: "artists/all",
        name: "admin.artistsmanager.all",
        component: AllListArtistsView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: 'artists/:id',
        name: "admin.artistsmanager.detail",
        component: ArtistsDetailView,
        props: true,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: 'artists/update/:id',
        name: "admin.artistsmanager.update",
        component: ArtistsUpdateView,
        props: true,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      /* ================================================ SONGS ================================================*/
      {
        path: "songs",
        name: "admin.songsmanager",
        component: SongsManagerView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: "songs/create",
        name: "admin.songsmanager.add",
        component: SongAddView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: "songs/all",
        name: "admin.songsmanager.all",
        component: AllListSongsView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: 'songs/:id',
        name: "admin.songsmanager.detail",
        component: SongDetailView,
        props: true,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: 'songs/update/:id',
        name: "admin.songsmanager.update",
        component: SongsUpdateView,
        props: true,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: 'songs/:id',
        name: "admin.songsmanager.lyris",
        component: SongLyrisView,
        props: true,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
    ]
  },
];

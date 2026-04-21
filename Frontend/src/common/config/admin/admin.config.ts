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

// managerment albums
import AlbumsManagerView from '@/modules/admin/views/albums/AlbumsManager.view.vue';
import AlbumsDetailView from '@/modules/admin/views/albums/AlbumDetail.view.vue';
import AlbumsAddView from '@/modules/admin/views/albums/AlbumAdd.view.vue';
import AllListAlbumsView from '@/modules/admin/views/albums/AllListAlbums.view.vue';
import AlbumsUpdateView from '@/modules/admin/views/albums/AlbumUpdate.view.vue';

// managerment genres
import GenresManagerView from '@/modules/admin/views/genres/GenresManager.view.vue';
import GenresDetailView from '@/modules/admin/views/genres/GenreDetail.view.vue';
import GenresAddView from '@/modules/admin/views/genres/GenreAdd.view.vue';
import AllListGenresView from '@/modules/admin/views/genres/AllListGenres.view.vue';
import GenresUpdateView from '@/modules/admin/views/genres/GenreUpdate.view.vue';
// managerment partner
import PartnerManagerView from '@/modules/admin/views/partners/PartnersManager.view.vue';
import PartnerDetailView from '@/modules/admin/views/partners/PartnerDetailview.vue';
// managerment advertising
import AdvertisingManagerView from '@/modules/admin/views/advertising/AdvertisingManager.view.vue';
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
        name: "admin.songsmanager.lyrics",
        component: SongLyrisView,
        props: true,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      /* ================================================ ALBUMS ================================================*/
      {
        path: "albums",
        name: "admin.albumsmanager",
        component: AlbumsManagerView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: "albums/create",
        name: "admin.albumsmanager.add",
        component: AlbumsAddView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: "albums/all",
        name: "admin.albumsmanager.all",
        component: AllListAlbumsView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: 'albums/:id',
        name: "admin.albumsmanager.detail",
        component: AlbumsDetailView,
        props: true,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: 'albums/update/:id',
        name: "admin.albumsmanager.update",
        component: AlbumsUpdateView,
        props: true,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      /* ================================================ GENRES ================================================*/
      {
        path: "genres",
        name: "admin.genresmanager",
        component: GenresManagerView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: "genres/create",
        name: "admin.genresmanager.add",
        component: GenresAddView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: "genres/all",
        name: "admin.genresmanager.all",
        component: AllListGenresView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: 'genres/:id',
        name: "admin.genresmanager.detail",
        component: GenresDetailView,
        props: true,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: 'genres/update/:id',
        name: "admin.genresmanager.update",
        component: GenresUpdateView,
        props: true,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      /* ================================================ Partner ================================================*/
      {
        path: "partners",
        name: "admin.partnersmanager",
        component: PartnerManagerView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      {
        path: "partners/detail/:id",
        name: "admin.partner.detail",
        component: PartnerDetailView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
      /* ================================================ Advertising ================================================*/
       {
        path: "advtising/",
        name: "admin.advtisingmanager",
        component: AdvertisingManagerView,
        meta: {
          requiresAuth: true,
          requiresAdmin: true
        }
      },
    ]
  },
];

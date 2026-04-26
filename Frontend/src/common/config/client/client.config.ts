import ClientLayout from '@/layouts/ClientLayout.vue';

// Dashboard
import HomeView from '@/modules/client/views/dashboard/HomeView.vue';
// user
import UserProfileView from '@/modules/client/views/user/UserProfile.view.vue';
// Artists
import AllArtistsView from '@/modules/client/views/artists/AllArtistsView.vue';
import ArtistSongsView from '@/modules/client/views/artists/ArtistSongsView.vue';
// Music
import AllNewMusicView from '@/modules/client/views/music/AllNewMusicView.vue';
import AllPopularMusicView from '@/modules/client/views/music/AllPopularMusicView.vue';
import TopChartsView from '@/modules/client/views/music/TopChartsView.vue';
// partner
import PartnerIndexView from '@/modules/client/views/partner/Partner.index.view.vue';
import PartnerRegisterView from '@/modules/client/views/partner/Partner.register.view.vue';
import PartnerDashboardView from '@/modules/client/views/partner/partner.dashboard.view.vue';
// partner Music distribution partners + Advertising partners
import PartnerMusicView from '@/modules/client/views/partner/PartnerMusic/Partner.music.view.vue';
import PartnerAdvertisingdView from '@/modules/client/views/partner/partner.dashboard.view.vue';
// partner Advertising partners
import PartnerAdvertisingdDashboadView from '@/modules/client/views/partner/PartnerAd/Partner.advertising.view.vue';
import PartnerAdvertisingdAddView from '@/modules/client/views/partner/PartnerAd/Partner.advertising.add.view.vue';
import PartnerAdvertisingdUpdateView from '@/modules/client/views/partner/PartnerAd/Partner.advertising.update.view.vue';
// song manager 
import SongAddView from '@/modules/client/views/music/SongAddView.vue';
import SongDetailView from '@/modules/client/views/music/SongDetail.view.vue';
import SongUpdateView from '@/modules/client/views/music/SongUpdate.view.vue';
// artist manager
import PartnerArtistsView from '@/modules/client/views/partner/PartnerMusic/Partner.artist.view.vue';
import PartnerAddArtistsView from '@/modules/client/views/artists/ArtistsAdd.view.vue';
import PartnerDetailArtistsView from '@/modules/client/views/artists/ArtistsDetail.view.vue';
import PartnerUpdateArtistsView from '@/modules/client/views/artists/ArtistsUpdate.view.vue';
// genres
import AllGenresView from '@/modules/client/views/genres/AllGenresView.vue';
import GenreSongsView from '@/modules/client/views/genres/GenreSongsView.vue';
// albums
import AlbumDetailView from '@/modules/client/views/albums/AlbumsSongView.vue';
import AlbumsManagerView from '@/modules/client/views/albums/AlbumsManager.view.vue'
import AlbumAddView from '@/modules/client/views/albums/AlbumAdd.view.vue'
import AlbumUpdateView from '@/modules/client/views/albums/AlbumsUpdate.view.vue'

// user
import UserUpgradeView from '@/modules/client/views/user/UserUpgrade.view.vue';


export const CLIENT_ROUTES = [
  {
    path: '/',
    component: ClientLayout,
    children: [
      {
        path: '',
        name: 'client.home',
        component: HomeView
      },
      // user
      {
        path: 'profile',
        name: 'client.profile',
        component: UserProfileView
      },
      // 🎤 Artists
      {
        path: 'artists',
        name: 'client.artists',
        component: AllArtistsView
      },
      {
        path: 'artists/:slug',
        name: 'client.artist.songs',
        component: ArtistSongsView
      },

      // 🎵 Music
      {
        path: 'music/new',
        name: 'client.music.new',
        component: AllNewMusicView
      },
      {
        path: 'music/popular',
        name: 'client.music.popular',
        component: AllPopularMusicView
      },
      {
        path: 'music/charts',
        name: 'client.charts',
        component: TopChartsView
      },

      // 📂 Genres
      {
        path: 'genres',
        name: 'genres.all',
        component: AllGenresView
      },
      {
        path: 'genres/:slug',
        name: 'genre.detail',
        component: GenreSongsView
      },
      
      // user
      {
        path: 'user/upgrade',
        name: 'client.user.upgrade',
        component: UserUpgradeView
      },
      // partner + partner type
      {
        path: 'partner/index',
        name: 'client.partner.index',
        component: PartnerIndexView
      },
      {
        path: 'partner/register',
        name: 'client.partner.register',
        component: PartnerRegisterView
      },
      {
        path: 'partner/dashboard',
        name: 'client.partner.dashboard',
        component: PartnerDashboardView
      },
      // partner Music distribution partners
      {
        path: 'partner/music',
        name: 'client.partner.music',
        component: PartnerMusicView
      },
      {
        path: 'song/add',
        name: 'client.song.add',
        component: SongAddView
      },
      {
        path: 'songs/update/:id',
        name: 'client.song.update',
        component: SongUpdateView
      },
      {
        path: 'songs/:id',
        name: 'client.song.detail',
        component: SongDetailView
      },
      // partner manager artists
      {
        path: 'partner/artists',
        name: 'client.partner.artists',
        component: PartnerArtistsView
      },
      {
        path: 'partner/artist/add',
        name: 'client.partner.artists.add',
        component: PartnerAddArtistsView
      },
      {
        path: 'partner/artist/:id',
        name: 'client.partner.artists.detail',
        component: PartnerDetailArtistsView
      },
      {
        path: 'partner/artist/update/:id',
        name: 'client.partner.artists.update',
        component: PartnerUpdateArtistsView
      },

      // partner Advertising partners
      {
        path: 'partner/Advertisingd',
        name: 'client.partner.Advertisingd',
        component: PartnerAdvertisingdView
      },
      {
        path: 'partner/Advertisingd/dashboard',
        name: 'client.partner.Advertisingd.dashboard',
        component: PartnerAdvertisingdDashboadView
      },
      {
        path: 'partner/Advertisingd/add',
        name: 'client.partner.Advertisingd.add',
        component: PartnerAdvertisingdAddView
      },
      {
        path: 'partner/Advertisingd/update/:id',
        name: 'client.partner.Advertisingd.update',
        component: PartnerAdvertisingdUpdateView
      },
      // albums
      {
        path: 'albums',
        name: 'client.albums',
        component: AlbumsManagerView
      },
      {
        path: 'album/add',
        name: 'client.album.add',
        component: AlbumAddView
      },
      {
        path: 'albums/:slug',
        name: 'client.album.detail',
        component: AlbumDetailView
      },
      {
        path: 'albums/:slug/edit',
        name: 'client.album.update',
        component: AlbumUpdateView
      },
     
    ]
  }
];

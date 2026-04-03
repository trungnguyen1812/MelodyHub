import ClientLayout from '@/layouts/ClientLayout.vue';

// Dashboard
import HomeView from '@/modules/client/views/dashboard/HomeView.vue';
// Artists
import AllArtistsView from '@/modules/client/views/artists/AllArtistsView.vue';
import ArtistSongsView from '@/modules/client/views/artists/ArtistSongsView.vue';
// Music
import AllNewMusicView from '@/modules/client/views/music/AllNewMusicView.vue';
import AllPopularMusicView from '@/modules/client/views/music/AllPopularMusicView.vue';
// partner
import PartnerIndexView from '@/modules/client/views/partner/Partner.index.view.vue';
import PartnerRegisterView from '@/modules/client/views/partner/Partner.register.view.vue';
import PartnerDashboardView from '@/modules/client/views/partner/partner.dashboard.view.vue';
// partner Music distribution partners + Advertising partners
import PartnerMusicView from '@/modules/client/views/partner/PartnerMusic/Partner.music.view.vue';
import PartnerAdvertisingdView from '@/modules/client/views/partner/partner.dashboard.view.vue';
// song manager 
import SongAddView from '@/modules/client/views/music/SongAddView.vue';
import SongDetailView from '@/modules/client/views/music/SongDetail.view.vue';
import SongUpdateView from '@/modules/client/views/music/SongUpdate.view.vue';
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
      // partner Advertising partners
      {
        path: 'partner/Advertisingd',
        name: 'client.partner.Advertisingd',
        component: PartnerAdvertisingdView
      },
     
    ]
  }
];

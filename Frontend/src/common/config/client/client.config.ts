import ClientLayout from '@/layouts/ClientLayout.vue';

// Dashboard
import HomeView from '@/modules/client/views/dashboard/HomeView.vue';
// Artists
import AllArtistsView from '@/modules/client/views/artists/AllArtistsView.vue';
import ArtistSongsView from '@/modules/client/views/artists/ArtistSongsView.vue';
// Music
import AllNewMusicView from '@/modules/client/views/music/AllNewMusicView.vue';
import AllPopularMusicView from '@/modules/client/views/music/AllPopularMusicView.vue';

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
      }
    ]
  }
];

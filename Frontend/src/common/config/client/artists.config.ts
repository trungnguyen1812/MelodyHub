import ArtistsView from '@client/artists/views/AllArtistsView.vue'
import ArtistSongsView  from '@client/artists/views/ArtistSongsView.vue'

// ========================== ROUTER =============================
export const ROUTER_ARTISTS= [
  {
    path: "/AllArtists",
    name: "AllArtists",
    component: ArtistsView,
    meta:{
      layout: 'client',
    }
  },
    {
    path: "/AllArtists/:artistSlug",
    name: "ArtistSongs",
    component: ArtistSongsView,
    meta: { layout: "client" },
    props: true,
  },
];

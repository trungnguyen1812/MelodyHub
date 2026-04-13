// types/album.ts
export interface CreateAlbumPayload {
  name: string;
  slug?: string | null;
  artist_id?: number | null;
  cover_url?: File | string | null;
  description?: string | null;
  release_date?: string | null;
  album_type?: 'album' | 'single' | 'ep' | 'compilation' | 'live';
  label?: string | null;
  is_featured?: boolean;
  is_premium?: boolean;
  partner_id?: number | null;
  status?: 'published' | 'draft' | 'pending' | 'rejected' | 'archived';
  seo_title?: string | null;
  seo_description?: string | null;

  // Legacy / optional fields still supported by some views
  bio?: string | null;

  // Images
  avatar?: File | string | null;
  avatar_url?: string | null;
  banner?: File | string | null;
  banner_url?: string | null;

  // Stats
  monthly_listeners?: number | null;
  total_followers?: number | null;
  total_plays?: number | null;
  total_songs?: number | null;
  total_albums?: number | null;

  // Location
  country?: string | null;

  // Links
  website?: string | null;
  facebook_url?: string | null;
  instagram_url?: string | null;
  twitter_url?: string | null;
  youtube_url?: string | null;

  // Flags
  verified?: boolean;
  is_featured?: boolean;

  // Relation
  partner_id?: number | null;

  // Status
  status?: 'active' | 'inactive';

  // SEO
  seo_title?: string | null;
  seo_description?: string | null;
  seo_keywords?: string | null;

  // Tracks (album_tracks)
  track_ids?: number[];
}
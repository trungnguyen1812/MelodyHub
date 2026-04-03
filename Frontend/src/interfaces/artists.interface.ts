export interface ArtistInterface {
    id: number;
    name: string;
    monthly_listeners: number;
    slug: string;
    bio: string | null;
    avatar_url: string | null;
    banner_url: string | null;
    country: string | null;
    website: string | null;
    facebook_url: string | null;
    instagram_url: string | null;
    twitter_url: string | null;
    youtube_url: string | null;
    verified: boolean;
    is_featured: boolean;
    total_followers: number;
    total_plays: number;
    total_songs: number;
    total_albums: number;
    partner_id: number | null;
    status: string; // Có thể là 'active', 'inactive', etc.
    seo_title: string | null;
    seo_description: string | null;
    seo_keywords: string | null;
    created_at: string | null; // ISO date string
    updated_at: string | null; // ISO date string
    deleted_at: string | null; // ISO date string
}

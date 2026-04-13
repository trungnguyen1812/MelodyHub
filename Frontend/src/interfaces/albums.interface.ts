import {ArtistInterface} from '@/interfaces/artists.interface';
import {Partner} from '@/interfaces/partner.interface';
export interface AlbumInterface {
    id: number;
    name: string;
    slug: string;
    artist?: Pick<ArtistInterface, 'id' | 'name' | 'avatar_url'>;
    cover_url: string | null;
    description: string | null;
    release_date: string | null; // Date string mapping to date
    album_type: 'album' | 'single' | 'ep' | 'compilation' | 'live';
    label: string | null;
    total_tracks: number;
    total_duration: number;
    total_plays: number;
    total_likes: number;
    is_featured: boolean;
    is_premium: boolean;
    partner?: Pick<Partner, 'id' | 'company_name'>;
    status: 'published' | 'draft' | 'pending' | 'rejected' | 'archived';
    published_at: string | null; // ISO date string
    seo_title: string | null;
    seo_description: string | null;
    created_at: string | null; // ISO date string
    updated_at: string | null; // ISO date string
    deleted_at: string | null; // ISO date string
}

export interface GenreInterface {
    id: number;
    name: string;
    slug: string;
    description: string | null;
    cover_url: string | null;
    color: string | null;
    parent_id: number | null;
    order: number;
    is_active: boolean;
    total_songs: number;
    created_at: string | null;
    updated_at: string | null;
}

export interface SongUrls {
  low:      string | null   // 128kbps  — tất cả user
  standard: string | null   // 320kbps  — tất cả user
  lossless: string | null   // FLAC     — chỉ VIP (null nếu không có quyền)
}
 
export interface SongArtist {
  id:         number
  name:       string
  slug:       string
  avatar_url: string | null
}
 
export interface SongAlbum {
  id:        number
  title:     string
  slug:      string
  cover_url: string | null
}
 
export interface SongPartner {
  id:           number
  company_name: string
}

export interface SongGenre {
  id: number
  name: string
  slug: string
  description?: string | null
  cover_url?: string | null
  color?: string | null
}
 
export interface SongStats {
  total_plays:     number
  total_likes:     number
  total_comments:  number
  total_shares:    number
  total_downloads: number
}
 
export interface Song {
  id:              number
  title:           string
  slug:            string
  duration:        number        // giây
  duration_format: string        // "4:57"
  year:            number | null
  track_number:    number | null
  disc_number:     number | null
  isrc:            string | null
  bitrate:         number | null
  quality:         'standard' | 'high' | 'lossless'
  file_size:       number | null
  lyrics:          string | null
  cover_url:       string | null
  is_premium:      boolean
  is_explicit:     boolean
  is_featured:     boolean
  allow_download:  boolean
  status:          'draft' | 'published' | 'blocked' | 'processing' | 'processing_failed'
  copyright_owner: string | null
  license_type:    string | null
  urls:            SongUrls
  artist:          SongArtist | null
  album:           SongAlbum  | null
  partner:         SongPartner | null
  genre:           SongGenre | null
  stats:           SongStats
  created_at:      string
  updated_at:      string
  total_plays:      number | null
  is_liked:         boolean
  total_likes  :     number
  is_followed:         boolean
  follower_count  :     number
}
 
export interface SongMeta {
  current_page: number
  last_page:    number
  per_page:     number
  total:        number
  
}
 
export interface SongListResponse {
  success: boolean
  data:    Song[]
  meta:    SongMeta
}
 
export interface SongDetailResponse {
  success: boolean
  data:    Song
}
 
// ── Filter params ──
export interface SongFilterParams {
  page?:        number
  per_page?:    number
  search?:      string
  artist_id?:   number
  album_id?:    number
  partner_id?:  number
  status?:      'draft' | 'published' | 'blocked' | 'processing'
  quality?:     'standard' | 'high' | 'lossless'
  is_premium?:  boolean
  is_featured?: boolean
  year?:        number
  sort_by?:     'created_at' | 'title' | 'total_plays' | 'total_likes' | 'duration' | 'year'
  sort_dir?:    'asc' | 'desc'
}
 

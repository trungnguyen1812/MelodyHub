export interface Album   { id: number; name: string }
export interface Partner { id: number; name: string }

export interface Flag {
  key: keyof Pick<CreateSongPayload, 'is_premium' | 'is_explicit' | 'is_featured' | 'allow_download'>
  label: string
  desc: string
  emoji: string
  color: 'yellow' | 'red' | 'orange' | 'green'
}

export interface CreateSongPayload {
  // ── Basic Info ──
  title: string
  slug: string
  artist_id: number | ''
  album_id: number | ''
  year: number
  track_number: number | null
  disc_number: number
  isrc: string
  copyright_owner: string
  license_type: string
 
  audio_file: File | null   
 
  duration: number          
  file_size: number         
  bitrate: number          
  quality: 'standard' | 'high' | 'lossless'
 
  cover_file: File | null  
  cover_url: string        
 
  lyrics: string
 
  status: 'draft' | 'published' | 'blocked'
  partner_id: number | ''
  genre_id: number | ''
  is_premium: boolean
  is_explicit: boolean
  is_featured: boolean
  allow_download: boolean
}

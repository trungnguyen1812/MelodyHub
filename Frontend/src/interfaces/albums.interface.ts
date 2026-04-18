import { ArtistInterface } from '@/interfaces/artists.interface'
import { Song } from '@/interfaces/songs.interface'

export interface AlbumInterface {
  id: number
  name: string
  slug: string
  partner_id: number | null

  artist?: Pick<ArtistInterface, 'id' | 'name'>
  

  cover_url: string | null
  description: string | null
  release_date: string | null

  album_type: 'album' | 'single' | 'ep' | 'compilation' | 'live'
  label: string | null

  total_tracks: number
  total_duration: number
  total_plays: number
  total_likes: number

  is_featured: boolean
  is_premium: boolean

  status: 'published' | 'draft' | 'pending' | 'rejected' | 'archived'
  published_at: string | null

  created_at: string | null
  updated_at: string | null

  tracks?: Song[]
}

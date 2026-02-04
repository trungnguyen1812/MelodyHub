export interface SubscriptionPlan {
  id: number;

  name: string;
  display_name: string;
  description: string | null;

  price: number;
  original_price: number | null;
  currency: string;

  duration_days: number;
  trial_days: number;

  max_playlists: number;
  max_songs_per_playlist: number;
  max_offline_downloads: number;
  max_devices: number;

  can_download: boolean;
  audio_quality: string;

  ads_free: boolean;
  can_skip_unlimited: boolean;
  can_create_collaborative_playlist: boolean;
  priority_support: boolean;
  early_access: boolean;

  is_active: boolean;
  is_featured: boolean;
  sort_order: number;

  created_at?: string;
  updated_at?: string;
}

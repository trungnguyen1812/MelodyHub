import {Partner} from '@/interfaces/partner.interface';
export interface PartnerType {
  id: number;
  code: string;
  name: string;
  description?: string | null;

  can_upload_songs: boolean;
  can_manage_artists: boolean;
  can_book_ads: boolean;

  default_revenue_share: number;
  default_payment_frequency: string;
  default_payment_threshold: number;

  is_active: boolean;

  created_at?: string | null;
  updated_at?: string | null;

  // Quan hệ
  partners?: Partner[];
}
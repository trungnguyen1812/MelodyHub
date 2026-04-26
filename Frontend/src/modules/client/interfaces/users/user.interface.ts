import {Role} from '@/modules/admin/interfaces/users/role.interface';
export interface NormalizedRole {
  id: number;
  name: string;
  display_name: string;
}

export interface UserInterface {
  id: number;

  name: string;
  username: string;
  email: string;
  phone?: string;

  roles: Role[];
  role_display_name?: string;

  password?: string; 

  avatar_url?: string | null;

  date_of_birth?: string | null;
  gender?: "male" | "female" | "other" | null;
  bio?: string | null;

  country?: string | null;
  timezone?: string | null;

  status: "active" | "inactive" | "banned" | "pending";
  published_at?: string | null;

  play_count_last_24h?: number;
  play_count_last_7d?: number;
  play_count_last_30d?: number;
  trending_score?: number;


  seo_title?: string | null;
  seo_description?: string | null;

  has_used_trial: boolean;
  is_vip: boolean;
  vip_expires_at?: string | null;

  created_at?: string;
  updated_at?: string;
}
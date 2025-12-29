import {Role} from '@/modules/admin/interfaces/users/role.interface';
export interface UserInterface {
  id: number;

  // Thông tin cơ bản
  name: string;
  slug: string;
  username: string;
  email: string;
  phone?: string;

  roles: Role[];
  // Xác thực
  email_verified_at?: string | null;
  phone_verified_at?: string | null;

  // Bảo mật
  password?: string; 

  // Media
  avatar_url?: string | null;
  banner_url?: string | null;

  // Hồ sơ cá nhân
  date_of_birth?: string | null;
  gender?: "male" | "female" | "other" | null;
  bio?: string | null;

  // Địa lý – ngôn ngữ
  country?: string | null;
  language?: string | null;
  timezone?: string | null;

  // Trạng thái
  status: "active" | "inactive" | "banned" | "pending";
  published_at?: string | null;

  // Thống kê
  play_count_last_24h?: number;
  play_count_last_7d?: number;
  play_count_last_30d?: number;
  trending_score?: number;

  // SEO
  seo_title?: string | null;
  seo_description?: string | null;

  // VIP / Trial
  has_used_trial: boolean;
  is_vip: boolean;
  vip_expires_at?: string | null;

  // Metadata
  created_at?: string;
  updated_at?: string;
}
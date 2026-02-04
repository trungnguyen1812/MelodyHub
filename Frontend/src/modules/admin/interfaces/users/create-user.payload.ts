// types/user.ts
export interface CreateUserPayload {
  // Basic info
  name: string;
  username: string;
  email: string;
  password: string;
  phone?: string | null;
  date_of_birth?: string | null;
  gender?: 'male' | 'female' | 'other' | 'prefer_not_to_say' | '';

  // Profile
  bio?: string | null;
  avatar?: File | string | null;
  avatar_url?: string | null;

  // Location & preferences
  roles?: number[];
  country?: string | null;
  timezone?: string | null;

  // Status & flags
  status: 'active' | 'inactive' | 'suspended' | 'pending';

  // Publish
  published_at?: string | null;

  // SEO
  seo_title?: string | null;
  seo_description?: string | null;
}

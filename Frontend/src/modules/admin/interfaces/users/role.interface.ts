export interface Role {
  id: number;
  name: string;
  display_name: string;
  description: string;
  level: number;
  is_system: boolean;
  created_at: string;
  updated_at: string;
  pivot: {
    user_id: number;
    role_id: number;
    id: number;
    assigned_by: number | null;
    assigned_at: string;
    expires_at: string | null;
    is_primary: number;
  };
}
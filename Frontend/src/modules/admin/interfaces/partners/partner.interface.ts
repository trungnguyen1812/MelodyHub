// types/partner.types.ts

// Enum cho payment frequency
export enum PaymentFrequency {
  WEEKLY = 'weekly',
  MONTHLY = 'monthly',
  QUARTERLY = 'quarterly'
}

// Enum cho partner status
export enum PartnerStatus {
  ACTIVE = 'active',
  PENDING = 'pending',
  SUSPENDED = 'suspended',
  TERMINATED = 'terminated'
}

// Interface chính cho Partner
export interface Partner {
  id: number;
  user_id: number;
  company_name: string;
  company_email: string;
  company_phone?: string | null;
  company_address?: string | null;
  tax_code?: string | null;
  website?: string | null;
  logo_url?: string | null;
  description?: string | null;
  contract_number?: string | null;
  contract_file_url?: string | null;
  contract_start_date?: Date | string | null;
  contract_end_date?: Date | string | null;
  revenue_share_percentage: number;
  payment_threshold: number;
  payment_frequency: PaymentFrequency;
  bank_name?: string | null;
  bank_branch?: string | null;
  bank_account_number?: string | null;
  bank_account_name?: string | null;
  total_songs: number;
  total_artists: number;
  total_albums: number;
  total_revenue: number;
  total_paid: number;
  pending_payout: number;
  status: PartnerStatus;
  verified_at?: Date | string | null;
  verified_by?: number | null;
  notes?: string | null;
  created_at: Date | string;
  updated_at: Date | string;
  deleted_at?: Date | string | null;
}

// Interface cho form tạo mới partner
export interface CreatePartnerDTO {
  user_id: number;
  company_name: string;
  company_email: string;
  company_phone?: string | null;
  company_address?: string | null;
  tax_code?: string | null;
  website?: string | null;
  logo_url?: string | null;
  description?: string | null;
  contract_number?: string | null;
  contract_file_url?: string | null;
  contract_start_date?: Date | string | null;
  contract_end_date?: Date | string | null;
  revenue_share_percentage?: number; // default 70.00
  payment_threshold?: number; // default 1000000.00
  payment_frequency?: PaymentFrequency; // default 'monthly'
  bank_name?: string | null;
  bank_branch?: string | null;
  bank_account_number?: string | null;
  bank_account_name?: string | null;
  status?: PartnerStatus; // default 'pending'
  notes?: string | null;
}

// Interface cho cập nhật partner
export interface UpdatePartnerDTO {
  company_name?: string;
  company_email?: string;
  company_phone?: string | null;
  company_address?: string | null;
  tax_code?: string | null;
  website?: string | null;
  logo_url?: string | null;
  description?: string | null;
  contract_number?: string | null;
  contract_file_url?: string | null;
  contract_start_date?: Date | string | null;
  contract_end_date?: Date | string | null;
  revenue_share_percentage?: number;
  payment_threshold?: number;
  payment_frequency?: PaymentFrequency;
  bank_name?: string | null;
  bank_branch?: string | null;
  bank_account_number?: string | null;
  bank_account_name?: string | null;
  status?: PartnerStatus;
  notes?: string | null;
}

// Interface cho verify partner
export interface VerifyPartnerDTO {
  verified_by: number;
  notes?: string | null;
}

// Interface cho filter/search partners
export interface PartnerFilterParams {
  page?: number;
  limit?: number;
  search?: string;
  status?: PartnerStatus;
  from_date?: string;
  to_date?: string;
  min_revenue?: number;
  max_revenue?: number;
  sort_by?: 'company_name' | 'created_at' | 'total_revenue' | 'status';
  sort_order?: 'asc' | 'desc';
}

// Interface cho response phân trang
export interface PaginatedPartnerResponse {
  data: Partner[];
  current_page: number;
  per_page: number;
  total: number;
  last_page: number;
  from: number;
  to: number;
}

// Interface cho thống kê partner
export interface PartnerStatistics {
  total_partners: number;
  active_partners: number;
  pending_partners: number;
  suspended_partners: number;
  terminated_partners: number;
  total_revenue_all: number;
  total_paid_all: number;
  total_pending_payout_all: number;
  average_revenue_share: number;
}

// Interface cho thông tin thanh toán partner
export interface PartnerPayoutInfo {
  partner_id: number;
  company_name: string;
  bank_name: string | null;
  bank_branch: string | null;
  bank_account_number: string | null;
  bank_account_name: string | null;
  pending_payout: number;
  payment_threshold: number;
  can_request_payout: boolean; // pending_payout >= payment_threshold
  payment_frequency: PaymentFrequency;
}

// Interface cho báo cáo doanh thu partner
export interface PartnerRevenueReport {
  partner_id: number;
  company_name: string;
  period_start: string;
  period_end: string;
  total_revenue: number;
  revenue_share_percentage: number;
  partner_earnings: number; // total_revenue * revenue_share_percentage / 100
  platform_fee: number; // total_revenue - partner_earnings
  previous_period_revenue: number;
  growth_percentage: number;
}

// Interface cho lịch sử thay đổi partner
export interface PartnerHistory {
  id: number;
  partner_id: number;
  field_changed: string;
  old_value: any;
  new_value: any;
  changed_by: number;
  changed_by_name?: string;
  created_at: string;
}
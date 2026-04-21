// modules/admin/interfaces/partners/partner.interface.ts

export interface MonthlyStat {
    month: string;
    year_month: string;
    revenue: number;
    paid: number;
    profit: number;
    new_partners: number;
}

export interface TopPartner {
    id: number;
    company_name: string;
    logo_url: string | null;
    total_revenue: number;
}

export interface GrowthMetric {
    current: number;
    previous: number;
    growth_rate: number;
    is_positive: boolean;
}

export interface GrowthInfo {
    total_partners: GrowthMetric;
    revenue: GrowthMetric;
    paid: GrowthMetric;
    pending_payout: GrowthMetric;
    profit: GrowthMetric;
}

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
    monthly_stats: MonthlyStat[];
    top_partners: TopPartner[];
    growth: GrowthInfo;
}

export interface Partner {
    id: number;
    user_id: number;
    partner_type_id: number;
    company_name: string;
    company_email: string;
    company_phone: string | null;
    company_address: string | null;
    tax_code: string | null;
    website: string | null;
    logo_url: string | null;
    description: string | null;
    contract_number: string | null;
    contract_file_url: string | null;
    contract_start_date: string | null;
    contract_end_date: string | null;
    revenue_share_percentage: number;
    payment_threshold: number;
    payment_frequency: 'weekly' | 'monthly' | 'quarterly';
    bank_name: string | null;
    bank_branch: string | null;
    bank_account_number: string | null;
    bank_account_name: string | null;
    status: 'active' | 'pending' | 'suspended' | 'terminated';
    verified_at: string | null;
    verified_by: number | null;
    notes: string | null;
    created_at: string;
    updated_at: string;
    deleted_at: string | null;
    
    // Accessors (tính toán động)
    total_songs?: number;
    total_artists?: number;
    total_albums?: number;
    total_revenue?: number;
    total_paid?: number;
    pending_payout?: number;
    
    // Relations
    user?: {
        id: number;
        name: string;
        email: string;
        avatar_url?: string;
    };
    partner_type?: {
        id: number;
        code: string;
        name: string;
        description: string;
        can_upload_songs: boolean;
        can_manage_artists: boolean;
        can_book_ads: boolean;
        default_revenue_share: number;
        default_payment_frequency: string;
        default_payment_threshold: number;
        is_active: boolean;
    };
}

export interface PartnerFilterParams {
    page?: number;
    per_page?: number;
    status?: string;
    sort_by?: string;
    sort_order?: 'asc' | 'desc';
    keyword?: string;
}

export interface PaginatedPartnerResponse {
    success: boolean;
    data: Partner[];
    total: number;
    current_page: number;
    last_page: number;
    per_page: number;
}

export interface ApiResponse<T> {
    success: boolean;
    message?: string;
    data: T;
    errors?: Record<string, string[]>;
}

// GrowthInfo formatted cho frontend display
export interface FormattedGrowthInfo {
    totalPartners: {
        value: number;
        isPositive: boolean;
        text: string;
    };
    revenue: {
        value: number;
        isPositive: boolean;
        text: string;
    };
    paid: {
        value: number;
        isPositive: boolean;
        text: string;
    };
    pendingPayout: {
        value: number;
        isPositive: boolean;
        text: string;
    };
    profit: {
        value: number;
        isPositive: boolean;
        text: string;
    };
}
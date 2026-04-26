// modules/admin/interfaces/advertising/advertising.interface.ts

/**
 * Interface cho Advertisement (tương ứng với model Laravel)
 */
export interface Advertisement {
    id: number;
    partner_id: number | null;
    name: string;
    type: string; // video, banner, audio, etc.
    advertiser_name: string;
    advertiser_url: string | null;
    media_url: string | null;
    thumbnail_url: string | null;
    click_url: string | null;
    duration: number | null;
    file_size: number | null;
    target_age_min: number | null;
    target_age_max: number | null;
    target_gender: string | null;
    target_location: any | null; // array
    target_genres: any | null; // array
    budget_total: number | null;
    budget_spent: number | null;
    budget_remaining: number | null;
    budget_used_percent: number | null; // e.g. 0.05 = 0.05%
    cost_per_play: number | null;
    cost_per_click: number | null;
    max_plays_per_user_per_day: number | null;
    frequency_cap: number | null;
    priority: number;
    start_date: string; // datetime
    end_date: string | null;
    total_impressions: number;
    total_plays: number;
    total_clicks: number;
    total_skips: number;
    status: 'active' | 'paused' | 'completed';
    created_at: string | null;
    updated_at: string | null;
}



/**
 * Interface cho summary
 */
export interface AdvertisingSummary {
    total_campaigns: number;
    active_campaigns: number;
    paused_campaigns: number;
    total_budget: number;
    total_spent: number;
    revenue_earned: number | string;
}

/**
 * Interface cho response khi lấy danh sách (có summary)
 */
export interface AdvertisingListResponse {
    data: Advertisement[];
    summary: AdvertisingSummary;
    current_page?: number;
    last_page?: number;
    per_page?: number;
    total?: number;
}
/**
 * Interface cho chi tiết Advertisement (có thể có thêm các field tính toán)
 */
export interface AdvertisementDetail extends Advertisement {
    // Các field bổ sung từ API detail response
    file_size_readable?: string;
    budget?: {
        total: number;
        spent: number;
        remaining: number;
        used_percent: string;
    };
    schedule?: {
        start_date: string;
        end_date: string | null;
        days_remaining: number | null;
        is_expired: boolean;
    };
    targeting?: {
        age_min: number | null;
        age_max: number | null;
        gender: string | null;
        location: string | null;
        genres: any;
    };
    ctr?: number;
}

/**
 * Interface cho response khi lấy danh sách
 */
export interface AdvertisingListResponse {
    data: Advertisement[];
    current_page?: number;
    last_page?: number;
    per_page?: number;
    total?: number;
}

/**
 * Interface cho response chi tiết
 */
export interface AdvertisingDetailResponse {
    message: string;
    data: AdvertisementDetail;
}

/**
 * Interface cho response toggle status
 */
export interface ToggleStatusResponse {
    message: string;
    status: 'active' | 'paused';
}

/**
 * Interface cho payload tạo mới (nếu cần)
 */
export interface CreateAdvertisementPayload {
    name: string;
    type: string;
    advertiser_name: string;
    advertiser_url?: string | null;
    media_url?: string | null;
    thumbnail_url?: string | null;
    click_url?: string | null;
    duration?: number | null;
    file_size?: number | null;
    target_age_min?: number | null;
    target_age_max?: number | null;
    target_gender?: string | null;
    target_location?: any | null;
    target_genres?: any | null;
    budget_total?: number | null;
    cost_per_play?: number | null;
    cost_per_click?: number | null;
    max_plays_per_user_per_day?: number | null;
    frequency_cap?: number | null;
    priority?: number;
    start_date: string;
    end_date?: string | null;
    status?: 'active' | 'paused';
}

/**
 * Interface cho payload update (partial)
 */
export type UpdateAdvertisementPayload = Partial<CreateAdvertisementPayload>;
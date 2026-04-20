export interface PermissionResponse {
  is_admin: boolean
  is_partner: boolean
  is_music_distribution: boolean
  is_advertising: boolean
  partner_type_name: string
  partner: {
    id: number
    user_id: number
    partner_type_id: number
    company_name: string
    company_email: string
    company_phone: string | null
    company_address: string | null
    tax_code: string | null
    website: string | null
    logo_url: string | null
    description: string | null
    contract_number: string
    contract_file_url: string | null
    contract_start_date: string
    contract_end_date: string
    revenue_share_percentage: number
    payment_threshold: number
    payment_frequency: string
    bank_name: string
    bank_branch: string | null
    bank_account_number: string
    bank_account_name: string
    total_songs: number
    total_artists: number
    total_albums: number
    total_revenue: number
    total_paid: number
    pending_payout: number
    status: string
    verified_at: string | null
    verified_by: string | null
    notes: string | null
    created_at: string
    updated_at: string
    deleted_at: string | null
    partner_type: {
      id: number
      code: string
      name: string
      description: string
      can_upload_songs: boolean
      can_manage_artists: boolean
      can_book_ads: boolean
      default_revenue_share: number
      default_payment_frequency: string
      default_payment_threshold: number
      is_active: boolean
      created_at: string | null
      updated_at: string | null
    }
  }
  user: {
    id: number
    name: string
    slug: string
    email: string
    phone: string | null
    username: string
    avatar_url: string | null
    date_of_birth: string | null
    gender: string | null
    country: string | null
    timezone: string | null
    bio: string | null
    status: string
    published_at: string | null
    play_count_last_24h: number
    play_count_last_7d: number
    play_count_last_30d: number
    trending_score: number
    seo_title: string | null
    seo_description: string | null
    created_at: string
    updated_at: string
    deleted_at: string | null
    wallet_balance: number| null
  }
  roles_flags: {
    is_admin: boolean
    is_boss: boolean
    is_content_manager: boolean
    is_partner: boolean
    is_moderator: boolean
    is_user_vip_yearly: boolean
    is_user_vip_monthly: boolean
    is_user_free: boolean
  }
}

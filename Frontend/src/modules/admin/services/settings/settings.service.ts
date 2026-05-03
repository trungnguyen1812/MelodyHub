import adminApi from '@/plugins/axios_admin'

// ── Partner Types ──────────────────────────────────────────────────────────────
export interface PartnerTypePayload {
  code: string
  name: string
  description?: string
  can_upload_songs?: boolean
  can_manage_artists?: boolean
  can_book_ads?: boolean
  default_revenue_share: number
  default_payment_frequency: 'monthly' | 'quarterly' | 'yearly'
  default_payment_threshold: number
  is_active?: boolean
}

// ── Roles ──────────────────────────────────────────────────────────────────────
export interface RolePayload {
  name: string
  display_name: string
  description?: string
  level: number
  is_system?: boolean
  permissions?: number[]
}

// ── Subscription Plans ─────────────────────────────────────────────────────────
export interface SubscriptionPlanPayload {
  name: string
  display_name: string
  description?: string
  price: number
  original_price?: number
  currency: string
  duration_days: number
  trial_days?: number
  max_playlists?: number
  max_songs_per_playlist?: number
  max_offline_downloads?: number
  max_devices?: number
  can_download?: boolean
  audio_quality: 'standard' | 'high' | 'lossless'
  ads_free?: boolean
  can_skip_unlimited?: boolean
  can_create_collaborative_playlist?: boolean
  priority_support?: boolean
  early_access?: boolean
  is_active?: boolean
  is_featured?: boolean
  sort_order?: number
}

// ── Ad Priority Tiers ─────────────────────────────────────────────────────────
export interface AdPriorityTierPayload {
  value: string
  label: string
  color: string
  min_cpm: number
  min_cpc: number
  max_priority: number
  description?: string
  sort_order?: number
  is_active?: boolean
}

class SettingsService {
  // ── Partner Types ────────────────────────────────────────────────────────────
  getPartnerTypes()                                                          { return adminApi.get('/settings/partner-types') }
  getPartnerType(id: number)                                                 { return adminApi.get(`/settings/partner-types/${id}`) }
  createPartnerType(data: PartnerTypePayload)                                { return adminApi.post('/settings/partner-types', data) }
  updatePartnerType(id: number, data: Partial<PartnerTypePayload>)           { return adminApi.put(`/settings/partner-types/${id}`, data) }
  deletePartnerType(id: number)                                              { return adminApi.delete(`/settings/partner-types/${id}`) }
  togglePartnerType(id: number)                                              { return adminApi.patch(`/settings/partner-types/${id}/toggle`) }

  // ── Roles ────────────────────────────────────────────────────────────────────
  getRoles()                                                                 { return adminApi.get('/settings/roles') }
  getRole(id: number)                                                        { return adminApi.get(`/settings/roles/${id}`) }
  getPermissions()                                                           { return adminApi.get('/settings/roles/permissions') }
  createRole(data: RolePayload)                                              { return adminApi.post('/settings/roles', data) }
  updateRole(id: number, data: Partial<RolePayload>)                        { return adminApi.put(`/settings/roles/${id}`, data) }
  deleteRole(id: number)                                                     { return adminApi.delete(`/settings/roles/${id}`) }

  // ── Subscription Plans ───────────────────────────────────────────────────────
  getSubscriptionPlans()                                                     { return adminApi.get('/settings/subscription-plans') }
  getSubscriptionPlan(id: number)                                            { return adminApi.get(`/settings/subscription-plans/${id}`) }
  createSubscriptionPlan(data: SubscriptionPlanPayload)                      { return adminApi.post('/settings/subscription-plans', data) }
  updateSubscriptionPlan(id: number, data: Partial<SubscriptionPlanPayload>) { return adminApi.put(`/settings/subscription-plans/${id}`, data) }
  deleteSubscriptionPlan(id: number)                                         { return adminApi.delete(`/settings/subscription-plans/${id}`) }
  toggleSubscriptionPlan(id: number)                                         { return adminApi.patch(`/settings/subscription-plans/${id}/toggle`) }

  // ── Ad Priority Tiers ────────────────────────────────────────────────────────
  getAdPriorityTiers()                                                       { return adminApi.get('/settings/ad-priority-tiers') }
  createAdPriorityTier(data: AdPriorityTierPayload)                          { return adminApi.post('/settings/ad-priority-tiers', data) }
  updateAdPriorityTier(id: number, data: Partial<AdPriorityTierPayload>)     { return adminApi.put(`/settings/ad-priority-tiers/${id}`, data) }
  deleteAdPriorityTier(id: number)                                           { return adminApi.delete(`/settings/ad-priority-tiers/${id}`) }
  toggleAdPriorityTier(id: number)                                           { return adminApi.patch(`/settings/ad-priority-tiers/${id}/toggle-active`) }
}

export default new SettingsService()

export interface UserStatisticsData {
  // Current counts
  total_users: number
  free_users: number
  partners: number
  admins: number
  vip_users: number
  
  // Growth percentages
  total_growth_percentage: number
  free_growth_percentage: number
  partner_growth_percentage: number
  admin_growth_percentage: number
  vip_growth_percentage: number
  
  // Growth trends
  total_growth_trend: 'up' | 'down' | 'neutral'
  free_growth_trend: 'up' | 'down' | 'neutral'
  partner_growth_trend: 'up' | 'down' | 'neutral'
  admin_growth_trend: 'up' | 'down' | 'neutral'
  vip_growth_trend: 'up' | 'down' | 'neutral'
  
  // New users this month
  new_users_this_month: number
  new_free_users_this_month: number
  new_partners_this_month: number
  new_admins_this_month: number
  new_vip_users_this_month: number
}
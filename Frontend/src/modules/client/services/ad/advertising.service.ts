import clientApi from '@/plugins/axios';


export interface Ad {
  id: string | number
  type: 'banner' | 'audio'
  title: string
  description: string
  media_url: string
  audio_url?: string
  thumbnail?: string
  target_url: string
  cta_text: string
  display_position?: 'inline' | 'sidebar' | 'sticky-bottom'
  partner_id?: string | number
  duration?: number
  skip_after?: number | null
  cost_per_play?: number
  cost_per_click?: number
  remaining_budget?: number
  frequency_cap?: number
  max_plays_per_user_per_day?: number
}

class AdvertisingService {
  /**
   * Get all active advertisements for client
   * Endpoint: GET /api/client/advertising/allAdvertising
   */
  async getCampaigns(): Promise<Ad[]> {
    try {
      const response = await clientApi.get('/advertising/allAdvertising')
      if (response.data && Array.isArray(response.data)) {
        return response.data
      } else if (response.data && response.data.data && Array.isArray(response.data.data)) {
        return response.data.data
      } else if (Array.isArray(response)) {
        return response
      }
      
      return []
    } catch (error) {
      console.error('[AdvertisingService] Failed to fetch ads:', error)
      throw error
    }
  }
  

  /**
   * Get banners only
   */
  async getBanners(): Promise<Ad[]> {
    const all = await this.getCampaigns()
    return all.filter(ad => ad.type === 'banner')
  }

  /**
   * Get audio ads only
   */
  async getAudioAds(): Promise<Ad[]> {
    const all = await this.getCampaigns()
    return all.filter(ad => ad.type === 'audio')
  }

  /**
   * Track ad events (impression, click, dismiss, skip, complete)
   */
  async trackEvent(adId: string | number, eventType: string): Promise<void> {
      try {
          // Cập nhật URL cho đúng với route đã tạo
          await clientApi.post(`/advertising/${adId}/track`, {
              event_type: eventType,
              timestamp: new Date().toISOString(),
          });
      } catch (error) {
          console.debug('[AdvertisingService] Track event failed:', error);
      }
  }

  /**
   * Get ad statistics
   */
  async getAdStatistics(adId: string | number, startDate?: string, endDate?: string): Promise<any> {
      try {
          const params = new URLSearchParams();
          if (startDate) params.append('start_date', startDate);
          if (endDate) params.append('end_date', endDate);
          
          const response = await clientApi.get(`/advertising/${adId}/statistics?${params}`);
          return response.data;
      } catch (error) {
          console.error('[AdvertisingService] Failed to get statistics:', error);
          throw error;
      }
  }

  /**
   * Fraud detection
   */
  async fraudDetection(adId: string | number): Promise<any> {
      try {
          const response = await clientApi.get(`/advertising/${adId}/fraud-detection`);
          return response.data;
      } catch (error) {
          console.error('[AdvertisingService] Fraud detection failed:', error);
          throw error;
      }
  }
}

export default new AdvertisingService()
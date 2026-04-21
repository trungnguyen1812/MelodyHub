import { defineStore } from "pinia";
import PartnersService from "@/modules/admin/services/partners/partners.service";
import type { 
  Partner, 
  PartnerStatistics, 
  FormattedGrowthInfo,
  GrowthInfo 
} from '@/modules/admin/interfaces/partners/partner.interface';

type PartnerStatus = Partner['status'];

export const getFullImageUrl = (path?: string | null): string | undefined => {
    if (!path || path.trim() === '') return undefined;
    
    if (path === 'null' || path === 'undefined') return undefined;

    if (path.startsWith('http')) return path;

    return `http://localhost:8000/storage/${path}`;
};

// Default values
const defaultGrowthInfo: FormattedGrowthInfo = {
    totalPartners: { value: 0, isPositive: true, text: '+0%' },
    revenue: { value: 0, isPositive: true, text: '+0%' },
    paid: { value: 0, isPositive: true, text: '+0%' },
    pendingPayout: { value: 0, isPositive: false, text: '+0%' },
    profit: { value: 0, isPositive: true, text: '+0%' },
};

const defaultStatistics: PartnerStatistics = {
    total_partners: 0,
    active_partners: 0,
    pending_partners: 0,
    suspended_partners: 0,
    terminated_partners: 0,
    total_revenue_all: 0,
    total_paid_all: 0,
    total_pending_payout_all: 0,
    average_revenue_share: 0,
    monthly_stats: [],
    top_partners: [],
    growth: {
        total_partners: { current: 0, previous: 0, growth_rate: 0, is_positive: true },
        revenue: { current: 0, previous: 0, growth_rate: 0, is_positive: true },
        paid: { current: 0, previous: 0, growth_rate: 0, is_positive: true },
        pending_payout: { current: 0, previous: 0, growth_rate: 0, is_positive: false },
        profit: { current: 0, previous: 0, growth_rate: 0, is_positive: true }
    }
};

export const usePartnerStore = defineStore("partners", {
    state: () => ({
        profile: null as Partner | null,
        partners: [] as Partner[],
        statistics: { ...defaultStatistics } as PartnerStatistics,
        growthInfo: { ...defaultGrowthInfo } as FormattedGrowthInfo,
        loading: false,
        loadingStats: false,
        error: null as string | null,
    }),

    getters: {
        netProfit: (state) => {
            return (state.statistics?.total_revenue_all || 0) - (state.statistics?.total_paid_all || 0);
        },
    },
    
    actions: {
        async fetchPartners() {
            try {
                this.loading = true;
                this.error = null;

                const response = await PartnersService.getAllPartners();

                if (!response?.data) {
                    this.partners = [];
                    return;
                }

                // Lấy data array từ response
                let partnersArray = [];
                if (Array.isArray(response.data)) {
                    partnersArray = response.data;
                } else if (response.data.data && Array.isArray(response.data.data)) {
                    partnersArray = response.data.data;
                } else {
                    partnersArray = [];
                }
                
                this.partners = partnersArray
                    .filter((u: any) => !u.deleted_at)
                    .sort(
                        (a: any, b: any) =>
                            new Date(b.created_at).getTime() -
                            new Date(a.created_at).getTime()
                    );

            } catch (err: any) {
                this.error = err?.message || "Failed to fetch partners";
            } finally {
                this.loading = false;
            }
        },

        async fetchRecentPartners(limit: number = 8) {
            this.loading = true;
            try {
                const response = await PartnersService.getRecentPartners(limit);
                const data = response.data || response;
                
                if (Array.isArray(data)) {
                    this.partners = data.filter((u: any) => !u.deleted_at);
                } else {
                    this.partners = [];
                }
                return response;
            } catch (error: any) {
                this.error = error.message;
                throw error;
            } finally {
                this.loading = false;
            }
        },
        
        async fetchSearchPartners(keyword: string) {
            this.loading = true;
            try {
                const response = await PartnersService.searchPartners(keyword);
                const data = response.data || response;
                
                if (Array.isArray(data)) {
                    this.partners = data.filter((u: any) => !u.deleted_at);
                } else {
                    this.partners = [];
                }
                return response;
            } catch (error: any) {
                this.error = error.message;
                throw error;
            } finally {
                this.loading = false;
            }
        },
        async updatePartnerStatus(id: number, status: PartnerStatus) {
            try {
                this.loading = true;
                this.error = null;

                const response = await PartnersService.updatePartnerStatus(id, status);
                
                // Cập nhật trực tiếp với đúng type
                const index = this.partners.findIndex(p => p.id === id);
                if (index !== -1) {
                    this.partners[index].status = status; // ✅ Giờ không còn lỗi
                }
                
                await this.fetchStatistics();

                return response;

            } catch (err: any) {
                this.error = err?.message || "Failed to update partner status";
                throw err;
            } finally {
                this.loading = false;
            }
        },
        async fetchPartnerDetail(id: number) {
            try {
                const response = await PartnersService.detailPartner(id);
                return response.data || response;
            } catch (error: any) {
                this.error = error.message;
                throw error;
            }
        },
        
        async verifyPartner(id: number) {
            try {
                const response = await PartnersService.verifyPartner(id);
                await this.fetchPartners();
                await this.fetchStatistics();
                return response;
            } catch (error: any) {
                this.error = error.message;
                throw error;
            }
        },
        
          async fetchStatistics() {
            this.loadingStats = true;
            try {
                const response = await PartnersService.getPartnerStatistics();
                
                if (response?.data) {
                    this.statistics = response.data;
                    
                    // Format growth info
                    if (response.data.growth) {
                        this.growthInfo = this.formatGrowthInfo(response.data.growth);
                    }
                }
                
                return response;
            } catch (error: any) {
                this.error = error.message;
                throw error;
            } finally {
                this.loadingStats = false;
            }
        },
        
        formatGrowthInfo(growth: GrowthInfo): FormattedGrowthInfo {
            const formatMetric = (metric: any, defaultPositive = true) => ({
                value: metric.growth_rate || 0,
                isPositive: metric.is_positive ?? defaultPositive,
                text: `${metric.growth_rate > 0 ? '+' : ''}${metric.growth_rate}%`
            });
            
            return {
                totalPartners: formatMetric(growth.total_partners, true),
                revenue: formatMetric(growth.revenue, true),
                paid: formatMetric(growth.paid, true),
                pendingPayout: formatMetric(growth.pending_payout, false),
                profit: formatMetric(growth.profit, true),
            };
        },
        
        // Reset store state
        resetState() {
            this.profile = null;
            this.partners = [];
            this.statistics = { ...defaultStatistics };
            this.growthInfo = { ...defaultGrowthInfo };
            this.loading = false;
            this.loadingStats = false;
            this.error = null;
        },
        
        // Clear error
        clearError() {
            this.error = null;
        }
    }
});
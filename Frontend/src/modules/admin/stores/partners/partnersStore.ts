import { defineStore } from "pinia";
import PartnersService from "@/modules/admin/services/partners/partners.service";
import {Partner} from '@/modules/admin/interfaces/partners/partner.interface';
import adminApi from "@/plugins/axios_admin";
import partnersService from "@/modules/admin/services/partners/partners.service";

export const getFullImageUrl = (path?: string | null) => {
    if (!path) return '/images/default-avatar.png';
    if (path.startsWith('http')) return path;
    return `http://localhost:8000/storage/${path}`;
};



export const usePartnerStore = defineStore("partners", {
    state: () => ({
        profile: null as Partner | null,
        partners: [] as Partner[],
        loading: false,
        error: null as string | null,
    }),

    getters: {
        isProfileLoaded: (state) => !!state.profile,
    },
    
    actions: {
        async fetchPartners() {
            try {
                this.loading = true;
                this.error = null;

                const data = await PartnersService.getAllPartners();

                if (!data) {
                    this.partners = [];
                    return;
                }

                const rawpartners = Array.isArray(data)
                ? data
                : Array.isArray(data?.data)
                ? data.data
                : Object.values(data ?? {});
                this.partners = rawpartners
                    .filter((u: any) => !u.deleted_at)
                    .sort(
                        (a: any, b: any) =>
                            new Date(b.created_at).getTime() -
                            new Date(a.created_at).getTime()
                    );

            } catch (err: any) {
                this.error = err?.message || "Failed to fetch artist";
            } finally {
                this.loading = false;
            }
        },
        // async fetchAddArtist(payload: CreateArtistPayload){
        //     this.loading = true;
        //     this.error = null;
        //     try {
        //         const res = await partnersService.addArtist(payload);
        //         const newArtist = res.data.data;
        //         this.partners.unshift(newArtist);
        //         return newArtist;
        //     } catch (err: any) {
        //         this.error =err?.response?.data?.message || "Add user false";
        //         throw err;
        //     } finally {
        //         this.loading = false;
        //     }
        // },
        // async fetchSearchArtitst(keyword: string) {
        //     this.loading = true;
        //     this.error = null;

        //     try {
        //         const res = await partnersService.searchArtist(keyword);
        //         console.log(res);
                
        //         const partners = res.data.data;
                
        //         this.partners = partners.map((u: any) => ({
        //             ...u,
        //         }));
                
        //     } catch (err: any) {
        //         this.error = err?.message || "User not found";
        //         this.partners = [];
        //     } finally {
        //         this.loading = false;
        //     }
        // },
        // async fetchDelete(id: number) {
        //     try {
        //         this.loading = true;
        //         this.error = null;
        //         const response = await partnersService.deleteArtist(id);
        //         return response;
        //     } catch (error) {
        //         if (error instanceof Error) {
        //             this.error = error.message;
        //         } else if (typeof error === 'string') {
        //             this.error = error;
        //         } else {
        //             this.error = 'An unknown error occurred';
        //         }
        //         throw error;
        //     } finally {
        //         this.loading = false;
        //     }
        // },
        // async fetchShow(id :number){
        //     return await partnersService.detailArtist(id);
        // },
        // async fetchUpdate(id: number, payload: CreateArtistPayload) {
        //     try {
        //         this.loading = true;
        //         this.error = null;
                
        //         const res = await partnerservice.updateArtist(id, payload);
                
                
        //         const index = this.partners.findIndex(u => u.id === id);
        //         if (index !== -1) {
        //             this.partners[index] = {
        //                 ...this.partners[index],
        //                 ...res.data.data
        //             };
        //         }
                
        //         return res.data;
        //     } catch (err: any) {
        //         this.error = err?.response?.data?.message || "Update user failed";
        //         throw err;
        //     } finally {
        //         this.loading = false;
        //     }
        // },
        
        // // Chỉ sửa phần này
        // async fetchShowStatistic() {
        //     this.loading = true;
        //     this.error = null;
            
        //     try {
        //         const response = await adminApi.get('/partners/statistics');
                
        //         if (response.data.success) {
        //             this.statistics = response.data.data;
        //             // Tự động format statistics
        //             this.getFormattedStatistics as any;
        //             return response.data;
        //         } else {
        //             throw new Error(response.data.message);
        //         }
        //     } catch (err: any) {
        //         this.error = err?.response?.data?.message || err?.message || "Failed to fetch statistics";
        //         throw err;
        //     } finally {
        //         this.loading = false;
        //     }
        // },
            
        // resetStatistics() {
        //     this.statistics = null;
        // }
    }
});
import { defineStore } from "pinia";
import TypePartnersService from "@/modules/admin/services/typePartners/typePartner.service";
import {PartnerType} from '@/interfaces/typePartner.interface';




export const useTypePartnerstore = defineStore("TypePartners", {
    state: () => ({
        profile: null as PartnerType | null,
        TypePartners: [] as PartnerType[],
        loading: false,
        error: null as string | null,
    }),

    getters: {
        isProfileLoaded: (state) => !!state.profile,
    },
    
    actions: {
        async fetchTypePartners() {
            try {
                this.loading = true;
                this.error = null;

                const data = await TypePartnersService.getAllGenres();

                if (!data) {
                    this.TypePartners = [];
                    return;
                }

                const rawTypePartners = Array.isArray(data)
                ? data
                : Array.isArray(data?.data)
                ? data.data
                : Object.values(data ?? {});
                this.TypePartners = rawTypePartners
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
        //         const res = await TypePartnersService.addArtist(payload);
        //         const newArtist = res.data.data;
        //         this.TypePartners.unshift(newArtist);
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
        //         const res = await TypePartnersService.searchArtist(keyword);
        //         console.log(res);
                
        //         const TypePartners = res.data.data;
                
        //         this.TypePartners = TypePartners.map((u: any) => ({
        //             ...u,
        //         }));
                
        //     } catch (err: any) {
        //         this.error = err?.message || "User not found";
        //         this.TypePartners = [];
        //     } finally {
        //         this.loading = false;
        //     }
        // },
        // async fetchDelete(id: number) {
        //     try {
        //         this.loading = true;
        //         this.error = null;
        //         const response = await TypePartnersService.deleteArtist(id);
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
        //     return await TypePartnersService.detailArtist(id);
        // },
        // async fetchUpdate(id: number, payload: CreateArtistPayload) {
        //     try {
        //         this.loading = true;
        //         this.error = null;
                
        //         const res = await TypePartnerservice.updateArtist(id, payload);
                
                
        //         const index = this.TypePartners.findIndex(u => u.id === id);
        //         if (index !== -1) {
        //             this.TypePartners[index] = {
        //                 ...this.TypePartners[index],
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
        //         const response = await adminApi.get('/TypePartners/statistics');
                
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
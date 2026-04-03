import { defineStore } from "pinia";
import ArtistService from "@/modules/client/services/artists/artists.service";
import {ArtistInterface} from '@/interfaces/artists.interface';
// import type { CreateArtistPayload } from '@/modules/admin/interfaces/artists/create-artist.payload';
import type { ArtistStatistics, FormattedArtistStatistics } from '@/modules/client/interfaces/artists/artist.statistic.interface';
import clientApi from '@/plugins/axios';

export const getFullImageUrl = (path?: string | null) => {
    if (!path) return '/images/default-avatar.png';
    if (path.startsWith('http')) return path;
    return `http://localhost:8000/storage/${path}`;
};

export interface ArtistsStatisticsData {
    totalArtists: number;
    newThisMonth: number;
    newLastMonth: number;
    growthPercentage: number;
    status: 'increase' | 'decrease';
}

export const useArtistStore = defineStore("client_artist", {
    state: () => ({
        profile: null as ArtistInterface | null,
        artists: [] as ArtistInterface[],
        loading: false,
        error: null as string | null,
        statistics: null as ArtistStatistics | null,
    }),

    getters: {
        isProfileLoaded: (state) => !!state.profile,
        
        // Getter cho statistics đã format
        getFormattedStatistics: (state) => {
            if (!state.statistics) return null;
            
            const stats = state.statistics;
            const newArtistsDiff = stats.new_artists_this_month - stats.new_artists_last_month;
            
            return {
                totalArtists: {
                    value: stats.total_artists,
                    label: 'Total Artists',
                    change: `${stats.growth_percentage >= 0 ? '+' : ''}${stats.growth_percentage}% from last month`,
                    changeType: stats.growth_percentage >= 0 ? 'positive' : 'negative' as 'positive' | 'negative',
                    iconType: 'total' as const
                },
                newArtistsThisMonth: {
                    value: stats.new_artists_this_month,
                    label: 'Ca sĩ mới trong tháng',
                    change: `${newArtistsDiff >= 0 ? '+' : ''}${newArtistsDiff} so với tháng trước`,
                    changeType: newArtistsDiff >= 0 ? 'positive' : 'negative' as 'positive' | 'negative',
                    iconType: 'new' as const
                },
                growth: {
                    value: `${stats.growth_percentage >= 0 ? '+' : ''}${stats.growth_percentage}%`,
                    label: 'Tăng trưởng',
                    change: `${stats.status === 'increase' ? 'Tăng' : 'Giảm'} ${Math.abs(stats.growth_percentage)}% so với tháng trước`,
                    changeType: stats.growth_percentage >= 0 ? 'positive' : 'negative' as 'positive' | 'negative',
                    iconType: 'growth' as const
                }
            };
        }
    },
    
    actions: {
        async fetchAllArtists() {
            try {
                this.loading = true;
                this.error = null;

                const data = await ArtistService.getAllArtist();

                if (!data) {
                    this.artists = [];
                    return;
                }

                const rawArtists = Array.isArray(data)
                ? data
                : Array.isArray(data?.data)
                ? data.data
                : Object.values(data ?? {});
                this.artists = rawArtists
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
        async fetchArtists(limit: number = 10) {
            this.loading = true;
            this.error = null;
            try {
                const res = await ArtistService.getArtists(limit);

                // Xử lý linh hoạt mọi cấu trúc response
                const raw = res?.data?.data ?? res?.data ?? res ?? [];

                this.artists = Array.isArray(raw) ? raw : Object.values(raw);

            } catch (err: any) {
                if (err.name === 'CanceledError' || err.code === 'ERR_CANCELED') return;
                this.error = err?.response?.data?.message || err.message;
                console.error('fetchArtists error:', err);
                this.artists = []; // ← đảm bảo không bao giờ undefined
            } finally {
                this.loading = false;
            }
        },

        // async fetchAddArtist(payload: CreateArtistPayload){
        //     this.loading = true;
        //     this.error = null;
        //     try {
        //         const res = await artistsService.addArtist(payload);
        //         const newArtist = res.data.data;
        //         this.artists.unshift(newArtist);
        //         return newArtist;
        //     } catch (err: any) {
        //         this.error =err?.response?.data?.message || "Add user false";
        //         throw err;
        //     } finally {
        //         this.loading = false;
        //     }
        // },
        async fetchSearchArtitst(keyword: string) {
            this.loading = true;
            this.error = null;

            try {
                const res = await ArtistService.searchArtist(keyword);
                console.log(res);
                
                const artists = res.data.data;
                
                this.artists = artists.map((u: any) => ({
                    ...u,
                }));
                
            } catch (err: any) {
                this.error = err?.message || "User not found";
                this.artists = [];
            } finally {
                this.loading = false;
            }
        },
        // async fetchDelete(id: number) {
        //     try {
        //         this.loading = true;
        //         this.error = null;
        //         const response = await artistsService.deleteArtist(id);
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
        async fetchShow(id :number){
            return await ArtistService.detailArtist(id);
        },
        // async fetchUpdate(id: number, payload: CreateArtistPayload) {
        //     try {
        //         this.loading = true;
        //         this.error = null;
                
        //         const res = await ArtistService.updateArtist(id, payload);
                
                
        //         const index = this.artists.findIndex(u => u.id === id);
        //         if (index !== -1) {
        //             this.artists[index] = {
        //                 ...this.artists[index],
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
        
        // Chỉ sửa phần này
        async fetchShowStatistic() {
            this.loading = true;
            this.error = null;
            
            try {
                const response = await clientApi.get('/artists/statistics');
                
                if (response.data.success) {
                    this.statistics = response.data.data;
                    // Tự động format statistics
                    this.getFormattedStatistics as any;
                    return response.data;
                } else {
                    throw new Error(response.data.message);
                }
            } catch (err: any) {
                this.error = err?.response?.data?.message || err?.message || "Failed to fetch statistics";
                throw err;
            } finally {
                this.loading = false;
            }
        },
            
        resetStatistics() {
            this.statistics = null;
        }
    }
});
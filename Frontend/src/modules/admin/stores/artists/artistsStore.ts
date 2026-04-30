import { defineStore } from "pinia";
import ArtistService from "@/modules/admin/services/artists/artists.service";
import {ArtistInterface} from '@/interfaces/artists.interface';
import type { CreateArtistPayload } from '@/modules/admin/interfaces/artists/create-artist.payload';
import type { ArtistStatistics, FormattedArtistStatistics } from '@/modules/admin/interfaces/artists/artist.statistic.interface';
import adminApi from "@/plugins/axios_admin";
import artists from "@/common/data/artists";
import artistsService from "@/modules/admin/services/artists/artists.service";

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

export const useArtistStore = defineStore("artist", {
    state: () => ({
        profile: null as ArtistInterface | null,
        artists: [] as ArtistInterface[],
        partnerArtists: [] as ArtistInterface[], // artists filtered by partner
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
        async fetchArtists() {
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

        async fetchArtistsByPartner(partnerId: number) {
            try {
                this.loading = true;
                this.error = null;

                const data = await ArtistService.getAllArtistByPartner(partnerId);

                const rawArtists = Array.isArray(data)
                    ? data
                    : Array.isArray(data?.data)
                    ? data.data
                    : Object.values(data ?? {});

                this.partnerArtists = rawArtists
                    .filter((u: any) => !u.deleted_at)
                    .sort((a: any, b: any) => a.name.localeCompare(b.name));

                return this.partnerArtists;
            } catch (err: any) {
                this.error = err?.message || "Failed to fetch artists by partner";
                this.partnerArtists = [];
            } finally {
                this.loading = false;
            }
        },
        async fetchAddArtist(payload: CreateArtistPayload){
            this.loading = true;
            this.error = null;
            try {
                const res = await artistsService.addArtist(payload);
                const newArtist = res.data.data;
                this.artists.unshift(newArtist);
                return newArtist;
            } catch (err: any) {
                this.error =err?.response?.data?.message || "Add user false";
                throw err;
            } finally {
                this.loading = false;
            }
        },
        async fetchSearchArtitst(keyword: string) {
            this.loading = true;
            this.error = null;

            try {
                const res = await artistsService.searchArtist(keyword);
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
        async fetchDelete(id: number) {
            try {
                this.loading = true;
                this.error = null;
                const response = await artistsService.deleteArtist(id);
                return response;
            } catch (error) {
                if (error instanceof Error) {
                    this.error = error.message;
                } else if (typeof error === 'string') {
                    this.error = error;
                } else {
                    this.error = 'An unknown error occurred';
                }
                throw error;
            } finally {
                this.loading = false;
            }
        },
        async fetchShow(id :number){
            return await artistsService.detailArtist(id);
        },
        async fetchUpdate(id: number, payload: CreateArtistPayload) {
            try {
                this.loading = true;
                this.error = null;
                
                const res = await ArtistService.updateArtist(id, payload);
                
                
                const index = this.artists.findIndex(u => u.id === id);
                if (index !== -1) {
                    this.artists[index] = {
                        ...this.artists[index],
                        ...res.data.data
                    };
                }
                
                return res.data;
            } catch (err: any) {
                this.error = err?.response?.data?.message || "Update user failed";
                throw err;
            } finally {
                this.loading = false;
            }
        },
        
        // Chỉ sửa phần này
        async fetchShowStatistic() {
            this.loading = true;
            this.error = null;
            
            try {
                const response = await adminApi.get('/artists/statistics');
                
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
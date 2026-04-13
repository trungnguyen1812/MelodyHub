import { defineStore } from "pinia";
import GenreService from "@/modules/admin/services/genres/genres.service";
import {GenreInterface} from '@/interfaces/genres.interface';
import type { CreateGenrePayload } from '@/modules/admin/interfaces/genres/create-genre.payload';
import type { GenreStatistics, FormattedGenreStatistics } from '@/modules/admin/interfaces/genres/genre.statistic.interface';
import adminApi from "@/plugins/axios_admin";
import genres from "@/common/data/genres";
import genresService from "@/modules/admin/services/genres/genres.service";

export const getFullImageUrl = (path?: string | null) => {
    if (!path) return '/images/default-avatar.png';
    if (path.startsWith('http')) return path;
    return `http://localhost:8000/storage/${path}`;
};

export interface GenresStatisticsData {
    totalGenres: number;
    newThisMonth: number;
    newLastMonth: number;
    growthPercentage: number;
    status: 'increase' | 'decrease';
}

export const useGenreStore = defineStore("genre", {
    state: () => ({
        profile: null as GenreInterface | null,
        genres: [] as GenreInterface[],
        loading: false,
        error: null as string | null,
        statistics: null as GenreStatistics | null,
    }),

    getters: {
        isProfileLoaded: (state) => !!state.profile,
        
        // Getter cho statistics đã format
        getFormattedStatistics: (state) => {
            if (!state.statistics) return null;
            
            const stats = state.statistics;
            const newGenresDiff = stats.new_genres_this_month - stats.new_genres_last_month;
            
            return {
                totalGenres: {
                    value: stats.total_genres,
                    label: 'Total Genres',
                    change: `${stats.growth_percentage >= 0 ? '+' : ''}${stats.growth_percentage}% from last month`,
                    changeType: stats.growth_percentage >= 0 ? 'positive' : 'negative' as 'positive' | 'negative',
                    iconType: 'total' as const
                },
                newGenresThisMonth: {
                    value: stats.new_genres_this_month,
                    label: 'Ca sĩ mới trong tháng',
                    change: `${newGenresDiff >= 0 ? '+' : ''}${newGenresDiff} so với tháng trước`,
                    changeType: newGenresDiff >= 0 ? 'positive' : 'negative' as 'positive' | 'negative',
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
        async fetchGenres() {
            try {
                this.loading = true;
                this.error = null;

                const data = await GenreService.getAllGenre();

                if (!data) {
                    this.genres = [];
                    return;
                }

                const rawGenres = Array.isArray(data)
                ? data
                : Array.isArray(data?.data)
                ? data.data
                : Object.values(data ?? {});
                this.genres = rawGenres
                    .filter((u: any) => !u.deleted_at)
                    .sort(
                        (a: any, b: any) =>
                            new Date(b.created_at).getTime() -
                            new Date(a.created_at).getTime()
                    );

            } catch (err: any) {
                this.error = err?.message || "Failed to fetch genre";
            } finally {
                this.loading = false;
            }
        },
        async fetchAddGenre(payload: CreateGenrePayload){
            this.loading = true;
            this.error = null;
            try {
                const res = await genresService.addGenre(payload);
                const newGenre = res.data.data;
                this.genres.unshift(newGenre);
                return newGenre;
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
                const res = await genresService.searchGenre(keyword);
                console.log(res);
                
                const genres = res.data.data;
                
                this.genres = genres.map((u: any) => ({
                    ...u,
                }));
                
            } catch (err: any) {
                this.error = err?.message || "User not found";
                this.genres = [];
            } finally {
                this.loading = false;
            }
        },
        async fetchDelete(id: number) {
            try {
                this.loading = true;
                this.error = null;
                const response = await genresService.deleteGenre(id);
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
            return await genresService.detailGenre(id);
        },
        async fetchUpdate(id: number, payload: CreateGenrePayload) {
            try {
                this.loading = true;
                this.error = null;
                
                const res = await GenreService.updateGenre(id, payload);
                
                
                const index = this.genres.findIndex(u => u.id === id);
                if (index !== -1) {
                    this.genres[index] = {
                        ...this.genres[index],
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
                const response = await adminApi.get('/genres/statistics');
                
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
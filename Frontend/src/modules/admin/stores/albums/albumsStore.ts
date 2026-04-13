import { defineStore } from "pinia";
import AlbumService from "@/modules/admin/services/albums/albums.service";
import {AlbumInterface} from '@/interfaces/albums.interface';
import type { CreateAlbumPayload } from '@/modules/admin/interfaces/albums/create-album.payload';
import type { AlbumStatistics, FormattedAlbumStatistics } from '@/modules/admin/interfaces/albums/album.statistic.interface';
import adminApi from "@/plugins/axios_admin";
import albums from "@/common/data/albums";
import albumsService from "@/modules/admin/services/albums/albums.service";

export const getFullImageUrl = (path?: string | null) => {
    if (!path) return '/images/default-avatar.png';
    if (path.startsWith('http')) return path;
    return `http://localhost:8000/storage/${path}`;
};

export interface AlbumsStatisticsData {
    totalAlbums: number;
    newThisMonth: number;
    newLastMonth: number;
    growthPercentage: number;
    status: 'increase' | 'decrease';
}

export const useAlbumStore = defineStore("album", {
    state: () => ({
        profile: null as AlbumInterface | null,
        albums: [] as AlbumInterface[],
        loading: false,
        error: null as string | null,
        statistics: null as AlbumStatistics | null,
    }),

    getters: {
        isProfileLoaded: (state) => !!state.profile,
        
        // Getter cho statistics đã format
        getFormattedStatistics: (state) => {
            if (!state.statistics) return null;
            
            const stats = state.statistics;
            const newAlbumsDiff = stats.new_albums_this_month - stats.new_albums_last_month;
            
            return {
                totalAlbums: {
                    value: stats.total_albums,
                    label: 'Total Albums',
                    change: `${stats.growth_percentage >= 0 ? '+' : ''}${stats.growth_percentage}% from last month`,
                    changeType: stats.growth_percentage >= 0 ? 'positive' : 'negative' as 'positive' | 'negative',
                    iconType: 'total' as const
                },
                newAlbumsThisMonth: {
                    value: stats.new_albums_this_month,
                    label: 'Ca sĩ mới trong tháng',
                    change: `${newAlbumsDiff >= 0 ? '+' : ''}${newAlbumsDiff} so với tháng trước`,
                    changeType: newAlbumsDiff >= 0 ? 'positive' : 'negative' as 'positive' | 'negative',
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
        async fetchAlbums() {
            try {
                this.loading = true;
                this.error = null;

                const data = await AlbumService.getAllAlbum();

                if (!data) {
                    this.albums = [];
                    return;
                }

                const rawAlbums = Array.isArray(data)
                ? data
                : Array.isArray(data?.data)
                ? data.data
                : Object.values(data ?? {});
                this.albums = rawAlbums
                    .filter((u: any) => !u.deleted_at)
                    .sort(
                        (a: any, b: any) =>
                            new Date(b.created_at).getTime() -
                            new Date(a.created_at).getTime()
                    );

            } catch (err: any) {
                this.error = err?.message || "Failed to fetch album";
            } finally {
                this.loading = false;
            }
        },
        async fetchAddAlbum(payload: CreateAlbumPayload){
            this.loading = true;
            this.error = null;
            try {
                const res = await albumsService.addAlbum(payload);
                const newAlbum = res.data.data;
                this.albums.unshift(newAlbum);
                return newAlbum;
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
                const res = await albumsService.searchAlbum(keyword);
                console.log(res);
                
                const albums = res.data.data;
                
                this.albums = albums.map((u: any) => ({
                    ...u,
                }));
                
            } catch (err: any) {
                this.error = err?.message || "User not found";
                this.albums = [];
            } finally {
                this.loading = false;
            }
        },
        async fetchDelete(id: number) {
            try {
                this.loading = true;
                this.error = null;
                const response = await albumsService.deleteAlbum(id);
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
            return await albumsService.detailAlbum(id);
        },
        async fetchUpdate(id: number, payload: CreateAlbumPayload) {
            try {
                this.loading = true;
                this.error = null;
                
                const res = await AlbumService.updateAlbum(id, payload);
                
                
                const index = this.albums.findIndex(u => u.id === id);
                if (index !== -1) {
                    this.albums[index] = {
                        ...this.albums[index],
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
                const response = await adminApi.get('/albums/statistics');
                
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
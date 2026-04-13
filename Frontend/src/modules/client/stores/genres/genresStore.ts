import { defineStore } from "pinia";
import GenresService from "@/modules/client/services/genres/genres.service";
import {GenreInterface} from '@/interfaces/genre.interface';

export const getFullImageUrl = (path?: string | null) => {
    if (!path) return '/images/default-avatar.png';
    if (path.startsWith('http')) return path;
    return `http://localhost:8000/storage/${path}`;
};



export const useGenrestore = defineStore("client_Genres", {
    state: () => ({
        profile: null as GenreInterface | null,
        Genres: [] as GenreInterface[],
        currentGenre: null as GenreInterface | null,
        currentSongs: [] as any[],
        loading: false,
        error: null as string | null,
    }),

    getters: {
        isProfileLoaded: (state) => !!state.profile,
    },
    
    actions: {
        async fetchGenres() {
            try {
                this.loading = true;
                this.error = null;

                const data = await GenresService.getAllGenres();

                if (!data) {
                    this.Genres = [];
                    return;
                }

                const rawGenres = Array.isArray(data)
                ? data
                : Array.isArray(data?.data)
                ? data.data
                : Object.values(data ?? {});
                this.Genres = rawGenres
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
        //         const res = await GenresService.addArtist(payload);
        //         const newArtist = res.data.data;
        //         this.Genres.unshift(newArtist);
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
        //         const res = await GenresService.searchArtist(keyword);
        //         console.log(res);
                
        //         const Genres = res.data.data;
                
        //         this.Genres = Genres.map((u: any) => ({
        //             ...u,
        //         }));
                
        //     } catch (err: any) {
        //         this.error = err?.message || "User not found";
        //         this.Genres = [];
        //     } finally {
        //         this.loading = false;
        //     }
        // },
        // async fetchDelete(id: number) {
        //     try {
        //         this.loading = true;
        //         this.error = null;
        //         const response = await GenresService.deleteArtist(id);
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
        //     return await GenresService.detailArtist(id);
        // },
        // async fetchUpdate(id: number, payload: CreateArtistPayload) {
        //     try {
        //         this.loading = true;
        //         this.error = null;
                
        //         const res = await Genreservice.updateArtist(id, payload);
                
                
        //         const index = this.Genres.findIndex(u => u.id === id);
        //         if (index !== -1) {
        //             this.Genres[index] = {
        //                 ...this.Genres[index],
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
        //         const response = await adminApi.get('/Genres/statistics');
                
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
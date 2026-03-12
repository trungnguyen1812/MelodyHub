import { defineStore } from "pinia";
import ArtistService from "@/modules/admin/services/artists/artists.service";
import {ArtistInterface} from '@/modules/admin/interfaces/artists/artist.interface';
import type { CreateArtistPayload } from '@/modules/admin/interfaces/artists/create-artist.payload';
import adminApi from "@/plugins/axios_admin";
import artists from "@/common/data/artists";
import artistsService from "@/modules/admin/services/artists/artists.service";



export const getFullImageUrl = (path?: string | null) => {
    if (!path) return '/images/default-avatar.png';

    if (path.startsWith('http')) return path;

    return `http://localhost:8000/storage/${path}`;
};


export const useArtistStore = defineStore("artist", {
    state: () => ({
        profile: null as ArtistInterface | null,
        artists: [] as ArtistInterface[],
        loading: false,
        error: null as string | null,
    }),

    getters: {
        isProfileLoaded: (state) => !!state.profile,
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
        async fetchShow(slug :string){
            return await artistsService.detailArtist(slug);
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
        }
    },
    
});

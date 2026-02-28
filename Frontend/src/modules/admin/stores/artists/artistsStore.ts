import { defineStore } from "pinia";
import ArtistService from "@/modules/admin/services/artists/artists.service";
import {ArtistInterface} from '@/modules/admin/interfaces/artists/artist.interface';
import adminApi from "@/plugins/axios_admin";
import artists from "@/common/data/artists";



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
        // async fetchAddUser(payload: CreateUserPayload){
        //     this.loading = true;
        //     this.error = null;
        //     try {
        //         const res = await userService.addUser(payload);
        //         const newUser = res.data.data;
        //         this.users.unshift(newUser);
        //         return newUser;
        //     } catch (err: any) {
        //         this.error =err?.response?.data?.message || "Add user false";
        //         throw err;
        //     } finally {
        //         this.loading = false;
        //     }
        // },
        // async fetchSearchUser(keyword: string) {
        //     this.loading = true;
        //     this.error = null;

        //     try {
        //         const res = await userService.searchUser(keyword);

        //         const users = res.data.data;
                
        //         this.users = users.map((u: any) => ({
        //             ...u,
        //             role_display_name:
        //             ROLE_DISPLAY_MAP[u.roles?.[0]?.name ?? ""] ?? "—"
        //         }));
        //     } catch (err: any) {
        //         this.error = err?.message || "User not found";
        //         this.users = [];
        //     } finally {
        //         this.loading = false;
        //     }
        // },
        // async fetchDelete(id: number) {
        //     try {
        //         this.loading = true;
        //         this.error = null;
        //         const response = await userService.deleteUser(id);
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
        //     return await userService.detailUser(id);
        // },
        // async fetchUpdate(id: number, payload: CreateUserPayload) {
        //     try {
        //         this.loading = true;
        //         this.error = null;
                
        //         const res = await userService.updateUser(id, payload);
                
        //         const index = this.users.findIndex(u => u.id === id);
        //         if (index !== -1) {
        //             this.users[index] = {
        //                 ...this.users[index],
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
        // }
    },
    
});

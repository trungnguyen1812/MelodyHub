import { defineStore } from "pinia";
import GenresService from "@/modules/client/services/genres/genres.service";
import { GenreInterface } from '@/interfaces/genre.interface';

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
        songsMeta: null as { current_page: number; last_page: number; per_page: number; total: number } | null,
        loading: false,
        error: null as string | null,
    }),

    getters: {
        isProfileLoaded: (state) => !!state.profile,
        hasMoreSongs: (state) =>
            state.songsMeta ? state.songsMeta.current_page < state.songsMeta.last_page : false,
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
                this.error = err?.message || "Failed to fetch genres";
            } finally {
                this.loading = false;
            }
        },

        async fetchGenreDetail(slug: string) {
            this.loading = true;
            this.error = null;
            this.currentGenre = null;
            this.currentSongs = [];
            this.songsMeta = null;

            try {
                const data = await GenresService.getGenreDetail(slug);

                if (data?.success && data?.data) {
                    this.currentGenre = data.data.genre;
                    
                    // Handle paginated songs from SongResource::collection
                    const songsRaw = data.data.songs;
                    this.currentSongs = Array.isArray(songsRaw?.data)
                        ? songsRaw.data
                        : Array.isArray(songsRaw)
                        ? songsRaw
                        : [];

                    // Store pagination meta
                    if (data.data.meta) {
                        this.songsMeta = data.data.meta;
                    }
                }

                return data;
            } catch (err: any) {
                this.error = err?.response?.data?.message || err?.message || "Genre not found";
                throw err;
            } finally {
                this.loading = false;
            }
        },

        resetGenreDetail() {
            this.currentGenre = null;
            this.currentSongs = [];
            this.songsMeta = null;
            this.error = null;
        },
    }
});
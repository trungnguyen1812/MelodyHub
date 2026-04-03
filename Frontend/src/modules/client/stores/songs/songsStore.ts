import { defineStore } from 'pinia'
import songsService from '@/modules/client/services/songs/songs.service'
import type { CreateSongPayload } from '@/modules/client/interfaces/songs/create-song.payload'
import type { UpdateSongPayload } from "@/modules/client/interfaces/songs/update_song.payload";
import type {
    Song,
    SongMeta,
    SongFilterParams,
    SongStats,
    SongGenre,
} from '@/interfaces/songs.interface'

export const useSongStore = defineStore('client_song', {
    state: () => ({
        songs:       [] as Song[],
        SongGenre:   [] as SongGenre[],
        newSongs: [] as Song[],      
        popularSongs: [] as Song[], 
        currentSong: null as Song | null,
        currentLyrics: null as string | null, 
        meta:        null as SongMeta | null,
        Stats:       null as SongStats | null,
        loading:     false,
        error:       null as string | null,
    }),

    getters: {
        // Chọn URL tốt nhất để phát
        getBestUrl: () => (song: Song, prefer: 'lossless' | 'standard' | 'low' = 'standard'): string | null => {
            const { urls } = song
            if (prefer === 'lossless' && urls.lossless) return urls.lossless
            if (prefer === 'standard' && urls.standard) return urls.standard
            return urls.standard ?? urls.low ?? urls.lossless ?? null
        },

        hasNextPage: (state) =>
            state.meta ? state.meta.current_page < state.meta.last_page : false,
    },

    actions: {
        // ── Thêm bài hát mới ──
        async fetchAddSong(payload: CreateSongPayload) {
            this.loading = true
            this.error   = null
            try {
                const res    = await songsService.addSong(payload)
                console.log(res)
                const newSong: Song = res.data.data
                this.songs.unshift(newSong)
                return newSong
            } catch (err: any) {
                this.error = err?.response?.data?.message || 'Add song failed'
                throw err
            } finally {
                this.loading = false
            }
        },

        // ── get list new songs ( filter ) ──
        async fetchAllSongs(params: SongFilterParams = {}) {
            this.loading = true
            this.error   = null
            try {
                const res = await songsService.getAllSongs(params)                
                this.songs = res.data.data
                this.meta  = res.data.meta
                return res.data
            } catch (err: any) {
                this.error = err?.response?.data?.message || 'Failed to fetch songs'
                throw err
            } finally {
                this.loading = false
            }
        },
        async fetchNewSongs(limit: number = 10) {
            this.loading = true;
            this.error = null;
            try {
                const res = await songsService.getNewSongs(limit);
                const raw = res?.data?.data ?? res?.data ?? res ?? [];
                this.newSongs = Array.isArray(raw) ? raw : Object.values(raw);
            } catch (err: any) {
                if (err.name === 'CanceledError' || err.code === 'ERR_CANCELED') return;
                this.error = err?.response?.data?.message || err.message;
                console.error('fetchArtists error:', err);
                this.newSongs = [];
            } finally {
                this.loading = false;
            }
        },

        async fetchPopularSongs(limit: number = 10) {
            this.loading = true;
            this.error = null;
            try {
                const res = await songsService.getPopularSongs(limit);
                const raw = res?.data?.data ?? res?.data ?? [];
                this.popularSongs = Array.isArray(raw) ? raw : [];
            } catch (err: any) {
                if (err.code === 'ERR_CANCELED') return;
                this.error = err?.response?.data?.message || err.message;
                this.popularSongs = [];
            } finally {
                this.loading = false;
            }
        },

        // ── Load thêm trang tiếp (infinite scroll) ──
        async fetchNextPage(params: SongFilterParams = {}) {
            if (!this.meta || !this.hasNextPage) return
            const nextParams = { ...params, page: this.meta.current_page + 1 }
            this.loading = true
            try {
                const res = await songsService.getAllSongs(nextParams)
                this.songs.push(...res.data.data)   // append thêm vào list
                this.meta = res.data.meta
            } catch (err: any) {
                this.error = err?.response?.data?.message || 'Failed to load more'
            } finally {
                this.loading = false
            }
        },

        // ── Lấy chi tiết 1 bài theo id hoặc slug ──
        async fetchSongs(params: SongFilterParams = {}) {
            this.loading = true
            this.error   = null
            
            try {
                const res = await songsService.getAllSongs(params)
                this.songs = res.data.data
                this.meta  = res.data.meta
                return res.data
            } catch (err: any) {
                this.error = err?.response?.data?.message || 'Failed to fetch songs'
                throw err
            } finally {
                this.loading = false
            }
        },

        async fetchSong(idOrSlug: string | number) {
            this.loading     = true
            this.error       = null
            this.currentSong = null
            this.currentLyrics = null
            try {
                const res        = await songsService.getSong(idOrSlug)
                this.currentSong = res.data.data
                this.currentLyrics = res.data.data?.lyrics || null
                return this.currentSong
            } catch (err: any) {
                this.error = err?.response?.data?.message || 'Song not found'
                throw err
            } finally {
                this.loading = false
            }
        },

        async fetchSongById(id: number) {
            const res = await songsService.getSong(id)
            const song: Song = res.data.data
            // Cập nhật luôn trong list nếu có
            const index = this.songs.findIndex(s => s.id === id)
            if (index !== -1) this.songs[index] = song
            return song
        },

        async fetchDelete(id: number) {
            try {
                this.loading = true;
                this.error = null;
                const response = await songsService.deleteSong(id);
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

        async fetchDeleteMultiple(ids: number[]) {
            try {
                this.loading = true;
                this.error = null;
                const response = await songsService.deleteMultipleSongs(ids);
                return response;
            } catch (error) {
                if (error instanceof Error) {
                    this.error = error.message;
                } else {
                    this.error = 'An unknown error occurred';
                }
                throw error;
            } finally {
                this.loading = false;
            }
        },
        
        async fetchUpdateSong(id: number, payload: UpdateSongPayload) {
            this.loading = true;
            this.error   = null;
            try {
                const res         = await songsService.updateSong(id, payload);
                const updatedSong: Song = res.data.data;

                const index = this.songs.findIndex(s => s.id === id);
                if (index !== -1) this.songs[index] = { ...this.songs[index], ...updatedSong };

                return updatedSong;
            } catch (err: any) {
                this.error = err?.response?.data?.message || 'Update song failed';
                throw err;
            } finally {
                this.loading = false;
            }
        },

        // ── Reset state ──
        resetSongs() {
            this.songs       = []
            this.meta        = null
            this.currentSong = null
            this.error       = null
        },
    },
})
import { defineStore } from 'pinia';
import AdminCopyrightService from '@/modules/admin/services/copyright/copyright.service';

export interface AdminCopyright {
    id: number;
    song_id: number;
    partner_id: number;
    copyright_type: string;
    owner_name: string;
    registration_number: string | null;
    registration_date: string | null;
    registration_country: string | null;
    valid_from: string;
    valid_until: string | null;
    territory: string | null;
    rights_included: string | null;
    document_url: string | null;
    notes: string | null;
    status: 'active' | 'pending' | 'expired' | 'disputed' | 'revoked';
    verified_at: string | null;
    verified_by: number | null;
    created_at: string;
    updated_at: string;
    song?: {
        id: number;
        title: string;
        cover_url?: string | null;
        artist?: { id: number; name: string };
        genre?: { id: number; name: string };
    };
partner?: {
        id: number;
        company_name: string;
        user?: { id: number; name: string; email: string };
    };
}

export interface CopyrightStats {
    total: number;
    pending: number;
    active: number;
    expired: number;
    disputed: number;
    revoked: number;
    by_type: Record<string, number>;
    monthly: { month: string; count: number }[];
}

interface Pagination {
    current_page: number;
    last_page: number;
    per_page: number;
    total: number;
}

export const useAdminCopyrightStore = defineStore('adminCopyright', {
    state: () => ({
        copyrights: [] as AdminCopyright[],
        currentCopyright: null as AdminCopyright | null,
        stats: null as CopyrightStats | null,
        pagination: { current_page: 1, last_page: 1, per_page: 15, total: 0 } as Pagination,
        loading: false,
        statsLoading: false,
        error: null as string | null,
    }),

    actions: {
        async fetchCopyrights(params = {}) {
            this.loading = true;
            this.error = null;
            try {
                const res = await AdminCopyrightService.getAll(params);
                if (res.success) {
                    this.copyrights = res.data;
                    this.pagination = {
                        current_page: res.current_page,
                        last_page: res.last_page,
                        per_page: res.per_page,
                        total: res.total,
                    };
                }
                return res;
            } catch (e: any) {
                this.error = e?.response?.data?.message ?? e.message;
                throw e;
            } finally {
                this.loading = false;
            }
        },

        async fetchStats() {
            this.statsLoading = true;
            try {
                const res = await AdminCopyrightService.getStats();
                if (res.success) this.stats = res.data;
                return res;
            } catch (e: any) {
                this.error = e?.response?.data?.message ?? e.message;
            } finally {
                this.statsLoading = false;
            }
        },

        async fetchDetail(id: number) {
            // Dùng detailLoading riêng, KHÔNG set this.loading để tránh ảnh hưởng table
            try {
                const res = await AdminCopyrightService.getDetail(id);
                if (res.success) this.currentCopyright = res.data;
                return res;
            } catch (e: any) {
                this.error = e?.response?.data?.message ?? e.message;
                throw e;
            }
        },

        async approve(id: number, notes?: string) {
            try {
                const res = await AdminCopyrightService.approve(id, notes);
                if (res.success) {
                    const idx = this.copyrights.findIndex(c => c.id === id);
                    if (idx !== -1) this.copyrights[idx] = res.data;
                    if (this.currentCopyright?.id === id) this.currentCopyright = res.data;
                    if (this.stats) {
                        this.stats.pending = Math.max(0, this.stats.pending - 1);
                        this.stats.active++;
                    }
                }
                return res;
            } catch (e: any) {
                this.error = e?.response?.data?.message ?? e.message;
                throw e;
            }
        },

        async reject(id: number, reason?: string) {
            try {
                const res = await AdminCopyrightService.reject(id, reason);
                if (res.success) {
                    const idx = this.copyrights.findIndex(c => c.id === id);
                    if (idx !== -1) this.copyrights[idx] = res.data;
                    if (this.currentCopyright?.id === id) this.currentCopyright = res.data;
                    if (this.stats) {
                        this.stats.pending = Math.max(0, this.stats.pending - 1);
                        this.stats.revoked++;
                    }
                }
                return res;
            } catch (e: any) {
                this.error = e?.response?.data?.message ?? e.message;
                throw e;
            }
        },

        clearError() { this.error = null; },
    },
});

import { defineStore } from "pinia";
import userService from "@/modules/admin/services/user/user.service";
import {UserInterface} from '@/modules/admin/interfaces/users/user.interface';
import type { CreateUserPayload } from "@/modules/admin/interfaces/users/create-user.payload";
import  { UserStatisticsData } from '@/modules/admin/interfaces/users/user.statistic';
import adminApi from "@/plugins/axios_admin";


const ROLE_DISPLAY_MAP: Record<string, string> = {
    boss: "Boss / Owner",
    admin: "Administrator",
    content_manager: "Content Manager",
    partner: "Partner / Producer",
    moderator: "Moderator",
    user_vip_yearly: "VIP Yearly User",
    user_vip_monthly: "VIP Monthly User",
    user_free: "Free User",
};


const defaultStatistics: UserStatisticsData = {
    // Current counts
    total_users: 0,
    free_users: 0,
    partners: 0,
    admins: 0,
    vip_users: 0,
    
    // Growth percentages
    total_growth_percentage: 0,
    free_growth_percentage: 0,
    partner_growth_percentage: 0,
    admin_growth_percentage: 0,
    vip_growth_percentage: 0,
    
    // Growth trends
    total_growth_trend: 'neutral',
    free_growth_trend: 'neutral',
    partner_growth_trend: 'neutral',
    admin_growth_trend: 'neutral',
    vip_growth_trend: 'neutral',
    
    // New users this month
    new_users_this_month: 0,
    new_free_users_this_month: 0,
    new_partners_this_month: 0,
    new_admins_this_month: 0,
    new_vip_users_this_month: 0
}


export const getFullImageUrl = (path?: string | null) => {
    if (!path) return '/images/default-avatar.png';

    if (path.startsWith('http')) return path;

    return `http://localhost:8000/storage/${path}`;
};

export const useUserStore = defineStore("user", {
    state: () => ({
        profile: null as UserInterface | null,
        users: [] as UserInterface[],
        loading: false,
        error: null as string | null,
        statistics: { ...defaultStatistics } as UserStatisticsData,
    }),

    getters: {
        isProfileLoaded: (state) => !!state.profile,

        safeStatistics: (state) => state.statistics || defaultStatistics,

        // Getter tổng hợp cho growth data của từng loại
        totalGrowthInfo: (state) => ({
            icon: state.statistics.total_growth_trend === 'up' ? '↑' : 
                  state.statistics.total_growth_trend === 'down' ? '↓' : '→',
            value: Math.abs(state.statistics.total_growth_percentage),
            class: state.statistics.total_growth_trend === 'up' ? 'positive' : 
                   state.statistics.total_growth_trend === 'down' ? 'negative' : 'neutral',
            text: `${state.statistics.total_growth_trend === 'up' ? '↑' : 
                   state.statistics.total_growth_trend === 'down' ? '↓' : '→'} 
                   ${Math.abs(state.statistics.total_growth_percentage)}% from last month`
        }),

        freeGrowthInfo: (state) => ({
            icon: state.statistics.free_growth_trend === 'up' ? '↑' : 
                  state.statistics.free_growth_trend === 'down' ? '↓' : '→',
            value: Math.abs(state.statistics.free_growth_percentage),
            class: state.statistics.free_growth_trend === 'up' ? 'positive' : 
                   state.statistics.free_growth_trend === 'down' ? 'negative' : 'neutral',
            text: `${state.statistics.free_growth_trend === 'up' ? '↑' : 
                   state.statistics.free_growth_trend === 'down' ? '↓' : '→'} 
                   ${Math.abs(state.statistics.free_growth_percentage)}% from last month`
        }),

        partnerGrowthInfo: (state) => ({
            icon: state.statistics.partner_growth_trend === 'up' ? '↑' : 
                  state.statistics.partner_growth_trend === 'down' ? '↓' : '→',
            value: Math.abs(state.statistics.partner_growth_percentage),
            class: state.statistics.partner_growth_trend === 'up' ? 'positive' : 
                   state.statistics.partner_growth_trend === 'down' ? 'negative' : 'neutral',
            text: `${state.statistics.partner_growth_trend === 'up' ? '↑' : 
                   state.statistics.partner_growth_trend === 'down' ? '↓' : '→'} 
                   ${Math.abs(state.statistics.partner_growth_percentage)}% from last month`
        }),

        adminGrowthInfo: (state) => ({
            icon: state.statistics.admin_growth_trend === 'up' ? '↑' : 
                  state.statistics.admin_growth_trend === 'down' ? '↓' : '→',
            value: Math.abs(state.statistics.admin_growth_percentage),
            class: state.statistics.admin_growth_trend === 'up' ? 'positive' : 
                   state.statistics.admin_growth_trend === 'down' ? 'negative' : 'neutral',
            text: `${state.statistics.admin_growth_trend === 'up' ? '↑' : 
                   state.statistics.admin_growth_trend === 'down' ? '↓' : '→'} 
                   ${Math.abs(state.statistics.admin_growth_percentage)}% from last month`
        }),

        vipGrowthInfo: (state) => ({
            icon: state.statistics.vip_growth_trend === 'up' ? '↑' : 
                  state.statistics.vip_growth_trend === 'down' ? '↓' : '→',
            value: Math.abs(state.statistics.vip_growth_percentage),
            class: state.statistics.vip_growth_trend === 'up' ? 'positive' : 
                   state.statistics.vip_growth_trend === 'down' ? 'negative' : 'neutral',
            text: `${state.statistics.vip_growth_trend === 'up' ? '↑' : 
                   state.statistics.vip_growth_trend === 'down' ? '↓' : '→'} 
                   ${Math.abs(state.statistics.vip_growth_percentage)}% from last month`
        }),
    },
    
   
    actions: {
        async fetchUsers() {
            try {
                this.loading = true;
                this.error = null;

                const data = await userService.getAllUser();

                if (!data) {
                    this.users = [];
                    return;
                }

                 const rawArtists = Array.isArray(data)
                ? data
                : Array.isArray(data?.data)
                ? data.data
                : Object.values(data ?? {});
                this.users = rawArtists
                    .filter((u: any) => !u.deleted_at)
                    .map((u: any) => ({
                        ...u,
                        role_display_name:
                            ROLE_DISPLAY_MAP[u.roles?.[0]?.name ?? ""] ?? "—"
                    }))
                    .sort(
                        (a: any, b: any) =>
                            new Date(b.created_at).getTime() -
                            new Date(a.created_at).getTime()
                    );


            } catch (err: any) {
                this.error = err?.message || "Failed to fetch users";
            } finally {
                this.loading = false;
            }
        },
        async fetchAddUser(payload: CreateUserPayload){
            this.loading = true;
            this.error = null;
            try {
                const res = await userService.addUser(payload);
                const newUser = res.data.data;
                this.users.unshift(newUser);
                return newUser;
            } catch (err: any) {
                this.error =err?.response?.data?.message || "Add user false";
                throw err;
            } finally {
                this.loading = false;
            }
        },
        async fetchSearchUser(keyword: string) {
            this.loading = true;
            this.error = null;

            try {
                const res = await userService.searchUser(keyword);

                const users = res.data.data;
                
                this.users = users.map((u: any) => ({
                    ...u,
                    role_display_name:
                    ROLE_DISPLAY_MAP[u.roles?.[0]?.name ?? ""] ?? "—"
                }));
            } catch (err: any) {
                this.error = err?.message || "User not found";
                this.users = [];
            } finally {
                this.loading = false;
            }
        },
        async fetchDelete(id: number) {
            try {
                this.loading = true;
                this.error = null;
                const response = await userService.deleteUser(id);
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
            return await userService.detailUser(id);
        },
        async fetchUpdate(id: number, payload: CreateUserPayload) {
            try {
                this.loading = true;
                this.error = null;
                
                const res = await userService.updateUser(id, payload);
                
                const index = this.users.findIndex(u => u.id === id);
                if (index !== -1) {
                    this.users[index] = {
                        ...this.users[index],
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
                async fetchShowStatistics() {
            this.loading = true
            try {
                const response = await userService.getUserStatistics()
                
                let rawData: any = response
                
                // Xử lý các cấu trúc khác nhau
                if (rawData?.original) {
                    rawData = rawData.original
                }
                
                
                // Map dữ liệu từ API vào interface mới
                this.statistics = {
                    // Current counts
                    total_users: Number(rawData?.total_users) || 0,
                    free_users: Number(rawData?.free_users) || 0,
                    partners: Number(rawData?.partners) || 0,
                    admins: Number(rawData?.admins) || 0,
                    vip_users: Number(rawData?.vip_users) || 0,
                    
                    // Growth percentages
                    total_growth_percentage: Number(rawData?.total_growth_percentage) || 0,
                    free_growth_percentage: Number(rawData?.free_growth_percentage) || 0,
                    partner_growth_percentage: Number(rawData?.partner_growth_percentage) || 0,
                    admin_growth_percentage: Number(rawData?.admin_growth_percentage) || 0,
                    vip_growth_percentage: Number(rawData?.vip_growth_percentage) || 0,
                    
                    // Growth trends
                    total_growth_trend: rawData?.total_growth_trend || 'neutral',
                    free_growth_trend: rawData?.free_growth_trend || 'neutral',
                    partner_growth_trend: rawData?.partner_growth_trend || 'neutral',
                    admin_growth_trend: rawData?.admin_growth_trend || 'neutral',
                    vip_growth_trend: rawData?.vip_growth_trend || 'neutral',
                    
                    // New users this month
                    new_users_this_month: Number(rawData?.new_users_this_month) || 0,
                    new_free_users_this_month: Number(rawData?.new_free_users_this_month) || 0,
                    new_partners_this_month: Number(rawData?.new_partners_this_month) || 0,
                    new_admins_this_month: Number(rawData?.new_admins_this_month) || 0,
                    new_vip_users_this_month: Number(rawData?.new_vip_users_this_month) || 0
                }
                
            } catch (error) {
                console.error('Failed to fetch statistics:', error)
                this.statistics = { ...defaultStatistics }
            } finally {
                this.loading = false
            }
        },
    },
    
});

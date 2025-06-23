import { defineStore } from 'pinia';
import http from "@/utils/http";

import type {
  User,
  LoginCredentials,
  LoginResponse,
  AuthState,
} from "../interfaces/auth.interface";

export const useAuthStore = defineStore('adminAuth', {
    state: (): AuthState => ({
        user: null,
        isAuthenticated: false,
        token: null, // Thêm token vào state để persist
    }),

    actions: {
        async login(credentials: LoginCredentials): Promise<LoginResponse> {
            try {
                // Lấy CSRF cookie trước
                await http.get("/sanctum/csrf-cookie");
                await new Promise(resolve => setTimeout(resolve, 100));
                
                const { data } = await http.post<LoginResponse>("/api/admin/login", credentials);
                
                // Cập nhật state thay vì localStorage trực tiếp
                this.token = data.token;
                this.user = data.user;
                this.isAuthenticated = true;
                
                return data;
            } catch (error: any) {
                console.error('Login error:', error.response?.data || error);
                throw error.response?.data || error;
            }
        },

        async fetchUser(): Promise<User> {
            try {
                const { data } = await http.get<User>("/api/admin/user");
                this.user = data;
                this.isAuthenticated = true;
                return data;
            } catch (error: any) {
                this.logout();
                throw error;
            }
        },

        async logout(): Promise<void> {
            try {
                await http.post("/api/logout");
            } finally {
                this.clearAuth();
            }
        },

        clearAuth(): void {
            // Không cần xóa localStorage trực tiếp nữa
            this.token = null;
            this.user = null;
            this.isAuthenticated = false;
        },
    },
    
    // Bỏ persist: true vì đã có plugin tự custom
});
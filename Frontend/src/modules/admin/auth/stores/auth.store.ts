import { defineStore } from 'pinia';
import { ref } from "vue";
import http from '@/utils/http';
import type { User } from '@/modules/admin/auth/interfaces/auth.interface';

interface LoginResponse {
    token: string;
    user: User;
}

interface Credentials {
    email: string;
    password: string;
}

export const useAuthStore = defineStore('auth', () => {
    const user = ref<User | null>(null);
    const isAuthenticated = ref(false);

    const login = async (credentials: Credentials): Promise<LoginResponse> => {
        try {
            // Sửa đường dẫn thành '/sanctum/csrf-cookie' (nếu dùng Sanctum)
            await http.get('/sanctum/csrf-cookie');
            
            // Sửa đường dẫn API cho đúng với backend (thêm '/api' nếu cần)
            const { data } = await http.post<LoginResponse>('/api/login', credentials);

            localStorage.setItem('auth_token', data.token);
            user.value = data.user;
            isAuthenticated.value = true;

            return data;
        } catch (error: any) {
            throw error.response?.data || error;
        }
    };

    const fetchUser = async (): Promise<User> => {
        try {
            // Sửa đường dẫn API cho đúng với backend
            const { data } = await http.get<User>('/api/admin/user');
            user.value = data;
            isAuthenticated.value = true;
            return data;
        } catch (error: any) {
            logout();
            throw error;
        }
    };

    const logout = async (): Promise<void> => {
        try {
            // Sửa đường dẫn API cho đúng với backend
            await http.post('/api/logout');
        } finally {
            clearAuth();
        }
    };

    const clearAuth = (): void => {
        localStorage.removeItem('auth_token');
        user.value = null;
        isAuthenticated.value = false;
    };

    return {
        user,
        isAuthenticated,
        login,
        fetchUser,
        logout,
        clearAuth
    };
});
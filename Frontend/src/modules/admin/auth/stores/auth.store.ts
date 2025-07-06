import { defineStore } from "pinia";
import { ref } from "vue";
import http from "@/utils/http";
import type { User } from "@/modules/admin/auth/interfaces/auth.interface";

interface LoginResponse {
  token: string;
  user: User;
}

interface Credentials {
  email: string;
  password: string;
}

export const useAuthStore = defineStore("auth.store", () => {
  const user = ref<User | null>(null);
  const isAuthenticated = ref(false);

  const login = async (credentials: Credentials): Promise<LoginResponse> => {
    try {
      console.log("Auth Store - Starting login..."); // Debug
      console.log("Credentials:", credentials); // Debug

      // CSRF cookie cho Sanctum
      console.log("Getting CSRF cookie..."); // Debug
      await http.get("/sanctum/csrf-cookie");

      // Login request
      console.log("Sending login request..."); // Debug
      const { data } = await http.post<LoginResponse>(
        "/api/login",
        credentials
      );
      console.log("Login successful, saving token..."); // Debug

      // Lưu token - thống nhất chỉ dùng auth_token
      localStorage.setItem("auth_token", data.token);
      user.value = data.user;
      isAuthenticated.value = true;

      console.log("Login completed successfully"); // Debug
      return data;
    } catch (error: any) {
      console.error("Login error in store:", {
        message: error.message,
        response: error.response?.data,
        status: error.response?.status,
      }); // Debug

      // QUAN TRỌNG: Throw nguyên error để component có thể truy cập error.response
      throw error;
    }
  };

  const fetchUser = async (): Promise<User> => {
    try {
      const { data } = await http.get<User>("/api/admin/user");
      user.value = data;
      isAuthenticated.value = true;
      return data;
    } catch (error: any) {
      console.error("Fetch user error:", error); // Debug
      logout();
      throw error;
    }
  };

  const logout = async (): Promise<void> => {
    try {
      await http.post("/api/logout", null, { withCredentials: true });
    } catch (error) {
      console.error("Logout error:", error);
    } finally {
      clearAuth();
    }
  };

  const clearAuth = (): void => {
    localStorage.removeItem("auth_token");
    // Cũng xóa pinia store nếu có
    localStorage.removeItem("pinia_adminAuth");
    user.value = null;
    isAuthenticated.value = false;
  };

  // Khởi tạo auth state khi app start
  const initAuth = (): void => {
    const token = localStorage.getItem("auth_token");
    if (token) {
      isAuthenticated.value = true;
      // Có thể fetch user info ở đây nếu cần
    }
  };

  return {
    user,
    isAuthenticated,
    login,
    fetchUser,
    logout,
    clearAuth,
    initAuth,
  };
});
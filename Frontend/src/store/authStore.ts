import { defineStore } from "pinia";
import AuthService from "@/services/auth.services";
import { data } from "autoprefixer";

interface User {
  id: number;
  fullname: string;
  email: string;
  avatar?: string;
  // thêm các trường khác nếu có
}

interface AuthState {
  isAuthenticated: boolean;
  user: User | null;
  token: string;
}

export const useAuthStore = defineStore("auth", {
  state: (): AuthState => ({
    isAuthenticated: !!localStorage.getItem("auth_token"),
    user: (()=>{
      try {
        return JSON.parse(localStorage.getItem("auth_user") || "null");
      } catch {
        localStorage.removeItem("auth_user");
        return null;
      }
    })(),
    token: localStorage.getItem("auth_token") || "",
  }),

  getters: {
    // Thêm getter để kiểm tra nhanh
    isLoggedIn: (state) => state.isAuthenticated && !!state.token,
  },

  actions: {
    async login(emailInput: string, passwordInput: string) {
      try {
        const data = await AuthService.login(emailInput, passwordInput);
        this.isAuthenticated = true;
        this.token = data.token;
        this.user = data.user;
        
        // Lưu vào localStorage
        localStorage.setItem("auth_token", data.token);
        localStorage.setItem("auth_user", JSON.stringify(data.user));
        
        return data;
      } catch (error) {
        // Reset state nếu login thất bại
        this.logout();
        throw error;
      }
    },

    async register(fullname: string , email:string , password:string){
      try {
        const data = await AuthService.register(fullname,email,password);
        this.isAuthenticated = true;
        this.token = data.token;
        this.user  = data.user;

        localStorage.setItem("auth_token", data.token);
        localStorage.setItem("auth_user" , JSON.stringify(data.user));

        return data;
      } catch (error) {
        throw error;
      }
    },

    logout() {
      try {
        AuthService.logout();
      } catch (error) {
        console.error("Logout error:", error);
      } finally {
        this.isAuthenticated = false;
        this.token = "";
        this.user = null;
        localStorage.removeItem("auth_token");
        localStorage.removeItem("auth_user");
      }
    },

    

    // Thêm action để khôi phục state từ localStorage
    initializeAuth() {
      const token = localStorage.getItem("auth_token");
      const user = localStorage.getItem("auth_user");
      
      if (token && user) {
        this.isAuthenticated = true;
        this.token = token;
        this.user = JSON.parse(user);
      } else {
        this.isAuthenticated = false;
        this.token = "";
        this.user = null;
      }
    }
  },
});
import { defineStore } from "pinia";
import AuthService from "@/services/auth.services";
import { data } from "autoprefixer";
import authServices from "@/services/auth.services";
import { ref} from "vue";

interface User {
  id: number;
  fullname: string;
  email: string;
  avatar?: string;
  name:string;
  // thêm các trường khác nếu có
}

interface AuthState {
  isAuthenticated: boolean;
  user: User | null;
  token: string;

  rolesFlags: Record<string, boolean> | null;
  isAdmin: boolean;
  permissionLoaded: boolean;
}

export const useAuthStore = defineStore("auth", {
  state: (): AuthState => ({
    isAuthenticated: !!localStorage.getItem("client_token"),
    user: (()=>{
      try {
        return JSON.parse(localStorage.getItem("auth_user") || "null");
      } catch {
        localStorage.removeItem("auth_user");
        return null;
      }
    })(),
    token: localStorage.getItem("client_token") || "",
    rolesFlags: null,
    isAdmin: false,
    permissionLoaded: false,
  }),

  getters: {
    // Add getters for quick testing.
    isLoggedIn: (state) => state.isAuthenticated && !!state.token,
  },

  actions: {
    async login(emailInput: string, passwordInput: string) {
      try {
        const data = await AuthService.login(emailInput, passwordInput);
        this.isAuthenticated = true;
        this.token = data.token;
        this.user = data.user;
        // save localStorage
        localStorage.setItem("client_token", data.token);
        localStorage.setItem("auth_user", JSON.stringify(data.user));
        
        return data;
      } catch (error) {
        // Reset state if login fails
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

        localStorage.setItem("client_token", data.token);
        localStorage.setItem("auth_user" , JSON.stringify(data.user));

        return data;
      } catch (error) {
        throw error;
      }
    },

    async logout() {
      try {
        await AuthService.logout();
      } catch (error) {
        console.error("Logout error:", error);
      } finally {
        this.isAuthenticated = false;
        this.token = "";
        this.user = null;
        localStorage.removeItem("client_token");
        localStorage.removeItem("admin_token");
        localStorage.removeItem("auth_user");
        this.$reset();
      }
    },

    async getEmail(){
      const email  = ref("");
      const rawUser = localStorage.getItem('auth_user');
      if (!rawUser) {
        return null;
      }else{
        const user = JSON.parse(rawUser);
        email.value = user.email;
      }
      
      return email.value;
    },

    async sendEmail(emailInput: string){
      await authServices.sendEmail(emailInput);
    },

    async verificationOTP(emailInput: string , otpInput: string){
      try {
        const data = await authServices.verificationOTP(emailInput,otpInput);
        this.isAuthenticated = true;
        this.token = data.token;
        localStorage.setItem("admin_token", data.admin_token);
        
        return {
          success: true,
        };
      } catch (error:any) {
          return {
            success: false,
            message:
              error.response?.data?.message ||'Invalid OTP',
          };
      }
    },

    async checkPermission() {
      try {
        const data = await authServices.checkPermission();

        this.rolesFlags = data.roles_flags;
        this.isAdmin = data.is_admin;
        this.permissionLoaded = true;

        return data;
      } catch (err) {
        this.rolesFlags = null;
        this.isAdmin = false;
        this.permissionLoaded = true;
        throw err;
      }
    },

    async checkAdminToken(){
      await authServices.checkAdminToken()
    },
    
    initializeAuth() {
      const token = localStorage.getItem("client_token");
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
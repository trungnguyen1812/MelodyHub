import { defineStore } from "pinia";
import AuthService from "@/services/auth.service";
import { data } from "autoprefixer";
import authServices from "@/services/auth.service";
import type {Partner} from '@/interfaces/partner.interface';
import {Role} from '@/modules/client/interfaces/users/role.interface';

import { ref} from "vue";

interface User {
  id: number;

  name: string;
  username: string;
  email: string;
  phone?: string;

  roles: Role[];
  role_display_name?: string;

  password?: string; 

  avatar_url?: string | null;

  date_of_birth?: string | null;
  gender?: "male" | "female" | "other" | null;
  bio?: string | null;

  country?: string | null;
  timezone?: string | null;

  status: "active" | "inactive" | "banned" | "pending";
  published_at?: string | null;

  play_count_last_24h?: number;
  play_count_last_7d?: number;
  play_count_last_30d?: number;
  trending_score?: number;


  seo_title?: string | null;
  seo_description?: string | null;

  has_used_trial: boolean;
  is_vip: boolean;
  vip_expires_at?: string | null;

  created_at?: string;
  updated_at?: string;
}

interface AuthState {
  isAuthenticated: boolean;
  user: User | null;
  token: string;
  partners: Partner[]
  rolesFlags: Record<string, boolean> | null;
  isAdmin: boolean;
  permissionLoaded: boolean;
}


export const getFullImageUrl = (path?: string | null): string | undefined => {
    if (!path || path.trim() === '') return undefined;
    
    if (path === 'null' || path === 'undefined') return undefined;

    if (path.startsWith('http')) return path;

    return `http://localhost:8000/storage/${path}`;
};

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
    partners: [] as Partner[],
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
        
        if (data.user) {
          this.user = data.user;
        }
        
        if (data.partner) {
          this.partners = [data.partner];
        } else if (data.partners) {
          this.partners = data.partners;
        }
        
        if (data.token) {
          this.token = data.token;
          localStorage.setItem("client_token", data.token);
          this.isAuthenticated = true;
        }
        
        this.permissionLoaded = true;

        return data;
      } catch (err) {
        this.rolesFlags = null;
        this.isAdmin = false;
        this.user = null;
        this.partners = [];
        this.permissionLoaded = true;
        throw err;
      }
    },

    async checkAdminToken(){
      await authServices.checkAdminToken()
    },

    async updateProfile(payload: {
      name?: string;
      phone?: string;
      date_of_birth?: string;
      gender?: string;
      bio?: string;
      avatar?: File | null;
    }) {
      const data = await authServices.updateProfile(payload);
      // Merge updated fields into local user state
      if (this.user) {
        this.user = { ...this.user, ...data.user ?? payload };
        localStorage.setItem('auth_user', JSON.stringify(this.user));
      }
      return data;
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
import { defineStore } from 'pinia';

export const useClientAuthStore = defineStore('clientAuth', {
  state: () => ({
    isAuthenticated: false,
    user: null as null | { name: string; email: string },
  }),
  actions: {
    setUser(userData: any) {
      this.isAuthenticated = true;
      this.user = userData;
    },
    logout() {
      localStorage.removeItem('auth_token');
      this.isAuthenticated = false;
      this.user = null;
    },
  },
});

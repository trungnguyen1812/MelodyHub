import { defineStore } from "pinia";
import { ref } from "vue";

export const useAuthStore = defineStore("auth", () => {
  const token = ref<string | null>(null);
  const user = ref<any>(null);

  function setToken(newToken: string) {
    token.value = newToken;
  }

  function setUser(data: any) {
    user.value = data;
  }

  function logout() {
    token.value = null;
    user.value = null;
  }

  return { token, user, setToken, setUser, logout };
});

<template>
  <div class="login-loading">
    <div class="loader"></div>
    <p>Signing in with Google...</p>
  </div>
</template>

<script setup lang="ts">
import { useAuthStore } from "@/store/authStore";
import { useRoute, useRouter } from "vue-router";
import { onMounted } from "vue";

const route = useRoute();
const router = useRouter();
const authStore = useAuthStore();

onMounted(() => {
  const token = route.query.token as string;

  if (token) {
    localStorage.setItem("client_token", token);
    authStore.isAuthenticated = true;
    router.push({ name: "Home" });
  } else {
    router.push({ name: "Login" });
  }
});
</script>

<style scoped>
.login-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  background: linear-gradient(to bottom, #081019, #0c191c);
  color: #ffffffcc;
  font-size: 1.2rem;
  font-family: 'Segoe UI', sans-serif;
  animation: fadeIn 1s ease-in-out;
}

.loader {
  border: 6px solid rgba(255, 255, 255, 0.1);
  border-top: 6px solid #ffffff;
  border-radius: 50%;
  width: 50px;
  height: 50px;
  margin-bottom: 20px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

@keyframes fadeIn {
  0% { opacity: 0; transform: scale(0.9); }
  100% { opacity: 1; transform: scale(1); }
}
</style>

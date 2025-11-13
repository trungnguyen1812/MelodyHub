import api from "axios";
import { useAuthStore } from "@/store/authStore";

const instance = api.create({
  baseURL: "http://localhost:8000/api",
  withCredentials: false,
});

instance.interceptors.request.use((config) => {
  // Lấy store trong hàm, khi Pinia đã active
  const authStore = useAuthStore(); 
  if (authStore.token) {
    config.headers.Authorization = `Bearer ${authStore.token}`;
  }
  return config;
});

export default instance;

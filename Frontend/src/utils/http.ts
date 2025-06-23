import axios, { type AxiosInstance } from "axios";
import type { HttpRequestConfig } from "@/types/http.type";
import { useAuthStore } from "@/stores/auth"; // Đường dẫn tới auth store của bạn

const http: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_URL || "http://localhost:8000",
  withCredentials: true,
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json",
  },
});

http.interceptors.request.use((config: HttpRequestConfig) => {
  // Lưu ý: Không thể sử dụng useAuthStore() trực tiếp ở đây vì Pinia chưa được khởi tạo
  const token = localStorage.getItem("pinia_adminAuth")
    ? JSON.parse(localStorage.getItem("pinia_adminAuth")!).token
    : null;

  if (token && config.headers) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  // Xử lý CSRF token như trước
  const xsrfToken = document.cookie
    .split("; ")
    .find((row) => row.startsWith("XSRF-TOKEN="))
    ?.split("=")[1];

  if (xsrfToken && config.headers) {
    config.headers["X-XSRF-TOKEN"] = decodeURIComponent(xsrfToken);
  }

  return config;
});

// ... giữ nguyên phần interceptors.response
http.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem("auth_token");
      window.location.href = "/admin/login";
    }
    return Promise.reject(error);
  }
);

export default http;

import axios, { type AxiosInstance } from "axios";
import type { HttpRequestConfig } from "@/types/http.type";

const http: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_URL || "http://localhost:8000",
  withCredentials: true,
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json",
  },
});

// Helper function để lấy token
const getAuthToken = (): string | null => {
  // Thử lấy từ localStorage đơn giản trước
  let token = localStorage.getItem("client_token");
  
  // Nếu không có, thử lấy từ pinia store
  if (!token) {
    try {
      const piniaAuth = localStorage.getItem("pinia_adminAuth");
      if (piniaAuth) {
        const parsed = JSON.parse(piniaAuth);
        token = parsed.token || null;
      }
    } catch (e) {
      console.error('Error parsing pinia auth:', e);
    }
  }
  
  return token;
};

// Helper function để clear tất cả auth data
const clearAllAuth = (): void => {
  localStorage.removeItem("client_token");
  localStorage.removeItem("pinia_adminAuth");
};

http.interceptors.request.use((config: HttpRequestConfig) => {
  console.log('Request interceptor - URL:', config.url); // Debug
  
  const token = getAuthToken();
  console.log('Token found:', !!token); // Debug (không log token thật)

  if (token && config.headers) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  // Xử lý CSRF token
  const xsrfToken = document.cookie
    .split("; ")
    .find((row) => row.startsWith("XSRF-TOKEN="))
    ?.split("=")[1];

  if (xsrfToken && config.headers) {
    config.headers["X-XSRF-TOKEN"] = decodeURIComponent(xsrfToken);
  }

  return config;
});

http.interceptors.response.use(
  (response) => {
    console.log('Response success for:', response.config.url); // Debug
    return response;
  },
  (error) => {
    console.error('Response error:', {
      url: error.config?.url,
      status: error.response?.status,
      message: error.message
    }); // Debug
    
    if (error.response?.status === 401) {
      console.log('401 error - clearing all auth data'); // Debug
      clearAllAuth();
      window.location.href = "/admin/login";
    }
    return Promise.reject(error);
  }
);

export default http;
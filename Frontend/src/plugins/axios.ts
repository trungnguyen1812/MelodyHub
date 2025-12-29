import axios, { InternalAxiosRequestConfig, AxiosResponse, AxiosError } from "axios";
import { useRouter } from "vue-router";

const api = axios.create({
  baseURL: "/api/client",
  headers: {
    "Content-Type": "application/json",
    "Accept": "application/json",
  },
  withCredentials: true,
});
 
api.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    const token = localStorage.getItem("client_token");
    
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

api.interceptors.response.use(
  (response: AxiosResponse) => response,
  (error: AxiosError) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('client_token');
      localStorage.removeItem('user_data');
      
      if (window.location.pathname.startsWith('/admin')) {
        window.location.href = '/admin/login';
      }
    } else if (error.response?.status === 403) {
      
      if (window.location.pathname.startsWith('/admin')) {
        window.location.href = '/403';
      }
    }
    return Promise.reject(error);
  }
);

export default api;

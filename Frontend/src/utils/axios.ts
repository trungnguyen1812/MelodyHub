import axios, { AxiosInstance } from 'axios';

// Tạo một instance riêng cho toàn bộ dự án
const api: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL + '/api', // URL Laravel Backend
  withCredentials: true, // Cho phép gửi cookie/session
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
});

// Xử lý lỗi toàn cục (tùy chọn)
api.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error('❌ API Error:', error.response?.data || error.message);
    return Promise.reject(error);
  }
);

export default api;

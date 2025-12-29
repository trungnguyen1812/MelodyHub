// adminApi.ts (admin)
import axios from 'axios';
const adminApi = axios.create({
  baseURL: 'http://localhost:8000/api/admin',
  headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
  withCredentials: true,
});
adminApi.interceptors.request.use(cfg => {
  const token = localStorage.getItem('admin_token');
  if (token) (cfg.headers as any).Authorization = `Bearer ${token}`;
  return cfg;
});
adminApi.interceptors.response.use(r => r, err => {
  if (err.response?.status === 401) {
    localStorage.removeItem('admin_token');
    localStorage.removeItem('admin_user');
    window.location.href = '/admin/login';
  } else if (err.response?.status === 403) {
    window.location.href = '/403';
  }
  return Promise.reject(err);
});
export default adminApi;

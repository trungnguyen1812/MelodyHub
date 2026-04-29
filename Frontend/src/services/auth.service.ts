import api from "@/plugins/axios";
import adminApi from '@/plugins/axios_admin';
import adminAuthApi from '@/plugins/axios_admin_auth';

class AuthService {
  async login(email: string, password: string) {
    const res = await api.post("/login", {
      email,
      password,
    });
    return res.data;
  }

  async logout() {
    const token = localStorage.getItem("admin_token") || localStorage.getItem("client_token");
    if (!token) {
      return;
    }
    const res = await api.post(
      "/logout",
      {}, 
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    return res.data;
  }

  async register(fullname: string , email:string , password:string){
    const token = localStorage.getItem("client_token");

    const res = await api.post(
      "/register",
      {
        fullname,
        email,
        password
      });
    return res.data;
  }

  async getProfile() {
    const res = await api.get("/profile");
    return res.data;
  }

  async sendEmail(email: string){
    const res = await adminAuthApi.post("/send-otp" , { 
      email,
      purpose: 'login'
    });
    return res.data;
  }

  async verificationOTP(email: string , otp: string){
    const res = await adminAuthApi.post("/verify-otp",{
      email,
      otp,
      purpose: 'login'
    });
    return res.data;
  }

  async checkPermission(){
    const response = await api.get('/check-permission');
    return response.data;
  }

  async checkAdminToken(){
    const res = await adminAuthApi.post("/check-token");
    return res.data;
  }

  async updateProfile(payload: {
    name?: string;
    phone?: string;
    date_of_birth?: string;
    gender?: string;
    bio?: string;
    avatar?: File | null;
  }) {
    const formData = new FormData();
    if (payload.name !== undefined)          formData.append('name', payload.name);
    if (payload.phone !== undefined)         formData.append('phone', payload.phone);
    if (payload.date_of_birth !== undefined) formData.append('date_of_birth', payload.date_of_birth);
    if (payload.gender !== undefined)        formData.append('gender', payload.gender);
    if (payload.bio !== undefined)           formData.append('bio', payload.bio);
    if (payload.avatar)                      formData.append('avatar', payload.avatar);

    const res = await api.post("/user/profile", formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return res.data;
  }

  async changePassword(payload: {
    current_password: string;
    new_password: string;
    new_password_confirmation: string;
  }) {
    const res = await api.post("/user/change-password", payload);
    return res.data;
  }

  async forgotPassword(email: string) {
    const res = await api.post("/forgot-password", { email });
    return res.data;
  }
}

export default new AuthService();

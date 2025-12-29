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
}

export default new AuthService();

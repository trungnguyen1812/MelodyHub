import api from "@/plugins/axios";

class AuthService {
  async login(email: string, password: string) {
    const res = await api.post("/login", {
      email,
      password,
    });
    return res.data;
  }

  async logout() {
    const token = localStorage.getItem("auth_token");
    
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
    const token = localStorage.getItem("auth_token");

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
}

export default new AuthService();

import api from "@/plugins/axios";
import adminApi from '@/plugins/axios_admin';
import adminAuthApi from '@/plugins/axios_admin_auth';

class UserService {
    async getAllUser() {
        const res = await adminApi.get("/list-user");
        return res.data;
    }
}

export default new UserService();
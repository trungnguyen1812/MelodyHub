import api from "@/plugins/axios";
import adminApi from '@/plugins/axios_admin';
import adminAuthApi from '@/plugins/axios_admin_auth';

import {UserInterface} from '@/modules/admin/interfaces/users/user.interface';
import type { CreateUserPayload } from "@/modules/admin/interfaces/users/create-user.payload";


class UserService {
    async getAllUser() {
        const res = await adminApi.get("/users");
        return res.data;
    }
    async addUser(payload: CreateUserPayload){
        return adminApi.post('/users/add', payload, {
            headers: {
            'Content-Type': 'multipart/form-data'
            }
        });
    }
    async searchUser(keyword: string){
        const res = await adminApi.post("/users/search" ,{
            q:keyword
        }); 
        return res.data;
    }
    async detailUser(id: number) {
        return await adminApi.get(`/users/${id}`);
    }
    async deleteUser(id: number){
        return await adminApi.post(`/users/delete/${id}`); 
    }
    async updateUser(id: number, payload: CreateUserPayload) {
        const formData = new FormData();
       
        Object.keys(payload).forEach(key => {
            if (key !== 'avatar' && payload[key as keyof CreateUserPayload]) {
                formData.append(key, String(payload[key as keyof CreateUserPayload]));
            }
        });
        
        if (payload.avatar instanceof File) {   
            formData.append('avatar', payload.avatar);
        }
        
        return await adminApi.post(`/users/update/${id}`, formData ,{
            headers: {
            'Content-Type': undefined,
            },
        }); 
    }
    async getUserStatistics(){
        const res = await adminApi.get("/users/statistics");
        return res.data;
    }
}

export default new UserService();
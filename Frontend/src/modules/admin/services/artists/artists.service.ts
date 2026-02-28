import api from "@/plugins/axios";
import adminApi from '@/plugins/axios_admin';
import adminAuthApi from '@/plugins/axios_admin_auth';


class ArtistService {
    async getAllArtist() {
        const res = await adminApi.get("/list-artists");
        return res.data;
    }
    // async addUser(payload: CreateUserPayload){
    //     return adminApi.post("/add-user", payload);
    // }
    // async searchUser(keyword: string){
    //     const res = await adminApi.post("/search-user" ,{
    //         q:keyword
    //     }); 
    //     return res.data;
    // }
    // async detailUser(id: number) {
    //     return adminApi.get(`/users/${id}`);
    // }
    // async deleteUser(id: number){
    //     return await adminApi.post(`/user/delete/${id}`); 
    // }
    // async updateUser(id: number, payload: CreateUserPayload) {
    //     const formData = new FormData();
       
    //     Object.keys(payload).forEach(key => {
    //         if (key !== 'avatar' && payload[key as keyof CreateUserPayload]) {
    //             formData.append(key, String(payload[key as keyof CreateUserPayload]));
    //         }
    //     });
        
    //     if (payload.avatar instanceof File) {   
    //         formData.append('avatar', payload.avatar);
    //     }
        
    //     return await adminApi.post(`/users/update/${id}`, formData ,{
    //         headers: {
    //         'Content-Type': undefined,
    //         },
    //     }); 
    // } 
}

export default new ArtistService();
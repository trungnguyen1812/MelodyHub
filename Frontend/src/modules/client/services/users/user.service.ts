import api from "@/plugins/axios";
import adminApi from '@/plugins/axios_admin';
import adminAuthApi from '@/plugins/axios_admin_auth';
// import interface
import {CreateQRPayload ,CreateTopUpQRPayload} from '@/modules/client/interfaces/users/CreateQRPayload';

export interface CreateQRResponse {
  qr_url: string;
  payment_id: number;
  content: string;
}

export interface SubscriptionResponse {
  status: 'active' | 'expired';
  subscription_id?: number;
  starts_at?: string;
  ends_at?: string;
  plan?: {
    id: number;
    name: string;
    display_name: string;
    duration_days: number;
  };
}

export interface PaymentStatusResponse {
  status: 'pending' | 'processing' | 'completed' | 'failed' | 'cancelled';
}

class UserService {
    async getAllSub(){
        const res = await api.get("/showsubcription");
        return res.data;
    }
    async create_QR(payload: CreateQRPayload){  
        return await api.post("/payment/create-qr",payload);
    }
    async create_QR_TopUp(payload: CreateTopUpQRPayload){  
        return await api.post("/payment/create-topup-qr",payload);
    }
    async checkStatus(paymentId: number): Promise<PaymentStatusResponse> {
        const { data } = await api.get(`/payment/${paymentId}/status`);
        return data;
    }
    async checkSubscription(){
        const  data = await api.get(`/me/subscription`);
        return data;
    } 
    async checkTopUpStatus(){
        const data = await api.get('/payments/check-status')
        return data;
    } 
    async detailUser(id: number) {
        return await api.get(`/users/${id}`);
    }
}

export default new UserService();
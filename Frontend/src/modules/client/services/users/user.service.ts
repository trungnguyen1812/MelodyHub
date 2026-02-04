import api from "@/plugins/axios";
import adminApi from '@/plugins/axios_admin';
import adminAuthApi from '@/plugins/axios_admin_auth';
// import interface
import {CreateQRPayload } from '@/modules/client/interfaces/users/CreateQRPayload';

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
    async checkStatus(paymentId: number): Promise<PaymentStatusResponse> {
        const { data } = await api.get(`/payment/${paymentId}/status`);
        return data;
    }
    async checkSubscription(){
        const  data = await api.get(`/me/subscription`);
        return data;
    } 
}

export default new UserService();
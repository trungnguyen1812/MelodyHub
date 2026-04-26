// @/modules/client/stores/users/UserStore.ts
import userService from "@/modules/client/services/users/user.service";
import { SubscriptionPlan } from '@/modules/client/interfaces/users/SubscriptionPlan';
import { CreateQRPayload , CreateTopUpQRPayload} from '@/modules/client/interfaces/users/CreateQRPayload';
import { defineStore } from 'pinia';
import router from "@/modules/router";
import { useNotificationStore } from "@/store/notificationStore";
import { Subscription } from '@/modules/client/interfaces/users/Subscription';
import {UserInterface} from '@/modules/client/interfaces/users/user.interface';




export const useUserStore = defineStore('client_user', {
  state: () => ({
    profile: null as UserInterface | null,
    subscriptionPlans: [] as SubscriptionPlan[],
    userSubscriptions: [] as any[],
    loading: false,
    status: 'idle' as 'idle' | 'pending' | 'processing' | 'completed' | 'failed' | 'cancelled',
    error: null as string | null,

    qrUrl: '',
    transferContent: '',
    pollingTimer: null as number | null,
    checkingInterval: null as number | null,
    paymentId: null as number | null,


    subscription: null as Subscription | null,
    subscriptionLoaded: false
  }),


  getters: {
    freePlan: (state) => state.subscriptionPlans.find(plan => plan.name === 'free'),

    premiumPlans: (state) => state.subscriptionPlans.filter(plan => plan.price > 0),

    sortedPlans: (state) => {
      return [...state.subscriptionPlans].sort((a, b) => a.sort_order - b.sort_order);
    },
    isVip(state): boolean {
      if (!state.subscription) return false;
      return ['active', 'trial'].includes(state.subscription.status);
    }
  },

  actions: {
    
    async fetchSubscriptionPlans() {
      this.loading = true;
      this.error = null;

      try {
        const response = await userService.getAllSub();
        this.qrUrl = response.qr_url;
        this.transferContent = response.content;
        this.paymentId = response.payment_id;
        this.status = 'pending';
        this.startPolling();
        let plansData: any[] = [];

        if (Array.isArray(response)) {
          plansData = response;
        } else if (response && typeof response === 'object') {
          if (response.data && Array.isArray(response.data)) {
            plansData = response.data;
          } else if (response.plans && Array.isArray(response.plans)) {
            plansData = response.plans;
          } else if (response.subscriptions && Array.isArray(response.subscriptions)) {
            plansData = response.subscriptions;
          } else {
            plansData = Object.values(response);
          }
        } else {
          throw new Error('Invalid response format');
        }


        this.subscriptionPlans = plansData.map((plan: any) => ({
          id: plan.id || 0,
          name: plan.name || '',
          display_name: plan.display_name || plan.name || '',
          description: plan.description || null,
          price: Number(plan.price) || 0,
          original_price: plan.original_price ? Number(plan.original_price) : null,
          currency: plan.currency || 'VND',
          duration_days: Number(plan.duration_days) || 0,
          trial_days: Number(plan.trial_days) || 0,
          max_playlists: Number(plan.max_playlists) || 0,
          max_songs_per_playlist: Number(plan.max_songs_per_playlist) || 0,
          max_offline_downloads: Number(plan.max_offline_downloads) || 0,
          max_devices: Number(plan.max_devices) || 1,
          can_download: Boolean(plan.can_download),
          audio_quality: plan.audio_quality || 'standard',
          ads_free: Boolean(plan.ads_free),
          can_skip_unlimited: Boolean(plan.can_skip_unlimited),
          can_create_collaborative_playlist: Boolean(plan.can_create_collaborative_playlist),
          priority_support: Boolean(plan.priority_support),
          early_access: Boolean(plan.early_access),
          is_active: Boolean(plan.is_active !== false),
          is_featured: Boolean(plan.is_featured),
          sort_order: Number(plan.sort_order) || 999,
          created_at: plan.created_at,
          updated_at: plan.updated_at
        } as SubscriptionPlan));


        if (this.subscriptionPlans.length === 0) {
          console.warn('No subscription plans found in response');
          console.log('Full response structure:', JSON.stringify(response, null, 2));
        }

      } catch (err: any) {
        this.error = err?.response?.data?.message || err.message || 'Fetch subscription failed';
        console.error('Error fetching subscription plans:', err);
      } finally {
        this.loading = false;
      }
    },
    async fetchCreateQR(payload: CreateQRPayload) {
      this.loading = true
      this.error = null

      const response = await userService.create_QR(payload);
      return response.data;
    },
    async fetchCreateQRToUp(payload: CreateTopUpQRPayload) {
      this.loading = true
      this.error = null

      const response = await userService.create_QR_TopUp(payload);
      return response.data;
    },
    async fetchSubscriptionStatus() {
      this.subscriptionLoaded = false;
      try {
        const res = await userService.checkSubscription();
        this.subscription = res.data;
      } catch (e) {
        this.subscription = null;
      } finally {
        this.subscriptionLoaded = true;
      }
    },
    async fetchShow(id :number){
        return await userService.detailUser(id);
    },
    startCheckSubscription() {
      if (this.checkingInterval) return;
      const notificationStore = useNotificationStore();
      this.checkingInterval = window.setInterval(async () => {
        try {
          const { data } = await userService.checkSubscription();
          if (data.status === 'active') {
            this.subscription = data;
            this.stopCheckSubscription();
            notificationStore.notify('Payment successful', 'success')
            router.push('/');
          }
        } catch (e) {
        }
      }, 3000);
    },
    startCheckTopUp(onSuccess: (balance: number) => void) {
      if (this.checkingInterval) return;
      const notificationStore = useNotificationStore();

      this.checkingInterval = window.setInterval(async () => {
        try {
          const { data } = await userService.checkTopUpStatus();

          if (data.status === 'completed') {
            this.stopCheckSubscription();
            notificationStore.notify('Top up successful!', 'success');
            onSuccess(parseFloat(data.wallet_balance));
          } else if (data.status === 'failed') {
            this.stopCheckSubscription();
            notificationStore.notify('Payment failed. Please try again.', 'error');
          }
        } catch (e) {
        }
      }, 3000);
    },
    stopCheckSubscription() {
      if (this.checkingInterval) {
        clearInterval(this.checkingInterval);
        this.checkingInterval = null;
      }
    },
    startPolling() {
      if (!this.paymentId) return;

      this.stopPolling();

      this.pollingTimer = window.setInterval(async () => {
        try {
          const res = await userService.checkStatus(this.paymentId!);
          this.status = res.status;

          if (res.status === 'completed') {
            this.stopPolling();
          }

          if (res.status === 'failed' || res.status === 'cancelled') {
            this.stopPolling();
          }
        } catch (err) {
          console.error('Polling error', err);
        }
      }, 3000);
    },
    stopPolling() {
      if (this.pollingTimer) {
        clearInterval(this.pollingTimer);
        this.pollingTimer = null;
      }
    },
    resetSubscription() {
      this.stopCheckSubscription();
      this.subscription = null;
      this.subscriptionLoaded = false;
    },

    reset() {
      this.stopPolling();
      this.qrUrl = '';
      this.transferContent = '';
      this.paymentId = null;
      this.status = 'idle';
    },
  }
});
import { SubscriptionPlan } from '@/modules/client/interfaces/users/SubscriptionPlan';

export type SubscriptionStatus =
  | 'active'
  | 'expired'
  | 'cancelled'
  | 'suspended'
  | 'trial';

export interface Subscription {
  subscription_id: number;

  status: SubscriptionStatus;

  starts_at: string | null;
  ends_at: string | null;

  plan: SubscriptionPlan;
}


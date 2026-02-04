<?php

namespace App\Http\Controllers\Api\Payment;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


class UserSubscriptionController extends Controller
{
    public function me(Request $request)
    {
        $user = $request->user();
       
        $subscription = $user->activeSubscription()
            ->with('subscription_plan')
            ->first();

        if (!$subscription) {
            return response()->json([
                'status' => 'expired'
            ]);
        }
        return response()->json([
            'status' => $subscription->status,
            'subscription_id' => $subscription->id,
            'starts_at' => $subscription->starts_at,
            'ends_at' => $subscription->ends_at,
            'plan' => [
                'id' => $subscription->subscription_plan->id,
                'name' => $subscription->subscription_plan->name,
                'display_name' => $subscription->subscription_plan->display_name,
                'duration_days' => $subscription->subscription_plan->duration_days,
            ]

        ]);
    }
}

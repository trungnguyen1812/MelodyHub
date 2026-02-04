<?php

namespace App\Http\Controllers\Api\Payment;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use App\Models\SubscriptionPlan;
use App\Models\User;
use App\Models\UserSubscription;
use App\Models\Role;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PaymentController extends Controller
{
    public function create_QR(Request $request)
    {
        $user = Auth::user();

        $request->validate([
            'subscription_plan_id' => 'required|exists:subscription_plans,id',
        ]);

        $plan = SubscriptionPlan::findOrFail($request->subscription_plan_id);

        $payment = Payment::where('user_id', $user->id)
            ->where('payment_type', 'subscription')
            ->where('status', 'pending')
            ->first();

        if ($payment) {
            $payment->update([
                'subscription_plan_id' => $plan->id,
                'amount' => $plan->price,
                'currency' => 'VND',
            ]);
        } else {    
            $payment = Payment::create([
                'user_id' => $user->id,
                'subscription_plan_id' => $plan->id,
                'payment_type' => 'subscription',
                'amount' => $plan->price,
                'currency' => 'VND',
                'status' => 'pending',
            ]);
        }


        $prefix = "SEVQR";
        $transferContent = $prefix . ' SEPAY ' . $payment->id;

        $payment->update(['transfer_content' => $transferContent]);

        Log::info('QR created', [
            'payment_id' => $payment->id,
            'user_id' => $user->id,
            'amount' => $payment->amount,
        ]);

        $params = [
            'acc' => config('services.sepay.bank_account'),
            'bank' => config('services.sepay.bank_provider'),
            'amount' => (int)$payment->amount,
            'des' => $transferContent,
            'template' => 'compact',
        ];

        $qrUrl = "https://qr.sepay.vn/img?" . http_build_query($params);

        return response()->json([
            'qr_url' => $qrUrl,
            'payment_id' => $payment->id,
            'content' => $transferContent,
            'amount' => $payment->amount,
            'bank_account' => config('services.sepay.bank_account'),
            'bank_name' => config('services.sepay.bank_provider'),
        ]);
    }

    private function verifySePay(Request $request): bool
    {
        $authHeader = $request->header('Authorization');

        if (!$authHeader) {
            Log::info('Webhook: No auth header, bypassing');
            return true;
        }

        if ($authHeader && str_starts_with($authHeader, 'Apikey')) {
            $prefixLength = str_starts_with($authHeader, 'Apikey ') ? 7 : 6;
            $receivedApiKey = trim(substr($authHeader, $prefixLength));
            $storedApiKey = config('services.sepay.webhook_secret') ?: config('services.sepay.api_token');

            if (hash_equals($storedApiKey ?? '', $receivedApiKey)) {
                Log::info('Webhook: API Key auth success');
                return true;
            }
        }

        $signature = $request->header('X-Sepay-Signature') ?? $request->header('X-Signature');

        if ($signature) {
            $secret = config('services.sepay.webhook_secret');

            if (empty($secret)) {
                Log::error('Webhook: Secret not configured');
                return false;
            }

            $rawBody = $request->getContent();
            $expectedSignature = hash_hmac('sha256', $rawBody, $secret);

            if (hash_equals($expectedSignature, $signature)) {
                Log::info('Webhook: Signature auth success');
                return true;
            }
        }

        Log::error('Webhook: Authentication failed');
        return false;
    }

    public function webhook(Request $request)
    {
        Log::info('SePay webhook received');

        $bypass = config('services.sepay.bypass_verification', false);

        if ($bypass) {
            Log::info('Webhook: Bypass mode enabled');
        } elseif (!$this->verifySePay($request)) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized'
            ], 401);
        }

        $content = $request->input('content')
            ?? $request->input('transferContent')
            ?? $request->input('description');

        if (!$content) {
            Log::error('Webhook: Missing content');
            return response()->json([
                'success' => false,
                'message' => 'Missing transfer content'
            ], 400);
        }

        $transferContent = null;
        if (preg_match('/(SEVQR\s+SEPAY\s+\d+)/', $content, $matches)) {
            $transferContent = $matches[1];
        }

        if (!$transferContent) {
            Log::error('Webhook: Invalid content format', ['content' => $content]);
            return response()->json([
                'success' => false,
                'message' => 'Invalid transfer content format'
            ], 400);
        }

        $payment = Payment::where('transfer_content', $transferContent)
            ->whereIn('status', ['pending', 'processing'])
            ->first();

        if (!$payment) {
            Log::error('Webhook: Payment not found', ['transfer_content' => $transferContent]);
            return response()->json([
                'success' => false,
                'message' => 'Payment not found'
            ], 404);
        }

        Log::info('Webhook: Processing payment', [
            'payment_id' => $payment->id,
            'user_id' => $payment->user_id,
            'amount' => $payment->amount
        ]);

        // check amount of money
        $receivedAmount = $request->input('transferAmount') ?? $request->input('amount');
        if ($receivedAmount && abs($receivedAmount - $payment->amount) > 0.01) {
            Log::warning('Webhook: Amount mismatch', [
                'expected' => $payment->amount,
                'received' => $receivedAmount
            ]);
        }

        $status = strtolower($request->input('status', 'success'));

        if (in_array($status, ['success', 'completed', 'successful'])) {
            DB::transaction(function () use ($payment, $request) {
                $payment->update([
                    'status' => 'completed',
                    'paid_at' => now(),
                    'transaction_id' => $request->input('id'),
                    'metadata' => $request->all(),
                ]);

                $this->upgradeUser($payment);
            });

            Log::info('Webhook: Payment completed', [
                'payment_id' => $payment->id,
                'user_id' => $payment->user_id
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Payment processed successfully'
            ]);
        }

        if (in_array($status, ['failed', 'cancelled', 'canceled', 'expired', 'rejected'])) {
            $payment->update([
                'status' => 'failed',
                'failed_at' => now(),
                'metadata' => $request->all(),
            ]);

            Log::info('Webhook: Payment failed', ['status' => $status]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Webhook received'
        ]);
    }

    private function upgradeUser(Payment $payment): void
    {
        $user = User::findOrFail($payment->user_id);
        $plan = $payment->subscriptionPlan;
        Log::info('PLAN DEBUG', [
            'plan' => $payment->subscriptionPlan
        ]);

        if (!$plan) {
            Log::error('Subscription plan not found for payment', [
                'payment_id' => $payment->id
            ]);
            return;
        }

        Log::info('Starting upgrade process', [
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'plan_role_name' => $plan->role_name,
            'payment_id' => $payment->id
        ]);

        $currentRole = DB::table('user_roles')
            ->join('roles', 'user_roles.role_id', '=', 'roles.id')
            ->where('user_roles.user_id', $user->id)
            ->where('user_roles.is_primary', 1)
            ->select('roles.name', 'roles.id', 'user_roles.expires_at')
            ->first();

        Log::info('Current role', [
            'current_role' => $currentRole?->name,
            'current_role_id' => $currentRole?->id
        ]);

        if (
            $currentRole?->name === 'user_vip_yearly' &&
            $plan->role_name === 'user_vip_monthly'
        ) {
            Log::info('Skipping downgrade from yearly to monthly');
            return;
        }

        $newRole = Role::where('name', $plan->role_name)->first();
        log::info(' role update new ');
        log::info($newRole);
        if (!$newRole) {
            Log::error('Role not found for plan', [
                'plan_id' => $plan->id,
                'role_name' => $plan->role_name,
                'available_roles' => Role::pluck('name')->toArray()
            ]);
            return;
        }

        Log::info('New role found', [
            'new_role_id' => $newRole->id,
            'new_role_name' => $newRole->name
        ]);

        $currentSubscription = UserSubscription::where('user_id', $user->id)
            ->where('status', 'active')
            ->first();

        $startsAt = now();

        if (
            $currentSubscription !== null &&
            $currentSubscription->plan_id === $plan->id &&
            $currentSubscription->ends_at !== null &&
            $currentSubscription->ends_at->greaterThan(now())
        ) {
            $startsAt = $currentSubscription->ends_at;
        }


        $endsAt = $startsAt->copy()->addDays($plan->duration_days);

        DB::transaction(function () use ($user, $plan, $newRole, $startsAt, $endsAt) {
            UserSubscription::where('user_id', $user->id)
                ->where('status', 'active')
                ->update(['status' => 'expired']);

            UserSubscription::create([
                'user_id' => $user->id,
                'plan_id' => $plan->id,
                'starts_at' => $startsAt,
                'ends_at' => $endsAt,
                'status' => 'active',
            ]);

            DB::table('user_roles')
                ->where('user_id', $user->id)
                ->where('is_primary', 1)
                ->update(['is_primary' => 0]);

            Log::info('Removed primary flag from old roles', [
                'user_id' => $user->id
            ]);

            $existingRole = DB::table('user_roles')
                ->where('user_id', $user->id)
                ->where('role_id', $newRole->id)
                ->first();

            if ($existingRole) {
                DB::table('user_roles')
                    ->where('user_id', $user->id)
                    ->where('role_id', $newRole->id)
                    ->update([
                        'is_primary' => 1,
                        'expires_at' => $endsAt,
                        'assigned_at' => now()
                    ]);
                
                Log::info('Updated existing role to primary', [
                    'user_id' => $user->id,
                    'role_id' => $newRole->id
                ]);
            } else {
                DB::table('user_roles')->insert([
                    'user_id' => $user->id,
                    'role_id' => $newRole->id,
                    'is_primary' => 1,
                    'expires_at' => $endsAt,
                    'assigned_at' => now(),
                    'assigned_by' => null, 
                ]);
                
                Log::info('Created new user role', [
                    'user_id' => $user->id,
                    'role_id' => $newRole->id
                ]);
            }
        });

        $updatedRole = DB::table('user_roles')
            ->join('roles', 'user_roles.role_id', '=', 'roles.id')
            ->where('user_roles.user_id', $user->id)
            ->where('user_roles.is_primary', 1)
            ->select('roles.name', 'user_roles.expires_at')
            ->first();

        Log::info('User upgraded successfully', [
            'user_id' => $user->id,
            'old_role' => $currentRole?->name,
            'new_role' => $updatedRole?->name,
            'plan_role_name' => $plan->role_name,
            'ends_at' => $endsAt,
            'verified_role' => $updatedRole?->name,
            'verified_expires_at' => $updatedRole?->expires_at
        ]);
    }

}

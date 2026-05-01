<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\SubscriptionPlan;
use Illuminate\Http\Request;

class SettingSubscriptionController extends Controller
{
    public function index()
    {
        $plans = SubscriptionPlan::withCount('user_subscriptions')
            ->orderBy('sort_order')
            ->get();

        return response()->json(['success' => true, 'data' => $plans]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name'                            => 'required|string|max:100|unique:subscription_plans,name',
            'display_name'                    => 'required|string|max:255',
            'description'                     => 'nullable|string',
            'price'                           => 'required|numeric|min:0',
            'original_price'                  => 'nullable|numeric|min:0',
            'currency'                        => 'required|string|max:10',
            'duration_days'                   => 'required|integer|min:1',
            'trial_days'                      => 'integer|min:0',
            'max_playlists'                   => 'nullable|integer|min:0',
            'max_songs_per_playlist'          => 'nullable|integer|min:0',
            'max_offline_downloads'           => 'nullable|integer|min:0',
            'max_devices'                     => 'nullable|integer|min:1',
            'can_download'                    => 'boolean',
            'audio_quality'                   => 'required|in:standard,high,lossless',
            'ads_free'                        => 'boolean',
            'can_skip_unlimited'              => 'boolean',
            'can_create_collaborative_playlist' => 'boolean',
            'priority_support'                => 'boolean',
            'early_access'                    => 'boolean',
            'is_active'                       => 'boolean',
            'is_featured'                     => 'boolean',
            'sort_order'                      => 'integer|min:0',
        ]);

        $plan = SubscriptionPlan::create($data);

        return response()->json(['success' => true, 'data' => $plan], 201);
    }

    public function show($id)
    {
        $plan = SubscriptionPlan::withCount('user_subscriptions')->findOrFail($id);
        return response()->json(['success' => true, 'data' => $plan]);
    }

    public function update(Request $request, $id)
    {
        $plan = SubscriptionPlan::findOrFail($id);

        $data = $request->validate([
            'name'                            => 'sometimes|string|max:100|unique:subscription_plans,name,' . $id,
            'display_name'                    => 'sometimes|string|max:255',
            'description'                     => 'nullable|string',
            'price'                           => 'sometimes|numeric|min:0',
            'original_price'                  => 'nullable|numeric|min:0',
            'currency'                        => 'sometimes|string|max:10',
            'duration_days'                   => 'sometimes|integer|min:1',
            'trial_days'                      => 'integer|min:0',
            'max_playlists'                   => 'nullable|integer|min:0',
            'max_songs_per_playlist'          => 'nullable|integer|min:0',
            'max_offline_downloads'           => 'nullable|integer|min:0',
            'max_devices'                     => 'nullable|integer|min:1',
            'can_download'                    => 'boolean',
            'audio_quality'                   => 'sometimes|in:standard,high,lossless',
            'ads_free'                        => 'boolean',
            'can_skip_unlimited'              => 'boolean',
            'can_create_collaborative_playlist' => 'boolean',
            'priority_support'                => 'boolean',
            'early_access'                    => 'boolean',
            'is_active'                       => 'boolean',
            'is_featured'                     => 'boolean',
            'sort_order'                      => 'integer|min:0',
        ]);

        $plan->update($data);

        return response()->json(['success' => true, 'data' => $plan]);
    }

    public function destroy($id)
    {
        $plan = SubscriptionPlan::withCount('user_subscriptions')->findOrFail($id);

        if ($plan->user_subscriptions_count > 0) {
            return response()->json([
                'success' => false,
                'message' => "Cannot delete: {$plan->user_subscriptions_count} active subscription(s) using this plan."
            ], 422);
        }

        $plan->delete();
        return response()->json(['success' => true, 'message' => 'Plan deleted.']);
    }

    public function toggleActive($id)
    {
        $plan = SubscriptionPlan::findOrFail($id);
        $plan->update(['is_active' => !$plan->is_active]);
        return response()->json(['success' => true, 'data' => $plan]);
    }
}

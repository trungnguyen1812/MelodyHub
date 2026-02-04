<?php
// app/Http/Controllers/PaymentController.php
namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\SubscriptionPlan;
use Illuminate\Http\Request;

class SubscriptionController extends Controller
{
    public function getAllSubscription() {
        $subscriptions = SubscriptionPlan::where('is_active', true)
        ->orderBy('sort_order')
        ->get();

        return response()->json([
            'data' => $subscriptions
        ]);
   }
}
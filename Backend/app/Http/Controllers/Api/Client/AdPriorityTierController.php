<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\AdPriorityTier;
use Illuminate\Http\JsonResponse;

class AdPriorityTierController extends Controller
{
    /**
     * Return all active priority tiers — used by partner ad wizard.
     */
    public function index(): JsonResponse
    {
        $tiers = AdPriorityTier::active()->orderBy('sort_order')->get();
        return response()->json(['success' => true, 'data' => $tiers]);
    }
}

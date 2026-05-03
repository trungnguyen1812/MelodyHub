<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\AdPriorityTier;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SettingAdPriorityTierController extends Controller
{
    public function index(): JsonResponse
    {
        $tiers = AdPriorityTier::orderBy('sort_order')->get();
        return response()->json(['success' => true, 'data' => $tiers]);
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'value'        => 'required|string|max:50|unique:ad_priority_tiers,value',
            'label'        => 'required|string|max:100',
            'color'        => 'required|string|max:20',
            'min_cpm'      => 'required|numeric|min:0.000001',
            'min_cpc'      => 'required|numeric|min:0.000001',
            'max_priority' => 'required|integer|min:1|max:1000',
            'description'  => 'nullable|string|max:255',
            'sort_order'   => 'integer|min:0',
            'is_active'    => 'boolean',
        ]);

        $tier = AdPriorityTier::create($data);
        return response()->json(['success' => true, 'data' => $tier], 201);
    }

    public function show($id): JsonResponse
    {
        $tier = AdPriorityTier::findOrFail($id);
        return response()->json(['success' => true, 'data' => $tier]);
    }

    public function update(Request $request, $id): JsonResponse
    {
        $tier = AdPriorityTier::findOrFail($id);

        $data = $request->validate([
            'value'        => 'sometimes|string|max:50|unique:ad_priority_tiers,value,' . $id,
            'label'        => 'sometimes|string|max:100',
            'color'        => 'sometimes|string|max:20',
            'min_cpm'      => 'sometimes|numeric|min:0.000001',
            'min_cpc'      => 'sometimes|numeric|min:0.000001',
            'max_priority' => 'sometimes|integer|min:1|max:1000',
            'description'  => 'nullable|string|max:255',
            'sort_order'   => 'integer|min:0',
            'is_active'    => 'boolean',
        ]);

        $tier->update($data);
        return response()->json(['success' => true, 'data' => $tier]);
    }

    public function destroy($id): JsonResponse
    {
        $tier = AdPriorityTier::findOrFail($id);
        $tier->delete();
        return response()->json(['success' => true, 'message' => 'Tier deleted']);
    }

    public function toggleActive($id): JsonResponse
    {
        $tier = AdPriorityTier::findOrFail($id);
        $tier->update(['is_active' => !$tier->is_active]);
        return response()->json(['success' => true, 'data' => $tier]);
    }
}

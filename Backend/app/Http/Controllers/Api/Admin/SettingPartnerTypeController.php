<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\PartnerType;
use Illuminate\Http\Request;

class SettingPartnerTypeController extends Controller
{
    public function index()
    {
        $types = PartnerType::withCount('partners')->orderBy('name')->get();
        return response()->json(['success' => true, 'data' => $types]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'code'                      => 'required|string|max:100|unique:partner_types,code',
            'name'                      => 'required|string|max:255',
            'description'               => 'nullable|string',
            'can_upload_songs'          => 'boolean',
            'can_manage_artists'        => 'boolean',
            'can_book_ads'              => 'boolean',
            'default_revenue_share'     => 'required|numeric|min:0|max:100',
            'default_payment_frequency' => 'required|in:monthly,quarterly,yearly',
            'default_payment_threshold' => 'required|numeric|min:0',
            'is_active'                 => 'boolean',
        ]);

        $type = PartnerType::create($data);

        return response()->json(['success' => true, 'data' => $type], 201);
    }

    public function show($id)
    {
        $type = PartnerType::withCount('partners')->findOrFail($id);
        return response()->json(['success' => true, 'data' => $type]);
    }

    public function update(Request $request, $id)
    {
        $type = PartnerType::findOrFail($id);

        $data = $request->validate([
            'code'                      => 'sometimes|string|max:100|unique:partner_types,code,' . $id,
            'name'                      => 'sometimes|string|max:255',
            'description'               => 'nullable|string',
            'can_upload_songs'          => 'boolean',
            'can_manage_artists'        => 'boolean',
            'can_book_ads'              => 'boolean',
            'default_revenue_share'     => 'sometimes|numeric|min:0|max:100',
            'default_payment_frequency' => 'sometimes|in:monthly,quarterly,yearly',
            'default_payment_threshold' => 'sometimes|numeric|min:0',
            'is_active'                 => 'boolean',
        ]);

        $type->update($data);

        return response()->json(['success' => true, 'data' => $type]);
    }

    public function destroy($id)
    {
        $type = PartnerType::withCount('partners')->findOrFail($id);

        if ($type->partners_count > 0) {
            return response()->json([
                'success' => false,
                'message' => "Cannot delete: {$type->partners_count} partner(s) are using this type."
            ], 422);
        }

        $type->delete();
        return response()->json(['success' => true, 'message' => 'Partner type deleted.']);
    }

    public function toggleActive($id)
    {
        $type = PartnerType::findOrFail($id);
        $type->update(['is_active' => !$type->is_active]);
        return response()->json(['success' => true, 'data' => $type]);
    }
}

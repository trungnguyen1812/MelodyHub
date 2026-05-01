<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Role;
use App\Models\Permission;
use Illuminate\Http\Request;

class SettingRoleController extends Controller
{
    public function index()
    {
        $roles = Role::withCount('users')
            ->with('permissions:id,name,display_name,module_id')
            ->orderBy('level')
            ->get();

        return response()->json(['success' => true, 'data' => $roles]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name'         => 'required|string|max:100|unique:roles,name',
            'display_name' => 'required|string|max:255',
            'description'  => 'nullable|string',
            'level'        => 'required|integer|min:0',
            'is_system'    => 'boolean',
            'permissions'  => 'nullable|array',
            'permissions.*'=> 'integer|exists:permissions,id',
        ]);

        $role = Role::create([
            'name'         => $data['name'],
            'display_name' => $data['display_name'],
            'description'  => $data['description'] ?? null,
            'level'        => $data['level'],
            'is_system'    => $data['is_system'] ?? false,
        ]);

        if (!empty($data['permissions'])) {
            $role->permissions()->sync($data['permissions']);
        }

        $role->load('permissions:id,name,display_name,module_id');
        return response()->json(['success' => true, 'data' => $role], 201);
    }

    public function show($id)
    {
        $role = Role::withCount('users')
            ->with('permissions:id,name,display_name,module_id')
            ->findOrFail($id);

        return response()->json(['success' => true, 'data' => $role]);
    }

    public function update(Request $request, $id)
    {
        $role = Role::findOrFail($id);

        $data = $request->validate([
            'name'         => 'sometimes|string|max:100|unique:roles,name,' . $id,
            'display_name' => 'sometimes|string|max:255',
            'description'  => 'nullable|string',
            'level'        => 'sometimes|integer|min:0',
            'permissions'  => 'nullable|array',
            'permissions.*'=> 'integer|exists:permissions,id',
        ]);

        $role->update(array_filter([
            'name'         => $data['name'] ?? null,
            'display_name' => $data['display_name'] ?? null,
            'description'  => $data['description'] ?? null,
            'level'        => $data['level'] ?? null,
        ], fn($v) => $v !== null));

        if (array_key_exists('permissions', $data)) {
            $role->permissions()->sync($data['permissions'] ?? []);
        }

        $role->load('permissions:id,name,display_name,module_id');
        return response()->json(['success' => true, 'data' => $role]);
    }

    public function destroy($id)
    {
        $role = Role::withCount('users')->findOrFail($id);

        if ($role->is_system) {
            return response()->json([
                'success' => false,
                'message' => 'System roles cannot be deleted.'
            ], 422);
        }

        if ($role->users_count > 0) {
            return response()->json([
                'success' => false,
                'message' => "Cannot delete: {$role->users_count} user(s) have this role."
            ], 422);
        }

        $role->permissions()->detach();
        $role->delete();

        return response()->json(['success' => true, 'message' => 'Role deleted.']);
    }

    public function permissions()
    {
        $permissions = Permission::with('module:id,name,display_name')
            ->orderBy('module_id')
            ->orderBy('name')
            ->get();

        return response()->json(['success' => true, 'data' => $permissions]);
    }
}

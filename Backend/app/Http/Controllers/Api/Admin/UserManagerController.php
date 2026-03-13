<?php

namespace App\Http\Controllers\Api\Admin;

use App\Helpers\FileUploadHelper;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Cache;

use Illuminate\Support\Facades\Log;
use App\Models\Role;
use App\Models\User;
use App\Services\UserSlugService;
use Illuminate\Support\Facades\Storage;


class UserManagerController extends Controller
{
    public function getAllUser()
    {
        $users = User::with('roles')->get();

        return response()->json($users);
    }

    public function add(Request $request)
    {
        try {
            $data = $request->validate([
                'name' => 'required|string|max:255',
                'slug' => 'nullable|string|max:255|unique:users,slug',
                'email' => 'required|email|max:255|unique:users,email',
                'phone' => 'nullable|string|max:20|unique:users,phone',
                'username' => 'required|string|max:50|unique:users,username',
                'phone_verified_at' => 'nullable|date',
                'password' => 'required|string|min:6',
                'avatar' => 'nullable|image|mimes:jpeg,png,jpg,gif,webp|max:5120',
                'date_of_birth' => 'nullable|date',
                'gender' => 'nullable|in:male,female,other',
                'country' => 'nullable|string|max:100',
                'timezone' => 'nullable|string|max:50',
                'bio' => 'nullable|string|max:500',
                'status' => 'nullable|in:active,inactive,banned',
                'published_at' => 'nullable|date',
                'play_count_last_24h' => 'nullable|integer|min:0',
                'play_count_last_7d' => 'nullable|integer|min:0',
                'play_count_last_30d' => 'nullable|integer|min:0',
                'trending_score' => 'nullable|numeric|min:0',
                'seo_title' => 'nullable|string|max:255',
                'seo_description' => 'nullable|string|max:500',
                'has_used_trial' => 'nullable|boolean',
                'is_vip' => 'nullable|boolean',
                'vip_expires_at' => 'nullable|date',
            ]);
            $avatarPath = null;
            if ($request->hasFile('avatar') && $request->file('avatar')->isValid()) {
                $avatarPath = FileUploadHelper::upload($request->file('avatar'), 'avatars/users');
                Log::info('Avatar uploaded during add: ' . $avatarPath);
            }
            
            $user = User::create([
                ...$data,
                'slug' => UserSlugService::generate($data['name']), 
                'password' => Hash::make($data['password']),
                'avatar_url' => $avatarPath,
            ]);

            $role = Role::where('name', 'user_free')->first();
            if ($role) {
                $user->assignRole('user_free');
            }

            return response()->json([
                'status' => 'success',
                'data' => [
                    'name' => $user->name,
                    'email' => $user->email,
                    'avatar_url' => $avatarPath ? Storage::url($avatarPath) : null,
                    'roles_flags' => $user->getRoleFlags(),
                ]
            ], 201);
        } catch (\Throwable $e) {
            return response()->json([
                'status' => 'error',
                'message' => $e->getMessage()
            ], 400);
        }
    }

    public function search(Request $request)
    {
        $users = User::query()
            ->search($request->q)
            ->with('roles')
            ->latest()
            ->paginate(10);
        return response()->json([
            'status' => 'success',
            'data' => $users
        ]);
    }

    public function show(User $user)
    {
        return response()->json($user);
    }

    public function update(Request $request, User $user)
    {
        try {
            $data = $request->validate([
                'name' => 'required|string|max:255',
                'slug' => 'nullable|string|max:255|unique:users,slug,' . $user->id,
                'email' => 'required|email|max:255|unique:users,email,' . $user->id,
                'phone' => 'nullable|string|max:20|unique:users,phone,' . $user->id,
                'username' => 'required|string|max:50|unique:users,username,' . $user->id,
                'phone_verified_at' => 'nullable|date',
                'password' => 'nullable|string|min:6',
                'avatar' => 'nullable|image|mimes:jpeg,png,jpg,gif,webp|max:5120',
                'date_of_birth' => 'nullable|date',
                'gender' => 'nullable|in:male,female,other',
                'country' => 'nullable|string|max:100',
                'timezone' => 'nullable|string|max:50',
                'bio' => 'nullable|string|max:500',
                'status' => 'nullable|in:active,inactive,banned,pending',
                'published_at' => 'nullable|date',
                'seo_title' => 'nullable|string|max:255',
                'seo_description' => 'nullable|string|max:500',
            ]);

            if (!empty($data['password'])) {
                $data['password'] = bcrypt($data['password']);
            } else {
                unset($data['password']);
            }

            if ($request->hasFile('avatar') && $request->file('avatar')->isValid()) {
                Log::info('Uploading avatar via helper...');
                
                $avatarPath = FileUploadHelper::upload(
                    $request->file('avatar'), 
                    'avatars/users', 
                    $user->avatar_url, 
                    'public'
                );
                
                Log::info('Avatar uploaded: ' . $avatarPath);
                $data['avatar_url'] = $avatarPath;
            } else {
                Log::info('No new avatar uploaded, keeping existing: ' . $user->avatar_url);
            }

            unset($data['avatar']);

            $user->update($data);
            
            Log::info('User updated successfully', [
                'user_id' => $user->id,
                'name' => $user->name,
                'email' => $user->email
            ]);

            return response()->json([
                'status' => 'success',
                'message' => 'Update user successfully',
                'data' => [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'avatar_url' => $user->avatar_url,
                    'roles_flags' => $user->getRoleFlags(),
                ]
            ]);
            
        } catch (\Throwable $e) {
            Log::error('Update user error: ' . $e->getMessage());
            Log::error('Stack trace: ' . $e->getTraceAsString());
            
            return response()->json([
                'status' => 'error',
                'message' => 'Update failed: ' . $e->getMessage()
            ], 400);
        }
    }

    public function delete(User $user)
    {
        try {
            Log::info('Hard deleting user ID:', ['id' => $user->id]);

            $user->forceDelete();

            Log::info('User hard deleted successfully');

            return response()->json([
                'success' => true,
                'message' => 'User permanently deleted successfully',
                'deleted_id' => $user->id
            ]);
        } catch (\Exception $e) {
            Log::error('Delete user error:', ['error' => $e->getMessage()]);

            return response()->json([
                'success' => false,
                'message' => 'Delete failed: ' . $e->getMessage()
            ], 500);
        }
    }

    
  
}

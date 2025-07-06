<?php

namespace App\Http\Controllers\API\Admin;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use App\Http\Controllers\Controller;
use Laravel\Sanctum\PersonalAccessToken;
use Laravel\Sanctum\TransientToken;
use Illuminate\Support\Facades\Log;


class AuthController extends Controller
{


    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        Log::info('Attempting login', ['email' => $request->email]);

        if (!Auth::attempt($credentials)) {
            Log::error('Invalid credentials', ['email' => $request->email]);
            return response()->json(['message' => 'Invalid credentials'], 401);
        }

        /** @var User $user */
        $user = Auth::user();
        Log::info('User authenticated', ['user_id' => $user->id, 'email' => $user->email, 'role_id' => $user->role_id]);

        // Kiểm tra role admin
        if (!$user->isAdmin()) {
            Log::warning('User not admin', ['user_id' => $user->id, 'role_id' => $user->role_id]);
            Auth::logout();
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        // Tạo token
        $token = $user->createToken('auth_token')->plainTextToken;
        Log::info('Token created', ['token' => $token, 'user_id' => $user->id]);

        return response()->json([
            'token' => $token,
            'user' => $user->only(['id', 'name', 'email', 'role'])
        ]);
    }


    public function logout(Request $request)
    {
        Auth::guard('web')->logout(); // xoá session của Laravel
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return response()->json(['message' => 'Logged out']);
    }
}

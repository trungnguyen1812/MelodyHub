<?php

namespace App\Http\Controllers\API\Admin;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use App\Http\Controllers\Controller;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if (!Auth::attempt($credentials)) {
            return response()->json([
                'message' => 'Invalid credentials'
            ], 401);
        }

        /** @var User $user */
        $user = Auth::user();

        // Kiểm tra role admin
        if (!$user->isAdmin()) {
            Auth::logout();
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        // Tạo token
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'token' => $token,
            'user' => $user->only(['id', 'name', 'email', 'role'])
        ]);
    }

    public function logout(Request $request)
    {
        /** @var User $user */
        $user = $request->user();

        /** @var \Laravel\Sanctum\PersonalAccessToken|null $token */
        $token = $user->currentAccessToken();

        if ($token) {
            $token->delete();
        }

        return response()->json(['message' => 'Logged out']);
    }
}
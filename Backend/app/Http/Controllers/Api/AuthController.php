<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $credentials = $request->only('email','password');
        
        if (Auth::attempt($credentials)) {
            /** @var \App\Models\User $user */
            $user = Auth::user();
            
            // Tạo token để frontend dùng
            $token = $user->createToken('api-token')->plainTextToken;
            
            return response()->json([
                'message'       => 'Login successful',
                'user'          => $user,
                'roles_flags'   => $user->getRoleFlags(),
                'token'         => $token
            ]);
        }

        return response()->json(['message'=>'Incorrect account or password'], 401);
    }

    public function logout(Request $request)
    {
        $user = $request->user();

        // Xóa tất cả token của người dùng
        $user->tokens()->delete();

        return response()->json([
            'message' => 'Logged out successfully'
        ]);
    }

    public function adminDashboard()
    {
        $user = Auth::user();
        return response()->json([
            'message' => 'Welcome to admin dashboard',
            'user' => $user
        ]);
    }
}

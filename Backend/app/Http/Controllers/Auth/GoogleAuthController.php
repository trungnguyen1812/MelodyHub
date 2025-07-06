<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Laravel\Socialite\Facades\Socialite;
use Illuminate\Support\Str;
use App\Models\Role;

class GoogleAuthController extends Controller
{
    // Chuyển hướng người dùng sang Google
    public function redirect()
    {
        return Socialite::driver('google')->redirect();
    }

    // Nhận callback từ Google
    public function callback()
    {
        $googleUser = Socialite::driver('google')->user();

         // Tìm role mặc định: ví dụ 'user'
        $defaultRole = Role::where('name', 'user')->first();

        $user = User::firstOrCreate(
            ['email' => $googleUser->getEmail()],
            [
                'name' => $googleUser->getName(),
                'password' => bcrypt(Str::random(16)),
                'role_id' => $defaultRole?->id, 
            ]
        );

        // Login (session hoặc tạo token)
        Auth::login($user);

        $token = $user->createToken('google_token')->plainTextToken;

        return redirect("http://localhost:5173/login-success?token={$token}");
    }
}

<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Laravel\Socialite\Facades\Socialite;

class GoogleAuthController extends Controller
{
    /**
     * Redirect user to Google OAuth consent screen.
     * GET /auth/redirect
     */
    public function redirect()
    {
        return Socialite::driver('google')
            ->stateless()
            ->redirect();
    }

    /**
     * Handle Google OAuth callback, issue Sanctum token, redirect to frontend.
     * GET /auth/google/callback
     */
    public function callback()
    {
        try {
            $googleUser = Socialite::driver('google')->stateless()->user();
        } catch (\Throwable $e) {
            Log::error('Google OAuth callback error', ['error' => $e->getMessage()]);
            $frontendUrl = env('FRONTEND_URL', 'http://localhost:5173');
            return redirect("{$frontendUrl}/login-success?error=oauth_failed");
        }

        // 1. Tìm theo google_id trước (login lại bằng Google)
        $user = User::where('google_id', $googleUser->getId())->first();

        // 2. Nếu không có, tìm theo email (user đã đăng ký thường, liên kết Google)
        if (!$user) {
            $user = User::where('email', $googleUser->getEmail())->first();

            if ($user) {
                // Liên kết google_id vào tài khoản hiện có
                $user->update([
                    'google_id'          => $googleUser->getId(),
                    'email_verified_at'  => $user->email_verified_at ?? now(),
                    'avatar_url'         => $user->avatar_url ?: $googleUser->getAvatar(),
                ]);
            }
        }

        // 3. Nếu vẫn không có → tạo tài khoản mới
        if (!$user) {
            $user = User::create([
                'name'              => $googleUser->getName() ?? $googleUser->getNickname() ?? 'Google User',
                'email'             => $googleUser->getEmail(),
                'google_id'         => $googleUser->getId(),
                'username'          => $this->generateUsername($googleUser->getEmail()),
                'password'          => bcrypt(Str::random(32)),
                'avatar_url'        => $googleUser->getAvatar(),
                'status'            => 'active',
                'slug'              => $this->generateSlug($googleUser->getName() ?? $googleUser->getEmail()),
                'email_verified_at' => now(),
            ]);

            $this->assignDefaultRole($user);
        }

        // Kiểm tra tài khoản bị ban
        if ($user->status === 'banned') {
            $frontendUrl = env('FRONTEND_URL', 'http://localhost:5173');
            return redirect("{$frontendUrl}/login-success?error=account_banned");
        }

        // Xóa token cũ để tránh tích lũy
        $user->tokens()->where('name', 'google-auth')->delete();

        // Cấp Sanctum token (30 ngày)
        $tokenResult = $user->createToken('google-auth');
        $tokenResult->accessToken->expires_at = now()->addDays(30);
        $tokenResult->accessToken->save();

        $token = $tokenResult->plainTextToken;

        // Redirect về frontend kèm token
        $frontendUrl = env('FRONTEND_URL', 'http://localhost:5173');
        return redirect("{$frontendUrl}/login-success?token={$token}");
    }

    /**
     * Generate a unique username from email.
     */
    private function generateUsername(string $email): string
    {
        $base     = Str::slug(explode('@', $email)[0]);
        $username = $base;
        $counter  = 1;

        while (User::where('username', $username)->exists()) {
            $username = "{$base}{$counter}";
            $counter++;
        }

        return $username;
    }

    /**
     * Generate a unique slug from name/email.
     */
    private function generateSlug(string $name): string
    {
        $base    = Str::slug($name);
        $slug    = $base;
        $counter = 1;

        while (User::where('slug', $slug)->exists()) {
            $slug = "{$base}-{$counter}";
            $counter++;
        }

        return $slug;
    }

    /**
     * Assign default 'user_free' role to new user.
     */
    private function assignDefaultRole(User $user): void
    {
        try {
            $role = \App\Models\Role::where('name', 'user_free')->first();
            if ($role) {
                $user->roles()->syncWithoutDetaching([$role->id]);
            }
        } catch (\Throwable $e) {
            Log::warning('Could not assign default role to Google user', [
                'user_id' => $user->id,
                'error'   => $e->getMessage(),
            ]);
        }
    }
}

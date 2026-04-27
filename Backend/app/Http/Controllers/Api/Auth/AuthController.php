<?php
namespace App\Http\Controllers\Api\auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\User\LoginUserRequest;
use App\Http\Requests\User\RegisterUserRequest;
use App\Models\Role;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Str;


class AuthController extends Controller
{
    public function login(LoginUserRequest $request)
    {
        $throttleKey = Str::lower($request->email) . '|' . $request->ip();
        // check for excessive login attempts
        if (RateLimiter::tooManyAttempts($throttleKey, 5)) {
            return response()->json(['message' => 'Too many login attempts. Try again later.'], 429);
        }
        $credentials = $request->only('email','password');
       
        if (Auth::attempt($credentials)) {
            /** @var \App\Models\User $user */
            $user = Auth::user();
            $tokenResult = $user->createToken('api-token');

            $tokenResult->accessToken->expires_at = now()->addDays(30);
            $tokenResult->accessToken->save();

            
            return response()->json([
                'message'       => 'Login successful',
                'user'          => $user,
                'roles_flags'   => $user->getRoleFlags(),
                'token'         => $tokenResult->plainTextToken
            ]);
        }
        // if login false -> increase the number of attempts
        RateLimiter::hit($throttleKey);
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

    public function register(RegisterUserRequest $request){
        $data = $request->validated();
         /** @var \App\Models\User $user */
        $user = User::create([
            'name'  => $data['fullname'],
            'email'    => $data['email'],
            'password' => Hash::make($data['password']),
            'slug'     => Str::slug($data['fullname']),
        ]);

        $role = Role::where('name' , 'user_free')->first();
        if ($role) {
          $user->assignRole('user_free');
        }

        $token = $user->createToken('api-token')->plainTextToken;

        return response()->json([
            'message'       => 'User registered successfully',
            'user'          => $user,
            'roles_flags'   => $user->getRoleFlags(),
            'token'         => $token
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

    public function sendAdminOtp(){
        
    }

    public function updateProfile(Request $request)
    {
        /** @var \App\Models\User $user */
        $user = $request->user();

        $validated = $request->validate([
            'name'          => 'sometimes|string|max:255',
            'phone'         => 'sometimes|nullable|string|max:20',
            'date_of_birth' => 'sometimes|nullable|date',
            'gender'        => 'sometimes|nullable|in:male,female,other',
            'bio'           => 'sometimes|nullable|string|max:1000',
            'avatar'        => 'sometimes|nullable|image|mimes:jpeg,png,jpg,gif,webp|max:2048',
        ]);

        if ($request->hasFile('avatar')) {
            // Delete old avatar if it's a local file
            if ($user->avatar_url && !str_starts_with($user->avatar_url, 'http')) {
                \Illuminate\Support\Facades\Storage::disk('public')->delete($user->avatar_url);
            }
            $path = $request->file('avatar')->store('avatars', 'public');
            $validated['avatar_url'] = $path;
        }

        unset($validated['avatar']);
        $user->update($validated);

        return response()->json([
            'message' => 'Profile updated successfully',
            'user'    => $user->fresh(),
        ]);
    }

    public function changePassword(Request $request)
    {
        /** @var \App\Models\User $user */
        $user = $request->user();

        $validated = $request->validate([
            'current_password' => 'required|string',
            'new_password'     => 'required|string|min:8|confirmed',
        ]);

        if (!Hash::check($validated['current_password'], $user->password)) {
            return response()->json([
                'message' => 'Current password is incorrect',
                'errors'  => ['current_password' => ['Current password is incorrect']],
            ], 422);
        }

        $user->update([
            'password' => Hash::make($validated['new_password']),
        ]);

        // Revoke all tokens except current so user stays logged in
        $currentToken = $request->user()->currentAccessToken();
        $user->tokens()->where('id', '!=', $currentToken->id)->delete();

        return response()->json([
            'message' => 'Password changed successfully',
        ]);
    }
}

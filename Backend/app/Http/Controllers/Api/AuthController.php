<?php
namespace App\Http\Controllers\Api;

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
            // Tạo token để frontend dùng
            $token = $user->createToken('api-token')->plainTextToken;
            
            return response()->json([
                'message'       => 'Login successful',
                'user'          => $user,
                'roles_flags'   => $user->getRoleFlags(),
                'token'         => $token
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

    
}

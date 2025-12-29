<?php
// app/Http/Middleware/AdminTokenMiddleware.php
namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Log;

class AdminTokenMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        // Lấy token từ header Authorization hoặc query parameter
        $token = $request->bearerToken() ?? 
                $request->header('X-Admin-Token') ?? 
                $request->query('admin_token');
        
        Log::debug('AdminTokenMiddleware checking', ['token_present' => !empty($token)]);
        
        if (!$token) {
            return response()->json([
                'success' => false,
                'message' => 'Admin token is required'
            ], 401);
        }
        
        $cacheKey = 'admin_token_' . $token;
        $adminData = Cache::get($cacheKey);
        
        Log::debug('AdminTokenMiddleware cache check', [
            'cache_key' => $cacheKey,
            'has_data' => !empty($adminData)
        ]);
        
        if (!$adminData) {
            return response()->json([
                'success' => false,
                'message' => 'Admin token is invalid or expired'
            ], 401);
        }
        
        // Gắn thông tin admin vào request
        $request->merge([
            'admin_user' => $adminData,
            'admin_token' => $token
        ]);
        
        // Set user cho request (tương thích với các middleware khác)
        if (isset($adminData['user_id'])) {
            $user = \App\Models\User::find($adminData['user_id']);
            if ($user) {
                $request->setUserResolver(function () use ($user) {
                    return $user;
                });
            }
        }
        
        return $next($request);
    }
}
<?php
// app/Http/Controllers/Api/Auth/AdminAuthController.php
namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use App\Models\User;

class AdminAuthController extends Controller
{
    /**
     * Check admin token validity
     */
    public function checkAdminToken(Request $request)
    {
        $token = $this->getTokenFromRequest($request);
        
        if (!$token) {
            return response()->json([
                'success' => false,
                'message' => 'Token is required'
            ], 400);
        }
        
        $cacheKey = 'admin_token_' . $token;
        $adminData = Cache::get($cacheKey);
        
        if ($adminData) {
            return response()->json([
                'success' => true,
                'valid' => true,
                'user' => [
                    'id' => $adminData['user_id'],
                    'email' => $adminData['email'],
                    'name' => $adminData['name']
                ],
                'role_flags' => $adminData['role_flags'],
                'created_at' => $adminData['created_at'],
                'expires_at' => $adminData['expires_at']
            ]);
        }
        
        return response()->json([
            'success' => false,
            'valid' => false,
            'message' => 'Token is invalid or expired'
        ], 401);
    }
    
    /**
     * Test endpoint for admin token
     */
    public function testToken(Request $request)
    {
        return response()->json([
            'success' => true,
            'message' => 'Admin token is valid',
            'user' => $request->admin_user,
            'token' => $request->admin_token
        ]);
    }
    
    /**
     * Check token expiry
     */
    public function checkTokenExpiry(Request $request)
    {
        $token = $request->query('token') ?? $this->getTokenFromRequest($request);
        
        if (!$token) {
            return response()->json([
                'message' => 'Token is required as query parameter: ?token=YOUR_TOKEN'
            ], 400);
        }
        
        $cacheKey = 'admin_token_' . $token;
        $data = Cache::get($cacheKey);
        
        if ($data) {
            // Tính thời gian còn lại
            $expiresAt = \Carbon\Carbon::parse($data['expires_at']);
            $remainingMinutes = now()->diffInMinutes($expiresAt, false);
            $remainingSeconds = now()->diffInSeconds($expiresAt, false);
            
            return response()->json([
                'valid' => true,
                'message' => 'Token is still valid',
                'user' => $data['email'],
                'remaining_minutes' => max(0, $remainingMinutes),
                'remaining_seconds' => max(0, $remainingSeconds),
                'expires_at' => $data['expires_at'],
                'cache_key' => $cacheKey
            ]);
        }
        
        return response()->json([
            'valid' => false,
            'message' => 'Token is expired or invalid',
            'cache_key' => $cacheKey
        ]);
    }
    
    /**
     * Helper: Extract token from request
     */
    private function getTokenFromRequest(Request $request)
    {
        return $request->bearerToken() ?? 
               $request->header('X-Admin-Token') ?? 
               $request->query('admin_token');
    }
}
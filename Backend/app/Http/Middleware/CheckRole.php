<?php
namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class CheckRole
{
    public function handle(Request $request, Closure $next, ...$roles) // ← Dùng ...$roles
    {
        // 1. Kiểm tra user đã đăng nhập chưa
        if (!Auth::check()) {
            return $this->unauthorizedResponse($request, 'Unauthorized. Please login first.');
        }
        
        /** @var \App\Models\User $user */
        $user = Auth::user();
        
        // 2. Debug
        Log::debug('CheckRole Middleware Triggered', [
            'user' => $user->email,
            'required_roles' => $roles,
            'path' => $request->path()
        ]);
        
        // 3. Nếu không có role requirement, cho phép tất cả
        if (empty($roles)) {
            return $next($request);
        }
        $roleFlags = $user->getRoleFlags();
        
        // 5. Map role name to flag name
        $roleToFlagMap = [
            'admin' => 'is_admin',
            'boss' => 'is_boss',
            'content_manager' => 'is_content_manager',
            'partner' => 'is_partner',
            'moderator' => 'is_moderator',
            'user_vip_yearly' => 'is_user_vip_yearly',
            'user_vip_monthly' => 'is_user_vip_monthly',
            'user_free' => 'is_user_free',
        ];
        
        // 6. Kiểm tra user có ít nhất 1 role required
        $hasAccess = false;
        
        foreach ($roles as $role) {
            $flagName = $roleToFlagMap[$role] ?? null;
            
            if ($flagName && isset($roleFlags[$flagName]) && $roleFlags[$flagName] === true) {
                $hasAccess = true;
                break;
            }
        }
        
        // 7. Nếu không có quyền
        if (!$hasAccess) {
            return $this->forbiddenResponse($request, [
                'message' => 'Forbidden. Insufficient permissions.',
                'required_roles' => $roles,
                'your_roles_flags' => $roleFlags,
                'hint' => 'You need one of these roles: ' . implode(', ', $roles)
            ]);
        }
        
        return $next($request);
    }
    
    /**
     * Helper methods (giữ nguyên như trên)
     */
    private function unauthorizedResponse(Request $request, $message = 'Unauthorized')
    {
        if ($this->isApiRequest($request)) {
            return response()->json(['message' => $message], 401);
        }
        return redirect('/login');
    }
    
    private function forbiddenResponse(Request $request, $data = [])
    {
        if ($this->isApiRequest($request)) {
            return response()->json($data, 403);
        }
        return redirect('/403');
    }
    
    private function isApiRequest(Request $request): bool
    {
        return $request->expectsJson() || 
               $request->is('api/*') || 
               Str::startsWith($request->header('Accept'), 'application/json');
    }
}
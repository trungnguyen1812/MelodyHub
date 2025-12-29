<?php
namespace App\Http\Middleware;

use Closure;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;

class CheckRole
{
    public function handle(Request $request, Closure $next, ...$roles)
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'message' => 'Unauthenticated'
            ], 401);
        }

        Log::debug('CheckRole Middleware Triggered', [
            'user' => $user->email,
            'required_roles' => $roles,
            'path' => $request->path()
        ]);

        if (empty($roles)) {
            return $next($request);
        }

        $roleFlags = $user->getRoleFlags();

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

        foreach ($roles as $role) {
            $flag = $roleToFlagMap[$role] ?? null;

            if ($flag && !empty($roleFlags[$flag])) {
                return $next($request);
            }
        }

        return response()->json([
            'message' => 'Forbidden. Insufficient permissions.',
            'required_roles' => $roles
        ], 403);
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
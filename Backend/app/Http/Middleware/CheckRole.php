<?php
namespace App\Http\Middleware;

use App\Models\Role;
use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CheckRole
{
    public function handle(Request $request, Closure $next , $roles)
    {
        $user = Auth::user();

        if (!$user) {
            // Nếu request là API trả JSON, nếu là web redirect
            if ($request->expectsJson() || $request->is('api/*')) {
                return response()->json(['message' => 'Unauthorized'], 401);
            }
            return redirect('/admin/login');
        }
        /** @var \App\Models\User $user */
        // Kiểm tra role
        if (empty($roles) || !$user->roles()->whereIn('name',$roles)->exists()) {
            if ($request->expectsJson() || $request->is('api/*')) {
                return response()->json(['message' => 'Forbidden'], 403);
            }
            return redirect('/admin/login');
        }

        return $next($request);
    }
  
}

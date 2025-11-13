<?php
namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class CheckAdmin
{
    public function handle(Request $request, Closure $next)
    {
        $user = Auth::user();

        if (!$user) {
            return redirect('/login'); // chưa login
        }

        // Kiểm tra role admin/boss
        $roles = DB::table('user_roles')
            ->join('roles', 'user_roles.role_id', '=', 'roles.id')
            ->where('user_roles.user_id', $user->id)
            ->whereIn('roles.name', ['boss', 'admin'])
            ->pluck('roles.name');

        if ($roles->isEmpty()) {
            return redirect('/'); // không phải admin
        }

        return $next($request);
    }
}

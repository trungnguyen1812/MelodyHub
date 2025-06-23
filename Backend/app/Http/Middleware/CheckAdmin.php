<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

class CheckAdmin
{
    public function handle(Request $request, Closure $next)
    {
        /** @var User|null $user */
        $user = Auth::user();

        if (!$user) {
            return response()->json([
                'error' => 'Unauthenticated',
                'message' => 'Authentication required'
            ], 401);
        }

        if (!$user->isAdmin()) {
            Auth::logout();
            return response()->json([
                'error' => 'Forbidden',
                'message' => 'Admin access only'
            ], 403);
        }

        return $next($request);
    }
}
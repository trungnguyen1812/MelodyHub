<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class OptionalAuth
{
    public function handle(Request $request, Closure $next): mixed
    {
        try {
            $user = auth('sanctum')->user();
            if ($user) {
                auth()->setUser($user);
            }
        } catch (\Exception) {
            // Guest
        }

        return $next($request);
    }
}
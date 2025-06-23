<?php

namespace App\Http\Middleware;

use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken as Middleware;
use Closure;
use Illuminate\Support\Facades\Log;

class VerifyCsrfToken extends Middleware
{
    protected $except = [
        'api/*',
        'sanctum/csrf-cookie'
    ];

    public function handle($request, Closure $next)
    {
        $xsrfTokenFromHeader = $request->header('X-XSRF-TOKEN');
        Log::info('CSRF Token from header: ' . ($xsrfTokenFromHeader ?? 'Not found'));

        $xsrfTokenFromCookie = $request->cookie('XSRF-TOKEN');
        Log::info('CSRF Token from cookie: ' . ($xsrfTokenFromCookie ?? 'Not found'));

        Log::info('Request URL: ' . $request->fullUrl());
        Log::info('Request Method: ' . $request->method());
        
        if ($request->route()) {
            Log::info('Request Route: ' . $request->route()->uri());
            Log::info('Applied Middleware: ' . implode(', ', $request->route()->gatherMiddleware()));
        }

        return parent::handle($request, $next);
    }
}
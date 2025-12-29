<?php
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Auth\Middleware\Authenticate; 
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Middleware\HandleCors; 
use App\Http\Middleware\CheckRole;
use App\Http\Middleware\AdminTokenMiddleware; 

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        // Middleware laravel built-in
        $middleware->prepend(HandleCors::class);
        $middleware->alias([
                'checkrole' => CheckRole::class,
                'authapi'   => Authenticate::class,
                'admin.token' => AdminTokenMiddleware::class,
            ]);
    })
    
    ->withExceptions(function (Exceptions $exceptions) {
        //
    })
    ->create();

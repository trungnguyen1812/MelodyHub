<?php
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful;
use Illuminate\Http\Middleware\HandleCors;
use Illuminate\Routing\Middleware\SubstituteBindings;


return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__ . '/../routes/web.php',
        api: __DIR__ . '/../routes/api.php',
        commands: __DIR__ . '/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->use([
             \Illuminate\Http\Middleware\HandleCors::class,
        ]);


        // ✅ Loại bỏ CSRF khỏi API middleware
        $middleware->api(append: [
            \Illuminate\Http\Middleware\HandleCors::class,
            EnsureFrontendRequestsAreStateful::class,
            SubstituteBindings::class,
            // ✅ Bỏ VerifyCsrfToken khỏi API group
        ]);


        // ✅ Chỉ áp dụng CSRF cho web routes
        $middleware->web(append: [
            \App\Http\Middleware\VerifyCsrfToken::class,
        ]);


        $middleware->alias([
            'admin' => \App\Http\Middleware\CheckAdmin::class,
            'auth:sanctum' => \Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions) {
        //
    })->create();
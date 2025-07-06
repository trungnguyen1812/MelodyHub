<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Auth\GoogleAuthController;

Route::middleware('web')->group(function () {
    Route::get('/auth/redirect', [GoogleAuthController::class, 'redirect']);
    Route::get('/auth/callback', [GoogleAuthController::class, 'callback']);
    Route::get('/test-web', fn () => 'WEB ROUTE HOẠT ĐỘNG');
});



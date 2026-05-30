<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\AuthController;
use App\Http\Middleware\CheckAdmin;
use App\Http\Controllers\Api\Auth\GoogleAuthController;

// client page
Route::get('/', function () {
    return view('welcome');
});

// ── Google OAuth ──────────────────────────────────────────────────────────────
Route::get('/auth/redirect',          [GoogleAuthController::class, 'redirect']);
Route::get('/auth/google/callback',   [GoogleAuthController::class, 'callback']);

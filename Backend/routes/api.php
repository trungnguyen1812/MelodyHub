<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Middleware\CheckAdmin;
use App\Http\Controllers\AdminController;

// API login
Route::post('/login', [AuthController::class, 'login']);

// API admin → middleware checkrole
Route::middleware(['auth:sanctum', 'checkrole'])->group(function() {
    Route::middleware('checkrole')->group(function() {
        Route::get('/admin', [AdminController::class, 'dashboard']);
    });
});
// router logout
Route::middleware('auth:sanctum')->post('/logout', [AuthController::class, 'logout']);

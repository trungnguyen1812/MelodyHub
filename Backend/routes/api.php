<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\Admin\AuthController;
use App\Http\Controllers\API\Admin\AdminController;

// Route login - bỏ CSRF cho API login
Route::post('/login', [AuthController::class, 'login'])
    ->middleware(['guest:sanctum']);

// Route logout - cần auth
Route::post('/logout', [AuthController::class, 'logout'])
    ->middleware(['auth:sanctum']);

// Nhóm route admin (yêu cầu auth + admin)
Route::middleware(['auth:sanctum', 'admin'])->prefix('admin')->group(function () {
    Route::get('/dashboard', [AdminController::class, 'dashboard']);
    Route::get('/users', [AdminController::class, 'users']);
    Route::get('/user', [AdminController::class, 'currentUser']);
});

<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController; // Thêm dòng này
use App\Http\Controllers\AdminController;

// Route đăng nhập (không cần middleware)
Route::post('/login', [AuthController::class, 'login']); // 👈 Thêm route mới

// Nhóm route admin (yêu cầu auth + admin)
Route::middleware(['auth:sanctum', 'admin'])->prefix('admin')->group(function () {
    Route::get('/dashboard', [AdminController::class, 'dashboard']);
    Route::get('/users', [AdminController::class, 'users']);
});
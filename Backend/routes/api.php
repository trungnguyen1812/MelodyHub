<?php
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
use App\Http\Controllers\Api\Admin\AdminController;
use App\Http\Controllers\Api\Admin\UserManagerController;
use App\Http\Controllers\Api\Auth\AuthController;
use App\Http\Controllers\Api\Auth\OTPController;
use App\Http\Controllers\Api\Auth\AdminAuthController;


/**-------------------
 * ROUTER FOR CLIENT--
 *-------------------*/
Route::prefix('client')->group(function () {
    // API login
    Route::post('/login', [AuthController::class, 'login']);
    // API register
    Route::post('/register',[AuthController::class,'register']);
    // API admin → middleware checkrole
    Route::middleware(['authapi:sanctum'])->group(function() {
        Route::post('/logout', [AuthController::class, 'logout']);
    });
    // kiểm tra admin-token (chỉ check token hợp lệ)
    Route::middleware(['authapi:sanctum'])->get('/check-permission', function (Request $request) {

        $user = $request->user();
        $rolesFlags = $user->getRoleFlags();

        $isAdmin = $rolesFlags['is_admin']
                || $rolesFlags['is_boss']
                || $rolesFlags['is_content_manager'];

        return response()->json([
            'is_admin'    => $isAdmin,
            'user'        => $user,
            'roles_flags' => $rolesFlags,
        ]);
    });
});



/**
 * -------------------------
 * ADMIN AUTH & OTP APIs
 * -------------------------
 */
Route::prefix('admin/auth')->group(function () {
    // OTP APIs
    Route::post('/send-otp', [OTPController::class, 'sendOTP']);
    Route::post('/verify-otp', [OTPController::class, 'verifyOTP']);
    Route::post('/check-verification', [OTPController::class, 'checkVerification']);
    
    // Token validation APIs (public)
    Route::post('/check-token', [AdminAuthController::class, 'checkAdminToken']);
    Route::get('/check-expiry', [AdminAuthController::class, 'checkTokenExpiry']);
    
});

/**
 * -------------------------
 * ADMIN PROTECTED APIs
 * -------------------------
 */
Route::prefix('admin')->middleware(['admin.token'])->group(function () {
    // Admin dashboard & management
    Route::get('/dashboard', [AdminController::class, 'dashboard']);
    Route::get('/test', [AdminAuthController::class, 'testToken']);
    // Router user management
    Route::get('/list-user',[UserManagerController::class,'getAllUser']);
    // Route::get('/users', [AdminController::class, 'getUsers']);
    // Route::get('/reports', [AdminController::class, 'getReports']);
});

// Route 404 fallback
Route::fallback(function() {
    return response()->json([
        'message' => 'Route not found'
    ], 404);
});
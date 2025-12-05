<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use Illuminate\Http\Request;
use App\Http\Controllers\Api\AdminController;

// API login
Route::post('/login', [AuthController::class, 'login']);
// API register
Route::post('/register',[AuthController::class,'register']);
// API admin → middleware checkrole
Route::middleware(['authapi:sanctum'])->group(function() {
    // Logout - cần auth nhưng không cần role
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/admin/check-permission', function (Request $request) {
        $user = $request->user();
        $rolesFlags = $user->getRoleFlags();
        
        $isAdmin = $rolesFlags['is_admin'] || 
                   $rolesFlags['is_boss'] || 
                   $rolesFlags['is_content_manager'];
        
        return response()->json([
            'is_admin' => $isAdmin,
            'user' => $user,
            'roles_flags' => $rolesFlags,
            'message' => $isAdmin ? 'Access granted' : 'Access denied'
        ]);
    });
    // Admin routes - cần cả auth và role
    Route::middleware(['checkrole:boss,admin,content_manager'])->group(function() {
        Route::get('/admin', [AdminController::class, 'dashboard']);
    });
    
});

// Route 404 fallback cho frontend
Route::fallback(function() {
    return response()->json([
        'message' => 'Route not found'
    ], 404);
});
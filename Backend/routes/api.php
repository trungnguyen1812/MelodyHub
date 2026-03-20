<?php
use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
use App\Http\Controllers\Api\Admin\AdminController;
use App\Http\Controllers\Api\Admin\UserManagerController;
use App\Http\Controllers\Api\Auth\AuthController;
use App\Http\Controllers\Api\Auth\OTPController;
use App\Http\Controllers\Api\Admin\AdminAuthController;
use App\Http\Controllers\Api\client\SubscriptionController; 
use App\Http\Controllers\Api\Payment\PaymentController;
use App\Http\Controllers\Api\Payment\UserSubscriptionController;
use App\Http\Controllers\Api\Admin\ArtistsManagerController;
use App\Http\Controllers\Api\Admin\PartnersManagerController;
use App\Http\Controllers\Api\Admin\SongsManagerController;

// routes/api.php
Route::match(['GET', 'POST'], 'payment/sepay/webhook', [
    PaymentController::class,
    'webhook'
]);



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
    // 
    Route::get('/showsubcription', [SubscriptionController::class,'getAllSubscription']);
    // payment
    Route::post('/payment/create-qr', [PaymentController::class, 'create_QR'])
        ->middleware('auth:sanctum');

    

    Route::middleware('auth:sanctum')->get(
        '/me/subscription',
        [UserSubscriptionController::class, 'me']
    );



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
    Route::prefix('users')->group(function () {
        Route::get('/', [UserManagerController::class, 'getAllUser']);
        Route::post('/add', [UserManagerController::class, 'add']);
        Route::post('/search', [UserManagerController::class, 'search']);
        Route::get('/statistics', [UserManagerController::class, 'getUserStatistics']);
        Route::get('/{user}', [UserManagerController::class, 'show']);
        Route::post('/delete/{user}', [UserManagerController::class, 'delete']);
        Route::post('/update/{user}', [UserManagerController::class, 'update']);
    });

    // Router artists manager
    Route::prefix('artists')->group(function () {
        Route::get('/', [ArtistsManagerController::class, 'getAllArtist']);
        Route::post('/add', [ArtistsManagerController::class, 'add']);
        Route::post('/search', [ArtistsManagerController::class, 'search']);
        Route::get('/statistics', [ArtistsManagerController::class, 'statistics']);
        Route::get('/{artist}', [ArtistsManagerController::class, 'show']);
        Route::delete('/delete/{artist}', [ArtistsManagerController::class, 'delete']);
        Route::post('/update/{artist}', [ArtistsManagerController::class, 'update']);
    });

    // Router songs manager
    Route::prefix('songs')->group(function () {
        Route::get('/',         [SongsManagerController::class, 'index']);
        Route::post('/add',        [SongsManagerController::class, 'add']);
        Route::get('/{song}',     [SongsManagerController::class, 'show']);
        Route::post('/{song}',     [SongsManagerController::class, 'update']);
        Route::post('/{song}',  [SongsManagerController::class, 'destroy']);
    });
    
    // Router partners  manager
    Route::prefix('partners')->group(function () {
        Route::get('/',         [PartnersManagerController::class, 'index']);
        Route::post('/add',        [PartnersManagerController::class, 'add']);
        Route::get('/{song}',     [PartnersManagerController::class, 'show']);
        Route::post('/{song}',     [PartnersManagerController::class, 'update']);
        Route::post('/{song}',  [PartnersManagerController::class, 'destroy']);
    });
   
});

// Route 404 fallback
Route::fallback(function() {
    return response()->json([
        'message' => 'Route not found'
    ], 404);
});
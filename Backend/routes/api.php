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
use App\Http\Controllers\Api\Admin\GenresManagerController;
use App\Http\Controllers\Api\Admin\PartnersManagerController;
use App\Http\Controllers\Api\Admin\SongsManagerController;
use App\Http\Controllers\Api\Admin\AlbumsManagerController;
use App\Http\Controllers\Api\Admin\TypePartnerController;
use App\Http\Controllers\Api\Client\ArtistInteractionController;
use App\Http\Controllers\Api\Client\ClientArtistsController;
use App\Http\Controllers\Api\Client\ClientGenresController;
use App\Http\Controllers\Api\Client\ClientPartnersController;
use App\Http\Controllers\Api\Client\ClientSongsController;
use App\Http\Controllers\Api\Client\ClientTypePartnerController;
use App\Http\Controllers\Api\Client\CommentInteractionController;
use App\Http\Controllers\Api\Client\Songinteractioncontroller;
use App\Http\Controllers\Api\Client\SongPlayController as ClientSongPlayController;
use App\Http\Controllers\Api\Client\ClientAlbumsContronller;
use App\Http\Controllers\Api\Client\ClientAdvertisingController;
use App\Http\Controllers\Api\SongPlayController;
use App\Models\Partner;
use App\Models\Song;

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
    Route::middleware(['authapi:sanctum'])->get('/check-permission', function (Request $request) {
        $user       = $request->user();
        $rolesFlags = $user->getRoleFlags();

        $isAdmin = $rolesFlags['is_admin']
                || $rolesFlags['is_boss']
                || $rolesFlags['is_content_manager'];

        $partner = Partner::where('user_id', $user->id)
                    ->whereIn('status', ['active', 'pending','suspended','terminated'])
                    ->with('partnerType') 
                    ->first();

        $partnerTypeName = $partner?->partnerType?->name ?? null;

        return response()->json([
            'is_admin'              => $isAdmin,
            'is_partner'            => !is_null($partner),
            'is_music_distribution' => $partnerTypeName === 'Music distribution partners',  
            'is_advertising'        => $partnerTypeName === 'Advertising partners',  
            'partner_type_name'     => $partnerTypeName,        
            'partner'               => $partner,
            'user'                  => $user,
            'roles_flags'           => $rolesFlags,
        ]);
    });
    // 
    Route::get('/showsubcription', [SubscriptionController::class,'getAllSubscription']);
    // payment
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/payment/create-qr',        [PaymentController::class, 'create_QR']);
        Route::post('/payment/create-topup-qr',  [PaymentController::class, 'create_TopUp_QR']);
        Route::post('/payment/webhook',          [PaymentController::class, 'webhook']);
        Route::get('/payments/check-status', [PaymentController::class, 'checkStatus']);

    });

    Route::middleware('auth:sanctum')->get(
        '/me/subscription',
        [UserSubscriptionController::class, 'me']
    );
    // artists Client 
    Route::prefix('artists')->group(function () {
        Route::get('/Artists', [ClientArtistsController::class,'getArtist']);
        Route::get('/allArtists', [ClientArtistsController::class,'getAllArtists']);
        Route::post('/add', [ClientArtistsController::class, 'add']);
        Route::post('/search', [ClientArtistsController::class, 'search']);
        Route::get('/statistics', [ClientArtistsController::class, 'statistics']);
        Route::get('/by-partner', [ClientArtistsController::class, 'getArtistByPartnerId']);
        Route::delete('/delete/{artist:id}', [ClientArtistsController::class, 'delete']);
        Route::post('/update/{artist:id}', [ClientArtistsController::class, 'update']);
        Route::middleware('auth:sanctum')->group(function () {
            Route::post('/{artist:id}/follow', [ArtistInteractionController::class, 'follow'])
            ->where('artist', '[0-9]+');
        });
        
        Route::get('/{artist}', [ClientArtistsController::class, 'show']);
    });
    
    // Router songs manager
    Route::prefix('songs')->group(function () {
        Route::get('/{song}/lyrics', [ClientSongsController::class, 'getLyricsSong']);
        Route::get('/allSongs', [ClientSongsController::class, 'index']);

        Route::get('/new', [ClientSongsController::class, 'getNewSongs'])
             ->middleware('optional.auth');
             
        Route::get('/popular', [ClientSongsController::class, 'getPopularSongs'])
            ->middleware('optional.auth');
        
        Route::get('/top-liked', [ClientSongsController::class, 'getTopLikedSongs'])
            ->middleware('optional.auth');

        
        Route::post('/add', [ClientSongsController::class, 'add']);

        Route::get('/by-slug/{slug}', [ClientSongsController::class, 'showBySlug']);
        Route::get('/{id}', [ClientSongsController::class, 'show'])->where('id', '[0-9]+');

        Route::delete('/delete/{song}', [ClientSongsController::class, 'delete']);
        Route::delete('/delete-multiple', [ClientSongsController::class, 'deleteMultiple']);
        Route::post('/update/{song}', [ClientSongsController::class, 'update']);

        // ─── Song Plays ───────────────────────────────────────────────────────
        Route::post('/{song}/play', [ClientSongPlayController::class, 'record']);
        
        // Route::middleware('auth:sanctum')->group(function () {
        //     Route::get('/{song}/plays/stats', [SongPlayController::class, 'stats']);
        // });
    });

    // Lịch sử nghe — đặt ngoài prefix songs vì không liên quan đến 1 bài cụ thể
    Route::middleware('auth:sanctum')->get('/me/history', [ClientSongPlayController::class, 'history']);

    // Router partners type manager
    Route::prefix('partnerTypes')->group(function () {
        Route::get('/',         [ClientTypePartnerController::class, 'getAllTypePartnar']);
        // Route::get('/new',       [ClientSongsController::class, 'getNewSongs']);      
        // Route::get('/popular',   [ClientSongsController::class, 'getPopularSongs']);  
        // Route::post('/add',        [SongsManagerController::class, 'add']);
        // Route::get('/{song}',     [ClientSongsController::class, 'show']);
        // Route::delete('/delete/{song}', [SongsManagerController::class, 'delete']);
        // Route::delete('/delete-multiple', [SongsManagerController::class, 'deleteMultiple']);
        // Route::post('/update/{song}', [SongsManagerController::class, 'update']);
    });
    // // Router partners  manager
    Route::prefix('partners')->group(function () {
        Route::get('/',         [ClientPartnersController::class, 'index']);
        Route::middleware('auth:sanctum')->group(function () {
            Route::post('/add', [ClientPartnersController::class, 'add']);

            // Advertising
            Route::prefix('advertising')->group(function () {
                Route::get('/', [ClientAdvertisingController::class, 'index']);
                Route::post('/store', [ClientAdvertisingController::class, 'store']);
                Route::get('/{advertisement}', [ClientAdvertisingController::class, 'show']);  
                Route::put('/{advertisement}', [ClientAdvertisingController::class, 'update']); 
                Route::patch('/{advertisement}', [ClientAdvertisingController::class, 'update']);
                Route::delete('/{advertisement}', [ClientAdvertisingController::class, 'destroy']);
                Route::patch('/{advertisement}/toggle-status', [ClientAdvertisingController::class, 'toggleStatus']);
            });
        });
    });

    // // Router Genres  manager
    Route::prefix('genres')->group(function () {
        Route::get('/',         [ClientGenresController::class, 'index']);
        Route::get('/{slug}',   [ClientGenresController::class, 'show']);
    });

    Route::middleware('auth:sanctum')->group(function () {
    Route::prefix('songLike')->group(function () {
        Route::post('/{song}/like',  [Songinteractioncontroller::class, 'like'])
             ->where('song', '[0-9]+');
        Route::post('/{song}/share', [SongInteractionController::class, 'share'])
             ->where('song', '[0-9]+');
    });

    // Comments
    Route::post('/comments/{comment}/like', [CommentInteractionController::class, 'like']);

    // Albums
    Route::prefix('albums')->group(function () {
        Route::get('/',         [ClientAlbumsContronller::class, 'index']);
        Route::post('/search',  [ClientAlbumsContronller::class, 'search']);
        Route::post('/add',     [ClientAlbumsContronller::class, 'add']);
        Route::get('/{album}',  [ClientAlbumsContronller::class, 'show']);
        Route::post('/update/{slug}', [ClientAlbumsContronller::class, 'update']);
        Route::put('/{album}/tracks',  [ClientAlbumsContronller::class, 'updateTracks']);
        Route::delete('/delete/{album}', [ClientAlbumsContronller::class, 'destroy']);

        // 
        Route::get('/partner/{partnerId}', [ClientAlbumsContronller::class, 'showAlbumByPartner']);
    });
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
        Route::get('/{artist}', [ArtistsManagerController::class, 'show'])->withTrashed();
        Route::delete('/delete/{artist}', [ArtistsManagerController::class, 'delete'])->withTrashed();
        Route::post('/update/{artist}', [ArtistsManagerController::class, 'update'])->withTrashed();
    });

    // Router songs manager
    Route::prefix('songs')->group(function () {
        Route::get('/',         [SongsManagerController::class, 'index']);
        Route::post('/add',        [SongsManagerController::class, 'add']);
        Route::get('/{song}',     [SongsManagerController::class, 'show']);
        Route::delete('/delete/{song}', [SongsManagerController::class, 'delete']);
        Route::delete('/delete-multiple', [SongsManagerController::class, 'deleteMultiple']);
        Route::post('/update/{song}', [SongsManagerController::class, 'update']);
    });
    
    // Router partners  manager
    Route::prefix('partners')->group(function () {
        // Xem dữ liệu
        Route::get('/', [PartnersManagerController::class, 'index']);
        Route::get('/recent', [PartnersManagerController::class, 'recent']);
        Route::get('/search', [PartnersManagerController::class, 'search']);
        Route::get('/statistics', [PartnersManagerController::class, 'statistics']);
        Route::get('/export', [PartnersManagerController::class, 'export']);
        Route::get('/{id}', [PartnersManagerController::class, 'show']);
        
        // Quản lý trạng thái (admin chỉ được làm cái này)
        Route::patch('/{id}/status', [PartnersManagerController::class, 'updateStatus']);
        Route::post('/bulk-update-status', [PartnersManagerController::class, 'bulkUpdateStatus']);
        
        // Duyệt partner
        Route::post('/{id}/verify', [PartnersManagerController::class, 'verify']);
        
        // Xóa (nếu cần)
        Route::delete('/{id}', [PartnersManagerController::class, 'destroy']);
    });

    // Router genres  manager
    Route::prefix('genres')->group(function () {
        Route::get('/',         [GenresManagerController::class, 'index']);
        Route::post('/add',        [GenresManagerController::class, 'add']);
        Route::get('/{genre}',     [GenresManagerController::class, 'show']);
        Route::post('/update/{genre}',     [GenresManagerController::class, 'update']);
        Route::delete('/delete/{genre}',  [GenresManagerController::class, 'destroy']);
    });

    // Router albums  manager
    Route::prefix('albums')->group(function () {
        Route::get('/',                         [AlbumsManagerController::class, 'index']);
        Route::post('/search',                  [AlbumsManagerController::class, 'search']);
        Route::post('/add',                     [AlbumsManagerController::class, 'add']);
        
        Route::get('/{album}',                  [AlbumsManagerController::class, 'show']);
        Route::post('/update/{album}',          [AlbumsManagerController::class, 'update']);
        Route::put('/{album}/tracks',           [AlbumsManagerController::class, 'updateTracks']);
    });

    // type partner
    Route::prefix('partnerTypes')->group(function () {
        Route::get('/',         [TypePartnerController::class, 'getAllTypePartnar']);
        // Route::get('/new',       [ClientSongsController::class, 'getNewSongs']);      
        // Route::get('/popular',   [ClientSongsController::class, 'getPopularSongs']);  
        // Route::post('/add',        [SongsManagerController::class, 'add']);
        // Route::get('/{song}',     [ClientSongsController::class, 'show']);
        // Route::delete('/delete/{song}', [SongsManagerController::class, 'delete']);
        // Route::delete('/delete-multiple', [SongsManagerController::class, 'deleteMultiple']);
        // Route::post('/update/{song}', [SongsManagerController::class, 'update']);
    });
   
});

// Route 404 fallback
Route::fallback(function() {
    return response()->json([
        'message' => 'Route not found'
    ], 404);
});
<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Validator;
use App\Mail\SendOTP;
use App\Models\User;

class OTPController extends Controller
{
    /**
     * Send the OTP code via email.
     */
    public function sendOTP(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'purpose' => 'required|in:register,login,reset_password,change_email',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $email = $request->email;
        $purpose = $request->purpose;
        $otp = str_pad(random_int(0, 999999), 6, '0', STR_PAD_LEFT);
        $expiryMinutes = 10;

        $cacheKey = 'otp_' . $purpose . '_' . $email;
        Cache::put($cacheKey, [
            'code' => $otp,
            'attempts' => 0,
            'verified' => false
        ], now()->addMinutes($expiryMinutes));

        $user = User::where('email', $email)->first();
        $userName = $user ? $user->name : null;

        try {
            Mail::to($email)->send(new SendOTP($otp, $userName, $expiryMinutes));

            return response()->json([
                'success' => true,
                'message' => 'Mã OTP đã được gửi đến email của bạn',
                'expiry_minutes' => $expiryMinutes,
                'email' => $this->maskEmail($email)
            ]);
        } catch (\Exception $e) {
            \Log::error('Lỗi gửi OTP: ' . $e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Không thể gửi mã OTP. Vui lòng thử lại sau.'
            ], 500);
        }
    }

    /**
     * OTP verification
     */
    public function verifyOTP(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'otp' => 'required|digits:6',
            'purpose' => 'required|in:register,login,reset_password,change_email',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $email = $request->email;
        $otp = $request->otp;
        $purpose = $request->purpose;

        $cacheKey = 'otp_' . $purpose . '_' . $email;
        $cachedOTP = Cache::get($cacheKey);

        if (!$cachedOTP) {
            return response()->json([
                'success' => false,
                'message' => 'Mã OTP không tồn tại hoặc đã hết hạn'
            ], 400);
        }

        // Kiểm tra số lần thử sai
        if ($cachedOTP['attempts'] >= 3) {
            Cache::forget($cacheKey);
            return response()->json([
                'success' => false,
                'message' => 'Đã vượt quá số lần thử. Vui lòng yêu cầu mã OTP mới'
            ], 400);
        }

        // Kiểm tra mã OTP
        if ($cachedOTP['code'] !== $otp) {
            // Tăng số lần thử sai
            $cachedOTP['attempts']++;
            Cache::put($cacheKey, $cachedOTP, now()->addMinutes(5));

            $remainingAttempts = 3 - $cachedOTP['attempts'];

            return response()->json([
                'success' => false,
                'message' => 'Mã OTP không chính xác',
                'remaining_attempts' => $remainingAttempts
            ], 400);
        }

        // Xóa OTP sau khi xác thực thành công
        Cache::forget($cacheKey);

        // Kiểm tra xem user có tồn tại và có phải là admin không
        $user = User::where('email', $email)->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Người dùng không tồn tại'
            ], 400);
        }

        // Kiểm tra role admin
        $roleFlags = $user->getRoleFlags();
        $isAdmin = $roleFlags['is_admin'] || $roleFlags['is_boss'] || $roleFlags['is_content_manager'];

        if (!$isAdmin && $purpose === 'login') {
            return response()->json([
                'success' => false,
                'message' => 'Tài khoản không có quyền truy cập admin'
            ], 403);
        }

        $adminToken = hash('sha256', $email . $otp . time() . uniqid());

        $adminTokenExpiry = 480; // 1 phút để test
        // $adminTokenExpiry = 480; // 8 giờ khi deploy

        Cache::put('admin_token_' . $adminToken, [
            'user_id' => $user->id,
            'email' => $user->email,
            'name' => $user->name,
            'role_flags' => $roleFlags,
            'created_at' => now()->toDateTimeString(),
            'expires_at' => now()->addMinutes($adminTokenExpiry)->toDateTimeString()
        ], now()->addMinutes($adminTokenExpiry));

        return response()->json([
            'success' => true,
            'message' => 'Xác thực OTP thành công',
            'admin_token' => $adminToken,
            'expires_in' => $adminTokenExpiry * 60, // giây
            'user' => [
                'id' => $user->id,
                'email' => $user->email,
                'name' => $user->name
            ]
        ]);
    }

    /**
     * Kiểm tra xem email đã được xác thực chưa
     */
    public function checkVerification(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'purpose' => 'required|in:register,login,reset_password,change_email',
            'token' => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $email = $request->email;
        $purpose = $request->purpose;
        $token = $request->token;

        $cacheKey = 'verified_' . $purpose . '_' . $email;
        $cachedToken = Cache::get($cacheKey);

        if ($cachedToken && $cachedToken === $token) {
            return response()->json([
                'success' => true,
                'verified' => true
            ]);
        }

        return response()->json([
            'success' => false,
            'verified' => false,
            'message' => 'Token xác thực không hợp lệ hoặc đã hết hạn'
        ], 400);
    }

    /**
     * Che email để hiển thị (ví dụ: abc***@gmail.com)
     */
    private function maskEmail($email)
    {
        $parts = explode('@', $email);
        if (count($parts) !== 2) {
            return $email;
        }

        $username = $parts[0];
        $domain = $parts[1];

        if (strlen($username) <= 2) {
            $maskedUsername = substr($username, 0, 1) . '***';
        } else {
            $maskedUsername = substr($username, 0, 2) . '***' . substr($username, -1);
        }

        return $maskedUsername . '@' . $domain;
    }
}

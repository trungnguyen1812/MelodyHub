<?php

namespace App\Helpers;

use Illuminate\Support\Facades\Validator;

class ValidationHelper
{
    /**
     * Validate dữ liệu bằng rules của Laravel
     * @param array $data
     * @param array $rules
     * @param array|null $messages
     * @return \Illuminate\Contracts\Validation\Validator
     */
    public static function make(array $data, array $rules, array $messages = null)
    {
        $defaultMessages = self::defaultMessages();
        $messages = $messages ? array_merge($defaultMessages, $messages) : $defaultMessages;
        return Validator::make($data, $rules, $messages);
    }

    /**
     * Danh sách thông báo mặc định tiếng Việt
     * @return array
     */
    public static function defaultMessages()
    {
        return [
            'required' => ':attribute là bắt buộc.',
            'email' => ':attribute không hợp lệ.',
            'min' => ':attribute phải có ít nhất :min ký tự.',
            'max' => ':attribute không được vượt quá :max ký tự.',
            'numeric' => ':attribute phải là số.',
            'image' => ':attribute phải là hình ảnh.',
            'mimes' => ':attribute phải có định dạng: :values.',
            'unique' => ':attribute đã tồn tại trong hệ thống.',
            'confirmed' => 'Xác nhận :attribute không trùng khớp.',
            'regex' => ':attribute không đúng định dạng.',
            'integer' => ':attribute phải là số nguyên.',
        ];
    }

    /**
     * Thông báo thành công chung
     * @param string $action
     * @return string
     */
    public static function successMessage($action = 'thao tác')
    {
        return "Thực hiện {$action} thành công!";
    }

    /**
     * Thông báo lỗi chung
     * @param string|null $error
     * @return string
     */
    public static function errorMessage($error = null)
    {
        return $error ?: 'Đã xảy ra lỗi, vui lòng thử lại!';
    }

    /**
     * Validate thủ công email
     */
    public static function isValidEmail($email)
    {
        return filter_var($email, FILTER_VALIDATE_EMAIL) !== false;
    }

    /**
     * Validate số điện thoại (Việt Nam)
     */
    public static function isValidPhone($phone)
    {
        return preg_match('/^(0|\+84)[0-9]{9}$/', $phone);
    }

    /**
     * Validate password mạnh
     */
    public static function isStrongPassword($password)
    {
        return preg_match('/^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*#?&]).{8,}$/', $password);
    }
}

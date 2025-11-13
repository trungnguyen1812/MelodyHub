<?php

namespace App\Helpers;

use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class FileUploadHelper
{
    /**
     * Upload file lên storage
     * @param \Illuminate\Http\UploadedFile $file
     * @param string $folder
     * @param string|null $oldFilePath
     * @return string|null
     */
    public static function upload($file, $folder = 'uploads', $oldFilePath = null)
    {
        if (!$file) {
            return $oldFilePath;
        }

        // Xoá file cũ nếu có
        if ($oldFilePath && Storage::exists($oldFilePath)) {
            Storage::delete($oldFilePath);
        }

        // Tạo tên file ngẫu nhiên
        $fileName = time() . '_' . Str::random(10) . '.' . $file->getClientOriginalExtension();

        // Lưu file vào thư mục storage/app/public/$folder
        $filePath = $file->storeAs('public/' . $folder, $fileName);

        // Trả về đường dẫn tương đối (dùng trong DB)
        return $filePath;
    }

    /**
     * Xoá file khỏi storage
     * @param string|null $filePath
     * @return bool
     */
    public static function delete($filePath)
    {
        if ($filePath && Storage::exists($filePath)) {
            return Storage::delete($filePath);
        }
        return false;
    }

    /**
     * Lấy URL public của file
     * @param string|null $filePath
     * @return string|null
     */
    public static function getUrl($filePath)
    {
        return $filePath ? Storage::url($filePath) : null;
    }

    /**
     * Kiểm tra định dạng file
     * @param \Illuminate\Http\UploadedFile $file
     * @param array $allowedExtensions
     * @return bool
     */
    public static function validateExtension($file, $allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'])
    {
        return in_array(strtolower($file->getClientOriginalExtension()), $allowedExtensions);
    }

    /**
     * Kiểm tra kích thước file (theo MB)
     * @param \Illuminate\Http\UploadedFile $file
     * @param int $maxSizeMB
     * @return bool
     */
    public static function validateSize($file, $maxSizeMB = 5)
    {
        return ($file->getSize() / 1024 / 1024) <= $maxSizeMB;
    }
}

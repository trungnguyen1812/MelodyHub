<?php
declare(strict_types=1);

namespace App\Helpers;

use InvalidArgumentException;
use RuntimeException;


/**
 * Class FileHelper
 * Hàm trợ giúp xử lý file (upload, move, delete, đọc/ghi, mime, validate).
 *
 * Sử dụng:
 * - FileHelper::moveUploadedFile($_FILES['file'], '/path/to/dir', ['jpg','png'], 5*1024*1024);
 * - FileHelper::readFile($path);
 */
class FileHelper
{
    /**
     * Đảm bảo thư mục tồn tại, nếu chưa có thì tạo.
     */
    public static function ensureDirectory(string $dir, int $mode = 0755): bool
    {
        if (empty($dir)) {
            throw new InvalidArgumentException('Thư mục không được rỗng.');
        }

        if (is_dir($dir)) {
            return is_writable($dir);
        }

        return mkdir($dir, $mode, true) && chmod($dir, $mode);
    }

    /**
     * Làm sạch tên file tránh path traversal và ký tự lạ.
     */
    public static function sanitizeFilename(string $name): string
    {
        $name = basename($name);
        // thay ký tự không mong muốn bằng dấu gạch ngang
        $name = preg_replace('/[^\w\-.]+/u', '-', $name);
        // loại nhiều dấu gạch ngang liên tiếp
        $name = preg_replace('/-+/', '-', $name);
        return trim($name, '-._');
    }

    /**
     * Tạo tên file duy nhất dựa trên tên gốc và thời gian/ngẫu nhiên.
     */
    public static function generateFilename(string $originalName): string
    {
        $sanitized = self::sanitizeFilename($originalName);
        $ext = pathinfo($sanitized, PATHINFO_EXTENSION);
        $base = pathinfo($sanitized, PATHINFO_FILENAME);
        $uniq = bin2hex(random_bytes(6));
        return $base . '_' . time() . '_' . $uniq . ($ext ? '.' . $ext : '');
    }

    /**
     * Kiểm tra extension có được phép không.
     */
    public static function validateExtension(string $filename, array $allowedExtensions = []): bool
    {
        if (empty($allowedExtensions)) {
            return true;
        }
        $ext = strtolower(pathinfo($filename, PATHINFO_EXTENSION));
        return in_array($ext, array_map('strtolower', $allowedExtensions), true);
    }

    /**
     * Kiểm tra kích thước file.
     */
    public static function validateSize(int $sizeBytes, int $maxBytes): bool
    {
        if ($maxBytes <= 0) {
            return true;
        }
        return $sizeBytes <= $maxBytes;
    }

    /**
     * Lưu file tải lên từ mảng $_FILES vào thư mục đích.
     * Trả về đường dẫn file đã lưu (đầy đủ) nếu thành công, ngược lại ném exception.
     *
     * $file expects keys: tmp_name, name, size, error
     */
    public static function moveUploadedFile(array $file, string $destinationDir, array $allowedExtensions = [], int $maxSizeBytes = 0): string
    {
        if (!isset($file['tmp_name'], $file['name'], $file['error'], $file['size'])) {
            throw new InvalidArgumentException('Mảng file không hợp lệ.');
        }

        if ($file['error'] !== UPLOAD_ERR_OK) {
            throw new RuntimeException('Lỗi upload: ' . $file['error']);
        }

        if (!is_uploaded_file($file['tmp_name'])) {
            throw new RuntimeException('File không phải là uploaded file hợp lệ.');
        }

        if (!self::validateExtension($file['name'], $allowedExtensions)) {
            throw new RuntimeException('Extension không được phép.');
        }

        if (!self::validateSize((int)$file['size'], $maxSizeBytes)) {
            throw new RuntimeException('Kích thước file vượt quá giới hạn.');
        }

        if (!self::ensureDirectory($destinationDir)) {
            throw new RuntimeException('Không thể tạo/ghi thư mục đích.');
        }

        $newName = self::generateFilename($file['name']);
        $destination = rtrim($destinationDir, DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $newName;

        if (!move_uploaded_file($file['tmp_name'], $destination)) {
            throw new RuntimeException('Không thể di chuyển file tới đích.');
        }

        return $destination;
    }

    /**
     * Lưu nội dung từ stream vào đường dẫn đích.
     */
    public static function saveFromStream($stream, string $destinationPath): bool
    {
        if (!is_resource($stream)) {
            throw new InvalidArgumentException('Stream không hợp lệ.');
        }

        $dir = dirname($destinationPath);
        if (!self::ensureDirectory($dir)) {
            throw new RuntimeException('Không thể tạo/ghi thư mục đích.');
        }

        $out = fopen($destinationPath, 'wb');
        if ($out === false) {
            throw new RuntimeException('Không thể mở file để ghi.');
        }

        while (!feof($stream)) {
            $chunk = fread($stream, 8192);
            if ($chunk === false) {
                fclose($out);
                throw new RuntimeException('Lỗi đọc stream.');
            }
            fwrite($out, $chunk);
        }

        fclose($out);
        return true;
    }

    /**
     * Ghi chuỗi vào file (tạo/ghi đè).
     */
    public static function writeFile(string $path, string $content): bool
    {
        $dir = dirname($path);
        if (!self::ensureDirectory($dir)) {
            throw new RuntimeException('Không thể tạo/ghi thư mục đích.');
        }

        $written = file_put_contents($path, $content, LOCK_EX);
        return $written !== false;
    }

    /**
     * Đọc nội dung file, trả về string hoặc null nếu không tồn tại.
     */
    public static function readFile(string $path): ?string
    {
        if (!is_file($path)) {
            return null;
        }
        return file_get_contents($path);
    }

    /**
     * Xoá file nếu tồn tại.
     */
    public static function deleteFile(string $path): bool
    {
        if (!is_file($path)) {
            return false;
        }
        return @unlink($path);
    }

    /**
     * Lấy mime type của file (sử dụng finfo).
     */
    public static function getMimeType(string $path): ?string
    {
        if (!is_file($path)) {
            return null;
        }
        $finfo = new \finfo(FILEINFO_MIME_TYPE);
        return $finfo->file($path) ?: null;
    }

    /**
     * Gửi file để download (header + readfile). Ném exception nếu file không tồn tại.
     * Lưu ý: gọi trước khi đã gửi output.
     */
    public static function download(string $path, ?string $downloadName = null): void
    {
        if (!is_file($path) || !is_readable($path)) {
            throw new RuntimeException('File không tồn tại hoặc không thể đọc.');
        }

        $mime = self::getMimeType($path) ?? 'application/octet-stream';
        $size = filesize($path);
        $name = $downloadName ? self::sanitizeFilename($downloadName) : basename($path);

        header('Content-Description: File Transfer');
        header('Content-Type: ' . $mime);
        header('Content-Disposition: attachment; filename="' . $name . '"');
        header('Content-Transfer-Encoding: binary');
        header('Content-Length: ' . $size);
        header('Cache-Control: must-revalidate');
        header('Pragma: public');
        header('Expires: 0');

        // Clear output buffers
        while (ob_get_level()) {
            ob_end_clean();
        }

        readfile($path);
        exit;
    }
}
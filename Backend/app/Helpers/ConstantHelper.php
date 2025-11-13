<?php
declare(strict_types=1);

namespace App\Helpers;

/**
 * Class ConstantHelper
 *
 * Centralized constants and small helpers for application-wide configuration.
 * Designed to be immutable and available statically.
 */
final class ConstantHelper
{
    // App info
    public const APP_NAME = 'MelodyHub';
    public const APP_VERSION = '1.0.0';

    // Environment
    public const ENV_PRODUCTION = 'production';
    public const ENV_DEVELOPMENT = 'development';
    public const ENV_LOCAL = 'local';

    // Statuses
    public const STATUS_ACTIVE = 1;
    public const STATUS_INACTIVE = 0;
    public const STATUS_DELETED = -1;

    // Roles
    public const ROLE_ADMIN = 'admin';
    public const ROLE_USER = 'user';
    public const ROLE_ARTIST = 'artist';

    // Pagination
    public const DEFAULT_PER_PAGE = 20;
    public const MAX_PER_PAGE = 100;

    // Storage paths (relative to storage or public folder as your app expects)
    public const STORAGE_DISK = 'local';
    public const UPLOAD_DIR = 'uploads';
    public const SONG_DIR = 'uploads/songs';
    public const ARTIST_DIR = 'uploads/artists';
    public const ALBUM_DIR = 'uploads/albums';
    public const COVER_DIR = 'uploads/covers';

    // Allowed file types & sizes
    public const ALLOWED_AUDIO_EXT = ['mp3', 'wav', 'flac', 'm4a', 'aac'];
    public const ALLOWED_IMAGE_EXT = ['jpg', 'jpeg', 'png', 'webp', 'gif'];

    public const ALLOWED_AUDIO_MIME = [
        'audio/mpeg', 'audio/mp3', 'audio/wav', 'audio/x-wav',
        'audio/flac', 'audio/x-flac', 'audio/mp4', 'audio/aac'
    ];
    public const ALLOWED_IMAGE_MIME = [
        'image/jpeg', 'image/png', 'image/webp', 'image/gif'
    ];

    // Sizes in bytes
    public const MAX_AUDIO_SIZE_BYTES = 30 * 1024 * 1024; // 30 MB
    public const MAX_IMAGE_SIZE_BYTES = 5 * 1024 * 1024;  // 5 MB

    // Misc
    public const TIMEZONE = 'UTC';
    public const DEFAULT_LOCALE = 'en';

    // Prevent instantiation
    private function __construct()
    {
    }

    /**
     * Get all constants defined in this class.
     *
     * @return array<string,mixed>
     */
    public static function getAll(): array
    {
        return (new \ReflectionClass(self::class))->getConstants();
    }

    /**
     * Get a constant by name (case-sensitive).
     *
     * @param string $key
     * @param mixed $default
     * @return mixed
     */
    public static function get(string $key, $default = null)
    {
        $consts = self::getAll();
        return $consts[$key] ?? $default;
    }

    /**
     * Check if an audio mime type is allowed.
     */
    public static function isAllowedAudioMime(string $mime): bool
    {
        return in_array(strtolower($mime), array_map('strtolower', self::ALLOWED_AUDIO_MIME), true);
    }

    /**
     * Check if an image mime type is allowed.
     */
    public static function isAllowedImageMime(string $mime): bool
    {
        return in_array(strtolower($mime), array_map('strtolower', self::ALLOWED_IMAGE_MIME), true);
    }

    /**
     * Check if an extension is allowed for a given type.
     *
     * @param string $ext Extension without dot, e.g. "mp3"
     * @param string $type "audio" or "image"
     */
    public static function isAllowedExtension(string $ext, string $type = 'audio'): bool
    {
        $ext = ltrim(strtolower($ext), '.');
        if ($type === 'image') {
            return in_array($ext, array_map('strtolower', self::ALLOWED_IMAGE_EXT), true);
        }
        // default to audio
        return in_array($ext, array_map('strtolower', self::ALLOWED_AUDIO_EXT), true);
    }

    /**
     * Validate file size for given type.
     *
     * @param int $sizeBytes
     * @param string $type "audio" or "image"
     */
    public static function isValidSize(int $sizeBytes, string $type = 'audio'): bool
    {
        if ($type === 'image') {
            return $sizeBytes > 0 && $sizeBytes <= self::MAX_IMAGE_SIZE_BYTES;
        }
        return $sizeBytes > 0 && $sizeBytes <= self::MAX_AUDIO_SIZE_BYTES;
    }
}
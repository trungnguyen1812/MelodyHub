<?php
namespace App\Helpers;

/**
 * AuthHelper
 * - Session + optional simple JWT "remember" support
 * - Minimal, framework-agnostic helper for authentication tasks
 *
 * Usage examples (very simple):
 * - AuthHelper::attempt(['email' => 'a@b.com', 'password' => 'pass'], function($email){ return User::findByEmail($email); });
 * - AuthHelper::user();
 * - AuthHelper::logout();
 */
class AuthHelper
{
    protected const SESSION_USER_KEY = 'auth_user';
    protected const SESSION_TOKENS_KEY = 'auth_tokens';
    protected const COOKIE_NAME = 'auth_token';
    protected const DEFAULT_SECRET = 'change_this_secret';

    protected static function ensureSession(): void
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
    }

    // Password helpers
    public static function hashPassword(string $password): string
    {
        return password_hash($password, PASSWORD_DEFAULT);
    }

    public static function verifyPassword(string $password, string $hash): bool
    {
        return password_verify($password, $hash);
    }

    /**
     * Attempt to authenticate using credentials.
     * $getUserByIdentifier: callable($identifierValue) -> null|object|array (user record)
     * Must return a user record that includes a password hash (key 'password' or property 'password').
     */
    public static function attempt(array $credentials, callable $getUserByIdentifier, string $identifierKey = 'email', string $passwordKey = 'password', bool $remember = false): bool
    {
        $identifier = $credentials[$identifierKey] ?? null;
        $password = $credentials[$passwordKey] ?? null;
        if (!$identifier || !$password) {
            return false;
        }

        $user = $getUserByIdentifier($identifier);
        if (!$user) {
            return false;
        }

        $storedHash = null;
        if (is_array($user) && isset($user[$passwordKey])) {
            $storedHash = $user[$passwordKey];
        } elseif (is_object($user) && isset($user->{$passwordKey})) {
            $storedHash = $user->{$passwordKey};
        }

        if (!$storedHash) {
            return false;
        }

        if (!self::verifyPassword($password, $storedHash)) {
            return false;
        }

        self::loginUser($user, $remember);
        return true;
    }

    // Log a user in (store in session). $user can be array or object (serializable).
    public static function loginUser($user, bool $remember = false, int $rememberSeconds = 60 * 60 * 24 * 30): void
    {
        self::ensureSession();
        $_SESSION[self::SESSION_USER_KEY] = $user;

        if ($remember) {
            $secret = getenv('APP_KEY') ?: self::DEFAULT_SECRET;
            $payload = [
                'user' => $user,
                'iat'  => time(),
                'exp'  => time() + $rememberSeconds,
            ];
            $token = self::generateToken($payload, $secret, $rememberSeconds);
            // persist token server-side (simple mapping) so we can revoke easily
            if (!isset($_SESSION[self::SESSION_TOKENS_KEY]) || !is_array($_SESSION[self::SESSION_TOKENS_KEY])) {
                $_SESSION[self::SESSION_TOKENS_KEY] = [];
            }
            $_SESSION[self::SESSION_TOKENS_KEY][$token] = $payload;
            setcookie(self::COOKIE_NAME, $token, time() + $rememberSeconds, '/', '', self::isHttps(), true);
        }
    }

    public static function logout(): void
    {
        self::ensureSession();
        // remove token mapping if cookie present
        if (!empty($_COOKIE[self::COOKIE_NAME])) {
            $token = $_COOKIE[self::COOKIE_NAME];
            if (isset($_SESSION[self::SESSION_TOKENS_KEY][$token])) {
                unset($_SESSION[self::SESSION_TOKENS_KEY][$token]);
            }
            setcookie(self::COOKIE_NAME, '', time() - 3600, '/', '', self::isHttps(), true);
            unset($_COOKIE[self::COOKIE_NAME]);
        }

        if (isset($_SESSION[self::SESSION_USER_KEY])) {
            unset($_SESSION[self::SESSION_USER_KEY]);
        }
    }

    // Current authenticated user or null
    public static function user()
    {
        self::ensureSession();
        if (!empty($_SESSION[self::SESSION_USER_KEY])) {
            return $_SESSION[self::SESSION_USER_KEY];
        }

        // Try cookie token fallback
        if (!empty($_COOKIE[self::COOKIE_NAME])) {
            $token = $_COOKIE[self::COOKIE_NAME];
            $secret = getenv('APP_KEY') ?: self::DEFAULT_SECRET;
            $payload = self::verifyToken($token, $secret);
            if ($payload && isset($payload['user'])) {
                // ensure token still exists server-side
                if (!empty($_SESSION[self::SESSION_TOKENS_KEY][$token])) {
                    // restore to session for convenience
                    $_SESSION[self::SESSION_USER_KEY] = $payload['user'];
                    return $payload['user'];
                }
            }
        }

        return null;
    }

    public static function check(): bool
    {
        return (bool) self::user();
    }

    public static function guest(): bool
    {
        return !self::check();
    }

    // Simple JWT-like functions (no external deps)
    public static function generateToken(array $payload, string $secret = null, int $expiry = 3600): string
    {
        $secret = $secret ?: (getenv('APP_KEY') ?: self::DEFAULT_SECRET);

        $header = ['alg' => 'HS256', 'typ' => 'JWT'];
        $payload['iat'] = $payload['iat'] ?? time();
        $payload['exp'] = $payload['exp'] ?? ($payload['iat'] + $expiry);

        $segments = [];
        $segments[] = self::base64UrlEncode(json_encode($header));
        $segments[] = self::base64UrlEncode(json_encode($payload));
        $signingInput = implode('.', $segments);
        $signature = hash_hmac('sha256', $signingInput, $secret, true);
        $segments[] = self::base64UrlEncode($signature);
        return implode('.', $segments);
    }

    public static function verifyToken(string $token, string $secret = null): ?array
    {
        $secret = $secret ?: (getenv('APP_KEY') ?: self::DEFAULT_SECRET);
        $parts = explode('.', $token);
        if (count($parts) !== 3) {
            return null;
        }

        [$h64, $p64, $s64] = $parts;
        $header = json_decode(self::base64UrlDecode($h64), true);
        $payload = json_decode(self::base64UrlDecode($p64), true);
        $signature = self::base64UrlDecode($s64);

        if (!$payload || !is_array($payload)) {
            return null;
        }

        $signingInput = $h64 . '.' . $p64;
        $expected = hash_hmac('sha256', $signingInput, $secret, true);
        if (!hash_equals($expected, $signature)) {
            return null;
        }

        if (isset($payload['exp']) && time() > (int)$payload['exp']) {
            return null;
        }

        return $payload;
    }

    // Helpers
    protected static function base64UrlEncode(string $data): string
    {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }

    protected static function base64UrlDecode(string $data): string
    {
        $remainder = strlen($data) % 4;
        if ($remainder) {
            $padlen = 4 - $remainder;
            $data .= str_repeat('=', $padlen);
        }
        return base64_decode(strtr($data, '-_', '+/'));
    }

    protected static function isHttps(): bool
    {
        if (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') {
            return true;
        }
        if (!empty($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
            return true;
        }
        return false;
    }


}
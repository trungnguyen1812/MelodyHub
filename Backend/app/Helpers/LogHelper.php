<?php

namespace App\Helpers;

use Illuminate\Support\Facades\Log;


class LogHelper
{
    /**
     * Ghi log thông tin.
     *
     * @param string $message
     * @param array $context
     */
    public static function info($message, array $context = [])
    {
        Log::info($message, $context);
    }

    /**
     * Ghi log cảnh báo.
     *
     * @param string $message
     * @param array $context
     */
    public static function warning($message, array $context = [])
    {
        Log::warning($message, $context);
    }

    /**
     * Ghi log lỗi.
     *
     * @param string $message
     * @param array $context
     */
    public static function error($message, array $context = [])
    {
        Log::error($message, $context);
    }

    /**
     * Ghi log debug.
     *
     * @param string $message
     * @param array $context
     */
    public static function debug($message, array $context = [])
    {
        Log::debug($message, $context);
    }
}
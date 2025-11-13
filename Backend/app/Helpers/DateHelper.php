<?php
declare(strict_types=1);

namespace App\Helpers;

use Carbon\Carbon;
use Carbon\Exceptions\InvalidFormatException;


/**
 * Class DateHelper
 * Các hàm tiện ích xử lý ngày giờ (sử dụng Carbon)
 */
final class DateHelper
{
    private function __construct() {}

    /**
     * Lấy timezone mặc định nếu không truyền
     */
    private static function tz(?string $tz): string
    {
        return $tz ?? date_default_timezone_get();
    }

    /**
     * Trả về thời điểm hiện tại (Carbon)
     */
    public static function now(?string $tz = null): Carbon
    {
        return Carbon::now(self::tz($tz));
    }

    /**
     * Parse một giá trị date/time thành Carbon hoặc null nếu không hợp lệ
     */
    public static function parse($input, ?string $tz = null): ?Carbon
    {
        if ($input instanceof Carbon) {
            return $input->copy()->setTimezone(self::tz($tz));
        }

        if ($input === null || $input === '') {
            return null;
        }

        try {
            return Carbon::parse($input, self::tz($tz));
        } catch (InvalidFormatException $e) {
            return null;
        }
    }

    /**
     * Kiểm tra xem input có phải là ngày hợp lệ không
     */
    public static function isValidDate($input): bool
    {
        return self::parse($input) !== null;
    }

    /**
     * Format ngày/thời gian, trả về null nếu không parse được
     */
    public static function formatDate($input, string $format = 'Y-m-d', ?string $tz = null): ?string
    {
        $dt = self::parse($input, $tz);
        return $dt ? $dt->format($format) : null;
    }

    /**
     * Format ngày giờ đầy đủ mặc định 'Y-m-d H:i:s'
     */
    public static function formatDateTime($input, string $format = 'Y-m-d H:i:s', ?string $tz = null): ?string
    {
        return self::formatDate($input, $format, $tz);
    }

    /**
     * Chuyển sang ISO 8601
     */
    public static function toIso8601($input, ?string $tz = null): ?string
    {
        $dt = self::parse($input, $tz);
        return $dt ? $dt->toIso8601String() : null;
    }

    /**
     * Bắt đầu ngày (00:00:00)
     */
    public static function startOfDay($input, ?string $tz = null): ?Carbon
    {
        $dt = self::parse($input, $tz);
        return $dt ? $dt->startOfDay() : null;
    }

    /**
     * Kết thúc ngày (23:59:59)
     */
    public static function endOfDay($input, ?string $tz = null): ?Carbon
    {
        $dt = self::parse($input, $tz);
        return $dt ? $dt->endOfDay() : null;
    }

    /**
     * Thêm ngày (positive) hoặc trừ ngày (negative)
     */
    public static function addDays($input, int $days, ?string $tz = null): ?Carbon
    {
        $dt = self::parse($input, $tz);
        return $dt ? $dt->addDays($days) : null;
    }

    /**
     * Thêm tháng (positive) hoặc trừ tháng (negative)
     */
    public static function addMonths($input, int $months, ?string $tz = null): ?Carbon
    {
        $dt = self::parse($input, $tz);
        return $dt ? $dt->addMonths($months) : null;
    }

    /**
     * Khoảng cách giữa 2 ngày theo số ngày nguyên
     */
    public static function diffInDays($dateA, $dateB, bool $absolute = true): ?int
    {
        $a = self::parse($dateA);
        $b = self::parse($dateB);
        if (! $a || ! $b) {
            return null;
        }
        return (int) $a->diffInDays($b, $absolute);
    }

    /**
     * Trả về chuỗi "cách đây" (human readable), hỗ trợ locale (vd 'vi' or 'en')
     */
    public static function humanDiff($date, $other = 'now', string $locale = 'vi'): ?string
    {
        $d1 = self::parse($date);
        $d2 = $other === 'now' ? self::now() : self::parse($other);
        if (! $d1 || ! $d2) {
            return null;
        }
        try {
            $d1->locale($locale);
            return $d1->diffForHumans($d2);
        } catch (\Throwable $e) {
            return $d1->diffForHumans($d2);
        }
    }

    /**
     * Lấy khoảng tuần chứa ngày (start, end)
     * Trả về mảng ['start' => Carbon, 'end' => Carbon]
     */
    public static function getWeekRange($input, ?string $tz = null, int $startOfWeek = Carbon::MONDAY): ?array
    {
        $dt = self::parse($input, $tz);
        if (! $dt) {
            return null;
        }
        $start = $dt->copy()->startOfWeek($startOfWeek);
        $end = $dt->copy()->endOfWeek($startOfWeek);
        return ['start' => $start, 'end' => $end];
    }

    /**
     * Lấy khoảng tháng chứa ngày (start, end)
     */
    public static function getMonthRange($input, ?string $tz = null): ?array
    {
        $dt = self::parse($input, $tz);
        if (! $dt) {
            return null;
        }
        return [
            'start' => $dt->copy()->startOfMonth(),
            'end' => $dt->copy()->endOfMonth(),
        ];
    }

    /**
     * Lấy khoảng quý chứa ngày (start, end) và số quý
     */
    public static function getQuarterRange($input, ?string $tz = null): ?array
    {
        $dt = self::parse($input, $tz);
        if (! $dt) {
            return null;
        }
        $quarter = (int) ceil($dt->month / 3);
        $startMonth = ($quarter - 1) * 3 + 1;
        $start = $dt->copy()->month($startMonth)->startOfMonth();
        $end = $start->copy()->addMonths(2)->endOfMonth();
        return [
            'quarter' => $quarter,
            'start' => $start,
            'end' => $end,
        ];
    }
}
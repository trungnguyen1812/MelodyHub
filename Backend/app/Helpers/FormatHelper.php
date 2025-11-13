<?php

namespace App\Helpers;

use Carbon\Carbon;
use Illuminate\Support\Str;

class FormatHelper
{
    /**
     * ============================================
     * CONFIGURATION - Cấu hình tổng thể
     * ============================================
     */
    private static $config = [
        // Locale settings
        'locale' => 'vi_VN',
        'timezone' => 'Asia/Ho_Chi_Minh',
        'fallback_locale' => 'en_US',
        
        // Currency settings
        'currency' => 'VND',
        'currency_symbol' => '₫',
        'currency_position' => 'after', // before or after
        'currency_space' => true,
        
        // Number settings
        'decimal_separator' => ',',
        'thousands_separator' => '.',
        'default_decimals' => 2,
        
        // Date settings
        'date_format' => 'd/m/Y',
        'time_format' => 'H:i:s',
        'datetime_format' => 'd/m/Y H:i:s',
        'human_date_threshold' => 7, // days
        
        // String settings
        'truncate_suffix' => '...',
        'slug_separator' => '-',
        'slug_lowercase' => true,
    ];

    /**
     * Cập nhật cấu hình
     */
    public static function configure(array $config)
    {
        self::$config = array_merge(self::$config, $config);
    }

    /**
     * Lấy giá trị cấu hình
     */
    public static function getConfig($key = null, $default = null)
    {
        if ($key === null) {
            return self::$config;
        }
        
        return self::$config[$key] ?? $default;
    }

    /**
     * ============================================
     * STRING FORMATTING
     * ============================================
     */

    /**
     * Cắt ngắn chuỗi
     */
    public static function truncate($string, $length = 100, $suffix = null)
    {
        $suffix = $suffix ?? self::$config['truncate_suffix'];
        
        if (mb_strlen($string) <= $length) {
            return $string;
        }
        
        return mb_substr($string, 0, $length) . $suffix;
    }

    /**
     * Cắt ngắn giữ nguyên từ
     */
    public static function truncateWords($string, $words = 50, $suffix = null)
    {
        $suffix = $suffix ?? self::$config['truncate_suffix'];
        $wordsArray = preg_split('/\s+/', $string);
        
        if (count($wordsArray) <= $words) {
            return $string;
        }
        
        return implode(' ', array_slice($wordsArray, 0, $words)) . $suffix;
    }

    /**
     * Chuyển thành slug
     */
    public static function slug($string, $separator = null, $lowercase = null)
    {
        $separator = $separator ?? self::$config['slug_separator'];
        $lowercase = $lowercase ?? self::$config['slug_lowercase'];
        
        // Chuyển đổi Unicode Vietnamese
        $string = self::removeVietnameseAccents($string);
        
        // Chuyển thành slug
        $slug = Str::slug($string, $separator);
        
        return $lowercase ? Str::lower($slug) : $slug;
    }

    /**
     * Bỏ dấu tiếng Việt
     */
    public static function removeVietnameseAccents($string)
    {
        $vietnamese = [
            'à', 'á', 'ạ', 'ả', 'ã', 'â', 'ầ', 'ấ', 'ậ', 'ẩ', 'ẫ', 'ă', 'ằ', 'ắ', 'ặ', 'ẳ', 'ẵ',
            'è', 'é', 'ẹ', 'ẻ', 'ẽ', 'ê', 'ề', 'ế', 'ệ', 'ể', 'ễ',
            'ì', 'í', 'ị', 'ỉ', 'ĩ',
            'ò', 'ó', 'ọ', 'ỏ', 'õ', 'ô', 'ồ', 'ố', 'ộ', 'ổ', 'ỗ', 'ơ', 'ờ', 'ớ', 'ợ', 'ở', 'ỡ',
            'ù', 'ú', 'ụ', 'ủ', 'ũ', 'ư', 'ừ', 'ứ', 'ự', 'ử', 'ữ',
            'ỳ', 'ý', 'ỵ', 'ỷ', 'ỹ',
            'đ',
            'À', 'Á', 'Ạ', 'Ả', 'Ã', 'Â', 'Ầ', 'Ấ', 'Ậ', 'Ẩ', 'Ẫ', 'Ă', 'Ằ', 'Ắ', 'Ặ', 'Ẳ', 'Ẵ',
            'È', 'É', 'Ẹ', 'Ẻ', 'Ẽ', 'Ê', 'Ề', 'Ế', 'Ệ', 'Ể', 'Ễ',
            'Ì', 'Í', 'Ị', 'Ỉ', 'Ĩ',
            'Ò', 'Ó', 'Ọ', 'Ỏ', 'Õ', 'Ô', 'Ồ', 'Ố', 'Ộ', 'Ổ', 'Ỗ', 'Ơ', 'Ờ', 'Ớ', 'Ợ', 'Ở', 'Ỡ',
            'Ù', 'Ú', 'Ụ', 'Ủ', 'Ũ', 'Ư', 'Ừ', 'Ứ', 'Ự', 'Ử', 'Ữ',
            'Ỳ', 'Ý', 'Ỵ', 'Ỷ', 'Ỹ',
            'Đ'
        ];
        
        $ascii = [
            'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a',
            'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e',
            'i', 'i', 'i', 'i', 'i',
            'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o',
            'u', 'u', 'u', 'u', 'u', 'u', 'u', 'u', 'u', 'u', 'u',
            'y', 'y', 'y', 'y', 'y',
            'd',
            'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A',
            'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E',
            'I', 'I', 'I', 'I', 'I',
            'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O',
            'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U', 'U',
            'Y', 'Y', 'Y', 'Y', 'Y',
            'D'
        ];
        
        return str_replace($vietnamese, $ascii, $string);
    }

    /**
     * Viết hoa chữ cái đầu mỗi từ
     */
    public static function title($string)
    {
        return mb_convert_case($string, MB_CASE_TITLE, 'UTF-8');
    }

    /**
     * Capitalize - viết hoa chữ cái đầu
     */
    public static function capitalize($string)
    {
        return mb_strtoupper(mb_substr($string, 0, 1)) . mb_substr($string, 1);
    }

    /**
     * Mask chuỗi (ẩn thông tin nhạy cảm)
     */
    public static function mask($string, $char = '*', $percent = 50)
    {
        $length = mb_strlen($string);
        $maskLength = (int) ($length * $percent / 100);
        $start = (int) (($length - $maskLength) / 2);
        
        return mb_substr($string, 0, $start) . 
               str_repeat($char, $maskLength) . 
               mb_substr($string, $start + $maskLength);
    }

    /**
     * Mask email
     */
    public static function maskEmail($email)
    {
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            return $email;
        }
        
        list($username, $domain) = explode('@', $email);
        $maskedUsername = mb_substr($username, 0, 2) . '***' . mb_substr($username, -1);
        
        return $maskedUsername . '@' . $domain;
    }

    /**
     * Mask số điện thoại
     */
    public static function maskPhone($phone)
    {
        $length = strlen($phone);
        return substr($phone, 0, 3) . str_repeat('*', $length - 6) . substr($phone, -3);
    }

    /**
     * ============================================
     * NUMBER FORMATTING
     * ============================================
     */

    /**
     * Format số với separator
     */
    public static function number($number, $decimals = null, $decimalSep = null, $thousandsSep = null)
    {
        $decimals = $decimals ?? self::$config['default_decimals'];
        $decimalSep = $decimalSep ?? self::$config['decimal_separator'];
        $thousandsSep = $thousandsSep ?? self::$config['thousands_separator'];
        
        return number_format($number, $decimals, $decimalSep, $thousandsSep);
    }

    /**
     * Format tiền tệ
     */
    public static function currency($amount, $currency = null, $decimals = 0)
    {
        $currency = $currency ?? self::$config['currency'];
        $symbol = self::getCurrencySymbol($currency);
        $formatted = self::number($amount, $decimals);
        $space = self::$config['currency_space'] ? ' ' : '';
        
        if (self::$config['currency_position'] === 'before') {
            return $symbol . $space . $formatted;
        }
        
        return $formatted . $space . $symbol;
    }

    /**
     * Lấy ký hiệu tiền tệ
     */
    private static function getCurrencySymbol($currency)
    {
        $symbols = [
            'VND' => '₫',
            'USD' => '$',
            'EUR' => '€',
            'GBP' => '£',
            'JPY' => '¥',
            'CNY' => '¥',
            'KRW' => '₩',
            'THB' => '฿',
        ];
        
        return $symbols[$currency] ?? $currency;
    }

    /**
     * Format phần trăm
     */
    public static function percent($number, $decimals = 2)
    {
        return self::number($number, $decimals) . '%';
    }

    /**
     * Format số lớn (K, M, B)
     */
    public static function shortNumber($number, $decimals = 1)
    {
        if ($number < 1000) {
            return (string) $number;
        }
        
        $units = ['', 'K', 'M', 'B', 'T'];
        $power = floor(log($number, 1000));
        $value = $number / pow(1000, $power);
        
        return self::number($value, $decimals) . $units[$power];
    }

    /**
     * Format dung lượng file
     */
    public static function fileSize($bytes, $decimals = 2)
    {
        if ($bytes < 1024) {
            return $bytes . ' B';
        }
        
        $units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
        $power = floor(log($bytes, 1024));
        $value = $bytes / pow(1024, $power);
        
        return self::number($value, $decimals) . ' ' . $units[$power];
    }

    /**
     * Format số thứ tự (1st, 2nd, 3rd)
     */
    public static function ordinal($number)
    {
        $ends = ['th', 'st', 'nd', 'rd', 'th', 'th', 'th', 'th', 'th', 'th'];
        
        if ((($number % 100) >= 11) && (($number % 100) <= 13)) {
            return $number . 'th';
        }
        
        return $number . $ends[$number % 10];
    }

    /**
     * Format số điện thoại Việt Nam
     */
    public static function phoneVN($phone)
    {
        $phone = preg_replace('/[^0-9]/', '', $phone);
        
        if (strlen($phone) == 10) {
            return preg_replace('/(\d{4})(\d{3})(\d{3})/', '$1 $2 $3', $phone);
        } elseif (strlen($phone) == 11) {
            return preg_replace('/(\d{4})(\d{3})(\d{4})/', '$1 $2 $3', $phone);
        }
        
        return $phone;
    }

    /**
     * ============================================
     * DATE & TIME FORMATTING
     * ============================================
     */

    /**
     * Format ngày tháng
     */
    public static function date($date, $format = null)
    {
        if (!$date) return null;
        
        $format = $format ?? self::$config['date_format'];
        $carbon = $date instanceof Carbon ? $date : Carbon::parse($date);
        
        return $carbon->timezone(self::$config['timezone'])->format($format);
    }

    /**
     * Format giờ
     */
    public static function time($time, $format = null)
    {
        if (!$time) return null;
        
        $format = $format ?? self::$config['time_format'];
        $carbon = $time instanceof Carbon ? $time : Carbon::parse($time);
        
        return $carbon->timezone(self::$config['timezone'])->format($format);
    }

    /**
     * Format ngày giờ
     */
    public static function datetime($datetime, $format = null)
    {
        if (!$datetime) return null;
        
        $format = $format ?? self::$config['datetime_format'];
        $carbon = $datetime instanceof Carbon ? $datetime : Carbon::parse($datetime);
        
        return $carbon->timezone(self::$config['timezone'])->format($format);
    }

    /**
     * Format ngày giờ dễ đọc (human)
     */
    public static function dateHuman($date, $threshold = null)
    {
        if (!$date) return null;
        
        $threshold = $threshold ?? self::$config['human_date_threshold'];
        $carbon = $date instanceof Carbon ? $date : Carbon::parse($date);
        $carbon->timezone(self::$config['timezone']);
        
        $now = Carbon::now(self::$config['timezone']);
        $diffInDays = $carbon->diffInDays($now);
        
        if ($diffInDays <= $threshold) {
            return $carbon->locale(self::$config['locale'])->diffForHumans();
        }
        
        return self::date($carbon);
    }

    /**
     * Format khoảng thời gian
     */
    public static function dateRange($startDate, $endDate, $separator = ' - ')
    {
        if (!$startDate || !$endDate) return null;
        
        return self::date($startDate) . $separator . self::date($endDate);
    }

    /**
     * Format ngày sinh thành tuổi
     */
    public static function age($birthdate)
    {
        if (!$birthdate) return null;
        
        $carbon = $birthdate instanceof Carbon ? $birthdate : Carbon::parse($birthdate);
        return $carbon->age . ' tuổi';
    }

    /**
     * Relative time (2 giờ trước, 3 ngày trước)
     */
    public static function timeAgo($datetime)
    {
        if (!$datetime) return null;
        
        $carbon = $datetime instanceof Carbon ? $datetime : Carbon::parse($datetime);
        return $carbon->locale(self::$config['locale'])
                     ->timezone(self::$config['timezone'])
                     ->diffForHumans();
    }

    /**
     * Format thành calendar date
     */
    public static function calendar($datetime)
    {
        if (!$datetime) return null;
        
        $carbon = $datetime instanceof Carbon ? $datetime : Carbon::parse($datetime);
        return $carbon->locale(self::$config['locale'])
                     ->timezone(self::$config['timezone'])
                     ->calendar();
    }

    /**
     * ============================================
     * UTILITY METHODS
     * ============================================
     */

    /**
     * Format địa chỉ Việt Nam
     */
    public static function addressVN($street, $ward, $district, $city)
    {
        $parts = array_filter([$street, $ward, $district, $city]);
        return implode(', ', $parts);
    }

    /**
     * Format boolean thành text
     */
    public static function boolean($value, $trueText = 'Có', $falseText = 'Không')
    {
        return $value ? $trueText : $falseText;
    }

    /**
     * Format array thành chuỗi
     */
    public static function listItems($array, $separator = ', ', $lastSeparator = ' và ')
    {
        if (empty($array)) return '';
        if (count($array) === 1) return $array[0];
        
        $last = array_pop($array);
        return implode($separator, $array) . $lastSeparator . $last;
    }

    /**
     * Format CMND/CCCD
     */
    public static function idCard($number)
    {
        $number = preg_replace('/[^0-9]/', '', $number);
        
        if (strlen($number) == 9) {
            return preg_replace('/(\d{3})(\d{3})(\d{3})/', '$1 $2 $3', $number);
        } elseif (strlen($number) == 12) {
            return preg_replace('/(\d{3})(\d{3})(\d{3})(\d{3})/', '$1 $2 $3 $4', $number);
        }
        
        return $number;
    }

    /**
     * Preset configurations
     */
    public static function presetVN()
    {
        self::configure([
            'locale' => 'vi_VN',
            'timezone' => 'Asia/Ho_Chi_Minh',
            'currency' => 'VND',
            'currency_symbol' => '₫',
            'currency_position' => 'after',
            'decimal_separator' => ',',
            'thousands_separator' => '.',
            'date_format' => 'd/m/Y',
        ]);
    }

    public static function presetUS()
    {
        self::configure([
            'locale' => 'en_US',
            'timezone' => 'America/New_York',
            'currency' => 'USD',
            'currency_symbol' => '$',
            'currency_position' => 'before',
            'decimal_separator' => '.',
            'thousands_separator' => ',',
            'date_format' => 'm/d/Y',
        ]);
    }
}
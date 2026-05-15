<?php

namespace App\Rules;

use App\Models\Artist;
use Closure;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Support\Facades\Log;

class UniqueArtistName implements ValidationRule
{
    private const SIMILARITY_THRESHOLD = 80; // % giống nhau thì chặn

    public function __construct(private ?int $ignoreId = null) {}

    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        Log::info('UniqueArtistName running for: ' . $value);

        $normalized = $this->normalize($value);

        // Chỉ query tên, không load toàn bộ model
        $artists = Artist::select('id', 'name')
            ->when($this->ignoreId, fn($q) => $q->where('id', '!=', $this->ignoreId))
            ->get();

        foreach ($artists as $artist) {
            $existingNormalized = $this->normalize($artist->name);

            // Check exact match sau normalize
            if ($normalized === $existingNormalized) {
                Log::warning("Exact match blocked: {$value} ~ {$artist->name}");
                $fail("The artist's name is too similar to \"{$artist->name}\" already existed.");
                return;
            }

            // Check similarity bằng similar_text
            similar_text($normalized, $existingNormalized, $percent);

            if ($percent >= self::SIMILARITY_THRESHOLD) {
                Log::warning("Similarity {$percent}% blocked: {$value} ~ {$artist->name}");
                $fail("The artist's name is too similar to \"{$artist->name}\" ({$percent}%). If this is a different artist, please contact the admin..");
                return;
            }
        }
    }

    private function normalize(string $name): string
    {
        $name = mb_strtolower($name, 'UTF-8');
        $name = $this->removeAccents($name);
        // Giữ lại khoảng trắng để similar_text hoạt động tốt hơn
        $name = preg_replace('/[^a-z0-9\s]/', '', $name);
        $name = preg_replace('/\s+/', ' ', trim($name));
        return $name;
    }

    private function removeAccents(string $str): string
    {
        $map = [
            'à'=>'a','á'=>'a','â'=>'a','ã'=>'a','ä'=>'a','å'=>'a',
            'ă'=>'a','ắ'=>'a','ặ'=>'a','ằ'=>'a','ẳ'=>'a','ẵ'=>'a',
            'ấ'=>'a','ậ'=>'a','ầ'=>'a','ẩ'=>'a','ẫ'=>'a',
            'è'=>'e','é'=>'e','ê'=>'e','ë'=>'e',
            'ế'=>'e','ệ'=>'e','ề'=>'e','ể'=>'e','ễ'=>'e',
            'ì'=>'i','í'=>'i','î'=>'i','ï'=>'i',
            'ò'=>'o','ó'=>'o','ô'=>'o','õ'=>'o','ö'=>'o',
            'ố'=>'o','ộ'=>'o','ồ'=>'o','ổ'=>'o','ỗ'=>'o',
            'ơ'=>'o','ớ'=>'o','ợ'=>'o','ờ'=>'o','ở'=>'o','ỡ'=>'o',
            'ù'=>'u','ú'=>'u','û'=>'u','ü'=>'u',
            'ư'=>'u','ứ'=>'u','ự'=>'u','ừ'=>'u','ử'=>'u','ữ'=>'u',
            'ỳ'=>'y','ý'=>'y','ỵ'=>'y','ỷ'=>'y','ỹ'=>'y',
            'đ'=>'d','ñ'=>'n','ç'=>'c','ß'=>'ss',
            'À'=>'a','Á'=>'a','Â'=>'a','Ã'=>'a','Ă'=>'a',
            'Ắ'=>'a','Ặ'=>'a','Ằ'=>'a','Ẳ'=>'a','Ẵ'=>'a',
            'Ấ'=>'a','Ậ'=>'a','Ầ'=>'a','Ẩ'=>'a','Ẫ'=>'a',
            'È'=>'e','É'=>'e','Ê'=>'e','Ế'=>'e','Ệ'=>'e',
            'Ề'=>'e','Ể'=>'e','Ễ'=>'e',
            'Ì'=>'i','Í'=>'i','Î'=>'i',
            'Ò'=>'o','Ó'=>'o','Ô'=>'o','Ố'=>'o','Ộ'=>'o',
            'Ồ'=>'o','Ổ'=>'o','Ỗ'=>'o','Ơ'=>'o','Ớ'=>'o',
            'Ợ'=>'o','Ờ'=>'o','Ở'=>'o','Ỡ'=>'o',
            'Ù'=>'u','Ú'=>'u','Û'=>'u','Ư'=>'u','Ứ'=>'u',
            'Ự'=>'u','Ừ'=>'u','Ử'=>'u','Ữ'=>'u',
            'Ỳ'=>'y','Ý'=>'y','Ỵ'=>'y','Ỷ'=>'y','Ỹ'=>'y',
            'Đ'=>'d',
        ];
        return strtr($str, $map);
    }
}
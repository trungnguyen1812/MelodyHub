<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Str;

class UserSlugService
{
    public static function generate(string $name): string
    {
        $words = preg_split('/\s+/', trim($name));

        $lastTwoWords = array_slice($words, -2);

        $baseSlug = Str::slug(implode(' ', $lastTwoWords));

        $slug = $baseSlug;
        $i = 1;

        while (User::where('slug', $slug)->exists()) {
            $slug = $baseSlug . '-' . $i;
            $i++;
        }

        return $slug;
    }
}

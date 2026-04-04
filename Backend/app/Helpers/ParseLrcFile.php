<?php

namespace App\Helpers;
use Illuminate\Support\Facades\Log;

/**
 * Class ArrayHelper
 * Useful array utilities with dot-notation support.
 */
class ParseLrcFile
{
    public function parseLrcFile(string $content): array
    {
        $lines  = explode("\n", str_replace("\r\n", "\n", $content));
        $result = [];
        $parsed = [];

        $pattern = '/^\[(\d{1,2}):(\d{2})(?:[.:](\d{1,3}))?\]\s*(.*)$/u';
        log::info($lines);
        foreach ($lines as $line) {
            $line = trim($line);

            if ($line === '') continue;

            // Bỏ qua metadata tags
            if (preg_match('/^\[(?![\d])/', $line)) {
                continue;
            }

            if (preg_match($pattern, $line, $m)) {
                $minutes = (int) $m[1];
                $seconds = (int) $m[2];
                $millis  = isset($m[3]) && $m[3] !== '' ? (int) str_pad($m[3], 3, '0') : 0;
                $text    = trim($m[4] ?? '');

                if ($text === '') continue;

                $start = $minutes * 60 + $seconds + $millis / 1000;

                $parsed[] = [
                    'start' => $start,
                    'text'  => $text,
                ];
            }
        }

        usort($parsed, fn($a, $b) => $a['start'] <=> $b['start']);

        $count = count($parsed);
        for ($i = 0; $i < $count; $i++) {
            $result[] = [
                'start' => round($parsed[$i]['start'], 3),
                'end'   => $i + 1 < $count
                            ? round($parsed[$i + 1]['start'], 3)
                            : round($parsed[$i]['start'] + 5, 3),
                'text'  => $parsed[$i]['text'],
            ];
        }

        return $result;
    }
}
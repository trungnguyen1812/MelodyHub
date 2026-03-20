<?php

namespace App\Services;

use FFMpeg\FFMpeg;
use FFMpeg\FFProbe;
use FFMpeg\Format\Audio\Mp3;
use FFMpeg\Format\Audio\Flac;
use Illuminate\Support\Facades\Log;

class AudioTranscodeService
{
    protected FFMpeg  $ffmpeg;
    protected FFProbe $ffprobe;

    public function __construct()
    {
        // FFMpeg tự detect ffmpeg/ffprobe từ PATH
        // Nếu cài ở path custom, set trong config/ffmpeg.php hoặc qua env

         Log::info('FFmpeg paths', [
            'ffmpeg'  => env('FFMPEG_BINARIES'),
            'ffprobe' => env('FFPROBE_BINARIES'),
        ]);

        $this->ffmpeg = FFMpeg::create([
            'ffmpeg.binaries'  => env('FFMPEG_BINARIES',  '/usr/bin/ffmpeg'),   // ✅ có fallback
            'ffprobe.binaries' => env('FFPROBE_BINARIES', '/usr/bin/ffprobe'),  // ✅ có fallback
        ]);

        $this->ffprobe = FFProbe::create([
            'ffprobe.binaries' => env('FFPROBE_BINARIES', '/usr/bin/ffprobe'),
        ]);
    }

    /**
     * Transcode file gốc ra 3 chất lượng.
     *
     * @param  string $originalPath  Đường dẫn tuyệt đối file gốc
     * @param  int    $songId        Dùng để đặt tên file tạm
     * @return array{low: string, standard: string, lossless: string}
     */
    public function transcodeAll(string $originalPath, int $songId): array
    {
        $tmpDir = sys_get_temp_dir() . "/song_{$songId}_" . uniqid();
        mkdir($tmpDir, 0755, true);

        $paths = [
            'low'      => "$tmpDir/low.mp3",
            'standard' => "$tmpDir/standard.mp3",
            'lossless' => "$tmpDir/lossless.flac",
        ];

        Log::info("AudioTranscodeService: bắt đầu transcode song #{$songId}", [
            'source' => $originalPath,
            'tmp'    => $tmpDir,
        ]);

        $audio = $this->ffmpeg->open($originalPath);

        // ── LOW: MP3 128 kbps ──
        $formatLow = new Mp3();
        $formatLow->setAudioChannels(2)
                  ->setAudioKiloBitrate(128);
        $audio->save($formatLow, $paths['low']);
        Log::info("AudioTranscodeService: ✓ low (128kbps) done");

        // ── STANDARD: MP3 320 kbps ──
        $formatStd = new Mp3();
        $formatStd->setAudioChannels(2)
                  ->setAudioKiloBitrate(320);
        $audio->save($formatStd, $paths['standard']);
        Log::info("AudioTranscodeService: ✓ standard (320kbps) done");

        // ── LOSSLESS: FLAC ──
        // FLAC giữ nguyên sample rate & channel từ file gốc
        $formatFlac = new Flac();
        $formatFlac->setAudioChannels(2);
        // Không set bitrate cho FLAC vì lossless — FFMpeg tự quyết định
        $audio->save($formatFlac, $paths['lossless']);
        Log::info("AudioTranscodeService: ✓ lossless (FLAC) done");

        return $paths;
    }

    /**
     * Lấy duration (giây) từ file audio bằng FFProbe.
     * Dùng khi frontend không gửi duration chính xác.
     */
    public function getDuration(string $filePath): int
    {
        $duration = $this->ffprobe
            ->streams($filePath)
            ->audios()
            ->first()
            ?->get('duration');

        return (int) round((float) $duration);
    }
}
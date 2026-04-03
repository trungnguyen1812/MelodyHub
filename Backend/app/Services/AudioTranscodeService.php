<?php

namespace App\Services;

use FFMpeg\FFProbe;
use Illuminate\Support\Facades\Log;
use Cloudinary\Cloudinary;

class AudioTranscodeService
{
    protected Cloudinary $cloudinary;
    protected FFProbe    $ffprobe;

    public function __construct()
    {
        $this->cloudinary = new Cloudinary([
            'cloud' => [
                'cloud_name' => env('CLOUDINARY_CLOUD_NAME'),
                'api_key'    => env('CLOUDINARY_API_KEY'),
                'api_secret' => env('CLOUDINARY_API_SECRET'),
            ]
        ]);

        $this->ffprobe = FFProbe::create([
            'ffprobe.binaries' => env('FFPROBE_BINARIES', '/usr/bin/ffprobe'),
        ]);
    }

    /**
     * Lấy duration (giây) từ file audio bằng FFProbe.
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

    /**
     * Upload file gốc lên Cloudinary, trả về public_id
     */
    public function uploadOriginal(string $originalPath, int $songId): string
    {
        Log::info("AudioTranscodeService: uploading song #{$songId} to Cloudinary");

        $result = $this->cloudinary->uploadApi()->upload($originalPath, [
            'resource_type' => 'video',
            'folder'        => 'songs',
            'public_id'     => "song_{$songId}",
            'overwrite'     => true,
        ]);

        Log::info("AudioTranscodeService: ✓ upload done", ['public_id' => $result['public_id']]);

        return $result['public_id'];
    }

    /**
     * Tạo URL stream/download theo chất lượng — transcode on-the-fly khi user request
     */
    public function getUrl(string $publicId, string $quality = 'standard'): string
    {
        $transformations = match ($quality) {
            'low' => [
                'format'          => 'mp3',
                'audio_codec'     => 'mp3',
                'audio_frequency' => 44100,
                'bit_rate'        => '128k',
            ],
            'standard' => [
                'format'          => 'mp3',
                'audio_codec'     => 'mp3',
                'audio_frequency' => 44100,
                'bit_rate'        => '320k',
            ],
            'lossless' => [
                'format'      => 'flac',
                'audio_codec' => 'flac',
            ],
            default => [
                'format'   => 'mp3',
                'bit_rate' => '128k',
            ]
        };

        return $this->cloudinary->image($publicId)
            ->delivery($transformations)
            ->toUrl();
    }

    /**
     * Lấy URL theo quyền user
     */
    public function getUrlByPermission(string $publicId, bool $isVip): string
    {
        return $this->getUrl($publicId, $isVip ? 'lossless' : 'low');
    }

    /**
     * Xoá file khỏi Cloudinary
     */
    public function delete(string $publicId): void
    {
        $this->cloudinary->uploadApi()->destroy($publicId, [
            'resource_type' => 'video',
        ]);
    }
}
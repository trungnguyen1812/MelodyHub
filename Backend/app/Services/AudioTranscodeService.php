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
     *
     * Cloudinary audio files are uploaded as resource_type=video, so we build
     * the transformation URL manually to ensure the correct delivery format.
     */
    public function getUrl(string $publicId, string $quality = 'standard'): string
    {
        $cloudName = env('CLOUDINARY_CLOUD_NAME');

        [$format, $bitRate] = match ($quality) {
            'low'      => ['mp3',  'ab_128k'],
            'standard' => ['mp3',  'ab_320k'],
            'lossless' => ['flac', null],
            default    => ['mp3',  'ab_128k'],
        };

        // Build transformation string: e.g. "ab_128k" or nothing for lossless
        $transformation = $bitRate ? "{$bitRate}" : '';

        // Cloudinary video URL pattern:
        // https://res.cloudinary.com/{cloud}/video/upload/{transformation}/{public_id}.{format}
        $transformPart = $transformation ? "{$transformation}/" : '';

        return "https://res.cloudinary.com/{$cloudName}/video/upload/{$transformPart}{$publicId}.{$format}";
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
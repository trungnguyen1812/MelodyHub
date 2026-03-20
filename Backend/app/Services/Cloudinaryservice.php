<?php

namespace App\Services;

use Cloudinary\Cloudinary;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Log;

class CloudinaryService
{
    protected Cloudinary $cloudinary;

    public function __construct()
    {
        // SDK tự đọc CLOUDINARY_URL từ .env — không cần config thủ công
        $this->cloudinary = new Cloudinary();
    }

    public function uploadImage(UploadedFile $file, string $folder = 'songs/covers'): string
    {
        $result = $this->cloudinary->uploadApi()->upload(
            $file->getRealPath(),
            [
                'folder'        => $folder,
                'resource_type' => 'image',
            ]
        );

        $url = $result['secure_url'] ?? '';
        Log::info("CloudinaryService: image uploaded → $url");
        return $url;
    }

    public function uploadAudio(string $absolutePath, string $folder = 'songs/audio'): string
    {
        $result = $this->cloudinary->uploadApi()->upload(
            $absolutePath,
            [
                'folder'          => $folder,
                'resource_type'   => 'video',
                'unique_filename' => true,
            ]
        );

        $url = $result['secure_url'] ?? '';
        Log::info("CloudinaryService: audio uploaded → $url");
        return $url;
    }
}
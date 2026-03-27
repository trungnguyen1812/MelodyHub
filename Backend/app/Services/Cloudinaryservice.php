<?php

namespace App\Services;

use Cloudinary\Cloudinary;
use Cloudinary\Configuration\Configuration;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Log;

class CloudinaryService
{
    protected Cloudinary $cloudinary;

    public function __construct()
    {
        $this->cloudinary = new Cloudinary(
            new Configuration([
                'cloud' => [
                    'cloud_name' => config('cloudinary.cloud_name'),
                    'api_key'    => config('cloudinary.api_key'),
                    'api_secret' => config('cloudinary.api_secret'),
                ],
                'url' => [
                    'secure' => true,
                ],
            ])
        );
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

    private function getPublicIdFromUrl(string $url): ?string
    {
        try {
            $url = urldecode($url); // ← thêm dòng này

            $parts = explode('/upload/', $url);
            if (!isset($parts[1])) return null;

            $path = $parts[1];
            $path = preg_replace('/^v\d+\//', '', $path);
            $path = preg_replace('/\.[^.]+$/', '', $path);

            Log::info("CloudinaryService: final publicId → $path");

            return $path ?: null;
        } catch (\Exception $e) {
            Log::error("getPublicIdFromUrl error: " . $e->getMessage());
            return null;
        }
    }

    public function deleteImageByUrl(?string $url): void
    {
        if (!$url) return;

        $publicId = $this->getPublicIdFromUrl($url);

        if ($publicId) {
            $this->cloudinary->uploadApi()->destroy($publicId, [
                'resource_type' => 'image',
            ]);
            Log::info("Deleted image: $publicId");
        }
    }

    public function deleteAudioByUrl(?string $url): void
    {
        if (!$url) return;

        $publicId = $this->getPublicIdFromUrl($url);

        if ($publicId) {
            $this->cloudinary->uploadApi()->destroy($publicId, [
                'resource_type' => 'video',
            ]);
            Log::info("Deleted audio: $publicId");
        }
    }

    public function deleteSongFolder(int $songId): void
    {
        try {
            $this->cloudinary->adminApi()->deleteAssetsByPrefix("songs/audio/{$songId}/", [
                'resource_type' => 'video',
            ]);
            Log::info("Deleted audio folder: songs/audio/{$songId}");
        } catch (\Exception $e) {
            Log::error("Failed to delete audio folder songs/audio/{$songId}: " . $e->getMessage());
        }

        try {
            $this->cloudinary->adminApi()->deleteFolder("songs/audio/{$songId}");
            Log::info("Deleted folder: songs/audio/{$songId}");
        } catch (\Exception $e) {
            Log::error("Failed to delete folder songs/audio/{$songId}: " . $e->getMessage());
        }
    }

    public function deleteSong(?string $coverUrl, ?string $audioUrl, ?int $songId = null): void
    {
        $this->deleteImageByUrl($coverUrl);

        if ($songId) {
            $this->deleteSongFolder($songId);
        } else {
            $this->deleteAudioByUrl($audioUrl);
        }
    }
}
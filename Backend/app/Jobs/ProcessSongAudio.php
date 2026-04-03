<?php

namespace App\Jobs;

use App\Models\Song;
use App\Services\CloudinaryService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class ProcessSongAudio implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public $tries = 3;
    public $backoff = [30, 60, 120];

    public function __construct(
        public int $songId,
        public string $localPath,
        public string $status
    ) {}

    public function handle(CloudinaryService $cloudinaryService)
    {
        try {
            Log::info('Processing audio for song', [
                'song_id'    => $this->songId,
                'local_path' => $this->localPath,
            ]);

            $absolutePath = Storage::disk('local')->path($this->localPath);
            Log::info('Looking for file at', ['absolute_path' => $absolutePath]);

            // Chờ file sẵn sàng
            $maxWait   = 10;
            $fileReady = false;
            for ($i = 0; $i < $maxWait; $i++) {
                clearstatcache(true, $absolutePath);
                if (Storage::disk('local')->exists($this->localPath)
                    && Storage::disk('local')->size($this->localPath) > 0
                ) {
                    $fileReady = true;
                    Log::info('File is ready', ['attempt' => $i + 1]);
                    break;
                }
                Log::info('Waiting for file to be ready...', [
                    'attempt' => $i + 1,
                    'path'    => $absolutePath,
                ]);
                sleep(1);
            }

            if (!$fileReady) {
                throw new \Exception("Audio file not found or empty after waiting: {$absolutePath}");
            }

            // 1. Upload lên Cloudinary
            $audioUrl = $cloudinaryService->uploadAudio($absolutePath, "songs/audio/{$this->songId}");

            // 2. Lấy public_id từ URL
            $publicId = $this->extractPublicIdFromUrl($audioUrl);

            // 3. Lấy song
            $song = Song::find($this->songId);
            if (!$song) {
                throw new \Exception("Song not found with ID: {$this->songId}");
            }

            // 4. Cập nhật song
            $validStatuses = ['draft', 'published', 'blocked', 'processing', 'processing_failed'];
            $finalStatus   = in_array($this->status, $validStatuses) ? $this->status : 'draft';

            $song->update([
                'song_url'               => $audioUrl,
                'audio_public_id'        => $publicId,
                'status'                 => $finalStatus,
                'audio_processed_at'     => now(),
                'audio_processing_error' => null,
            ]);

            Log::info('Audio uploaded successfully', [
                'song_id'   => $this->songId,
                'audio_url' => $audioUrl,
                'public_id' => $publicId,
                'status'    => $finalStatus,
            ]);

            // 5. Dispatch GenerateLyricsJob
            // Luôn reset và dispatch lại khi có audio mới (bất kể lyrics_status cũ là gì)
            if ($publicId) {
                $song->update([
                    'lyrics_status' => 'pending',
                    'lyrics_error'  => null,
                    'lyrics'        => null,
                ]);

                GenerateLyricsJob::dispatch($song->id, $publicId)
                    ->onQueue('lyrics');

                Log::info('Lyrics generation job dispatched', [
                    'song_id'   => $song->id,
                    'public_id' => $publicId,
                ]);
            } else {
                Log::warning('No public_id, skipping lyrics generation', [
                    'song_id' => $song->id,
                ]);
            }

            // 6. Xóa file tạm
            Storage::disk('local')->delete($this->localPath);
            Log::info('Temporary audio file deleted', ['path' => $this->localPath]);

        } catch (\Exception $e) {
            Log::error('ProcessSongAudio failed: ' . $e->getMessage(), [
                'song_id' => $this->songId,
                'trace'   => $e->getTraceAsString(),
            ]);

            Song::where('id', $this->songId)->update([
                'status'                 => 'processing_failed',
                'audio_processing_error' => substr($e->getMessage(), 0, 500),
            ]);

            throw $e;
        }
    }

    private function extractPublicIdFromUrl(string $url): ?string
    {
        try {
            $url = urldecode($url);

            if (preg_match('/\/upload\/(?:v\d+\/)?(.+?)\.(mp3|wav|flac|aac|ogg|m4a)/i', $url, $matches)) {
                $publicId = $matches[1];
                Log::info('Extracted public_id', ['public_id' => $publicId, 'url' => $url]);
                return $publicId;
            }

            Log::warning('Could not extract public_id from URL', ['url' => $url]);
            return null;

        } catch (\Exception $e) {
            Log::error('Failed to extract public_id', ['error' => $e->getMessage()]);
            return null;
        }
    }
}
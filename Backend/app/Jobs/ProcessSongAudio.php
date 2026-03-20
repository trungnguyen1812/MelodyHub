<?php

namespace App\Jobs;

use App\Models\Song;
use App\Services\AudioTranscodeService;
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

    /**
     * Số lần retry nếu Job lỗi
     */
    public int $tries = 3;

    /**
     * Timeout tối đa cho Job (giây) — file FLAC lossless có thể mất vài phút
     */
    public int $timeout = 600;

    public function __construct(
        protected int    $songId,
        protected string $storedPath,      // đường dẫn local: "audio_originals/xxx.mp3"
        protected string $targetStatus,    // status cuối: 'published' | 'draft'
    ) {}

    public function handle(
        AudioTranscodeService $transcoder,
        CloudinaryService     $cloudinary
    ): void {
        $song = Song::findOrFail($this->songId);

        Log::info("ProcessSongAudio: bắt đầu xử lý song #{$this->songId}");

        // Đường dẫn tuyệt đối của file gốc
        $originalAbsPath = Storage::disk('local')->path($this->storedPath);

        $transcodedPaths = [];

        try {
            // ── BƯỚC 1: Transcode ra 3 chất lượng ──
            // low      → MP3 128 kbps  (mobile, tiết kiệm data)
            // standard → MP3 320 kbps  (default stream)
            // lossless → FLAC          (premium)
            $transcodedPaths = $transcoder->transcodeAll($originalAbsPath, $this->songId);
            // Trả về: ['low' => '/tmp/...mp3', 'standard' => '/tmp/...mp3', 'lossless' => '/tmp/...flac']

            // ── BƯỚC 2: Upload 3 file lên Cloudinary ──
            $folder = "songs/audio/{$this->songId}";

            $urlLow      = $cloudinary->uploadAudio($transcodedPaths['low'],      "$folder/low");
            $urlStandard = $cloudinary->uploadAudio($transcodedPaths['standard'], "$folder/standard");
            $urlLossless = $cloudinary->uploadAudio($transcodedPaths['lossless'], "$folder/lossless");

            // ── BƯỚC 3: Cập nhật song record ──
            $song->update([
                'song_url'          => $urlStandard,   // field chính = 320kbps
                'song_url_hq'       => $urlLow,        // dùng lại field hq cho 128kbps (low)
                'song_url_lossless' => $urlLossless,
                'status'            => $this->targetStatus,
            ]);

            Log::info("ProcessSongAudio: song #{$this->songId} hoàn tất.", [
                'low'      => $urlLow,
                'standard' => $urlStandard,
                'lossless' => $urlLossless,
            ]);

        } catch (\Throwable $e) {
            // Đánh dấu song bị lỗi xử lý
            $song->update(['status' => 'processing_failed']);

            Log::error("ProcessSongAudio: song #{$this->songId} thất bại — " . $e->getMessage(), [
                'trace' => $e->getTraceAsString(),
            ]);

            // Ném lại để Queue retry
            throw $e;

        } finally {
            // ── DỌN DẸP: xóa file tạm transcode ──
            foreach ($transcodedPaths as $path) {
                if ($path && file_exists($path)) {
                    @unlink($path);
                }
            }

            // Xóa file gốc đã lưu tạm sau khi xử lý xong
            Storage::disk('local')->delete($this->storedPath);
        }
    }

    /**
     * Xử lý khi Job thất bại hoàn toàn (hết số lần retry)
     */
    public function failed(\Throwable $exception): void
    {
        Log::critical("ProcessSongAudio: song #{$this->songId} FAILED after {$this->tries} retries.", [
            'error' => $exception->getMessage(),
        ]);

        Song::where('id', $this->songId)->update(['status' => 'processing_failed']);
    }
}
<?php

namespace App\Jobs;

use App\Models\CopyrightReport;
use App\Services\SoundalikeService;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class ProcessCopyrightReport implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, SerializesModels;

    /**
     * Queue riêng để không block audio/lyrics workers
     */
    public string $queue = 'copyright';

    /**
     * Số lần retry nếu job thất bại
     */
    public int $tries = 3;

    /**
     * Timeout tối đa cho job (giây)
     */
    public int $timeout = 180;

    /**
     * Thời gian chờ giữa các lần retry (giây)
     */
    public int $backoff = 30;

    protected CopyrightReport $report;

    public function __construct(CopyrightReport $report)
    {
        $this->report = $report;
    }

    public function handle(SoundalikeService $soundalike): void
    {
        // Reload fresh từ DB để tránh stale data
        $report = $this->report->fresh();

        if (!$report) {
            Log::warning('[CopyrightReport] Report not found, skipping job', [
                'report_id' => $this->report->id,
            ]);
            return;
        }

        // Đánh dấu đang scan
        $report->update(['status' => 'ai_scanning']);

        // Lấy URL của 2 bài hát
        $originalSong   = $report->originalSong;
        $infringingSong = $report->infringingSong;

        if (!$originalSong || !$originalSong->song_url) {
            Log::error('[CopyrightReport] Original song has no audio URL', [
                'report_id'        => $report->id,
                'original_song_id' => $report->original_song_id,
            ]);
            $report->update([
                'status'         => 'pending',
                'ai_report_path' => json_encode([
                    'error' => 'Original song has no audio URL',
                ]),
            ]);
            return;
        }

        if (!$infringingSong || !$infringingSong->song_url) {
            Log::error('[CopyrightReport] Infringing song has no audio URL', [
                'report_id'          => $report->id,
                'infringing_song_id' => $report->infringing_song_id,
            ]);
            $report->update([
                'status'         => 'pending',
                'ai_report_path' => json_encode([
                    'error' => 'Infringing song has no audio URL',
                ]),
            ]);
            return;
        }

        // Gọi soundalike service và đo thời gian
        $startTime = microtime(true);

        $result = $soundalike->compare(
            $originalSong->song_url,
            $infringingSong->song_url
        );

        $durationMs = (int) round((microtime(true) - $startTime) * 1000);

        // Xử lý kết quả
        if (!$result['success']) {
            Log::error('[CopyrightReport] Soundalike comparison failed', [
                'report_id' => $report->id,
                'error'     => $result['error'] ?? 'Unknown error',
            ]);

            // Nếu còn lần retry thì để lại trạng thái pending để retry
            $report->update([
                'status'         => 'pending',
                'ai_report_path' => json_encode([
                    'error'       => $result['error'] ?? 'Soundalike service error',
                    'duration_ms' => $durationMs,
                ]),
            ]);

            // Throw để queue tự retry
            throw new \RuntimeException(
                '[CopyrightReport] Soundalike failed: ' . ($result['error'] ?? 'Unknown')
            );
        }

        $similarityPercent = (float) $result['similarity_percent'];
        $isViolation       = $result['is_violation'] ?? ($similarityPercent >= 60);
        $newStatus         = $isViolation ? 'reviewing' : 'auto_rejected';

        Log::info('[CopyrightReport] Soundalike completed', [
            'report_id'         => $report->id,
            'similarity_percent'=> $similarityPercent,
            'is_violation'      => $isViolation,
            'status'            => $newStatus,
            'duration_ms'       => $durationMs,
        ]);

        $report->update([
            'similarity_raw'         => $result['similarity_raw'] ?? null,
            'similarity_score'       => $similarityPercent,
            'ai_report_path'         => json_encode($result),
            'comparison_duration_ms' => $durationMs,
            'fingerprint_cache_hit'  => $result['cache_hit'] ?? false,
            'status'                 => $newStatus,
        ]);
    }

    /**
     * Xử lý khi job thất bại hoàn toàn (hết retry)
     */
    public function failed(\Throwable $exception): void
    {
        Log::error('[CopyrightReport] Job failed permanently', [
            'report_id' => $this->report->id,
            'error'     => $exception->getMessage(),
        ]);

        // Đặt lại pending để admin có thể reprocess thủ công
        $this->report->update([
            'status'         => 'pending',
            'ai_report_path' => json_encode([
                'error'      => 'Job failed after all retries: ' . $exception->getMessage(),
                'failed_at'  => now()->toISOString(),
            ]),
        ]);
    }
}

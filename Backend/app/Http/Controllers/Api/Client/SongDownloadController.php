<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\Song;
use App\Models\SongDownload;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Symfony\Component\HttpFoundation\StreamedResponse;

class SongDownloadController extends Controller
{
    /**
     * GET /client/songs/{id}/download
     *
     * 1. Download original audio from Cloudinary (server-side)
     * 2. Transcode with FFmpeg to the correct quality
     * 3. Stream the transcoded file back to the client
     *
     * Quality enforced server-side:
     *   Free → 128kbps MP3
     *   VIP  → 320kbps MP3  (lossless FLAC requires Cloudinary paid plan)
     */
    public function download(Request $request, int $id): StreamedResponse|\Illuminate\Http\JsonResponse
    {
        // ── 1. Find song ──────────────────────────────────────────────────────
        $song = Song::with('artist')->find($id);

        if (!$song) {
            return response()->json(['message' => 'Song not found.'], 404);
        }

        if (!$song->allow_download) {
            return response()->json(['message' => 'This song does not allow downloads.'], 403);
        }

        if (!$song->song_url) {
            return response()->json(['message' => 'Audio file not available.'], 404);
        }

        // ── 2. Determine quality by VIP status ────────────────────────────────
        $user  = Auth::user();
        $isVip = false;

        if ($user) {
            $flags = $user->getRoleFlags();
            $isVip = ($flags['is_user_vip_yearly']  ?? false)
                  || ($flags['is_user_vip_monthly']  ?? false)
                  || ($flags['is_boss']               ?? false)
                  || ($flags['is_admin']              ?? false);
        }

        // Free → 128k, VIP → 320k
        $bitrate  = $isVip ? '320k' : '128k';
        $quality  = $isVip ? 'hq'   : 'low';

        // ── 3. Download original from Cloudinary ─────────────────────────────
        $originalUrl = $song->song_url;

        Log::info('[SongDownload] Downloading original', [
            'song_id' => $id,
            'url'     => $originalUrl,
        ]);

        $tmpDir      = sys_get_temp_dir();
        $tmpOriginal = $tmpDir . DIRECTORY_SEPARATOR . 'melodyhub_orig_' . $id . '_' . uniqid() . '.mp3';
        $tmpOutput   = $tmpDir . DIRECTORY_SEPARATOR . 'melodyhub_out_'  . $id . '_' . uniqid() . '.mp3';

        try {
            // Download original file
            $ch = curl_init($originalUrl);
            curl_setopt_array($ch, [
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_TIMEOUT        => 60,
                CURLOPT_SSL_VERIFYPEER => false,
            ]);
            $audioData = curl_exec($ch);
            $httpCode  = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            curl_close($ch);

            if ($httpCode !== 200 || !$audioData) {
                Log::error('[SongDownload] Failed to download original', [
                    'song_id'   => $id,
                    'http_code' => $httpCode,
                ]);
                return response()->json(['message' => 'Failed to fetch original audio. Status: ' . $httpCode], 502);
            }

            file_put_contents($tmpOriginal, $audioData);
            unset($audioData); // free memory

            // ── 4. Transcode with FFmpeg ──────────────────────────────────────
            $ffmpeg = env('FFMPEG_BINARIES', 'ffmpeg');

            $cmd = sprintf(
                '"%s" -y -i "%s" -vn -acodec libmp3lame -ab %s -ar 44100 "%s" 2>&1',
                $ffmpeg,
                $tmpOriginal,
                $bitrate,
                $tmpOutput
            );

            Log::info('[SongDownload] Running FFmpeg', ['cmd' => $cmd]);
            exec($cmd, $output, $exitCode);

            if ($exitCode !== 0 || !file_exists($tmpOutput) || filesize($tmpOutput) === 0) {
                Log::error('[SongDownload] FFmpeg failed', [
                    'exit_code' => $exitCode,
                    'output'    => implode("\n", $output),
                ]);
                return response()->json(['message' => 'Audio transcoding failed.'], 500);
            }

            $fileSize = filesize($tmpOutput);
            $filename = $this->buildFilename($song, $quality);

            Log::info('[SongDownload] Transcoding done', [
                'song_id'   => $id,
                'quality'   => $quality,
                'bitrate'   => $bitrate,
                'file_size' => $fileSize,
            ]);

            // ── 5. Log download record ────────────────────────────────────────
            if ($user) {
                try {
                    SongDownload::create([
                        'user_id'       => $user->id,
                        'song_id'       => $song->id,
                        'quality'       => $quality,
                        'file_size'     => $fileSize,
                        'downloaded_at' => now(),
                        'ip_address'    => $request->ip(),
                        'device_info'   => $request->userAgent(),
                    ]);
                    $song->increment('total_downloads');
                } catch (\Throwable $e) {
                    Log::warning('[SongDownload] Failed to log record', ['error' => $e->getMessage()]);
                }
            }

            // ── 6. Stream transcoded file ─────────────────────────────────────
            $outputPath = $tmpOutput;

            return response()->streamDownload(
                function () use ($outputPath, $tmpOriginal) {
                    $handle = fopen($outputPath, 'rb');
                    while (!feof($handle)) {
                        echo fread($handle, 8192);
                        flush();
                    }
                    fclose($handle);
                    // Cleanup temp files
                    @unlink($outputPath);
                    @unlink($tmpOriginal);
                },
                $filename,
                [
                    'Content-Type'   => 'audio/mpeg',
                    'Content-Length' => $fileSize,
                    'Cache-Control'  => 'no-cache',
                    'X-Quality'      => $quality,
                    'X-Bitrate'      => $bitrate,
                ]
            );

        } catch (\Throwable $e) {
            // Cleanup on error
            @unlink($tmpOriginal);
            @unlink($tmpOutput);

            Log::error('[SongDownload] Unexpected error', [
                'song_id' => $id,
                'error'   => $e->getMessage(),
            ]);
            return response()->json(['message' => 'Download failed: ' . $e->getMessage()], 500);
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private function buildFilename(Song $song, string $quality): string
    {
        $title  = preg_replace('/[^\w\s\-]/', '', $song->title         ?? 'Unknown');
        $artist = preg_replace('/[^\w\s\-]/', '', $song->artist?->name ?? 'Unknown');
        $label  = $quality === 'hq' ? '320kbps' : '128kbps';
        return trim("{$title} - {$artist} [{$label}].mp3");
    }
}

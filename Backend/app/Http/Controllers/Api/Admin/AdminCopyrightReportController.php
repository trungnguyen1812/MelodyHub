<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\CopyrightReport;
use App\Models\Song;
use App\Models\Notification;
use App\Jobs\ProcessCopyrightReport;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class AdminCopyrightReportController extends Controller
{
    private const ALLOWED_SORT_FIELDS = [
        'created_at', 'updated_at', 'similarity_score', 'status', 'violation_type',
    ];

    /**
     * Danh sách tất cả reports (có filter, sort, paginate)
     */
    public function index(Request $request)
    {
        $query = CopyrightReport::with([
            'originalSong.artist',
            'infringingSong.artist',
            'reporterPartner',
            'reporterUser',
        ]);

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('min_similarity')) {
            $query->where('similarity_score', '>=', $request->min_similarity);
        }

        $sortField = in_array($request->get('sort_by'), self::ALLOWED_SORT_FIELDS)
            ? $request->get('sort_by')
            : 'created_at';
        $sortOrder = $request->get('sort_order', 'desc') === 'asc' ? 'asc' : 'desc';
        $query->orderBy($sortField, $sortOrder);

        $reports = $query->paginate($request->get('per_page', 15));

        return response()->json([
            'success' => true,
            'data'    => $reports,
        ]);
    }

    /**
     * Thống kê tổng quan
     */
    public function stats()
    {
        $total = CopyrightReport::count();

        return response()->json([
            'success' => true,
            'data'    => [
                'total'            => $total,
                'pending'          => CopyrightReport::where('status', 'pending')->count(),
                'ai_scanning'      => CopyrightReport::where('status', 'ai_scanning')->count(),
                'reviewing'        => CopyrightReport::where('status', 'reviewing')->count(),
                'auto_rejected'    => CopyrightReport::where('status', 'auto_rejected')->count(),
                'resolved_removed' => CopyrightReport::where('status', 'resolved_removed')->count(),
                'resolved_kept'    => CopyrightReport::where('status', 'resolved_kept')->count(),
                'rejected'         => CopyrightReport::where('status', 'rejected')->count(),
                'avg_similarity'   => $total > 0
                    ? round((float) CopyrightReport::avg('similarity_score'), 2)
                    : null,
                'violation_rate'   => $total > 0
                    ? round(CopyrightReport::where('similarity_score', '>=', 60)->count() / $total * 100, 2)
                    : 0,
            ],
        ]);
    }

    /**
     * Chi tiết 1 report
     */
    public function show($id)
    {
        $report = CopyrightReport::with([
            'originalSong.artist',
            'infringingSong.artist',
            'reporterPartner',
            'reporterUser',
            'resolvedBy',
        ])->findOrFail($id);

        return response()->json([
            'success' => true,
            'data'    => $report,
        ]);
    }

    /**
     * Admin cập nhật trạng thái report (duyệt / từ chối / giữ)
     */
    public function update(Request $request, $id)
    {
        $report = CopyrightReport::findOrFail($id);

        $validated = $request->validate([
            'status'          => 'required|in:reviewing,resolved_removed,resolved_kept,rejected',
            'resolution_note' => 'nullable|string|max:2000',
        ]);

        // Xử lý block / unblock bài hát vi phạm
        if (\in_array($validated['status'], ['resolved_removed', 'resolved_kept', 'rejected'])) {
            $infringingSong = Song::find($report->infringing_song_id);

            if ($infringingSong) {
                if ($validated['status'] === 'resolved_removed') {
                    $infringingSong->update(['status' => 'blocked']);
                } elseif ($validated['status'] === 'resolved_kept' && $infringingSong->status === 'blocked') {
                    $infringingSong->update(['status' => 'published']);
                }
            }
        }

        /** @var \App\Models\User $admin */
        $admin = \Illuminate\Support\Facades\Auth::user();

        $report->update([
            'status'          => $validated['status'],
            'resolution_note' => $validated['resolution_note'] ?? null,
            'resolved_by'     => $admin?->id,
            'resolved_at'     => now(),
        ]);

        Log::info('[AdminCopyrightReport] Report updated', [
            'report_id' => $report->id,
            'status'    => $validated['status'],
            'admin_id'  => $admin?->id,
        ]);

        // Gửi notification cho reporter
        $this->notifyReporter($report->fresh(), $validated['status'], $validated['resolution_note'] ?? null);

        return response()->json([
            'success' => true,
            'message' => 'Report updated successfully',
            'data'    => $report->fresh([
                'originalSong.artist',
                'infringingSong.artist',
                'reporterPartner',
                'resolvedBy',
            ]),
        ]);
    }

    /**
     * Xóa report (chỉ được xóa khi chưa resolved)
     */
    public function destroy($id)
    {
        $report = CopyrightReport::findOrFail($id);

        if (\in_array($report->status, ['resolved_removed', 'resolved_kept'])) {
            return response()->json([
                'success' => false,
                'message' => 'Cannot delete resolved reports',
            ], 422);
        }

        $report->delete();

        return response()->json([
            'success' => true,
            'message' => 'Report deleted successfully',
        ]);
    }

    /**
     * Reprocess — chạy lại soundalike
     */
    public function reprocess($id)
    {
        $report = CopyrightReport::findOrFail($id);

        if (\in_array($report->status, ['resolved_removed', 'resolved_kept', 'rejected'])) {
            return response()->json([
                'success' => false,
                'message' => 'Cannot reprocess a resolved or rejected report',
            ], 422);
        }

        $report->update([
            'status'                 => 'pending',
            'similarity_raw'         => null,
            'similarity_score'       => null,
            'ai_report_path'         => null,
            'comparison_duration_ms' => null,
            'resolution_note'        => null,
            'resolved_by'            => null,
            'resolved_at'            => null,
        ]);

        ProcessCopyrightReport::dispatch($report);

        return response()->json([
            'success'   => true,
            'message'   => 'Report queued for reprocessing',
            'report_id' => $report->id,
        ]);
    }

    /**
     * Gửi notification cho reporter khi admin ra quyết định
     */
    private function notifyReporter(CopyrightReport $report, string $status, ?string $note): void
    {
        $userId = null;

        if ($report->reporter_type === 'partner' && $report->reporterPartner) {
            $userId = $report->reporterPartner->user_id ?? null;
        } elseif ($report->reporter_type === 'user') {
            $userId = $report->reporter_user_id;
        }

        if (!$userId) return;

        $originalTitle   = $report->originalSong?->title  ?? "Song #{$report->original_song_id}";
        $infringingTitle = $report->infringingSong?->title ?? "Song #{$report->infringing_song_id}";

        [$type, $title, $message] = match ($status) {
            'resolved_removed' => [
                'copyright_report_resolved_removed',
                '✅ Copyright Violation Confirmed',
                "Your report for \"{$originalTitle}\" has been reviewed. The infringing song \"{$infringingTitle}\" has been blocked." . ($note ? " Note: {$note}" : ''),
            ],
            'resolved_kept' => [
                'copyright_report_resolved_kept',
                'ℹ️ Copyright Report Closed',
                "Your report for \"{$originalTitle}\" vs \"{$infringingTitle}\" has been reviewed. Admin determined no violation — the song will remain available." . ($note ? " Note: {$note}" : ''),
            ],
            'rejected' => [
                'copyright_report_rejected',
                '❌ Copyright Report Rejected',
                "Your report for \"{$originalTitle}\" vs \"{$infringingTitle}\" was rejected." . ($note ? " Reason: {$note}" : ''),
            ],
            default => [
                'copyright_report_updated',
                'Copyright Report Updated',
                "Your report #{{$report->id}} status has been updated to: {$status}.",
            ],
        };

        Notification::create([
            'user_id'    => $userId,
            'type'       => $type,
            'title'      => $title,
            'message'    => $message,
            'data'       => json_encode([
                'report_id'       => $report->id,
                'status'          => $status,
                'original_song'   => $originalTitle,
                'infringing_song' => $infringingTitle,
                'similarity'      => $report->similarity_score,
            ]),
            'action_url' => '/center/my-reports',
            'is_read'    => false,
        ]);
    }
}

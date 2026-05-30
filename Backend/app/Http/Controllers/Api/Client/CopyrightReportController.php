<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\CopyrightReport;
use App\Models\Notification;
use App\Models\Song;
use App\Models\User;
use App\Jobs\ProcessCopyrightReport;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CopyrightReportController extends Controller
{
    private const ALLOWED_SORT_FIELDS = [
        'created_at', 'updated_at', 'similarity_score', 'status', 'violation_type',
    ];

    /**
     * Danh sách reports (partner/admin)
     */
    public function index(Request $request)
    {
        $query = CopyrightReport::with(['originalSong', 'infringingSong', 'reporterPartner']);

        if ($request->filled('status')) {
            $query->where('status', $request->get('status'));
        }

        if ($request->filled('reporter_partner_id')) {
            $query->where('reporter_partner_id', $request->get('reporter_partner_id'));
        }

        if ($request->filled('min_similarity')) {
            $query->where('similarity_score', '>=', $request->get('min_similarity'));
        }

        $sortField = \in_array($request->get('sort_by'), self::ALLOWED_SORT_FIELDS)
            ? $request->get('sort_by')
            : 'created_at';
        $sortOrder = $request->get('sort_order', 'desc') === 'asc' ? 'asc' : 'desc';
        $query->orderBy($sortField, $sortOrder);

        return response()->json([
            'success' => true,
            'data'    => $query->paginate($request->get('per_page', 15)),
        ]);
    }

    /**
     * Reports của user/partner đang login
     */
    public function myReports(Request $request)
    {
        /** @var \App\Models\User $user */
        $user   = Auth::user();
        $userId = $user->id;

        $withIsLiked = function ($q) use ($userId) {
            $q->withExists([
                'song_likes as is_liked' => fn($q) => $q->where('user_id', $userId),
            ]);
        };

        $query = CopyrightReport::with([
            'originalSong' => function ($q) use ($withIsLiked) {
                $q->select('id', 'title', 'cover_url');
                $withIsLiked($q);
            },
            'infringingSong' => function ($q) use ($withIsLiked) {
                $q->select('id', 'title', 'cover_url');
                $withIsLiked($q);
            },
        ]);

        // Lấy tất cả partner_id của user (user có thể có nhiều partners)
        $partnerIds = $user->partners()->pluck('id')->toArray();

        if (!empty($partnerIds)) {
            // Partner: lấy theo tất cả partner_id của user
            $query->whereIn('reporter_partner_id', $partnerIds);
        } else {
            // User thường: lấy theo user_id
            $query->where('reporter_user_id', $userId);
        }

        $reports = $query->orderBy('created_at', 'desc')
            ->paginate($request->get('per_page', 20));

        return response()->json(['success' => true, 'data' => $reports]);
    }

    /**
     * Reports cần admin review
     */
    public function needsReview(Request $request)
    {
        $reports = CopyrightReport::with(['originalSong', 'infringingSong', 'reporterPartner'])
            ->needsReview()
            ->orderBy('similarity_score', 'desc')
            ->paginate($request->get('per_page', 15));

        return response()->json(['success' => true, 'data' => $reports]);
    }

    /**
     * Tạo report mới
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'reporter_type'       => 'required|in:partner,artist,user',
            'reporter_partner_id' => 'required_if:reporter_type,partner|nullable|exists:partners,id',
            'reporter_user_id'    => 'required_if:reporter_type,user|nullable|exists:users,id',
            'original_song_id'    => 'required|exists:songs,id',
            'infringing_song_id'  => 'required|exists:songs,id|different:original_song_id',
            'violation_type'      => 'required|in:melody,lyrics,beat,full_copy,unauthorized_remix,other',
            'description'         => 'nullable|string|max:2000',
            'evidence_files'      => 'nullable|array',
            'evidence_files.*'    => 'string',
        ]);

        // Kiểm tra duplicate
        $existing = CopyrightReport::where('original_song_id', $validated['original_song_id'])
            ->where('infringing_song_id', $validated['infringing_song_id'])
            ->whereIn('status', ['pending', 'ai_scanning', 'reviewing'])
            ->first();

        if ($existing) {
            return response()->json([
                'success'   => false,
                'message'   => 'A report for this song pair already exists and is being processed',
                'report_id' => $existing->id,
            ], 422);
        }

        $report = CopyrightReport::create([
            'reporter_type'       => $validated['reporter_type'],
            'reporter_partner_id' => $validated['reporter_partner_id'] ?? null,
            'reporter_user_id'    => $validated['reporter_user_id'] ?? null,
            'original_song_id'    => $validated['original_song_id'],
            'infringing_song_id'  => $validated['infringing_song_id'],
            'violation_type'      => $validated['violation_type'],
            'description'         => $validated['description'] ?? null,
            'evidence_files'      => $validated['evidence_files'] ?? [],
            'status'              => 'pending',
        ]);

        // Dispatch AI job
        ProcessCopyrightReport::dispatch($report);

        // Notification xác nhận cho reporter
        $this->notifyReporter($report);

        // Notification cho admin/boss để duyệt
        $this->notifyAdmins($report);

        return response()->json([
            'success' => true,
            'message' => 'Report created successfully. AI is analyzing the audio...',
            'data'    => [
                'report_id'      => $report->id,
                'status'         => $report->status,
                'estimated_time' => '5-10 seconds',
            ],
        ], 201);
    }

    /**
     * Chi tiết 1 report
     */
    public function show($id)
    {
        $report = CopyrightReport::with([
            'originalSong',
            'infringingSong',
            'reporterPartner',
            'reporterUser',
            'resolvedBy',
        ])->findOrFail($id);

        /** @var \App\Models\User|null $user */
        $user = Auth::user();
        if ($user && $user->role === 'partner') {
            $partnerId = $user->partner?->id;
            if (!$partnerId || $report->reporter_partner_id !== $partnerId) {
                return response()->json(['success' => false, 'message' => 'Unauthorized'], 403);
            }
        }

        return response()->json(['success' => true, 'data' => $report]);
    }

    /**
     * Cập nhật trạng thái report (admin)
     */
    public function update(Request $request, $id)
    {
        $report = CopyrightReport::findOrFail($id);

        $validated = $request->validate([
            'status'          => 'required|in:reviewing,resolved_removed,resolved_kept,rejected',
            'resolution_note' => 'nullable|string|max:2000',
        ]);

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
        $admin = Auth::user();

        $report->update([
            'status'          => $validated['status'],
            'resolution_note' => $validated['resolution_note'] ?? null,
            'resolved_by'     => $admin?->id,
            'resolved_at'     => now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Report updated successfully',
            'data'    => $report->fresh(),
        ]);
    }

    /**
     * Xóa report
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

        return response()->json(['success' => true, 'message' => 'Report deleted successfully']);
    }

    /**
     * Thống kê
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
                'avg_similarity'   => $total > 0 ? round((float) CopyrightReport::avg('similarity_score'), 2) : null,
                'violation_rate'   => $total > 0
                    ? round(CopyrightReport::where('similarity_score', '>=', 60)->count() / $total * 100, 2)
                    : 0,
                'reports_by_day'   => CopyrightReport::selectRaw('DATE(created_at) as date, COUNT(*) as count')
                    ->groupBy('date')
                    ->orderBy('date', 'desc')
                    ->limit(7)
                    ->get(),
            ],
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
                'message' => 'Cannot reprocess a report that has already been resolved or rejected',
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
            'message'   => 'Report has been queued for reprocessing',
            'report_id' => $report->id,
        ]);
    }

    /**
     * Gửi notification xác nhận cho người tạo report
     */
    private function notifyReporter(CopyrightReport $report): void
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

        Notification::create([
            'user_id'    => $userId,
            'type'       => 'copyright_report_submitted',
            'title'      => 'Copyright Report Submitted',
            'message'    => "Your report for \"{$originalTitle}\" vs \"{$infringingTitle}\" has been received. Our AI is analyzing the audio fingerprints.",
            'data'       => json_encode([
                'report_id'       => $report->id,
                'original_song'   => $originalTitle,
                'infringing_song' => $infringingTitle,
                'violation_type'  => $report->violation_type,
            ]),
            'action_url' => '/center/my-reports',
            'is_read'    => false,
        ]);
    }

    /**
     * Gửi notification cho tất cả admin/boss khi có report mới cần duyệt
     */
    private function notifyAdmins(CopyrightReport $report): void
    {
        $originalTitle   = $report->originalSong?->title  ?? "Song #{$report->original_song_id}";
        $infringingTitle = $report->infringingSong?->title ?? "Song #{$report->infringing_song_id}";

        $reporterName = match ($report->reporter_type) {
            'partner' => $report->reporterPartner?->name ?? 'A partner',
            'user'    => $report->reporterUser?->name    ?? 'A user',
            default   => 'Someone',
        };

        // Lấy tất cả user có role admin hoặc boss
        $admins = User::whereHas('roles', function ($q) {
            $q->whereIn('name', ['admin', 'boss']);
        })->get();

        foreach ($admins as $admin) {
            Notification::create([
                'user_id'    => $admin->id,
                'type'       => 'new_copyright_report',
                'title'      => '🚨 New Copyright Report',
                'message'    => "{$reporterName} has submitted a copyright report: \"{$originalTitle}\" vs \"{$infringingTitle}\". Please review and take action.",
                'data'       => json_encode([
                    'report_id'       => $report->id,
                    'reporter_type'   => $report->reporter_type,
                    'original_song'   => $originalTitle,
                    'infringing_song' => $infringingTitle,
                    'violation_type'  => $report->violation_type,
                ]),
                'action_url' => '/admin/reports',
                'is_read'    => false,
            ]);
        }
    }
}

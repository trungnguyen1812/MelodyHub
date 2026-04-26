<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use App\Models\PartnerPayout;
use App\Models\Partner;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class PaymentManagerController extends Controller
{
    // ─────────────────────────────────────────────────────────────────────────
    // GET /admin/payments
    // Danh sách giao dịch (Payment user + PartnerPayout) có filter & pagination
    // ─────────────────────────────────────────────────────────────────────────
    public function index(Request $request)
    {
        try {
            $perPage = (int) $request->get('per_page', 15);
            $page    = (int) $request->get('page', 1);

            // ── 1. Payment (subscription / topup / refund) ───────────────────
            $paymentQuery = Payment::with(['user:id,name,email'])
                ->select(
                    'id',
                    DB::raw("'payment' as source"),
                    DB::raw("CONCAT('PAY-', LPAD(id, 7, '0')) as reference_code"),
                    'payment_type as type',
                    'status',
                    'user_id',
                    DB::raw('NULL as partner_id'),
                    'amount',
                    'currency',
                    DB::raw('NULL as fee'),
                    DB::raw('amount as net_amount'),
                    DB::raw('NULL as bank_name'),
                    DB::raw('NULL as bank_account_number'),
                    DB::raw('NULL as bank_account_name'),
                    'created_at',
                    'paid_at as processed_at',
                    'created_at as requested_at',
                    'updated_at',
                    'notes',
                    'failed_reason as failure_reason'
                );

            // ── 2. PartnerPayout (payouts cho partner) ───────────────────────
            $payoutQuery = PartnerPayout::with(['partner:id,company_name,user_id'])
                ->select(
                    'id',
                    DB::raw("'payout' as source"),
                    DB::raw("IFNULL(transaction_reference, CONCAT('PO-', LPAD(id, 7, '0'))) as reference_code"),
                    DB::raw("'partner_payout' as type"),
                    'status',
                    DB::raw('NULL as user_id'),
                    'partner_id',
                    'total_amount as amount',
                    'currency',
                    'fee_amount as fee',
                    'net_amount',
                    'bank_name',
                    'account_number as bank_account_number',
                    DB::raw('NULL as bank_account_name'),
                    'created_at',
                    'processed_at',
                    'created_at as requested_at',
                    'updated_at',
                    'notes',
                    'failed_reason as failure_reason'
                );

            // ── Filters ──────────────────────────────────────────────────────
            $status  = $request->get('status');
            $type    = $request->get('type');
            $keyword = $request->get('keyword');
            $dateFrom = $request->get('date_from');
            $dateTo   = $request->get('date_to');

            if ($status) {
                $paymentQuery->where('status', $status);
                $payoutQuery->where('status', $status);
            }

            if ($type === 'partner_payout') {
                // chỉ lấy payout
                $paymentQuery->whereRaw('1=0');
            } elseif ($type && $type !== 'partner_payout') {
                // chỉ lấy payment (subscription, refund…)
                $paymentQuery->where('payment_type', $type);
                $payoutQuery->whereRaw('1=0');
            }

            if ($dateFrom) {
                $paymentQuery->whereDate('created_at', '>=', $dateFrom);
                $payoutQuery->whereDate('created_at', '>=', $dateFrom);
            }
            if ($dateTo) {
                $paymentQuery->whereDate('created_at', '<=', $dateTo);
                $payoutQuery->whereDate('created_at', '<=', $dateTo);
            }

            // ── UNION + paginate thủ công ────────────────────────────────────
            $union = $paymentQuery->union($payoutQuery)
                ->orderByDesc('created_at');

            $total   = DB::table(DB::raw("({$union->toSql()}) as combined"))
                ->mergeBindings($union->getQuery())
                ->count();

            $rows = DB::table(DB::raw("({$union->toSql()}) as combined"))
                ->mergeBindings($union->getQuery())
                ->orderByDesc('created_at')
                ->offset(($page - 1) * $perPage)
                ->limit($perPage)
                ->get();

            // ── Enrich: lấy thêm tên user / partner ─────────────────────────
            $userIds    = $rows->pluck('user_id')->filter()->unique()->values();
            $partnerIds = $rows->pluck('partner_id')->filter()->unique()->values();

            $users    = $userIds->isNotEmpty()
                ? \App\Models\User::whereIn('id', $userIds)->pluck('name', 'id')
                : collect();
            $partners = $partnerIds->isNotEmpty()
                ? Partner::whereIn('id', $partnerIds)
                    ->select('id', 'company_name', 'bank_name', 'bank_account_number', 'bank_account_name')
                    ->get()
                    ->keyBy('id')
                : collect();

            $data = $rows->map(function ($row) use ($users, $partners) {
                $partnerModel = $row->partner_id ? ($partners[$row->partner_id] ?? null) : null;
                return [
                    'id'                  => $row->id . '_' . $row->source, // unique key
                    'reference_code'      => $row->reference_code,
                    'type'                => $row->type,
                    'status'              => $row->status,
                    'user_id'             => $row->user_id,
                    'user_name'           => $row->user_id ? ($users[$row->user_id] ?? null) : null,
                    'partner_id'          => $row->partner_id,
                    'partner_name'        => $partnerModel?->company_name,
                    'amount'              => (float) $row->amount,
                    'currency'            => $row->currency ?? 'VND',
                    'fee'                 => $row->fee !== null ? (float) $row->fee : null,
                    'net_amount'          => $row->net_amount !== null ? (float) $row->net_amount : null,
                    'bank_name'           => $partnerModel?->bank_name ?? $row->bank_name,
                    'bank_account_number' => $partnerModel?->bank_account_number ?? $row->bank_account_number,
                    'bank_account_name'   => $partnerModel?->bank_account_name ?? $row->bank_account_name,
                    'requested_at'        => $row->requested_at,
                    'processed_at'        => $row->processed_at,
                    'created_at'          => $row->created_at,
                    'updated_at'          => $row->updated_at,
                    'note'                => $row->notes,
                    'failure_reason'      => $row->failure_reason,
                ];
            });

            // ── Keyword filter (sau khi enrich để search theo tên) ───────────
            if ($keyword) {
                $kw = mb_strtolower($keyword);
                $data = $data->filter(function ($item) use ($kw) {
                    return str_contains(mb_strtolower($item['reference_code'] ?? ''), $kw)
                        || str_contains(mb_strtolower($item['partner_name'] ?? ''), $kw)
                        || str_contains(mb_strtolower($item['user_name'] ?? ''), $kw);
                })->values();
            }

            // ── Summary ──────────────────────────────────────────────────────
            $summary = $this->buildSummary();

            return response()->json([
                'data'         => $data,
                'summary'      => $summary,
                'total'        => $total,
                'current_page' => $page,
                'last_page'    => (int) ceil($total / $perPage),
                'per_page'     => $perPage,
            ]);
        } catch (\Exception $e) {
            Log::error('PaymentManagerController@index: ' . $e->getMessage());
            return response()->json(['message' => 'Internal server error', 'error' => $e->getMessage()], 500);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET /admin/payments/{id}
    // Chi tiết: id có dạng "123_payment" hoặc "456_payout"
    // ─────────────────────────────────────────────────────────────────────────
    public function show($id)
    {
        try {
            [$numId, $source] = array_pad(explode('_', $id, 2), 2, 'payment');

            if ($source === 'payout') {
                $payout = PartnerPayout::with('partner')->findOrFail((int) $numId);
                $partner = $payout->partner;

                return response()->json([
                    'data' => [
                        'id'                  => $payout->id . '_payout',
                        'reference_code'      => $payout->transaction_reference ?? 'PO-' . str_pad($payout->id, 7, '0', STR_PAD_LEFT),
                        'type'                => 'partner_payout',
                        'status'              => $payout->status,
                        'user_id'             => null,
                        'user_name'           => null,
                        'partner_id'          => $payout->partner_id,
                        'partner_name'        => $partner?->company_name,
                        'amount'              => (float) $payout->total_amount,
                        'currency'            => $payout->currency,
                        'fee'                 => (float) $payout->fee_amount,
                        'net_amount'          => (float) $payout->net_amount,
                        'bank_name'           => $partner?->bank_name ?? $payout->bank_name,
                        'bank_account_number' => $partner?->bank_account_number ?? $payout->account_number,
                        'bank_account_name'   => $partner?->bank_account_name,
                        'requested_at'        => $payout->created_at,
                        'processed_at'        => $payout->processed_at ?? $payout->completed_at,
                        'created_at'          => $payout->created_at,
                        'updated_at'          => $payout->updated_at,
                        'note'                => $payout->notes,
                        'failure_reason'      => $payout->failed_reason,
                    ],
                ]);
            }

            // ── Payment ──────────────────────────────────────────────────────
            $payment = Payment::with('user')->findOrFail((int) $numId);

            return response()->json([
                'data' => [
                    'id'                  => $payment->id . '_payment',
                    'reference_code'      => 'PAY-' . str_pad($payment->id, 7, '0', STR_PAD_LEFT),
                    'type'                => $payment->payment_type,
                    'status'              => $payment->status,
                    'user_id'             => $payment->user_id,
                    'user_name'           => $payment->user?->name,
                    'partner_id'          => null,
                    'partner_name'        => null,
                    'amount'              => (float) $payment->amount,
                    'currency'            => $payment->currency,
                    'fee'                 => null,
                    'net_amount'          => (float) $payment->amount,
                    'bank_name'           => $payment->bank_code,
                    'bank_account_number' => $payment->gateway_transaction_id,
                    'bank_account_name'   => null,
                    'requested_at'        => $payment->created_at,
                    'processed_at'        => $payment->paid_at,
                    'created_at'          => $payment->created_at,
                    'updated_at'          => $payment->updated_at,
                    'note'                => $payment->notes,
                    'failure_reason'      => $payment->failed_reason,
                ],
            ]);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException) {
            return response()->json(['message' => 'Transaction not found'], 404);
        } catch (\Exception $e) {
            Log::error('PaymentManagerController@show: ' . $e->getMessage());
            return response()->json(['message' => 'Internal server error'], 500);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // POST /admin/payments/{id}/approve
    // Duyệt giao dịch pending → completed
    // ─────────────────────────────────────────────────────────────────────────
    public function approve(Request $request, $id)
    {
        try {
            [$numId, $source] = array_pad(explode('_', $id, 2), 2, 'payment');
            $note = $request->get('note');

            if ($source === 'payout') {
                $payout = PartnerPayout::findOrFail((int) $numId);
                
                if ($payout->status !== 'pending') {
                    return response()->json(['message' => 'Only pending payouts can be approved'], 422);
                }

                $payout->update([
                    'status'       => 'completed',
                    'completed_at' => now(),
                    'processed_at' => now(),
                    'notes'        => $note ? ($payout->notes . "\n[Admin approved] " . $note) : $payout->notes,
                ]);

                return response()->json(['message' => 'Payout approved successfully', 'status' => 'completed']);
            }

            $payment = Payment::findOrFail((int) $numId);
            
            if ($payment->status !== 'pending') {
                return response()->json(['message' => 'Only pending payments can be approved'], 422);
            }

            $payment->markAsCompleted();
            if ($note) {
                $payment->update(['notes' => ($payment->notes ?? '') . "\n[Admin approved] " . $note]);
            }

            return response()->json(['message' => 'Payment approved successfully', 'status' => 'completed']);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException) {
            return response()->json(['message' => 'Transaction not found'], 404);
        } catch (\Exception $e) {
            Log::error('PaymentManagerController@approve: ' . $e->getMessage());
            return response()->json(['message' => 'Internal server error'], 500);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // POST /admin/payments/{id}/reject
    // Từ chối giao dịch pending → failed
    // ─────────────────────────────────────────────────────────────────────────
    public function reject(Request $request, $id)
    {
        $request->validate(['reason' => 'required|string|max:500']);
        $reason = $request->get('reason');

        try {
            [$numId, $source] = array_pad(explode('_', $id, 2), 2, 'payment');

            if ($source === 'payout') {
                $payout = PartnerPayout::findOrFail((int) $numId);

                if ($payout->status !== 'pending') {
                    return response()->json(['message' => 'Only pending payouts can be rejected'], 422);
                }

                $payout->update([
                    'status'        => 'failed',
                    'failed_reason' => $reason,
                    'processed_at'  => now(),
                ]);

                return response()->json(['message' => 'Payout rejected', 'status' => 'failed']);
            }

            $payment = Payment::findOrFail((int) $numId);

            if ($payment->status !== 'pending') {
                return response()->json(['message' => 'Only pending payments can be rejected'], 422);
            }

            $payment->markAsFailed($reason);

            return response()->json(['message' => 'Payment rejected', 'status' => 'failed']);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException) {
            return response()->json(['message' => 'Transaction not found'], 404);
        } catch (\Exception $e) {
            Log::error('PaymentManagerController@reject: ' . $e->getMessage());
            return response()->json(['message' => 'Internal server error'], 500);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET /admin/payments/summary
    // ─────────────────────────────────────────────────────────────────────────
    public function summary()
    {
        return response()->json(['data' => $this->buildSummary()]);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // GET /admin/payments/export?format=csv
    // ─────────────────────────────────────────────────────────────────────────
    public function export(Request $request)
    {
        $payments = Payment::with('user')
            ->orderByDesc('created_at')
            ->get()
            ->map(fn($p) => [
                'PAY-' . str_pad($p->id, 7, '0', STR_PAD_LEFT),
                $p->payment_type,
                $p->status,
                $p->user?->name ?? '',
                $p->amount,
                $p->currency,
                $p->created_at?->toDateTimeString(),
                $p->paid_at?->toDateTimeString(),
                $p->notes ?? '',
            ]);

        $payouts = PartnerPayout::with('partner')
            ->orderByDesc('created_at')
            ->get()
            ->map(fn($po) => [
                $po->transaction_reference ?? 'PO-' . str_pad($po->id, 7, '0', STR_PAD_LEFT),
                'partner_payout',
                $po->status,
                $po->partner?->company_name ?? '',
                $po->total_amount,
                $po->currency,
                $po->created_at?->toDateTimeString(),
                $po->completed_at?->toDateTimeString(),
                $po->notes ?? '',
            ]);

        $rows = $payments->concat($payouts);

        $csv  = "Reference,Type,Status,Party,Amount,Currency,Created At,Processed At,Notes\n";
        foreach ($rows as $row) {
            $csv .= implode(',', array_map(fn($v) => '"' . str_replace('"', '""', $v ?? '') . '"', $row)) . "\n";
        }

        return response($csv, 200, [
            'Content-Type'        => 'text/csv; charset=UTF-8',
            'Content-Disposition' => 'attachment; filename="payments_' . now()->format('Ymd_His') . '.csv"',
        ]);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Private helper: build summary stats
    // ─────────────────────────────────────────────────────────────────────────
    private function buildSummary(): array
    {
        $paymentTotal    = Payment::count();
        $payoutTotal     = PartnerPayout::count();

        $completedAmt = Payment::where('status', 'completed')->sum('amount')
                      + PartnerPayout::where('status', 'completed')->sum('total_amount');

        $pendingAmt   = Payment::where('status', 'pending')->sum('amount')
                      + PartnerPayout::where('status', 'pending')->sum('total_amount');

        $failedCount  = Payment::where('status', 'failed')->count()
                      + PartnerPayout::where('status', 'failed')->count();

        $thisMonthAmt = Payment::whereMonth('created_at', now()->month)
                            ->whereYear('created_at', now()->year)
                            ->sum('amount')
                      + PartnerPayout::whereMonth('created_at', now()->month)
                            ->whereYear('created_at', now()->year)
                            ->sum('total_amount');

        return [
            'total_payments'    => $paymentTotal + $payoutTotal,
            'total_amount'      => (float) ($completedAmt + $pendingAmt),
            'completed_amount'  => (float) $completedAmt,
            'pending_amount'    => (float) $pendingAmt,
            'failed_count'      => $failedCount,
            'this_month_amount' => (float) $thisMonthAmt,
        ];
    }
}

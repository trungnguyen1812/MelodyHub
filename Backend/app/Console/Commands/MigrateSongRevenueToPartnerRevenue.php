<?php

namespace App\Console\Commands;

use App\Models\Partner;
use App\Models\PartnerRevenue;
use App\Models\Song;
use Carbon\Carbon;
use Illuminate\Console\Command;

class MigrateSongRevenueToPartnerRevenue extends Command
{
    protected $signature = 'partners:migrate-revenue {--partner= : Specific partner ID}';
    protected $description = 'Migrate song revenue data to partner_revenues table';
    
    public function handle()
    {
        $partnerId = $this->option('partner');
        
        if ($partnerId) {
            $partners = Partner::where('id', $partnerId)->get();
        } else {
            $partners = Partner::all();
        }
        
        foreach ($partners as $partner) {
            $this->info("Processing partner: {$partner->company_name}");
            $this->migratePartnerRevenue($partner);
        }
        
        $this->info('Revenue migration completed!');
    }
    
    private function migratePartnerRevenue($partner)
    {
        // Lấy tất cả songs của partner
        $songs = Song::where('partner_id', $partner->id)->get();
        
        if ($songs->isEmpty()) {
            $this->warn("  No songs found for {$partner->company_name}");
            return;
        }
        
        // Nhóm songs theo tháng
        $songsByMonth = $songs->groupBy(function($song) {
            return Carbon::parse($song->created_at)->format('Y-m');
        });
        
        foreach ($songsByMonth as $yearMonth => $monthSongs) {
            $date = Carbon::parse($yearMonth . '-01');
            $startDate = $date->copy()->startOfMonth();
            $endDate = $date->copy()->endOfMonth();
            
            // Tính tổng plays và downloads trong tháng
            $totalPlays = $monthSongs->sum('total_plays');
            $totalDownloads = $monthSongs->sum('total_downloads');
            
            // Tính doanh thu (1 play = 10 VND, 1 download = 500 VND)
            $adRevenue = $totalPlays * 10;
            $subscriptionRevenue = $totalDownloads * 500;
            $totalRevenue = $adRevenue + $subscriptionRevenue;
            
            // Tính partner share
            $partnerSharePercent = $partner->revenue_share_percentage ?? 70;
            $partnerShareAmount = $totalRevenue * ($partnerSharePercent / 100);
            $platformShareAmount = $totalRevenue - $partnerShareAmount;
            $taxAmount = $partnerShareAmount * 0.1; // 10% tax
            $netPayout = $partnerShareAmount - $taxAmount;
            
            // Xác định status dựa trên thời gian
            $now = Carbon::now();
            $status = 'calculated';
            $paidAt = null;
            
            // Nếu là tháng cũ (trước tháng hiện tại) thì đánh dấu đã paid
            if ($date->endOfMonth()->lt($now)) {
                $status = 'paid';
                $paidAt = $date->endOfMonth()->addDays(15); // Ngày 15 tháng sau
            }
            
            // Tạo hoặc cập nhật bản ghi
            PartnerRevenue::updateOrCreate(
                [
                    'partner_id' => $partner->id,
                    'period_type' => 'monthly',
                    'period_start' => $startDate,
                    'period_end' => $endDate,
                ],
                [
                    'total_plays' => $totalPlays,
                    'total_downloads' => $totalDownloads,
                    'ad_revenue' => $adRevenue,
                    'subscription_revenue' => $subscriptionRevenue,
                    'total_revenue' => $totalRevenue,
                    'partner_share_percentage' => $partnerSharePercent,
                    'partner_share_amount' => $partnerShareAmount,
                    'platform_share_amount' => $platformShareAmount,
                    'tax_amount' => $taxAmount,
                    'net_payout' => $netPayout,
                    'status' => $status,
                    'calculated_at' => now(),
                    'paid_at' => $paidAt,
                ]
            );
            
            $this->info("  ✓ {$yearMonth}: " . number_format($totalRevenue) . " VND (status: {$status})");
        }
    }
}
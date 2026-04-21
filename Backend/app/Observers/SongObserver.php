<?php

namespace App\Observers;

use App\Models\Song;
use App\Models\PartnerRevenue;
use Carbon\Carbon;

class SongObserver
{
    /**
     * Handle the Song "updated" event (khi total_plays thay đổi)
     */
    public function updated(Song $song)
    {
        if ($song->wasChanged('total_plays') && $song->partner_id) {
            $this->calculateRevenue($song);
        }
    }
    
    /**
     * Tính doanh thu cho partner
     */
    private function calculateRevenue(Song $song)
    {
        $currentMonth = Carbon::now()->startOfMonth();
        $periodEnd = Carbon::now()->endOfMonth();
        
        // Giả sử 1 play = 10 VND, 1 download = 500 VND
        $adRevenue = $song->total_plays * 10;
        $subscriptionRevenue = $song->total_downloads * 500;
        $totalRevenue = $adRevenue + $subscriptionRevenue;
        
        // Lấy partner share percentage
        $partner = $song->partner;
        $partnerSharePercent = $partner->revenue_share_percentage ?? 70;
        
        // Tính toán
        $partnerShareAmount = $totalRevenue * ($partnerSharePercent / 100);
        $platformShareAmount = $totalRevenue - $partnerShareAmount;
        $taxAmount = $partnerShareAmount * 0.1; // 10% tax
        $netPayout = $partnerShareAmount - $taxAmount;
        
        // Tìm hoặc tạo bản ghi doanh thu tháng hiện tại
        $revenue = PartnerRevenue::firstOrCreate(
            [
                'partner_id' => $song->partner_id,
                'period_type' => 'monthly',
                'period_start' => $currentMonth,
                'period_end' => $periodEnd,
            ],
            [
                'total_plays' => 0,
                'total_downloads' => 0,
                'ad_revenue' => 0,
                'subscription_revenue' => 0,
                'total_revenue' => 0,
                'partner_share_percentage' => $partnerSharePercent,
                'partner_share_amount' => 0,
                'platform_share_amount' => 0,
                'tax_amount' => 0,
                'net_payout' => 0,
                'status' => 'pending',
            ]
        );
        
        // Cập nhật tổng
        $revenue->total_plays += $song->total_plays;
        $revenue->total_downloads += $song->total_downloads;
        $revenue->ad_revenue += $adRevenue;
        $revenue->subscription_revenue += $subscriptionRevenue;
        $revenue->total_revenue += $totalRevenue;
        $revenue->partner_share_amount += $partnerShareAmount;
        $revenue->platform_share_amount += $platformShareAmount;
        $revenue->tax_amount += $taxAmount;
        $revenue->net_payout += $netPayout;
        
        $revenue->save();
    }
}
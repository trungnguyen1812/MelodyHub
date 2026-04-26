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

        $partner = $song->partner;

        $songs = Song::where('partner_id', $song->partner_id)->get();

        $totalPlays = $songs->sum('total_plays');
        $totalDownloads = $songs->sum('total_downloads');

        $adRevenue = $totalPlays * 10;
        $subscriptionRevenue = $totalDownloads * 500;
        $totalRevenue = $adRevenue + $subscriptionRevenue;

        $partnerSharePercent = $partner->revenue_share_percentage ?? 70;

        $partnerShareAmount = $totalRevenue * ($partnerSharePercent / 100);
        $platformShareAmount = $totalRevenue - $partnerShareAmount;
        $taxAmount = $partnerShareAmount * 0.1;
        $netPayout = $partnerShareAmount - $taxAmount;

        PartnerRevenue::updateOrCreate(
            [
                'partner_id' => $song->partner_id,
                'period_type' => 'monthly',
                'period_start' => $currentMonth,
                'period_end' => $periodEnd,
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
            ]
        );
    }
}
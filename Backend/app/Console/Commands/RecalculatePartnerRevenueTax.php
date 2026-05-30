<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class RecalculatePartnerRevenueTax extends Command
{
    protected $signature   = 'partners:recalculate-tax';
    protected $description = 'Recalculate all partner_revenues based on 0.05đ/play with 10% tax on partner_share_amount';

    public function handle(): int
    {
        $count = DB::table('partner_revenues')->count();
        $this->info("Found {$count} partner_revenue records to recalculate.");

        if ($count === 0) {
            $this->warn('No records found.');
            return self::SUCCESS;
        }

        // Recalculate toàn bộ từ total_plays với đơn giá mới 0.05đ/play
        // total_revenue         = total_plays × 0.05
        // partner_share_amount  = total_revenue × (partner_share_percentage / 100)
        // platform_share_amount = total_revenue - partner_share_amount
        // tax_amount            = partner_share_amount × 0.1
        // net_payout            = partner_share_amount × 0.9
        DB::statement("
            UPDATE partner_revenues pr
            JOIN partners p ON p.id = pr.partner_id
            SET
                pr.ad_revenue            = ROUND(pr.total_plays * 0.05, 4),
                pr.total_revenue         = ROUND(pr.total_plays * 0.05, 4),
                pr.partner_share_amount  = ROUND(pr.total_plays * 0.05 * (COALESCE(p.revenue_share_percentage, 70) / 100), 4),
                pr.platform_share_amount = ROUND(pr.total_plays * 0.05 * (1 - COALESCE(p.revenue_share_percentage, 70) / 100), 4),
                pr.tax_amount            = ROUND(pr.total_plays * 0.05 * (COALESCE(p.revenue_share_percentage, 70) / 100) * 0.1, 4),
                pr.net_payout            = ROUND(pr.total_plays * 0.05 * (COALESCE(p.revenue_share_percentage, 70) / 100) * 0.9, 4),
                pr.updated_at            = NOW()
        ");

        $this->info('Recalculation complete.');
        $this->table(
            ['Metric', 'Value'],
            [
                ['Total records updated', $count],
                ['Total plays',           number_format(DB::table('partner_revenues')->sum('total_plays'))],
                ['Total revenue (0.05/play)', number_format(DB::table('partner_revenues')->sum('total_revenue'), 4)],
                ['Total partner share',   number_format(DB::table('partner_revenues')->sum('partner_share_amount'), 4)],
                ['Total tax (10%)',        number_format(DB::table('partner_revenues')->sum('tax_amount'), 4)],
                ['Total net payout',      number_format(DB::table('partner_revenues')->sum('net_payout'), 4)],
                ['Total platform share',  number_format(DB::table('partner_revenues')->sum('platform_share_amount'), 4)],
            ]
        );

        return self::SUCCESS;
    }
}

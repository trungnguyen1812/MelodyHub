<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Cập nhật trigger after_song_play_insert:
     * - Giữ nguyên 10đ/lượt play
     * - Tính đúng: partner_share_amount, platform_share, tax (10%), net_payout
     * - net_payout = partner_share_amount - tax_amount
     */
    public function up(): void
    {
        // Drop cả 2 trigger cũ (trigger gốc 10đ và trigger trùng lặp nếu có)
        DB::unprepared('DROP TRIGGER IF EXISTS after_song_play_insert');
        DB::unprepared('DROP TRIGGER IF EXISTS update_partner_revenue_on_play');

        DB::unprepared("
CREATE TRIGGER after_song_play_insert
AFTER INSERT ON song_plays
FOR EACH ROW
BEGIN
    DECLARE v_partner_id       BIGINT;
    DECLARE v_partner_share    DECIMAL(5,2);
    DECLARE v_revenue          DECIMAL(15,4);
    DECLARE v_partner_share_amount DECIMAL(15,4);
    DECLARE v_platform_share   DECIMAL(15,4);
    DECLARE v_tax_amount       DECIMAL(15,4);
    DECLARE v_net_payout       DECIMAL(15,4);

    SELECT partner_id INTO v_partner_id
    FROM songs WHERE id = NEW.song_id;

    IF v_partner_id IS NOT NULL THEN
        SET v_revenue = 0.05;

        SELECT COALESCE(revenue_share_percentage, 70) INTO v_partner_share
        FROM partners WHERE id = v_partner_id;

        SET v_partner_share_amount = v_revenue * (v_partner_share / 100);
        SET v_platform_share       = v_revenue - v_partner_share_amount;
        SET v_tax_amount           = v_partner_share_amount * 0.1;
        SET v_net_payout           = v_partner_share_amount - v_tax_amount;

        INSERT INTO partner_revenues (
            partner_id, song_id,
            period_type, period_start, period_end,
            total_plays, ad_revenue, total_revenue,
            partner_share_percentage, partner_share_amount,
            platform_share_amount, tax_amount, net_payout,
            status, calculated_at, updated_at
        )
        VALUES (
            v_partner_id, NEW.song_id,
            'monthly',
            DATE_FORMAT(NEW.played_at, '%Y-%m-01'),
            LAST_DAY(NEW.played_at),
            1, v_revenue, v_revenue,
            v_partner_share, v_partner_share_amount,
            v_platform_share, v_tax_amount, v_net_payout,
            'calculated', NOW(), NOW()
        )
        ON DUPLICATE KEY UPDATE
            total_plays           = total_plays + 1,
            ad_revenue            = ad_revenue + v_revenue,
            total_revenue         = total_revenue + v_revenue,
            partner_share_amount  = partner_share_amount + v_partner_share_amount,
            platform_share_amount = platform_share_amount + v_platform_share,
            tax_amount            = tax_amount + v_tax_amount,
            net_payout            = net_payout + v_net_payout,
            updated_at            = NOW();
    END IF;
END
        ");
    }

    public function down(): void
    {
        DB::unprepared('DROP TRIGGER IF EXISTS after_song_play_insert');

        // Khôi phục trigger cũ (10đ/play, không có tax)
        DB::unprepared("
CREATE TRIGGER after_song_play_insert
AFTER INSERT ON song_plays
FOR EACH ROW
BEGIN
    DECLARE v_partner_id       BIGINT;
    DECLARE v_partner_share    DECIMAL(5,2);
    DECLARE v_revenue          DECIMAL(15,2);
    DECLARE v_partner_share_amount DECIMAL(15,2);
    DECLARE v_platform_share   DECIMAL(15,2);

    SELECT partner_id INTO v_partner_id
    FROM songs WHERE id = NEW.song_id;

    IF v_partner_id IS NOT NULL THEN
        SET v_revenue = 10;

        SELECT COALESCE(revenue_share_percentage, 70) INTO v_partner_share
        FROM partners WHERE id = v_partner_id;

        SET v_partner_share_amount = v_revenue * (v_partner_share / 100);
        SET v_platform_share       = v_revenue - v_partner_share_amount;

        INSERT INTO partner_revenues (
            partner_id, song_id,
            period_type, period_start, period_end,
            total_plays, ad_revenue, total_revenue,
            partner_share_percentage, partner_share_amount,
            platform_share_amount, tax_amount, net_payout,
            status, calculated_at, updated_at
        )
        VALUES (
            v_partner_id, NEW.song_id,
            'monthly',
            DATE_FORMAT(NEW.played_at, '%Y-%m-01'),
            LAST_DAY(NEW.played_at),
            1, v_revenue, v_revenue,
            v_partner_share, v_partner_share_amount,
            v_platform_share, 0, v_partner_share_amount,
            'calculated', NOW(), NOW()
        )
        ON DUPLICATE KEY UPDATE
            total_plays           = total_plays + 1,
            ad_revenue            = ad_revenue + v_revenue,
            total_revenue         = total_revenue + v_revenue,
            partner_share_amount  = partner_share_amount + v_partner_share_amount,
            platform_share_amount = platform_share_amount + v_platform_share,
            updated_at            = NOW();
    END IF;
END
        ");
    }
};

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Thêm UNIQUE key (partner_id, song_id, period_start) để trigger
     * ON DUPLICATE KEY UPDATE hoạt động đúng — tránh tạo record trùng.
     */
    public function up(): void
    {
        Schema::table('partner_revenues', function (Blueprint $table) {
            $table->unique(['partner_id', 'song_id', 'period_start'], 'uq_partner_song_period');
        });
    }

    public function down(): void
    {
        Schema::table('partner_revenues', function (Blueprint $table) {
            $table->dropUnique('uq_partner_song_period');
        });
    }
};

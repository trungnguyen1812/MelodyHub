<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Chuẩn hóa songs.total_plays = COUNT thực tế từ bảng song_plays.
     * Dữ liệu cũ bị inflate do seeder/fake data không đồng bộ với song_plays.
     */
    public function up(): void
    {
        // Cập nhật total_plays trong songs = số bản ghi thực tế trong song_plays
        DB::statement("
            UPDATE songs s
            SET s.total_plays = (
                SELECT COUNT(*)
                FROM song_plays sp
                WHERE sp.song_id = s.id
            )
        ");
    }

    /**
     * Không thể rollback về dữ liệu cũ (đã bị inflate/sai).
     * Down chỉ ghi nhận — không làm gì.
     */
    public function down(): void
    {
        // Không rollback vì dữ liệu cũ là sai
    }
};

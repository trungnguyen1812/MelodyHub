<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('copyright_reports', function (Blueprint $table) {
            $table->id();

            // Bài bị báo cáo
            $table->foreignId('song_id')->constrained('songs')->cascadeOnDelete();

            // Người báo cáo (user hoặc partner)
            $table->foreignId('reporter_user_id')->constrained('users')->cascadeOnDelete();

            // Bài gốc của người báo cáo (nếu có)
            $table->foreignId('original_song_id')->nullable()->constrained('songs')->nullOnDelete();

            // Copyright của người báo cáo (nếu có)
            $table->foreignId('copyright_id')->nullable()->constrained('copyrights')->nullOnDelete();

            // Loại vi phạm
            $table->enum('violation_type', [
                'melody_copy',
                'lyrics_copy',
                'beat_copy',
                'full_copy',
                'unauthorized_remix',
                'other',
            ])->default('other');

            // Mô tả chi tiết
            $table->text('description')->nullable();

            // File bằng chứng
            $table->string('evidence_url')->nullable();

            // Trạng thái xử lý
            $table->enum('status', [
                'pending',           // chờ admin xem xét
                'under_review',      // admin đang xem xét
                'resolved_removed',  // report hợp lệ → bài bị gỡ
                'resolved_kept',     // report sai → bài giữ nguyên
                'dismissed',         // bác bỏ (spam/không hợp lệ)
            ])->default('pending');

            // Admin xử lý
            $table->foreignId('resolved_by')->nullable()->constrained('users')->nullOnDelete();
            $table->text('admin_note')->nullable();
            $table->timestamp('resolved_at')->nullable();

            $table->timestamps();

            $table->index(['song_id', 'status']);
            $table->index(['reporter_user_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('copyright_reports');
    }
};

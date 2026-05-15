<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Drop bảng cũ (trống) và tạo lại đầy đủ
        Schema::dropIfExists('notifications');

        Schema::create('notifications', function (Blueprint $table) {
            $table->id();

            // Người nhận
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();

            // Loại thông báo
            $table->enum('type', [
                'copyright_unverified',   // nhắc nhở bài chưa đăng ký bản quyền
                'copyright_pending',      // hồ sơ đang chờ duyệt
                'copyright_approved',     // hồ sơ được duyệt ✓
                'copyright_rejected',     // hồ sơ bị từ chối
                'copyright_disputed',     // bài bị report vi phạm ⚠
                'report_resolved',        // report đã được xử lý
                'system',                 // thông báo hệ thống chung
            ])->default('system');

            $table->string('title');
            $table->text('message');

            // Dữ liệu liên quan (song_id, copyright_id, report_id...)
            $table->json('data')->nullable();

            // Link điều hướng khi click
            $table->string('action_url')->nullable();

            $table->boolean('is_read')->default(false);
            $table->timestamp('read_at')->nullable();

            $table->timestamps();

            $table->index(['user_id', 'is_read']);
            $table->index(['user_id', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('notifications');
    }
};

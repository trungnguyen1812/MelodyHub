<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('songs', function (Blueprint $table) {
            $table->enum('copyright_status', [
                'unverified',   // mới upload, chưa nộp hồ sơ
                'pending',      // đã nộp hồ sơ, chờ admin duyệt
                'verified',     // admin đã duyệt ✓
                'rejected',     // admin từ chối
                'disputed',     // có report vi phạm đang xử lý ⚠
            ])->default('unverified')->after('status');
        });
    }

    public function down(): void
    {
        Schema::table('songs', function (Blueprint $table) {
            $table->dropColumn('copyright_status');
        });
    }
};

// database/migrations/2025_01_20_000001_create_song_fingerprints_table.php

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Chỉ tạo nếu bảng chưa tồn tại
        if (!Schema::hasTable('song_fingerprints')) {
            Schema::create('song_fingerprints', function (Blueprint $table) {
                $table->id();
                $table->foreignId('song_id')->constrained('songs')->onDelete('cascade');
                $table->text('fingerprint_hash');
                $table->text('fpcalc_raw_output')->nullable();
                $table->integer('duration');
                $table->string('fpcalc_version', 50)->nullable();
                $table->timestamp('generated_at')->useCurrent();
                
                $table->unique('song_id');
                $table->index('duration');
            });
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('song_fingerprints');
    }
};
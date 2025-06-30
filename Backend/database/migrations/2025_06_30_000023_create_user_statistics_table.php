<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('user_statistics', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('user_id')->unique();
            $table->unsignedInteger('total_uploads')->default(0);
            $table->unsignedBigInteger('total_upload_size')->default(0);
            $table->unsignedInteger('successful_uploads')->default(0);
            $table->unsignedInteger('failed_uploads')->default(0);
            $table->unsignedBigInteger('total_plays')->default(0);
            $table->unsignedBigInteger('total_listening_time')->default(0);
            $table->string('favorite_genre', 100)->nullable();
            $table->unsignedInteger('total_likes_given')->default(0);
            $table->unsignedInteger('total_likes_received')->default(0);
            $table->unsignedInteger('total_followers')->default(0);
            $table->unsignedInteger('total_following')->default(0);
            $table->unsignedInteger('total_downloads')->default(0);
            $table->unsignedInteger('monthly_downloads')->default(0);
            $table->decimal('total_revenue', 12, 2)->default(0);
            $table->decimal('monthly_revenue', 10, 2)->default(0);
            $table->decimal('total_royalties', 12, 2)->default(0);
            $table->timestamp('last_upload_at')->nullable();
            $table->timestamp('last_download_at')->nullable();
            $table->timestamp('last_activity_at')->nullable();
            $table->timestamp('monthly_stats_reset_at')->default(DB::raw('CURRENT_TIMESTAMP'));
            $table->timestamps();
            
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_statistics');
    }
};
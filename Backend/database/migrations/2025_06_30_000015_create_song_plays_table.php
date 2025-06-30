<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('song_plays', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('user_id')->nullable();
            $table->unsignedBigInteger('song_id');
            $table->timestamp('played_at')->default(DB::raw('CURRENT_TIMESTAMP'));
            $table->unsignedInteger('play_duration')->default(0);
            $table->decimal('completion_rate', 5, 2)->default(0);
            $table->enum('device_type', ['web', 'mobile', 'tablet', 'desktop'])->default('web');
            $table->string('ip_address', 45)->nullable();
            $table->char('country', 2)->nullable();
            $table->string('city', 100)->nullable();
            $table->text('user_agent')->nullable();
            $table->string('source', 50)->nullable();
            $table->unsignedBigInteger('source_id')->nullable();
            
            $table->foreign('user_id')->references('id')->on('users')->onDelete('set null');
            $table->foreign('song_id')->references('id')->on('songs')->onDelete('cascade');
            $table->index(['song_id', 'played_at'], 'idx_song_plays');
            $table->index(['user_id', 'played_at'], 'idx_user_plays');
            $table->index('played_at', 'idx_date_plays');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('song_plays');
    }
};
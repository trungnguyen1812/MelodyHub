<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('downloads', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('user_id');
            $table->unsignedBigInteger('song_id');
            $table->string('download_url', 500)->nullable();
            $table->string('file_format', 10)->nullable();
            $table->string('file_quality', 20)->nullable();
            $table->unsignedBigInteger('file_size')->nullable();
            $table->enum('status', ['pending', 'generating', 'ready', 'downloaded', 'expired', 'failed'])->default('pending');
            $table->timestamp('expires_at')->nullable();
            $table->timestamp('downloaded_at')->nullable();
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->timestamps();
            
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('song_id')->references('id')->on('songs')->onDelete('cascade');
            $table->index(['user_id', 'created_at'], 'idx_user_downloads');
            $table->index('song_id', 'idx_song_downloads');
            $table->index(['status', 'expires_at'], 'idx_status');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('downloads');
    }
};
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('comments', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('user_id');
            $table->unsignedBigInteger('song_id');
            $table->unsignedBigInteger('parent_id')->nullable();
            $table->text('content');
            $table->unsignedInteger('like_count')->default(0);
            $table->enum('status', ['active', 'pending', 'deleted'])->default('pending');
            $table->timestamps();
            $table->softDeletes();
            
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('song_id')->references('id')->on('songs')->onDelete('cascade');
            $table->foreign('parent_id')->references('id')->on('comments')->onDelete('cascade');
            $table->index(['song_id', 'created_at'], 'idx_song_comments');
            $table->index('user_id', 'idx_user_comments');
            $table->index('parent_id', 'idx_parent');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('comments');
    }
};
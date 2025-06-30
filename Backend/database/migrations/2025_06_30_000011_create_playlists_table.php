<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('playlists', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->uuid('uuid')->unique()->default(DB::raw('(UUID())'));
            $table->unsignedBigInteger('user_id');
            $table->string('name');
            $table->string('slug');
            $table->text('description')->nullable();
            $table->string('cover_url', 500)->nullable();
            $table->boolean('is_public')->default(true);
            $table->boolean('is_collaborative')->default(false);
            $table->boolean('allow_comments')->default(true);
            $table->unsignedInteger('total_songs')->default(0);
            $table->unsignedInteger('total_duration')->default(0);
            $table->unsignedBigInteger('total_plays')->default(0);
            $table->unsignedInteger('follower_count')->default(0);
            $table->boolean('is_featured')->default(false);
            $table->timestamp('featured_at')->nullable();
            $table->timestamps();
            
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->index('user_id', 'idx_user');
            $table->index('is_public', 'idx_public');
            $table->index('is_featured', 'idx_features');
            $table->index(['slug', 'user_id'], 'idx_slug');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('playlists');
    }
};
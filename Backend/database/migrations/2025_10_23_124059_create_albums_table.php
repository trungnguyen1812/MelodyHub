<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('albums', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('slug')->unique();
            $table->foreignId('artist_id')->constrained('artists')->cascadeOnDelete();
            $table->string('cover_url', 500)->nullable();
            $table->text('description')->nullable();
            $table->date('release_date')->nullable();
            $table->enum('album_type', ['album', 'single', 'ep', 'compilation', 'live'])->default('album');
            $table->string('label')->nullable()->comment('Record label');
            $table->integer('total_tracks')->default(0);
            $table->integer('total_duration')->default(0);
            $table->unsignedBigInteger('total_plays')->default(0);
            $table->unsignedBigInteger('total_likes')->default(0);
            $table->boolean('is_featured')->default(false);
            $table->boolean('is_premium')->default(false);
            $table->unsignedBigInteger('partner_id')->nullable();
            $table->enum('status', ['published', 'draft', 'pending', 'rejected', 'archived'])->default('draft');
            $table->timestamp('published_at')->nullable();
            $table->string('seo_title')->nullable();
            $table->text('seo_description')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->index('artist_id', 'idx_artist');
            $table->index('partner_id', 'idx_partner');
            $table->index('status', 'idx_status');
            $table->index('release_date', 'idx_release_date');
            $table->fullText(['name', 'description'], 'ft_search');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('albums');
    }
};

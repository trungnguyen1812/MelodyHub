<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('albums', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->uuid('uuid')->unique()->default(DB::raw('(UUID())'));
            $table->string('title');
            $table->string('slug');
            $table->text('description')->nullable();
            $table->string('cover', 255)->nullable();
            $table->string('cover_url', 500)->nullable();
            $table->unsignedBigInteger('artist_id');
            $table->enum('album_type', ['album', 'ep', 'single', 'compilation'])->default('album');
            $table->date('release_date')->nullable();
            $table->string('record_label', 255)->nullable();
            $table->string('producer', 255)->nullable();
            $table->unsignedBigInteger('uploader_id');
            $table->enum('source_type', ['official', 'user_upload', 'provider_upload']);
            $table->unsignedInteger('total_tracks')->default(0);
            $table->unsignedInteger('total_duration')->default(0);
            $table->unsignedBigInteger('total_plays')->default(0);
            $table->enum('status', ['active', 'draft', 'pending', 'blocked'])->default('active');
            $table->timestamps();

            $table->foreign('artist_id')->references('id')->on('artists')->onDelete('cascade');
            $table->foreign('uploader_id')->references('id')->on('users');
            $table->index('artist_id', 'idx_artist');
            $table->index('uploader_id', 'idx_uploader');
            $table->index('album_type', 'idx_type');
            $table->index('release_date', 'idx_release');
            $table->index(['slug', 'artist_id'], 'idx_slug');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('albums');
    }
};

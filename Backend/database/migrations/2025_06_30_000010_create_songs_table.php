<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('songs', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->uuid('uuid')->unique()->default(DB::raw('(UUID())'));
            $table->string('title');
            $table->string('slug');
            $table->unsignedBigInteger('artist_id');
            $table->unsignedBigInteger('album_id')->nullable();
            $table->unsignedBigInteger('uploader_id');
            $table->unsignedInteger('duration')->default(0);
            $table->unsignedInteger('track_number')->nullable();
            $table->unsignedInteger('disc_number')->default(1);
            $table->year('year')->nullable();
            $table->string('mood', 100)->nullable();
            $table->string('language', 10)->nullable();
            $table->boolean('explicit_content')->default(false);
            $table->unsignedInteger('bitrate')->nullable();
            $table->unsignedInteger('sample_rate')->nullable();
            $table->unsignedBigInteger('file_size')->nullable();
            $table->string('audio_format', 10)->nullable();
            $table->string('song_url', 500);
            $table->string('cloudinary_public_id', 255)->unique();
            $table->string('cloudinary_folder', 255)->nullable();
            $table->string('cover_url', 500)->nullable();
            $table->string('cover_public_id', 255)->nullable();
            $table->text('lyrics')->nullable();
            $table->string('lyrics_language', 10)->nullable();
            $table->boolean('has_lyrics')->default(false);
            $table->enum('source_type', ['official', 'user_upload', 'provider_upload']);
            $table->enum('copyright_status', ['verified', 'unverified', 'disputed', 'claimed'])->default('unverified');
            $table->string('copyright_owner', 255)->nullable();
            $table->enum('license_type', ['all_rights_reserved', 'creative_commons', 'royalty_free'])->default('all_rights_reserved');
            $table->boolean('is_premium')->default(false);
            $table->boolean('is_downloadable')->default(false);
            $table->decimal('download_price', 8, 2)->default(0.00);
            $table->boolean('requires_subscription')->default(false);
            $table->unsignedBigInteger('play_count')->default(0);
            $table->unsignedInteger('download_count')->default(0);
            $table->unsignedInteger('like_count')->default(0);
            $table->unsignedInteger('comment_count')->default(0);
            $table->unsignedInteger('share_count')->default(0);
            $table->timestamp('last_played_at')->nullable();
            $table->decimal('trending_score', 10, 4)->default(0);
            $table->enum('status', ['active', 'pending', 'processing', 'blocked', 'deleted', 'draft'])->default('pending');
            $table->enum('moderation_status', ['approved', 'pending', 'flagged', 'rejected'])->default('pending');
            $table->text('flagged_reason')->nullable();
            $table->text('meta_description')->nullable();
            $table->json('tags')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->foreign('artist_id')->references('id')->on('artists');
            $table->foreign('album_id')->references('id')->on('albums');
            $table->foreign('uploader_id')->references('id')->on('users');
            $table->index('artist_id', 'idx_artist');
            $table->index('album_id', 'idx_album');
            $table->index('uploader_id', 'idx_uploader');
            $table->index('status', 'idx_status');
            $table->index('source_type', 'idx_source');
            $table->index('is_premium', 'idx_premium');
            $table->index('play_count', 'idx_plays');
            $table->index('trending_score', 'idx_trending');
            $table->index('created_at', 'idx_created');
            $table->index(['title', 'artist_id'], 'idx_title_search');
            $table->text('tags_text')->storedAs("JSON_UNQUOTE(JSON_EXTRACT(tags, '$'))");
            $table->fullText(['title', 'lyrics', 'tags_text'], 'idx_search');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('songs');
    }
};

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('artists', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->uuid('uuid')->unique()->default(DB::raw('(UUID())'));
            $table->string('name');
            $table->string('slug')->unique();
            $table->text('bio')->nullable();
            $table->string('avatar_url', 500)->nullable();
            $table->string('cover_image_url', 500)->nullable();
            $table->string('real_name', 255)->nullable();
            $table->date('birth_date')->nullable();
            $table->date('death_date')->nullable();
            $table->char('country', 2)->nullable();
            $table->json('genres')->nullable();
            $table->string('website_url', 500)->nullable();
            $table->json('social_links')->nullable();
            $table->boolean('is_verified')->default(false);
            $table->timestamp('verified_at')->nullable();
            $table->unsignedBigInteger('verified_by')->nullable();
            $table->unsignedInteger('total_songs')->default(0);
            $table->unsignedInteger('total_albums')->default(0);
            $table->unsignedBigInteger('total_plays')->default(0);
            $table->unsignedInteger('total_downloads')->default(0);
            $table->enum('status', ['active', 'inactive', 'pending'])->default('active');
            $table->timestamps();
            
            $table->foreign('verified_by')->references('id')->on('users');
            $table->index('name', 'idx_name');
            $table->index('slug', 'idx_slug');
            $table->index('is_verified', 'idx_verified');
            $table->index('status', 'idx_status');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('artists');
    }
};
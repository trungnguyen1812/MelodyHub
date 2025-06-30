<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('recommendations', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('user_id');
            $table->unsignedBigInteger('song_id')->nullable();
            $table->unsignedBigInteger('artist_id')->nullable();
            $table->unsignedBigInteger('album_id')->nullable();
            $table->string('type', 50); // song, artist, album
            $table->decimal('score', 5, 2); // recommendation score
            $table->string('source', 50)->nullable(); // algorithm, curator, trending
            $table->timestamps();
            
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('song_id')->references('id')->on('songs')->onDelete('cascade');
            $table->foreign('artist_id')->references('id')->on('artists')->onDelete('cascade');
            $table->foreign('album_id')->references('id')->on('albums')->onDelete('cascade');
            $table->index(['user_id', 'type'], 'idx_user_recommendations');
            $table->index('score', 'idx_score');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('recommendations');
    }
};
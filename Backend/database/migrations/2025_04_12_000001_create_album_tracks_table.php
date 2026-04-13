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
        Schema::create('album_tracks', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('album_id');
            $table->unsignedBigInteger('track_id');
            $table->integer('position')->default(0);
            $table->timestamps();

            // Foreign keys
            $table->foreign('album_id')
                ->references('id')
                ->on('albums')
                ->cascadeOnDelete();

            $table->foreign('track_id')
                ->references('id')
                ->on('songs')
                ->cascadeOnDelete();

            // Indexes
            $table->unique(['album_id', 'track_id'], 'unique_album_track');
            $table->index('album_id', 'idx_album_id');
            $table->index('track_id', 'idx_track_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('album_tracks');
    }
};

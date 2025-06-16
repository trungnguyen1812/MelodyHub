<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateSongsTable extends Migration {
    public function up(): void {
        Schema::create('songs', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->foreignId('artist_id')->constrained('artists')->onDelete('cascade');
            $table->foreignId('album_id')->nullable()->constrained('albums')->onDelete('set null');
            $table->integer('duration');
            $table->string('genre')->nullable();
            $table->string('song_url');
            $table->string('cover_url')->nullable();
            $table->timestamps();
        });
    }
    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('songs');
    }
};

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

// 7. create_song_plays_table.php
class CreateSongPlaysTable extends Migration {
    public function up(): void {
        Schema::create('song_plays', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->nullable()->constrained('users')->onDelete('set null');
            $table->foreignId('song_id')->constrained('songs')->onDelete('cascade');
            $table->timestamp('played_at')->useCurrent();
            $table->string('device_info')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('song_plays');
    }
};

<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('playlist_songs', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('playlist_id');
            $table->unsignedBigInteger('song_id');
            $table->unsignedInteger('position');
            $table->unsignedBigInteger('added_by');
            $table->timestamp('added_at')->default(DB::raw('CURRENT_TIMESTAMP'));
            
            $table->foreign('playlist_id')->references('id')->on('playlists')->onDelete('cascade');
            $table->foreign('song_id')->references('id')->on('songs')->onDelete('cascade');
            $table->foreign('added_by')->references('id')->on('users');
            $table->unique(['playlist_id', 'song_id', 'position'], 'unique_playlist_song');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('playlist_songs');
    }
};
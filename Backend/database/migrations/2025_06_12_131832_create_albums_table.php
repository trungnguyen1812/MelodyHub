<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

// 3. create_albums_table.php
class CreateAlbumsTable extends Migration {
    public function up(): void {
        Schema::create('albums', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->foreignId('artist_id')->constrained('artists')->onDelete('cascade');
            $table->string('cover_url')->nullable();
            $table->date('release_date')->nullable();
            $table->timestamps();
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

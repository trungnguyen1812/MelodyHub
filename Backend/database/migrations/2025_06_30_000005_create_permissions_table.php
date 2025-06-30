<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('permissions', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name', 100)->unique();
            $table->string('display_name', 100);
            $table->text('description')->nullable();
            $table->string('group', 50)->nullable();
            $table->timestamps();
            
            $table->index('name', 'idx_name');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('permissions');
    }
};
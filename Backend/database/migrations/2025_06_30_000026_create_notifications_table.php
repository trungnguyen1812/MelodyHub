<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('notifications', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->uuid('uuid')->unique()->default(DB::raw('(UUID())'));
            $table->unsignedBigInteger('user_id');
            $table->string('type', 100);
            $table->string('notifiable_type', 100);
            $table->unsignedBigInteger('notifiable_id');
            $table->json('data');
            $table->timestamp('read_at')->nullable();
            $table->timestamps();
            
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->index(['user_id', 'read_at'], 'idx_user_notifications');
            $table->index(['notifiable_type', 'notifiable_id'], 'idx_notifiable');
            $table->index('type', 'idx_type');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('notifications');
    }
};
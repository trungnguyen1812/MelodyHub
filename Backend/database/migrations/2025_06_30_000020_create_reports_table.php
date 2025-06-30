<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('reports', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->uuid('uuid')->unique()->default(DB::raw('(UUID())'));
            $table->unsignedBigInteger('reporter_id')->nullable();
            $table->string('reporter_email', 255)->nullable();
            $table->string('reporter_name', 255)->nullable();
            $table->unsignedBigInteger('reported_user_id')->nullable();
            $table->unsignedBigInteger('song_id')->nullable();
            $table->unsignedBigInteger('comment_id')->nullable();
            $table->enum('report_type', ['copyright', 'fake_content', 'inappropriate', 'spam', 'harassment', 'impersonation', 'other']);
            $table->string('title');
            $table->text('description');
            $table->json('evidence_urls')->nullable();
            $table->enum('status', ['pending', 'investigating', 'escalated', 'resolved', 'rejected', 'duplicate'])->default('pending');
            $table->enum('priority', ['low', 'medium', 'high', 'critical'])->default('medium');
            $table->unsignedBigInteger('assigned_to')->nullable();
            $table->text('admin_notes')->nullable();
            $table->text('resolution_notes')->nullable();
            $table->unsignedBigInteger('resolved_by')->nullable();
            $table->timestamp('resolved_at')->nullable();
            $table->boolean('requires_follow_up')->default(false);
            $table->date('follow_up_date')->nullable();
            $table->timestamps();
            
            $table->foreign('reporter_id')->references('id')->on('users')->onDelete('set null');
            $table->foreign('reported_user_id')->references('id')->on('users')->onDelete('set null');
            $table->foreign('song_id')->references('id')->on('songs')->onDelete('set null');
            $table->foreign('comment_id')->references('id')->on('comments')->onDelete('set null');
            $table->foreign('assigned_to')->references('id')->on('users');
            $table->foreign('resolved_by')->references('id')->on('users');
            $table->index('status', 'idx_status');
            $table->index('report_type', 'idx_type');
            $table->index('assigned_to', 'idx_assigned');
            $table->index('created_at', 'idx_created');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('reports');
    }
};
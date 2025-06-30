<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('copyright_claims', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->uuid('uuid')->unique()->default(DB::raw('(UUID())'));
            $table->unsignedBigInteger('song_id');
            $table->string('claimant_name');
            $table->string('claimant_email');
            $table->string('claimant_phone', 20)->nullable();
            $table->string('organization', 255)->nullable();
            $table->enum('claim_type', ['owner', 'exclusive_license', 'representative', 'automated_system']);
            $table->string('work_title');
            $table->string('original_work_url', 500)->nullable();
            $table->string('registration_number', 100)->nullable();
            $table->text('evidence_description');
            $table->json('evidence_files')->nullable();
            $table->boolean('sworn_statement')->default(false);
            $table->enum('status', ['pending', 'valid', 'invalid', 'resolved', 'counter_claimed', 'withdrawn'])->default('pending');
            $table->text('admin_notes')->nullable();
            $table->unsignedBigInteger('resolved_by')->nullable();
            $table->timestamp('resolved_at')->nullable();
            $table->enum('resolution_action', ['content_removed', 'access_restricted', 'revenue_shared', 'claim_rejected'])->nullable();
            $table->timestamp('counter_claim_deadline')->nullable();
            $table->boolean('has_counter_claim')->default(false);
            $table->timestamps();
            
            $table->foreign('song_id')->references('id')->on('songs')->onDelete('cascade');
            $table->foreign('resolved_by')->references('id')->on('users');
            $table->index('song_id', 'idx_song');
            $table->index('status', 'idx_status');
            $table->index('claimant_email', 'idx_claimant');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('copyright_claims');
    }
};
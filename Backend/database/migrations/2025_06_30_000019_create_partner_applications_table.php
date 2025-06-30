<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('partner_applications', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->uuid('uuid')->unique()->default(DB::raw('(UUID())'));
            $table->string('full_name');
            $table->string('email');
            $table->string('phone', 20)->nullable();
            $table->string('organization_name');
            $table->enum('organization_type', ['individual', 'company', 'label', 'distributor'])->nullable();
            $table->string('business_license', 500)->nullable();
            $table->string('tax_id', 50)->nullable();
            $table->text('description');
            $table->string('portfolio_url', 500)->nullable();
            $table->unsignedInteger('years_of_experience')->nullable();
            $table->unsignedInteger('expected_monthly_uploads')->nullable();
            $table->enum('status', ['pending', 'approved', 'rejected', 'requires_info'])->default('pending');
            $table->text('admin_notes')->nullable();
            $table->text('rejection_reason')->nullable();
            $table->unsignedBigInteger('processed_by')->nullable();
            $table->timestamp('processed_at')->nullable();
            $table->boolean('follow_up_required')->default(false);
            $table->date('follow_up_date')->nullable();
            $table->timestamps();
            
            $table->foreign('processed_by')->references('id')->on('users');
            $table->index('status', 'idx_status');
            $table->index('email', 'idx_email');
            $table->index('created_at', 'idx_created');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('partner_applications');
    }
};
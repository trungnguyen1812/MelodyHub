<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('subscriptions', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->uuid('uuid')->unique()->default(DB::raw('(UUID())'));
            $table->unsignedBigInteger('user_id')->unique();
            $table->enum('plan_type', ['monthly', 'yearly']);
            $table->enum('status', ['active', 'cancelled', 'expired', 'suspended'])->default('active');
            $table->timestamp('started_at');
            $table->timestamp('expires_at');
            $table->timestamp('cancelled_at')->nullable();
            $table->boolean('auto_renew')->default(true);
            $table->timestamp('next_billing_date')->nullable();
            $table->unsignedInteger('billing_cycle_day')->default(1);
            $table->unsignedBigInteger('payment_id')->nullable();
            $table->decimal('monthly_price', 8, 2)->nullable();
            $table->unsignedInteger('monthly_downloads')->default(0);
            $table->unsignedInteger('download_limit')->default(1000);
            $table->timestamp('downloads_reset_at')->nullable();
            $table->timestamps();
            
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('payment_id')->references('id')->on('payments');
            $table->index(['status', 'expires_at'], 'idx_status_expires');
            $table->index(['auto_renew', 'next_billing_date'], 'idx_auto_renew');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('subscriptions');
    }
};
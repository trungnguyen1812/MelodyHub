<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('payments', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->uuid('uuid')->unique()->default(DB::raw('(UUID())'));
            $table->unsignedBigInteger('user_id');
            $table->string('transaction_id', 100)->unique()->nullable();
            $table->enum('payment_method', ['vnpay', 'momo', 'banking', 'paypal', 'stripe']);
            $table->decimal('amount', 10, 2);
            $table->string('currency', 3)->default('VND');
            $table->enum('payment_type', ['subscription', 'download', 'tip', 'advertisement']);
            $table->enum('subscription_plan', ['monthly_vip', 'yearly_vip'])->nullable();
            $table->unsignedInteger('subscription_months')->nullable();
            $table->enum('status', ['pending', 'processing', 'completed', 'failed', 'cancelled', 'refunded'])->default('pending');
            $table->timestamp('payment_date')->nullable();
            $table->timestamp('subscription_start_date')->nullable();
            $table->timestamp('subscription_end_date')->nullable();
            $table->string('gateway_transaction_id', 255)->nullable();
            $table->json('gateway_response')->nullable();
            $table->text('failure_reason')->nullable();
            $table->timestamp('refunded_at')->nullable();
            $table->text('refund_reason')->nullable();
            $table->decimal('refund_amount', 10, 2)->nullable();
            $table->timestamps();
            
            $table->foreign('user_id')->references('id')->on('users');
            $table->index('user_id', 'idx_user_payments');
            $table->index('status', 'idx_status');
            $table->index('transaction_id', 'idx_transaction');
            $table->index('payment_date', 'idx_payment_date');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('payments');
    }
};
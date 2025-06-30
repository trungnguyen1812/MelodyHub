<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;
return new class extends Migration
{
    /**
     * Run the migrations.
     */
 public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->uuid('uuid')->unique()->default(DB::raw('(UUID())'));
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->string('display_name');
            $table->string('first_name', 100)->nullable();
            $table->string('last_name', 100)->nullable();
            $table->text('bio')->nullable();
            $table->string('avatar_url', 500)->nullable();
            $table->string('cover_image_url', 500)->nullable();
            $table->date('date_of_birth')->nullable();
            $table->enum('gender', ['male', 'female', 'other', 'prefer_not_to_say'])->nullable();
            $table->char('country', 2)->nullable();
            $table->string('city', 100)->nullable();
            $table->unsignedBigInteger('role_id');
            $table->enum('status', ['active', 'suspended', 'pending', 'banned'])->default('active');
            $table->enum('subscription_status', ['free', 'vip', 'expired'])->default('free');
            $table->timestamp('subscription_outcome_at')->nullable();
            $table->timestamp('subscription_expires_at')->nullable();
            $table->boolean('auto_renew')->default(false);
            $table->boolean('is_verified')->default(false);
            $table->string('organization_name', 255)->nullable();
            $table->string('business_license', 255)->nullable();
            $table->string('tax_id', 50)->nullable();
            $table->string('cloudinary_folder', 255)->nullable();
            $table->json('social_links')->nullable();
            $table->unsignedInteger('total_uploads')->default(0);
            $table->unsignedInteger('monthly_uploads')->default(0);
            $table->timestamp('monthly_upload_reset_at')->default(DB::raw('CURRENT_TIMESTAMP'));
            $table->unsignedBigInteger('storage_used')->default(0);
            $table->string('remember_token', 100)->nullable();
            $table->text('two_factor_secret')->nullable();
            $table->boolean('two_factor_enabled')->default(false);
            $table->timestamp('last_login_at')->nullable();
            $table->string('last_login_ip', 45)->nullable();
            $table->timestamps();
            $table->softDeletes();
            
            $table->foreign('role_id')->references('id')->on('roles');
            
            $table->index('email', 'idx_email');
            $table->index('role_id', 'idx_role');
            $table->index('status', 'idx_status');
            $table->index(['subscription_status', 'subscription_expires_at'], 'idx_subscription');
            $table->index('created_at', 'idx_created');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
        Schema::dropIfExists('password_reset_tokens');
        Schema::dropIfExists('sessions');
    }
};

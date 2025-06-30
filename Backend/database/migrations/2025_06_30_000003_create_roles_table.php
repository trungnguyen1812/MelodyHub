<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('roles', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name', 50)->unique();
            $table->string('display_name', 100);
            $table->text('description')->nullable();
            $table->json('permissions')->nullable();
            $table->unsignedBigInteger('max_upload_size')->default(0);
            $table->unsignedInteger('max_monthly_uploads')->default(0);
            $table->boolean('can_download')->default(false);
            $table->boolean('can_upload')->default(false);
            $table->timestamps();
            $table->index('name', 'idx_name');
        });

        DB::table('roles')->insert([
            [
                'name' => 'admin',
                'display_name' => 'Administrator',
                'description' => 'Full system access',
                'permissions' => json_encode(['*']),
                'max_upload_size' => 0,
                'max_monthly_uploads' => 0,
                'can_download' => true,
                'can_upload' => true,
            ],
            [
                'name' => 'user',
                'display_name' => 'Free User',
                'description' => 'Basic listening features',
                'permissions' => json_encode(['listen', 'comment', 'like', 'playlist']),
                'max_upload_size' => 0,
                'max_monthly_uploads' => 0,
                'can_download' => false,
                'can_upload' => false,
            ],
            [
                'name' => 'vip_user',
                'display_name' => 'VIP User',
                'description' => 'Premium features + limited upload',
                'permissions' => json_encode(['listen', 'comment', 'like', 'playlist', 'download', 'upload_personal']),
                'max_upload_size' => 50,
                'max_monthly_uploads' => 20,
                'can_download' => true,
                'can_upload' => true,
            ],
            [
                'name' => 'provider',
                'display_name' => 'Content Provider',
                'description' => 'Commercial music provider',
                'permissions' => json_encode(['listen', 'comment', 'like', 'playlist', 'download', 'upload_commercial', 'analytics']),
                'max_upload_size' => 200,
                'max_monthly_uploads' => 100,
                'can_download' => true,
                'can_upload' => true,
            ],
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('roles');
    }
};
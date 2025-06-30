<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('system_settings', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('setting_key', 100)->unique();
            $table->text('setting_value')->nullable();
            $table->enum('setting_type', ['string', 'integer', 'boolean', 'json', 'float'])->default('string');
            $table->text('description')->nullable();
            $table->boolean('is_public')->default(false);
            $table->string('category', 50)->default('general');
            $table->timestamps();
            
            $table->index('category', 'idx_category');
            $table->index('is_public', 'idx_public');
        });

        DB::table('system_settings')->insert([
            [
                'setting_key' => 'max_file_size_mb',
                'setting_value' => '50',
                'setting_type' => 'integer',
                'description' => 'Maximum file size for uploads in MB',
                'category' => 'upload',
            ],
            [
                'setting_key' => 'allowed_audio_formats',
                'setting_value' => json_encode(['mp3', 'wav', 'flac']),
                'setting_type' => 'json',
                'description' => 'Allowed audio file formats',
                'category' => 'upload',
            ],
            [
                'setting_key' => 'vip_monthly_price',
                'setting_value' => '50000',
                'setting_type' => 'integer',
                'description' => 'VIP monthly subscription price in VND',
                'category' => 'pricing',
            ],
            [
                'setting_key' => 'vip_yearly_price',
                'setting_value' => '500000',
                'setting_type' => 'integer',
                'description' => 'VIP yearly subscription price in VND',
                'category' => 'pricing',
            ],
            [
                'setting_key' => 'max_playlist_songs',
                'setting_value' => '500',
                'setting_type' => 'integer',
                'description' => 'Maximum songs per playlist',
                'category' => 'limits',
            ],
            [
                'setting_key' => 'trending_weight',
                'setting_value' => '0.7',
                'setting_type' => 'float',
                'description' => 'Weight for trending calculation',
                'category' => 'algorithm',
            ],
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('system_settings');
    }
};
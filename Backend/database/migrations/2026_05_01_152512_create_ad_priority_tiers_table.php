<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('ad_priority_tiers', function (Blueprint $table) {
            $table->id();
            $table->string('value', 50)->unique()->comment('Tier key: standard, enhanced, premium');
            $table->string('label', 100)->comment('Display name');
            $table->string('color', 20)->default('#888fa0')->comment('Hex color for UI');
            $table->decimal('min_cpm', 10, 6)->default(0.002000)->comment('Minimum cost per play');
            $table->decimal('min_cpc', 10, 6)->default(0.005000)->comment('Minimum cost per click');
            $table->unsignedInteger('max_priority')->default(33)->comment('Max priority value for this tier');
            $table->string('description', 255)->nullable()->comment('Short description shown in UI');
            $table->unsignedInteger('sort_order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        // Seed default tiers
        DB::table('ad_priority_tiers')->insert([
            [
                'value'        => 'standard',
                'label'        => 'Standard',
                'color'        => '#888fa0',
                'min_cpm'      => 0.002000,
                'min_cpc'      => 0.005000,
                'max_priority' => 33,
                'description'  => 'General reach, competitive queue',
                'sort_order'   => 1,
                'is_active'    => true,
                'created_at'   => now(),
                'updated_at'   => now(),
            ],
            [
                'value'        => 'enhanced',
                'label'        => 'Enhanced',
                'color'        => '#00aaff',
                'min_cpm'      => 0.005000,
                'min_cpc'      => 0.012000,
                'max_priority' => 66,
                'description'  => 'Higher visibility, better placement',
                'sort_order'   => 2,
                'is_active'    => true,
                'created_at'   => now(),
                'updated_at'   => now(),
            ],
            [
                'value'        => 'premium',
                'label'        => 'Premium',
                'color'        => '#f59e0b',
                'min_cpm'      => 0.010000,
                'min_cpc'      => 0.025000,
                'max_priority' => 100,
                'description'  => 'Top priority, maximum exposure',
                'sort_order'   => 3,
                'is_active'    => true,
                'created_at'   => now(),
                'updated_at'   => now(),
            ],
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('ad_priority_tiers');
    }
};

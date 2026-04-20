<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('advertisements', function (Blueprint $table) {
            $table->integer('target_age_min')->nullable()->after('file_size');
            $table->integer('target_age_max')->nullable()->after('target_age_min');
            $table->string('target_gender')->nullable()->default('all')->after('target_age_max');
            $table->json('target_location')->nullable()->after('target_gender');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('advertisements', function (Blueprint $table) {
            $table->dropColumn(['target_age_min', 'target_age_max', 'target_gender', 'target_location']);
        });
    }
};

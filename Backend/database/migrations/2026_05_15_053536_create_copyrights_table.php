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
        Schema::create('copyrights', function (Blueprint $table) {
            $table->id();
            $table->foreignId('song_id')->constrained('songs')->onDelete('cascade');
            $table->foreignId('partner_id')->constrained('partners')->onDelete('cascade');
            $table->enum('copyright_type', ['author', 'performer', 'producer', 'publisher', 'exclusive', 'non_exclusive', 'creative_commons', 'public_domain'])->default('author');
            $table->string('owner_name', 255);
            $table->string('registration_number', 100)->nullable()->unique();
            $table->date('registration_date')->nullable();
            $table->string('registration_country', 100)->nullable();
            $table->date('valid_from');
            $table->date('valid_until')->nullable();
            $table->string('territory', 255)->nullable()->default('Worldwide');
            $table->text('rights_included')->nullable();
            $table->string('document_url', 500)->nullable();
            $table->text('notes')->nullable();
            $table->enum('status', ['active', 'expired', 'pending', 'disputed', 'revoked'])->default('pending');
            $table->timestamp('verified_at')->nullable();
            $table->foreignId('verified_by')->nullable()->constrained('users')->onDelete('set null');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('copyrights');
    }
};

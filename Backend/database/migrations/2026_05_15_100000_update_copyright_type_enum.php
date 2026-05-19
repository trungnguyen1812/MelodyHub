<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Alter enum để thêm các giá trị mới: author, performer, producer, publisher
        DB::statement("
            ALTER TABLE copyrights
            MODIFY COLUMN copyright_type
            ENUM('author','performer','producer','publisher','exclusive','non_exclusive','creative_commons','public_domain')
            NOT NULL DEFAULT 'author'
        ");
    }

    public function down(): void
    {
        // Revert về enum cũ (chỉ an toàn nếu không có data dùng giá trị mới)
        DB::statement("
            ALTER TABLE copyrights
            MODIFY COLUMN copyright_type
            ENUM('exclusive','non_exclusive','creative_commons','public_domain')
            NOT NULL DEFAULT 'exclusive'
        ");
    }
};

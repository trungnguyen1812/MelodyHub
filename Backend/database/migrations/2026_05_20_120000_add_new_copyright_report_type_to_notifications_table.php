<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::statement("
            ALTER TABLE notifications
            MODIFY COLUMN `type` ENUM(
                'copyright_unverified',
                'copyright_pending',
                'copyright_approved',
                'copyright_rejected',
                'copyright_disputed',
                'report_resolved',
                'copyright_report_submitted',
                'copyright_report_resolved_removed',
                'copyright_report_resolved_kept',
                'copyright_report_rejected',
                'copyright_report_updated',
                'new_copyright_report',
                'system'
            ) NOT NULL DEFAULT 'system'
        ");
    }

    public function down(): void
    {
        DB::statement("
            ALTER TABLE notifications
            MODIFY COLUMN `type` ENUM(
                'copyright_unverified',
                'copyright_pending',
                'copyright_approved',
                'copyright_rejected',
                'copyright_disputed',
                'report_resolved',
                'copyright_report_submitted',
                'copyright_report_resolved_removed',
                'copyright_report_resolved_kept',
                'copyright_report_rejected',
                'copyright_report_updated',
                'system'
            ) NOT NULL DEFAULT 'system'
        ");
    }
};

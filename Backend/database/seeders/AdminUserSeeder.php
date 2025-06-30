<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;

class AdminUserSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('users')->insert([
            'uuid' => Str::uuid(),
            'email' => 'admin@melodyhub.com',
            'password' => Hash::make('admin123'), // 🔒 mã hóa
            'display_name' => 'Melody Admin',
            'role_id' => 1, // hoặc id role tương ứng
            'status' => 'active',
            'is_verified' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}

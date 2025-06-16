<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User; // Import model nếu cần

class AdminController extends Controller
{
    /**
     * Hiển thị dashboard admin (API)
     */
    public function dashboard()
    {
        return response()->json([
            'message' => 'Admin Dashboard Data',
            'data' => [
                'total_users' => User::count(),
                // Thêm metrics khác tại đây
            ]
        ]);
    }

    /**
     * Quản lý users (Ví dụ)
     */
    public function users()
    {
        $users = User::select('id', 'name', 'email', 'role')->get();
        
        return response()->json([
            'users' => $users
        ]);
    }
}
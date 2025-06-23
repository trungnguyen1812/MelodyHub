<?php


namespace App\Http\Controllers\API\Admin;


use Illuminate\Http\Request;
use App\Models\User; 
use App\Http\Controllers\Controller;


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

    public function currentUser(Request $request)
    {
        return response()->json($request->user()->only(['id', 'name', 'email', 'role']));
    }
}

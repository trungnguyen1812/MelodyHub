<?php
namespace App\Http\Controllers\Api\admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AdminController extends Controller
{
    public function dashboard(Request $request)
    {
          /** @var \App\Models\User $user */
        $user = Auth::user();
        
        return response()->json([
            'message' => 'Welcome to Admin Dashboard',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'role' => $user->getRoleFlags(), 
            ],
            'stats' => [
                'total_users' => \App\Models\User::count(),
            ]
        ]);
    }
    

}
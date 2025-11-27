<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AdminController extends Controller
{
    public function dashboard()
    {print_r('xin chao cau đã đến đây');die;
        $user = Auth::User();
        return response()->json([
            'message'   =>  'Well come to admin dasboard',
            'user'      =>  $user
        ]);
    }
}

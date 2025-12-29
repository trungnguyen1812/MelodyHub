<?php
namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use App\Models\User;

class UserManagerController extends Controller
{
   public function getAllUser(){
        $users = User::with('roles')->get();

        return response()->json([
            'users' => $users
        ]);
   }

}
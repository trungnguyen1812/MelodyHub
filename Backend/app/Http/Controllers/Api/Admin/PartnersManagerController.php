<?php

namespace App\Http\Controllers\Api\Admin;
use App\Http\Controllers\Controller;
use App\Models\Partner;
use Illuminate\Http\Request;

class PartnersManagerController extends Controller
{
    public function index(){
        $partners  = Partner::all();

        return response()->json($partners);
    }
}
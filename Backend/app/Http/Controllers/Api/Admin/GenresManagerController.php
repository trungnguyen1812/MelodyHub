<?php

namespace App\Http\Controllers\Api\Admin;
use App\Http\Controllers\Controller;
use App\Models\Genre;
use Illuminate\Http\Request;

class GenresManagerController extends Controller
{
    public function index(){
        $genres  = Genre::all();

        return response()->json($genres);
    }
}
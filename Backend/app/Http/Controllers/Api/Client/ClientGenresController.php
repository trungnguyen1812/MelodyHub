<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\Genre;
use Illuminate\Http\Request;

class ClientGenresController extends Controller
{
    public function index(){
        $genres  = Genre::all();

        return response()->json($genres);
    }
}

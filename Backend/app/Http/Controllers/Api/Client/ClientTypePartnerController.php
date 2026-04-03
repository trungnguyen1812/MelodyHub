<?php

namespace App\Http\Controllers\Api\Client;

use App\Http\Controllers\Controller;
use App\Models\PartnerType;
use Illuminate\Http\Request;

class ClientTypePartnerController extends Controller
{
    public function getAllTypePartnar(){
        $typePartner = PartnerType::all();
        return response()->json($typePartner);
    }
}

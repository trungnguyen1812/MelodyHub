<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\PartnerType;
use Illuminate\Http\Request;

class TypePartnerController extends Controller
{
    public function getAllTypePartnar(){
        $typePartner = PartnerType::all();
        return response()->json($typePartner);
    }
}

<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\AuthController;
use App\Http\Middleware\CheckAdmin;

// client page
Route::get('/', function () {
    return view('welcome');
});

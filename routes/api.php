<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\LocationController;
use App\Http\Controllers\Api\MenuController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\ProductController;
use Illuminate\Support\Facades\Route;

// Public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::get('/menu', [MenuController::class, 'index']);
Route::get('/modifiers', [MenuController::class, 'modifiers']);
Route::get('/barangays', [LocationController::class, 'index']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);

    Route::apiResource('products', ProductController::class)->only(['index', 'show', 'update']);

    Route::get('/orders', [OrderController::class, 'index']);
    Route::post('/orders', [OrderController::class, 'store']);
    Route::patch('/orders/{order}/status', [OrderController::class, 'updateStatus']);
});

<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\CategoryResource;
use App\Models\Category;
use App\Models\Modifier;
use App\Http\Resources\ModifierResource;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class MenuController extends Controller
{
    public function index(): AnonymousResourceCollection
    {
        $categories = Category::with(['products' => function ($query) {
            $query->where('is_available', true)->with('variations');
        }])->get();

        return CategoryResource::collection($categories);
    }

    public function modifiers(): AnonymousResourceCollection
    {
        return ModifierResource::collection(Modifier::all());
    }
}

<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ProductResource;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class ProductController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(): AnonymousResourceCollection
    {
        $products = Product::with(['category', 'variations'])->get();

        return ProductResource::collection($products);
    }

    /**
     * Display the specified resource.
     */
    public function show(Product $product): ProductResource
    {
        $product->load(['category', 'variations']);

        return new ProductResource($product);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Product $product): ProductResource
    {
        $request->validate([
            'is_available' => ['required', 'boolean'],
        ]);

        $product->update([
            'is_available' => $request->boolean('is_available'),
        ]);

        return new ProductResource($product);
    }
}

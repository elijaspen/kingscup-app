<?php

use App\Models\Category;
use App\Models\Product;
use App\Models\ProductVariation;

test('it returns the menu catalog', function () {
    $category = Category::factory()->create(['name' => 'Coffee']);
    $product = Product::factory()->create([
        'category_id' => $category->id,
        'name' => 'Latte',
    ]);
    ProductVariation::factory()->create([
        'product_id' => $product->id,
        'type' => \App\Enums\VariationType::Hot,
        'price' => 120,
    ]);

    $response = $this->getJson('/api/menu');

    $response->assertStatus(200)
        ->assertJsonFragment(['name' => 'Coffee'])
        ->assertJsonFragment(['name' => 'Latte'])
        ->assertJsonFragment(['type' => 'hot', 'price' => '120.00']);
});

test('it does not return unavailable products', function () {
    $product = Product::factory()->create(['is_available' => false]);

    $response = $this->getJson('/api/menu');

    $response->assertStatus(200)
        ->assertJsonMissing(['name' => $product->name]);
});

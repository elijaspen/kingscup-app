<?php

namespace Database\Factories;

use App\Enums\VariationType;
use App\Models\Product;
use App\Models\ProductVariation;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<ProductVariation>
 */
class ProductVariationFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'product_id' => Product::factory(),
            'type' => $this->faker->randomElement(VariationType::cases()),
            'price' => $this->faker->randomFloat(2, 50, 200),
        ];
    }
}

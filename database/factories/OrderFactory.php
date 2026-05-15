<?php

namespace Database\Factories;

use App\Models\Order;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Order>
 */
class OrderFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'customer_id' => \App\Models\User::factory(),
            'total_price' => $this->faker->randomFloat(2, 100, 1000),
            'address_text' => $this->faker->address(),
            'status' => \App\Enums\OrderStatus::Pending,
        ];
    }
}

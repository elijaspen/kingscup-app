<?php

use App\Models\User;
use App\Models\Order;
use App\Models\ProductVariation;
use App\Enums\UserRole;
use App\Enums\OrderStatus;

test('customer can place an order', function () {
    $user = User::factory()->customer()->create();
    $variation = ProductVariation::factory()->create(['price' => 100]);

    $response = $this->actingAs($user)->postJson('/api/orders', [
        'items' => [
            [
                'variation_id' => $variation->id,
                'quantity' => 2,
                'modifiers' => ['Vanilla'],
            ]
        ],
        'address_text' => '123 Main St',
    ]);

    $response->assertStatus(201)
        ->assertJsonFragment(['total_price' => '200.00']);

    $this->assertDatabaseHas('orders', [
        'customer_id' => $user->id,
        'total_price' => 200,
    ]);
});

test('barista can update order status', function () {
    $barista = User::factory()->barista()->create();
    $order = Order::factory()->create(['status' => OrderStatus::Pending]);

    $response = $this->actingAs($barista)->patchJson("/api/orders/{$order->id}/status", [
        'status' => OrderStatus::Preparing->value,
    ]);

    $response->assertStatus(200);
    $this->assertDatabaseHas('orders', [
        'id' => $order->id,
        'status' => OrderStatus::Preparing,
    ]);
});

test('barista is assigned when status changes to delivering', function () {
    $barista = User::factory()->barista()->create();
    $order = Order::factory()->create(['status' => OrderStatus::Preparing]);

    $response = $this->actingAs($barista)->patchJson("/api/orders/{$order->id}/status", [
        'status' => OrderStatus::Delivering->value,
    ]);

    $response->assertStatus(200);
    $this->assertDatabaseHas('orders', [
        'id' => $order->id,
        'status' => OrderStatus::Delivering,
        'barista_id' => $barista->id,
    ]);
});

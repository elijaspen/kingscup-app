<?php

namespace App\Http\Controllers\Api;

use App\Enums\OrderStatus;
use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Http\Requests\Api\StoreOrderRequest;
use App\Http\Resources\OrderResource;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\ProductVariation;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class OrderController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        $query = Order::with(['customer', 'barista', 'items.variation.product']);

        if ($user->role === UserRole::Customer) {
            $query->where('customer_id', $user->id);
        }

        return OrderResource::collection($query->latest()->get());
    }

    public function store(StoreOrderRequest $request): JsonResponse
    {
        $user = $request->user();
        $address = $request->address_text;

        if (!$address) {
            $defaultAddress = $user->addresses()->where('is_default', true)->first();
            $address = $defaultAddress?->address_text ?? 'Pickup';
        }

        return DB::transaction(function () use ($request, $user, $address) {
            $order = Order::create([
                'customer_id' => $user->id,
                'total_price' => 0, // Will update after adding items
                'address_text' => $address,
                'status' => OrderStatus::Pending,
            ]);

            $totalPrice = 0;

            foreach ($request->items as $item) {
                $variation = ProductVariation::findOrFail($item['variation_id']);
                $itemPrice = $variation->price;
                
                // Add modifier prices if any
                if (!empty($item['modifiers'])) {
                    // Check if modifiers are IDs (numeric) or just names (strings)
                    // For this implementation, we expect IDs for price calculation
                    $modifierIds = array_filter($item['modifiers'], 'is_numeric');
                    if (!empty($modifierIds)) {
                        $modifierTotal = \App\Models\Modifier::whereIn('id', $modifierIds)->sum('price');
                        $itemPrice += $modifierTotal;
                    }
                }

                OrderItem::create([
                    'order_id' => $order->id,
                    'variation_id' => $variation->id,
                    'quantity' => $item['quantity'],
                    'modifiers' => $item['modifiers'] ?? [],
                ]);

                $totalPrice += ($itemPrice * $item['quantity']);
            }

            $order->update(['total_price' => $totalPrice]);

            return response()->json([
                'message' => 'Order placed successfully',
                'order' => new OrderResource($order->load('items')),
            ], 201);
        });
    }

    public function updateStatus(Request $request, Order $order): JsonResponse
    {
        $request->validate([
            'status' => ['required', 'string', \Illuminate\Validation\Rule::enum(OrderStatus::class)],
        ]);

        $newStatus = OrderStatus::from($request->status);
        $user = $request->user();

        if ($user->role !== UserRole::Barista) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $data = ['status' => $newStatus];

        if ($newStatus === OrderStatus::Delivering) {
            $data['barista_id'] = $user->id;
        }

        $order->update($data);

        return response()->json([
            'message' => "Order status updated to {$newStatus->value}",
            'order' => new OrderResource($order->load(['customer', 'barista', 'items'])),
        ]);
    }
}

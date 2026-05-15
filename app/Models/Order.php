<?php

namespace App\Models;

use App\Enums\OrderStatus;
use Database\Factories\OrderFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

#[Fillable(['customer_id', 'barista_id', 'total_price', 'address_text', 'status'])]
class Order extends Model
{
    /** @use HasFactory<OrderFactory> */
    use HasFactory;

    protected function casts(): array
    {
        return [
            'total_price' => 'decimal:2',
            'status' => OrderStatus::class,
        ];
    }

    public function customer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'customer_id');
    }

    public function barista(): BelongsTo
    {
        return $this->belongsTo(User::class, 'barista_id');
    }

    public function items(): HasMany
    {
        return $this->hasMany(OrderItem::class);
    }
}

<?php

namespace App\Models;

use App\Enums\VariationType;
use Database\Factories\ProductVariationFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

#[Fillable(['product_id', 'type', 'price'])]
class ProductVariation extends Model
{
    /** @use HasFactory<ProductVariationFactory> */
    use HasFactory;

    protected function casts(): array
    {
        return [
            'price' => 'decimal:2',
            'type' => VariationType::class,
        ];
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }
}

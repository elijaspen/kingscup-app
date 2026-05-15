<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class OrderItemResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'variation' => new ProductVariationResource($this->whenLoaded('variation')),
            'quantity' => $this->quantity,
            'modifiers' => $this->modifiers,
        ];
    }
}

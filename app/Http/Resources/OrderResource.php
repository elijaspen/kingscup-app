<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class OrderResource extends JsonResource
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
            'customer' => new UserResource($this->whenLoaded('customer')),
            'barista' => new UserResource($this->whenLoaded('barista')),
            'total_price' => $this->total_price,
            'address_text' => $this->address_text,
            'status' => $this->status,
            'items' => OrderItemResource::collection($this->whenLoaded('items')),
            'created_at' => $this->created_at,
        ];
    }
}

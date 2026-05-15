<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ProductResource extends JsonResource
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
            'name' => $this->name,
            'description' => $this->description,
            'image' => $this->image_url,
            'available' => $this->is_available,
            'category' => $this->whenLoaded('category', fn () => $this->category->name),
            'variations' => ProductVariationResource::collection($this->whenLoaded('variations')),
        ];
    }
}

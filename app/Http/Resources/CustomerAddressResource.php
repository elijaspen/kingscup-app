<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class CustomerAddressResource extends JsonResource
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
            'label' => $this->label,
            'address_text' => $this->address_text,
            'barangay' => $this->barangay,
            'is_default' => $this->is_default,
        ];
    }
}

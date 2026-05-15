<?php

namespace Database\Seeders;

use App\Enums\VariationType;
use App\Models\Category;
use App\Models\Modifier;
use App\Models\Product;
use App\Models\ProductVariation;
use Illuminate\Database\Seeder;

class MenuSeeder extends Seeder
{
    public function run(): void
    {
        // Modifiers
        $modifiers = [
            ['name' => 'Vanilla Syrup', 'price' => 40],
            ['name' => 'Hazelnut Syrup', 'price' => 40],
            ['name' => 'Mint Syrup', 'price' => 40],
            ['name' => 'Chocolate Sauce', 'price' => 65],
            ['name' => 'Caramel Sauce', 'price' => 65],
            ['name' => 'Whipped Cream', 'price' => 40],
        ];

        foreach ($modifiers as $modifier) {
            Modifier::create($modifier);
        }

        // Categories
        $coffeeCat = Category::create(['name' => 'Coffee Based']);
        $frappeCat = Category::create(['name' => 'Frappe']);
        $nonCoffeeCat = Category::create(['name' => 'Non-Coffee Based']);
        $teaCat = Category::create(['name' => 'Tea']);
        $pastaCat = Category::create(['name' => 'Pasta']);
        $sandwichCat = Category::create(['name' => 'Sandwiches']);
        $cakeCat = Category::create(['name' => 'Cakes']);

        // Products & Variations
        $this->createProduct($coffeeCat, 'Espresso', [
            ['type' => VariationType::Hot, 'price' => 60],
        ]);

        $this->createProduct($coffeeCat, 'Cafe Americano', [
            ['type' => VariationType::Hot, 'price' => 95],
            ['type' => VariationType::Iced, 'price' => 95],
        ]);

        $this->createProduct($coffeeCat, 'Cafe Latte', [
            ['type' => VariationType::Hot, 'price' => 105],
            ['type' => VariationType::Iced, 'price' => 110],
        ]);

        $this->createProduct($coffeeCat, 'Cappuccino', [
            ['type' => VariationType::Hot, 'price' => 100],
            ['type' => VariationType::Iced, 'price' => 115],
        ]);

        $this->createProduct($coffeeCat, 'Cafe Mocha', [
            ['type' => VariationType::Hot, 'price' => 145],
            ['type' => VariationType::Iced, 'price' => 155],
        ]);

        $this->createProduct($coffeeCat, 'Caramel Macchiato', [
            ['type' => VariationType::Hot, 'price' => 155],
            ['type' => VariationType::Iced, 'price' => 160],
        ]);

        $this->createProduct($coffeeCat, 'Hazelnut Latte', [
            ['type' => VariationType::Hot, 'price' => 120],
            ['type' => VariationType::Iced, 'price' => 125],
        ]);

        $this->createProduct($coffeeCat, 'Mint Latte', [
            ['type' => VariationType::Hot, 'price' => 110],
            ['type' => VariationType::Iced, 'price' => 115],
        ]);

        $this->createProduct($coffeeCat, 'Affogato', [
            ['type' => VariationType::Hot, 'price' => 120],
        ]);

        $this->createProduct($coffeeCat, 'Caramel Mocha', [
            ['type' => VariationType::Iced, 'price' => 165],
        ]);

        $this->createProduct($coffeeCat, 'Matcha', [
            ['type' => VariationType::Hot, 'price' => 155],
            ['type' => VariationType::Iced, 'price' => 160],
        ]);

        // Frappes
        $this->createProduct($frappeCat, 'Chocolate Frappe', [['type' => VariationType::Standard, 'price' => 165]]);
        $this->createProduct($frappeCat, 'Mocha Frappe', [['type' => VariationType::Standard, 'price' => 170]]);
        $this->createProduct($frappeCat, 'Caramel Frappe', [['type' => VariationType::Standard, 'price' => 175]]);
        $this->createProduct($frappeCat, 'Caramel Mocha Frappe', [['type' => VariationType::Standard, 'price' => 180]]);
        $this->createProduct($frappeCat, 'Matcha Frappe', [['type' => VariationType::Standard, 'price' => 170]]);
        $this->createProduct($frappeCat, 'Hazelnut Mocha Frappe', [['type' => VariationType::Standard, 'price' => 200]]);

        // Non-Coffee
        $this->createProduct($nonCoffeeCat, 'Chocolate', [
            ['type' => VariationType::Hot, 'price' => 130],
            ['type' => VariationType::Iced, 'price' => 135],
        ]);
        $this->createProduct($nonCoffeeCat, 'Vanilla Bean Chocolate', [
            ['type' => VariationType::Hot, 'price' => 145],
            ['type' => VariationType::Iced, 'price' => 150],
        ]);
        $this->createProduct($nonCoffeeCat, 'Chocolate Mint', [
            ['type' => VariationType::Hot, 'price' => 150],
            ['type' => VariationType::Iced, 'price' => 155],
        ]);

        // Tea
        $this->createProduct($teaCat, 'Tea (Dilmah/Twinings)', [
            ['type' => VariationType::Hot, 'price' => 60],
            ['type' => VariationType::Iced, 'price' => 70],
        ]);

        // Pasta
        $this->createProduct($pastaCat, 'Tuna Pesto', [['type' => VariationType::Standard, 'price' => 130]]);
        $this->createProduct($pastaCat, 'Carbonara', [['type' => VariationType::Standard, 'price' => 130]]);
        $this->createProduct($pastaCat, 'Spaghetti', [['type' => VariationType::Standard, 'price' => 130]]);

        // Sandwiches
        $this->createProduct($sandwichCat, 'Tuna Overload', [['type' => VariationType::Standard, 'price' => 100]]);
        $this->createProduct($sandwichCat, 'Ham Overload', [['type' => VariationType::Standard, 'price' => 150]]);
        $this->createProduct($sandwichCat, 'Clubhouse', [['type' => VariationType::Standard, 'price' => 120]]);
        $this->createProduct($sandwichCat, 'Egg Sandwich', [['type' => VariationType::Standard, 'price' => 90]]);

        // Cakes
        $this->createProduct($cakeCat, 'Carrot Cake', [['type' => VariationType::Standard, 'price' => 160]]);
        $this->createProduct($cakeCat, 'Chocolate Cake', [['type' => VariationType::Standard, 'price' => 160]]);
        $this->createProduct($cakeCat, 'Red Velvet Cake', [['type' => VariationType::Standard, 'price' => 160]]);
        $this->createProduct($cakeCat, 'Cheese Cake', [['type' => VariationType::Standard, 'price' => 180]]);
    }

    private function createProduct(Category $category, string $name, array $variations)
    {
        $product = Product::create([
            'category_id' => $category->id,
            'name' => $name,
        ]);

        foreach ($variations as $variation) {
            ProductVariation::create([
                'product_id' => $product->id,
                'type' => $variation['type'],
                'price' => $variation['price'],
            ]);
        }
    }
}

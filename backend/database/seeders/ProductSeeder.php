<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Storage;
use App\Models\Product;

class ProductSeeder extends Seeder
{
    public function run(): void
    {
        if (!Storage::exists('techlines.products.json')) {
            throw new \Exception("JSON file not found in storage/app/");
        }

        $json = Storage::get('techlines.products.json');
        $products = json_decode($json, true);

        if (!is_array($products)) {
            throw new \Exception("Invalid JSON structure. Expected an array.");
        }

        foreach ($products as $item) {
            Product::create([
                'name' => $item['name'],
                'subtitle' => $item['subtitle'] ?? null,
                'images' => $item['images'] ?? [],
                'description' => $item['description'] ?? '',
                'brand' => $item['brand'] ?? '',
                'category' => $item['category'] ?? '',
                'price' => $item['price'] ?? 0,
                'stock' => $item['stock'] ?? 0,
                'rating' => $item['rating'] ?? 0,
                'numberOfReviews' => $item['numberOfReviews'] ?? 0,
                'productIsNew' => $item['productIsNew'] ?? false,
                'stripeId' => $item['stripeId'] ?? null
            ]);
        }
    }
}

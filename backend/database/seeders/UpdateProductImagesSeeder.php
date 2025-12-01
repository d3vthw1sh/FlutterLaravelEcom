<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Product;

class UpdateProductImagesSeeder extends Seeder
{
    public function run(): void
    {
        // Map product names to their local asset image paths
        $imageMap = [
            'iPhone 15' => ['assets/images/products/iphone15_image_1.avif', 'assets/images/products/iphone15_image_2.avif'],
            'iPhone 13' => ['assets/images/products/iphone13_image_1.avif', 'assets/images/products/iphone13_image_2.avif'],
            'Samsung Galaxy S23' => ['assets/images/products/s23_image_1.avif', 'assets/images/products/s23_image_2.avif'],
            'Samsung Galaxy S23 Ultra' => ['assets/images/products/s23ultra_image_1.avif', 'assets/images/products/s23ultra_image_2.avif'],
            'Google Pixel 7' => ['assets/images/products/googlePixel7_image_1.avif', 'assets/images/products/googlePixel7_image_2.avif'],
            'Xiaomi Redmi Note 12 Pro' => ['assets/images/products/xiaomi_note_12_pro_image_1.avif', 'assets/images/products/xiaomi_note_12_pro_image_2.avif'],
            'Samsung Galaxy A53 5G' => ['assets/images/products/a535g_image_1.avif', 'assets/images/products/a535g_image_2.avif'],
            'Samsung Galaxy S54 5G' => ['assets/images/products/s545g_image_1.webp', 'assets/images/products/s545g_image_2.avif'],
            'Fairphone 5' => ['assets/images/products/fairphone5_image_1.avif', 'assets/images/products/fairphone5_image_2.avif'],
        ];

        foreach ($imageMap as $productName => $images) {
            Product::where('name', 'LIKE', "%{$productName}%")
                ->update(['images' => $images]);
        }

        echo "Product images updated to use local assets!\n";
    }
}

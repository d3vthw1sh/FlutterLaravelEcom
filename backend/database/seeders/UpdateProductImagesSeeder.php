<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Product;

class UpdateProductImagesSeeder extends Seeder
{
    public function run(): void
    {
        // Update ALL products to use PNG images
        // This maps the old image filenames to new PNG versions
        
        $products = Product::all();
        
        foreach ($products as $product) {
            $updatedImages = [];
            
            foreach ($product->images as $image) {
                // Convert any image path to use PNG and assets/ prefix
                $newImage = $image;
                
                // Replace extensions
                $newImage = preg_replace('/\.(avif|webp|jpg|jpeg)$/i', '.png', $newImage);
                
                // Fix path prefix - ensure it starts with assets/images/products/
                if (preg_match('/([a-zA-Z0-9_]+_image_\d+\.png)$/', $newImage, $matches)) {
                    $filename = $matches[1];
                    $newImage = "assets/images/products/{$filename}";
                }
                
                $updatedImages[] = $newImage;
            }
            
            if ($updatedImages !== $product->images) {
                $product->images = $updatedImages;
                $product->save();
                echo "Updated: {$product->name}\n";
            }
        }
        
        echo "\nProduct images updated to use local PNG assets!\n";
    }
}

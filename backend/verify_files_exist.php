<?php

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

echo "=== VERIFYING PHYSICAL IMAGE FILES ===\n\n";

$products = App\Models\Product::all(['id', 'name', 'images']);
$frontendAssetsPath = 'd:/FlutterLaravelecommercial/ecommercial/frontend/';

$missingFiles = 0;
$foundFiles = 0;

foreach ($products as $product) {
    if (empty($product->images)) continue;

    foreach ($product->images as $imagePath) {
        // $imagePath should be like "assets/images/products/iphone15_image_1.png"
        
        // Construct full physical path
        $fullPath = $frontendAssetsPath . $imagePath;
        
        // Check if file exists
        if (file_exists($fullPath)) {
            $foundFiles++;
        } else {
            $missingFiles++;
            echo "❌ MISSING FILE: {$fullPath}\n";
            echo "   Product: {$product->name}\n";
            echo "   DB Path: {$imagePath}\n\n";
        }
    }
}

echo "=== SUMMARY ===\n";
echo "✓ Found files: {$foundFiles}\n";
echo "✗ Missing files: {$missingFiles}\n";

if ($missingFiles === 0) {
    echo "\n🎉 ALL DATABASE IMAGES EXIST ON DISK!\n";
} else {
    echo "\n⚠️ SOME IMAGES ARE MISSING! See above for details.\n";
}

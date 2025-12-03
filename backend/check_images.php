<?php

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

$products = App\Models\Product::all(['id', 'name', 'images']);

$totalProducts = count($products);
$correctProducts = 0;
$incorrectProducts = 0;

foreach ($products as $product) {
    $allCorrect = true;
    
    if (count($product->images) === 0) {
        $allCorrect = false;
    }
    
    foreach ($product->images as $image) {
        if (!str_ends_with($image, '.png') || !str_starts_with($image, 'assets/')) {
            $allCorrect = false;
            break;
        }
    }
    
    if ($allCorrect) {
        $correctProducts++;
    } else {
        $incorrectProducts++;
        echo "❌ {$product->name}: " . implode(', ', $product->images) . "\n";
    }
}

echo "\n=== SUMMARY ===\n";
echo "Total products: {$totalProducts}\n";
echo "✓ Correct PNG paths: {$correctProducts}\n";
echo "✗ Incorrect paths: {$incorrectProducts}\n";

if ($incorrectProducts === 0) {
    echo "\n🎉 ALL PRODUCTS HAVE CORRECT PNG IMAGES!\n";
}

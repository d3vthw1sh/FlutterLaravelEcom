<?php

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

try {
    echo "Testing Order model...\n";
    
    $order = App\Models\Order::find(6);
    
    if ($order) {
        echo "Order found!\n";
        echo "ID: " . $order->id . "\n";
        echo "_id attribute: " . $order->_id . "\n";
        echo "User ID: " . $order->user_id . "\n";
        echo "\nJSON output:\n";
        echo $order->toJson();
        echo "\n\nSuccess!\n";
    } else {
        echo "Order not found\n";
    }
    
} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . ":" . $e->getLine() . "\n";
    echo "\nStack trace:\n";
    echo $e->getTraceAsString();
}

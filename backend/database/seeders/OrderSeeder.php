<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Order;
use App\Models\User;

class OrderSeeder extends Seeder
{
    public function run()
    {
        // Get an admin user
        $user = User::where('isAdmin', true)->first();
        
        if (!$user) {
            echo "No admin user found. Please create one first.\n";
            return;
        }

        // Create test orders
        Order::create([
            'user_id' => $user->id,
            'orderItems' => [
                [
                    'id' => '1',
                    'name' => 'Test Product 1',
                    'price' => 100,
                    'qty' => 2,
                    'image' => 'assets/images/products/test1.jpg',
                    'product' => '1'
                ]
            ],
            'shippingAddress' => [
                'address' => '123 Main Street',
                'city' => 'Phnom Penh',
                'state' => 'Phnom Penh',
                'zipCode' => '12000',
                'country' => 'Cambodia'
            ],
            'shippingPrice' => 5.99,
            'subtotal' => 200,
            'totalPrice' => 205.99,
            'isDelivered' => false,
            'deliveredAt' => null
        ]);

        Order::create([
            'user_id' => $user->id,
            'orderItems' => [
                [
                    'id' => '2',
                    'name' => 'Test Product 2',
                    'price' => 50,
                    'qty' => 1,
                    'image' => 'assets/images/products/test2.jpg',
                    'product' => '2'
                ]
            ],
            'shippingAddress' => [
                'address' => '456 Oak Avenue',
                'city' => 'Siem Reap',
                'state' => 'Siem Reap',
                'zipCode' => '17000',
                'country' => 'Cambodia'
            ],
            'shippingPrice' => 5.99,
            'subtotal' => 50,
            'totalPrice' => 55.99,
            'isDelivered' => true,
            'deliveredAt' => now()
        ]);

        echo "Created 2 test orders successfully!\n";
    }
}

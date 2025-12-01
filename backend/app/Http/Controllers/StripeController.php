<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\Product;
use Illuminate\Http\Request;

class StripeController extends Controller
{
    /**
     * Mock Stripe Checkout Session
     * Simulates Stripe payment flow but saves order to database
     */
    public function createCheckoutSession(Request $request)
    {
        // Validate the request
        $request->validate([
            'cartItems' => 'required|array',
            'total' => 'required|numeric',
            'customerInfo' => 'required|array',
            'shippingAddress' => 'required|array',
        ]);

        try {
            // Extract data from request
            $cartItems = $request->cartItems;
            $customerInfo = $request->customerInfo;
            $shippingAddress = $request->shippingAddress;
            $subtotal = $request->input('subtotal', 0);
            $shippingCost = $request->input('shippingCost', 0);
            $total = $request->total;

            // Reduce product stock
            foreach ($cartItems as $item) {
                $product = Product::find($item['id']);
                if ($product) {
                    $product->stock -= $item['qty'];
                    if ($product->stock < 0) $product->stock = 0;
                    $product->save();
                }
            }

            // Create order in database
            $order = Order::create([
                'user_id' => $customerInfo['userId'] ?? null,
                'orderItems' => $cartItems,
                'shippingAddress' => $shippingAddress,
                'shippingPrice' => $shippingCost,
                'subtotal' => $subtotal,
                'totalPrice' => $total,
                'isDelivered' => false,
                'deliveredAt' => null,
                'customerName' => $customerInfo['name'] ?? '',
                'customerEmail' => $customerInfo['email'] ?? '',
                'customerPhone' => $customerInfo['phone'] ?? '',
            ]);

            // Return success response (no payment page needed)
            return response()->json([
                'success' => true,
                'orderId' => $order->id,
                'message' => 'Order placed successfully',
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => $e->getMessage()
            ], 500);
        }
    }
}

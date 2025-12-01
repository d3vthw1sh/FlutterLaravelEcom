<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Models\Product;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    // ---------------------------------------------------------
    // FAKE CHECKOUT (NO STRIPE)
    // Flutter sends:
    // {
    //   cartItems: [...],
    //   userInfo: {...},
    //   shippingAddress: {...},
    //   subtotal: 100,
    //   shipping: 5.99
    // }
    // ---------------------------------------------------------
    public function checkout(Request $request)
    {
        $request->validate([
            'cartItems' => 'required|array',
            'userInfo' => 'required|array',
            'shippingAddress' => 'required|array',
            'subtotal' => 'required|numeric',
            'shipping' => 'required|numeric'
        ]);

        // Reduce stock
        foreach ($request->cartItems as $item) {
            $product = Product::find($item['id']);
            if ($product) {
                $product->stock -= $item['qty'];
                if ($product->stock < 0) $product->stock = 0;
                $product->save();
            }
        }

        // Create order in MySQL
        $order = Order::create([
            'user_id' => $request->userInfo['_id'],
            'orderItems' => $request->cartItems,
            'shippingAddress' => $request->shippingAddress,
            'shippingPrice' => $request->shipping,
            'subtotal' => $request->subtotal,
            'totalPrice' => $request->subtotal + $request->shipping,
            'isDelivered' => false,
            'deliveredAt' => null
        ]);

        // Fake checkout success URL
        $fakeUrl = "https://example.com/payment-success?orderId=" . $order->id;

        return response()->json([
            "orderId" => (string)$order->id,
            "url" => $fakeUrl
        ]);
    }


    // ---------------------------------------------------------
    // GET ALL ORDERS (ADMIN)
    // ---------------------------------------------------------
    public function index()
    {
        return response()->json(Order::with('user')->get());
    }

    // ---------------------------------------------------------
    // GET ORDERS FOR SPECIFIC USER
    // ---------------------------------------------------------
    public function userOrders($id)
    {
        return response()->json(
            Order::where('user_id', $id)->get()
        );
    }

    // ---------------------------------------------------------
    // GET ORDERS FOR AUTHENTICATED USER
    // ---------------------------------------------------------
    public function myOrders()
    {
        $user = auth()->user();
        if (!$user) return response('Unauthorized', 401);

        return response()->json(
            Order::where('user_id', $user->id)->get()
        );
    }
    // ---------------------------------------------------------
    // MARK ORDER DELIVERED
    // ---------------------------------------------------------
    public function markDelivered($id)
    {
        $order = Order::find($id);
        if (!$order) return response("Order not found", 404);

        $order->isDelivered = true;
        $order->deliveredAt = now();
        $order->save();

        return response("Order delivered", 200);
    }

    // ---------------------------------------------------------
    // DELETE ORDER
    // ---------------------------------------------------------
    public function destroy($id)
    {
        $order = Order::find($id);
        if (!$order) return response("Order not found", 404);

        $order->delete();

        return response("Order deleted", 200);
    }
}

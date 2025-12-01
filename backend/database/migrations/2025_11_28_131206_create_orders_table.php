<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id(); 
            $table->foreignId('user_id')->nullable()->constrained('users')->onDelete('cascade');

            // Flutter sends arrays → store as JSON
            $table->json('orderItems');
            $table->json('shippingAddress');

            $table->float('shippingPrice');
            $table->float('subtotal');
            $table->float('totalPrice');

            // Customer information (for guest checkout)
            $table->string('customerName')->nullable();
            $table->string('customerEmail')->nullable();
            $table->string('customerPhone')->nullable();

            $table->boolean('isDelivered')->default(false);
            $table->timestamp('deliveredAt')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};

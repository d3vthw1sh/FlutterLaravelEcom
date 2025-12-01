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
        Schema::create('products', function (Blueprint $table) {
            $table->id(); // _id for Flutter
            $table->string('name');
            $table->string('subtitle')->nullable();

            // JSON array of images
            $table->json('images')->nullable();

            $table->text('description');
            $table->string('brand');
            $table->string('category');

            $table->integer('price');
            $table->integer('stock');

            $table->float('rating')->default(0);
            $table->integer('numberOfReviews')->default(0);
            $table->boolean('productIsNew')->default(false);

            $table->string('stripeId')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};

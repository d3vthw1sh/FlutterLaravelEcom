<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    protected $table = 'orders';

    protected $fillable = [
        'user_id',
        'orderItems',
        'shippingAddress',
        'shippingPrice',
        'subtotal',
        'totalPrice',
        'isDelivered',
        'deliveredAt'
    ];

    protected $casts = [
        'orderItems' => 'array',
        'shippingAddress' => 'array',
        'isDelivered' => 'boolean'
    ];

    protected $appends = ['_id'];

    public function get_IdAttribute()
    {
        return $this->id;
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}

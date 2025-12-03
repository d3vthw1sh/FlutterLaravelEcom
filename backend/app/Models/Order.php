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
        'paymentStatus',
        'isDelivered',
        'deliveredAt'
    ];

    protected $casts = [
        'orderItems' => 'array',
        'shippingAddress' => 'array',
        'isDelivered' => 'boolean',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
        'deliveredAt' => 'datetime',
    ];

    protected $appends = ['createdAt'];

    // Make created_at available as createdAt for Flutter compatibility
    public function getCreatedAtAttribute()
    {
        return $this->attributes['created_at'] ?? null;
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}

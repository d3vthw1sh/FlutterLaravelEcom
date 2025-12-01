<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Review extends Model
{
    protected $table = 'reviews';

    protected $fillable = [
        'product_id',
        'user_id',
        'name',
        'rating',
        'title',
        'comment'
    ];

    protected $casts = [
        'rating' => 'integer'
    ];

    protected $appends = ['_id'];

    public function get_IdAttribute()
    {
        return $this->id;
    }

    public function product()
    {
        return $this->belongsTo(Product::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    protected $table = 'products';

    protected $fillable = [
        'name',
        'subtitle',
        'images',
        'description',
        'brand',
        'category',
        'price',
        'stock',
        'rating',
        'numberOfReviews',
        'productIsNew',
        'stripeId'
    ];

    protected $casts = [
        'images' => 'array',
        'productIsNew' => 'boolean'
    ];

    protected $appends = ['reviews'];

    public function reviewsRelation()
    {
        return $this->hasMany(Review::class);
    }

    // embed reviews like Node/Mongo
    public function getReviewsAttribute()
    {
        return $this->reviewsRelation()->get();
    }
}

<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Tymon\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable implements JWTSubject
{
    use Notifiable;

    protected $table = 'users';

    protected $fillable = [
        'name',
        'email',
        'password',
        'googleId',
        'googleImage',
        'isAdmin',
        'active',
        'firstLogin'
    ];

    protected $hidden = [
        'password'
    ];

    protected $casts = [
        'isAdmin' => 'boolean',
        'active' => 'boolean',
        'firstLogin' => 'boolean',
    ];

    // Flutter expects "_id"
    protected $appends = ['_id'];

    public function getIdAttribute()
    {
        return $this->attributes['id'];
    }

    public function get_IdAttribute()
    {
        return $this->id;
    }

    // JWT required methods
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    public function getJWTCustomClaims()
    {
        return [];
    }

    public function orders()
    {
        return $this->hasMany(Order::class);
    }
}

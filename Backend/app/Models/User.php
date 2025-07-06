<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Contracts\Auth\Access\Authorizable;
use Illuminate\Foundation\Auth\Access\Authorizable as AuthorizableTrait;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable implements Authorizable
{
    use HasApiTokens, AuthorizableTrait;

    protected $table = 'users';

    protected $fillable = [
        'uuid',
        'email',
        'password',
        'display_name',
        'role_id', // ✅ dùng role_id thay vì 'role'
        'email_verified_at',
    ];

    public $timestamps = true;

    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];


    public function role()
    {
        return $this->belongsTo(Role::class, 'role_id');
    }

    public function hasRole(string $roleName): bool
    {
        $role = $this->role;
        return $role instanceof \App\Models\Role && $role->name === $roleName;
    }

    public function isAdmin(): bool
    {
        return $this->hasRole('admin');
    }


    public function isUser(): bool
    {
        return $this->hasRole('user');
    }

    public function isVip(): bool
    {
        return $this->hasRole('vip_user');
    }

    public function isProvider(): bool
    {
        return $this->hasRole('provider');
    }

    // ✅ Relationships khác
    public function playlists()
    {
        return $this->hasMany(Playlist::class, 'user_id');
    }

    public function songPlays()
    {
        return $this->hasMany(SongPlay::class, 'user_id');
    }

    public function comments()
    {
        return $this->hasMany(Comment::class, 'user_id');
    }

    public function songLikes()
    {
        return $this->hasMany(SongLike::class, 'user_id');
    }
}

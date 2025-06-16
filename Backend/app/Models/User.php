<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Contracts\Auth\Access\Authorizable;
use Illuminate\Foundation\Auth\Access\Authorizable as AuthorizableTrait;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable implements Authorizable
{
     use HasApiTokens, AuthorizableTrait;
     
    // 1. Khai báo tên bảng (bắt buộc vì khác với quy ước Laravel)
    protected $table = 'users';

    // 2. Khai báo trường có thể fill (mass assignment)
    protected $fillable = [
        'name',
        'email',
        'password',
        'email_verified_at',
        'role'
    ];

    // 3. Tắt/mở timestamps (nếu bảng không có created_at/updated_at)
    public $timestamps = true;

    // 4. Định dạng kiểu dữ liệu (nếu cần)
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    // Helper methods để kiểm tra role
    public function isAdmin():bool
    {
        return $this->role === 'admin';
    }

    public function isUser():bool
    {
        return $this->role === 'user';
    }

    // Relationships
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

<?php

namespace App\Policies;

use App\Models\User;

class UserPolicy
{
    /**
     * Kiểm tra quyền admin (API Focus)
     * @param User $user
     * @return bool
     */
    public function isAdmin(User $user): bool
    {
        // Logic kiểm tra admin (tuỳ chỉnh theo DB của bạn)
        return $user->role === 'admin'; 
        
        // Hoặc nếu dùng enum:
        // return $user->role === UserRole::ADMIN->value;
    }
}
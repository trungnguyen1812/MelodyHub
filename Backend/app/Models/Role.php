<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Role extends Model
{
    protected $table = 'roles';

    protected $fillable = [
        'name', 'display_name', 'description',
        'permissions', 'max_upload_size', 'max_monthly_uploads',
        'can_download', 'can_upload'
    ];

    protected $casts = [
        'permissions' => 'array',
        'can_download' => 'boolean',
        'can_upload' => 'boolean',
    ];

    public function users()
    {
        return $this->hasMany(User::class, 'role_id');
    }
}

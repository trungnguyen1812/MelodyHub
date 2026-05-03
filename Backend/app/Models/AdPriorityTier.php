<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AdPriorityTier extends Model
{
    protected $table = 'ad_priority_tiers';

    protected $casts = [
        'min_cpm'      => 'float',
        'min_cpc'      => 'float',
        'max_priority' => 'int',
        'sort_order'   => 'int',
        'is_active'    => 'bool',
    ];

    protected $fillable = [
        'value',
        'label',
        'color',
        'min_cpm',
        'min_cpc',
        'max_priority',
        'description',
        'sort_order',
        'is_active',
    ];

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }
}

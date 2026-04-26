<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;

/**
 * Class AdTracking
 *
 * @property int $id
 * @property int $ad_id
 * @property int|null $user_id
 * @property string|null $session_id
 * @property string $event_type
 * @property string|null $ip_address
 * @property string|null $user_agent
 * @property string|null $referrer
 * @property Carbon $tracked_at
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 *
 * @property Advertisement $advertisement
 * @property User|null $user
 */
class AdTracking extends Model
{
    protected $table = 'ad_tracking';

    protected $casts = [
        'ad_id'      => 'int',
        'user_id'    => 'int',
        'tracked_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    protected $fillable = [
        'ad_id',
        'user_id',
        'session_id',
        'event_type',
        'ip_address',
        'user_agent',
        'referrer',
        'tracked_at',
    ];

    /**
     * Quan hệ với bảng advertisements
     */
    public function advertisement()
    {
        return $this->belongsTo(Advertisement::class, 'ad_id');
    }

    /**
     * Quan hệ với bảng users
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
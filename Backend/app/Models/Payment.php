<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Payment extends Model
{
    protected $table = 'payments';

    protected $casts = [
        'user_id' => 'integer',
        'subscription_id' => 'integer',
        'amount' => 'decimal:2',
        'refunded_amount' => 'decimal:2',
        'paid_at' => 'datetime',
        'refunded_at' => 'datetime',
        'payment_details' => 'array', // JSON cast
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    protected $fillable = [
        'user_id',
        'subscription_id',
        'subscription_plan_id',
        'payment_type',
        'amount',
        'currency',
        'status',
        'transfer_content',
        'gateway_transaction_id',
        'bank_code',
        'payment_details',
        'paid_at',
        'failed_reason',
        'refunded_amount',
        'refunded_at',
        'notes'
    ];

    protected $attributes = [
        'currency' => 'VND',
        'status' => 'pending',
    ];

    /**
     * Payment type constants
     */
    const TYPE_SUBSCRIPTION_planb = 'subscriptionPlan';
    const TYPE_UPGRADE = 'upgrade';
    const TYPE_RENEWAL = 'renewal';
    const TYPE_REFUND = 'refund';

    /**
     * Status constants
     */
    const STATUS_PENDING = 'pending';
    const STATUS_PROCESSING = 'processing';
    const STATUS_COMPLETED = 'completed';
    const STATUS_FAILED = 'failed';
    const STATUS_REFUNDED = 'refunded';
    const STATUS_CANCELLED = 'cancelled';

    /**
     * Scope for pending payments
     */
    public function scopePending($query)
    {
        return $query->where('status', self::STATUS_PENDING);
    }

    /**
     * Scope for completed payments
     */
    public function scopeCompleted($query)
    {
        return $query->where('status', self::STATUS_COMPLETED);
    }

    /**
     * Scope for failed payments
     */
    public function scopeFailed($query)
    {
        return $query->where('status', self::STATUS_FAILED);
    }

    /**
     * Scope for specific user
     */
    public function scopeForUser($query, $userId)
    {
        return $query->where('user_id', $userId);
    }

    /**
     * Check if payment is successful
     */
    public function isSuccessful()
    {
        return $this->status === self::STATUS_COMPLETED;
    }

    /**
     * Check if payment is pending
     */
    public function isPending()
    {
        return $this->status === self::STATUS_PENDING;
    }

    /**
     * Mark payment as completed
     */
    public function markAsCompleted($gatewayTransactionId = null, $bankCode = null, $paymentDetails = null)
    {
        $this->update([
            'status' => self::STATUS_COMPLETED,
            'paid_at' => now(),
            'gateway_transaction_id' => $gatewayTransactionId ?? $this->gateway_transaction_id,
            'bank_code' => $bankCode ?? $this->bank_code,
            'payment_details' => $paymentDetails ?? $this->payment_details,
        ]);
    }

    /**
     * Mark payment as failed
     */
    public function markAsFailed($reason = null)
    {
        $this->update([
            'status' => self::STATUS_FAILED,
            'failed_reason' => $reason,
        ]);
    }

    /**
     * Get the user that owns the payment
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the subscription associated with the payment
     */
     
    public function subscriptionPlan(): BelongsTo
    {
        return $this->belongsTo(SubscriptionPlan::class, 'subscription_plan_id');
    }

    /**
     * Create payment from SePay response
     */
    public static function createFromSePay(array $data, $userId, $subscriptionId = null)
    {
        return self::create([
            'user_id' => $userId,
            'subscription_id' => $subscriptionId,
            'payment_type' => $data['payment_type'] ?? 'subscription',
            'amount' => $data['amount'],
            'currency' => $data['currency'] ?? 'VND',
            'status' => self::STATUS_PENDING,
            'transfer_content' => $data['transfer_content'] ?? null,
            'gateway_transaction_id' => $data['transaction_id'] ?? null,
            'bank_code' => $data['bank_code'] ?? null,
            'payment_details' => $data,
        ]);
    }

    /**
     * Generate transfer content for bank transfer
     */
    public function generateTransferContent()
    {
        if (!$this->transfer_content) {
            $this->transfer_content = 'PAY' . str_pad($this->id, 7, '0', STR_PAD_LEFT);
            $this->save();
        }
        return $this->transfer_content;
    }

    /**
     * Get formatted amount with currency
     */
    public function getFormattedAmountAttribute()
    {
        return number_format($this->amount, 0, ',', '.') . ' ' . $this->currency;
    }

    /**
     * Get payment gateway name
     */
    public function getGatewayNameAttribute()
    {
        if ($this->bank_code) {
            return $this->getBankName($this->bank_code);
        }
        
        if ($this->gateway_transaction_id) {
            if (strpos($this->gateway_transaction_id, 'MOMO') !== false) {
                return 'Momo';
            }
            if (strpos($this->gateway_transaction_id, 'SEPAY') !== false) {
                return 'SePay';
            }
        }
        
        return 'Ngân hàng';
    }

    /**
     * Get bank name from code
     */
    private function getBankName($code)
    {
        $banks = [
            'VCB' => 'Vietcombank',
            'ICB' => 'VietinBank',
            'BIDV' => 'BIDV',
            'ACB' => 'ACB',
            'VIB' => 'VIB',
            'TCB' => 'Techcombank',
            'MB' => 'MB Bank',
            'STB' => 'Sacombank',
            'VPB' => 'VP Bank',
            'TPB' => 'TP Bank',
        ];
        
        return $banks[$code] ?? $code;
    }
}
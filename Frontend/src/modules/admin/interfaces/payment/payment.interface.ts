// modules/admin/interfaces/payment/payment.interface.ts

export type PaymentStatus = 'pending' | 'processing' | 'completed' | 'failed' | 'cancelled'
export type PaymentType   = 'partner_payout' | 'subscription' | 'ad_payment' | 'refund'

export interface Payment {
  id: number
  reference_code: string          // e.g. PAY-20240426-00123
  type: PaymentType
  status: PaymentStatus

  // Bên nhận / liên quan
  partner_id: number | null
  partner_name: string | null
  user_id: number | null
  user_name: string | null

  // Tài chính
  amount: number                  // số tiền thực tế
  currency: string                // 'VND'
  fee: number | null              // phí giao dịch nếu có
  net_amount: number | null       // amount - fee

  // Ngân hàng (dành cho payout)
  bank_name: string | null
  bank_account_number: string | null
  bank_account_name: string | null

  // Thời gian
  requested_at: string | null
  processed_at: string | null
  created_at: string
  updated_at: string

  // Meta
  note: string | null
  failure_reason: string | null
}

export interface PaymentSummary {
  total_payments: number
  total_amount: number
  pending_amount: number
  completed_amount: number
  failed_count: number
  this_month_amount: number
}

export interface PaymentListResponse {
  data: Payment[]
  summary: PaymentSummary
  current_page: number
  last_page: number
  per_page: number
  total: number
}

export interface PaymentFilterParams {
  page?: number
  per_page?: number
  status?: string
  type?: string
  keyword?: string
  date_from?: string
  date_to?: string
}

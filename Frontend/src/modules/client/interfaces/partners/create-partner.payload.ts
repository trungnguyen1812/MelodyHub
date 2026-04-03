export interface CreatePartnerRequest {
  // Company
  partner_type_id:           number
  company_name:              string
  company_email:             string
  company_phone?:            string
  company_address?:          string
  tax_code?:                 string
  website?:                  string
  description?:              string
  logo_url?:                 string

  // Contract
  contract_number:           string
  contract_start_date:       string        // format: YYYY-MM-DD
  contract_file:             File          // file .docx upload lên server
  revenue_share_percentage?: number
  payment_threshold?:        number
  payment_frequency?:        'weekly' | 'monthly' | 'quarterly'

  // Bank
  bank_name:                 string
  bank_branch?:              string
  bank_account_number:       string
  bank_account_name:         string
}

export interface CreatePartnerResponse {
  message: string
  data:    Partner
}

export interface Partner {
  id:                        number
  user_id:                   number
  partner_type_id:           number
  company_name:              string
  company_email:             string
  company_phone:             string | null
  company_address:           string | null
  tax_code:                  string | null
  website:                   string | null
  description:               string | null
  logo_url:                  string | null
  contract_number:           string
  contract_file_url:         string        // Cloudinary URL
  contract_start_date:       string
  contract_end_date:         string
  revenue_share_percentage:  number | null
  payment_threshold:         number | null
  payment_frequency:         'weekly' | 'monthly' | 'quarterly' | null
  bank_name:                 string
  bank_branch:               string | null
  bank_account_number:       string
  bank_account_name:         string
  status:                    'pending' | 'active' | 'inactive'
  created_at:                string
  updated_at:                string
}
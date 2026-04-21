// modules/admin/interfaces/partners/create-partner.payload.ts

export interface CreatePartnerPayload {
    user_id: number;
    partner_type_id: number;
    company_name: string;
    company_email: string;
    company_phone?: string;
    company_address?: string;
    tax_code?: string;
    website?: string;
    logo?: File | null;
    description?: string;
    contract_number?: string;
    contract_file?: File | null;
    contract_start_date?: string;
    contract_end_date?: string;
    revenue_share_percentage?: number;
    payment_threshold?: number;
    payment_frequency?: 'weekly' | 'monthly' | 'quarterly';
    bank_name?: string;
    bank_branch?: string;
    bank_account_number?: string;
    bank_account_name?: string;
    status?: 'active' | 'pending' | 'suspended' | 'terminated';
    notes?: string;
}
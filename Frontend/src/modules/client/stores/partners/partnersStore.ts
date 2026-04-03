import { defineStore } from 'pinia'
import partnerService from '@/modules/client/services/partners/partners.service'
import clientApi from '@/plugins/axios';
import type { Partner, CreatePartnerRequest } from '@/modules/client/interfaces/partners/create-partner.payload'
import type { PermissionResponse } from '@/interfaces/permission.interface';

interface PartnerState {
  partners: Partner[]
  currentPartner: Partner | null
  loading: boolean
  error: string | null
  partnerInfo: PermissionResponse | null
}

export const usePartnerStore = defineStore('client_partner', {
  state: (): PartnerState => ({
    partners: [],
    currentPartner: null,
    loading: false,
    error: null,
    partnerInfo: null,
  }),

  actions: {
    async addPartner(payload: CreatePartnerRequest) {
      this.loading = true
      this.error = null
      try {
        const formData = new FormData()

        // Company
        formData.append('partner_type_id', String(payload.partner_type_id))
        formData.append('company_name', payload.company_name)
        formData.append('company_email', payload.company_email)
        if (payload.company_phone) formData.append('company_phone', payload.company_phone)
        if (payload.company_address) formData.append('company_address', payload.company_address)
        if (payload.tax_code) formData.append('tax_code', payload.tax_code)
        if (payload.website) formData.append('website', payload.website)
        if (payload.description) formData.append('description', payload.description)
        if (payload.logo_url) formData.append('logo_url', payload.logo_url)

        // Contract
        formData.append('contract_number', payload.contract_number)
        formData.append('contract_start_date', payload.contract_start_date)
        formData.append('contract_file', payload.contract_file)
        if (payload.revenue_share_percentage != null)
          formData.append('revenue_share_percentage', String(payload.revenue_share_percentage))
        if (payload.payment_threshold != null)
          formData.append('payment_threshold', String(payload.payment_threshold))
        if (payload.payment_frequency)
          formData.append('payment_frequency', payload.payment_frequency)

        // Bank
        formData.append('bank_name', payload.bank_name)
        formData.append('bank_account_number', payload.bank_account_number)
        formData.append('bank_account_name', payload.bank_account_name)
        if (payload.bank_branch) formData.append('bank_branch', payload.bank_branch)

        const res = await partnerService.addPartner(formData)
        const newPartner: Partner = res.data.data
        this.partners.unshift(newPartner)
        return newPartner

      } catch (err: any) {
        this.error = err?.response?.data?.message || 'Add partner failed'
        throw err
      } finally {
        this.loading = false
      }
    },
    async fetchPartnerInfo() {
      if (this.partnerInfo !== null) {
        return this.partnerInfo
      }
      
      if (this.loading) {
        return null
      }
      
      this.loading = true
      this.error = null
      
      try {
        const res = await clientApi.get('/check-permission')
        this.partnerInfo = res.data
        return this.partnerInfo
      } catch (error: any) {
        console.error('Fetch partner info error:', error)
        this.error = error?.response?.data?.message || 'Fetch partner info failed'
        return null
      } finally {
        this.loading = false
      }
    },
    async fetchPartners() {
      try {
          this.loading = true;
          this.error = null;

          const data = await partnerService.getAllPartners();

          if (!data) {
              this.partners = [];
              return;
          }

          const rawpartners = Array.isArray(data)
          ? data
          : Array.isArray(data?.data)
          ? data.data
          : Object.values(data ?? {});
          this.partners = rawpartners
              .filter((u: any) => !u.deleted_at)
              .sort(
                  (a: any, b: any) =>
                      new Date(b.created_at).getTime() -
                      new Date(a.created_at).getTime()
              );

      } catch (err: any) {
          this.error = err?.message || "Failed to fetch artist";
      } finally {
          this.loading = false;
      }
  },
    setCurrentPartner(partner: Partner | null) {
      this.currentPartner = partner
    },

    clearPartnerInfo() {
      this.partnerInfo = null
    },

    reset() {
      this.partners = []
      this.currentPartner = null
      this.loading = false
      this.error = null
      this.partnerInfo = null
    }
    
  },
   getters: {
    // get partner từ response
    partner: (state) => state.partnerInfo?.partner || null,
    
    // get partner_type_name
    partnerTypeName: (state) => state.partnerInfo?.partner_type_name || '',
    
    // get tên công ty
    companyName: (state) => state.partnerInfo?.partner?.company_name || '',
    
    // get email công ty
    companyEmail: (state) => state.partnerInfo?.partner?.company_email || '',
    
    // get user
    user: (state) => state.partnerInfo?.user || null,
    
    // get tên user
    userName: (state) => state.partnerInfo?.user?.name || '',
    
    // Kiểm tra có phải partner không
    isPartner: (state) => state.partnerInfo?.is_partner || false,
    
    // Kiểm tra có phải music distribution không
    isMusicDistribution: (state) => state.partnerInfo?.is_music_distribution || false,
    
    // Kiểm tra có phải admin không
    isAdmin: (state) => state.partnerInfo?.is_admin || false,
    
    // get roles flags
    rolesFlags: (state) => state.partnerInfo?.roles_flags || null,
    
    // get partner type
    partnerType: (state) => state.partnerInfo?.partner?.partner_type || null,
    
    // get revenue share percentage
    revenueSharePercentage: (state) => state.partnerInfo?.partner?.revenue_share_percentage || 0,
    
    // get contract status
    contractStatus: (state) => {
      const partner = state.partnerInfo?.partner
      if (!partner) return null
      return {
        contractNumber: partner.contract_number,
        startDate: partner.contract_start_date,
        endDate: partner.contract_end_date,
        isExpired: new Date(partner.contract_end_date) < new Date()
      }
    },
    
    // get bank information
    bankInfo: (state) => {
      const partner = state.partnerInfo?.partner
      if (!partner) return null
      return {
        bankName: partner.bank_name,
        bankBranch: partner.bank_branch,
        accountNumber: partner.bank_account_number,
        accountName: partner.bank_account_name
      }
    }
  }
})
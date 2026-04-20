<template>
  <div class="partner-register">
    <!-- Background -->
    <div class="bg-grid"></div>
    <div class="bg-glow"></div>

    <div class="register-container">
      <!-- Header -->
      <div class="register-header">
        <h1 class="register-title">Partner Registration</h1>
        <p class="register-subtitle">Complete the steps below to become an official partner</p>
      </div>

      <!-- Stepper -->
      <div class="stepper">
        <div
          v-for="(step, index) in steps"
          :key="index"
          class="step-item"
          :class="{
            'is-active': currentStep === index,
            'is-done': currentStep > index
          }"
        >
          <div class="step-circle">
            <svg v-if="currentStep > index" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
            <span v-else>{{ index + 1 }}</span>
          </div>
          <div class="step-label">{{ step.label }}</div>
          <div v-if="index < steps.length - 1" class="step-line"></div>
        </div>
      </div>

      <!-- Form Card -->
      <div class="form-card">

        <!-- ───────────── STEP 0: Company Info ───────────── -->
        <transition name="fade-slide" mode="out-in">
        <div v-if="currentStep === 0" key="step0">
          <div class="step-heading">
            <span class="step-badge">Step 1</span>
            <h2>Company Information</h2>
            <p>Basic details pre-filled from your previous submission. Please review and complete.</p>
          </div>

          <div class="form-grid">
            <div class="form-group">
              <label>Company Name <span class="req">*</span></label>
              <input v-model="form.company_name" type="text" placeholder="Your company name" :class="{ invalid: errors.company_name }">
              <span class="err-msg" v-if="errors.company_name">{{ errors.company_name }}</span>
            </div>

            <div class="form-group">
              <label>Contact Name</label>
              <input :value="fullName" type="text" disabled class="input-disabled">
            </div>

            <div class="form-group">
              <label>Company Email <span class="req">*</span></label>
              <input v-model="form.company_email" type="email" placeholder="you@company.com" :class="{ invalid: errors.company_email }">
              <span class="err-msg" v-if="errors.company_email">{{ errors.company_email }}</span>
            </div>

            <div class="form-group">
              <label>Company Phone</label>
              <input v-model="form.company_phone" type="tel" placeholder="+84">
            </div>

            <div class="form-group full">
              <label>Partner Type <span class="req">*</span></label>
              <select v-model="form.partner_type_id" :class="{ invalid: errors.partner_type_id }">
                <option value="">Select partnership type</option>
                <option v-for="t in TypePartners" :key="t.id" :value="t.id">{{ t.name }}</option>
              </select>
              <span class="err-msg" v-if="errors.partner_type_id">{{ errors.partner_type_id }}</span>
            </div>

            <div class="form-group full">
              <label>Company Address <span class="req">*</span></label>
              <input v-model="form.company_address" type="text" placeholder="123 Street, City, Country" :class="{ invalid: errors.company_address }">
              <span class="err-msg" v-if="errors.company_address">{{ errors.company_address }}</span>
            </div>

            <div class="form-group">
              <label>Tax Code <span class="req">*</span></label>
              <input v-model="form.tax_code" type="text" placeholder="0123456789" :class="{ invalid: errors.tax_code }">
              <span class="err-msg" v-if="errors.tax_code">{{ errors.tax_code }}</span>
            </div>

            <div class="form-group">
              <label>Website <span class="req">*</span></label>
              <input v-model="form.website" type="url" placeholder="https://yourcompany.com" :class="{ invalid: errors.website }">
              <span class="err-msg" v-if="errors.website">{{ errors.website }}</span>
            </div>

            <div class="form-group full">
              <label>Company Logo URL</label>
              <input v-model="form.logo_url" type="url" placeholder="https://...">
            </div>

            <div class="form-group full">
              <label>Description</label>
              <textarea v-model="form.description" rows="3" placeholder="Briefly describe your company and what you do..."></textarea>
            </div>
          </div>
        </div>

        <!-- ───────────── STEP 1: Contract Info ───────────── -->
        <div v-else-if="currentStep === 1" key="step1">
        <div class="step-heading">
            <span class="step-badge">Step 2</span>
            <h2>Contract Details</h2>
            <p>Download the pre-filled contract template, sign it, then upload the signed copy.</p>
        </div>

        <div class="form-grid">
            <!-- Contract Number (readonly, auto-generated) -->
            <div class="form-group">
            <label>Contract Number</label>
            <div class="input-readonly">
                <span>{{ form.contract_number }}</span>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="5" y="2" width="14" height="20" rx="2"/><line x1="9" y1="7" x2="15" y2="7"/><line x1="9" y1="11" x2="15" y2="11"/><line x1="9" y1="15" x2="13" y2="15"/></svg>
            </div>
            <small class="hint">Auto-generated — no action needed.</small>
            </div>

            <!-- Download template -->
            <div class="form-group">
            <label>Contract Template</label>
            <button type="button" class="btn-download" @click="downloadContract" :disabled="!generatedFile">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                <polyline points="7 10 12 15 17 10"/>
                <line x1="12" y1="15" x2="12" y2="3"/>
                </svg>
                Download Pre-filled Contract
            </button>
            <small class="hint">Download to keep a copy of your contract.</small>
            </div>

            <!-- Contract preview (auto-generated) -->
            <div class="form-group full">
            <label>Contract File</label>

            <!-- Loading state -->
            <div class="upload-zone" v-if="!generatedFile">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="spin">
                <path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"/>
                </svg>
                <p class="upload-text">Generating your contract...</p>
            </div>

            <!-- Generated state (readonly preview) -->
            <div class="upload-zone is-uploaded" v-else>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#4ade80" stroke-width="2">
                <polyline points="20 6 9 17 4 12"/>
                </svg>
                <div class="upload-file-info">
                <span class="upload-filename">{{ generatedFileName }}</span>
                <span class="upload-filesize">{{ formatFileSize(generatedFile.size) }} · Auto-generated</span>
                </div>
            </div>

            <span class="err-msg" v-if="errors.contract_file">{{ errors.contract_file }}</span>
            </div>

            <div class="form-group">
            <label>Contract Start Date <span class="req">*</span></label>
            <input 
                v-model="contract_start_date" 
                type="date" 
                :class="{ invalid: errors.contract_start_date }"
                disabled="true"
            >
            <span class="err-msg" v-if="errors.contract_start_date">
                {{ errors.contract_start_date }}
            </span>
            </div>


            <div class="form-group">
            <label>Revenue Share (%)</label>
            <input v-model.number="form.revenue_share_percentage" type="number" min="0" max="100" step="0.01" placeholder="70.00" readonly>
            </div>

            <div class="form-group">
                <label>Payment Frequency <span class="req">*</span></label>
                <select v-model="form.payment_frequency" :class="{ invalid: errors.payment_frequency }">
                    <option value="" disabled>Select frequency</option>
                    <option value="daily">Daily</option>
                    <option value="weekly">Weekly</option>
                    <option value="monthly">Monthly</option>
                    <option value="quarterly">Quarterly</option>
                    <option value="yearly">Yearly</option>
                </select>
                <span class="err-msg" v-if="errors.payment_frequency">{{ errors.payment_frequency }}</span>
            </div>

            <div class="form-group full">
                <label>Payment Threshold (USD)</label>
                <input 
                    v-model.number="form.payment_threshold" 
                    type="number" 
                    min="0" 
                    disabled
                >
                <small class="hint">Minimum revenue required before payout is triggered.</small>
            </div>

        </div>
        </div>

        <!-- ───────────── STEP 2: Bank Info ───────────── -->
        <div v-else-if="currentStep === 2" key="step2">
          <div class="step-heading">
            <span class="step-badge">Step 3</span>
            <h2>Bank Information</h2>
            <p>Your payment details for revenue distribution.</p>
          </div>

          <div class="form-grid">
            <div class="form-group">
              <label>Bank Name <span class="req">*</span></label>
              <input v-model="form.bank_name" type="text" placeholder="Vietcombank" :class="{ invalid: errors.bank_name }">
              <span class="err-msg" v-if="errors.bank_name">{{ errors.bank_name }}</span>
            </div>

            <div class="form-group">
              <label>Bank Branch</label>
              <input v-model="form.bank_branch" type="text" placeholder="Ho Chi Minh City Branch">
            </div>

            <div class="form-group">
              <label>Account Number <span class="req">*</span></label>
              <input v-model="form.bank_account_number" type="text" placeholder="0123456789" :class="{ invalid: errors.bank_account_number }">
              <span class="err-msg" v-if="errors.bank_account_number">{{ errors.bank_account_number }}</span>
            </div>

            <div class="form-group">
              <label>Account Name <span class="req">*</span></label>
              <input v-model="form.bank_account_name" type="text" placeholder="NGUYEN VAN A" :class="{ invalid: errors.bank_account_name }">
              <span class="err-msg" v-if="errors.bank_account_name">{{ errors.bank_account_name }}</span>
            </div>

            <div class="form-group full info-box">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
              <span>Please ensure account name matches exactly as shown on your bank records. Incorrect info may delay payouts.</span>
            </div>
          </div>
        </div>

        <!-- ───────────── STEP 3: Confirm ───────────── -->
        <div v-else-if="currentStep === 3" key="step3">
          <div class="step-heading">
            <span class="step-badge">Step 4</span>
            <h2>Review & Submit</h2>
            <p>Please review all information before submitting your partner application.</p>
          </div>

          <div class="review-sections">
            <!-- Company -->
            <div class="review-block">
              <div class="review-block-header">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/></svg>
                Company Information
              </div>
              <div class="review-grid">
                <div class="review-item"><span class="rl">Company</span><span class="rv">{{ form.company_name }}</span></div>
                <div class="review-item"><span class="rl">Email</span><span class="rv">{{ form.company_email }}</span></div>
                <div class="review-item"><span class="rl">Phone</span><span class="rv">{{ form.company_phone || '—' }}</span></div>
                <div class="review-item"><span class="rl">Address</span><span class="rv">{{ form.company_address }}</span></div>
                <div class="review-item"><span class="rl">Tax Code</span><span class="rv">{{ form.tax_code }}</span></div>
                <div class="review-item"><span class="rl">Website</span><span class="rv">{{ form.website }}</span></div>
                <div class="review-item"><span class="rl">Partner Type</span><span class="rv">{{ selectedTypeName }}</span></div>
              </div>
            </div>

            <!-- Contract -->
            <div class="review-block">
              <div class="review-block-header">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                Contract Details
              </div>
              <div class="review-grid">
                <div class="review-item"><span class="rl">Contract No.</span><span class="rv">{{ form.contract_number }}</span></div>
                <div class="review-item"><span class="rl">Start Date</span><span class="rv">{{ form.contract_start_date }}</span></div>
                <div class="review-item"><span class="rl">Revenue Share</span><span class="rv">{{ form.revenue_share_percentage }}%</span></div>
                <div class="review-item"><span class="rl">Payment</span><span class="rv">{{ form.payment_frequency }}</span></div>
              </div>
            </div>

            <!-- Bank -->
            <div class="review-block">
              <div class="review-block-header">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="5" width="20" height="14" rx="2"/><line x1="2" y1="10" x2="22" y2="10"/></svg>
                Bank Information
              </div>
              <div class="review-grid">
                <div class="review-item"><span class="rl">Bank</span><span class="rv">{{ form.bank_name }}</span></div>
                <div class="review-item"><span class="rl">Branch</span><span class="rv">{{ form.bank_branch || '—' }}</span></div>
                <div class="review-item"><span class="rl">Account No.</span><span class="rv">{{ form.bank_account_number }}</span></div>
                <div class="review-item"><span class="rl">Account Name</span><span class="rv">{{ form.bank_account_name }}</span></div>
              </div>
            </div>
          </div>

          <div class="agree-box">
            <label class="agree-label">
              <input type="checkbox" v-model="agreed">
              <span>I confirm that all information provided is accurate and I agree to the <a href="#">Partner Terms & Conditions</a></span>
            </label>
          </div>
        </div>
        </transition>

        <!-- Navigation -->
        <div class="form-nav">
          <button class="btn-back" @click="prevStep" v-if="currentStep > 0" :disabled="loading">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
            Back
          </button>
          <div v-else></div>

          <button
            v-if="currentStep < steps.length - 1"
            class="btn-next"
            @click="nextStep"
            :disabled="loading"
          >
            Continue
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
          </button>

          <button
            v-else
            class="btn-submit"
            @click="submitForm"
            :disabled="loading || !agreed"
          >
            <span v-if="loading" class="spinner"></span>
            {{ loading ? 'Submitting...' : 'Submit Application' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted ,watch} from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '@/store/authStore'
import PizZip from "pizzip"
import Docxtemplater from "docxtemplater"
import { storeToRefs } from 'pinia'
import { useTypePartnerstore } from '@/modules/client/stores/typePartners/typePartnersStore'
import {usePartnerStore} from '@/modules/client/stores/partners/partnersStore';
import { useNotificationStore } from '@/store/notificationStore'


const router        = useRouter()
const route         = useRoute()
const authStore     = useAuthStore()
const typePartnerStore = useTypePartnerstore()
const partnerStore = usePartnerStore()
const notificationStore = useNotificationStore()

const query    = route.query
const fullName = computed(() => authStore.user?.name ?? '')

const { TypePartners } = storeToRefs(typePartnerStore)

const partnerTypeName = computed(() => {
  if (!form.partner_type_id) return ''
  return TypePartners.value.find(t => t.id === form.partner_type_id)?.name ?? ''
})

const selectedTypeName = computed(() => {
  const found = TypePartners.value.find(t => t.id === form.partner_type_id)
  return found?.name ?? '—'
})

const selectedTypepaymentthreshold = computed(() => {
  const found = TypePartners.value.find(t => t.id === form.partner_type_id)
  return found?.default_payment_threshold ?? '—'
})




// ── Steps ──
const steps = [
  { label: 'Company' },
  { label: 'Contract' },
  { label: 'Bank' },
  { label: 'Confirm' },
]

const currentStep = ref(0)
const loading     = ref(false)
const agreed      = ref(false)

// ── Generated contract (lưu trong memory) ──
const generatedFile     = ref<Blob | null>(null)
const generatedFileName = ref<string>('')

// ── Helpers ──
const generateContractNumber = () => {
  const random = Math.floor(100000 + Math.random() * 900000)
  return `HD${random}`
}

const formatDateForInput = (date: Date): string => {
  const year  = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day   = String(date.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

const formatFileSize = (bytes: number): string => {
  if (bytes < 1024)            return bytes + ' B'
  if (bytes < 1024 * 1024)     return (bytes / 1024).toFixed(1) + ' KB'
  return (bytes / (1024 * 1024)).toFixed(1) + ' MB'
}

const contract_start_date = ref<string>(formatDateForInput(new Date()));

// ── Form ──
const form = reactive({
  // Pre-filled từ query params
  company_name:    (query.company     as string) ?? '',
  company_email:   (query.email       as string) ?? authStore.user?.email ?? '',
  company_phone:   (query.phone       as string) ?? '',
  partner_type_id: query.typePartner_id ? Number(query.typePartner_id) : '' as number | '',
  
  // Step 0 - Company
  company_address: '',
  tax_code:        '',
  website:         '',
  logo_url:        '',
  description:     '',

  // Step 1 - Contract
  contract_number:          generateContractNumber(),
  contract_start_date:      formatDateForInput(new Date()),
  revenue_share_percentage: 0,
  payment_frequency:        'monthly' as 'weekly' | 'monthly' | 'quarterly',
  payment_threshold:        0 as number,

  // Step 2 - Bank
  bank_name:           '',
  bank_branch:         '',
  bank_account_number: '',
  bank_account_name:   '',
})

const errors = reactive<Record<string, string>>({})

// ── Generate contract (auto khi vào Step 1) ──
const generateContract = async () => {
  try {
    const currentType = TypePartners.value.find(t => t.id === form.partner_type_id)
    const typeCode    = currentType?.code ?? ''

    console.log('currentType:', currentType)
    console.log('typeCode:', typeCode)

    const templateMap: Record<string, string> = {
      'advertising': '/template/contract_template - adv.docx',
      'music':       '/template/contract_template.docx',
    }

    const templateFile = templateMap[typeCode] ?? '/template/contract_template.docx'

    console.log('Using template:', templateFile)

    const response = await fetch(`${templateFile}?t=${Date.now()}`, {
      cache: 'no-store'
    })
    if (!response.ok) throw new Error(`Failed to fetch template: ${response.status}`)

    const content = await response.arrayBuffer()
    const zip     = new PizZip(content)
    const doc     = new Docxtemplater(zip, {
      paragraphLoop: true,
      linebreaks:    true,
      delimiters:    { start: '{{', end: '}}' }
    })

    doc.setData({
      contract_number:          form.contract_number          || '',
      partner_type_id:          partnerTypeName.value         || '',
      company_name:             form.company_name             || '',
      company_email:            form.company_email            || '',
      tax_code:                 form.tax_code                 || '',
      revenue_share_percentage: form.revenue_share_percentage || '',
      signer_name:              fullName.value                || '',
    })

    doc.render()

    const blob = doc.getZip().generate({
      type:     'blob',
      mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    })

    generatedFile.value     = blob
    generatedFileName.value = `${form.contract_number || 'contract'}.docx`

  } catch (error: any) {
    console.error('Generate contract error:', error)
    if (error?.properties?.errors) {
      error.properties.errors.forEach((err: any) => console.error('Template error:', err))
    }
  }
}

// ── Download (dùng lại Blob đã gen) ──
const downloadContract = () => {
  if (!generatedFile.value) return
  const url = URL.createObjectURL(generatedFile.value)
  const a   = document.createElement('a')
  a.href    = url
  a.download = generatedFileName.value
  a.click()
  URL.revokeObjectURL(url)
}

// ── Validate từng step ──
const validateStep = (step: number): boolean => {
  Object.keys(errors).forEach(k => delete errors[k])
  let valid = true

  if (step === 0) {
    if (!form.company_name.trim())    { errors.company_name    = 'Company name is required';     valid = false }
    if (!form.company_email.trim())   { errors.company_email   = 'Company email is required';    valid = false }
    if (!form.company_address.trim()) { errors.company_address = 'Company address is required';  valid = false }
    if (!form.tax_code.trim())        { errors.tax_code        = 'Tax code is required';         valid = false }
    if (!form.website.trim())         { errors.website         = 'Website is required';          valid = false }
    if (!form.partner_type_id)        { errors.partner_type_id = 'Please select a partner type'; valid = false }
  }

  if (step === 1) {
    if (!form.contract_number.trim()) { errors.contract_number     = 'Contract number is required'; valid = false }
    if (!form.contract_start_date)    { errors.contract_start_date = 'Start date is required';      valid = false }
    if (!generatedFile.value)         { errors.contract_file       = 'Contract is not generated yet'; valid = false }
  }

  if (step === 2) {
    if (!form.bank_name.trim())           { errors.bank_name           = 'Bank name is required';      valid = false }
    if (!form.bank_account_number.trim()) { errors.bank_account_number = 'Account number is required'; valid = false }
    if (!form.bank_account_name.trim())   { errors.bank_account_name   = 'Account name is required';   valid = false }
  }

  return valid
}

// ── Navigation ──
const nextStep = async () => {
  if (!validateStep(currentStep.value)) return
  currentStep.value++
  if (currentStep.value === 1) {
    await generateContract()
  }
}

const prevStep = () => {
  if (currentStep.value > 0) currentStep.value--
}

// ── Submit ──
const submitForm = async () => {
  if (!agreed.value || !generatedFile.value) return
  loading.value = true
  try {
    const file = new File([generatedFile.value], generatedFileName.value, {
      type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    })

    await partnerStore.addPartner({
      // Company
      partner_type_id:          form.partner_type_id as number,
      company_name:             form.company_name,
      company_email:            form.company_email,
      company_phone:            form.company_phone,
      company_address:          form.company_address,
      tax_code:                 form.tax_code,
      website:                  form.website,
      description:              form.description,

      // Contract
      contract_number:          form.contract_number,
      contract_start_date:      form.contract_start_date,
      contract_file:            file,
      revenue_share_percentage: form.revenue_share_percentage,
      payment_frequency:        form.payment_frequency,
      payment_threshold:        form.payment_threshold,

      // Bank
      bank_name:                form.bank_name,
      bank_branch:              form.bank_branch,
      bank_account_number:      form.bank_account_number,
      bank_account_name:        form.bank_account_name,
    })
    notificationStore.notify("Register successful" ,"success");
    router.push({ name: 'client.home' })

  } catch (err: any) {
    notificationStore.notify(err.response?.data?.message || 'Failed to create song', 'error')
  } finally {
    loading.value = false
    setTimeout(() => notificationStore.clear(), 3000)
  }
}

// ── Init ──
onMounted(async () => {
  if (!TypePartners.value.length) {
    await typePartnerStore.fetchTypePartners()
  }
})

watch(
  [() => form.partner_type_id, TypePartners],
  ([newTypeId]) => {
    if (!newTypeId || !TypePartners.value.length) return

    const found = TypePartners.value.find(t => t.id === newTypeId)
    console.log('found:', found)

    if (found) {
      form.payment_threshold        = found.default_payment_threshold
      form.revenue_share_percentage = found.default_revenue_share
      form.payment_frequency        = (found.default_payment_frequency ?? 'monthly') as 'weekly' | 'monthly' | 'quarterly'
    } else {
      form.payment_threshold        = 0
      form.revenue_share_percentage = 0
      form.payment_frequency        = 'monthly'
    }
  },
  { immediate: true }
)
</script>

<style scoped>
/* ── Root ── */
.partner-register {
  min-height: 100vh;
  background: #080e14;
  color: #e8eaed;
  font-family: 'DM Sans', sans-serif;
  position: relative;
  overflow: hidden;
  padding: 48px 16px 80px;
}

.bg-grid {
  position: fixed; inset: 0;
  background-image:
    linear-gradient(rgba(255,255,255,.025) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255,255,255,.025) 1px, transparent 1px);
  background-size: 40px 40px;
  pointer-events: none;
}
.bg-glow {
  position: fixed; top: -200px; left: 50%;
  transform: translateX(-50%);
  width: 600px; height: 500px;
  background: radial-gradient(ellipse, rgba(99,102,241,.12) 0%, transparent 70%);
  pointer-events: none;
}

/* ── Container ── */
.register-container {
  max-width: 760px;
  margin: 0 auto;
  position: relative;
  z-index: 1;
}

/* ── Header ── */
.register-header {
  text-align: center;
  margin-bottom: 40px;
}
.register-title {
  font-size: 2rem;
  font-weight: 700;
  letter-spacing: -0.03em;
  background: linear-gradient(135deg, #fff 40%, #818cf8);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  margin: 0 0 8px;
}
.register-subtitle {
  color: #6b7280;
  font-size: 0.95rem;
  margin: 0;
}

/* ── Stepper ── */
.stepper {
  display: flex;
  align-items: flex-start;
  justify-content: center;
  gap: 0;
  margin-bottom: 32px;
}
.step-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
  flex: 1;
}
.step-circle {
  width: 34px; height: 34px;
  border-radius: 50%;
  border: 2px solid #2d3748;
  background: #111827;
  display: flex; align-items: center; justify-content: center;
  font-size: 13px; font-weight: 600; color: #6b7280;
  transition: all .3s;
  position: relative; z-index: 1;
}
.step-item.is-active .step-circle {
  border-color: #6366f1;
  color: #6366f1;
  box-shadow: 0 0 0 4px rgba(99,102,241,.15);
}
.step-item.is-done .step-circle {
  background: #6366f1;
  border-color: #6366f1;
  color: #fff;
}
.step-label {
  font-size: 11px;
  color: #4b5563;
  margin-top: 8px;
  font-weight: 500;
  letter-spacing: .04em;
  text-transform: uppercase;
}
.step-item.is-active .step-label { color: #a5b4fc; }
.step-item.is-done .step-label   { color: #6366f1; }
.step-line {
  position: absolute;
  top: 17px; left: calc(50% + 17px);
  width: calc(100% - 34px);
  height: 2px;
  background: #1f2937;
  z-index: 0;
}
.step-item.is-done .step-line { background: #6366f1; }

/* ── Card ── */
.form-card {
  background: rgba(17,24,39,.85);
  border: 1px solid rgba(255,255,255,.07);
  border-radius: 20px;
  padding: 40px;
  backdrop-filter: blur(12px);
}

/* ── Step heading ── */
.step-heading { margin-bottom: 28px; }
.step-badge {
  display: inline-block;
  background: rgba(99,102,241,.15);
  color: #818cf8;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: .08em;
  text-transform: uppercase;
  padding: 3px 10px;
  border-radius: 20px;
  margin-bottom: 10px;
}
.step-heading h2 {
  font-size: 1.35rem;
  font-weight: 700;
  margin: 0 0 6px;
  color: #f1f5f9;
}
.step-heading p { color: #6b7280; font-size: .9rem; margin: 0; }

/* ── Form Grid ── */
.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}
.form-group { display: flex; flex-direction: column; gap: 6px; }
.form-group.full { grid-column: 1 / -1; }

label {
  font-size: 13px;
  font-weight: 500;
  color: #9ca3af;
  letter-spacing: .02em;
}
.req { color: #f87171; }

input, select, textarea {
  background: rgba(255,255,255,.04);
  border: 1px solid rgba(255,255,255,.09);
  border-radius: 10px;
  color: #e8eaed;
  font-size: 14px;
  padding: 10px 14px;
  outline: none;
  transition: border-color .2s, box-shadow .2s;
  width: 100%;
  box-sizing: border-box;
  font-family: inherit;
}
input::placeholder, textarea::placeholder { color: #374151; }
input:focus, select:focus, textarea:focus {
  border-color: rgba(99,102,241,.5);
  box-shadow: 0 0 0 3px rgba(99,102,241,.1);
}
input.invalid, select.invalid { border-color: #f87171; }
.input-disabled { opacity: .5; cursor: not-allowed; }
select { cursor: pointer; }
select option { background: #1f2937; }
textarea { resize: vertical; min-height: 80px; }
.err-msg { color: #f87171; font-size: 12px; }
.hint { color: #4b5563; font-size: 12px; }

/* ── Info box ── */
.info-box {
  display: flex !important;
  flex-direction: row !important;
  align-items: flex-start;
  gap: 10px;
  background: rgba(99,102,241,.07);
  border: 1px solid rgba(99,102,241,.2);
  border-radius: 10px;
  padding: 14px;
  color: #818cf8;
  font-size: 13px;
  line-height: 1.5;
}
.info-box svg { flex-shrink: 0; margin-top: 2px; }

/* ── Review ── */
.review-sections { display: flex; flex-direction: column; gap: 16px; }
.review-block {
  border: 1px solid rgba(255,255,255,.07);
  border-radius: 12px;
  overflow: hidden;
}
.review-block-header {
  display: flex; align-items: center; gap: 8px;
  background: rgba(255,255,255,.04);
  padding: 12px 16px;
  font-size: 13px;
  font-weight: 600;
  color: #9ca3af;
  border-bottom: 1px solid rgba(255,255,255,.06);
}
.review-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0;
}
.review-item {
  display: flex;
  flex-direction: column;
  gap: 2px;
  padding: 12px 16px;
  border-bottom: 1px solid rgba(255,255,255,.04);
}
.review-item:nth-last-child(-n+2) { border-bottom: none; }
.rl { font-size: 11px; color: #4b5563; text-transform: uppercase; letter-spacing: .05em; }
.rv { font-size: 14px; color: #e8eaed; font-weight: 500; word-break: break-all; }

/* ── Agree ── */
.agree-box {
  margin-top: 24px;
  padding: 16px;
  background: rgba(255,255,255,.03);
  border: 1px solid rgba(255,255,255,.07);
  border-radius: 10px;
}
.agree-label {
  display: flex; align-items: flex-start; gap: 10px;
  font-size: 14px; color: #9ca3af; cursor: pointer;
}
.agree-label input[type="checkbox"] {
  width: 16px; height: 16px; flex-shrink: 0; margin-top: 2px;
  accent-color: #6366f1;
}
.agree-label a { color: #818cf8; text-decoration: none; }
.agree-label a:hover { text-decoration: underline; }

/* ── Nav buttons ── */
.form-nav {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 32px;
  padding-top: 24px;
  border-top: 1px solid rgba(255,255,255,.06);
}
.btn-back {
  display: flex; align-items: center; gap: 6px;
  background: transparent;
  border: 1px solid rgba(255,255,255,.1);
  border-radius: 10px;
  color: #9ca3af;
  font-size: 14px;
  font-weight: 500;
  padding: 10px 20px;
  cursor: pointer;
  transition: all .2s;
}
.btn-back:hover { border-color: rgba(255,255,255,.2); color: #e8eaed; }

.btn-next, .btn-submit {
  display: flex; align-items: center; gap: 8px;
  background: #6366f1;
  border: none;
  border-radius: 10px;
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  padding: 11px 28px;
  cursor: pointer;
  transition: background .2s, transform .1s;
}
.btn-next:hover, .btn-submit:hover { background: #4f46e5; transform: translateY(-1px); }
.btn-next:disabled, .btn-submit:disabled { opacity: .5; cursor: not-allowed; transform: none; }

.spinner {
  width: 14px; height: 14px;
  border: 2px solid rgba(255,255,255,.3);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin .7s linear infinite;
  display: inline-block;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* ── Transition ── */
.fade-slide-enter-active, .fade-slide-leave-active { transition: all .25s ease; }
.fade-slide-enter-from { opacity: 0; transform: translateX(16px); }
.fade-slide-leave-to   { opacity: 0; transform: translateX(-16px); }

/* ── Responsive ── */
@media (max-width: 600px) {
  .form-card { padding: 24px 16px; }
  .form-grid { grid-template-columns: 1fr; }
  .review-grid { grid-template-columns: 1fr; }
}

/* ── Input readonly ── */
.input-readonly {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: rgba(255,255,255,.03);
  border: 1px solid rgba(255,255,255,.07);
  border-radius: 10px;
  padding: 10px 14px;
  color: #6b7280;
  font-size: 14px;
  font-family: monospace;
  letter-spacing: .05em;
}

/* ── Download button ── */
.btn-download {
  display: flex;
  align-items: center;
  gap: 8px;
  background: rgba(99,102,241,.1);
  border: 1px solid rgba(99,102,241,.3);
  border-radius: 10px;
  color: #818cf8;
  font-size: 14px;
  font-weight: 500;
  padding: 10px 16px;
  cursor: pointer;
  transition: all .2s;
  width: 100%;
  justify-content: center;
}
.btn-download:hover {
  background: rgba(99,102,241,.2);
  border-color: rgba(99,102,241,.5);
}

/* ── Upload zone ── */
.upload-zone {
  border: 2px dashed rgba(255,255,255,.1);
  border-radius: 12px;
  padding: 32px 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  cursor: pointer;
  transition: all .2s;
  color: #4b5563;
  text-align: center;
  min-height: 120px;
}
.upload-zone:hover,
.upload-zone.is-dragover {
  border-color: rgba(99,102,241,.5);
  background: rgba(99,102,241,.05);
  color: #818cf8;
}
.upload-zone.is-uploaded {
  border-style: solid;
  border-color: rgba(74,222,128,.3);
  background: rgba(74,222,128,.05);
  flex-direction: row;
  gap: 12px;
  padding: 16px 20px;
  cursor: default;
}
.upload-zone.invalid { border-color: rgba(248,113,113,.5); }

.upload-text    { font-size: 14px; font-weight: 500; margin: 0; }
.upload-subtext { font-size: 12px; margin: 0; }
.upload-link    { color: #818cf8; text-decoration: underline; }

.upload-file-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
  flex: 1;
  text-align: left;
}
.upload-filename { font-size: 14px; font-weight: 500; color: #e8eaed; }
.upload-filesize { font-size: 12px; color: #4ade80; }

.upload-remove {
  background: rgba(255,255,255,.05);
  border: 1px solid rgba(255,255,255,.1);
  border-radius: 6px;
  color: #9ca3af;
  padding: 4px 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  transition: all .2s;
}
.upload-remove:hover { background: rgba(248,113,113,.15); border-color: #f87171; color: #f87171; }

.file-input-hidden { display: none; }
</style>
<template>
  <div class="pd-page">

    <!-- Back button -->
    <button class="back-btn" @click="router.back()">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <polyline points="15 18 9 12 15 6"/>
      </svg>
      Back
    </button>

    <!-- Error -->
    <div v-if="store.error" class="error-banner">{{ store.error }}</div>

    <!-- Loading skeleton -->
    <div v-if="store.loadingDetail" class="skeleton-detail">
      <div class="skel skel-title"></div>
      <div class="skel-grid">
        <div class="skel-card" v-for="i in 8" :key="i">
          <div class="skel skel-lbl"></div>
          <div class="skel skel-val"></div>
        </div>
      </div>
    </div>

    <!-- Real content -->
    <Transition name="fade-up">
    <div v-if="!store.loadingDetail && store.currentPayment" class="pd-content">

      <!-- Header row -->
      <div class="pd-header">
        <div>
          <div class="pd-ref">{{ store.currentPayment.reference_code ?? '—' }}</div>
          <h1 class="pd-title">{{ typeLabel[store.currentPayment.type] ?? store.currentPayment.type }}</h1>
        </div>
        <div class="pd-header-right">
          <span class="status-chip" :class="'status-' + store.currentPayment.status">
            <span class="status-dot"></span>
            {{ statusLabel[store.currentPayment.status] ?? store.currentPayment.status }}
          </span>
          <!-- Action buttons (only pending) -->
          <template v-if="store.currentPayment.status === 'pending'">
            <button class="btn btn-approve" :disabled="store.actionLoading" @click="handleApprove">
              ✓ Approve
            </button>
            <button class="btn btn-reject" :disabled="store.actionLoading" @click="handleReject">
              ✕ Reject
            </button>
          </template>
        </div>
      </div>

      <!-- ── Section: Financial ─────────────────────────── -->
      <div class="section">
        <div class="section-title">Financial</div>
        <div class="info-grid">
          <div class="info-item">
            <span class="info-label">Amount</span>
            <span class="info-value amount">{{ fmtVND(store.currentPayment.amount) }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">Fee</span>
            <span class="info-value">{{ fmtVND(store.currentPayment.fee) }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">Net Amount</span>
            <span class="info-value accent">{{ fmtVND(store.currentPayment.net_amount) }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">Currency</span>
            <span class="info-value">{{ store.currentPayment.currency }}</span>
          </div>
        </div>
      </div>

      <!-- ── Section: Party ─────────────────────────────── -->
      <div class="section">
        <div class="section-title">Party</div>
        <div class="info-grid">
          <div class="info-item">
            <span class="info-label">Partner</span>
            <span class="info-value">{{ store.currentPayment.partner_name ?? '—' }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">User</span>
            <span class="info-value">{{ store.currentPayment.user_name ?? '—' }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">Bank</span>
            <span class="info-value">{{ store.currentPayment.bank_name ?? '—' }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">Account Number</span>
            <span class="info-value mono">{{ store.currentPayment.bank_account_number ?? '—' }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">Account Name</span>
            <span class="info-value">{{ store.currentPayment.bank_account_name ?? '—' }}</span>
          </div>
        </div>
      </div>

      <!-- ── Section: Timeline ──────────────────────────── -->
      <div class="section">
        <div class="section-title">Timeline</div>
        <div class="info-grid">
          <div class="info-item">
            <span class="info-label">Requested At</span>
            <span class="info-value">{{ fmtDateFull(store.currentPayment.requested_at) }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">Processed At</span>
            <span class="info-value">{{ fmtDateFull(store.currentPayment.processed_at) }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">Created At</span>
            <span class="info-value">{{ fmtDateFull(store.currentPayment.created_at) }}</span>
          </div>
          <div class="info-item">
            <span class="info-label">Updated At</span>
            <span class="info-value">{{ fmtDateFull(store.currentPayment.updated_at) }}</span>
          </div>
        </div>
      </div>

      <!-- ── Section: Notes ─────────────────────────────── -->
      <div class="section" v-if="store.currentPayment.note || store.currentPayment.failure_reason">
        <div class="section-title">Notes</div>
        <div class="info-grid">
          <div class="info-item full" v-if="store.currentPayment.note">
            <span class="info-label">Note</span>
            <span class="info-value">{{ store.currentPayment.note }}</span>
          </div>
          <div class="info-item full" v-if="store.currentPayment.failure_reason">
            <span class="info-label">Failure Reason</span>
            <span class="info-value danger">{{ store.currentPayment.failure_reason }}</span>
          </div>
        </div>
      </div>

    </div>
    </Transition>

    <!-- Not found -->
    <div v-if="!store.loadingDetail && !store.currentPayment && !store.error" class="not-found">
      <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
      </svg>
      <p>Transaction not found</p>
    </div>

  </div>
</template>

<script setup lang="ts">
import { onMounted, onUnmounted, computed } from 'vue'
import { usePaymentStore } from '@/modules/admin/stores/payment/paymentStore'
import { useRoute } from 'vue-router'
import router from '@/modules/router'
import Swal from 'sweetalert2'

const props = defineProps<{ id?: string | number }>()
const route = useRoute()
const store = usePaymentStore()

// Lấy id từ props (khi dùng props:true) hoặc fallback sang route.params
// id có dạng "83_payment" hoặc "45_payout" — giữ nguyên string
const paymentId = computed<string | null>(() => {
  const raw = props.id ?? route.params.id
  if (!raw) return null
  const str = String(raw).trim()
  return str.length > 0 ? str : null
})

// ── Helpers ────────────────────────────────────────────────────────────────
const statusLabel: Record<string, string> = {
  pending: 'Pending', processing: 'Processing',
  completed: 'Completed', failed: 'Failed', cancelled: 'Cancelled',
}
const typeLabel: Record<string, string> = {
  partner_payout: 'Partner Payout', subscription: 'Subscription',
  ad_payment: 'Ad Payment', refund: 'Refund',
}

const fmtVND = (val: number | null | undefined): string => {
  if (val == null) return '—'
  return '₫' + Number(val).toLocaleString('vi-VN')
}
const fmtDateFull = (d: string | null | undefined): string => {
  if (!d) return '—'
  return new Date(d).toLocaleString('vi-VN')
}

// ── Actions ────────────────────────────────────────────────────────────────
const handleApprove = async () => {
  const { value: note } = await Swal.fire({
    title: 'Approve Payment',
    input: 'textarea', inputLabel: 'Note (optional)',
    showCancelButton: true,
    confirmButtonText: 'Approve', confirmButtonColor: '#10b981',
    cancelButtonColor: '#475569',
    background: '#181c22', color: '#f0f4f8',
  })
  if (note !== undefined) {
    try {
      await store.approve(paymentId.value!, note)
      Swal.fire({ title: 'Approved!', icon: 'success', background: '#181c22', color: '#f0f4f8', timer: 1500, showConfirmButton: false })
    } catch {
      Swal.fire({ title: 'Error', icon: 'error', background: '#181c22', color: '#f0f4f8' })
    }
  }
}

const handleReject = async () => {
  const { value: reason } = await Swal.fire({
    title: 'Reject Payment',
    input: 'textarea', inputLabel: 'Reason *',
    showCancelButton: true,
    confirmButtonText: 'Reject', confirmButtonColor: '#ef4444',
    cancelButtonColor: '#475569',
    background: '#181c22', color: '#f0f4f8',
    preConfirm: (v) => { if (!v.trim()) Swal.showValidationMessage('Required'); return v },
  })
  if (reason) {
    try {
      await store.reject(paymentId.value!, reason)
      Swal.fire({ title: 'Rejected!', icon: 'info', background: '#181c22', color: '#f0f4f8', timer: 1500, showConfirmButton: false })
    } catch {
      Swal.fire({ title: 'Error', icon: 'error', background: '#181c22', color: '#f0f4f8' })
    }
  }
}

// ── Lifecycle ──────────────────────────────────────────────────────────────
onMounted(() => {
  if (paymentId.value) {
    store.fetchById(paymentId.value)
  } else {
    store.error = 'Invalid payment ID'
  }
})
onUnmounted(() => store.clearCurrentPayment())
</script>

<style scoped>
.pd-page {
  padding: 28px 32px;
  min-height: 100vh;
  background: #0f1216;
  color: #e2e8f0;
  font-family: 'DM Sans', system-ui, sans-serif;
  font-size: 14px;
}

/* Back button */
.back-btn {
  display: inline-flex; align-items: center; gap: 6px;
  background: transparent; border: 1px solid #334155;
  color: #94a3b8; padding: 6px 14px; border-radius: 8px;
  font-size: 13px; cursor: pointer; margin-bottom: 20px;
  transition: all 0.2s;
}
.back-btn:hover { background: rgba(255,255,255,0.04); color: #fff; }

.error-banner {
  background: #3b0e0e; border: 1px solid #7f1d1d;
  color: #f87171; padding: 10px 16px; border-radius: 8px;
  margin-bottom: 16px; font-size: 13px;
}

/* Header */
.pd-header {
  display: flex; align-items: flex-start;
  justify-content: space-between; gap: 16px;
  margin-bottom: 24px; flex-wrap: wrap;
}
.pd-ref  { font-family: ui-monospace, monospace; font-size: 12px; color: #818cf8; margin-bottom: 4px; }
.pd-title { font-size: 20px; font-weight: 700; color: #f1f5f9; margin: 0; }
.pd-header-right { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }

.btn {
  padding: 8px 18px; border-radius: 8px; font-size: 13px;
  font-weight: 500; cursor: pointer; border: none; transition: opacity 0.15s;
}
.btn:disabled { opacity: 0.4; cursor: not-allowed; }
.btn-approve { background: rgba(16,185,129,0.15); color: #34d399; border: 1px solid rgba(16,185,129,0.3); }
.btn-approve:hover:not(:disabled) { background: rgba(16,185,129,0.25); }
.btn-reject  { background: rgba(239,68,68,0.15); color: #f87171; border: 1px solid rgba(239,68,68,0.3); }
.btn-reject:hover:not(:disabled) { background: rgba(239,68,68,0.25); }

/* Status chip */
.status-chip {
  display: inline-flex; align-items: center; gap: 5px;
  padding: 5px 12px; border-radius: 20px;
  font-size: 12px; font-weight: 600;
}
.status-dot { width: 5px; height: 5px; border-radius: 50%; background: currentColor; }
.status-pending    { background: rgba(245,158,11,0.12); color: #fbbf24; }
.status-processing { background: rgba(59,130,246,0.12); color: #60a5fa; }
.status-completed  { background: rgba(16,185,129,0.12); color: #34d399; }
.status-failed     { background: rgba(239,68,68,0.12);  color: #f87171; }
.status-cancelled  { background: rgba(100,116,139,0.12); color: #94a3b8; }

/* Content */
.pd-content { display: flex; flex-direction: column; gap: 20px; }

/* Sections */
.section {
  background: rgba(255,255,255,0.025);
  border: 1px solid rgba(255,255,255,0.07);
  border-radius: 12px; padding: 20px;
}
.section-title {
  font-size: 11px; font-weight: 600; color: #475569;
  text-transform: uppercase; letter-spacing: 0.07em;
  margin-bottom: 16px; padding-bottom: 8px;
  border-bottom: 1px solid rgba(255,255,255,0.06);
}
.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 12px;
}
.info-item {
  display: flex; flex-direction: column; gap: 5px;
  background: rgba(255,255,255,0.03);
  border: 1px solid rgba(255,255,255,0.05);
  border-radius: 8px; padding: 12px 14px;
}
.info-item.full { grid-column: 1 / -1; }
.info-label { font-size: 10px; color: #475569; text-transform: uppercase; letter-spacing: 0.05em; }
.info-value { font-size: 14px; color: #e2e8f0; font-weight: 500; }
.info-value.amount { font-size: 18px; font-weight: 700; color: #34d399; }
.info-value.accent { color: #818cf8; }
.info-value.mono   { font-family: ui-monospace, monospace; font-size: 13px; }
.info-value.danger { color: #f87171; }

/* Not found */
.not-found {
  text-align: center; padding: 80px 0; color: #475569;
  display: flex; flex-direction: column; align-items: center; gap: 16px;
}

/* Skeleton */
@keyframes shimmer {
  0%   { background-position: -600px 0; }
  100% { background-position:  600px 0; }
}
.skel {
  border-radius: 6px;
  background: linear-gradient(90deg,
    rgba(255,255,255,0.04) 25%, rgba(255,255,255,0.10) 50%, rgba(255,255,255,0.04) 75%);
  background-size: 600px 100%;
  animation: shimmer 1.6s infinite linear;
}
.skeleton-detail { display: flex; flex-direction: column; gap: 20px; }
.skel-title { width: 300px; height: 28px; border-radius: 8px; }
.skel-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 12px;
}
.skel-card {
  background: rgba(255,255,255,0.025); border-radius: 8px;
  border: 1px solid rgba(255,255,255,0.05); padding: 14px;
}
.skel-lbl { width: 70px; height: 10px; margin-bottom: 10px; }
.skel-val { width: 120px; height: 16px; }

/* Transition */
.fade-up-enter-active { transition: opacity 0.4s ease, transform 0.4s ease; }
.fade-up-enter-from   { opacity: 0; transform: translateY(12px); }

@media (max-width: 640px) {
  .pd-page { padding: 20px 16px; }
  .pd-header { flex-direction: column; }
}
</style>

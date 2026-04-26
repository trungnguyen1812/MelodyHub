<template>
  <div class="pm-page">

    <!-- ── Header ─────────────────────────────────────────── -->
    <div class="pm-header">
      <div>
        <h1 class="pm-title">Payment Management</h1>
        <p class="pm-subtitle">Track and manage all financial transactions</p>
      </div>
      <button class="btn btn-outline" @click="exportCSV">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/>
        </svg>
        Export CSV
      </button>
    </div>

    <!-- ── Error ───────────────────────────────────────────── -->
    <div v-if="store.error" class="error-banner">{{ store.error }}</div>

    <!-- ── Summary Cards ──────────────────────────────────── -->
    <div class="summary-grid">
      <!-- Skeleton -->
      <template v-if="store.loadingList && !store.summary">
        <div v-for="i in 4" :key="i" class="sum-card skel-card">
          <div class="skel skel-lbl"></div>
          <div class="skel skel-val"></div>
        </div>
      </template>
      <!-- Real -->
      <template v-else>
        <div class="sum-card sum-card--blue">
          <div class="sum-label">Total Transactions</div>
          <div class="sum-value">{{ store.summary?.total_payments ?? store.total }}</div>
        </div>
        <div class="sum-card sum-card--green">
          <div class="sum-label">Completed Amount</div>
          <div class="sum-value">{{ fmtVND(store.summary?.completed_amount ?? 0) }}</div>
        </div>
        <div class="sum-card sum-card--orange">
          <div class="sum-label">Pending Amount</div>
          <div class="sum-value">{{ fmtVND(store.summary?.pending_amount ?? 0) }}</div>
        </div>
        <div class="sum-card sum-card--purple">
          <div class="sum-label">This Month</div>
          <div class="sum-value">{{ fmtVND(store.summary?.this_month_amount ?? 0) }}</div>
        </div>
      </template>
    </div>

    <!-- ── Filters ─────────────────────────────────────────── -->
    <div class="filters-row">
      <div class="search-box">
        <svg class="search-icon" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
        </svg>
        <input v-model="filters.keyword" type="text" placeholder="Search by name, code..." @input="onSearch" />
      </div>
      <select v-model="filters.status" class="pm-select" @change="applyFilters">
        <option value="">All statuses</option>
        <option value="pending">Pending</option>
        <option value="processing">Processing</option>
        <option value="completed">Completed</option>
        <option value="failed">Failed</option>
        <option value="cancelled">Cancelled</option>
      </select>
      <select v-model="filters.type" class="pm-select" @change="applyFilters">
        <option value="">All types</option>
        <option value="partner_payout">Partner Payout</option>
        <option value="subscription">Subscription</option>
        <option value="ad_payment">Ad Payment</option>
        <option value="refund">Refund</option>
      </select>
      <input v-model="filters.date_from" type="date" class="pm-select" @change="applyFilters" />
      <input v-model="filters.date_to"   type="date" class="pm-select" @change="applyFilters" />
    </div>

    <!-- ── Table ───────────────────────────────────────────── -->
    <div class="table-card">

      <!-- Skeleton rows -->
      <div v-if="store.loadingList" class="skel-table">
        <div class="skel-thead">
          <div class="skel skel-th" v-for="c in 7" :key="c"></div>
        </div>
        <div v-for="r in 10" :key="r" class="skel-row">
          <div class="skel-td"><div class="skel skel-cell"></div></div>
          <div class="skel-td"><div class="skel skel-cell wide"></div></div>
          <div class="skel-td"><div class="skel skel-badge"></div></div>
          <div class="skel-td"><div class="skel skel-cell"></div></div>
          <div class="skel-td"><div class="skel skel-cell"></div></div>
          <div class="skel-td"><div class="skel skel-cell"></div></div>
          <div class="skel-td"><div class="skel skel-actions"></div></div>
        </div>
        <div class="table-progress-bar"><div class="table-progress-fill"></div></div>
      </div>

      <!-- Real table -->
      <div v-show="!store.loadingList" class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>#</th>
              <th>Reference</th>
              <th>Type</th>
              <th>Partner / User</th>
              <th>Status</th>
              <th>Amount</th>
              <th>Date</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(p, idx) in store.payments" :key="p.id">
              <td class="muted">{{ (store.currentPage - 1) * store.perPage + idx + 1 }}</td>
              <td>
                <span class="ref-code">{{ p.reference_code ?? '—' }}</span>
              </td>
              <td><span class="type-badge" :class="'type-' + p.type">{{ typeLabel[p.type] ?? p.type }}</span></td>
              <td>
                <div class="person-cell">
                  <div class="avatar-initial">{{ initial(p.partner_name || p.user_name) }}</div>
                  <div>
                    <div class="person-name">{{ p.partner_name || p.user_name || '—' }}</div>
                    <div class="person-sub muted">{{ p.bank_name ?? '' }}</div>
                  </div>
                </div>
              </td>
              <td>
                <span class="status-chip" :class="'status-' + p.status">
                  <span class="status-dot"></span>
                  {{ statusLabel[p.status] ?? p.status }}
                </span>
              </td>
              <td class="amount-cell">{{ fmtVND(p.amount) }}</td>
              <td class="muted date-cell">{{ fmtDate(p.created_at) }}</td>
              <td>
                <div class="action-btns">
                  <button class="act-btn act-btn--view" title="View detail" @click="viewDetail(p.id)">
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                    </svg>
                  </button>
                  <button
                    v-if="p.status === 'pending'"
                    class="act-btn act-btn--approve"
                    title="Approve"
                    :disabled="store.actionLoading"
                    @click="handleApprove(p.id)"
                  >
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <polyline points="20 6 9 17 4 12"/>
                    </svg>
                  </button>
                  <button
                    v-if="p.status === 'pending'"
                    class="act-btn act-btn--reject"
                    title="Reject"
                    :disabled="store.actionLoading"
                    @click="handleReject(p.id)"
                  >
                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
            <tr v-if="!store.loadingList && store.payments.length === 0">
              <td colspan="8" class="empty-row">No transactions found</td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <div class="pagination" v-if="store.total > 0">
        <span class="page-info">
          Showing {{ pageStart }}–{{ pageEnd }} of {{ store.total }} transactions
        </span>
        <div class="page-btns">
          <button class="page-btn" :disabled="store.currentPage === 1" @click="goPage(store.currentPage - 1)">‹</button>
          <button
            v-for="p in pageNumbers"
            :key="p"
            class="page-btn"
            :class="{ active: p === store.currentPage }"
            @click="goPage(p)"
          >{{ p }}</button>
          <button class="page-btn" :disabled="store.currentPage === store.lastPage" @click="goPage(store.currentPage + 1)">›</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { usePaymentStore } from '@/modules/admin/stores/payment/paymentStore'
import router from '@/modules/router'
import Swal from 'sweetalert2'

const store = usePaymentStore()

// ── Filters ────────────────────────────────────────────────────────────────
const filters = ref({
  keyword: '',
  status: '',
  type: '',
  date_from: '',
  date_to: '',
  page: 1,
  per_page: 15,
})

let searchTimer: ReturnType<typeof setTimeout> | null = null

const onSearch = () => {
  if (searchTimer) clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {
    filters.value.page = 1
    applyFilters()
  }, 300)
}

const applyFilters = () => {
  const params: Record<string, any> = { ...filters.value }
  // strip empty strings
  Object.keys(params).forEach(k => { if (params[k] === '') delete params[k] })
  store.fetchAll(params)
}

// ── Pagination ─────────────────────────────────────────────────────────────
const pageStart   = computed(() => store.total === 0 ? 0 : (store.currentPage - 1) * store.perPage + 1)
const pageEnd     = computed(() => Math.min(store.currentPage * store.perPage, store.total))
const pageNumbers = computed(() => {
  const pages: number[] = []
  const start = Math.max(1, store.currentPage - 2)
  const end   = Math.min(store.lastPage, store.currentPage + 2)
  for (let i = start; i <= end; i++) pages.push(i)
  return pages
})

const goPage = (p: number) => {
  filters.value.page = p
  applyFilters()
}

// ── Actions ────────────────────────────────────────────────────────────────
const viewDetail = (id: number) => router.push({ name: 'admin.payment.detail', params: { id } })

const handleApprove = async (id: number) => {
  const { value: note } = await Swal.fire({
    title: 'Approve Payment',
    input: 'textarea',
    inputLabel: 'Note (optional)',
    inputPlaceholder: 'Enter a note...',
    showCancelButton: true,
    confirmButtonText: 'Approve',
    confirmButtonColor: '#10b981',
    cancelButtonColor: '#475569',
    background: '#181c22',
    color: '#f0f4f8',
  })
  if (note !== undefined) {
    try {
      await store.approve(id, note)
      Swal.fire({ title: 'Approved!', icon: 'success', background: '#181c22', color: '#f0f4f8', timer: 1500, showConfirmButton: false })
    } catch {
      Swal.fire({ title: 'Error', icon: 'error', background: '#181c22', color: '#f0f4f8' })
    }
  }
}

const handleReject = async (id: number) => {
  const { value: reason } = await Swal.fire({
    title: 'Reject Payment',
    input: 'textarea',
    inputLabel: 'Reason *',
    inputPlaceholder: 'Enter rejection reason...',
    showCancelButton: true,
    confirmButtonText: 'Reject',
    confirmButtonColor: '#ef4444',
    cancelButtonColor: '#475569',
    background: '#181c22',
    color: '#f0f4f8',
    preConfirm: (val) => {
      if (!val.trim()) Swal.showValidationMessage('Reason is required')
      return val
    },
  })
  if (reason) {
    try {
      await store.reject(id, reason)
      Swal.fire({ title: 'Rejected!', icon: 'info', background: '#181c22', color: '#f0f4f8', timer: 1500, showConfirmButton: false })
    } catch {
      Swal.fire({ title: 'Error', icon: 'error', background: '#181c22', color: '#f0f4f8' })
    }
  }
}

const exportCSV = async () => {
  try {
    const { default: svc } = await import('@/modules/admin/services/payment/payment.service')
    const blob = await svc.export('csv', filters.value as any)
    const url  = URL.createObjectURL(blob)
    const a    = document.createElement('a')
    a.href = url; a.download = 'payments.csv'; a.click()
    URL.revokeObjectURL(url)
  } catch {
    Swal.fire({ title: 'Export failed', icon: 'error', background: '#181c22', color: '#f0f4f8' })
  }
}

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

const fmtDate = (d: string | null | undefined): string => {
  if (!d) return '—'
  return new Date(d).toLocaleDateString('vi-VN')
}

const initial = (name: string | null | undefined): string =>
  (name ?? '?').trim().charAt(0).toUpperCase()

// ── Mount ──────────────────────────────────────────────────────────────────
onMounted(() => store.fetchAll())
</script>

<style scoped>
/* ── Base ─────────────────────────────────────────────── */
.pm-page {
  padding: 28px 32px;
  min-height: 100vh;
  background: #0f1216;
  color: #e2e8f0;
  font-family: 'DM Sans', system-ui, sans-serif;
  font-size: 14px;
}

/* ── Header ───────────────────────────────────────────── */
.pm-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 24px;
}
.pm-title {
  font-size: 22px;
  font-weight: 700;
  margin: 0;
  background: linear-gradient(90deg, #fff 30%, #00aaff);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.pm-subtitle { font-size: 12px; color: #64748b; margin-top: 3px; }

.btn {
  display: flex; align-items: center; gap: 7px;
  padding: 8px 16px; border-radius: 8px;
  font-size: 13px; font-weight: 500; cursor: pointer;
  border: none; transition: opacity 0.15s;
}
.btn-outline {
  background: transparent;
  border: 1px solid #334155;
  color: #94a3b8;
}
.btn-outline:hover { opacity: 0.8; }

.error-banner {
  background: #3b0e0e; border: 1px solid #7f1d1d;
  color: #f87171; padding: 10px 16px; border-radius: 8px;
  margin-bottom: 16px; font-size: 13px;
}

/* ── Summary Cards ────────────────────────────────────── */
.summary-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 20px;
}
.sum-card {
  background: rgba(255,255,255,0.03);
  border: 1px solid rgba(255,255,255,0.06);
  border-radius: 12px;
  padding: 20px;
  border-top: 3px solid transparent;
  transition: transform 0.2s;
}
.sum-card:hover { transform: translateY(-3px); }
.sum-card--blue   { border-top-color: #3b82f6; }
.sum-card--green  { border-top-color: #10b981; }
.sum-card--orange { border-top-color: #f59e0b; }
.sum-card--purple { border-top-color: #8b5cf6; }
.sum-label { font-size: 11px; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 8px; }
.sum-value { font-size: 24px; font-weight: 700; color: #f1f5f9; }

/* ── Filters ──────────────────────────────────────────── */
.filters-row {
  display: flex; gap: 10px; align-items: center;
  flex-wrap: wrap; margin-bottom: 16px;
}
.search-box {
  position: relative; display: flex; align-items: center;
}
.search-icon { position: absolute; left: 10px; color: #475569; pointer-events: none; }
.search-box input {
  background: #181c22; border: 1px solid #2d3748; border-radius: 8px;
  padding: 8px 12px 8px 32px; color: #e2e8f0;
  font-size: 13px; width: 240px; outline: none;
  transition: border-color 0.2s;
}
.search-box input:focus { border-color: #3b82f6; }
.pm-select {
  background: #181c22; border: 1px solid #2d3748; border-radius: 8px;
  padding: 8px 12px; color: #94a3b8; font-size: 13px;
  outline: none; cursor: pointer;
}
.pm-select:focus { border-color: #3b82f6; }

/* ── Table Card ───────────────────────────────────────── */
.table-card {
  background: #111418;
  border: 1px solid #1e2530;
  border-radius: 14px;
  overflow: hidden;
  position: relative;
}
.table-wrap { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; font-size: 13px; }
thead tr { background: #1e2530; border-bottom: 1px solid #252d3a; }
th {
  padding: 11px 16px; text-align: left;
  font-size: 11px; font-weight: 600;
  color: #94a3b8; text-transform: uppercase;
  letter-spacing: 0.05em; white-space: nowrap;
}
td { padding: 12px 16px; border-bottom: 1px solid #1a2030; vertical-align: middle; }
tr:last-child td { border-bottom: none; }
tr:hover td { background: rgba(255,255,255,0.02); }

/* Cells */
.muted   { color: #64748b; }
.ref-code { font-family: ui-monospace, monospace; font-size: 12px; color: #818cf8; }
.date-cell { font-size: 12px; white-space: nowrap; }
.amount-cell { font-weight: 600; color: #34d399; white-space: nowrap; }
.empty-row { text-align: center; color: #475569; padding: 40px; }

/* Person cell */
.person-cell { display: flex; align-items: center; gap: 10px; }
.avatar-initial {
  width: 32px; height: 32px; border-radius: 8px;
  background: #1e2530; display: flex; align-items: center;
  justify-content: center; font-size: 12px; font-weight: 600;
  color: #818cf8; flex-shrink: 0;
}
.person-name { font-weight: 500; color: #e2e8f0; }
.person-sub  { font-size: 11px; }

/* Status chip */
.status-chip {
  display: inline-flex; align-items: center; gap: 5px;
  padding: 3px 10px; border-radius: 20px;
  font-size: 11px; font-weight: 600; white-space: nowrap;
}
.status-dot { width: 5px; height: 5px; border-radius: 50%; background: currentColor; }
.status-pending    { background: rgba(245,158,11,0.12); color: #fbbf24; }
.status-processing { background: rgba(59,130,246,0.12); color: #60a5fa; }
.status-completed  { background: rgba(16,185,129,0.12); color: #34d399; }
.status-failed     { background: rgba(239,68,68,0.12);  color: #f87171; }
.status-cancelled  { background: rgba(100,116,139,0.12); color: #94a3b8; }

/* Type badge */
.type-badge {
  display: inline-block; padding: 2px 9px; border-radius: 5px;
  font-size: 11px; font-weight: 500; white-space: nowrap;
}
.type-partner_payout { background: rgba(99,102,241,0.15); color: #818cf8; }
.type-subscription   { background: rgba(16,185,129,0.15); color: #34d399; }
.type-ad_payment     { background: rgba(245,158,11,0.15); color: #fbbf24; }
.type-refund         { background: rgba(239,68,68,0.15);  color: #f87171; }

/* Action buttons */
.action-btns { display: flex; gap: 6px; }
.act-btn {
  width: 28px; height: 28px; display: flex;
  align-items: center; justify-content: center;
  border-radius: 7px; background: #1e2530;
  border: 1px solid #2d3748; color: #64748b;
  cursor: pointer; transition: all 0.2s;
}
.act-btn:hover     { color: #f1f5f9; border-color: #4a5568; }
.act-btn:disabled  { opacity: 0.3; cursor: not-allowed; }
.act-btn--view:hover    { color: #60a5fa; border-color: #3b82f6; background: rgba(59,130,246,0.08); }
.act-btn--approve:hover { color: #34d399; border-color: #10b981; background: rgba(16,185,129,0.08); }
.act-btn--reject:hover  { color: #f87171; border-color: #ef4444; background: rgba(239,68,68,0.08); }

/* Pagination */
.pagination {
  display: flex; align-items: center; justify-content: space-between;
  padding: 12px 20px; border-top: 1px solid #1e2530;
}
.page-info { font-size: 12px; color: #475569; }
.page-btns { display: flex; gap: 5px; }
.page-btn {
  min-width: 32px; height: 32px; padding: 0 8px;
  display: flex; align-items: center; justify-content: center;
  border-radius: 7px; background: #181c22;
  border: 1px solid #2d3748; color: #64748b;
  cursor: pointer; font-size: 13px; transition: all 0.2s;
}
.page-btn:hover:not(:disabled) { border-color: #3b82f6; color: #3b82f6; }
.page-btn.active { background: #3b82f6; border-color: #3b82f6; color: #fff; }
.page-btn:disabled { opacity: 0.35; cursor: not-allowed; }

/* ── Skeleton ─────────────────────────────────────────── */
@keyframes shimmer {
  0%   { background-position: -600px 0; }
  100% { background-position:  600px 0; }
}
.skel {
  border-radius: 5px;
  background: linear-gradient(90deg,
    rgba(255,255,255,0.04) 25%,
    rgba(255,255,255,0.10) 50%,
    rgba(255,255,255,0.04) 75%);
  background-size: 600px 100%;
  animation: shimmer 1.6s infinite linear;
}
.skel-card { border-top-color: rgba(255,255,255,0.05) !important; }
.skel-lbl { width: 80px; height: 10px; margin-bottom: 12px; }
.skel-val { width: 120px; height: 24px; border-radius: 6px; }

.skel-table { padding: 0; }
.skel-thead {
  display: flex; gap: 12px; padding: 12px 16px;
  background: #1e2530; border-bottom: 1px solid #252d3a;
}
.skel-th { flex: 1; height: 10px; border-radius: 4px; }
.skel-row { display: flex; align-items: center; border-bottom: 1px solid #1a2030; }
.skel-td  { flex: 1; padding: 14px 16px; }
.skel-cell { width: 80px; height: 11px; }
.skel-cell.wide { width: 130px; }
.skel-badge { width: 70px; height: 22px; border-radius: 20px; }
.skel-actions { width: 60px; height: 24px; border-radius: 7px; }

.table-progress-bar {
  position: absolute; top: 0; left: 0; right: 0;
  height: 3px; background: rgba(59,130,246,0.15); overflow: hidden; z-index: 10;
}
.table-progress-fill {
  height: 100%; width: 40%;
  background: linear-gradient(90deg, #3b82f6, #60a5fa, #3b82f6);
  animation: progress-slide 1.8s infinite ease-in-out;
}
@keyframes progress-slide {
  0%   { transform: translateX(-150%); }
  100% { transform: translateX(400%); }
}

@media (max-width: 900px) {
  .summary-grid { grid-template-columns: repeat(2,1fr); }
  .pm-header { flex-direction: column; align-items: flex-start; gap: 12px; }
}
@media (max-width: 600px) {
  .summary-grid { grid-template-columns: 1fr; }
}
</style>

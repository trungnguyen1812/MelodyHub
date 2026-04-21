<template>
    <div class="partner-detail">
        <div class="container">
            <!-- Header -->
            <div class="header">
                <div class="header-left">
                    <button class="back-btn" @click="goBack">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="15 18 9 12 15 6" />
                        </svg>
                        Back
                    </button>
                    <h1 class="title">Partner Details</h1>
                </div>
                <div class="header-right">
                    <span class="status-badge" :class="`status--${partner?.status}`">
                        <span class="status-dot"></span>
                        {{ formatStatus(partner?.status) }}
                    </span>
                </div>
            </div>

            <div v-if="loading" class="loading-state">
                <div class="spinner"></div>
                <p>Loading partner details...</p>
            </div>

            <div v-else-if="partner" class="detail-content">
                <!-- Company Information -->
                <div class="detail-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z" />
                                <polyline points="17 21 17 13 7 13 7 21" />
                                <polyline points="7 3 7 8 15 8" />
                            </svg>
                            Company Information
                        </h2>
                    </div>
                    <div class="card-body">
                        <div class="info-row">
                            <div class="info-label">Company Name</div>
                            <div class="info-value">{{ partner.company_name || '—' }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Company Email</div>
                            <div class="info-value">{{ partner.company_email || '—' }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Company Phone</div>
                            <div class="info-value">{{ partner.company_phone || '—' }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Company Address</div>
                            <div class="info-value">{{ partner.company_address || '—' }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Tax Code</div>
                            <div class="info-value">{{ partner.tax_code || '—' }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Website</div>
                            <div class="info-value">
                                <a v-if="partner.website" :href="partner.website" target="_blank" class="link">
                                    {{ partner.website }}
                                </a>
                                <span v-else>—</span>
                            </div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Partner Type</div>
                            <div class="info-value">{{ partner.partner_type?.name || '—' }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Description</div>
                            <div class="info-value">{{ partner.description || '—' }}</div>
                        </div>
                    </div>
                </div>

                <!-- Contract Information -->
                <div class="detail-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                                <polyline points="14 2 14 8 20 8" />
                                <line x1="16" y1="13" x2="8" y2="13" />
                                <line x1="16" y1="17" x2="8" y2="17" />
                                <polyline points="10 9 9 9 8 9" />
                            </svg>
                            Contract Information
                        </h2>
                    </div>
                    <div class="card-body">
                        <div class="info-row">
                            <div class="info-label">Contract Number</div>
                            <div class="info-value">{{ partner.contract_number || '—' }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Start Date</div>
                            <div class="info-value">{{ formatDate(partner.contract_start_date) }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">End Date</div>
                            <div class="info-value">{{ formatDate(partner.contract_end_date) }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Revenue Share</div>
                            <div class="info-value">{{ partner.revenue_share_percentage }}%</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Payment Frequency</div>
                            <div class="info-value">{{ partner.payment_frequency || '—' }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Payment Threshold</div>
                            <div class="info-value">{{ formatCurrency(partner.payment_threshold) }}</div>
                        </div>
                        <div class="info-row" v-if="partner.contract_file_url">
                            <div class="info-label">Contract File</div>
                            <div class="info-value">
                                <a :href="partner.contract_file_url" target="_blank" class="link download-link">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                        <polyline points="7 10 12 15 17 10" />
                                        <line x1="12" y1="15" x2="12" y2="3" />
                                    </svg>
                                    Download Contract
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bank Information -->
                <div class="detail-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <rect x="2" y="6" width="20" height="16" rx="2" />
                                <line x1="2" y1="10" x2="22" y2="10" />
                                <line x1="6" y1="14" x2="6" y2="14" />
                                <line x1="12" y1="14" x2="12" y2="14" />
                                <line x1="18" y1="14" x2="18" y2="14" />
                            </svg>
                            Bank Information
                        </h2>
                    </div>
                    <div class="card-body">
                        <div class="info-row">
                            <div class="info-label">Bank Name</div>
                            <div class="info-value">{{ partner.bank_name || '—' }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Bank Branch</div>
                            <div class="info-value">{{ partner.bank_branch || '—' }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Account Number</div>
                            <div class="info-value">{{ partner.bank_account_number || '—' }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Account Name</div>
                            <div class="info-value">{{ partner.bank_account_name || '—' }}</div>
                        </div>
                    </div>
                </div>

                <!-- User Information -->
                <div class="detail-card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                <circle cx="12" cy="7" r="4" />
                            </svg>
                            User Information
                        </h2>
                    </div>
                    <div class="card-body">
                        <div class="info-row">
                            <div class="info-label">User Name</div>
                            <div class="info-value">{{ partner.user?.name || '—' }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">User Email</div>
                            <div class="info-value">{{ partner.user?.email || '—' }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Phone</div>
                            <div class="info-value">{{ partner.user?.phone || '—' }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Registered Date</div>
                            <div class="info-value">{{ formatDate(partner.created_at) }}</div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Verified At</div>
                            <div class="info-value">{{ formatDate(partner.verified_at) || 'Not verified' }}</div>
                        </div>
                    </div>
                </div>

                <!-- Statistics -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon">🎵</div>
                        <div class="stat-info">
                            <span class="stat-value">{{ partner.total_songs || 0 }}</span>
                            <span class="stat-label">Total Songs</span>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">🎤</div>
                        <div class="stat-info">
                            <span class="stat-value">{{ partner.total_artists || 0 }}</span>
                            <span class="stat-label">Total Artists</span>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">💿</div>
                        <div class="stat-info">
                            <span class="stat-value">{{ partner.total_albums || 0 }}</span>
                            <span class="stat-label">Total Albums</span>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon">💰</div>
                        <div class="stat-info">
                            <span class="stat-value">{{ formatCurrency(partner.total_revenue) }}</span>
                            <span class="stat-label">Total Revenue</span>
                        </div>
                    </div>
                </div>

                <!-- Actions -->
                <div class="action-buttons">
                    <button class="action-btn" @click="changeStatus">
                        Change Status
                    </button>
                </div>
            </div>

            <div v-else class="empty-state">
                <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                    <circle cx="12" cy="7" r="4" />
                </svg>
                <p>Partner not found</p>
                <button class="back-home-btn" @click="goBack">Go Back</button>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { usePartnerStore } from '@/modules/admin/stores/partners/partnersStore'
import { useNotificationStore } from '@/store/notificationStore'
import Swal from 'sweetalert2'

const router = useRouter()
const route = useRoute()
const partnerStore = usePartnerStore()
const notificationStore = useNotificationStore()

const partner = ref<any>(null)
const loading = ref(true)

const formatStatus = (status: string) => {
    const statusMap: Record<string, string> = {
        'active': 'Active',
        'pending': 'Pending',
        'suspended': 'Suspended',
        'terminated': 'Terminated'
    }
    return statusMap[status] || status
}

const formatDate = (date: string | null) => {
    if (!date) return '—'
    return new Date(date).toLocaleDateString('vi-VN')
}

const formatCurrency = (n: number) => {
    if (!n) return '0 ₫'
    if (n >= 1_000_000_000) return (n / 1_000_000_000).toFixed(2) + 'B ₫'
    if (n >= 1_000_000) return (n / 1_000_000).toFixed(1) + 'M ₫'
    if (n >= 1_000) return (n / 1_000).toFixed(0) + 'K ₫'
    return n.toLocaleString() + ' ₫'
}

const goBack = () => {
    router.push({ name: 'admin.partnersmanager' })
}

const changeStatus = async () => {
    const statusOptions = {
        'active': 'Active',
        'pending': 'Pending',
        'suspended': 'Suspended',
        'terminated': 'Terminated'
    }

    const { value: newStatus } = await Swal.fire({
        title: 'Change Partner Status',
        html: `Current status: <strong>${partner.value.status}</strong>`,
        input: 'select',
        inputOptions: statusOptions,
        inputValue: partner.value.status,
        showCancelButton: true,
        confirmButtonText: 'Update',
        confirmButtonColor: '#3b82f6',
        cancelButtonText: 'Cancel',
        background: '#181c22',
        color: '#f0f4f8'
    })

    if (newStatus && newStatus !== partner.value.status) {
        try {
            loading.value = true
            await partnerStore.updatePartnerStatus(partner.value.id, newStatus)
            await fetchPartnerDetail()
            notificationStore.notify(`Status changed to ${newStatus} successfully`, 'success')
        } catch (error: any) {
            notificationStore.notify(error?.message || 'Error changing status', 'error')
        } finally {
            loading.value = false
        }
    }
}

const fetchPartnerDetail = async () => {
    try {
        loading.value = true
        const id = Number(route.params.id)
        const response = await partnerStore.fetchPartnerDetail(id)
        partner.value = response
    } catch (error) {
        notificationStore.notify('Failed to load partner details', 'error')
    } finally {
        loading.value = false
    }
}

onMounted(() => {
    fetchPartnerDetail()
})
</script>

<style scoped>
.partner-detail {
    background-color: #0f1216;
    min-height: 100vh;
    padding: 32px 36px;
    font-family: 'DM Sans', system-ui, sans-serif;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
}

/* Header */
.header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 32px;
}

.header-left {
    display: flex;
    align-items: center;
    gap: 16px;
}

.back-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 10px;
    padding: 8px 16px;
    color: #94a3b8;
    cursor: pointer;
    transition: all 0.2s;
}

.back-btn:hover {
    background: rgba(255, 255, 255, 0.1);
    color: #e2e8f0;
}

.title {
    font-size: 24px;
    font-weight: 700;
    background: linear-gradient(90deg, #fff 30%, #00aaff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin: 0;
}

/* Status Badge */
.status-badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    text-transform: capitalize;
}

.status--active {
    background: rgba(16, 185, 129, 0.1);
    color: #34d399;
}

.status--pending {
    background: rgba(245, 158, 11, 0.1);
    color: #fbbf24;
}

.status--suspended {
    background: rgba(239, 68, 68, 0.1);
    color: #f87171;
}

.status--terminated {
    background: rgba(100, 116, 139, 0.1);
    color: #94a3b8;
}

.status-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: currentColor;
}

/* Cards */
.detail-card {
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 16px;
    margin-bottom: 24px;
    overflow: hidden;
}

.card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 20px 24px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.card-title {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 18px;
    font-weight: 600;
    color: #f1f5f9;
    margin: 0;
}

.edit-btn {
    display: flex;
    align-items: center;
    gap: 6px;
    background: transparent;
    border: 1px solid rgba(59, 130, 246, 0.3);
    border-radius: 8px;
    padding: 6px 12px;
    color: #3b82f6;
    font-size: 12px;
    cursor: pointer;
    transition: all 0.2s;
}

.edit-btn:hover {
    background: rgba(59, 130, 246, 0.1);
}

.card-body {
    padding: 24px;
}

.info-row {
    display: flex;
    padding: 12px 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.03);
}

.info-row:last-child {
    border-bottom: none;
}

.info-label {
    width: 160px;
    font-size: 13px;
    font-weight: 500;
    color: #64748b;
}

.info-value {
    flex: 1;
    font-size: 13px;
    color: #e2e8f0;
}

.link {
    color: #3b82f6;
    text-decoration: none;
}

.link:hover {
    text-decoration: underline;
}

.download-link {
    display: inline-flex;
    align-items: center;
    gap: 6px;
}

/* Stats Grid */
.stats-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 20px;
    margin-bottom: 24px;
}

.stat-card {
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 16px;
    padding: 20px;
    display: flex;
    align-items: center;
    gap: 16px;
}

.stat-icon {
    font-size: 32px;
}

.stat-info {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.stat-value {
    font-size: 24px;
    font-weight: 700;
    color: #f1f5f9;
}

.stat-label {
    font-size: 12px;
    color: #64748b;
}

/* Action Buttons */
.action-buttons {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    margin-top: 24px;
}

.action-btn {
    padding: 10px 20px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
    background: linear-gradient(90deg, #3b82f6, #2563eb);
    border: none;
    color: white;
}

.action-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}

/* Loading & Empty States */
.loading-state,
.empty-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 400px;
    gap: 16px;
}

.spinner {
    width: 40px;
    height: 40px;
    border: 3px solid rgba(255, 255, 255, 0.1);
    border-top-color: #3b82f6;
    border-radius: 50%;
    animation: spin 1s linear infinite;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

.empty-state svg {
    color: #64748b;
}

.empty-state p {
    color: #94a3b8;
}

.back-home-btn {
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 8px;
    padding: 8px 16px;
    color: #e2e8f0;
    cursor: pointer;
}

/* Responsive */
@media (max-width: 768px) {
    .partner-detail {
        padding: 20px 16px;
    }

    .stats-grid {
        grid-template-columns: repeat(2, 1fr);
    }

    .info-row {
        flex-direction: column;
        gap: 4px;
    }

    .info-label {
        width: 100%;
    }
}
</style>
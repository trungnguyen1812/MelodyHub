<template>
  <div class="adv-dashboard">
    <div class="bg-grid" aria-hidden="true"></div>

    <!-- Header -->
    <div class="header">
      <div class="header-left">
        <h1 class="title">Advertising Dashboard</h1>
        <p class="subtitle">Manages all advertising campaigns from {{ partnerStore.companyName }}</p>
      </div>
      <div class="header-right">
        <!-- Wallet Widget -->
        <div class="wallet-widget" :class="{ 'wallet-widget--low': walletBalance < 50 }">
          <button class="topup-reload-btn" @click="refreshBalance" :disabled="isRefreshing">
            <svg 
              width="18" 
              height="18" 
              viewBox="0 0 24 24" 
              fill="none" 
              stroke="currentColor" 
              stroke-width="2.5"
              :class="{ spinning: isRefreshing }"
            >
              <path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"/>
              <path d="M21 3v5h-5M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 0-6.74-2.74L3 16"/>
              <path d="M3 21v-5h5"/>
            </svg>
          </button>
          <div class="wallet-widget__icon">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
              <path d="M21 12V7H5a2 2 0 0 1 0-4h14v4"/>
              <path d="M3 5v14a2 2 0 0 0 2 2h16v-5"/>
              <path d="M18 12a2 2 0 0 0 0 4h4v-4z"/>
            </svg>
          </div>
          <div class="wallet-widget__body">
            <span class="wallet-widget__label">Wallet</span>
            <span class="wallet-widget__amount">${{ walletBalance.toFixed(2) }}</span>
          </div>
          <div v-if="walletBalance < 50" class="wallet-widget__low-dot" title="Low balance"></div>
          <button class="wallet-widget__topup" @click="showTopUpModal = true">
            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            Top Up
          </button>
        </div>

        <button class="btn-add" @click="ViewAddCampaign">
          <span class="btn-icon">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <circle cx="12" cy="12" r="10"/>
              <line x1="12" y1="8" x2="12" y2="16"/>
              <line x1="8" y1="12" x2="16" y2="12"/>
            </svg>
          </span>
          New Campaign
        </button>
      </div>
    </div>

    <!-- Stat Cards -->
    <div class="stats-grid">
      <div class="stat-card stat-card--blue">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <rect x="2" y="3" width="20" height="14" rx="2"/>
            <path d="M8 21h8M12 17v4"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Total Campaigns</span>
          <span class="stat-value">{{ stats.totalCampaigns }}</span>
          <span class="stat-change positive">↑ 12% from last month</span>
        </div>
      </div>

      <div class="stat-card stat-card--green">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
            <circle cx="12" cy="12" r="3"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Total Impressions</span>
          <span class="stat-value">{{ formatNumber(stats.totalImpressions) }}</span>
          <span class="stat-change positive">↑ 8% from last month</span>
        </div>
      </div>

      <div class="stat-card stat-card--purple">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Click Rate (CTR)</span>
          <span class="stat-value">{{ stats.ctr }}%</span>
          <span class="stat-change positive">↑ 3% from last month</span>
        </div>
      </div>

      <div class="stat-card stat-card--orange">
        <div class="stat-icon">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
            <line x1="12" y1="1" x2="12" y2="23"/>
            <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>
          </svg>
        </div>
        <div class="stat-info">
          <span class="stat-label">Total Revenue</span>
          <!-- <span class="stat-value">${{ formatNumber(stats.totalRevenue) }}</span> -->
          <span class="stat-change positive">↑ 20% from last month</span>
        </div>
      </div>
    </div>

    <!-- Campaigns Table -->
    <div class="songs-list-page">

      <!-- Toolbar -->
      <div class="toolbar">
        <div class="toolbar__left">
          <div class="search-box">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="search-icon">
              <circle cx="11" cy="11" r="8"/>
              <line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <input v-model="searchQuery" type="text" placeholder="Search campaigns..." @input="onSearchInput"/>
            <button v-if="searchQuery" class="search-clear" @click="searchQuery = ''">
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
              </svg>
            </button>
          </div>

          <select v-model="selectedStatus" class="filter-select" @change="onFilterChange">
            <option value="">All Status</option>
            <option value="active">Active</option>
            <option value="paused">Paused</option>
            <option value="ended">Ended</option>
            <option value="draft">Draft</option>
          </select>

          <select v-model="selectedType" class="filter-select" @change="onFilterChange">
            <option value="">All Types</option>
            <option value="banner">Banner</option>
            <option value="audio">Audio</option>
            <option value="video">Video</option>
          </select>
        </div>

        <div class="toolbar__right">
          <button class="btn-reload" @click="handleReload" :disabled="isReloading">
            <svg
              class="reload-icon"
              :class="{ spinning: isReloading }"
              xmlns="http://www.w3.org/2000/svg"
              width="16" height="16"
              viewBox="0 0 24 24"
              fill="none" stroke="currentColor" stroke-width="2"
            >
              <path d="M23 4v6h-6M1 20v-6h6"/>
              <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/>
            </svg>
            {{ isReloading ? 'Reloading...' : 'Reload' }}
          </button>
        </div>
      </div>

      <!-- Loading -->
      <div v-if="loading" class="loading-wrap">
        <div class="skeleton-table">
          <div v-for="n in 6" :key="n" class="skeleton-row">
            <div class="skel skel--cover"></div>
            <div class="skel-text-col">
              <div class="skel skel--title"></div>
              <div class="skel skel--sub"></div>
            </div>
            <div class="skel skel--md"></div>
            <div class="skel skel--badge"></div>
            <div class="skel skel--sm"></div>
          </div>
        </div>
      </div>

      <!-- Table -->
      <template v-else>
        <div class="table-section">
          <div class="table-wrapper">
            <table class="songs-table">
              <thead>
                <tr>
                  <th>Campaign</th>
                  <th>Type</th>
                  <th>Impressions</th>
                  <th>Clicks</th>
                  <th>CTR</th>
                  <th>Budget</th>
                  <th>Spent</th>
                  <th>Status</th>
                  <th>Period</th>
                  <th class="th-actions">Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  v-for="(campaign, i) in filteredCampaigns"
                  :key="campaign.id"
                  class="table-row"
                  :style="{ animationDelay: i * 30 + 'ms' }"
                >
                  <!-- Campaign -->
                  <td class="td-song">
                    <div class="song-cell">
                      <div class="campaign-icon" :class="'campaign-icon--' + campaign.type">
                        <!-- Banner -->
                        <svg v-if="campaign.type === 'banner'" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <rect x="2" y="3" width="20" height="14" rx="2"/>
                        </svg>
                        <!-- Audio -->
                        <svg v-else-if="campaign.type === 'audio'" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>
                        </svg>
                        <!-- Video -->
                        <svg v-else width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <polygon points="23 7 16 12 23 17 23 7"/><rect x="1" y="5" width="15" height="14" rx="2"/>
                        </svg>
                      </div>
                      <div class="song-info">
                        <p class="song-title">{{ campaign.name }}</p>
                        <!-- <p class="song-meta-sub">
                          {{ campaign.target_gender === 'all' ? 'All Genders' : (campaign.target_gender === 'male' ? 'Male Only' : 'Female Only') }}
                          · {{ campaign.target_age_min || 13 }}+ age
                        </p> -->
                      </div>
                    </div>
                  </td>

                  <!-- Type -->
                  <td>
                    <span class="type-badge" :class="'type--' + campaign.type">
                      {{ campaign.type }}
                    </span>
                  </td>

                  <!-- Impressions -->
                  <td class="td-text">
                    <div class="plays-cell">
                      <div class="plays-bar-wrap">
                        <div class="plays-bar">
                          <div class="plays-fill" :style="{ width: getPercent(campaign.total_impressions, maxImpressions) + '%' }"></div>
                        </div>
                      </div>
                      <span class="plays-num">{{ formatNumber(campaign.total_impressions) }}</span>
                    </div>
                  </td>

                  <!-- Clicks -->
                  <td class="td-text td-mono">{{ formatNumber(campaign.total_clicks) }}</td>

                  <!-- CTR -->
                  <td class="td-text">
                    <span :class="Number(calculateCTR(campaign)) >= 2 ? 'ctr-good' : 'ctr-low'">
                      {{ calculateCTR(campaign) }}%
                    </span>
                  </td>

                  <!-- Budget -->
                  <td class="td-text td-mono">${{ formatNumber(campaign.budget_total) }}</td>

                  <!-- Spent -->
                  <td class="td-text">
                    <div class="budget-cell">
                      <div class="budget-bar">
                        <div
                          class="budget-fill"
                          :class="getBudgetClass(campaign.budget_spent, campaign.budget_total)"
                          :style="{ width: getPercent(campaign.budget_spent, campaign.budget_total) + '%' }"
                        ></div>
                      </div>
                      <span class="plays-num">${{ formatNumber(campaign.budget_spent) }}</span>
                    </div>
                  </td>

                  <!-- Status -->
                  <td>
                    <span class="status-badge" :class="'status--' + campaign.status">
                      <span class="status-dot"></span>
                      {{ campaign.status }}
                    </span>
                  </td>

                  <!-- Period -->
                  <td class="td-text td-muted">
                    <span class="td-mono">{{ formatDate(campaign.start_date) }}</span>
                    <br/>
                    <!-- <span class="td-mono" style="font-size:11px">→ {{ formatDate(campaign.end_date) }}</span> -->
                  </td>

                  <!-- Actions -->
                  <td class="td-actions">
                    <div class="action-btns">
                      <button class="act-btn act-btn--edit" title="Edit" @click="editCampaign(campaign.id)">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                          <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                        </svg>
                      </button>
                      <button
                        class="act-btn"
                        :class="campaign.status === 'active' ? 'act-btn--pause' : 'act-btn--play'"
                        :title="campaign.status === 'active' ? 'Pause' : 'Resume'"
                        @click="toggleCampaign(campaign)"
                      >
                        <svg v-if="campaign.status === 'active'" width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                          <rect x="6" y="4" width="4" height="16" rx="1"/><rect x="14" y="4" width="4" height="16" rx="1"/>
                        </svg>
                        <svg v-else width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                          <polygon points="5 3 19 12 5 21 5 3"/>
                        </svg>
                      </button>
                      <button class="act-btn act-btn--delete" title="Delete" @click="deleteCampaign(campaign.id)">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <polyline points="3 6 5 6 21 6"/>
                          <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                        </svg>
                      </button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

              <!-- Empty -->
        <div v-if="!loading && filteredCampaigns.length === 0" class="empty-state">
          <div class="empty-illustration">
            <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
              <rect x="2" y="3" width="20" height="14" rx="2"/>
              <path d="M8 21h8M12 17v4"/>
            </svg>
          </div>
          <p class="empty-title">No campaigns found</p>
          <p class="empty-sub">Try adjusting your search or create a new campaign</p>
          <button class="btn-retry" @click="ViewAddCampaign">Create Campaign</button>
        </div>
      </template>
    </div>
  </div>
  <!-- Top Up Modal -->
  <teleport to="body">
    <transition name="modal-fade">
      <div v-if="showTopUpModal" class="modal-backdrop" @click.self="showTopUpModal = false">
        <div class="topup-modal">
          <div class="topup-modal__header">
            <div class="topup-modal__title">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <path d="M21 12V7H5a2 2 0 0 1 0-4h14v4"/>
                <path d="M3 5v14a2 2 0 0 0 2 2h16v-5"/>
                <path d="M18 12a2 2 0 0 0 0 4h4v-4z"/>
              </svg>
              Top Up Wallet
            </div>
            <button class="topup-modal__close" @click="cancelTopUp">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
              </svg>
            </button>
          </div>

          <div class="topup-modal__balance">
            <span class="topup-balance__label">Current Balance</span>
            <span class="topup-balance__amount">${{ walletBalance.toFixed(2) }}</span>
          </div>

          <!-- Quick amount presets -->
          <div class="topup-modal__section-label">Quick Select</div>
          <div class="topup-presets">
            <button
              v-for="preset in topUpPresets"
              :key="preset"
              class="topup-preset-btn"
              :class="{ active: topUpAmount === preset }"
              @click="topUpAmount = preset"
            >
              ${{ preset }}
            </button>
          </div>

          <!-- Custom amount -->
          <div class="topup-modal__section-label">Or enter amount</div>
          <div class="topup-input-wrap">
            <span class="topup-input-prefix">$</span>
            <input
              v-model.number="topUpAmount"
              type="number"
              class="topup-input"
              placeholder="0.00"
              min="1"
              step="1"
            />
          </div>

          <!-- QR placeholder — bạn tự làm phần này -->
          <div class="topup-qr-zone">
            <!-- Loading -->
            <div v-if="loadingQR" class="topup-qr-placeholder">
              <svg class="topup-qr-spinning" width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"/>
              </svg>
              <p class="topup-qr-text">Creating QR...</p>
            </div>

            <!-- Error -->
            <div v-else-if="qrError" class="topup-qr-placeholder">
              <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="1.5">
                <circle cx="12" cy="12" r="10"/>
                <line x1="12" y1="8" x2="12" y2="12"/>
                <line x1="12" y1="16" x2="12.01" y2="16"/>
              </svg>
              <p class="topup-qr-text" style="color: #ef4444">{{ qrError }}</p>
            </div>

            <!-- QR hiển thị -->
            <div v-else-if="qrData.qr_url" class="topup-qr-content">
              <img :src="qrData.qr_url" alt="QR Code" class="topup-qr-image" />
              <div class="topup-qr-info">
                <div class="topup-qr-info-row">
                  <span class="topup-qr-info-label">Bank</span>
                  <span class="topup-qr-info-value">{{ qrData.bank_name }}</span>
                </div>
                <div class="topup-qr-info-row">
                  <span class="topup-qr-info-label">Account Number</span>
                  <span class="topup-qr-info-value">{{ qrData.bank_account }}</span>
                </div>
                <div class="topup-qr-info-row">
                  <span class="topup-qr-info-label">Content</span>
                  <span class="topup-qr-info-value">{{ qrData.content }}</span>
                </div>
                <div class="topup-qr-info-row">
                  <span class="topup-qr-info-label">Amount</span>
                  <span class="topup-qr-info-value topup-qr-amount">${{ qrData.amount }}</span>
                </div>
              </div>
            </div>

            <!-- Placeholder ban đầu -->
            <div v-else class="topup-qr-placeholder">
              <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2">
                <rect x="3" y="3" width="7" height="7" rx="1"/>
                <rect x="14" y="3" width="7" height="7" rx="1"/>
                <rect x="3" y="14" width="7" height="7" rx="1"/>
                <rect x="14" y="14" width="3" height="3"/>
                <rect x="19" y="14" width="2" height="2"/>
                <rect x="14" y="19" width="2" height="2"/>
                <rect x="18" y="18" width="3" height="3"/>
              </svg>
              <p class="topup-qr-text">Select the amount and press Confirm.</p>
              <p class="topup-qr-sub">QR will be displayed here</p>
            </div>
          </div>

          <div class="topup-modal__footer">
            <button class="topup-cancel-btn" @click="cancelTopUp">Cancel</button>
            <button
              class="topup-confirm-btn"
              :disabled="!topUpAmount || topUpAmount <= 0"
              @click="handleTopUp"
            >
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <polyline points="20 6 9 17 4 12"/>
              </svg>
              Confirm ${{ topUpAmount || 0 }}
            </button>
          </div>
        </div>
      </div>
    </transition>
  </teleport>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { usePartnerStore } from '@/modules/client/stores/partners/partnersStore'
import { useUserStore } from '@/modules/client/stores/users/UserStore'
import { useNotificationStore } from '@/store/notificationStore'
import advertisingService from '@/modules/client/services/partners/advertising.service'
import Swal from 'sweetalert2'

const userStore = useUserStore()
const notificationStore = useNotificationStore()
const router = useRouter()
const partnerStore = usePartnerStore()

// ── UI State ──
const loading      = ref(false)
const isReloading  = ref(false)
const searchQuery  = ref('')
const selectedStatus = ref('')
const selectedType   = ref('')
const showQR = ref(false)
const loadingQR = ref(false)
const isRefreshing = ref(false)

const qrError = ref<string | null>(null)
  
const qrData = ref({
    qr_url:       '',
    content:      '',
    payment_id:   null as number | null,
    bank_name:    '',
    bank_account: '',
    amount:       '',
})
// ── Campaign Interface & State ──
interface Campaign {
  id:                number
  name:              string
  type:              'audio' | 'banner' | 'video' | 'sponsored_content'
  thumbnail_url:     string | null
  media_url:         string | null
  budget_total:      number
  budget_spent:      number
  total_impressions: number
  total_plays:       number
  total_clicks:      number
  status:            'active' | 'paused' | 'ended' | 'draft' | 'pending'
  start_date:        string
  end_date:          string | null
}

const campaigns = ref<Campaign[]>([])

// ── Computed Stats ──
const stats = computed(() => {
  const total = campaigns.value.length
  const imps = campaigns.value.reduce((acc, c) => acc + (c.total_impressions || 0), 0)
  const plays = campaigns.value.reduce((acc, c) => acc + (c.total_plays || 0), 0)
  const clicks = campaigns.value.reduce((acc, c) => acc + (c.total_clicks || 0), 0)
  const spent = campaigns.value.reduce((acc, c) => acc + (c.budget_spent || 0), 0)
  
  // Calculate CTR based on plays (if audio/video) or impressions (if banner)
  // For simplicity, we'll use (clicks / impressions) as a general CTR
  const ctrValue = imps > 0 ? (clicks / imps) * 100 : 0
  
  return {
    totalCampaigns: total,
    totalImpressions: imps,
    totalPlays: plays,
    ctr: ctrValue.toFixed(1),
    totalSpent: spent,
  }
})

// ── Computed ──
const maxImpressions = computed(() =>
  campaigns.value.length ? Math.max(...campaigns.value.map(c => c.total_impressions || 0), 100) : 100
)

function calculateCTR(campaign: Campaign) {
  if (!campaign.total_impressions || campaign.total_impressions === 0) return '0.0'
  return ((campaign.total_clicks / campaign.total_impressions) * 100).toFixed(1)
}

const filteredCampaigns = computed(() => {
  return campaigns.value.filter(c => {
    const matchSearch = !searchQuery.value ||
      c.name.toLowerCase().includes(searchQuery.value.toLowerCase())

    const matchStatus = !selectedStatus.value || c.status === selectedStatus.value
    const matchType   = !selectedType.value   || c.type   === selectedType.value

    return matchSearch && matchStatus && matchType
  })
})

// ── Helpers ──
const formatNumber = (n: number): string => {
  if (n >= 1_000_000) return (n / 1_000_000).toFixed(1) + 'M'
  if (n >= 1_000)     return (n / 1_000).toFixed(1) + 'K'
  return String(n)
}

const formatDate = (iso: string): string =>
  new Date(iso).toLocaleDateString('en-GB', {
    day: '2-digit', month: 'short', year: 'numeric'
  })

const getPercent = (value: number, max: number): number =>
  max > 0 ? Math.round((value / max) * 100) : 0

const getBudgetClass = (spent: number, budget: number): string => {
  const pct = budget > 0 ? (spent / budget) * 100 : 0
  if (pct >= 90) return 'budget-fill--danger'
  if (pct >= 60) return 'budget-fill--warning'
  return 'budget-fill--safe'
}

const refreshBalance = async () => {
  isRefreshing.value = true
  try {
    await partnerStore.fetchPartnerInfo()
    await new Promise(resolve => setTimeout(resolve, 600))
  } catch (err) {
    console.error('Refresh balance failed', err)
  } finally {
    isRefreshing.value = false
  }
}
// ── Actions ──
const ViewAddCampaign = () => router.push({ name: 'client.partner.Advertisingd.add' })
const editCampaign    = (id: number) => router.push({ name: 'client.partner.Advertisingd.update', params: { id } })

const toggleCampaign = async (campaign: Campaign) => {
  try {
    const res = await advertisingService.toggleCampaignStatus(campaign.id)
    campaign.status = res.data.status
    notificationStore.notify(`Campaign ${campaign.status === 'active' ? 'resumed' : 'paused'}`, 'success')
  } catch (err: any) {
    console.error('Toggle failed:', err)
    notificationStore.notify('Failed to update campaign status', 'error')
  }
}

const deleteCampaign = async (id: number) => {
  const result = await Swal.fire({
    title:             'Delete Campaign?',
    text:              'This action cannot be undone.',
    icon:              'warning',
    showCancelButton:  true,
    confirmButtonText: 'Delete',
    confirmButtonColor: '#e24b4a',
    cancelButtonColor:  '#334155',
    background: '#181c22',
    color: '#f1f5f9'
  })

  if (result.isConfirmed) {
    try {
      await advertisingService.deleteCampaign(id)
      notificationStore.notify('Campaign deleted successfully', 'success')
      
      // Refresh list
      const allCampaigns = await advertisingService.getCampaigns()
      campaigns.value = allCampaigns
    } catch (err: any) {
      console.error('Delete failed:', err)
      notificationStore.notify('Failed to delete campaign', 'error')
    }
  }
}
const onFilterChange = () => {}
const onSearchInput  = () => {}

const handleReload = async () => {
  isReloading.value = true
  try {
    const allCampaigns = await advertisingService.getCampaigns()
    campaigns.value = allCampaigns
    notificationStore.notify('Data refreshed', 'success')
  } catch (err) {
    console.error('Reload failed:', err)
    notificationStore.notify('Failed to refresh data', 'error')
  } finally {
    isReloading.value = false
  }
}

// ── Wallet ──
const walletBalance   = ref(0)
const showTopUpModal  = ref(false)
const topUpAmount     = ref<number | null>(null)
const topUpPresets    = [2000, 3000, 5000 , 10000]

const topUpSuccess = ref(false)
const newWalletBalance = ref(0)

const generateTopUpQR = async () => {
    if (!topUpAmount.value || topUpAmount.value <= 0) return

    loadingQR.value = true
    qrError.value = null
    topUpSuccess.value = false  

    qrData.value = {
        qr_url: '', content: '', payment_id: null,
        bank_name: '', bank_account: '', amount: '',
    }

    try {
        const res = await userStore.fetchCreateQRToUp({
            amount: topUpAmount.value,
        })

        qrData.value = {
            qr_url:       res.qr_url       || res.data?.qr_url       || '',
            content:      res.content      || res.data?.content      || '',
            payment_id:   res.payment_id   || res.data?.payment_id   || null,
            bank_name:    res.bank_name    || res.data?.bank_name    || '',
            bank_account: res.bank_account || res.data?.bank_account || '',
            amount:       res.amount       || res.data?.amount       || '',
        }

        notificationStore.notify('QR code generated! Scan to pay.', 'success')

        userStore.startCheckTopUp((balance: number) => {            
            walletBalance.value = balance        
            newWalletBalance.value = balance     
            topUpSuccess.value = true           

            // Notify success
            Swal.fire({
                title: 'Payment Successful',
                text: 'Your wallet has been topped up successfully.',
                icon: 'success',
                timer: 2000,
                showConfirmButton: false,
                background: '#181c22',
                color: '#f1f5f9'
            })

            // Close modal
            showTopUpModal.value = false
            
            // Reset state
            topUpAmount.value = null
        })

    } catch (err: any) {
        qrError.value = err.response?.data?.message || err.message || 'Failed to generate QR'
        notificationStore.notify('Failed to generate QR code', 'error')
    } finally {
        loadingQR.value = false
    }
}

const cancelTopUp = () => {
    userStore.stopCheckSubscription() 
    showTopUpModal.value = false
    topUpAmount.value = null
    topUpSuccess.value = false
    qrError.value = null
    qrData.value = {
        qr_url: '', content: '', payment_id: null,
        bank_name: '', bank_account: '', amount: '',
    }
}

const handleTopUp = async () => {
  if (!topUpAmount.value || topUpAmount.value <= 0) return

  loadingQR.value = true
  qrError.value = null

  try {
    await generateTopUpQR()

    await refreshBalance()

  } catch (err: unknown) {
    const error = err as any 
    qrError.value =
      error?.response?.data?.message ||
      error?.message ||
      'Unable to generate QR code. Please try again..'
    console.error('Top up error:', error)
  } finally {
    loadingQR.value = false
  }
}

onMounted(async () => {
    loading.value = true
    try {
        // Fetch partner and wallet info
        await partnerStore.fetchPartnerInfo()
        if (partnerStore.user) {
            walletBalance.value = Number(partnerStore.user.wallet_balance ?? 0)
        }

        // Fetch campaigns
        const allCampaigns = await advertisingService.getCampaigns()
        campaigns.value = allCampaigns

    } catch (err) {
        console.error('Failed to fetch dashboard data:', err)
    } finally {
        loading.value = false
    }
})


</script>

<style scoped>
* { box-sizing: border-box; margin: 0; padding: 0; }

.adv-dashboard {
  background-color: #1b2325;
  min-height: 100vh;
  padding: 32px 36px;
  font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
  color: #e2e8f0;
}

/* ── Header ── */
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 32px;
}
.title {
  font-size: 28px;
  font-weight: 700;
  background: linear-gradient(90deg, #f59e0b, #ef4444);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.subtitle { font-size: 13px; color: #64748b; margin-top: 4px; }
.header-right { display: flex; align-items: center; gap: 12px; }

.btn-add {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  background: linear-gradient(90deg, #f59e0b, #ef4444);
  border: none;
  border-radius: 10px;
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: opacity 0.2s;
}
.btn-add:hover { opacity: 0.85; }
.btn-icon { display: flex; align-items: center; }

/* ── Stats ── */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 18px;
  margin-bottom: 28px;
}
.stat-card {
  background: rgba(255,255,255,0.05);
  border-radius: 14px;
  padding: 22px 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  border-top: 3px solid transparent;
}
.stat-card--blue   { border-top-color: #00c6ff; }
.stat-card--green  { border-top-color: #43e97b; }
.stat-card--purple { border-top-color: #a78bfa; }
.stat-card--orange { border-top-color: #f59e0b; }

.stat-icon {
  width: 52px; height: 52px; border-radius: 12px;
  background: rgba(255,255,255,0.08);
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0; color: #94a3b8;
}
.stat-info { display: flex; flex-direction: column; gap: 4px; }
.stat-label { font-size: 12px; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; }
.stat-value { font-size: 28px; font-weight: 700; color: #f1f5f9; line-height: 1.1; }
.stat-change { font-size: 12px; color: #64748b; }
.stat-change.positive { color: #43e97b; }

/* ── Table Area ── */
.songs-list-page {
  --bg:        #111418;
  --surface:   #181c22;
  --surface-2: #1e2530;
  --surface-3: #252d3a;
  --border:    #252d3a;
  --border-2:  #2e3847;
  --text-1:    #f0f4f8;
  --text-2:    #8b9ab0;
  --text-3:    #4a5568;
  --accent:    #f59e0b;
  --accent-2:  #fbbf24;
  --green:     #22c55e;
  --red:       #ef4444;

  background: var(--bg);
  padding: 24px;
  border-radius: 14px;
  color: var(--text-1);
}

/* ── Toolbar ── */
.toolbar {
  display: flex; align-items: center; justify-content: space-between;
  flex-wrap: wrap; gap: 10px; margin-bottom: 18px;
}
.toolbar__left, .toolbar__right { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }

.search-box { position: relative; display: flex; align-items: center; }
.search-icon { position: absolute; left: 11px; color: var(--text-3); pointer-events: none; }
.search-box input {
  background: var(--surface); border: 1px solid var(--border-2); border-radius: 10px;
  padding: 9px 32px 9px 34px; color: var(--text-1); font-size: 13px; width: 230px;
  outline: none; transition: all .2s;
}
.search-box input::placeholder { color: var(--text-3); }
.search-box input:focus { border-color: var(--accent); }
.search-clear {
  position: absolute; right: 10px; background: none; border: none;
  color: var(--text-3); cursor: pointer; display: flex; align-items: center;
}

.filter-select {
  background: var(--surface); border: 1px solid var(--border-2); border-radius: 10px;
  padding: 9px 12px; color: var(--text-2); font-size: 13px; outline: none; cursor: pointer;
}

/* ── Skeleton ── */
.skeleton-table { background: var(--surface); border-radius: 14px; overflow: hidden; border: 1px solid var(--border); }
.skeleton-row {
  display: flex; align-items: center; gap: 16px; padding: 14px 20px;
  border-bottom: 1px solid var(--border); animation: skeleton-pulse 1.6s ease-in-out infinite;
}
.skel { border-radius: 6px; background: var(--surface-3); flex-shrink: 0; }
.skel--cover  { width: 38px; height: 38px; border-radius: 8px; }
.skel--title  { width: 120px; height: 12px; }
.skel--sub    { width: 80px; height: 10px; margin-top: 6px; }
.skel--md     { width: 90px; height: 12px; }
.skel--badge  { width: 50px; height: 20px; border-radius: 20px; }
.skel--sm     { width: 60px; height: 12px; }
.skel-text-col { flex: 1; }
@keyframes skeleton-pulse { 0%,100% { opacity: 1; } 50% { opacity: .5; } }

/* ── Table ── */
.table-section { background: var(--surface); border-radius: 14px; overflow: hidden; border: 1px solid var(--border); }
.table-wrapper { overflow-x: auto; }
.songs-table { width: 100%; border-collapse: collapse; font-size: 13px; }
.songs-table thead tr { background: var(--surface-2); border-bottom: 1px solid var(--border-2); }
.songs-table thead th {
  padding: 11px 16px; text-align: left;
  font-size: 11.5px; font-weight: 600; color: var(--text-3);
  letter-spacing: 0.04em; white-space: nowrap;
}
.th-actions { width: 110px; text-align: right; }
.table-row { border-bottom: 1px solid var(--border); transition: background .15s; animation: row-in .3s ease both; }
.table-row:last-child { border-bottom: none; }
.table-row:hover { background: rgba(255,255,255,.02); }
@keyframes row-in { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: translateY(0); } }

.songs-table td { padding: 11px 16px; vertical-align: middle; }
.td-song  { min-width: 220px; }
.td-text  { color: var(--text-2); white-space: nowrap; }
.td-muted { color: var(--text-3); }
.td-mono  { font-variant-numeric: tabular-nums; }
.td-actions { width: 110px; }

/* ── Campaign Icon ── */
.song-cell { display: flex; align-items: center; gap: 11px; }
.campaign-icon {
  width: 38px; height: 38px; border-radius: 8px; flex-shrink: 0;
  display: flex; align-items: center; justify-content: center;
}
.campaign-icon--banner { background: rgba(0,198,255,.12); color: #00c6ff; }
.campaign-icon--audio  { background: rgba(167,139,250,.12); color: #a78bfa; }
.campaign-icon--video  { background: rgba(245,158,11,.12); color: #f59e0b; }

.song-info { min-width: 0; flex: 1; }
.song-title {
  font-size: 13.5px; font-weight: 600; color: var(--text-1);
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 180px;
}
.song-meta-sub { font-size: 11px; color: var(--text-3); margin-top: 1px; }

/* ── Type Badge ── */
.type-badge {
  display: inline-flex; align-items: center; padding: 3px 9px; border-radius: 6px;
  font-size: 11px; font-weight: 600; letter-spacing: 0.03em; border: 1px solid transparent;
  text-transform: capitalize;
}
.type--banner { background: rgba(0,198,255,.1);   color: #00c6ff; border-color: rgba(0,198,255,.2); }
.type--audio  { background: rgba(167,139,250,.1); color: #a78bfa; border-color: rgba(167,139,250,.2); }
.type--video  { background: rgba(245,158,11,.1);  color: #f59e0b; border-color: rgba(245,158,11,.2); }

/* ── Plays / Impressions Bar ── */
.plays-cell { display: flex; align-items: center; gap: 8px; }
.plays-bar-wrap { width: 48px; }
.plays-bar  { height: 3px; background: var(--surface-3); border-radius: 2px; overflow: hidden; }
.plays-fill { height: 100%; background: linear-gradient(90deg, #f59e0b, #ef4444); border-radius: 2px; transition: width .3s; }
.plays-num  { font-size: 12px; color: var(--text-3); white-space: nowrap; font-variant-numeric: tabular-nums; }

/* ── CTR ── */
.ctr-good { color: #4ade80; font-weight: 600; }
.ctr-low  { color: #94a3b8; }

/* ── Budget Bar ── */
.budget-cell { display: flex; align-items: center; gap: 8px; }
.budget-bar  { width: 48px; height: 3px; background: var(--surface-3); border-radius: 2px; overflow: hidden; }
.budget-fill { height: 100%; border-radius: 2px; transition: width .3s; }
.budget-fill--safe    { background: #22c55e; }
.budget-fill--warning { background: #f59e0b; }
.budget-fill--danger  { background: #ef4444; }

/* ── Status Badge ── */
.status-badge {
  display: inline-flex; align-items: center; gap: 5px; padding: 4px 10px;
  border-radius: 20px; font-size: 11.5px; font-weight: 600; text-transform: capitalize;
}
.status-dot { width: 5px; height: 5px; border-radius: 50%; background: currentColor; }
.status--active  { background: rgba(34,197,94,.1);   color: #4ade80; }
.status--paused  { background: rgba(245,158,11,.1);  color: #fbbf24; }
.status--ended   { background: rgba(100,116,139,.12); color: #64748b; }
.status--draft   { background: rgba(148,163,184,.08); color: #94a3b8; }

/* ── Action Buttons ── */
.action-btns { display: flex; align-items: center; gap: 4px; justify-content: flex-end; }
.act-btn {
  width: 28px; height: 28px; border-radius: 8px;
  border: 1px solid var(--border-2); background: var(--surface-2);
  display: flex; align-items: center; justify-content: center;
  cursor: pointer; color: var(--text-3); transition: all .2s;
}
.act-btn:hover { transform: translateY(-1px); }
.act-btn--edit:hover  { border-color: #f59e0b; color: #fbbf24; background: rgba(245,158,11,.08); }
.act-btn--play:hover  { border-color: var(--green); color: var(--green); background: rgba(34,197,94,.08); }
.act-btn--pause:hover { border-color: #fbbf24; color: #fbbf24; background: rgba(245,158,11,.08); }
.act-btn--delete:hover{ border-color: var(--red); color: #f87171; background: rgba(239,68,68,.08); }

/* ── Empty State ── */
.empty-state {
  display: flex; flex-direction: column; align-items: center;
  padding: 80px 0; gap: 10px; text-align: center;
}
.empty-illustration { color: var(--surface-3); margin-bottom: 8px; }
.empty-title { font-size: 16px; font-weight: 600; color: var(--text-3); }
.empty-sub   { font-size: 13px; color: var(--text-3); opacity: .6; }
.btn-retry {
  display: flex; align-items: center; gap: 7px; padding: 9px 18px; border-radius: 10px;
  background: linear-gradient(90deg, #f59e0b, #ef4444);
  border: none; color: #fff; font-size: 13px; font-weight: 600;
  cursor: pointer; margin-top: 8px; transition: opacity .2s;
}
.btn-retry:hover { opacity: .85; }

/* ── Reload Button ── */
.btn-reload {
  display: flex; align-items: center; gap: 6px; padding: 8px 16px;
  background: transparent; border: 1px solid rgba(245,158,11,.3);
  border-radius: 8px; color: #f59e0b; font-size: 13px; cursor: pointer; transition: all .2s;
}
.btn-reload:hover { background: rgba(245,158,11,.1); border-color: #f59e0b; }

.reload-icon { transition: transform .3s; }
.spinning    { animation: spin .8s linear infinite; }
@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }

/* ── Responsive ── */
@media (max-width: 1024px) {
  .stats-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 640px) {
  .adv-dashboard { padding: 20px 16px; }
  .header { flex-direction: column; align-items: flex-start; gap: 16px; }
  .stats-grid { grid-template-columns: 1fr 1fr; }
}

/* ── Wallet Widget ── */
.wallet-widget {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 14px;
  background: rgba(255,255,255,.05);
  border: 1px solid rgba(255,255,255,.1);
  border-radius: 12px;
  position: relative;
  transition: all .2s;
}
.wallet-widget--low {
  border-color: rgba(239,68,68,.4);
  background: rgba(239,68,68,.06);
}
.wallet-widget__icon {
  color: #f59e0b;
  display: flex;
  align-items: center;
}
.wallet-widget__body {
  display: flex;
  flex-direction: column;
  gap: 1px;
}
.wallet-widget__label {
  font-size: 10px;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: .06em;
  font-weight: 600;
}
.wallet-widget__amount {
  font-size: 16px;
  font-weight: 700;
  color: #f1f5f9;
  font-variant-numeric: tabular-nums;
  line-height: 1;
}
.wallet-widget--low .wallet-widget__amount { color: #f87171; }
.wallet-widget__low-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: #ef4444;
  position: absolute;
  top: 8px;
  right: 8px;
  animation: pulse-dot 1.5s ease-in-out infinite;
}
@keyframes pulse-dot {
  0%,100% { opacity: 1; transform: scale(1); }
  50%      { opacity: .5; transform: scale(1.4); }
}
.wallet-widget__topup {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 6px 12px;
  background: linear-gradient(135deg, #f59e0b, #ef4444);
  border: none;
  border-radius: 8px;
  color: #fff;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: opacity .2s, transform .15s;
  white-space: nowrap;
}
.wallet-widget__topup:hover { opacity: .85; transform: translateY(-1px); }

/* ── Modal ── */
.modal-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,.65);
  backdrop-filter: blur(6px);
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
}
.topup-modal {
  background: #181c22;
  border: 1px solid rgba(255,255,255,.1);
  border-radius: 20px;
  padding: 28px;
  width: 420px;
  max-width: calc(100vw - 32px);
  box-shadow: 0 24px 60px rgba(0,0,0,.6);
  display: flex;
  flex-direction: column;
  gap: 18px;
}
.topup-modal__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.topup-modal__title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 17px;
  font-weight: 700;
  color: #f1f5f9;
}
.topup-modal__title svg { color: #f59e0b; }
.topup-modal__close {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  background: rgba(255,255,255,.06);
  border: 1px solid rgba(255,255,255,.1);
  color: #64748b;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all .15s;
}
.topup-modal__close:hover { color: #fff; background: rgba(255,255,255,.12); }

.topup-modal__balance {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 16px;
  background: rgba(245,158,11,.06);
  border: 1px solid rgba(245,158,11,.2);
  border-radius: 12px;
}
.topup-balance__label {
  font-size: 11px;
  color: #64748b;
  text-transform: uppercase;
  letter-spacing: .06em;
  font-weight: 600;
}
.topup-balance__amount {
  font-size: 28px;
  font-weight: 800;
  color: #f59e0b;
  font-variant-numeric: tabular-nums;
}

.topup-modal__section-label {
  font-size: 11px;
  font-weight: 600;
  color: #475569;
  text-transform: uppercase;
  letter-spacing: .06em;
}

.topup-presets {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
}
.topup-preset-btn {
  padding: 10px;
  background: rgba(255,255,255,.04);
  border: 1px solid rgba(255,255,255,.1);
  border-radius: 10px;
  color: #94a3b8;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all .15s;
  text-align: center;
}
.topup-preset-btn:hover { background: rgba(255,255,255,.08); color: #fff; }
.topup-preset-btn.active {
  background: rgba(245,158,11,.15);
  border-color: rgba(245,158,11,.5);
  color: #f59e0b;
}

.topup-input-wrap {
  display: flex;
  align-items: center;
  background: rgba(255,255,255,.04);
  border: 1px solid rgba(255,255,255,.1);
  border-radius: 10px;
  overflow: hidden;
  transition: border-color .2s;
}
.topup-input-wrap:focus-within { border-color: rgba(245,158,11,.5); }
.topup-input-prefix {
  padding: 0 14px;
  font-size: 16px;
  font-weight: 600;
  color: #475569;
  background: rgba(255,255,255,.03);
  border-right: 1px solid rgba(255,255,255,.08);
  height: 44px;
  display: flex;
  align-items: center;
}
.topup-input {
  flex: 1;
  background: transparent;
  border: none;
  outline: none;
  padding: 0 14px;
  color: #f1f5f9;
  font-size: 16px;
  font-weight: 600;
  font-variant-numeric: tabular-nums;
  height: 44px;
  font-family: inherit;
}
.topup-input::placeholder { color: #334155; }

/* ── QR Zone ── */
.topup-qr-zone {
  background: rgba(255,255,255,.02);
  border: 1px dashed rgba(255,255,255,.1);
  border-radius: 12px;
  overflow: hidden;
}
.topup-qr-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 28px;
  gap: 8px;
  color: rgba(255,255,255,.15);
}
.topup-qr-text { font-size: 13px; color: #334155; font-weight: 500; }
.topup-qr-sub  { font-size: 11px; color: #1e293b; }

.topup-modal__footer {
  display: flex;
  gap: 10px;
}
.topup-cancel-btn {
  flex: 1;
  padding: 12px;
  background: rgba(255,255,255,.05);
  border: 1px solid rgba(255,255,255,.1);
  border-radius: 10px;
  color: #64748b;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all .15s;
  font-family: inherit;
}
.topup-cancel-btn:hover { background: rgba(255,255,255,.08); color: #94a3b8; }
.topup-confirm-btn {
  flex: 2;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 7px;
  padding: 12px;
  background: linear-gradient(135deg, #f59e0b, #ef4444);
  border: none;
  border-radius: 10px;
  color: #fff;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  transition: opacity .2s, transform .15s;
  font-family: inherit;
}
.topup-confirm-btn:hover:not(:disabled) { opacity: .88; transform: translateY(-1px); }
.topup-confirm-btn:disabled { opacity: .35; cursor: not-allowed; }

/* ── Modal transition ── */
.modal-fade-enter-active, .modal-fade-leave-active { transition: opacity .2s ease; }
.modal-fade-enter-from,  .modal-fade-leave-to      { opacity: 0; }
.modal-fade-enter-active .topup-modal,
.modal-fade-leave-active .topup-modal              { transition: transform .2s ease; }
.modal-fade-enter-from   .topup-modal              { transform: scale(.95) translateY(10px); }
.modal-fade-leave-to     .topup-modal              { transform: scale(.95) translateY(10px); }

.topup-qr-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  width: 100%;
}

.topup-qr-image {
  width: 180px;
  height: 180px;
  border-radius: 8px;
  border: 1px solid rgba(255,255,255,0.1);
}

.topup-qr-info {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.topup-qr-info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 12px;
}

.topup-qr-info-label {
  color: rgba(255,255,255,0.5);
}

.topup-qr-info-value {
  color: rgba(255,255,255,0.9);
  font-weight: 500;
}

.topup-qr-amount {
  color: #a78bfa;
  font-weight: 700;
  font-size: 14px;
}

.topup-qr-spinning {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to   { transform: rotate(360deg); }
}

/* ====================== NÚT RELOAD + ANIMATION ====================== */
.topup-reload-btn {
  background: none;
  border: none;
  color: #00aaff;
  cursor: pointer;
  padding: 6px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.25s ease;
  width: 32px;
  height: 32px;
}

.topup-reload-btn:hover {
  background: rgba(0, 170, 255, 0.12);
  transform: scale(1.08);
}

.topup-reload-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Animation quay khi đang refresh */
.topup-reload-btn .spinning {
  animation: spin 0.9s linear infinite;
}

/* Keyframes */
@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
</style>
<template>
    <div class="users-management">
        <!-- Header -->
        <div class="header">
            <div class="header-left">
                <h1 class="title">Partners Management</h1>
                <p class="subtitle">Overview and statistics of all user accounts</p>
            </div>
        </div>

        <!-- Stats Grid -->
         <div class="stats-grid">
            <!-- 1. Tổng số Partner -->
            <div class="stat-card stat-card--purple">
            <div class="stat-icon">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                <circle cx="12" cy="7" r="4" />
                </svg>
            </div>
            <div class="stat-info">
                <span class="stat-label">Total partners</span>
                <span class="stat-value">{{ formatNumber(partnerStore.statistics?.total_partners || 0) }}</span>
                <span v-if="partnerStore.growthInfo?.totalPartners"
                :class="['stat-change', partnerStore.growthInfo.totalPartners.isPositive ? 'positive' : 'negative']">
                {{ partnerStore.growthInfo.totalPartners.text }}
                </span>
            </div>
            </div>

            <!-- 2. Tổng doanh thu từ Partner -->
            <div class="stat-card stat-card--green">
            <div class="stat-icon">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <path d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-.895 3-2s-1.343-2-3-2" />
                </svg>
            </div>
            <div class="stat-info">
                <span class="stat-label">Total revenue</span>
                <span class="stat-value">{{ formatCurrency(partnerStore.statistics?.total_revenue_all || 0) }}</span>
                <span v-if="partnerStore.growthInfo?.revenue"
                :class="['stat-change', partnerStore.growthInfo.revenue.isPositive ? 'positive' : 'negative']">
                {{ partnerStore.growthInfo.revenue.text }}
                </span>
            </div>
            </div>

            <!-- 3. Tổng chi trả -->
            <div class="stat-card stat-card--red">
            <div class="stat-icon">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <path d="M17 9V7a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h2m2 4h10a2 2 0 0 0 2-2v-1a2 2 0 0 0-2-2H9a2 2 0 0 1-2-2v-1a2 2 0 0 1 2-2m0 0V9" />
                </svg>
            </div>
            <div class="stat-info">
                <span class="stat-label">Total payment</span>
                <span class="stat-value">{{ formatCurrency(partnerStore.statistics?.total_paid_all || 0) }}</span>
                <span v-if="partnerStore.growthInfo?.paid"
                :class="['stat-change', partnerStore.growthInfo.paid.isPositive ? 'positive' : 'negative']">
                {{ partnerStore.growthInfo.paid.text }}
                </span>
            </div>
            </div>

            <!-- 4. Chờ thanh toán -->
            <div class="stat-card stat-card--orange">
            <div class="stat-icon">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <circle cx="12" cy="12" r="10" />
                <path d="M12 8v4l3 3" />
                </svg>
            </div>
            <div class="stat-info">
                <span class="stat-label">Waiting for payment</span>
                <span class="stat-value">{{ formatCurrency(partnerStore.statistics?.total_pending_payout_all || 0) }}</span>
                <span v-if="partnerStore.growthInfo?.pendingPayout"
                :class="['stat-change', partnerStore.growthInfo.pendingPayout.isPositive ? 'positive' : 'negative']">
                {{ partnerStore.growthInfo.pendingPayout.text }}
                </span>
            </div>
            </div>

            <!-- 5. Lợi nhuận ròng -->
            <div class="stat-card stat-card--emerald">
            <div class="stat-icon">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <path d="M12 2v20M2 12h20" />
                </svg>
            </div>
            <div class="stat-info">
                <span class="stat-label">Net profit</span>
                <span class="stat-value">{{ formatCurrency(partnerStore.netProfit || 0) }}</span>
                <span v-if="partnerStore.growthInfo?.profit"
                :class="['stat-change', partnerStore.growthInfo.profit.isPositive ? 'positive' : 'negative']">
                {{ partnerStore.growthInfo.profit.text }}
                </span>
            </div>
            </div>
        </div>

        <!-- ==================== CHART 1: Line Chart - Xu hướng Doanh thu & Chi trả ==================== -->
        <div class="chart-card mt-8">
            <div class="chart-header">
                <h3 class="text-lg font-semibold">Monthly Revenue & Payment Trends</h3>
                <select v-model="timeRange" class="chart-select" @change="fetchChartData">
                    <option value="6">last 6 months</option>
                    <option value="12">12 months</option>
                    <option value="3">3 months</option>
                </select>
            </div>

            <apexchart type="line" height="380" :options="revenueChartOptions" :series="revenueChartSeries" />
        </div>

        <!-- ==================== CHART 2: Stacked Column + Top Partners (2 cột) ==================== -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mt-8">
            <!-- Stacked Column Chart -->
            <div class="chart-card">
                <h3 class="text-lg font-semibold mb-4">Revenue & Payments by Month (Stacked)</h3>
                <apexchart type="bar" height="350" :options="stackedChartOptions" :series="stackedChartSeries" />
            </div>

            <!-- Top 10 Partner Bar Chart -->
            <div class="chart-card">
                <h3 class="text-lg font-semibold mb-4">Top 10 Partners by Revenue</h3>
                <apexchart type="bar" height="350" :options="topPartnerOptions" :series="topPartnerSeries" />
            </div>
        </div>

        <!-- ==================== CHART 3: Pie - Phân bổ trạng thái Partner ==================== -->
        <div class="chart-card mt-8">
            <h3 class="text-lg font-semibold mb-4">Partner State Allocation</h3>
            <apexchart type="donut" height="320" :options="statusPieOptions" :series="statusPieSeries" />
        </div>
        <!-- Users List Section -->
        <div class="users-list-page">
            <div class="toolbar">
                <div class="toolbar__left">
                    <h2 class="section-title">Recent Parrtner</h2>
                </div>
                <div class="toolbar__right">
                    <div class="search-box">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2" class="search-icon">
                            <circle cx="11" cy="11" r="8" />
                            <line x1="21" y1="21" x2="16.65" y2="16.65" />
                        </svg>
                        <input v-model="keyword" type="text" placeholder="Search partners..." @input="onSearch" />
                    </div>
                </div>
            </div>

            <!-- Table Section -->
            <div class="table-section">
                <div class="table-wrapper">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th>Company</th>
                                <th>Tax Code</th>
                                <th>Stats</th>
                                <th>Status</th>
                                <th>Join Date</th>
                                <th class="th-actions">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="partner in paginatedPartners" :key="partner.id" class="table-row">
                                <!-- Cột Company: Logo + Tên công ty + ID -->
                                <td class="td-user">
                                    <div class="user-cell">
                                        <div class="user-avatar">
                                            <!-- Chỉ hiển thị img nếu có logo_url thực sự -->
                                            <img
                                                v-if="partner.logo_url && partner.logo_url.trim() !== ''"
                                                :src="getFullImageUrl(partner.logo_url)"
                                                :alt="partner.company_name"
                                                @error="(e) => {
                                                    const target = e.target as HTMLImageElement;
                                                    if (target) {
                                                        target.style.display = 'none';
                                                    }
                                                }"
                                            />

                                            <!-- Fallback khi không có logo_url -->
                                            <div
                                                v-else
                                                class="avatar-fallback"
                                                :style="{ backgroundColor: getAvatarColor(partner.company_name) }"
                                            >
                                                {{ getInitial(partner.company_name) }}
                                            </div>
                                        </div>
                                        <div class="user-info">
                                            <p class="user-name">{{ partner.company_name }}</p>
                                            <p class="user-id">ID: {{ partner.company_email }}</p>
                                        </div>
                                    </div>
                                </td>
                                <!-- Cột Tax Code -->
                                <td class="td-text td-mono text-left">
                                    {{ partner.tax_code || '—' }}
                                </td>

                                <!-- Cột Stats: Songs / Artists / Albums -->
                                <td class="td-text">
                                    <div class="stats-badges">
                                        <span class="stat-badge" title="Total Songs">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M9 18V5l12-2v13" />
                                                <circle cx="6" cy="18" r="3" />
                                                <circle cx="18" cy="16" r="3" />
                                            </svg>
                                            {{ partner.total_songs ?? partner.total_songs ?? 0 }}
                                        </span>
                                        <span class="stat-badge" title="Total Artists">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                                <circle cx="12" cy="7" r="4" />
                                            </svg>
                                            {{ partner.total_artists ?? partner.total_artists ?? 0 }}
                                        </span>
                                        <span class="stat-badge" title="Total Albums">
                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <rect x="2" y="2" width="20" height="20" rx="2.18" />
                                                <line x1="8" y1="2" x2="8" y2="22" />
                                                <line x1="16" y1="2" x2="16" y2="22" />
                                            </svg>
                                            {{ partner.total_albums ?? partner.total_albums ?? 0 }}
                                        </span>
                                    </div>
                                </td>

                                <!-- Cột Status -->
                                <td>
                                    <span class="status-btn" :class="getStatusClass(partner.status)">
                                        <span class="status-dot"></span>
                                        {{ formatStatus(partner.status) }}
                                    </span>
                                </td>

                                <!-- Cột Join Date -->
                                <td class="td-text td-mono">{{ formatDate(partner.created_at ?? "") }}</td>

                                <!-- Cột Actions -->
                                <td class="td-actions">
                                <div class="action-btns">
                                    <!-- Nút View Details -->
                                    <button class="act-btn act-btn--view" title="View Details" @click="viewDetailPartner(partner.id)">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                            <circle cx="12" cy="12" r="3" />
                                        </svg>
                                    </button>
                                    
                                    <!-- Nút Change Status - chỉ hiển thị với 1 số status nhất định -->
                                    <button 
                                        v-if="partner.status !== 'terminated'" 
                                        class="act-btn act-btn--status" 
                                        title="Change Status" 
                                        @click="changePartnerStatus(partner.id, partner.status)"
                                    >
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M20 12H4M12 4v16" />
                                        </svg>
                                    </button>
                                </div>
                            </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Empty state -->
                <div v-if="!loading && paginatedPartners.length === 0" class="empty-state">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="1.5">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                        <circle cx="12" cy="7" r="4" />
                    </svg>
                    <p>No partners found</p>
                </div>

                <!-- Loading state inside table -->
                <div v-if="loading" class="loading-overlay">
                    <div class="spinner">
                        <div class="dot"></div>
                        <div class="dot"></div>
                        <div class="dot"></div>
                    </div>
                    <span>Loading data...</span>
                </div>
            </div>

            <!-- Pagination (Brief for Dashboard) -->
            <div class="pagination" v-if="partners.length > 0">
                <div class="pagination-info">
                    Showing <strong>{{ paginationStart }}</strong> to <strong>{{ paginationEnd }}</strong> of <strong>{{
                        partners.length }}</strong> partners
                </div>
                <div class="pagination-controls">
                    <button class="page-btn" :disabled="currentPage === 1" @click="currentPage--">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2">
                            <polyline points="15 18 9 12 15 6" />
                        </svg>
                    </button>
                    <span class="page-current">{{ currentPage }} / {{ totalPages }}</span>
                    <button class="page-btn" :disabled="currentPage === totalPages" @click="currentPage++">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2">
                            <polyline points="9 18 15 12 9 6" />
                        </svg>
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed, watch } from 'vue';
import { usePartnerStore , getFullImageUrl} from '@/modules/admin/stores/partners/partnersStore';
import { storeToRefs } from "pinia";
import router from '@/modules/router';
import Swal from 'sweetalert2';
import { useNotificationStore } from "@/store/notificationStore";
import CountUp from '@/components/common/VcCountUp/CountUp.vue';

const partnerStore = usePartnerStore();
const notificationStore = useNotificationStore();

const { loading } = storeToRefs(partnerStore);
const partners = computed(() => partnerStore.partners ?? []);

const keyword = ref("");
let searchTimeout: number | null = null;
const timeRange = ref('6');
const currentPage = ref(1);
const itemsPerPage = 8;

// innterface 
interface ChartOptions {
    chart: {
        type: string;
        height: number;
        background: string;
        foreColor: string;
        toolbar?: {
            show: boolean;
        };
    };
    theme: {
        mode: string;
    };
    plotOptions: {
        bar: {
            horizontal: boolean;
            borderRadius: number;
            dataLabels: {
                position: string;
            };
        };
    };
    colors: string[];
    dataLabels: {
        enabled: boolean;
        formatter: (val: number) => string;
        offsetY: number;
        style: {
            colors: string[];
        };
    };
    xaxis: {
        categories: string[];
        labels: {
            rotate: number;
            style: {
                colors: string;
            };
        };
    };
    yaxis: {
        labels: {
            formatter: (val: number) => string;
        };
    };
}
// Helper functions
function formatStatus(status: string): string {
    const statusMap: Record<string, string> = {
        'active': 'Active',
        'pending': 'Pending',
        'suspended': 'Suspended',
        'terminated': 'Terminated'
    };
    return statusMap[status] || status;
}

function getStatusClass(status: string): string {
    return `status--${status}`;
}

function formatDate(date: string | Date): string {
  if (!date) return ""

  const d = typeof date === "string" ? new Date(date) : date

  return d.toLocaleDateString("vi-VN")
}

const formatNumber = (n: number): string => {
  if (n >= 1_000_000) {
    return (n / 1_000_000).toFixed(1) + 'M';
  }
  if (n >= 1_000) {
    return (n / 1_000).toFixed(1) + 'K';
  }
  return String(n);
};

// Format tiền tệ (có ₫)
const formatCurrency = (n: number): string => {
  if (n >= 1_000_000_000) {
    return (n / 1_000_000_000).toFixed(2) + 'B ₫';
  }
  if (n >= 1_000_000) {
    return (n / 1_000_000).toFixed(1) + 'M ₫';
  }
  if (n >= 1_000) {
    return (n / 1_000).toFixed(0) + 'K ₫';
  }
  return n.toLocaleString() + ' ₫';
};
const getInitial = (name?: string) => {
  if (!name) return '?'
  return name.trim().charAt(0).toUpperCase()
}

const getAvatarColor = (name?: string) => {
    
  if (!name) return '#6b7280'; // Màu xám mặc định
  
  const colors = [
    '#f87171', // đỏ
    '#fb923c', // cam
    '#fbbf24', // vàng
    '#34d399', // xanh lá
    '#60a5fa', // xanh dương
    '#a78bfa', // tím
    '#f472b6'  // hồng
  ]

  let hash = 0
  for (let i = 0; i < name.length; i++) {
    hash = name.charCodeAt(i) + ((hash << 5) - hash)
  }

  return colors[Math.abs(hash) % colors.length]
}

const ViewAllPartners = () => {
    router.push({ name: "admin.partner.all" });
}

function viewDetailPartner(id: number) {
    router.push({
        name: "admin.partner.detail",
        params: { id }
    });
}


// Search function
const onSearch = () => {
    if (searchTimeout) clearTimeout(searchTimeout);
    searchTimeout = window.setTimeout(async () => {
        currentPage.value = 1;
        if (!keyword.value.trim()) {
            await partnerStore.fetchPartners();
            return;
        }
        await partnerStore.fetchSearchPartners(keyword.value);
    }, 300);
}


// change status function
const changePartnerStatus = async (id: number, currentStatus: string) => {
    const statusOptions = ['active', 'pending', 'suspended', 'terminated'];
    const currentIndex = statusOptions.indexOf(currentStatus);
    
    const { value: newStatus } = await Swal.fire({
        title: 'Change Partner Status',
        html: `Current status: <strong>${currentStatus}</strong>`,
        input: 'select',
        inputOptions: {
            'active': '✅ Active',
            'pending': '⏳ Pending', 
            'suspended': '⛔ Suspended',
            'terminated': '🔚 Terminated'
        },
        inputValue: currentStatus,
        showCancelButton: true,
        confirmButtonText: 'Update',
        confirmButtonColor: '#3b82f6',
        cancelButtonText: 'Cancel',
        cancelButtonColor: '#64748b',
        background: '#181c22',
        color: '#f0f4f8'
    });
    
    if (newStatus && newStatus !== currentStatus) {
        try {
            loading.value = true;
            await partnerStore.updatePartnerStatus(id, newStatus);
            await partnerStore.fetchPartners(); // Refresh list
            await partnerStore.fetchStatistics(); // Refresh stats
            notificationStore.notify(`Status changed to ${newStatus} successfully`, "success");
        } catch (error: any) {
            notificationStore.notify("Error changing status", "error");
        } finally {
            loading.value = false;
        }
    }
};

// Pagination computed
const totalPages = computed(() => Math.max(1, Math.ceil(partners.value.length / itemsPerPage)));
const paginationStart = computed(() => partners.value.length === 0 ? 0 : ((currentPage.value - 1) * itemsPerPage) + 1);
const paginationEnd = computed(() => Math.min(currentPage.value * itemsPerPage, partners.value.length));

const paginatedPartners = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    return partners.value.slice(start, end);
});

// Chart options (giữ nguyên)

const revenueChartOptions = ref({
    chart: {
        type: 'line',
        height: 380,
        background: 'transparent',
        foreColor: '#cbd5e1',
        toolbar: { show: true },
    },
    colors: ['#22c55e', '#ef4444', '#60a5fa'],
    stroke: {
        curve: 'smooth',
        width: 3,
    },
    grid: {
        borderColor: 'rgba(148, 163, 184, 0.15)',
        strokeDashArray: 4,
    },
   tooltip: {
        theme: 'dark',
        y: {
            formatter: (val: number) => formatCurrency(val)
        }
    },
    legend: {
        position: 'top',
        horizontalAlign: 'left',
        labels: {
            colors: '#e2e8f0'
        },
        itemMargin: {
            horizontal: 15
        }
    },
    xaxis: {
        categories: computed(() => {
            const monthlyStats = partnerStore.statistics?.monthly_stats || [];
            return monthlyStats.map(stat => stat.month);
        }),
        labels: {
            style: { colors: '#94a3b8' }
        }
    },
    yaxis: {
        labels: {
            style: { colors: '#94a3b8' },
            formatter: (val: number) => {
                return (val / 1_000_000).toFixed(1) + 'M ₫'
            }
        }
    }
});

const stackedChartOptions = ref({
    chart: {
        type: 'bar',
        stacked: true,
        background: 'transparent',
        foreColor: '#e5e7eb'
    },
    theme: { mode: 'dark' },
    plotOptions: {
        bar: { horizontal: false, borderRadius: 6 }
    },
    colors: ['#10b981', '#ef4444'],
    xaxis: {
        categories: computed(() => {
            const monthlyStats = partnerStore.statistics?.monthly_stats || [];
            return monthlyStats.map(stat => stat.month);
        }),
        labels: { style: { colors: '#9ca3af' } }
    },
    yaxis: {
        labels: { style: { colors: '#9ca3af' } }
    },
    grid: {
        borderColor: '#374151'
    },
    legend: {
        labels: { colors: '#e5e7eb' }
    }
});

const topPartnerCategories = computed(() => {
    const topPartners = partnerStore.statistics?.top_partners || [];
    return topPartners.map(p => p.company_name);
});

const topPartnerOptions = ref<ChartOptions>({
    chart: {
        type: 'bar',
        height: 350,
        background: 'transparent',
        foreColor: '#e5e7eb'
    },
    theme: { mode: 'dark' },
    plotOptions: {
        bar: {
            horizontal: false,
            borderRadius: 6,
            dataLabels: {
                position: 'top'
            }
        }
    },
    colors: ['#6366f1'],
    dataLabels: {
        enabled: true,
        formatter: (val: number) => formatCurrency(val),
        offsetY: -20,
        style: {
            colors: ['#e5e7eb']
        }
    },
    xaxis: {
        categories: [], // Bây giờ đã có type string[]
        labels: {
            rotate: -45,
            style: {
                colors: '#9ca3af'
            }
        }
    },
    yaxis: {
        labels: {
            formatter: (val: number) => formatCurrency(val)
        }
    }
});

const statusPieOptions = ref({
    chart: {
        type: 'donut',
        background: 'transparent',
        foreColor: '#e5e7eb'
    },
    theme: { mode: 'dark' },
    labels: ['Active', 'Pending', 'Suspended', 'Terminated'],
    colors: ['#10b981', '#f59e0b', '#ef4444', '#6b7280'],
    legend: {
        position: 'bottom',
        labels: { colors: '#e5e7eb' }
    },
    stroke: {
        colors: ['#111827']
    }
});


// Chart data
const revenueChartSeries = computed(() => {
  const monthlyStats = partnerStore.statistics?.monthly_stats || [];
  
  return [
    {
      name: 'Revenue',
      data: monthlyStats.map(stat => stat.revenue)
    },
    {
      name: 'Payment',
      data: monthlyStats.map(stat => stat.paid)
    },
    {
      name: 'Profit',
      data: monthlyStats.map(stat => stat.profit)
    }
  ];
});

const stackedChartSeries = computed(() => {
  const monthlyStats = partnerStore.statistics?.monthly_stats || [];
  
  return [
    { 
      name: 'Revenue', 
      data: monthlyStats.map(stat => stat.revenue) 
    },
    { 
      name: 'Payment', 
      data: monthlyStats.map(stat => stat.paid) 
    }
  ];
});

const topPartnerSeries = computed(() => {
  const topPartners = partnerStore.statistics?.top_partners || [];
  
  return [{
    name: 'Revenue',
    data: topPartners.map(partner => partner.total_revenue)
  }];
});

const statusPieSeries = computed(() => [
    partnerStore.statistics?.active_partners ?? 0,
    partnerStore.statistics?.pending_partners ?? 0,
    partnerStore.statistics?.suspended_partners ?? 0,
    partnerStore.statistics?.terminated_partners ?? 0
]);

// Fetch dữ liệu 
const fetchChartData = async () => {
    // Implement chart data fetching based on timeRange
}

watch(topPartnerCategories, (newCategories) => {
    if (topPartnerOptions.value && newCategories.length) {
        topPartnerOptions.value = {
            ...topPartnerOptions.value,
            xaxis: {
                ...topPartnerOptions.value.xaxis,
                categories: newCategories
            }
        };
    }
}, { immediate: true });

onMounted(() => {
    partnerStore.fetchPartners();
    partnerStore.fetchStatistics();
});
</script>

<style scoped>
.users-management {
    background-color: #0f1216;
    min-height: 100vh;
    padding: 32px 36px;
    font-family: 'DM Sans', system-ui, sans-serif;
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
    font-size: 26px;
    font-weight: 700;
    margin: 0;
    background: linear-gradient(90deg, #fff 30%, #00aaff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.subtitle {
    font-size: 13px;
    color: #64748b;
    margin-top: 4px;
}

.btn-add {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 20px;
    background: linear-gradient(90deg, #3b82f6, #2563eb);
    border: none;
    border-radius: 10px;
    color: #fff;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
}

.btn-add:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}

/* ── Stats Grid ── */
.stats-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 20px;
    margin-bottom: 30px;
}

.stat-card {
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.05);
    border-radius: 14px;
    padding: 24px 20px;
    display: flex;
    align-items: center;
    gap: 16px;
    border-top: 3px solid transparent;
    transition: transform 0.2s;
}

.stat-card:hover {
    transform: translateY(-4px);
    background: rgba(255, 255, 255, 0.05);
}

.stat-card--blue {
    border-top-color: #3b82f6;
}

.stat-card--green {
    border-top-color: #10b981;
}

.stat-card--purple {
    border-top-color: #8b5cf6;
}

.stat-card--orange {
    border-top-color: #f59e0b;
}

.stat-icon {
    width: 52px;
    height: 52px;
    border-radius: 12px;
    background: rgba(255, 255, 255, 0.05);
    display: flex;
    align-items: center;
    justify-content: center;
    color: #94a3b8;
}

.stat-info {
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.stat-label {
    font-size: 12px;
    color: #64748b;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.stat-value {
    font-size: 28px;
    font-weight: 700;
    color: #f1f5f9;
    line-height: 1.1;
}

.stat-change {
    font-size: 12px;
}

.stat-change.positive {
    color: #10b981;
}

.stat-change.negative {
    color: #ef4444;
}

/* ── Main List Box ── */
.users-list-page {
    background: #111418;
    border-radius: 16px;
    border: 1px solid #1e2530;
    padding: 24px;
}

.toolbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.section-title {
    font-size: 18px;
    font-weight: 600;
    color: #f1f5f9;
}

.toolbar__right {
    display: flex;
    align-items: center;
    gap: 12px;
}

.search-box {
    position: relative;
    display: flex;
    align-items: center;
}

.search-icon {
    position: absolute;
    left: 12px;
    color: #4a5568;
    pointer-events: none;
}

.search-box input {
    background: #181c22;
    border: 1px solid #2d3748;
    border-radius: 10px;
    padding: 9px 12px 9px 36px;
    color: #e2e8f0;
    font-size: 13px;
    width: 240px;
    outline: none;
    transition: all 0.2s;
}

.search-box input:focus {
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.btn-view-all {
    background: transparent;
    border: 1px solid rgba(59, 130, 246, 0.3);
    color: #3b82f6;
    padding: 8px 16px;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
}

.btn-view-all:hover {
    background: rgba(59, 130, 246, 0.05);
    border-color: #3b82f6;
}

/* ── Table ── */
.table-section {
    position: relative;
    background: #181c22;
    border-radius: 12px;
    border: 1px solid #252d3a;
    overflow: hidden;
}

.table-wrapper {
    overflow-x: auto;
}

.users-table {
    width: 100%;
    border-collapse: collapse;
    font-size: 13px;
}

.users-table thead tr {
    background: #1e2530;
    border-bottom: 1px solid #252d3a;
}

.users-table th {
    padding: 12px 16px;
    text-align: left;
    font-size: 11px;
    font-weight: 600;
    color: #94a3b8;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.users-table td {
    padding: 12px 16px;
    border-bottom: 1px solid #252d3a;
    vertical-align: middle;
}

.table-row:hover {
    background: rgba(255, 255, 255, 0.02);
}

.user-cell {
    display: flex;
    align-items: center;
    gap: 10px;
}

.user-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
  flex-shrink: 0;
  background: #1e2530;
}

.user-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}


.user-name {
    font-weight: 600;
    color: #f1f5f9;
    margin: 0;
}

.user-id {
    font-size: 11px;
    color: #64748b;
    margin: 0;
}

.td-text {
    color: #94a3b8;
}

.td-mono {
    font-family: ui-monospace, monospace;
}

.role-badge {
    display: inline-flex;
    padding: 3px 10px;
    border-radius: 6px;
    font-size: 10px;
    font-weight: 700;
    text-transform: uppercase;
    background: rgba(255, 255, 255, 0.05);
    color: #94a3b8;
}

.role-admin {
    background: rgba(239, 68, 68, 0.1);
    color: #f87171;
}

.role-partner {
    background: rgba(16, 185, 129, 0.1);
    color: #34d399;
}

.role-user_vip_yearly {
    background: rgba(245, 158, 11, 0.1);
    color: #fbbf24;
}

.status-btn {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 11px;
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

.td-actions {
    width: 120px;
}

.action-btns {
    display: flex;
    gap: 6px;
    justify-content: flex-end;
}

.act-btn {
    width: 28px;
    height: 28px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 8px;
    background: #1e2530;
    border: 1px solid #2d3748;
    color: #64748b;
    cursor: pointer;
    transition: all 0.2s;
}

.act-btn:hover {
    color: #f1f5f9;
    border-color: #4a5568;
    transform: translateY(-1px);
}

.act-btn--edit:hover {
    color: #3b82f6;
    border-color: #3b82f6;
    background: rgba(59, 130, 246, 0.05);
}

.act-btn--delete:hover {
    color: #ef4444;
    border-color: #ef4444;
    background: rgba(239, 68, 68, 0.05);
}

.act-btn--view:hover {
    color: #10b981;
    border-color: #10b981;
    background: rgba(16, 185, 129, 0.05);
}

/* ── Pagination ── */
.pagination {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 16px;
    font-size: 13px;
    color: #64748b;
}

.pagination-controls {
    display: flex;
    align-items: center;
    gap: 12px;
}

.page-btn {
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 8px;
    background: #181c22;
    border: 1px solid #2d3748;
    color: #64748b;
    cursor: pointer;
}

.page-btn:hover:not(:disabled) {
    border-color: #3b82f6;
    color: #3b82f6;
}

.page-btn:disabled {
    opacity: 0.3;
    cursor: not-allowed;
}

.loading-overlay {
    position: absolute;
    inset: 0;
    background: rgba(15, 18, 22, 0.7);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 12px;
    z-index: 10;
}

.spinner {
    display: flex;
    gap: 4px;
}

.dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #3b82f6;
    animation: bounce 1.4s infinite ease-in-out;
}

.dot:nth-child(1) {
    animation-delay: -0.32s;
}

.dot:nth-child(2) {
    animation-delay: -0.16s;
}

@keyframes bounce {

    0%,
    80%,
    100% {
        transform: scale(0);
    }

    40% {
        transform: scale(1.0);
    }
}

@media (max-width: 1024px) {
    .stats-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 640px) {
    .users-management {
        padding: 20px 16px;
    }

    .header {
        flex-direction: column;
        align-items: flex-start;
        gap: 16px;
    }

    .stats-grid {
        grid-template-columns: 1fr;
    }

    .toolbar {
        flex-direction: column;
        align-items: stretch;
        gap: 12px;
    }

    .search-box input {
        width: 100%;
    }
}

/* ==================== CHART CARD - GLASSMORPHISM ==================== */
.chart-card {
    background: rgba(255, 255, 255, 0.041);
    border-radius: 16px;
    padding: 24px;
    border: 1px solid rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(12px);
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
    transition: all 0.3s ease;
}

.chart-card:hover {
    background: rgba(255, 255, 255, 0.08);
    /* Tăng nhẹ độ mờ khi hover */
    border-color: rgba(255, 255, 255, 0.15);
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.3);
}

/* Tiêu đề chart */
.chart-card h3 {
    color: #e2e8f0;
    margin-bottom: 20px;
    font-weight: 600;
}

/* ==================== APEXCHARTS - Đảm bảo chữ dễ đọc ==================== */
.apexcharts-canvas {
    background: transparent !important;
}

.apexcharts-tooltip {
    background: rgba(15, 23, 42, 0.95) !important;
    /* Nền tooltip tối */
    color: #f1f5f9 !important;
    border: 1px solid rgba(148, 163, 184, 0.3) !important;
    border-radius: 8px;
    box-shadow: 0 10px 15px rgba(0, 0, 0, 0.3);
}

.apexcharts-tooltip-title {
    background: rgba(0, 0, 0, 0.3) !important;
    border-bottom: 1px solid rgba(148, 163, 184, 0.2) !important;
    color: #e2e8f0 !important;
}

.apexcharts-legend-text {
    color: #cbd5e1 !important;
}

.apexcharts-xaxis-label,
.apexcharts-yaxis-label {
    fill: #94a3b8 !important;
}

/* Hover trên data point (dot) */
.apexcharts-marker {
    transition: all 0.2s ease;
}

/* Legend hover */
.apexcharts-legend-series:hover .apexcharts-legend-text {
    color: #ffffff !important;
    font-weight: 500;
}

.user-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
}

.user-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.avatar-fallback {
  width: 100%;
  height: 100%;
  display: flex !important;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 16px;
  color: white !important;
  text-transform: uppercase;
  border-radius: 50%;
}
/* Stats Badges Container */
.stats-badges {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
}

/* Individual Stat Badge */
.stat-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 5px 10px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.08);
  font-size: 12px;
  font-weight: 500;
  color: #cbd5e1;
  white-space: nowrap;
  transition: all 0.2s ease;
  line-height: 1;
  min-width: fit-content;
}

.stat-badge:hover {
  background: rgba(255, 255, 255, 0.08);
  border-color: rgba(255, 255, 255, 0.15);
  transform: translateY(-1px);
}

.stat-badge svg {
  color: #64748b;
  flex-shrink: 0;
  transition: color 0.2s ease;
}

.stat-badge:hover svg {
  color: #94a3b8;
}

/* Responsive adjustments */
@media (max-width: 1200px) {
  .stats-badges {
    gap: 6px;
  }
  
  .stat-badge {
    padding: 4px 8px;
    font-size: 11px;
  }
}

@media (max-width: 768px) {
  .stats-badges {
    flex-direction: column;
    align-items: flex-start;
    gap: 4px;
  }
  
  .stat-badge {
    width: 100%;
    justify-content: flex-start;
  }
}
</style>
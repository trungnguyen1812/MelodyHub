<template>
    <div class="upgrade-page">
        <!-- Header -->
        <section class="upgrade-header">
            <div class="container">
                <div class="header-content">
                    <h1 class="header-title">Upgrade your MelodyHub account.</h1>
                    <p class="header-subtitle">Unlock all premium features and enjoy the ultimate music experience.</p>
                </div>
            </div>
        </section>


        <!-- Pricing Plans -->
        <section v-if="selectedPlan && showQR" class="qr-section">
            <div class="container">
                <div class="qr-container">
                    <!-- Back Button -->
                    <button class="back-btn" @click="cancelPayment">
                        <i class="fas fa-arrow-left"></i> Back to Plans
                    </button>

                    <!-- QR Code Card -->
                    <div class="qr-card">
                        <div class="qr-header">
                            <h2>Payment for {{ selectedPlan.display_name }}</h2>
                            <div class="plan-price-qr">
                                <span class="price">{{ formatPrice(selectedPlan.price) }}</span>
                                <span class="currency">{{ selectedPlan.currency }}</span>
                                <span class="period">{{ getPricePeriod(selectedPlan.duration_days) }}</span>
                            </div>
                        </div>

                        <!-- QR Code -->
                        <div class="qr-image-container">
                            <div v-if="loadingQR" class="qr-loading">
                                <div class="spinner"></div>
                                <p>Generating QR code...</p>
                            </div>
                            <div v-else-if="qrError" class="qr-error">
                                <i class="fas fa-exclamation-circle"></i>
                                <p>{{ qrError }}</p>
                                <button @click="generateQR(selectedPlan)" class="retry-btn">
                                    Retry
                                </button>
                            </div>
                            <div v-else class="qr-display">
                                <img :src="qrData.qr_url" alt="Payment QR Code" class="qr-img" />
                                <div class="qr-info">
                                    <div class="transfer-content">
                                        <span>Transfer Content:</span>
                                        <div class="content-box">
                                            <code>{{ qrData.content }}</code>
                                            <button @click="copyToClipboard(qrData.content)" class="copy-btn">
                                                <i class="fas fa-copy"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="payment-id">
                                        <span>Payment ID:</span>
                                        <strong>#{{ qrData.payment_id }}</strong>
                                    </div>
                                </div>
                            </div>
                        </div>

                       

                        <!-- Action Buttons -->
                        <div class="qr-actions">
                            
                            <button @click="shareQR" class="share-btn">
                                <i class="fas fa-share-alt"></i> Share
                            </button>
                        </div>

                        <!-- Status Message -->
                       
                    </div>
                </div>
            </div>
        </section>

        

        <!-- Pricing Plans Section (Hide when plan is selected) -->
        <section v-else class="pricing-section">
            <div class="container">
                <div class="pricing-grid">
                    <!-- Dynamic Plans -->
                    <div
                        class="pricing-card"
                        v-for="plan in userStore.subscriptionPlans"
                        :key="plan.id"
                        :class="getPlanClass(plan)"
                    >
                        <div class="plan-header">
                            <div class="plan-badge" :class="getBadgeClass(plan)">
                                {{ getBadgeText(plan) }}
                            </div>
                            
                            <h3 class="plan-name">{{ plan.display_name }}</h3>
                            
                            <div class="plan-price">
                                <span v-if="plan.price > 0" class="price-currency">$</span>
                                <span class="price-amount">
                                    {{ plan.price > 0 ? formatPrice(plan.price) : 'FREE OF CHARGE' }}
                                </span>
                                <span v-if="plan.price > 0" class="price-period">
                                    {{ getPricePeriod(plan.duration_days) }}
                                </span>
                            </div>
                            
                            <p class="plan-period">{{ plan.description }}</p>
                            
                            <div v-if="plan.price > 0 && plan.duration_days > 0" class="price-savings">
                                <span class="savings-text">
                                    {{ getDailyPrice(plan.price, plan.duration_days) }}
                                </span>
                            </div>
                        </div>
                        
                        <ul class="plan-features">
                            <!-- Audio Quality -->
                            <li>
                                <i :class="getFeatureIcon(plan.audio_quality !== 'standard')"></i>
                                {{ getAudioQualityText(plan.audio_quality) }}
                            </li>
                            
                            <!-- Ads -->
                            <li :class="{ 'disabled': !plan.ads_free }">
                                <i :class="getFeatureIcon(plan.ads_free)"></i>
                                {{ plan.ads_free ? 'No ads' : 'With ads' }}
                            </li>
                            
                            <!-- Playlists -->
                            <li :class="{ 'disabled': plan.max_playlists === 0 }">
                                <i :class="getFeatureIcon(plan.max_playlists > 0)"></i>
                                {{ getPlaylistText(plan.max_playlists) }}
                            </li>
                            
                            <!-- Songs per playlist -->
                            <li :class="{ 'disabled': plan.max_songs_per_playlist === 0 }">
                                <i :class="getFeatureIcon(plan.max_songs_per_playlist > 0)"></i>
                                {{ getSongsPerPlaylistText(plan.max_songs_per_playlist) }}
                            </li>
                            
                            <!-- Offline Downloads -->
                            <li :class="{ 'disabled': !plan.can_download }">
                                <i :class="getFeatureIcon(plan.can_download)"></i>
                                {{ getDownloadText(plan) }}
                            </li>
                            
                            <!-- Multiple Devices -->
                            <li :class="{ 'disabled': plan.max_devices <= 1 }">
                                <i :class="getFeatureIcon(plan.max_devices > 1)"></i>
                                {{ getDeviceText(plan.max_devices) }}
                            </li>
                            
                            <!-- Skip Unlimited -->
                            <li :class="{ 'disabled': !plan.can_skip_unlimited }">
                                <i :class="getFeatureIcon(plan.can_skip_unlimited)"></i>
                                {{ plan.can_skip_unlimited ? 'Unlimited skips' : 'Limited skips' }}
                            </li>
                            
                            <!-- Priority Support -->
                            <li :class="{ 'disabled': !plan.priority_support }">
                                <i :class="getFeatureIcon(plan.priority_support)"></i>
                                {{ plan.priority_support ? 'Priority support' : 'Standard support' }}
                            </li>
                            
                            <!-- Early Access -->
                            <li :class="{ 'disabled': !plan.early_access }">
                                <i :class="getFeatureIcon(plan.early_access)"></i>
                                {{ plan.early_access ? 'Early access to new features' : 'Standard access' }}
                            </li>
                            
                            <!-- Collaborative Playlist -->
                            <li :class="{ 'disabled': !plan.can_create_collaborative_playlist }">
                                <i :class="getFeatureIcon(plan.can_create_collaborative_playlist)"></i>
                                {{ plan.can_create_collaborative_playlist ? 'Collaborative playlists' : 'No collaborative playlists' }}
                            </li>
                        </ul>
                        
                        <button 
                            class="plan-button" 
                            :class="getButtonClass(plan)"
                            @click="selectPlan(plan)"
                        >
                            <i :class="getButtonIcon(plan)"></i>
                            {{ getButtonText(plan) }}
                        </button>
                        
                        
                        <div v-if="plan.original_price && plan.original_price > plan.price" class="price-comparison">
                            <p class="comparison-text">
                                <i class="fas fa-check-circle"></i>
                                Save ${{ formatPrice(plan.original_price - plan.price) }}
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </section>


        <!-- Feature Comparison -->
        <section class="comparison-section">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title">Detailed Plan Comparison</h2>
                    <p class="section-subtitle">See all the features you'll get</p>
                </div>

                <!-- Loading state -->
                <div v-if="userStore.loading" class="comparison-loading">
                    <div class="spinner"></div>
                    <p>Loading plans...</p>
                </div>

                <div v-else-if="sortedPlans.length > 0" class="comparison-table">
                    <table>
                        <thead>
                            <tr>
                                <th>Feature</th>
                                <th v-for="plan in sortedPlans" :key="plan.id">
                                    {{ plan.display_name }}
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Price</td>
                                <td v-for="plan in sortedPlans" :key="plan.id">
                                    <span v-if="plan.price === 0">Free</span>
                                    <span v-else>{{ formatPrice(plan.price) }} {{ plan.currency }}{{ getPricePeriod(plan.duration_days) }}</span>
                                </td>
                            </tr>
                            <tr>
                                <td>Audio quality</td>
                                <td v-for="plan in sortedPlans" :key="plan.id">
                                    {{ getAudioQualityText(plan.audio_quality) }}
                                </td>
                            </tr>
                            <tr>
                                <td>Offline downloads</td>
                                <td v-for="plan in sortedPlans" :key="plan.id">
                                    <i v-if="!plan.can_download" class="fas fa-times"></i>
                                    <span v-else-if="plan.max_offline_downloads >= 9999">Unlimited</span>
                                    <span v-else>{{ plan.max_offline_downloads }}</span>
                                </td>
                            </tr>
                            <tr>
                                <td>Ads</td>
                                <td v-for="plan in sortedPlans" :key="plan.id">
                                    <i v-if="!plan.ads_free" class="fas fa-times"></i>
                                    <span v-else>None</span>
                                </td>
                            </tr>
                            <tr>
                                <td>Playlists</td>
                                <td v-for="plan in sortedPlans" :key="plan.id">
                                    <i v-if="plan.max_playlists === 0" class="fas fa-times"></i>
                                    <span v-else-if="plan.max_playlists >= 9999">Unlimited</span>
                                    <span v-else>Up to {{ plan.max_playlists }}</span>
                                </td>
                            </tr>
                            <tr>
                                <td>Devices</td>
                                <td v-for="plan in sortedPlans" :key="plan.id">
                                    <span v-if="plan.max_devices >= 9999">Unlimited</span>
                                    <span v-else>{{ plan.max_devices }}</span>
                                </td>
                            </tr>
                            <tr>
                                <td>Unlimited skips</td>
                                <td v-for="plan in sortedPlans" :key="plan.id">
                                    <i :class="plan.can_skip_unlimited ? 'fas fa-check' : 'fas fa-times'"></i>
                                </td>
                            </tr>
                            <tr>
                                <td>Collaborative playlists</td>
                                <td v-for="plan in sortedPlans" :key="plan.id">
                                    <i :class="plan.can_create_collaborative_playlist ? 'fas fa-check' : 'fas fa-times'"></i>
                                </td>
                            </tr>
                            <tr>
                                <td>Customer support</td>
                                <td v-for="plan in sortedPlans" :key="plan.id">
                                    <span v-if="plan.priority_support">Priority</span>
                                    <span v-else>Standard</span>
                                </td>
                            </tr>
                            <tr>
                                <td>Early access</td>
                                <td v-for="plan in sortedPlans" :key="plan.id">
                                    <i :class="plan.early_access ? 'fas fa-check' : 'fas fa-times'"></i>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>


        <!-- FAQ Section -->
        <section class="faq-section">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title">Frequently Asked Questions</h2>
                </div>
                
                <div class="faq-grid">
                    <div class="faq-item">
                        <div class="faq-question" @click="toggleFaq(0)">
                            <h3>Do I need a credit card for the 7-day free trial?</h3>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer" v-if="activeFaq === 0">
                            <p>No! You can enjoy the 7-day free trial without providing any payment information. After the trial ends, your account will automatically switch to the free plan if you don’t upgrade.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question" @click="toggleFaq(1)">
                            <h3>Can I cancel my subscription at any time?</h3>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer" v-if="activeFaq === 1">
                            <p>Yes! You can cancel your Premium plan at any time. If you cancel mid-cycle, you’ll still have access until the end of your paid period.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question" @click="toggleFaq(2)">
                            <h3>What payment methods are supported?</h3>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer" v-if="activeFaq === 2">
                            <p>We support multiple payment methods, including credit/debit cards (Visa, MasterCard), e-wallets (MoMo, ZaloPay), bank transfers, and VNPay gateway.</p>
                        </div>
                    </div>
                    
                    <div class="faq-item">
                        <div class="faq-question" @click="toggleFaq(3)">
                            <h3>Can I switch from the monthly plan to the annual plan?</h3>
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <div class="faq-answer" v-if="activeFaq === 3">
                            <p>Yes! You can upgrade to the annual plan at any time. We’ll prorate the remaining balance from your current plan.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed ,onUnmounted} from 'vue'
import { useUserStore } from '@/modules/client/stores/users/UserStore';
import type { SubscriptionPlan } from '@/modules/client/interfaces/users/SubscriptionPlan';
import { useNotificationStore } from "@/store/notificationStore";   


const userStore = useUserStore()
const notificationStore = useNotificationStore();

// Sorted plans from store (by sort_order)
const sortedPlans = computed(() => userStore.sortedPlans)

// State
const isAnnual = ref(false)
const activeFaq = ref<number | null>(null)
const selectedPlan = ref<SubscriptionPlan | null>(null)
const showQR = ref(false)
const loadingQR = ref(false)

const qrError = ref<string | null>(null)
const qrData = ref({
    qr_url: '',
    content: '',
    payment_id: null as number | null
})


// Helper functions
const getPlanClass = (plan: SubscriptionPlan) => {
    return {
        'popular': plan.is_featured === true,
        'trial': plan.name === 'free',
    };
};

const getBadgeClass = (plan: SubscriptionPlan) => {
    if (plan.name === 'free') return 'trial'
    if (plan.is_featured) return 'popular'
    if (plan.trial_days > 0) return 'trial'
    return ''
}

const getBadgeText = (plan: SubscriptionPlan) => {
    if (plan.name === 'free') return 'Try it out'
    if (plan.is_featured) return 'Most popular'
    if (plan.trial_days > 0) return `${plan.trial_days}-day trial`
    return ''
}

const formatPrice = (price: number): string => {
    return price.toLocaleString('vi-VN')
}

const getPricePeriod = (days: number): string => {
    if (days === 30) return '/Month'
    if (days >= 365) return '/Year'
    if (days > 0) return `/${days} days`
    return ''
}

const getDailyPrice = (price: number, days: number): string => {
    if (days === 0) return ''
    const dailyPrice = (price / days).toFixed(2)
    return `Only ~ $${dailyPrice}/day`
}

const getFeatureIcon = (hasFeature: boolean): string => {
    return hasFeature ? 'fas fa-check' : 'fas fa-times'
}

const getAudioQualityText = (quality: string): string => {
    const qualityMap: Record<string, string> = {
        'standard': 'Standard quality',
        'high': 'High quality (320kbps)',
        'lossless': 'Lossless (FLAC)',
        'master': 'Master quality'
    }
    return qualityMap[quality] || 'Standard quality'
}

const getPlaylistText = (maxPlaylists: number): string => {
    if (maxPlaylists >= 9999) return 'Create unlimited playlists'
    if (maxPlaylists === 0) return 'Cannot create playlists'
    return `Create up to ${maxPlaylists} playlists`
}

const getSongsPerPlaylistText = (maxSongs: number): string => {
    if (maxSongs >= 9999) return 'Unlimited songs per playlist'
    if (maxSongs === 0) return 'Cannot add songs to playlists'
    return `Up to ${maxSongs} songs per playlist`
}

const getDownloadText = (plan: SubscriptionPlan): string => {
    if (!plan.can_download) return 'No offline downloads'
    if (plan.max_offline_downloads >= 9999) return 'Unlimited offline downloads'
    if (plan.max_offline_downloads === 0) return 'Limited offline downloads'
    return `${plan.max_offline_downloads} offline downloads`
}

const getDeviceText = (maxDevices: number): string => {
    if (maxDevices >= 9999) return 'Listen on unlimited devices'
    if (maxDevices <= 1) return 'Listen on 1 device'
    return `Listen on ${maxDevices} devices simultaneously`
}

const getButtonClass = (plan: SubscriptionPlan): string => {
    if (plan.name === 'free') return 'trial-btn'
    if (plan.is_featured) return 'primary-btn'
    return 'value-btn'
}

const getButtonIcon = (plan: SubscriptionPlan): string => {
    if (plan.name === 'free') return 'fas fa-play-circle'
    if (plan.is_featured) return 'fas fa-rocket'
    return 'fas fa-crown'
}

const getButtonText = (plan: SubscriptionPlan): string => {
    if (plan.name === 'free') return 'Start a trial'
    if (plan.is_featured) return 'Upgrade now'
    return 'Choose this plan'
}

const toggleBilling = () => { 
    isAnnual.value = !isAnnual.value
}

const toggleFaq = (index: number) => {
    activeFaq.value = activeFaq.value === index ? null : index
}

// Main payment function
const selectPlan = async (plan: SubscriptionPlan) => {
    if (plan.name === 'free') {
        notificationStore.notify('Free plan selected!', 'success')
        return
    }
    
    selectedPlan.value = plan
    showQR.value = true
    await generateQR(plan)
}

const generateQR = async (plan: SubscriptionPlan) => {
    loadingQR.value = true
    qrError.value = null
    qrData.value = {
        qr_url: '',
        content: '',
        payment_id: null
    }
    
    try {
        const res = await userStore.fetchCreateQR({
            subscription_plan_id: plan.id,
        })
        
        // used data from response, not from store
        qrData.value = {
            qr_url: res.qr_url || res.data?.qr_url || '',
            content: res.content || res.data?.content || '',
            payment_id: res.payment_id || res.data?.payment_id || null
        }
        
        notificationStore.notify('QR code generated! Scan to pay.', 'success')

        userStore.startCheckSubscription()
        
    } catch (err: any) {
        qrError.value = err.response?.data?.message || err.message || 'Failed to generate QR code'
        notificationStore.notify('Failed to generate QR code', 'error')
    } finally {
        loadingQR.value = false
    }
}

onUnmounted(() => {
    userStore.stopCheckSubscription()
})

const cancelPayment = () => {
    selectedPlan.value = null
    showQR.value = false
    qrError.value = null
    qrData.value = {
        qr_url: '',
        content: '',
        payment_id: null
    }
    userStore.stopCheckSubscription()
}

const copyToClipboard = async (text: string) => {
    try {
        await navigator.clipboard.writeText(text)
        notificationStore.notify('Copied to clipboard!', 'success')
    } catch (err) {
        notificationStore.notify('Failed to copy', 'error')
    }
}

const shareQR = () => {
    if (navigator.share && selectedPlan.value) {
        navigator.share({
            title: `Pay for ${selectedPlan.value.display_name}`,
            text: `Scan this QR to pay ${formatPrice(selectedPlan.value.price)} for MelodyHub`,
            url: window.location.href
        })
    } else {
        copyToClipboard(window.location.href)
    }
}



onMounted(() => {
    userStore.fetchSubscriptionPlans()
})
</script>

<style scoped>
.upgrade-page {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
    min-height: 100vh;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
}

/* Header Section */
.upgrade-header {

    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border: 1px solid rgba(252, 250, 250, 0.637);
    box-shadow: 0 8px 32px rgba(31, 38, 135, 0.15);
    color: rgba(255, 255, 255, 0.355);
    padding: 80px 0 60px;
    text-align: center;
    position: relative;
    overflow: hidden;
}

.upgrade-header::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: 
        radial-gradient(circle at 20% 50%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
        radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.08) 0%, transparent 50%);
}

.header-content {
    position: relative;
    z-index: 1;
    max-width: 800px;
    margin: 0 auto;
}

.header-title {
    font-size: 3rem;
    font-weight: 800;
    margin-bottom: 1rem;
    background: linear-gradient(45deg, #fff, #e0f2ff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.header-subtitle {
    font-size: 1.25rem;
    opacity: 0.9;
    margin-bottom: 40px;
    line-height: 1.6;
}

.billing-toggle {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 20px;
    margin-top: 40px;
    flex-wrap: wrap;
}

.toggle-label {
    font-size: 1.1rem;
    font-weight: 600;
}

.toggle-switch {
    width: 60px;
    height: 30px;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 15px;
    position: relative;
    cursor: pointer;
    transition: all 0.3s ease;
}

.toggle-switch:hover {
    background: rgba(255, 255, 255, 0.3);
}

.toggle-slider {
    position: absolute;
    top: 2px;
    left: 2px;
    width: 26px;
    height: 26px;
    background: white;
    border-radius: 50%;
    transition: transform 0.3s ease;
}

.toggle-slider.annual {
    transform: translateX(30px);
}

.discount-badge {
    background: #10b981;
    color: white;
    padding: 8px 16px;
    border-radius: 20px;
    font-size: 0.9rem;
    font-weight: 600;
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.05); }
}

/* Pricing Section */
.pricing-section {
    padding: 80px 0;
    margin-top: -40px;
}

.pricing-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
    gap: 30px;
    align-items: stretch;
}

.pricing-card {
    background: white;
    border-radius: 20px;
    padding: 40px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
    transition: all 0.3s ease;
    position: relative;
    display: flex;
    flex-direction: column;
}

.pricing-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 30px 80px rgba(0, 0, 0, 0.15);
}

.pricing-card.popular {
    border: 2px solid #1d4ed8;
    transform: scale(1.05);
}

.pricing-card.popular:hover {
    transform: scale(1.05) translateY(-10px);
}

.plan-header {
    text-align: center;
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 1px solid #e2e8f0;
}

.plan-badge {
    display: inline-block;
    padding: 8px 16px;
    border-radius: 20px;
    font-size: 0.9rem;
    font-weight: 600;
    margin-bottom: 20px;
}

.plan-badge.trial {
    background: #3b82f6;
    color: white;
}

.plan-badge.popular {
    background: #1d4ed8;
    color: white;
}

.plan-badge.value {
    background: linear-gradient(135deg, #f59e0b, #d97706);
    color: white;
}

.plan-name {
    font-size: 1.75rem;
    font-weight: 700;
    color: #1e293b;
    margin-bottom: 15px;
}

.plan-price {
    display: flex;
    align-items: baseline;
    justify-content: center;
    gap: 5px;
    margin-bottom: 10px;
}

.price-currency {
    font-size: 1.5rem;
    font-weight: 600;
    color: #64748b;
}

.price-amount {
    font-size: 3.5rem;
    font-weight: 800;
    color: #1e293b;
    line-height: 1;
}

.price-period {
    font-size: 1.1rem;
    color: #64748b;
    font-weight: 500;
}

.plan-period {
    color: #64748b;
    font-size: 1rem;
    margin-bottom: 15px;
}

.price-savings {
    margin-top: 10px;
}

.savings-text {
    background: #dcfce7;
    color: #166534;
    padding: 8px 16px;
    border-radius: 10px;
    font-size: 0.9rem;
    font-weight: 600;
}

.plan-features {
    list-style: none;
    margin: 30px 0;
    flex-grow: 1;
}

.plan-features li {
    display: flex;
    align-items: flex-start;
    margin-bottom: 15px;
    color: #475569;
    font-size: 0.95rem;
}

.plan-features i {
    margin-right: 12px;
    margin-top: 3px;
    min-width: 16px;
}

.plan-features .fa-check {
    color: #10b981;
}

.plan-features .fa-times {
    color: #ef4444;
}

.plan-features li.disabled {
    color: #94a3b8;
    text-decoration: line-through;
}

.plan-button {
    width: 100%;
    padding: 18px;
    border-radius: 12px;
    font-weight: 600;
    font-size: 1.1rem;
    cursor: pointer;
    transition: all 0.3s ease;
    border: none;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    margin-top: auto;
}

.trial-btn {
    background: linear-gradient(135deg, #3b82f6, #1d4ed8);
    color: white;
}

.trial-btn:hover {
    background: linear-gradient(135deg, #1d4ed8, #1e40af);
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(59, 130, 246, 0.3);
}

.primary-btn {
    background: linear-gradient(135deg, #1d4ed8, #7c3aed);
    color: white;
}

.primary-btn:hover {
    background: linear-gradient(135deg, #7c3aed, #1d4ed8);
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(124, 58, 237, 0.3);
}

.value-btn {
    background: linear-gradient(135deg, #f59e0b, #d97706);
    color: white;
}

.value-btn:hover {
    background: linear-gradient(135deg, #d97706, #b45309);
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(245, 158, 11, 0.3);
}

.plan-note {
    text-align: center;
    color: #64748b;
    font-size: 0.9rem;
    margin-top: 15px;
}

.price-comparison,
.price-breakdown {
    margin-top: 20px;
    text-align: center;
}

.comparison-text,
.breakdown-text {
    color: #1d4ed8;
    font-weight: 600;
    font-size: 0.95rem;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}

/* Comparison Table */
.comparison-section {
    padding: 80px 0;
}

.section-header {
    text-align: center;
    margin-bottom: 50px;
}

.section-title {
    font-size: 2.5rem;
    font-weight: 700;
    color: #ffffff;
    margin-bottom: 1rem;
}

.section-subtitle {
    font-size: 1.2rem;
    color: #545556;
}

.comparison-table {
    overflow-x: auto;
    border-radius: 15px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
}

.comparison-loading {
    text-align: center;
    padding: 60px 20px;
    color: rgba(255, 255, 255, 0.5);
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 16px;
    font-size: 1rem;
}

.comparison-table table {
    width: 100%;
    border-collapse: collapse;
    background: white;
}

.comparison-table th {
    background: linear-gradient(135deg, #1d4ed8, #7c3aed);
    color: white;
    padding: 20px;
    text-align: center;
    font-weight: 600;
    font-size: 1.1rem;
}

.comparison-table th:first-child {
    border-radius: 15px 0 0 0;
}

.comparison-table th:last-child {
    border-radius: 0 15px 0 0;
}

.comparison-table td {
    padding: 20px;
    text-align: center;
    border-bottom: 1px solid #e2e8f0;
    color: #475569;
}

.comparison-table tr:last-child td {
    border-bottom: none;
}

.comparison-table td:first-child {
    text-align: left;
    font-weight: 600;
    color: #1e293b;
    background: #f8fafc;
}

.comparison-table .fa-check {
    color: #10b981;
    font-size: 1.2rem;
}

.comparison-table .fa-times {
    color: #ef4444;
    font-size: 1.2rem;
}

/* FAQ Section */
.faq-section {
    padding: 80px 0;
}

.faq-grid {
    max-width: 800px;
    margin: 0 auto;
}

.faq-item {
    background: white;
    border-radius: 15px;
    margin-bottom: 15px;
    overflow: hidden;
    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
}

.faq-question {
    padding: 25px 30px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
    transition: background 0.3s ease;
}

.faq-question:hover {
    background: #f8fafc;
}

.faq-question h3 {
    font-size: 1.1rem;
    font-weight: 600;
    color: #1e293b;
    margin: 0;
}

.faq-question i {
    color: #1d4ed8;
    transition: transform 0.3s ease;
}

.faq-answer {
    padding: 0 30px 25px;
    color: #475569;
    line-height: 1.6;
    font-size: 0.95rem;
}

/* Responsive Design */
@media (max-width: 992px) {
    .pricing-card.popular {
        transform: none;
    }
    
    .pricing-card.popular:hover {
        transform: translateY(-10px);
    }
    
    .header-title {
        font-size: 2.5rem;
    }
}

@media (max-width: 768px) {
    .header-title {
        font-size: 2rem;
    }
    
    .header-subtitle {
        font-size: 1.1rem;
    }
    
    .price-amount {
        font-size: 2.8rem;
    }
    
    .pricing-grid {
        grid-template-columns: 1fr;
        max-width: 400px;
        margin: 0 auto;
    }
    
    .billing-toggle {
        flex-direction: column;
        gap: 15px;
    }
}

@media (max-width: 576px) {
    .pricing-card {
        padding: 30px 20px;
    }
    
    .plan-name {
        font-size: 1.5rem;
    }
    
    .price-amount {
        font-size: 2.5rem;
    }
    
    .comparison-table {
        font-size: 0.9rem;
    }
    
    .comparison-table th,
    .comparison-table td {
        padding: 15px 10px;
    }
}

.qr-section {
    padding: 60px 0;
    min-height: calc(100vh - 200px);
    display: flex;
    align-items: center;
}

.back-btn {
    background: rgba(255, 255, 255, 0.2);
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    gap: 8px;
    cursor: pointer;
    margin-bottom: 30px;
    transition: all 0.3s;
}

.back-btn:hover {
    background: rgba(255, 255, 255, 0.3);
    transform: translateX(-5px);
}

.qr-card {
    background: white;
    border-radius: 20px;
    padding: 40px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
    max-width: 500px;
    margin: 0 auto;
}

.qr-header {
    text-align: center;
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 1px solid #e5e7eb;
}

.qr-header h2 {
    color: #1f2937;
    margin-bottom: 10px;
    font-size: 1.8rem;
}

.plan-price-qr {
    display: flex;
    align-items: baseline;
    justify-content: center;
    gap: 5px;
    color: #4b5563;
}

.plan-price-qr .price {
    font-size: 2.5rem;
    font-weight: 800;
    color: #1f2937;
}

.plan-price-qr .currency {
    font-size: 1.5rem;
    font-weight: 600;
    margin-right: 5px;
}

.plan-price-qr .period {
    font-size: 1.1rem;
    color: #6b7280;
}

.qr-image-container {
    margin-bottom: 30px;
}

.qr-loading,
.qr-error {
    text-align: center;
    padding: 40px 20px;
}

.spinner {
    border: 4px solid #f3f3f3;
    border-top: 4px solid #667eea;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
    margin: 0 auto 20px;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

.qr-error {
    color: #ef4444;
}

.qr-error i {
    font-size: 3rem;
    margin-bottom: 15px;
}

.retry-btn {
    background: #667eea;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 6px;
    margin-top: 15px;
    cursor: pointer;
}

.qr-display {
    text-align: center;
}

.qr-img {
    display: block;
    width: 250px;
    height: 250px;
    margin: 0 auto 20px auto;

    border: 2px solid #e5e7eb;
    border-radius: 12px;
    padding: 15px;
    background: white;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}


.qr-info {
    background: #f9fafb;
    border-radius: 10px;
    padding: 20px;
    margin-top: 20px;
}

.transfer-content {
    margin-bottom: 15px;
}

.transfer-content span {
    display: block;
    font-weight: 600;
    color: #4b5563;
    margin-bottom: 8px;
}

.content-box {
    display: flex;
    align-items: center;
    gap: 10px;
    background: white;
    padding: 10px 15px;
    border-radius: 8px;
    border: 1px solid #e5e7eb;
}

.content-box code {
    flex: 1;
    font-family: 'Monaco', 'Courier New', monospace;
    font-size: 0.9rem;
    word-break: break-all;
    color: #1f2937;
}

.copy-btn {
    background: #264db9;
    color: white;
    border: none;
    width: 32px;
    height: 32px;
    border-radius: 6px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s;
}

.copy-btn:hover {
    background: #5a67d8;
    transform: scale(1.05);
}

.payment-id {
    display: flex;
    align-items: center;
    justify-content: space-between;
    color: #4b5563;
}

.payment-id strong {
    color: #1f2937;
    font-size: 1.1rem;
}

.instructions {
    background: #f0f9ff;
    border-radius: 12px;
    padding: 20px;
    margin-bottom: 30px;
}

.instructions h3 {
    color: #0369a1;
    margin-bottom: 15px;
    display: flex;
    align-items: center;
    gap: 8px;
}

.steps {
    list-style: none;
    padding-left: 0;
    margin: 0;
}

.steps li {
    padding: 8px 0;
    padding-left: 25px;
    position: relative;
    color: #4b5563;
}

.steps li:before {
    content: "✓";
    position: absolute;
    left: 0;
    color: #10b981;
    font-weight: bold;
}

.qr-actions {
    display: flex;
    gap: 12px;
    margin-bottom: 20px;
}

.check-btn,
.share-btn {
    flex: 1;
    padding: 12px;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    border: none;
    transition: all 0.2s;
}

.check-btn {
    background: #10b981;
    color: white;
}

.check-btn:hover:not(:disabled) {
    background: #059669;
    transform: translateY(-2px);
}

.check-btn:disabled {
    opacity: 0.7;
    cursor: not-allowed;
}

.share-btn {
    background: #264db9;
    color: white;
}

.share-btn:hover {
    background: #264db9ad;
    transform: translateY(-2px);
}

.status-message {
    padding: 15px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    gap: 10px;
    font-weight: 600;
}

.status-message.success {
    background: #d1fae5;
    color: #065f46;
    border: 1px solid #a7f3d0;
}

.status-message.pending {
    background: #fef3c7;
    color: #92400e;
    border: 1px solid #fde68a;
}

.status-message.failed {
    background: #fee2e2;
    color: #991b1b;
    border: 1px solid #fecaca;
}

/* Responsive */
@media (max-width: 768px) {
    .qr-card {
        padding: 25px;
    }
    
    .qr-img {
        width: 200px;
        height: 200px;
    }
    
    .content-box {
        flex-direction: column;
        align-items: stretch;
    }
    
    .copy-btn {
        align-self: flex-end;
        width: 100%;
        margin-top: 10px;
    }
    
    .qr-actions {
        flex-direction: column;
    }
}
</style>
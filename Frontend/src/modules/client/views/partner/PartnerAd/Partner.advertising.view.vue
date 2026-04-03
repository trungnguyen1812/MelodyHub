<template>
  <div class="partner-dashboard">
    <div class="container">
      <!-- Header -->
      <div class="header">
        <h1 class="title">Welcome back, {{ partnerName }}</h1>
        <p class="subtitle">Please select your partner type to continue</p>
      </div>

      <!-- 2 Cards Selection -->
      <div class="cards-container">
        <!-- Music Distribution Partner Card -->
        <div 
          class="partner-card music-card"
          :class="{ selected: selectedType === 'music' }"
          @click="selectPartnerType('music')"
        >
          <div class="card-glow"></div>
          <div class="card-content">
            <div class="icon-wrapper">
              <svg class="card-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3"></path>
              </svg>
            </div>
            <h2 class="card-title">Music Distribution</h2>
            <p class="card-description">
              Manage your music catalog, track releases, and monitor streaming performance
            </p>
            <div class="card-stats">
              <div class="stat">
                <span class="stat-value">{{ musicStats.releases }}</span>
                <span class="stat-label">Active Releases</span>
              </div>
              <div class="stat">
                <span class="stat-value">{{ musicStats.streams }}+</span>
                <span class="stat-label">Total Streams</span>
              </div>
            </div>
            <button class="select-btn">
              {{ selectedType === 'music' ? 'Selected' : 'Select' }}
              <svg v-if="selectedType === 'music'" class="check-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
              </svg>
            </button>
          </div>
        </div>

        <!-- Advertising Partner Card -->
        <div 
          class="partner-card ad-card"
          :class="{ selected: selectedType === 'ad' }"
          @click="selectPartnerType('ad')"
        >
          <div class="card-glow"></div>
          <div class="card-content">
            <div class="icon-wrapper">
              <svg class="card-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M11 3.055A9.001 9.001 0 1020.945 13H11V3.055zM20.488 9H15V3.512A9.001 9.001 0 0120.488 9zM3 12a9 9 0 109-9" />
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 12l3-3" />
              </svg>
            </div>
            <h2 class="card-title">Advertising Partner</h2>
            <p class="card-description">
              Manage ad campaigns, track impressions, and optimize your marketing ROI
            </p>
            <div class="card-stats">
              <div class="stat">
                <span class="stat-value">{{ adStats.campaigns }}</span>
                <span class="stat-label">Active Campaigns</span>
              </div>
              <div class="stat">
                <span class="stat-value">{{ adStats.impressions }}+</span>
                <span class="stat-label">Impressions</span>
              </div>
            </div>
            <button class="select-btn">
              {{ selectedType === 'ad' ? 'Selected' : 'Select' }}
              <svg v-if="selectedType === 'ad'" class="check-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
              </svg>
            </button>
          </div>
        </div>
      </div>

      <!-- Continue Button -->
      <div class="action-footer" v-if="selectedType">
        <button class="continue-btn" @click="continueToDashboard">
          Continue to {{ selectedType === 'music' ? 'Music Distribution' : 'Advertising' }} Dashboard
          <svg class="arrow-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3"></path>
          </svg>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PartnerDashboard',
  data() {
    return {
      partnerName: 'Partner',
      selectedType: null, // 'music' or 'ad'
      musicStats: {
        releases: 24,
        streams: '1.2M'
      },
      adStats: {
        campaigns: 8,
        impressions: '2.5M'
      }
    }
  },
  methods: {
    selectPartnerType(type) {
      this.selectedType = type
    },
    continueToDashboard() {
      if (this.selectedType === 'music') {
        // Navigate to Music Distribution Dashboard
        this.$router.push('/partner/music-dashboard')
      } else if (this.selectedType === 'ad') {
        // Navigate to Advertising Dashboard
        this.$router.push('/partner/ad-dashboard')
      }
    }
  }
}
</script>

<style scoped>
.partner-dashboard {
  min-height: 100vh;
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}

.container {
  max-width: 1200px;
  width: 100%;
}

/* Header Styles */
.header {
  text-align: center;
  margin-bottom: 4rem;
}

.title {
  font-size: 2.5rem;
  font-weight: 700;
  background: linear-gradient(135deg, #fff 0%, #94a3b8 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 0.5rem;
}

.subtitle {
  color: #94a3b8;
  font-size: 1.1rem;
}

/* Cards Container */
.cards-container {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 2rem;
  margin-bottom: 3rem;
}

/* Partner Card Styles */
.partner-card {
  position: relative;
  background: rgba(30, 41, 59, 0.5);
  backdrop-filter: blur(10px);
  border-radius: 2rem;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 2px solid rgba(255, 255, 255, 0.1);
  overflow: hidden;
}

.partner-card:hover {
  transform: translateY(-8px);
  border-color: rgba(255, 255, 255, 0.3);
}

.partner-card.selected {
  border-color: #3b82f6;
  background: rgba(59, 130, 246, 0.1);
  box-shadow: 0 0 30px rgba(59, 130, 246, 0.3);
}

.music-card.selected .card-glow {
  background: radial-gradient(circle at 50% 0%, rgba(59, 130, 246, 0.4), transparent);
}

.ad-card.selected .card-glow {
  background: radial-gradient(circle at 50% 0%, rgba(139, 92, 246, 0.4), transparent);
}

.card-glow {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 100%;
  pointer-events: none;
  transition: opacity 0.3s ease;
  opacity: 0;
}

.partner-card.selected .card-glow {
  opacity: 1;
}

.card-content {
  padding: 2rem;
  position: relative;
  z-index: 1;
}

.icon-wrapper {
  width: 80px;
  height: 80px;
  background: rgba(59, 130, 246, 0.1);
  border-radius: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 1.5rem;
}

.music-card .icon-wrapper {
  background: rgba(59, 130, 246, 0.1);
}

.ad-card .icon-wrapper {
  background: rgba(139, 92, 246, 0.1);
}

.card-icon {
  width: 48px;
  height: 48px;
  stroke-width: 1.5;
}

.music-card .card-icon {
  color: #3b82f6;
  stroke: #3b82f6;
}

.ad-card .card-icon {
  color: #8b5cf6;
  stroke: #8b5cf6;
}

.card-title {
  font-size: 1.75rem;
  font-weight: 700;
  color: white;
  margin-bottom: 0.75rem;
}

.card-description {
  color: #94a3b8;
  line-height: 1.6;
  margin-bottom: 1.5rem;
}

.card-stats {
  display: flex;
  gap: 1.5rem;
  margin-bottom: 1.5rem;
  padding: 1rem 0;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.stat {
  display: flex;
  flex-direction: column;
}

.stat-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: white;
}

.stat-label {
  font-size: 0.875rem;
  color: #64748b;
}

.select-btn {
  width: 100%;
  padding: 0.875rem;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 1rem;
  color: white;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.partner-card.selected .select-btn {
  background: #3b82f6;
  border-color: #3b82f6;
}

.ad-card.selected .select-btn {
  background: #8b5cf6;
  border-color: #8b5cf6;
}

.select-btn:hover {
  background: rgba(255, 255, 255, 0.1);
  transform: scale(0.98);
}

.check-icon {
  width: 1.25rem;
  height: 1.25rem;
}

/* Continue Button */
.action-footer {
  display: flex;
  justify-content: center;
}

.continue-btn {
  padding: 1rem 2rem;
  background: linear-gradient(135deg, #3b82f6, #8b5cf6);
  border: none;
  border-radius: 2rem;
  color: white;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: inline-flex;
  align-items: center;
  gap: 0.75rem;
}

.continue-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(59, 130, 246, 0.3);
}

.arrow-icon {
  width: 1.25rem;
  height: 1.25rem;
}

/* Responsive */
@media (max-width: 768px) {
  .cards-container {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
  
  .title {
    font-size: 1.75rem;
  }
  
  .card-content {
    padding: 1.5rem;
  }
  
  .icon-wrapper {
    width: 60px;
    height: 60px;
  }
  
  .card-icon {
    width: 36px;
    height: 36px;
  }
  
  .card-title {
    font-size: 1.5rem;
  }
}
</style>
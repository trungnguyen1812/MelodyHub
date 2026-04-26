<template>
  <div class="wizard-shell">
    <div class="bg-grid"></div>
    <!-- Topbar -->
    <div class="topbar">
      <button class="back-btn" @click="$router.back()">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M7.793 2.232a.75.75 0 0 1-.025 1.06L3.622 7.25h10.003a5.375 5.375 0 0 1 0 10.75H10.75a.75.75 0 0 1 0-1.5h2.875a3.875 3.875 0 0 0 0-7.75H3.622l4.146 3.957a.75.75 0 0 1-1.036 1.085l-5.5-5.25a.75.75 0 0 1 0-1.085l5.5-5.25a.75.75 0 0 1 1.06.025Z" clip-rule="evenodd" />
        </svg>
        Back
      </button>
      <button class="back-btn" @click="resetForm">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"/>
          <path d="M21 3v5h-5M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 0-6.74-2.74L3 16"/>
          <path d="M3 21v-5h5"/>
        </svg>
        <span>Reset</span>
      </button>
      <div class="topbar-title">
        <span class="topbar-label">Edit Campaign</span>
      </div>
      <div class="step-pills">
        <div
          v-for="(step, idx) in steps"
          :key="idx"
          class="step-pill"
          :class="{ active: currentStep === idx, done: currentStep > idx }"
          @click="currentStep > idx ? goToStep(idx) : null"
        >
          <span class="pill-num">
            <span v-if="currentStep > idx">✓</span>
            <span v-else>{{ idx + 1 }}</span>
          </span>
          <span class="pill-label">{{ step.label }}</span>
        </div>
      </div>
    </div>
    <!-- Progress Bar -->
    <div class="progress-bar">
      <div class="progress-fill" :style="{ width: `${(currentStep + 1) * (100 / steps.length)}%` }"></div>
    </div>
    <!-- Body -->
    <div class="wizard-body">
      <transition name="slide-fade" mode="out-in">
        <div :key="currentStep" class="step-panel">
          <!-- ══ STEP 1: Basic ══ -->
          <div v-if="currentStep === 0" class="info-layout">
            <div class="cover-col">
              <div class="cover-uploader" @click="triggerFileUpload">
                <img v-if="form.thumbnail_url" :src="form.thumbnail_url" class="cover-img" alt="Thumbnail" />
                <div v-else class="cover-placeholder">
                  <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2">
                    <rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="M21 15l-5-5L5 21"/>
                  </svg>
                  <span>Upload Poster</span>
                </div>
                <div v-if="form.thumbnail_url" class="cover-overlay">
                  <p class="cover-hint">1200×1200px recommended<br>Max 5MB · JPG / PNG</p>
                  <div class="artist-display" v-if="form.partner_id">
                    <span class="artist-label">Partner</span>
                    <span class="artist-name">{{ partnerName }}</span>
                  </div>
                </div>
              </div>
            </div>
            <div class="fields-col">
              <div class="field">
                <label class="field-label required">Campaign Name</label>
                <input v-model="form.name" type="text" class="field-control" :class="{ error: errors.name }" placeholder="e.g., Summer Sale 2025" />
                <span v-if="errors.name" class="field-hint error">{{ errors.name }}</span>
              </div>
              <div class="field-row two-col">
                <div class="field">
                  <label class="field-label required">Ad Type</label>
                  <select v-model="form.type" class="field-control" :class="{ error: errors.type }">
                    <option value="">Select type</option>
                    <option value="audio">🎵 Audio</option>
                    <option value="banner">🖼 Banner</option>
                    <option value="video">🎬 Video</option>
                    <option value="sponsored_content">📝 Sponsored Content</option>
                  </select>
                  <span v-if="errors.type" class="field-hint error">{{ errors.type }}</span>
                </div>
                <div class="field">
                  <label class="field-label">Advertising Partner</label>
                  <div class="field-control" style="background:rgba(255,255,255,0.02);color:rgba(255,255,255,0.5)">
                    {{ partnerName }}
                  </div>
                </div>
              </div>
              <div class="field">
                <label class="field-label required">Advertiser Name</label>
                <input v-model="form.advertiser_name" type="text" class="field-control" :class="{ error: errors.advertiser_name }" placeholder="e.g., Nike Vietnam" />
                <span v-if="errors.advertiser_name" class="field-hint error">{{ errors.advertiser_name }}</span>
              </div>
              <div class="field">
                <label class="field-label">Advertiser Website</label>
                <input v-model="form.advertiser_url" type="url" class="field-control" placeholder="https://example.com" />
              </div>
            </div><!-- /fields-col -->
          </div><!-- /info-layout -->

          <!-- Các step còn lại giữ nguyên (Media, Target, Budget, Display, Schedule, Review) -->
          <!-- STEP 2: Media -->
          <div v-if="currentStep === 1" class="fields-col">
            <div class="field">
              <label class="field-label required">Media Content</label>
              <div class="url-input-wrap">
                <span class="url-icon">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/>
                    <path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>
                  </svg>
                </span>
                <input v-model="form.media_url" type="url" class="field-control url-field" :class="{ error: errors.media_url }" placeholder="Enter URL or upload file below..." @blur="detectMediaMeta" />
                <button class="back-btn" style="margin:4px;border-radius:6px;padding:4px 10px;font-size:11px" @click="triggerMediaUpload">
                  Upload File
                </button>
              </div>
              <span v-if="errors.media_url" class="field-hint error">{{ errors.media_url }}</span>
              <div v-if="form.type" class="media-type-hint">
                <span class="mtag" :class="form.type">
                  {{ mediaTypeLabel }}
                </span>
                <span class="field-hint" style="margin:0">
                  {{ mediaTypeDesc }}
                </span>
              </div>
            </div>
            <div v-if="form.duration || form.file_size" class="auto-detect-box">
              <div class="auto-detect-title">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <circle cx="12" cy="12" r="10"/><path d="M12 8v4l3 3"/>
                </svg>
                Auto-detected from file
              </div>
              <div class="auto-detect-row">
                <div v-if="form.duration" class="auto-detect-item">
                  <span class="ad-label">Duration</span>
                  <span class="ad-val">{{ form.duration }}s</span>
                </div>
                <div v-if="form.file_size" class="auto-detect-item">
                  <span class="ad-label">File size</span>
                  <span class="ad-val">{{ formatBytes(form.file_size) }}</span>
                </div>
              </div>
            </div>
            <div v-if="detectingMedia" class="detecting-box">
              <span class="detecting-spinner"></span>
              Analysing media file…
            </div>
            <div class="field">
              <label class="field-label required">Click-through URL</label>
              <div class="url-input-wrap">
                <span class="url-icon">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/>
                    <polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/>
                  </svg>
                </span>
                <input v-model="form.click_url" type="url" class="field-control url-field" :class="{ error: errors.click_url }" placeholder="https://your-landing-page.com/promo" />
              </div>
              <span v-if="errors.click_url" class="field-hint error">{{ errors.click_url }}</span>
              <span class="field-hint">When users click the ad, they'll be taken to this URL — your product or promotion page.</span>
            </div>
          </div>

          <!-- STEP 3: Targeting (giữ nguyên) -->
          <div v-if="currentStep === 2" class="fields-col">
            <div class="info-banner">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4M12 8h.01"/></svg>
              Your ad will only show to users who match <strong>all</strong> of these criteria. Leave blank to target everyone.
            </div>
            <div class="field-row two-col">
              <div class="field">
                <label class="field-label">Age Range</label>
                <div class="range-pair">
                  <input v-model.number="form.target_age_min" type="number" class="field-control" placeholder="Min (13)" min="13" max="65" />
                  <span class="range-pair-sep">—</span>
                  <input v-model.number="form.target_age_max" type="number" class="field-control" placeholder="Max (65)" min="13" max="65" />
                </div>
              </div>
              <div class="field">
                <label class="field-label">Gender</label>
                <div class="seg-control">
                  <button v-for="g in genderOptions" :key="g.value" class="seg-btn" :class="{ active: form.target_gender === g.value }" @click="form.target_gender = g.value" type="button">
                    {{ g.label }}
                  </button>
                </div>
              </div>
            </div>
            <div class="field">
              <label class="field-label">Target Countries</label>
              <div class="country-grid dark-multiselect-wrapper">
                <multiselect
                    v-model="selectedCountries"
                    :options="countries"
                    :multiple="true"
                    :close-on-select="false"
                    :clear-on-select="false"
                    placeholder="Select country..."
                    label="name"
                    track-by="code"
                    :searchable="true"
                  >
                    <template #option="{ option }">
                      <span>{{ option.flag }} {{ option.name }}</span>
                    </template>
                    <template #tag="{ option, remove }">
                      <span class="multiselect__tag">
                        {{ option.flag }} {{ option.name }}
                        <i @click="remove(option)">×</i>
                      </span>
                    </template>
                  </multiselect>
              </div>
            </div>
            <div class="field">
              <label class="field-label">Target Music Genres</label>
              <p class="field-hint" style="margin-top:0">Ad will play when user is listening to these genres.</p>
              <div class="genre-grid">
                <label v-for="g in genres" :key="g.id" class="genre-chip" :class="{ selected: form.target_genres.includes(g.id) }">
                  <input type="checkbox" :value="g.id" v-model="form.target_genres" hidden />
                  {{ g.name }}
                </label>
              </div>
            </div>
          </div>

          <!-- STEP 4: Budget (giữ nguyên) -->
          <div v-if="currentStep === 3" class="fields-col">
            <div class="wallet-card" :class="{ warning: walletWarning, danger: walletDanger }">
              <div class="wallet-icon">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                  <path d="M21 12V7H5a2 2 0 0 1 0-4h14v4"/>
                  <path d="M3 5v14a2 2 0 0 0 2 2h16v-5"/>
                  <path d="M18 12a2 2 0 0 0 0 4h4v-4z"/>
                </svg>
              </div>
              <div class="wallet-body">
                <span class="wallet-label">Available wallet balance</span>
                <span class="wallet-amount">${{ walletBalance.toFixed(2) }}</span>
              </div>
              <div v-if="walletWarning && !walletDanger" class="wallet-alert warning">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
                Budget exceeds 80% of balance
              </div>
              <div v-if="walletDanger" class="wallet-alert danger">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                Insufficient balance — top up wallet first
              </div>
            </div>
            <div class="field">
              <label class="field-label required">Total Budget</label>
              <div class="input-prefix">
                <span>$</span>
                <input v-model.number="form.budget_total" type="number" class="field-control" style="border-radius:0 9px 9px 0" min="0" step="1" placeholder="0" :class="{ error: errors.budget_total }" />
              </div>
              <div v-if="form.budget_total && !walletDanger" class="budget-estimate">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
                Estimated {{ estimatedPlays.toLocaleString() }} plays at current CPM
              </div>
              <span v-if="errors.budget_total" class="field-hint error">{{ errors.budget_total }}</span>
            </div>
            <div class="field">
              <label class="field-label">
                Priority Tier
                <span class="field-hint" style="margin:0; font-size:11px; text-transform:none; font-weight:400"> — determines minimum CPM rate</span>
              </label>
              <div class="tier-cards">
                <div v-for="tier in priorityTiers" :key="tier.value" class="tier-card" :class="{ active: form.priorityTier === tier.value }" @click="selectTier(tier)">
                  <div class="tier-badge" :style="{ background: tier.color + '22', color: tier.color, border: `1px solid ${tier.color}44` }">{{ tier.label }}</div>
                  <div class="tier-cpm">Min CPM <strong>${{ tier.minCpm.toFixed(4) }}</strong></div>
                  <div class="tier-desc">{{ tier.desc }}</div>
                  <div class="tier-priority">Priority 0–{{ tier.maxPriority }}</div>
                </div>
              </div>
            </div>
            <div class="field-row two-col">
              <div class="field">
                <label class="field-label">
                  Cost Per Play (CPM)
                  <span v-if="cpmWarning" class="cpm-floor-badge">Floor: ${{ currentTier.minCpm.toFixed(4) }}</span>
                </label>
                <div class="input-prefix" :class="{ 'has-error': cpmWarning }">
                  <span>$</span>
                  <input v-model.number="form.cost_per_play" type="number" class="field-control" style="border-radius:0 9px 9px 0" min="0" step="0.0001" :placeholder="currentTier.minCpm.toFixed(4)" @blur="enforceCpmFloor" />
                </div>
                <span v-if="cpmWarning" class="field-hint error">Below minimum for {{ currentTier.label }} tier (${{ currentTier.minCpm.toFixed(4) }})</span>
                <span v-else class="field-hint">Cost per audio/video play</span>
              </div>
              <div class="field">
                <label class="field-label">
                  Cost Per Click (CPC)
                  <span v-if="cpcWarning" class="cpm-floor-badge">Floor: ${{ currentTier.minCpc.toFixed(4) }}</span>
                </label>
                <div class="input-prefix" :class="{ 'has-error': cpcWarning }">
                  <span>$</span>
                  <input v-model.number="form.cost_per_click" type="number" class="field-control" style="border-radius:0 9px 9px 0" min="0" step="0.0001" :placeholder="currentTier.minCpc.toFixed(4)" @blur="enforceCpcFloor" />
                </div>
                <span v-if="cpcWarning" class="field-hint error">Below minimum for {{ currentTier.label }} tier</span>
                <span v-else class="field-hint">Cost per user click (optional)</span>
              </div>
            </div>
          </div>

          <!-- STEP 5: Display Controls (giữ nguyên) -->
          <div v-if="currentStep === 4" class="fields-col">
            <div class="vis-section">
              <h3 class="vis-section-title">Playback limits per user per day</h3>
              <div class="field">
                <label class="field-label">
                  Max plays
                  <span class="badge-info">{{ form.max_plays_per_user_per_day }}×</span>
                </label>
                <input v-model.number="form.max_plays_per_user_per_day" type="range" class="field-control" style="padding:0; accent-color:#00aaff" min="1" max="20" step="1" />
                <div class="range-labels"><span>1</span><span>20</span></div>
                <span class="field-hint">Max number of times the audio/video ad <em>plays</em> for one user today.</span>
              </div>
              <div class="field" style="margin-top:14px">
                <label class="field-label">
                  Frequency cap (impressions)
                  <span class="badge-info">{{ form.frequency_cap }}×</span>
                </label>
                <input v-model.number="form.frequency_cap" type="range" class="field-control" style="padding:0; accent-color:#00aaff" min="1" max="30" step="1" />
                <div class="range-labels"><span>1</span><span>30</span></div>
                <span class="field-hint">Max times this ad <em>appears</em> (impressions) for one user today. Includes banners that don't play.</span>
              </div>
              <div class="diff-box">
                <div class="diff-row">
                  <span class="diff-icon play">▶</span>
                  <div><strong>Max plays</strong> — user actively hears/watches the ad</div>
                </div>
                <div class="diff-row">
                  <span class="diff-icon eye">👁</span>
                  <div><strong>Frequency cap</strong> — ad appears on screen (banner counts too)</div>
                </div>
              </div>
            </div>
            <div class="priority-display">
              <div class="pd-header">
                <span class="pd-label">Priority level from selected tier</span>
                <span class="pd-tier-badge" :style="{ background: currentTier.color + '22', color: currentTier.color }">
                  {{ currentTier.label }}
                </span>
              </div>
              <input v-model.number="form.priority" type="range" class="field-control" style="padding:0" :style="{ accentColor: currentTier.color }" min="0" :max="currentTier.maxPriority" step="1" />
              <div class="range-labels">
                <span>0</span>
                <span class="pd-current">{{ form.priority }} / {{ currentTier.maxPriority }}</span>
                <span>{{ currentTier.maxPriority }}</span>
              </div>
              <p class="field-hint" style="margin-top:4px">Fine-tune within your tier. Higher tier = higher ceiling = more visibility.</p>
            </div>
            <div class="toggle-row">
              <div class="toggle-card" :class="{ on: showDateRange }" @click="toggleDateRange">
                <div class="toggle-thumb" :class="{ on: showDateRange }"></div>
                <div class="toggle-body">
                  <span class="toggle-name">Set campaign end date</span>
                  <span class="toggle-desc">Leave off to run indefinitely until budget runs out</span>
                </div>
                <span class="toggle-badge" :class="{ on: showDateRange }">
                  {{ showDateRange ? 'ON' : 'OFF' }}
                </span>
              </div>
            </div>
          </div>

          <!-- STEP 6: Schedule (giữ nguyên) -->
          <div v-if="currentStep === 5" class="fields-col">
            <div class="field-row two-col">
              <div class="field">
                <label class="field-label required">Start Date</label>
                <input v-model="form.start_date" type="date" class="field-control" :class="{ error: errors.start_date }" :min="today" />
                <span v-if="errors.start_date" class="field-hint error">{{ errors.start_date }}</span>
              </div>
              <div class="field">
                <label class="field-label">End Date</label>
                <input v-model="form.end_date" type="date" class="field-control" :min="form.start_date || today" :disabled="!showDateRange" :style="!showDateRange ? 'opacity:.4;cursor:not-allowed' : ''" />
                <span class="field-hint">{{ showDateRange ? 'Campaign stops on this date.' : 'No end date — runs until budget is exhausted.' }}</span>
              </div>
            </div>
            <div v-if="form.start_date && form.end_date && showDateRange" class="campaign-duration">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/>
              </svg>
              Campaign duration: <strong>{{ campaignDays }} days</strong>
              <span v-if="form.budget_total && form.cost_per_play" class="dur-extra">
                · ~{{ dailySpend }} / day
              </span>
            </div>
            <div v-if="!showDateRange" class="indefinite-note">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 22c5.523 0 10-4.477 10-10S17.523 2 12 2 2 6.477 2 12s4.477 10 10 10z"/>
                <path d="M12 8v4l3 3"/>
              </svg>
              Campaign runs until <strong>${{ form.budget_total || 0 }}</strong> budget is fully spent.
            </div>
          </div>

          <!-- STEP 7: Review (giữ nguyên) -->
          <div v-if="currentStep === 6" class="fields-col">
            <div class="summary-card">
              <div class="summary-cover">
                <img v-if="form.thumbnail_url" :src="form.thumbnail_url" alt="Cover" />
                <div v-else class="summary-cover-blank">
                  <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="2"/></svg>
                </div>
              </div>
              <div class="summary-info">
                <div class="summary-name">{{ form.name || 'Untitled Campaign' }}</div>
                <div class="summary-artist">{{ form.advertiser_name || 'No advertiser' }}</div>
                <div class="summary-tags">
                  <span class="stag type">{{ adTypeLabel }}</span>
                  <span class="stag budget">${{ form.budget_total || 0 }}</span>
                  <span class="stag tier" :style="{ background: currentTier.color + '22', color: currentTier.color }">{{ currentTier.label }}</span>
                  <span v-if="form.target_genres.length" class="stag">{{ form.target_genres.length }} genres</span>
                </div>
              </div>
            </div>
            <div class="review-sections">
              <div class="review-section">
                <div class="rs-title">Media</div>
                <div class="review-grid">
                  <div class="review-item">
                    <span class="review-label">Media URL</span>
                    <span class="review-value url-val">{{ form.media_url || '—' }}</span>
                  </div>
                  <div class="review-item">
                    <span class="review-label">Click URL</span>
                    <span class="review-value url-val">{{ form.click_url || '—' }}</span>
                  </div>
                  <div v-if="form.duration" class="review-item">
                    <span class="review-label">Duration</span>
                    <span class="review-value">{{ form.duration }}s</span>
                  </div>
                  <div v-if="form.file_size" class="review-item">
                    <span class="review-label">File size</span>
                    <span class="review-value">{{ formatBytes(form.file_size) }}</span>
                  </div>
                </div>
              </div>
              <div class="review-section">
                <div class="rs-title">Targeting</div>
                <div class="review-grid">
                  <div class="review-item">
                    <span class="review-label">Age</span>
                    <span class="review-value">{{ form.target_age_min || '—' }} – {{ form.target_age_max || '—' }}</span>
                  </div>
                  <div class="review-item">
                    <span class="review-label">Gender</span>
                    <span class="review-value" style="text-transform:capitalize">{{ form.target_gender }}</span>
                  </div>
                  <div class="review-item">
                    <span class="review-label">Countries</span>
                    <span class="review-value">{{ form.target_location.length ? form.target_location.join(', ') : 'All' }}</span>
                  </div>
                  <div class="review-item">
                    <span class="review-label">Genres</span>
                    <span class="review-value">{{ form.target_genres.length ? form.target_genres.length + ' selected' : 'All' }}</span>
                  </div>
                </div>
              </div>
              <div class="review-section">
                <div class="rs-title">Budget & Pricing</div>
                <div class="review-grid">
                  <div class="review-item">
                    <span class="review-label">Total budget</span>
                    <span class="review-value">${{ form.budget_total || 0 }}</span>
                  </div>
                  <div class="review-item">
                    <span class="review-label">Priority tier</span>
                    <span class="review-value" :style="{ color: currentTier.color }">{{ currentTier.label }}</span>
                  </div>
                  <div class="review-item">
                    <span class="review-label">CPM (per play)</span>
                    <span class="review-value">${{ (form.cost_per_play || currentTier.minCpm).toFixed(4) }}</span>
                  </div>
                  <div class="review-item">
                    <span class="review-label">CPC (per click)</span>
                    <span class="review-value">${{ (form.cost_per_click || currentTier.minCpc).toFixed(4) }}</span>
                  </div>
                  <div class="review-item">
                    <span class="review-label">Est. plays</span>
                    <span class="review-value">{{ estimatedPlays.toLocaleString() }}</span>
                  </div>
                  <div class="review-item">
                    <span class="review-label">Priority</span>
                    <span class="review-value">{{ form.priority }} / {{ currentTier.maxPriority }}</span>
                  </div>
                </div>
              </div>
              <div class="review-section">
                <div class="rs-title">Schedule</div>
                <div class="review-grid">
                  <div class="review-item">
                    <span class="review-label">Start date</span>
                    <span class="review-value">{{ form.start_date || '—' }}</span>
                  </div>
                  <div class="review-item">
                    <span class="review-label">End date</span>
                    <span class="review-value">{{ showDateRange && form.end_date ? form.end_date : 'Run until budget ends' }}</span>
                  </div>
                  <div class="review-item">
                    <span class="review-label">Max plays / user</span>
                    <span class="review-value">{{ form.max_plays_per_user_per_day }}× / day</span>
                  </div>
                  <div class="review-item">
                    <span class="review-label">Freq. cap</span>
                    <span class="review-value">{{ form.frequency_cap }}× / day</span>
                  </div>
                </div>
              </div>
            </div>
            <div v-if="walletDanger" class="submit-blocker">
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
              Wallet balance is insufficient. Please top up before updating.
            </div>
          </div>
        </div>
      </transition>
    </div>
    <!-- Footer -->
    <div class="wizard-footer">
      <div class="footer-dots">
        <span v-for="(_, idx) in steps" :key="idx" class="dot" :class="{ active: idx === currentStep }"></span>
      </div>
      <div style="display:flex;gap:10px">
        <button class="wf-btn ghost" @click="prevStep" :disabled="currentStep === 0">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 18l-6-6 6-6"/></svg>
          Previous
        </button>
        <button v-if="currentStep < steps.length - 1" class="wf-btn primary" @click="nextStep">
          Next
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 18l6-6-6-6"/></svg>
        </button>
        <button v-else class="wf-btn primary" @click="handleSubmit" :disabled="isSubmitting || walletDanger">
          <span v-if="isSubmitting" class="btn-spinner"></span>
          <span v-else>Update Campaign</span>
          <svg v-if="!isSubmitting" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
        </button>
      </div>
    </div>
    <!-- Toast -->
    <transition name="toast">
      <div v-if="toast.show" class="toast" :class="toast.type">{{ toast.message }}</div>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import Multiselect from 'vue-multiselect'
import 'vue-multiselect/dist/vue-multiselect.css'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/modules/client/stores/users/UserStore'
import { usePartnerStore } from '@/modules/client/stores/partners/partnersStore'
import { useGenrestore } from '@/modules/client/stores/genres/genresStore'
import advertisingService from '@/modules/client/services/partners/advertising.service'
import { COUNTRIES } from '@/interfaces/countries'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()
const partnerStore = usePartnerStore()
const genresStore = useGenrestore()

const steps = [
  { label: 'Basic' },
  { label: 'Media' },
  { label: 'Target' },
  { label: 'Budget' },
  { label: 'Display' },
  { label: 'Schedule' },
  { label: 'Review' }
]

const priorityTiers = [
  { value: 'standard', label: 'Standard', color: '#888fa0', minCpm: 0.0020, minCpc: 0.0050, maxPriority: 33, desc: 'General reach, competitive queue' },
  { value: 'enhanced', label: 'Enhanced', color: '#00aaff', minCpm: 0.0050, minCpc: 0.0120, maxPriority: 66, desc: 'Higher visibility, better placement' },
  { value: 'premium', label: 'Premium', color: '#f59e0b', minCpm: 0.0100, minCpc: 0.0250, maxPriority: 100, desc: 'Top priority, maximum exposure' }
]
const genderOptions = [
  { value: 'all', label: 'All' },
  { value: 'male', label: 'Male' },
  { value: 'female', label: 'Female' }
]

const countries = COUNTRIES
const selectedCountries = computed({
  get() {
    return countries.filter(c => form.target_location.includes(c.code))
  },
  set(val) {
    form.target_location = val.map(c => c.code)
  }
})
const genres = computed(() => genresStore.Genres || [])

const walletBalance = computed(() => Number(partnerStore.user?.wallet_balance || 0))

// Campaign ID từ URL (ví dụ: /advertising/campaigns/:id/edit)
const campaignId = computed(() => route.params.id ? parseInt(route.params.id) : null)

const defaultForm = () => ({
  partner_id: '',
  name: '',
  type: '',
  advertiser_name: '',
  advertiser_url: '',
  media_url: '',
  thumbnail_url: '',
  click_url: '',
  duration: null,
  file_size: null,
  target_age_min: null,
  target_age_max: null,
  target_gender: 'all',
  target_location: [],
  target_genres: [],
  budget_total: null,
  priorityTier: 'standard',
  cost_per_play: null,
  cost_per_click: null,
  max_plays_per_user_per_day: 3,
  frequency_cap: 5,
  priority: 0,
  start_date: '',
  end_date: ''
})



const form = reactive(defaultForm())
const errors = reactive({})
const isSubmitting = ref(false)
const detectingMedia = ref(false)
const showDateRange = ref(false)
const currentStep = ref(0)
const toast = reactive({ show: false, message: '', type: 'success' })

const thumbFile = ref(null)
const mediaFile = ref(null)

onMounted(async () => {
  if (!genresStore.Genres || genresStore.Genres.length === 0) {
    await genresStore.fetchGenres()
  }
  if (!partnerStore.partnerInfo) {
    await partnerStore.fetchPartnerInfo()
  }
  if (partnerStore.partnerInfo?.partner) {
    form.partner_id = partnerStore.partnerInfo.partner.id
    if (!form.advertiser_name) form.advertiser_name = partnerStore.partnerInfo.partner.company_name
  }

  if (campaignId.value) {
    try {
      const response = await advertisingService.getCampaign(campaignId.value)
      const data = response.data || response

      // ==================== MAPPING CHÍNH XÁC TỪ BACKEND ====================
      form.name = data.name || ''
      form.type = data.type || ''
      form.advertiser_name = data.advertiser_name || ''
      form.advertiser_url = data.advertiser_url || ''
      form.media_url = data.media_url || ''
      form.thumbnail_url = data.thumbnail_url || ''
      form.click_url = data.click_url || ''
      form.duration = data.duration || 0
      form.file_size = data.file_size || null

      // Targeting (nested)
      const targeting = data.targeting || {}
      form.target_age_min = targeting.age_min ?? null
      form.target_age_max = targeting.age_max ?? null
      form.target_gender = targeting.gender || 'all'
      form.target_location = Array.isArray(targeting.location) ? targeting.location : []
      form.target_genres = Array.isArray(targeting.genres) ? targeting.genres.map(String) : []

      // Budget (nested)
      const budgetData = data.budget || {}
      form.budget_total = budgetData.total ?? null
      form.cost_per_play = data.cost_per_play ?? null
      form.cost_per_click = data.cost_per_click ?? null

      // Display & Priority
      form.max_plays_per_user_per_day = data.max_plays_per_user_per_day ?? 3
      form.frequency_cap = data.frequency_cap ?? 5
      form.priority = data.priority ?? 0

      // Suy ra Priority Tier từ priority
      if (form.priority <= 33) form.priorityTier = 'standard'
      else if (form.priority <= 66) form.priorityTier = 'enhanced'
      else form.priorityTier = 'premium'

      // Schedule (nested + format date)
      const schedule = data.schedule || {}
      form.start_date = data.schedule?.start_date 
        ? new Date(data.schedule.start_date).toISOString().split('T')[0]
        : ''

      form.end_date = data.schedule?.end_date 
        ? new Date(data.schedule.end_date).toISOString().split('T')[0]
        : ''

      // Set showDateRange dựa trên end_date
      showDateRange.value = !!(form.end_date && form.end_date.trim() !== '')

      console.log('✅ Campaign data loaded successfully', form)
    } catch (err) {
      console.error('Failed to load campaign:', err)
      showToast('Không thể tải dữ liệu campaign', 'error')
    }
  }
})

// ── Computed (giữ nguyên) ─────────────────────────────────────
const today = computed(() => new Date().toISOString().split('T')[0])
const partnerName = computed(() => partnerStore.partnerInfo?.partner?.company_name || 'Loading...')
const currentTier = computed(() => priorityTiers.find(t => t.value === form.priorityTier) || priorityTiers[0])
const cpmWarning = computed(() => form.cost_per_play && form.cost_per_play < currentTier.value.minCpm)
const cpcWarning = computed(() => form.cost_per_click && form.cost_per_click < currentTier.value.minCpc)
const walletWarning = computed(() => form.budget_total && form.budget_total > walletBalance.value * 0.8 && form.budget_total <= walletBalance.value)
const walletDanger = computed(() => form.budget_total && form.budget_total > walletBalance.value)
const estimatedPlays = computed(() => {
  const cpm = form.cost_per_play || currentTier.value.minCpm
  if (!form.budget_total || !cpm) return 0
  return Math.floor(form.budget_total / cpm)
})
const campaignDays = computed(() => {
  if (!form.start_date || !form.end_date) return 0
  return Math.max(0, Math.ceil((new Date(form.end_date) - new Date(form.start_date)) / 86400000))
})
const dailySpend = computed(() => form.budget_total && campaignDays.value ? '$' + (form.budget_total / campaignDays.value).toFixed(2) : '$0')
const adTypeLabel = computed(() => {
  const map = { audio: '🎵 Audio', banner: '🖼 Banner', video: '🎬 Video', sponsored_content: '📝 Sponsored' }
  return map[form.type] || form.type || 'No type'
})
const mediaTypeLabel = computed(() => {
  const map = { audio: 'Audio Ad', banner: 'Banner Image', video: 'Video Ad', sponsored_content: 'Sponsored Content' }
  return map[form.type] || ''
})
const mediaTypeDesc = computed(() => {
  const map = {
    audio: 'Paste a direct link to your MP3 or audio file.',
    banner: 'Paste a direct link to your JPG/PNG banner image.',
    video: 'Paste a direct link to your MP4 video file.',
    sponsored_content: 'Paste a link to your hosted content.'
  }
  return map[form.type] || ''
})

// ── Methods (chỉ thay đổi handleSubmit) ───────────────────────
function selectTier(tier) {
  form.priorityTier = tier.value
  if (form.priority > tier.maxPriority) form.priority = tier.maxPriority
  if (!form.cost_per_play || form.cost_per_play < tier.minCpm) form.cost_per_play = tier.minCpm
  if (!form.cost_per_click || form.cost_per_click < tier.minCpc) form.cost_per_click = tier.minCpc
}
function enforceCpmFloor() {
  if (form.cost_per_play && form.cost_per_play < currentTier.value.minCpm) form.cost_per_play = currentTier.value.minCpm
}
function enforceCpcFloor() {
  if (form.cost_per_click && form.cost_per_click < currentTier.value.minCpc) form.cost_per_click = currentTier.value.minCpc
}
async function detectMediaMeta() {
  if (!form.media_url || form.type === 'banner' || form.type === 'sponsored_content') return
  if (form.media_url.startsWith('blob:')) return
  detectingMedia.value = true
  try {
    const media = document.createElement(form.type === 'video' ? 'video' : 'audio')
    media.src = form.media_url
    await new Promise((resolve, reject) => {
      media.onloadedmetadata = resolve
      media.onerror = reject
      setTimeout(resolve, 5000)
    })
    if (media.duration) form.duration = Math.round(media.duration)
  } catch (e) {
    console.warn('Could not detect media meta:', e)
  } finally {
    detectingMedia.value = false
  }
}
function formatBytes(bytes) {
  if (!bytes) return '—'
  if (bytes < 1024) return bytes + ' B'
  if (bytes < 1048576) return (bytes / 1024).toFixed(1) + ' KB'
  return (bytes / 1048576).toFixed(1) + ' MB'
}
function toggleDateRange() {
  showDateRange.value = !showDateRange.value
  if (!showDateRange.value) {
    form.end_date = ''
  } else {
    if (form.start_date && !form.end_date) {
      const defaultEndDate = new Date(form.start_date)
      defaultEndDate.setDate(defaultEndDate.getDate() + 7)
      form.end_date = defaultEndDate.toISOString().split('T')[0]
    }
  }
}
function onThumbChange(e) {
  const file = e.target.files[0]
  if (!file) return
  thumbFile.value = file
  form.thumbnail_url = URL.createObjectURL(file)
}
function triggerFileUpload() {
  const input = document.createElement('input')
  input.type = 'file'
  input.accept = 'image/*'
  input.onchange = onThumbChange
  input.click()
}
function onMediaChange(e) {
  const file = e.target.files[0]
  if (!file) return
  mediaFile.value = file
  form.media_url = URL.createObjectURL(file)
  detectingMedia.value = true
  const media = document.createElement(form.type === 'video' ? 'video' : 'audio')
  media.src = form.media_url
  media.onloadedmetadata = () => {
    form.duration = Math.round(media.duration)
    form.file_size = file.size
    detectingMedia.value = false
  }
}
function triggerMediaUpload() {
  const input = document.createElement('input')
  input.type = 'file'
  input.accept = form.type === 'video' ? 'video/*' : (form.type === 'audio' ? 'audio/*' : 'image/*')
  input.onchange = onMediaChange
  input.click()
}
function nextStep() {
  if (validateStep(currentStep.value)) currentStep.value++
}
function prevStep() { currentStep.value-- }
function goToStep(step) { if (step < currentStep.value) currentStep.value = step }

function validateStep(step) {
  Object.keys(errors).forEach(k => delete errors[k])
  switch (step) {
    case 0:
      if (!form.name.trim()) errors.name = 'Campaign name is required'
      if (!form.type) errors.type = 'Please select an ad type'
      if (!form.advertiser_name.trim()) errors.advertiser_name = 'Advertiser name is required'
      break
    case 1:
      if (!form.media_url) errors.media_url = 'Media URL is required'
      if (!form.click_url) errors.click_url = 'Click-through URL is required'
      break
    case 3:
      if (!form.budget_total || form.budget_total <= 0) errors.budget_total = 'Budget must be greater than 0'
      if (walletDanger.value) errors.budget_total = 'Budget exceeds available wallet balance'
      break
    case 5:
      if (!form.start_date) errors.start_date = 'Start date is required'
      break
  }
  return Object.keys(errors).length === 0
}

async function handleSubmit() {
  const valid = [0, 1, 3, 5].every(s => validateStep(s))
  if (!valid) {
    showToast('Please complete all required fields', 'error')
    return
  }
  if (walletDanger.value) {
    showToast('Insufficient wallet balance', 'error')
    return
  }

  isSubmitting.value = true
  try {
    const formData = new FormData()
    formData.append('partner_id', form.partner_id)
    formData.append('name', form.name)
    formData.append('type', form.type)
    formData.append('advertiser_name', form.advertiser_name)
    formData.append('advertiser_url', form.advertiser_url || '')
    if (mediaFile.value) {
      formData.append('media_file', mediaFile.value)
    } else if (form.media_url) {
      formData.append('media_url', form.media_url)
    }
    if (thumbFile.value) {
      formData.append('thumbnail', thumbFile.value)
    }
    formData.append('click_url', form.click_url)
    formData.append('duration', form.duration || 0)
    if (form.target_age_min) formData.append('target_age_min', form.target_age_min)
    if (form.target_age_max) formData.append('target_age_max', form.target_age_max)
    formData.append('target_gender', form.target_gender)
    form.target_location.forEach(loc => formData.append('target_location[]', loc))
    form.target_genres.forEach(genre => formData.append('target_genres[]', genre))
    formData.append('budget_total', form.budget_total)
    formData.append('cost_per_play', form.cost_per_play || currentTier.value.minCpm)
    formData.append('cost_per_click', form.cost_per_click || currentTier.value.minCpc)
    formData.append('max_plays_per_user_per_day', form.max_plays_per_user_per_day)
    formData.append('frequency_cap', form.frequency_cap)
    formData.append('priority', form.priority)
    formData.append('start_date', form.start_date)
    if (form.end_date) formData.append('end_date', form.end_date)

    // Gọi API UPDATE
    await advertisingService.updateCampaign(campaignId.value, formData)   // ← Service phải có method updateCampaign(id, formData)
    
    showToast('Campaign updated successfully!', 'success')
    setTimeout(() => {
      router.push({ name: 'client.partner.Advertisingd.dashboard' })
    }, 1500)
  } catch (error) {
    console.error('Update failed:', error)
    const msg = error.response?.data?.message || 'Failed to update campaign'
    showToast(msg, 'error')
    if (error.response?.data?.errors) Object.assign(errors, error.response.data.errors)
  } finally {
    isSubmitting.value = false
  }
}

function resetForm() {
  Object.assign(form, defaultForm())
  Object.keys(errors).forEach(k => delete errors[k])
  currentStep.value = 0
  showDateRange.value = false
  thumbFile.value = null
  mediaFile.value = null
}

function showToast(message, type = 'success') {
  toast.message = message
  toast.type = type
  toast.show = true
  setTimeout(() => { toast.show = false }, 3200)
}
</script>

<style scoped>
.wizard-shell {
  min-height: 100vh;
  background: #080e14;
  display: flex;
  flex-direction: column;
  font-family: 'DM Sans', 'Segoe UI', sans-serif;
  color: #e8edf2;
  position: relative;
  overflow: hidden;
}
.bg-grid {
  position: absolute; inset: 0;
  background-image:
    linear-gradient(rgba(0,160,255,.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0,160,255,.03) 1px, transparent 1px);
  background-size: 40px 40px;
  pointer-events: none; z-index: 0;
}

/* ── Topbar ── */
.topbar {
  position: relative; z-index: 10;
  display: flex; align-items: center; gap: 16px;
  padding: 18px 28px;
  border-bottom: 1px solid rgba(255,255,255,.06);
  background: rgba(8,14,20,.8); backdrop-filter: blur(12px);
}
.back-btn {
  display: flex; align-items: center; gap: 6px;
  background: rgba(255,255,255,.05); border: 1px solid rgba(255,255,255,.1);
  color: rgba(255,255,255,.7); border-radius: 8px; padding: 7px 14px;
  font-size: 13px; cursor: pointer; transition: all .15s; flex-shrink: 0;
}
.back-btn:hover { background: rgba(255,255,255,.1); color: #fff; }
.topbar-title { flex: 1; }
.topbar-label { font-size: 15px; font-weight: 600; color: rgba(255,255,255,.5); }
.step-pills { display: flex; gap: 6px; }
.step-pill {
  display: flex; align-items: center; gap: 8px; padding: 7px 14px;
  border-radius: 100px; border: 1px solid rgba(255,255,255,.1);
  background: transparent; color: rgba(255,255,255,.4);
  font-size: 13px; font-weight: 500; cursor: default; transition: all .2s;
}
.step-pill.active { background: rgba(0,160,255,.15); border-color: rgba(0,160,255,.5); color: #00aaff; }
.step-pill.done { background: rgba(0,200,120,.1); border-color: rgba(0,200,120,.4); color: #00c87a; cursor: pointer; }
.pill-num {
  width: 20px; height: 20px; border-radius: 50%;
  background: rgba(255,255,255,.08); display: flex; align-items: center; justify-content: center;
  font-size: 11px; font-weight: 700;
}
.step-pill.active .pill-num { background: #00aaff; color: #000; }
.step-pill.done .pill-num { background: #00c87a; color: #000; }

/* ── Progress ── */
.progress-bar { position: relative; z-index: 10; height: 2px; background: rgba(255,255,255,.06); }
.progress-fill { height: 100%; background: linear-gradient(90deg,#00aaff,#00c87a); transition: width .4s cubic-bezier(.4,0,.2,1); }

/* ── Body ── */
.wizard-body {
  flex: 1; overflow-y: auto; padding: 32px 28px;
  position: relative; z-index: 1; max-width: 960px; width: 100%; margin: 0 auto;
}
.step-panel { animation: fadeUp .25s ease; }
@keyframes fadeUp { from { opacity:0; transform:translateY(10px); } to { opacity:1; transform:translateY(0); } }

/* ── Layout ── */
.info-layout { display: grid; grid-template-columns: 220px 1fr; gap: 28px; align-items: start; }
.cover-col { display: flex; flex-direction: column; align-items: center; gap: 10px; }
.cover-uploader {
  width: 200px; height: 200px; border-radius: 16px; overflow: hidden;
  border: 2px dashed rgba(255,255,255,.15); position: relative; cursor: pointer; transition: border-color .2s;
}
.cover-uploader:hover { border-color: #00aaff; }
.cover-img { width: 100%; height: 100%; object-fit: cover; display: block; }
.cover-placeholder {
  width: 100%; height: 100%; display: flex; flex-direction: column;
  align-items: center; justify-content: center; gap: 8px;
  color: rgba(255,255,255,.3); font-size: 13px;
}
.cover-overlay {
  position: absolute; inset: 0; background: rgba(0,0,0,.65);
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  gap: 6px; color: #fff; opacity: 0; transition: opacity .2s; font-size: 13px;
}
.cover-uploader:hover .cover-overlay { opacity: 1; }
.cover-hint { font-size: 11px; color: rgba(255,255,255,.3); text-align: center; line-height: 1.5; }
.artist-display { display: flex; flex-direction: column; align-items: center; gap: 4px; width: 100%; text-align: center; }
.artist-label { font-size: 11px; font-weight: 500; color: rgba(255,255,255,.35); text-transform: uppercase; letter-spacing: .05em; }
.artist-name { font-size: 14px; font-weight: 600; color: #00aaff; }

/* ── Fields ── */
.fields-col { display: flex; flex-direction: column; gap: 18px; }
.field { display: flex; flex-direction: column; gap: 6px; }
.field-row.two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.field-label { font-size: 13px; font-weight: 500; color: rgba(255,255,255,.6); display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
.field-label.required::after { content:' *'; color:#ff5555; }
.field-control {
  background: rgba(255,255,255,.05); border: 1px solid rgba(255,255,255,.1);
  border-radius: 9px; padding: 10px 13px; color: #fff; font-size: 14px;
  transition: border-color .2s; width: 100%; box-sizing: border-box; font-family: inherit;
}
.field-control:focus { outline: none; border-color: rgba(0,170,255,.6); background: rgba(255,255,255,.07); }
.field-control::placeholder { color: rgba(255,255,255,.2); }
.field-control option { background: #1a2530; color: #fff; }
.field-control.error { border-color: #ff5555; }
.field-control:disabled { opacity: .5; cursor: not-allowed; }
.field-hint { font-size: 12px; color: rgba(255,255,255,.35); line-height: 1.5; }
.field-hint.error { color: #ff5555; }

/* ── URL input ── */
.url-input-wrap { display: flex; align-items: center; background: rgba(255,255,255,.05); border: 1px solid rgba(255,255,255,.1); border-radius: 9px; overflow: hidden; transition: border-color .2s; }
.url-input-wrap:focus-within { border-color: rgba(0,170,255,.6); }
.url-icon { width: 40px; display: flex; align-items: center; justify-content: center; color: rgba(255,255,255,.3); flex-shrink: 0; }
.url-field { border: none; background: transparent; border-radius: 0; }
.url-field:focus { outline: none; }

/* ── Media type hint ── */
.media-type-hint { display: flex; align-items: center; gap: 8px; margin-top: 2px; }
.mtag { font-size: 11px; font-weight: 600; padding: 2px 8px; border-radius: 4px; letter-spacing: .03em; }
.mtag.audio { background: rgba(0,200,120,.15); color: #00c87a; }
.mtag.video { background: rgba(0,170,255,.15); color: #00aaff; }
.mtag.banner { background: rgba(245,158,11,.15); color: #f59e0b; }
.mtag.sponsored_content { background: rgba(168,85,247,.15); color: #a855f7; }

/* ── Auto detect ── */
.auto-detect-box {
  background: rgba(0,200,120,.06); border: 1px solid rgba(0,200,120,.2);
  border-radius: 10px; padding: 12px 16px;
}
.auto-detect-title {
  font-size: 12px; font-weight: 500; color: #00c87a;
  display: flex; align-items: center; gap: 6px; margin-bottom: 10px;
}
.auto-detect-row { display: flex; gap: 24px; }
.auto-detect-item { display: flex; flex-direction: column; gap: 2px; }
.ad-label { font-size: 11px; color: rgba(255,255,255,.4); }
.ad-val { font-size: 14px; font-weight: 600; color: #fff; }
.detecting-box {
  display: flex; align-items: center; gap: 10px;
  background: rgba(0,170,255,.06); border: 1px solid rgba(0,170,255,.2);
  border-radius: 10px; padding: 12px 16px; font-size: 13px; color: rgba(255,255,255,.6);
}
.detecting-spinner {
  width: 14px; height: 14px; border: 2px solid rgba(0,170,255,.3);
  border-top-color: #00aaff; border-radius: 50%; animation: spin .7s linear infinite;
}

/* ── Info banner ── */
.info-banner {
  display: flex; align-items: flex-start; gap: 8px; padding: 12px 14px;
  background: rgba(0,170,255,.07); border: 1px solid rgba(0,170,255,.2);
  border-radius: 8px; font-size: 13px; color: rgba(255,255,255,.6); line-height: 1.5;
}
.info-banner svg { flex-shrink: 0; margin-top: 1px; color: #00aaff; }
.info-banner strong { color: #fff; font-weight: 500; }

/* ── Segmented control (gender) ── */
.seg-control { display: flex; border-radius: 9px; overflow: hidden; border: 1px solid rgba(255,255,255,.1); }
.seg-btn {
  flex: 1; padding: 10px 0; background: rgba(255,255,255,.03); border: none;
  color: rgba(255,255,255,.5); font-size: 13px; font-family: inherit; cursor: pointer; transition: all .15s;
}
.seg-btn + .seg-btn { border-left: 1px solid rgba(255,255,255,.1); }
.seg-btn.active { background: rgba(0,170,255,.2); color: #00aaff; font-weight: 600; }

/* ── Country grid ── */
.country-grid { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 4px; }
.country-chip {
  display: flex; align-items: center; gap: 6px;
  padding: 6px 12px; border: 1px solid rgba(255,255,255,.1); border-radius: 8px;
  font-size: 13px; cursor: pointer; transition: all .12s;
  background: rgba(255,255,255,.03); color: rgba(255,255,255,.6); user-select: none;
}
.country-chip:hover { background: rgba(255,255,255,.08); color: #fff; }
.country-chip.selected { background: rgba(0,170,255,.15); border-color: rgba(0,170,255,.45); color: #00aaff; }
.country-flag { font-size: 16px; }

/* ── Genre grid ── */
.genre-grid { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 6px; }
.genre-chip {
  padding: 6px 14px; border: 1px solid rgba(255,255,255,.1); border-radius: 100px;
  font-size: 13px; cursor: pointer; transition: all .12s;
  background: rgba(255,255,255,.03); color: rgba(255,255,255,.6); user-select: none;
}
.genre-chip:hover { background: rgba(255,255,255,.08); color: #fff; }
.genre-chip.selected { background: rgba(0,160,255,.15); border-color: rgba(0,160,255,.5); color: #00aaff; }

/* ── Wallet card ── */
.wallet-card {
  display: flex; align-items: center; gap: 14px;
  padding: 14px 18px; border-radius: 12px;
  background: rgba(255,255,255,.04); border: 1px solid rgba(255,255,255,.1);
  transition: all .2s;
}
.wallet-card.warning { border-color: rgba(245,158,11,.4); background: rgba(245,158,11,.06); }
.wallet-card.danger  { border-color: rgba(255,85,85,.4); background: rgba(255,85,85,.06); }
.wallet-icon { color: rgba(255,255,255,.5); flex-shrink: 0; }
.wallet-body { flex: 1; display: flex; flex-direction: column; gap: 2px; }
.wallet-label { font-size: 11px; color: rgba(255,255,255,.4); text-transform: uppercase; letter-spacing: .05em; }
.wallet-amount { font-size: 20px; font-weight: 700; color: #fff; font-variant-numeric: tabular-nums; }
.wallet-alert { display: flex; align-items: center; gap: 6px; font-size: 12px; font-weight: 500; padding: 5px 10px; border-radius: 6px; white-space: nowrap; }
.wallet-alert.warning { color: #f59e0b; background: rgba(245,158,11,.1); }
.wallet-alert.danger  { color: #ff5555; background: rgba(255,85,85,.1); }

/* ── Budget estimate ── */
.budget-estimate {
  display: flex; align-items: center; gap: 6px;
  font-size: 12px; color: rgba(0,200,120,.8); margin-top: 2px;
}

/* ── Tier cards ── */
.tier-cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-top: 4px; }
.tier-card {
  padding: 14px; border-radius: 10px; border: 1px solid rgba(255,255,255,.08);
  background: rgba(255,255,255,.03); cursor: pointer; transition: all .18s;
  display: flex; flex-direction: column; gap: 6px;
}
.tier-card:hover { background: rgba(255,255,255,.07); }
.tier-card.active { border-color: rgba(0,170,255,.4); background: rgba(0,170,255,.07); }
.tier-badge { font-size: 11px; font-weight: 700; padding: 3px 9px; border-radius: 5px; display: inline-block; letter-spacing: .04em; }
.tier-cpm { font-size: 12px; color: rgba(255,255,255,.5); }
.tier-cpm strong { color: #fff; }
.tier-desc { font-size: 11px; color: rgba(255,255,255,.35); line-height: 1.4; }
.tier-priority { font-size: 11px; color: rgba(255,255,255,.25); }

/* ── CPM floor badge ── */
.cpm-floor-badge {
  font-size: 10px; font-weight: 600; padding: 2px 7px; border-radius: 4px;
  background: rgba(245,158,11,.15); color: #f59e0b; letter-spacing: .03em;
}
.input-prefix { display: flex; align-items: center; background: rgba(255,255,255,.05); border: 1px solid rgba(255,255,255,.1); border-radius: 9px; overflow: hidden; transition: border-color .2s; }
.input-prefix:focus-within { border-color: rgba(0,170,255,.6); }
.input-prefix.has-error { border-color: rgba(255,85,85,.6); }
.input-prefix span {
  padding: 0 12px; background: rgba(255,255,255,.05); color: rgba(255,255,255,.5);
  font-size: 14px; height: 40px; display: flex; align-items: center;
  border-right: 1px solid rgba(255,255,255,.1); flex-shrink: 0;
}
.input-prefix .field-control { border: none; border-radius: 0; background: transparent; }
.input-prefix .field-control:focus { outline: none; }

/* ── Vis section ── */
.vis-section {
  background: rgba(255,255,255,.02); border: 1px solid rgba(255,255,255,.07);
  border-radius: 14px; padding: 22px;
}
.vis-section-title { font-size: 12px; font-weight: 600; color: rgba(255,255,255,.35); text-transform: uppercase; letter-spacing: .08em; margin: 0 0 18px; }
.range-labels { display: flex; justify-content: space-between; font-size: 11px; color: rgba(255,255,255,.3); margin-top: 4px; }
.badge-info {
  display: inline-flex; align-items: center; justify-content: center;
  min-width: 26px; height: 20px; padding: 0 6px;
  background: #00aaff; color: #000; border-radius: 4px; font-size: 12px; font-weight: 700;
}

/* ── Diff box ── */
.diff-box {
  background: rgba(255,255,255,.03); border: 1px solid rgba(255,255,255,.07);
  border-radius: 10px; padding: 14px; display: flex; flex-direction: column; gap: 10px; margin-top: 6px;
}
.diff-row { display: flex; align-items: flex-start; gap: 10px; font-size: 13px; color: rgba(255,255,255,.6); line-height: 1.4; }
.diff-row strong { color: rgba(255,255,255,.85); }
.diff-icon { font-size: 14px; flex-shrink: 0; width: 24px; text-align: center; }

/* ── Priority display ── */
.priority-display {
  background: rgba(255,255,255,.02); border: 1px solid rgba(255,255,255,.07);
  border-radius: 14px; padding: 18px; margin-top: 4px;
}
.pd-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px; }
.pd-label { font-size: 13px; font-weight: 500; color: rgba(255,255,255,.6); }
.pd-tier-badge { font-size: 11px; font-weight: 700; padding: 3px 9px; border-radius: 5px; }
.pd-current { font-weight: 600; color: rgba(255,255,255,.7); }

/* ── Toggle ── */
.toggle-row { display: flex; flex-direction: column; gap: 10px; }
.toggle-card {
  display: flex; align-items: center; gap: 14px; padding: 14px 16px;
  border-radius: 10px; border: 1px solid rgba(255,255,255,.07);
  background: rgba(255,255,255,.03); cursor: pointer; transition: all .2s; user-select: none;
}
.toggle-card:hover { background: rgba(255,255,255,.06); }
.toggle-card.on { border-color: rgba(0,170,255,.3); background: rgba(0,160,255,.07); }
.toggle-thumb { width: 36px; height: 20px; border-radius: 100px; background: rgba(255,255,255,.1); position: relative; flex-shrink: 0; transition: background .2s; }
.toggle-thumb::after { content:''; position:absolute; width:14px; height:14px; border-radius:50%; background:rgba(255,255,255,.5); top:3px; left:3px; transition:all .2s; }
.toggle-thumb.on { background: #00aaff; }
.toggle-thumb.on::after { left:19px; background:#fff; }
.toggle-body { flex: 1; }
.toggle-name { display:block; font-size:14px; font-weight:500; color:#fff; }
.toggle-desc { font-size:12px; color:rgba(255,255,255,.35); }
.toggle-badge { font-size:11px; font-weight:700; padding:3px 9px; border-radius:100px; background:rgba(255,255,255,.07); color:rgba(255,255,255,.3); letter-spacing:.05em; transition:all .2s; }
.toggle-badge.on { background:rgba(0,170,255,.15); color:#00aaff; }

/* ── Schedule ── */
.range-pair { display:flex; align-items:center; gap:8px; }
.range-pair-sep { color:rgba(255,255,255,.3); font-size:14px; flex-shrink:0; }
.campaign-duration {
  display: inline-flex; align-items: center; gap: 8px; padding: 10px 16px;
  background: rgba(0,200,120,.08); border: 1px solid rgba(0,200,120,.25);
  border-radius: 8px; font-size: 13px; color: #00c87a;
}
.dur-extra { color: rgba(0,200,120,.6); font-size: 12px; }
.indefinite-note {
  display: flex; align-items: center; gap: 8px; padding: 12px 16px;
  background: rgba(0,170,255,.07); border: 1px solid rgba(0,170,255,.2);
  border-radius: 8px; font-size: 13px; color: rgba(255,255,255,.6);
}
.indefinite-note strong { color: #fff; }

/* ── Review ── */
.summary-card {
  display: flex; align-items: center; gap: 18px; padding: 18px 20px;
  background: rgba(255,255,255,.03); border: 1px solid rgba(255,255,255,.08); border-radius: 14px;
}
.summary-cover { width: 64px; height: 64px; border-radius: 10px; overflow: hidden; flex-shrink: 0; }
.summary-cover img { width:100%; height:100%; object-fit:cover; }
.summary-cover-blank { width:100%; height:100%; background:rgba(255,255,255,.05); display:flex; align-items:center; justify-content:center; color:rgba(255,255,255,.2); }
.summary-info { display:flex; flex-direction:column; gap:4px; flex:1; }
.summary-name { font-size:17px; font-weight:700; color:#fff; }
.summary-artist { font-size:13px; color:rgba(255,255,255,.45); }
.summary-tags { display:flex; gap:6px; flex-wrap:wrap; margin-top:4px; }
.stag { font-size:11px; padding:2px 9px; border-radius:100px; background:rgba(255,255,255,.07); color:rgba(255,255,255,.5); text-transform:capitalize; }
.stag.type { background:rgba(0,170,255,.12); color:#00aaff; }
.stag.budget { background:rgba(0,200,120,.12); color:#00c87a; }

.review-sections { display:flex; flex-direction:column; gap:16px; margin-top:18px; }
.review-section { background:rgba(255,255,255,.02); border:1px solid rgba(255,255,255,.06); border-radius:12px; padding:16px 18px; }
.rs-title { font-size:11px; font-weight:600; color:rgba(255,255,255,.3); text-transform:uppercase; letter-spacing:.07em; margin-bottom:12px; }
.review-grid { display:grid; grid-template-columns:1fr 1fr; gap:12px; }
.review-item { display:flex; flex-direction:column; gap:3px; }
.review-label { font-size:11px; color:rgba(255,255,255,.4); text-transform:uppercase; letter-spacing:.05em; }
.review-value { font-size:14px; font-weight:500; color:#fff; }
.url-val { font-size:12px; word-break:break-all; color:rgba(0,170,255,.8); }

.submit-blocker {
  display:flex; align-items:center; gap:8px; padding:12px 16px; margin-top:8px;
  background:rgba(255,85,85,.08); border:1px solid rgba(255,85,85,.3);
  border-radius:8px; font-size:13px; color:#ff5555; font-weight:500;
}

/* ── Footer ── */
.wizard-footer {
  position:relative; z-index:10;
  display:flex; align-items:center; justify-content:space-between;
  padding:16px 28px; border-top:1px solid rgba(255,255,255,.06);
  background:rgba(8,14,20,.85); backdrop-filter:blur(12px);
}
.footer-dots { display:flex; gap:6px; align-items:center; }
.dot { width:6px; height:6px; border-radius:50%; background:rgba(255,255,255,.2); transition:all .2s; }
.dot.active { background:#00aaff; width:18px; border-radius:3px; }
.wf-btn {
  display:flex; align-items:center; gap:8px; padding:10px 22px;
  border-radius:10px; font-size:14px; font-weight:600; cursor:pointer; border:none; transition:all .2s; font-family:inherit;
}
.wf-btn:disabled { opacity:.4; cursor:not-allowed; }
.wf-btn.ghost { background:rgba(255,255,255,.05); border:1px solid rgba(255,255,255,.1); color:rgba(255,255,255,.6); }
.wf-btn.ghost:hover:not(:disabled) { background:rgba(255,255,255,.1); color:#fff; }
.wf-btn.primary { background:#00aaff; color:#000; }
.wf-btn.primary:hover:not(:disabled) { background:#33bbff; transform:translateY(-1px); box-shadow:0 6px 20px rgba(0,170,255,.35); }
.btn-spinner { width:15px; height:15px; border:2px solid rgba(0,0,0,.3); border-top-color:#000; border-radius:50%; animation:spin .6s linear infinite; }
@keyframes spin { to { transform:rotate(360deg); } }

/* ── Toast ── */
.toast { position:fixed; bottom:28px; right:28px; padding:12px 20px; border-radius:10px; font-size:14px; font-weight:500; z-index:9999; box-shadow:0 4px 16px rgba(0,0,0,.3); }
.toast.success { background:#00c87a; color:#000; }
.toast.error { background:#ff5555; color:#fff; }
.toast-enter-active,.toast-leave-active { transition:opacity .25s, transform .25s; }
.toast-enter-from,.toast-leave-to { opacity:0; transform:translateY(10px); }
.slide-fade-enter-active,.slide-fade-leave-active { transition:all .22s ease; }
.slide-fade-enter-from { opacity:0; transform:translateX(18px); }
.slide-fade-leave-to { opacity:0; transform:translateX(-18px); }

/* ── Responsive ── */
@media (max-width:720px) {
  .topbar { flex-wrap:wrap; gap:12px; }
  .step-pills { order:3; width:100%; justify-content:center; }
  .pill-label { display:none; }
  .info-layout { grid-template-columns:1fr; }
  .cover-col { flex-direction:row; align-items:center; }
  .cover-uploader { width:100px; height:100px; }
  .field-row.two-col { grid-template-columns:1fr; }
  .tier-cards { grid-template-columns:1fr; }
  .review-grid { grid-template-columns:1fr; }
  .wizard-body { padding:20px 16px; }
  .wizard-footer { padding:14px 16px; }
}.dark-multiselect-wrapper :deep(.multiselect__tags) {
  background: #0f151b;
  border-color: #334155;
  border-radius: 8px;
}

.dark-multiselect-wrapper :deep(.multiselect__input),
.dark-multiselect-wrapper :deep(.multiselect__single) {
  background: #0f151b;
  color: #e2e8f0;
}

.dark-multiselect-wrapper :deep(.multiselect__input::placeholder) {
  color: #64748b;
}

.dark-multiselect-wrapper :deep(.multiselect__placeholder) {
  color: #64748b;
}

/* Dropdown */
.dark-multiselect-wrapper :deep(.multiselect__content-wrapper) {
  background: #0f151b;
  border-color: #334155;
}

.dark-multiselect-wrapper :deep(.multiselect__option) {
  background: #0f151b;
  color: #e2e8f0;
}

/* Hover */
.dark-multiselect-wrapper :deep(.multiselect__option--highlight) {
  background: #062d43;
  color: #fff;
}

.dark-multiselect-wrapper :deep(.multiselect__option--highlight::after) {
  background: #062d43;
  color: #fff;
}

/* Option đã chọn */
.dark-multiselect-wrapper :deep(.multiselect__option--selected) {
  background: #0f151b;
  color: #00c87a;
  font-weight: 600;
}

.dark-multiselect-wrapper :deep(.multiselect__option--selected::after) {
  color: #00c87a;
}

/* Vừa selected vừa hover */
.dark-multiselect-wrapper :deep(.multiselect__option--selected.multiselect__option--highlight) {
  background: #062d43;
  color: #fff;
}

.dark-multiselect-wrapper :deep(.multiselect__option--selected.multiselect__option--highlight::after) {
  background: #062d43;
  color: #fff;
}

/* Tags */
.dark-multiselect-wrapper :deep(.multiselect__tag) {
  background: linear-gradient(90deg, #00aaff, #00c87a);
  color: #fff;
  border-radius: 20px;
}

.dark-multiselect-wrapper :deep(.multiselect__tag-icon::after) {
  color: #fff;
}

.dark-multiselect-wrapper :deep(.multiselect__tag-icon:hover) {
  background: rgba(0, 0, 0, 0.2);
}

/* Caret */
.dark-multiselect-wrapper :deep(.multiselect__select) {
  background: transparent;
}

.dark-multiselect-wrapper :deep(.multiselect__select::before) {
  border-color: #64748b transparent transparent;
}

/* Active border */
.dark-multiselect-wrapper :deep(.multiselect--active .multiselect__tags) {
  border-color: #00aaff;
}
</style>
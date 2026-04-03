<template>
  <div class="song-add-page">

    <!-- ── Page Header ── -->
    <div class="page-header">
      <div class="page-header__left">
        <button class="btn-back" @click="$router.back()">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
            <polyline points="15 18 9 12 15 6" />
          </svg>
          Back
        </button>
        <div>
          <h1 class="page-title">Update Song</h1>
          <p class="page-subtitle">Edit & save changes for this track</p>
        </div>
      </div>
      <div class="page-header__right">
        <button class="btn-save-draft" @click="saveDraft">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z" />
            <polyline points="17 21 17 13 7 13 7 21" />
            <polyline points="7 3 7 8 15 8" />
          </svg>
          Save Draft
        </button>
        <button
          class="btn-publish"
          @click="update"
          :disabled="loading"
          :class="{ 'is-loading': loading }"
        >
          <svg v-if="!loading" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
            <polyline points="20 6 9 17 4 12" />
          </svg>
          <span v-else class="spinner"></span>
          <span>{{ loading ? 'Saving...' : 'Save Changes' }}</span>
        </button>
      </div>
    </div>

    <!-- ── Loading skeleton ── -->
    <div v-if="isFetching" class="fetching-overlay">
      <div class="fetching-spinner"></div>
      <p>Loading song data…</p>
    </div>

    <template v-else>
      <!-- ── Progress Steps ── -->
      <div class="steps-bar">
        <div v-for="(step, i) in steps" :key="i" class="step"
          :class="{ active: currentStep === i, done: currentStep > i }" @click="goToStep(i)">
          <div class="step-circle">
            <svg v-if="currentStep > i" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
              <polyline points="20 6 9 17 4 12" />
            </svg>
            <span v-else>{{ i + 1 }}</span>
          </div>
          <span class="step-label">{{ step }}</span>
          <div v-if="i < steps.length - 1" class="step-line" :class="{ done: currentStep > i }"></div>
        </div>
      </div>

      <!-- ── Form Body ── -->
      <div class="form-layout">

        <!-- LEFT COLUMN -->
        <div class="col-main">

          <!-- STEP 0 · Basic Info -->
          <section v-show="currentStep === 0" class="form-section">
            <div class="section-heading">
              <div class="section-icon section-icon--blue">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M9 18V5l12-2v13" />
                  <circle cx="6" cy="18" r="3" />
                  <circle cx="18" cy="16" r="3" />
                </svg>
              </div>
              <h2 class="section-title">Basic Information</h2>
            </div>

            <div class="form-grid form-grid--2">
              <div class="field field--full" :class="{ 'field--error': stepErrors[0].title }">
                <label class="field-label">Song Title <span class="required">*</span></label>
                <input v-model="form.title" type="text" class="field-input" placeholder="e.g. Midnight Dreams"
                  @input="autoSlug(); clearError(0, 'title')" />
                <p v-if="stepErrors[0].title" class="field-error">{{ stepErrors[0].title }}</p>
              </div>
              <div class="field field--full">
                <label class="field-label">Slug <span class="required">*</span></label>
                <div class="input-prefix-wrap">
                  <span class="input-prefix">songs/</span>
                  <input v-model="form.slug" type="text" class="field-input field-input--prefixed"
                    placeholder="midnight-dreams" disabled />
                </div>
              </div>
            </div>

            <div class="form-grid form-grid--2">
              <div class="field" :class="{ 'field--error': stepErrors[0].artist_id }">
                <label class="field-label">Artist <span class="required">*</span></label>
                <select v-model="form.artist_id" class="field-select" @change="clearError(0, 'artist_id')">
                  <option value="">-- Select Artist --</option>
                  <option v-for="a in useArtist.artists" :key="a.id" :value="a.id">{{ a.name }}</option>
                </select>
                <p v-if="stepErrors[0].artist_id" class="field-error">{{ stepErrors[0].artist_id }}</p>
              </div>
              <div class="field">
                <label class="field-label">Album</label>
                <select v-model="form.album_id" class="field-select">
                  <option value="">-- No Album --</option>
                  <option v-for="a in mockAlbums" :key="a.id" :value="a.id">{{ a.name }}</option>
                </select>
              </div>
            </div>

            <div class="form-grid form-grid--4">
              <div class="field" :class="{ 'field--error': stepErrors[0].year }">
                <label class="field-label">Year<span class="required">*</span></label>
                <input v-model="form.year" type="number" class="field-input" placeholder="2026" min="1900" max="2099"
                  @input="clearError(0, 'year')" />
                <p v-if="stepErrors[0].year" class="field-error">{{ stepErrors[0].year }}</p>
              </div>
              <div class="field">
                <label class="field-label">Track #</label>
                <input v-model="form.track_number" type="number" class="field-input" placeholder="1" min="1" />
              </div>
              <div class="field">
                <label class="field-label">Disc #</label>
                <input v-model="form.disc_number" type="number" class="field-input" placeholder="1" min="1" />
              </div>
              <div class="field">
                <label class="field-label">ISRC</label>
                <input v-model="form.isrc" type="text" class="field-input" placeholder="USRC12345678" maxlength="20" />
              </div>
            </div>

            <div class="form-grid form-grid--2">
              <div class="field" :class="{ 'field--error': stepErrors[0].copyright_owner }">
                <label class="field-label">Copyright Owner<span class="required">*</span></label>
                <input v-model="form.copyright_owner" type="text" class="field-input" placeholder="e.g. Sony Music"
                  @input="clearError(0, 'copyright_owner')" />
                <p v-if="stepErrors[0].copyright_owner" class="field-error">{{ stepErrors[0].copyright_owner }}</p>
              </div>
              <div class="field">
                <label class="field-label">License Type</label>
                <input v-model="form.license_type" type="text" class="field-input" placeholder="e.g. All Rights Reserved" />
              </div>
            </div>
          </section>

          <!-- STEP 1 · Audio Files -->
          <section v-show="currentStep === 1" class="form-section">
            <div class="section-heading">
              <div class="section-icon section-icon--green">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M3 18v-6a9 9 0 0 1 18 0v6" />
                  <path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3z" />
                  <path d="M3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z" />
                </svg>
              </div>
              <h2 class="section-title">Audio File <span style="font-size:12px;color:#64748b;font-weight:400">(optional – leave empty to keep current)</span></h2>
            </div>

            <!-- Current audio banner -->
            <div v-if="currentAudioUrl && !audioFile" class="current-audio-banner">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/>
              </svg>
              <div class="current-audio-banner__info">
                <span class="current-audio-banner__label">Current audio file</span>
                <span class="current-audio-banner__url">{{ currentAudioUrl }}</span>
              </div>
              <button class="current-audio-banner__play" type="button" @click="toggleCurrentAudio">
                <svg v-if="!isPlayingCurrent" width="13" height="13" viewBox="0 0 24 24" fill="currentColor">
                  <polygon points="5 3 19 12 5 21 5 3" />
                </svg>
                <svg v-else width="13" height="13" viewBox="0 0 24 24" fill="currentColor">
                  <rect x="6" y="4" width="4" height="16"/><rect x="14" y="4" width="4" height="16"/>
                </svg>
              </button>
              <audio ref="currentAudioEl" :src="currentAudioUrl" @ended="isPlayingCurrent = false" hidden />
            </div>

            <!-- Info banner -->
            <div class="audio-info-banner">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <circle cx="12" cy="12" r="10" /><line x1="12" y1="8" x2="12" y2="12" /><line x1="12" y1="16" x2="12.01" y2="16" />
              </svg>
              <span>Upload a new file to replace the current one. The backend will automatically handle splitting into
                <strong>Standard / HQ / Lossless</strong> and upload to Cloudinary.</span>
            </div>

            <!-- Upload zone -->
            <div class="upload-zone"
              :class="{ dragover: isDragging, 'has-file': audioFile }"
              @dragover.prevent="isDragging = true" @dragleave="isDragging = false" @drop.prevent="onDrop"
              @click="(audioInput as HTMLInputElement)?.click()">
              <input ref="audioInput" type="file" accept="audio/*" hidden @change="onAudioChange" />
              <template v-if="!audioFile">
                <div class="upload-icon">
                  <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                    <polyline points="17 8 12 3 7 8" /><line x1="12" y1="3" x2="12" y2="15" />
                  </svg>
                </div>
                <p class="upload-title">Drag & drop to replace audio</p>
                <p class="upload-sub">MP3, WAV, FLAC, AAC — max 200 MB</p>
                <button class="upload-browse-btn" type="button">Browse File</button>
              </template>
              <template v-else>
                <div class="upload-preview">
                  <div class="upload-preview__icon">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#43e97b" stroke-width="2">
                      <path d="M9 18V5l12-2v13" /><circle cx="6" cy="18" r="3" /><circle cx="18" cy="16" r="3" />
                    </svg>
                  </div>
                  <div class="upload-preview__info">
                    <p class="upload-preview__name">{{ audioFile.name }}</p>
                    <p class="upload-preview__size">{{ formatBytes(audioFile.size) }} · {{ formatDuration(form.duration) }}</p>
                  </div>
                  <button class="upload-remove-btn" type="button" @click.stop="removeAudio">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                      <line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" />
                    </svg>
                  </button>
                </div>
              </template>
            </div>

            <!-- Processing pipeline preview -->
            <div class="pipeline-preview">
              <p class="pipeline-title">Post-upload processing procedure</p>
              <div class="pipeline-steps">
                <div class="pipeline-step" :class="{ 'pipeline-step--active': !!audioFile }">
                  <div class="pipeline-step__dot"></div>
                  <div>
                    <p class="pipeline-step__label">① Original file received</p>
                    <p class="pipeline-step__sub">{{ audioFile ? audioFile.name : 'No new file selected' }}</p>
                  </div>
                </div>
                <div class="pipeline-arrow">→</div>
                <div class="pipeline-step">
                  <div class="pipeline-step__dot pipeline-step__dot--pending"></div>
                  <div>
                    <p class="pipeline-step__label">② Backend processing & separation</p>
                    <p class="pipeline-step__sub">Standard · HQ · Lossless</p>
                  </div>
                </div>
                <div class="pipeline-arrow">→</div>
                <div class="pipeline-step">
                  <div class="pipeline-step__dot pipeline-step__dot--pending"></div>
                  <div>
                    <p class="pipeline-step__label">③ Upload Cloudinary</p>
                    <p class="pipeline-step__sub">URLs are automatically saved to the database.</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Metadata -->
            <div class="form-grid form-grid--2" v-if="audioFile">
              <div class="field">
                <label class="field-label">Duration (auto-detect)</label>
                <div class="duration-display">
                  <span class="duration-value">{{ form.duration ? formatDuration(form.duration) : '—' }}</span>
                  <span class="duration-note">{{ form.duration || 0 }}s</span>
                </div>
              </div>
              <div class="field">
                <label class="field-label">File Size</label>
                <div class="duration-display">
                  <span class="duration-value" style="font-size:15px">{{ formatBytes(form.file_size) }}</span>
                  <span class="duration-note">{{ audioFile.type || 'audio' }}</span>
                </div>
              </div>
            </div>
          </section>

          <!-- STEP 2 · Artwork & Lyrics -->
          <section v-show="currentStep === 2" class="form-section">
            <div class="section-heading">
              <div class="section-icon section-icon--purple">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <rect x="3" y="3" width="18" height="18" rx="2" />
                  <circle cx="8.5" cy="8.5" r="1.5" /><polyline points="21 15 16 10 5 21" />
                </svg>
              </div>
              <h2 class="section-title">Artwork & Descriptions</h2>
            </div>

            <div class="artwork-layout">
              <!-- Cover upload -->
              <div class="cover-upload-wrap">
                <div class="cover-upload"
                  :style="coverPreview ? { backgroundImage: `url(${coverPreview})`, backgroundSize: 'cover', backgroundPosition: 'center' } : {}"
                  @click="(coverInput as HTMLInputElement)?.click()">
                  <input ref="coverInput" type="file" accept="image/*" hidden @change="onCoverChange" />
                  <template v-if="!coverPreview">
                    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#334155" stroke-width="1.5">
                      <rect x="3" y="3" width="18" height="18" rx="2" />
                      <circle cx="8.5" cy="8.5" r="1.5" /><polyline points="21 15 16 10 5 21" />
                    </svg>
                    <p class="cover-upload__hint">Click to upload cover</p>
                    <p class="cover-upload__sub">JPG, PNG — 1:1 ratio</p>
                  </template>
                  <div v-else class="cover-overlay">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
                      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                      <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                    </svg>
                    <span>Change</span>
                  </div>
                </div>
                <div class="field" style="margin-top:12px">
                  <label class="field-label">Cover URL (Cloudinary)</label>
                  <input v-model="form.cover_url" type="url" class="field-input"
                    placeholder="https://res.cloudinary.com/…/cover.jpg" />
                </div>
              </div>

              <!-- Lyrics -->
              <div class="lyrics-wrap">
                <div class="field" style="height:100%">
                  <label class="field-label">Descriptions</label>
                  <textarea v-model="form.descriptions" class="field-textarea"
                    placeholder="Paste or type song lyrics here…&#10;&#10;[Verse 1]&#10;..." rows="14"></textarea>
                  <p class="field-hint">Supports plain text. Line breaks are preserved.</p>
                </div>
              </div>
            </div>
          </section>

          <!-- STEP 3 · Settings -->
          <section v-show="currentStep === 3" class="form-section">
            <div class="section-heading">
              <div class="section-icon section-icon--orange">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <circle cx="12" cy="12" r="3" />
                  <path d="M19.07 4.93a10 10 0 0 1 0 14.14M4.93 4.93a10 10 0 0 0 0 14.14" />
                </svg>
              </div>
              <h2 class="section-title">Settings & Flags</h2>
            </div>

            <!-- Status -->
            <div class="field">
              <label class="field-label">Publish Status <span class="required">*</span></label>
              <div class="status-options">
                <label v-for="s in ['draft', 'published', 'blocked']" :key="s" class="status-option"
                  :class="{ active: form.status === s, ['status-option--' + s]: true }">
                  <input type="radio" :value="s" v-model="form.status" hidden />
                  <span class="status-dot"></span>
                  {{ s.charAt(0).toUpperCase() + s.slice(1) }}
                </label>
              </div>
            </div>

            <!-- Genre -->
            <div class="field">
              <label class="field-label">Genre <span class="required">*</span></label>
              <div class="status-options">
                <label v-for="genre in Genres" :key="genre.id" class="status-option"
                  :class="{ active: form.genre_id === genre.id, 'status-option--published': form.genre_id === genre.id }">
                  <input type="radio" :value="genre.id" v-model="form.genre_id" hidden />
                  <span class="status-dot"></span>
                  {{ genre.name }}
                </label>
              </div>
            </div>

            <!-- Partner -->
            <div class="field">
              <label class="field-label">Partner</label>
              <select v-model="form.partner_id" class="field-select">
                <option value="">-- No Partner --</option>
                <option v-for="p in usePartner.partners" :key="p.id" :value="p.id">{{ p.company_name }}</option>
              </select>
            </div>

            <!-- Toggles -->
            <div class="toggles-grid">
              <div class="toggle-card" v-for="flag in flags" :key="flag.key" :class="{ active: form[flag.key] }">
                <div class="toggle-info">
                  <div class="toggle-icon" :class="'toggle-icon--' + flag.color">
                    <span>{{ flag.emoji }}</span>
                  </div>
                  <div>
                    <p class="toggle-label">{{ flag.label }}</p>
                    <p class="toggle-desc">{{ flag.desc }}</p>
                  </div>
                </div>
                <button type="button" class="toggle-switch" :class="{ on: form[flag.key] }"
                  @click="form[flag.key] = !form[flag.key]">
                  <span class="toggle-knob"></span>
                </button>
              </div>
            </div>
          </section>

          <!-- Step Navigation -->
          <div class="step-nav">
            <button v-if="currentStep > 0" class="btn-prev" @click="currentStep--">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="15 18 9 12 15 6" />
              </svg>
              Previous
            </button>
            <div v-else></div>
            <button v-if="currentStep < steps.length - 1" class="btn-next" @click="nextStep">
              Next
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="9 18 15 12 9 6" />
              </svg>
            </button>
            <button v-else class="btn-publish" @click="update" :disabled="loading">
              <template v-if="!loading">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
                  <polyline points="20 6 9 17 4 12" />
                </svg>
                Save Changes
              </template>
              <template v-else>
                <span class="spinner"></span>
                Saving...
              </template>
            </button>
          </div>
        </div>

        <!-- RIGHT COLUMN · Preview Card -->
        <div class="col-preview">
          <div class="preview-card">
            <p class="preview-heading">Live Preview</p>
            <div class="preview-cover"
              :style="coverPreview ? { backgroundImage: `url(${coverPreview})`, backgroundSize: 'cover', backgroundPosition: 'center' } : { background: previewGradient }">

              <audio
                ref="audioPlayer"
                :src="audioObjectUrl"
                @ended="isPlaying = false; currentTime = 0"
                @timeupdate="onTimeUpdate"
              />

              <div class="preview-cover__overlay">
                <button class="preview-play-btn" @click="togglePlay" type="button">
                  <svg v-if="!isPlaying" width="18" height="18" viewBox="0 0 24 24" fill="white">
                    <polygon points="5 3 19 12 5 21 5 3" />
                  </svg>
                  <svg v-else width="18" height="18" viewBox="0 0 24 24" fill="white">
                    <rect x="6" y="4" width="4" height="16" /><rect x="14" y="4" width="4" height="16" />
                  </svg>
                </button>
              </div>

              <span class="preview-duration">{{ form.duration ? formatDuration(form.duration) : '0:00' }}</span>

              <div class="yt-progress" @click="seekTo">
                <div class="yt-progress__fill" :style="{ width: form.duration ? (currentTime / form.duration * 100) + '%' : '0%' }" />
                <div class="yt-progress__thumb" :style="{ left: form.duration ? (currentTime / form.duration * 100) + '%' : '0%' }" />
              </div>
            </div>

            <div v-if="audioObjectUrl" class="yt-time-row">
              <span>{{ formatDuration(Math.floor(currentTime)) }}</span>
              <span>{{ formatDuration(form.duration) }}</span>
            </div>

            <div class="preview-body">
              <p class="preview-title">{{ form.title || 'Song Title' }}</p>
              <p class="preview-artist">{{ selectedArtistName }}</p>
              <p class="preview-album">{{ selectedAlbumName || '—' }}</p>

              <div class="preview-waveform">
                <div v-for="(h, i) in animatedHeights" :key="i" class="wave-bar"
                  :class="{ 'wave-bar--active': isPlaying }"
                  :style="{ height: h + 'px' }" />
              </div>

              <div class="preview-tags">
                <span class="status-badge" :class="'status--' + form.status">{{ form.status }}</span>
                <span v-if="form.is_premium" class="preview-tag preview-tag--premium">⭐ Premium</span>
                <span v-if="form.is_explicit" class="preview-tag preview-tag--explicit">🔞 Explicit</span>
                <span v-if="form.is_featured" class="preview-tag preview-tag--featured">🔥 Featured</span>
                <span v-if="form.allow_download" class="preview-tag preview-tag--download">⬇ Download</span>
              </div>

              <div class="preview-meta">
                <div class="preview-meta__row" v-if="form.year">
                  <span class="meta-key">Year</span><span class="meta-val">{{ form.year }}</span>
                </div>
                <div class="preview-meta__row" v-if="form.quality">
                  <span class="meta-key">Quality</span>
                  <span class="quality-tag" :class="'quality-tag--' + form.quality">{{ form.quality }}</span>
                </div>
                <div class="preview-meta__row" v-if="form.bitrate">
                  <span class="meta-key">Bitrate</span><span class="meta-val">{{ form.bitrate }} kbps</span>
                </div>
                <div class="preview-meta__row" v-if="form.isrc">
                  <span class="meta-key">ISRC</span><span class="meta-val isrc">{{ form.isrc }}</span>
                </div>
                <!-- Song ID badge for update mode -->
                <div class="preview-meta__row">
                  <span class="meta-key">Song ID</span>
                  <span class="meta-val" style="color:#00c6ff;font-weight:600">#{{ songId }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- JSON Payload preview -->
          <div class="payload-preview">
            <div class="payload-header">
              <p class="payload-title">Update Payload</p>
              <button class="payload-copy" @click="copyPayload">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <rect x="9" y="9" width="13" height="13" rx="2" />
                  <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1" />
                </svg>
                {{ copied ? 'Copied!' : 'Copy' }}
              </button>
            </div>
            <pre class="payload-code">{{ payloadJson }}</pre>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onUnmounted, onMounted, reactive } from 'vue'
import { useRoute } from 'vue-router'
import { useArtistStore } from '@/modules/admin/stores/artists/artistsStore'
import { usePartnerStore } from '@/modules/admin/stores/partners/partnersStore'
import { useGenrestore } from '@/modules/admin/stores/genres/genresStore'
import { useSongStore } from '@/modules/admin/stores/songs/songsStore'
import type { ArtistInterface } from '@/interfaces/artists.interface'
import type { Album, Flag } from '@/modules/admin/interfaces/songs/create-song.payload'
import type { UpdateSongPayload } from "@/modules/admin/interfaces/songs/update_song.payload";
import { useNotificationStore } from '@/store/notificationStore'
import { useCloudinaryUpload } from '@/composables/Usecloudinaryupload'
import { storeToRefs } from 'pinia'
import router from '@/modules/router'

// ── Route ──
const route  = useRoute()
const songId = computed<number>(() => Number(route.params.id))

// ── Stores ──
const useArtist  = useArtistStore()
const usePartner = usePartnerStore()
const useGenre   = useGenrestore()
const useSong    = useSongStore()
const notificationStore = useNotificationStore()

// ── Steps ──
const steps       = ['Basic Info', 'Audio Files', 'Artwork & Lyrics', 'Settings'] as const
const currentStep = ref<number>(0)
const isFetching  = ref<boolean>(true)

// ── Validation types ──
type Step0Errors = { title?: string; artist_id?: string; year?: string; copyright_owner?: string }
type Step1Errors = { audio_file?: string }
type Step2Errors = Record<string, never>
type Step3Errors = Record<string, never>

const stepErrors = ref<[Step0Errors, Step1Errors, Step2Errors, Step3Errors]>([{}, {}, {}, {}])

function validateStep(step: number): boolean {
  stepErrors.value[step] = {} as any

  if (step === 0) {
    const e: Step0Errors = {}
    if (!form.title.trim())           e.title           = 'Song title is required.'
    if (!form.artist_id)              e.artist_id       = 'Please select an artist.'
    if (!form.year || form.year < 1900 || form.year > 2099)
                                      e.year            = 'Enter a valid year (1900–2099).'
    if (!form.copyright_owner.trim()) e.copyright_owner = 'Copyright owner is required.'
    stepErrors.value[0] = e
    return Object.keys(e).length === 0
  }

  // Step 1: audio is optional on update
  return true
}

function clearError(step: number, field: string): void {
  (stepErrors.value[step] as Record<string, string | undefined>)[field] = undefined
}

function nextStep(): void {
  if (validateStep(currentStep.value)) currentStep.value++
}

function goToStep(i: number): void {
  if (i < currentStep.value) { currentStep.value = i; return }
  for (let s = currentStep.value; s < i; s++) {
    if (!validateStep(s)) return
  }
  currentStep.value = i
}

// ── Form ──
// UpdateSongPayload: same as Create but audio_file is optional
const form = reactive<UpdateSongPayload>({
  title: '', slug: '', artist_id: '', album_id: '',
  year: new Date().getFullYear(),
  track_number: null, disc_number: 1, isrc: '',
  copyright_owner: '', license_type: '',
  audio_file: null,
  duration: 0, file_size: 0, bitrate: 320, quality: 'high',
  cover_file: null, cover_url: '',
  descriptions: '',lyrics:'',
  status: 'draft', partner_id: '',genre_id: '',
  is_premium: false, is_explicit: false, is_featured: false, allow_download: false,
})

// Current audio URL from the existing song record
const currentAudioUrl    = ref<string>('')
const currentAudioEl     = ref<HTMLAudioElement | null>(null)
const isPlayingCurrent   = ref<boolean>(false)

function toggleCurrentAudio(): void {
  if (!currentAudioEl.value) return
  if (isPlayingCurrent.value) {
    currentAudioEl.value.pause()
    isPlayingCurrent.value = false
  } else {
    currentAudioEl.value.play()
    isPlayingCurrent.value = true
  }
}

// ── Load existing song ──
async function loadSong(): Promise<void> {
  try {
    isFetching.value = true
    const song = await useSong.fetchSongById(songId.value)

    form.title           = song.title           ?? ''
    form.slug            = song.slug            ?? ''

    // Extract .id từ nested objects (SongArtist / SongAlbum / SongPartner)
    form.artist_id       = song.artist?.id      ?? ''
    form.album_id        = song.album?.id       ?? ''
    form.partner_id      = song.partner?.id     ?? ''

    form.year            = song.year            ?? new Date().getFullYear()
    form.track_number    = song.track_number    ?? null
    form.disc_number     = song.disc_number     ?? 1
    form.isrc            = song.isrc            ?? ''
    form.copyright_owner = song.copyright_owner ?? ''
    form.license_type    = song.license_type    ?? ''
    form.duration        = song.duration        ?? 0
    form.file_size       = song.file_size       ?? 0
    form.bitrate         = song.bitrate         ?? 320
    form.quality         = song.quality         ?? 'high'
    form.cover_url       = song.cover_url       ?? ''
    form.lyrics          = song.lyrics          ?? ''


    const editableStatuses = ['draft', 'published', 'blocked'] as const
    form.status = editableStatuses.includes(song.status as any)
      ? (song.status as 'draft' | 'published' | 'blocked')
      : 'draft'

    form.genre_id        = song.genre?.id       ?? ''
    form.is_premium      = song.is_premium      ?? false
    form.is_explicit     = song.is_explicit     ?? false
    form.is_featured     = song.is_featured     ?? false
    form.allow_download  = song.allow_download  ?? false

    if (song.cover_url) coverPreview.value = song.cover_url
    currentAudioUrl.value = song.urls?.standard ?? song.urls?.low ?? song.urls?.lossless ?? ''

  } catch {
    notificationStore.notify('Failed to load song data', 'error')
    router.back()
  } finally {
    isFetching.value = false
  }
}

console.log(form.genre_id);


// ── Mock data ──
const mockAlbums = ref<Album[]>([])

// ── Flags ──
const flags: Flag[] = [
  { key: 'is_premium',     label: 'Premium',          desc: 'Requires premium subscription', emoji: '⭐', color: 'yellow' },
  { key: 'is_explicit',    label: 'Explicit Content', desc: 'Contains explicit language',    emoji: '🔞', color: 'red'    },
  { key: 'is_featured',    label: 'Featured',         desc: 'Show in featured carousel',     emoji: '🔥', color: 'orange' },
  { key: 'allow_download', label: 'Allow Download',   desc: 'Users can download this track', emoji: '⬇',  color: 'green'  },
]

// ── Waveform ──
const waveHeights: number[] = [8, 14, 20, 28, 18, 10, 24, 32, 16, 12, 26, 20, 8, 30, 18, 14, 22, 28, 10, 20]
const animatedHeights = ref<number[]>([...waveHeights])
let waveAnimFrame: number | null = null
const { Genres } = storeToRefs(useGenre)

// ── File & Audio state ──
const audioFile      = ref<File | null>(null)
const audioObjectUrl = ref<string>('')
const audioPlayer    = ref<HTMLAudioElement | null>(null)
const isPlaying      = ref<boolean>(false)
const currentTime    = ref<number>(0)
const coverPreview   = ref<string>('')
const isDragging     = ref<boolean>(false)
const copied         = ref<boolean>(false)
const audioInput     = ref<HTMLInputElement | null>(null)
const coverInput     = ref<HTMLInputElement | null>(null)
const loading        = ref<boolean>(false)
const { uploadCover } = useCloudinaryUpload()

// ── Watch audioFile ──
watch(audioFile, (newFile) => {
  form.audio_file = newFile ?? null

  if (audioObjectUrl.value) {
    URL.revokeObjectURL(audioObjectUrl.value)
    audioObjectUrl.value = ''
  }

  isPlaying.value   = false
  currentTime.value = 0
  stopWave()

  if (newFile) audioObjectUrl.value = URL.createObjectURL(newFile)
})

onUnmounted(() => {
  if (audioObjectUrl.value) URL.revokeObjectURL(audioObjectUrl.value)
  stopWave()
})

// ── Computed ──
const selectedArtistName = computed(() => {
  if (!form.artist_id) return 'Singer not yet selected.'
  const artist = useArtist.artists.find((a: ArtistInterface) => a.id === form.artist_id)
  return artist?.name || 'No singer found'
})

const selectedAlbumName = computed<string>(() =>
  mockAlbums.value.find(a => a.id === form.album_id)?.name ?? ''
)

const previewGradient = computed<string>(() => {
  const gradients = [
    'linear-gradient(135deg,#00c6ff,#0072ff)',
    'linear-gradient(135deg,#f093fb,#f5576c)',
    'linear-gradient(135deg,#43e97b,#38f9d7)',
    'linear-gradient(135deg,#f7971e,#ffd200)',
  ]
  const index = typeof form.artist_id === 'number' ? form.artist_id : 0
  return gradients[index % gradients.length]
})

const payloadJson = computed<string>(() => {
  const payload = { ...form } as Record<string, unknown>
  if (payload.audio_file instanceof File) payload.audio_file = payload.audio_file.name
  if (payload.cover_file  instanceof File) payload.cover_file  = payload.cover_file.name
  Object.keys(payload).forEach(k => { if (payload[k] === '' || payload[k] === null) delete payload[k] })
  return JSON.stringify({ id: songId.value, ...payload }, null, 2)
})

// ── Audio playback ──
function togglePlay(): void {
  if (!audioPlayer.value || !audioObjectUrl.value) return
  if (isPlaying.value) {
    audioPlayer.value.pause()
    isPlaying.value = false
    stopWave()
  } else {
    audioPlayer.value.play()
    isPlaying.value = true
    animateWave()
  }
}

function onTimeUpdate(): void {
  if (audioPlayer.value) currentTime.value = audioPlayer.value.currentTime
}

function seekTo(e: MouseEvent): void {
  if (!audioPlayer.value || !form.duration) return
  const bar   = e.currentTarget as HTMLElement
  const rect  = bar.getBoundingClientRect()
  const ratio = (e.clientX - rect.left) / rect.width
  audioPlayer.value.currentTime = ratio * form.duration
}

function animateWave(): void {
  animatedHeights.value = waveHeights.map((base, i) => {
    const variation = Math.sin(Date.now() / 200 + i * 0.8) * 8
    return Math.max(4, Math.min(36, base + variation))
  })
  waveAnimFrame = requestAnimationFrame(animateWave)
}

function stopWave(): void {
  if (waveAnimFrame) { cancelAnimationFrame(waveAnimFrame); waveAnimFrame = null }
  animatedHeights.value = [...waveHeights]
}

// ── File handlers ──
function setAudioFile(file: File): void {
  audioFile.value = file
  detectDuration(file)
}

function onAudioChange(e: Event): void {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (file) setAudioFile(file)
}

function onDrop(e: DragEvent): void {
  isDragging.value = false
  const file = e.dataTransfer?.files[0]
  if (file?.type.startsWith('audio/')) setAudioFile(file)
}

function removeAudio(): void {
  audioPlayer.value?.pause()
  isPlaying.value   = false
  currentTime.value = 0
  stopWave()
  audioFile.value = null
  form.audio_file = null
  form.duration   = 0
  form.file_size  = 0
}

function detectDuration(file: File): void {
  const audio     = new Audio()
  const objectUrl = URL.createObjectURL(file)
  audio.src       = objectUrl
  audio.onloadedmetadata = () => {
    form.duration  = Math.round(audio.duration)
    form.file_size = file.size
    URL.revokeObjectURL(objectUrl)
  }
}

async function onCoverChange(e: Event) {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (!file) return
  const reader = new FileReader()
  reader.onload = (ev) => { coverPreview.value = ev.target?.result as string }
  reader.readAsDataURL(file)
  const url = await uploadCover(file)
  form.cover_url = url
}

// ── Utilities ──
function autoSlug(): void {
  form.slug = form.title
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^a-z0-9\s-]/g, '')
    .trim()
    .replace(/\s+/g, '-')
}

function formatBytes(bytes: number): string {
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB'
  return (bytes / (1024 * 1024)).toFixed(2) + ' MB'
}

function formatDuration(secs: number): string {
  const m = Math.floor(secs / 60)
  const s = secs % 60
  return `${m}:${String(s).padStart(2, '0')}`
}

// ── Actions ──
function saveDraft(): void {
  form.status = 'draft'
  update()
}

async function update(): Promise<void> {
  if (loading.value) return

  let allValid = true
  for (let s = 0; s < steps.length; s++) {
    if (!validateStep(s)) {
      allValid     = false
      currentStep.value = s
      break
    }
  }
  if (!allValid) return

  await submitForm()
}

async function copyPayload(): Promise<void> {
  await navigator.clipboard.writeText(payloadJson.value)
  copied.value = true
  setTimeout(() => { copied.value = false }, 2000)
}

async function submitForm(): Promise<void> {
  try {
    loading.value = true

    // Build payload — omit audio_file if no new file chosen
    const payload: UpdateSongPayload = { ...form }
    if (!payload.audio_file) delete (payload as any).audio_file

    await useSong.fetchUpdateSong(songId.value, payload)

    notificationStore.notify('Song updated successfully!', 'success')
    setTimeout(() => notificationStore.clear(), 3000)

    router.push({ name: 'admin.songsmanager.all' })

  } catch (err: any) {
    notificationStore.notify(err.response?.data?.message || 'Failed to update song', 'error')
  } finally {
    loading.value = false
    setTimeout(() => notificationStore.clear(), 3000)
  }
}

// ── Lifecycle ──
onMounted(async () => {
  try {
    await Promise.all([
      useArtist.fetchArtists(),
      usePartner.fetchPartners(),
      useGenre.fetchGenres(),
    ])
    await loadSong()
  } catch {
    notificationStore.notify('Error fetching data', 'error')
  }
})
</script>

<style scoped>
* { box-sizing: border-box; margin: 0; padding: 0; }

.song-add-page {
  background: rgba(255, 255, 255, 0.08);
  min-height: 100vh;
  border-radius: 14px;
  padding: 28px 36px 60px;
  font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
  color: #e2e8f0;
}

/* ── Fetching overlay ── */
.fetching-overlay {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  padding: 80px 0;
  color: #64748b;
  font-size: 14px;
}

.fetching-spinner {
  width: 36px;
  height: 36px;
  border: 3px solid #1e2535;
  border-top-color: #00c6ff;
  border-radius: 50%;
  animation: spin .8s linear infinite;
}

/* ── Current audio banner ── */
.current-audio-banner {
  display: flex;
  align-items: center;
  gap: 12px;
  background: rgba(67, 233, 123, 0.07);
  border: 1px solid rgba(67, 233, 123, 0.2);
  border-radius: 10px;
  padding: 12px 16px;
  color: #94a3b8;
  font-size: 13px;
}

.current-audio-banner svg { color: #43e97b; flex-shrink: 0; }

.current-audio-banner__info {
  display: flex;
  flex-direction: column;
  gap: 3px;
  flex: 1;
  min-width: 0;
}

.current-audio-banner__label {
  font-size: 11px;
  font-weight: 700;
  color: #43e97b;
  text-transform: uppercase;
  letter-spacing: .05em;
}

.current-audio-banner__url {
  font-size: 11.5px;
  color: #4a5568;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.current-audio-banner__play {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background: rgba(67, 233, 123, .12);
  border: 1px solid rgba(67, 233, 123, .3);
  color: #43e97b;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: background .2s;
}

.current-audio-banner__play:hover { background: rgba(67, 233, 123, .2); }

/* ── Header ── */
.page-header {
  display: flex; align-items: center; justify-content: space-between;
  margin-bottom: 24px; flex-wrap: wrap; gap: 14px;
}
.page-header__left  { display: flex; align-items: center; gap: 16px; }
.page-header__right { display: flex; align-items: center; gap: 10px; }

.btn-back {
  display: flex; align-items: center; gap: 6px;
  padding: 8px 14px; background: rgba(0,0,0,.2);
  border: 1px solid #2d3748; border-radius: 8px;
  color: #94a3b8; font-size: 13px; cursor: pointer;
  transition: border-color .2s, color .2s; white-space: nowrap;
}
.btn-back:hover { border-color: #00c6ff; color: #00c6ff; }

.page-title {
  font-size: 24px; font-weight: 700;
  background: linear-gradient(90deg, #00d2ff, #7b2ff7);
  -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
}
.page-subtitle { font-size: 13px; color: #64748b; margin-top: 3px; }

.btn-save-draft {
  display: flex; align-items: center; gap: 7px;
  padding: 9px 18px; background: #1e2535;
  border: 1px solid #2d3748; border-radius: 9px;
  color: #94a3b8; font-size: 13px; font-weight: 500; cursor: pointer;
  transition: border-color .2s, color .2s;
}
.btn-save-draft:hover { border-color: #00c6ff; color: #00c6ff; }

.btn-publish {
  display: flex; align-items: center; gap: 7px;
  padding: 9px 20px; background: linear-gradient(90deg, #00c6ff, #0072ff);
  border: none; border-radius: 9px; color: #fff;
  font-size: 13px; font-weight: 600; cursor: pointer; transition: opacity .2s;
}
.btn-publish:hover { opacity: .85; }
.btn-publish:disabled { opacity: .6; cursor: not-allowed; }

.spinner {
  width: 14px; height: 14px;
  border: 2px solid #fff; border-top: 2px solid transparent;
  border-radius: 50%; animation: spin .6s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* ── Steps Bar ── */
.steps-bar {
  display: flex; align-items: center; margin-bottom: 28px;
  background: rgba(0,0,0,.2); border-radius: 12px;
  padding: 16px 24px; border: 1px solid #1e2535; gap: 0;
}
.step { display: flex; align-items: center; gap: 10px; cursor: pointer; flex: 1; }
.step-circle {
  width: 30px; height: 30px; border-radius: 50%;
  border: 2px solid #2d3748; background: #0f1117;
  display: flex; align-items: center; justify-content: center;
  font-size: 12px; font-weight: 700; color: #4a5568; flex-shrink: 0; transition: all .3s;
}
.step.active .step-circle { border-color: #00c6ff; color: #00c6ff; background: rgba(0,198,255,.1); }
.step.done  .step-circle  { border-color: #43e97b; color: #43e97b; background: rgba(67,233,123,.1); }
.step-label { font-size: 13px; color: #4a5568; white-space: nowrap; transition: color .3s; }
.step.active .step-label  { color: #e2e8f0; font-weight: 600; }
.step.done   .step-label  { color: #64748b; }
.step-line {
  flex: 1; height: 2px; background: #1e2535;
  margin: 0 10px; border-radius: 1px; transition: background .3s;
}
.step-line.done { background: #43e97b; }

/* ── Layout ── */
.form-layout { display: grid; grid-template-columns: 1fr 320px; gap: 20px; align-items: start; }

/* ── Form Section ── */
.form-section {
  background: rgba(0,0,0,.2); border-radius: 14px;
  padding: 24px; border: 1px solid #1e2535;
  display: flex; flex-direction: column; gap: 20px;
}
.section-heading { display: flex; align-items: center; gap: 12px; margin-bottom: 4px; }
.section-icon {
  width: 34px; height: 34px; border-radius: 8px;
  display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.section-icon--blue   { background: rgba(0,198,255,.12);   color: #00c6ff; }
.section-icon--green  { background: rgba(67,233,123,.12);  color: #43e97b; }
.section-icon--purple { background: rgba(167,139,250,.12); color: #a78bfa; }
.section-icon--orange { background: rgba(251,146,60,.12);  color: #fb923c; }
.section-title { font-size: 16px; font-weight: 600; color: #f1f5f9; }

/* ── Grid ── */
.form-grid { display: grid; gap: 14px; }
.form-grid--2 { grid-template-columns: 1fr 1fr; }
.form-grid--4 { grid-template-columns: 1fr 1fr 1fr 1fr; }
.field--full  { grid-column: 1 / -1; }

/* ── Fields ── */
.field { display: flex; flex-direction: column; gap: 6px; }
.field-label {
  font-size: 12.5px; font-weight: 600; color: #64748b;
  text-transform: uppercase; letter-spacing: .04em;
  display: flex; align-items: center; gap: 6px;
}
.required  { color: #f87171; }
.field-hint { font-size: 11.5px; color: #334155; margin-top: 4px; }

.field--error .field-input,
.field--error .field-select { border-color: #f87171 !important; background: rgba(248,113,113,.05); }

.field-error {
  font-size: 12px; color: #f87171;
  display: flex; align-items: center; gap: 5px;
  margin-top: 2px; animation: errorShake .3s ease;
}
.field-error::before { content: '⚠'; font-size: 11px; }
@keyframes errorShake {
  0%,100% { transform: translateX(0); }
  25%     { transform: translateX(-4px); }
  75%     { transform: translateX(4px); }
}

.field-input,.field-select,.field-textarea {
  background: #0f1117; border: 1px solid #2d3748;
  border-radius: 8px; padding: 10px 14px; color: #e2e8f0;
  font-size: 13.5px; outline: none; width: 100%;
  transition: border-color .2s; font-family: inherit;
}
.field-input::placeholder,.field-textarea::placeholder { color: #334155; }
.field-input:focus,.field-select:focus,.field-textarea:focus { border-color: #0072ff; }
.field-select { cursor: pointer; }
.field-textarea { resize: vertical; min-height: 220px; line-height: 1.6; }

.input-prefix-wrap { display: flex; align-items: center; }
.input-prefix {
  background: #1e2535; border: 1px solid #2d3748; border-right: none;
  border-radius: 8px 0 0 8px; padding: 10px 12px;
  color: #4a5568; font-size: 13px; white-space: nowrap;
}
.field-input--prefixed { border-radius: 0 8px 8px 0; }

.duration-display {
  background: #0f1117; border: 1px solid #2d3748;
  border-radius: 8px; padding: 10px 14px;
  display: flex; align-items: center; justify-content: space-between;
}
.duration-value { font-size: 18px; font-weight: 700; color: #00c6ff; }
.duration-note  { font-size: 11px; color: #334155; }

.quality-tag { display: inline-block; padding: 2px 8px; border-radius: 6px; font-size: 11px; font-weight: 500; }
.quality-tag--hq,.quality-tag--high { background: rgba(0,198,255,.12); color: #00c6ff; }
.quality-tag--lossless { background: rgba(167,139,250,.12); color: #a78bfa; }

/* ── Upload Zone ── */
.upload-zone {
  border: 2px dashed #2d3748; border-radius: 12px;
  padding: 36px 24px; display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  gap: 10px; cursor: pointer; transition: border-color .2s, background .2s; text-align: center;
}
.upload-zone:hover,.upload-zone.dragover { border-color: #00c6ff; background: rgba(0,198,255,.04); }
.upload-zone.has-file { border-style: solid; border-color: #43e97b; background: rgba(67,233,123,.03); }
.upload-icon { color: #334155; }
.upload-title  { font-size: 15px; font-weight: 600; color: #94a3b8; }
.upload-sub    { font-size: 12.5px; color: #4a5568; }
.upload-browse-btn {
  margin-top: 4px; padding: 8px 20px; background: #1e2535;
  border: 1px solid #2d3748; border-radius: 8px;
  color: #94a3b8; font-size: 13px; cursor: pointer; transition: border-color .2s, color .2s;
}
.upload-browse-btn:hover { border-color: #00c6ff; color: #00c6ff; }
.upload-preview { display: flex; align-items: center; gap: 14px; width: 100%; }
.upload-preview__icon {
  width: 44px; height: 44px; background: rgba(67,233,123,.1);
  border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.upload-preview__info { flex: 1; text-align: left; }
.upload-preview__name { font-size: 14px; font-weight: 600; color: #f1f5f9; }
.upload-preview__size { font-size: 12px; color: #64748b; margin-top: 2px; }
.upload-remove-btn {
  width: 30px; height: 30px; border-radius: 8px;
  background: rgba(248,113,113,.1); border: 1px solid rgba(248,113,113,.3);
  color: #f87171; cursor: pointer; display: flex; align-items: center; justify-content: center;
}

/* ── Artwork Layout ── */
.artwork-layout { display: grid; grid-template-columns: 200px 1fr; gap: 20px; }
.cover-upload-wrap { display: flex; flex-direction: column; }
.cover-upload {
  width: 200px; height: 200px; border-radius: 12px;
  background: #1e2535; border: 2px dashed #2d3748;
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  gap: 8px; cursor: pointer; overflow: hidden;
  position: relative; transition: border-color .2s;
}
.cover-upload:hover { border-color: #a78bfa; }
.cover-upload__hint { font-size: 12.5px; font-weight: 600; color: #4a5568; }
.cover-upload__sub  { font-size: 11px; color: #334155; }
.cover-overlay {
  position: absolute; inset: 0; background: rgba(0,0,0,.5);
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  gap: 6px; opacity: 0; transition: opacity .2s; color: white; font-size: 12px;
}
.cover-upload:hover .cover-overlay { opacity: 1; }

/* ── Status Options ── */
.status-options { display: flex; gap: 10px; flex-wrap: wrap; }
.status-option {
  display: flex; align-items: center; gap: 8px;
  padding: 10px 18px; border-radius: 10px;
  border: 1px solid #2d3748; background: #0f1117;
  cursor: pointer; font-size: 13px; color: #64748b; transition: all .2s;
}
.status-option.active { background: rgba(0,0,0,.2); }
.status-dot { width: 8px; height: 8px; border-radius: 50%; background: currentColor; }
.status-option--draft.active     { border-color: #64748b; color: #94a3b8; }
.status-option--published.active { border-color: #43e97b; color: #43e97b; }
.status-option--blocked.active   { border-color: #f87171; color: #f87171; }

/* ── Toggles ── */
.toggles-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.toggle-card {
  display: flex; align-items: center; justify-content: space-between;
  background: #0f1117; border: 1px solid #1e2535;
  border-radius: 12px; padding: 14px 16px; transition: border-color .2s;
}
.toggle-card.active { border-color: #2d3748; }
.toggle-info { display: flex; align-items: center; gap: 12px; }
.toggle-icon {
  width: 36px; height: 36px; border-radius: 9px;
  flex-shrink: 0; display: flex; align-items: center; justify-content: center; font-size: 18px;
}
.toggle-icon--yellow { background: rgba(251,191,36,.1); }
.toggle-icon--red    { background: rgba(248,113,113,.1); }
.toggle-icon--orange { background: rgba(251,146,60,.1); }
.toggle-icon--green  { background: rgba(67,233,123,.1); }
.toggle-label { font-size: 13.5px; font-weight: 600; color: #e2e8f0; }
.toggle-desc  { font-size: 11.5px; color: #4a5568; margin-top: 2px; }
.toggle-switch {
  width: 44px; height: 24px; border-radius: 12px;
  background: #1e2535; border: 1px solid #2d3748;
  cursor: pointer; position: relative; transition: background .2s, border-color .2s; flex-shrink: 0;
}
.toggle-switch.on { background: linear-gradient(90deg, #00c6ff, #0072ff); border-color: #00c6ff; }
.toggle-knob {
  position: absolute; top: 3px; left: 3px;
  width: 16px; height: 16px; border-radius: 50%;
  background: #64748b; transition: transform .2s, background .2s;
}
.toggle-switch.on .toggle-knob { transform: translateX(20px); background: #fff; }

/* ── Step Nav ── */
.step-nav { display: flex; justify-content: space-between; align-items: center; margin-top: 8px; }
.btn-prev {
  display: flex; align-items: center; gap: 6px;
  padding: 10px 20px; background: #1e2535;
  border: 1px solid #2d3748; border-radius: 9px;
  color: #94a3b8; font-size: 13px; font-weight: 500; cursor: pointer; transition: all .2s;
}
.btn-prev:hover { border-color: #00c6ff; color: #00c6ff; }
.btn-next {
  display: flex; align-items: center; gap: 6px;
  padding: 10px 22px; background: linear-gradient(90deg, #00c6ff, #0072ff);
  border: none; border-radius: 9px; color: #fff;
  font-size: 13px; font-weight: 600; cursor: pointer; transition: opacity .2s;
}
.btn-next:hover { opacity: .85; }

/* ── Preview Card ── */
.col-preview { position: sticky; top: 24px; display: flex; flex-direction: column; gap: 16px; }
.preview-card { background: rgba(0,0,0,.2); border-radius: 14px; border: 1px solid #1e2535; overflow: hidden; }
.preview-heading {
  padding: 14px 16px 0; font-size: 11.5px; text-transform: uppercase;
  letter-spacing: .08em; color: #334155; font-weight: 700;
}
.preview-cover {
  height: 200px; position: relative;
  display: flex; align-items: center; justify-content: center;
  margin: 12px 12px 0; border-radius: 10px; overflow: hidden;
}
.preview-cover__overlay {
  position: absolute; inset: 0; background: rgba(0,0,0,.3);
  display: flex; align-items: center; justify-content: center;
}
.preview-play-btn {
  width: 50px; height: 50px; border-radius: 50%;
  background: rgba(255,255,255,.2); border: 2px solid rgba(255,255,255,.5);
  display: flex; align-items: center; justify-content: center; cursor: pointer;
}
.preview-duration {
  position: absolute; bottom: 8px; right: 10px;
  font-size: 11px; color: rgba(255,255,255,.85);
  background: rgba(0,0,0,.4); padding: 2px 7px; border-radius: 4px;
}
.preview-body { padding: 14px 16px 16px; }
.preview-title  { font-size: 16px; font-weight: 700; color: #f1f5f9; }
.preview-artist { font-size: 13px; color: #64748b; margin-top: 3px; }
.preview-album  { font-size: 11.5px; color: #334155; margin-top: 2px; }
.preview-waveform { display: flex; align-items: flex-end; gap: 3px; height: 36px; margin: 14px 0 12px; }
.wave-bar {
  flex: 1; background: linear-gradient(180deg, #00c6ff, rgba(0,114,255,.3));
  border-radius: 2px; min-height: 4px; opacity: .7;
}
.preview-tags { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 14px; }
.preview-tag { font-size: 11px; padding: 3px 8px; border-radius: 6px; font-weight: 500; }
.preview-tag--premium  { background: rgba(251,191,36,.12);  color: #fbbf24; }
.preview-tag--explicit { background: rgba(248,113,113,.12); color: #f87171; }
.preview-tag--featured { background: rgba(251,146,60,.12);  color: #fb923c; }
.preview-tag--download { background: rgba(67,233,123,.12);  color: #43e97b; }
.preview-meta { display: flex; flex-direction: column; gap: 6px; }
.preview-meta__row { display: flex; justify-content: space-between; align-items: center; }
.meta-key { font-size: 11.5px; color: #334155; }
.meta-val  { font-size: 12px; color: #94a3b8; }
.meta-val.isrc { font-family: monospace; font-size: 11.5px; }
.status-badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 11.5px; font-weight: 600; text-transform: capitalize; }
.status--draft     { background: rgba(100,116,139,.15); color: #64748b; }
.status--published { background: rgba(67,233,123,.15);  color: #43e97b; }
.status--blocked   { background: rgba(248,113,113,.15); color: #f87171; }

/* ── Payload ── */
.payload-preview { background: #0d1117; border: 1px solid #1e2535; border-radius: 12px; overflow: hidden; }
.payload-header { display: flex; justify-content: space-between; align-items: center; padding: 10px 14px; border-bottom: 1px solid #1e2535; }
.payload-title { font-size: 11.5px; color: #334155; font-weight: 700; text-transform: uppercase; letter-spacing: .07em; }
.payload-copy {
  display: flex; align-items: center; gap: 5px;
  padding: 4px 10px; background: rgba(0,0,0,.2);
  border: 1px solid #2d3748; border-radius: 6px;
  color: #64748b; font-size: 11.5px; cursor: pointer; transition: all .2s;
}
.payload-copy:hover { border-color: #00c6ff; color: #00c6ff; }
.payload-code {
  padding: 14px; font-family: 'Fira Code','Courier New',monospace;
  font-size: 11px; color: #43e97b; line-height: 1.65;
  max-height: 260px; overflow-y: auto; white-space: pre; overflow-x: auto;
}

/* ── Audio Info Banner ── */
.audio-info-banner {
  display: flex; align-items: flex-start; gap: 10px;
  background: rgba(0,198,255,.07); border: 1px solid rgba(0,198,255,.2);
  border-radius: 10px; padding: 12px 16px;
  font-size: 13px; color: #94a3b8; line-height: 1.5;
}
.audio-info-banner svg    { flex-shrink: 0; margin-top: 1px; color: #00c6ff; }
.audio-info-banner strong { color: #00c6ff; }

/* ── Pipeline ── */
.pipeline-preview { background: rgba(0,0,0,.15); border: 1px solid #1e2535; border-radius: 12px; padding: 16px 20px; }
.pipeline-title { font-size: 11.5px; font-weight: 700; color: #334155; text-transform: uppercase; letter-spacing: .06em; margin-bottom: 14px; }
.pipeline-steps { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
.pipeline-step  { display: flex; align-items: center; gap: 10px; flex: 1; min-width: 140px; }
.pipeline-step__dot { width: 10px; height: 10px; border-radius: 50%; background: #43e97b; box-shadow: 0 0 6px rgba(67,233,123,.5); flex-shrink: 0; }
.pipeline-step__dot--pending { background: #2d3748; box-shadow: none; }
.pipeline-step--active .pipeline-step__dot { animation: pulse 1.5s infinite; }
@keyframes pulse {
  0%,100% { box-shadow: 0 0 6px rgba(67,233,123,.5); }
  50%     { box-shadow: 0 0 14px rgba(67,233,123,.9); }
}
.pipeline-step__label { font-size: 12.5px; font-weight: 600; color: #e2e8f0; }
.pipeline-step__sub   { font-size: 11px; color: #4a5568; margin-top: 2px; }
.pipeline-arrow       { color: #2d3748; font-size: 18px; flex-shrink: 0; }

/* ── YouTube-style progress bar ── */
.yt-progress {
  position: absolute; bottom: 0; left: 0; right: 0;
  height: 4px; background: rgba(255,255,255,.25);
  cursor: pointer; z-index: 10; transition: height .15s ease;
}
.yt-progress:hover { height: 6px; }
.yt-progress__fill {
  position: absolute; left: 0; top: 0; height: 100%;
  background: #00bef5; border-radius: 0; pointer-events: none;
}
.yt-progress__thumb {
  position: absolute; top: 50%;
  transform: translate(-50%,-50%) scale(0);
  width: 12px; height: 12px; background: #00bef5;
  border-radius: 50%; pointer-events: none; transition: transform .15s ease;
}
.yt-progress:hover .yt-progress__thumb { transform: translate(-50%,-50%) scale(1); }
.yt-time-row { display: flex; justify-content: space-between; padding: 5px 14px 0; font-size: 11px; color: #64748b; }

/* ── Responsive ── */
@media (max-width: 1100px) {
  .form-layout { grid-template-columns: 1fr; }
  .col-preview { position: static; }
  .artwork-layout { grid-template-columns: 160px 1fr; }
  .cover-upload   { width: 160px; height: 160px; }
  .toggles-grid   { grid-template-columns: 1fr; }
  .form-grid--4   { grid-template-columns: 1fr 1fr; }
}
@media (max-width: 640px) {
  .song-add-page { padding: 16px; }
  .form-grid--2  { grid-template-columns: 1fr; }
  .steps-bar     { gap: 0; padding: 12px 16px; }
  .step-label    { display: none; }
  .step-line     { margin: 0 6px; }
  .artwork-layout { grid-template-columns: 1fr; }
}
</style>
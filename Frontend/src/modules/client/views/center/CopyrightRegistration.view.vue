<template>
  <div class="cr-page">
    <!-- Hero Banner -->
    <section class="cr-hero">
      <div class="cr-hero__bg"></div>
      <div class="cr-container">
        <div class="cr-hero__inner">
          <div class="cr-hero__badge">
            <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
            Free - No fees required
          </div>
          <h1 class="cr-hero__title">Copyright Registration</h1>
          <p class="cr-hero__subtitle">Protect your music on MelodyHub. Verified songs display a <strong>checkmark</strong> badge so listeners know your work is authentic.</p>
          <div class="cr-hero__stats">
            <div class="cr-stat"><span class="cr-stat__num">100%</span><span class="cr-stat__label">Free</span></div>
            <div class="cr-stat__divider"></div>
            <div class="cr-stat"><span class="cr-stat__num">24h</span><span class="cr-stat__label">Review time</span></div>
            <div class="cr-stat__divider"></div>
            <div class="cr-stat"><span class="cr-stat__num">✓</span><span class="cr-stat__label">Verified badge</span></div>
          </div>
        </div>
      </div>
    </section>

    <!-- Registration Form -->
    <section class="cr-section cr-section--form">
      <div class="cr-container cr-container--narrow">
        <div class="cr-card">
          <div class="cr-card__header">
            <div class="cr-card__icon cr-card__icon--blue">
              <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                <rect x="4" y="3" width="16" height="18" rx="2"/>
                <path stroke-linecap="round" d="M8 7h8M8 11h8M8 15h5"/>
              </svg>
            </div>
            <div>
              <h2 class="cr-card__title">Submit Registration</h2>
              <p class="cr-card__sub">Step {{ currentStep + 1 }} of {{ formSteps.length }} — {{ formSteps[currentStep].title }}</p>
            </div>
          </div>

          <!-- Step Indicator -->
          <div class="cr-stepper">
            <div
              v-for="(step, i) in formSteps"
              :key="i"
              class="cr-stepper__item"
              :class="{
                'cr-stepper__item--active': i === currentStep,
                'cr-stepper__item--done': i < currentStep,
              }"
            >
              <div class="cr-stepper__dot">
                <svg v-if="i < currentStep" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"/></svg>
                <span v-else>{{ i + 1 }}</span>
              </div>
              <span class="cr-stepper__label">{{ step.short }}</span>
              <div v-if="i < formSteps.length - 1" class="cr-stepper__line"></div>
            </div>
          </div>

          <form class="cr-form" @submit.prevent="handleSubmit">

            <!-- ── Step 0: Song Info ── -->
            <template v-if="currentStep === 0">
              <div class="cr-field">
                <label class="cr-label">Song Title <span class="cr-required">*</span></label>
                <div class="cr-select-search" :class="{ 'cr-select-search--open': songDropdownOpen }">
                  <div class="cr-select-search__control" @click="toggleSongDropdown">
                    <span v-if="form.selectedSong" class="cr-select-search__value">
                      <span class="cr-select-search__song-cover" :style="getSelectedCoverStyle()"></span>
                      {{ form.selectedSong.title }}
                      <span class="cr-select-search__song-meta">— {{ form.selectedSong.artist?.name ?? '' }}</span>
                    </span>
                    <span v-else class="cr-select-search__placeholder">Search and select a song...</span>
                    <button v-if="form.selectedSong" type="button" class="cr-select-search__clear" @click.stop="clearSelectedSong">
                      <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                    </button>
                    <svg class="cr-select-search__arrow" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                  </div>
                  <div v-if="songDropdownOpen" class="cr-select-search__dropdown">
                    <div class="cr-select-search__search-wrap">
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="cr-select-search__search-icon"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                      <input
                        ref="songSearchInput"
                        v-model="songSearchQuery"
                        type="text"
                        class="cr-select-search__search-input"
                        placeholder="Type to search songs..."
                        @input="onSongSearchInput"
                        @keydown.escape="songDropdownOpen = false"
                      />
                      <button v-if="songSearchQuery" type="button" class="cr-select-search__search-clear" @click="songSearchQuery = ''; onSongSearchInput()">
                        <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                      </button>
                    </div>
                    <div class="cr-select-search__list">
                      <div v-if="songSearchLoading" class="cr-select-search__loading">
                        <span class="cr-spinner cr-spinner--sm"></span>
                        Searching...
                      </div>
                      <div v-else-if="songOptions.length === 0" class="cr-select-search__empty">No songs found</div>
                      <button
                        v-else
                        v-for="song in songOptions"
                        :key="song.id"
                        type="button"
                        class="cr-select-search__option"
                        :class="{ 'cr-select-search__option--selected': form.selectedSong?.id === song.id }"
                        @click="selectSong(song)"
                      >
                        <span class="cr-select-search__opt-cover" :style="getSongCoverStyle(song)">
                          <svg v-if="!song.cover_url" width="10" height="10" viewBox="0 0 24 24" fill="rgba(255,255,255,0.5)"><path d="M9 18V5l12-2v13"/><circle cx="6" cy="18" r="3"/><circle cx="18" cy="16" r="3"/></svg>
                        </span>
                        <span class="cr-select-search__opt-info">
                          <span class="cr-select-search__opt-title">{{ song.title }}</span>
                          <span class="cr-select-search__opt-meta">{{ song.artist?.name ?? '—' }} <span v-if="song.genre?.name" class="cr-select-search__opt-genre">· {{ song.genre.name }}</span></span>
                        </span>
                        <span class="cr-select-search__opt-status" :class="'cr-status--' + song.status">{{ song.status }}</span>
                      </button>
                    </div>
                    <div v-if="songMeta && songMeta.last_page > 1" class="cr-select-search__footer">
                      <button type="button" class="cr-select-search__load-more" :disabled="songSearchLoading || songCurrentPage >= songMeta.last_page" @click="loadMoreSongs">
                        {{ songCurrentPage >= songMeta.last_page ? 'No more songs' : 'Load more' }}
                      </button>
                      <span class="cr-select-search__count">{{ songMeta.total }} songs total</span>
                    </div>
                  </div>
                </div>
              </div>

              <div class="cr-field">
                <label class="cr-label">Artist / Band Name <span class="cr-required">*</span></label>
                <input v-model="form.artistName" type="text" class="cr-input" placeholder="Your artist or band name" />
              </div>
            </template>

            <!-- ── Step 1: Owner & Rights ── -->
            <template v-if="currentStep === 1">
              <div class="cr-fieldset">
                <div class="cr-fieldset__legend">Copyright owner information</div>
                <div class="cr-field">
                  <label class="cr-label">Owner name <span class="cr-required">*</span></label>
                  <input v-model="form.owner_name" type="text" class="cr-input" placeholder="Full legal name of copyright owner" />
                </div>
                <div class="cr-field">
                  <label class="cr-label">Copyright type <span class="cr-required">*</span></label>
                  <div class="cr-tags">
                    <button v-for="t in copyrightTypes" :key="t.value" type="button" class="cr-tag" :class="{ 'cr-tag--active': form.copyright_type === t.value }" @click="form.copyright_type = t.value">{{ t.label }}</button>
                  </div>
                  <p class="cr-field__hint">{{ copyrightTypeHint }}</p>
                </div>
              </div>

              <div class="cr-fieldset">
                <div class="cr-fieldset__legend">Official registration <span class="cr-fieldset__optional">(if available)</span></div>
                <div class="cr-field-row">
                  <div class="cr-field">
                    <label class="cr-label">Registration number</label>
                    <input v-model="form.registration_number" type="text" class="cr-input" placeholder="e.g. VCPMC-2024-XXXXX" />
                  </div>
                  <div class="cr-field">
                    <label class="cr-label">Registration date</label>
                    <input v-model="form.registration_date" type="date" class="cr-input" />
                  </div>
                </div>
                <div class="cr-field">
                  <label class="cr-label">Registration country</label>
                  <input v-model="form.registration_country" type="text" class="cr-input" placeholder="e.g. Vietnam, United States..." />
                </div>
              </div>

              <div class="cr-fieldset">
                <div class="cr-fieldset__legend">Validity & territory</div>
                <div class="cr-field-row">
                  <div class="cr-field">
                    <label class="cr-label">Valid from <span class="cr-required">*</span></label>
                    <input v-model="form.valid_from" type="date" class="cr-input" />
                  </div>
                  <div class="cr-field">
                    <label class="cr-label">Valid until <span class="cr-hint">(leave blank = forever)</span></label>
                    <input v-model="form.valid_until" type="date" class="cr-input" />
                  </div>
                </div>
                <div class="cr-field">
                  <label class="cr-label">Territory</label>
                  <div class="cr-tags">
                    <button v-for="t in territories" :key="t" type="button" class="cr-tag" :class="{ 'cr-tag--active': form.territory === t }" @click="form.territory = t">{{ t }}</button>
                  </div>
                  <input v-if="form.territory === 'Custom'" v-model="form.territory_custom" type="text" class="cr-input cr-input--mt" placeholder="e.g. Vietnam, Thailand, Singapore" />
                </div>
              </div>

              <div class="cr-fieldset">
                <div class="cr-fieldset__legend">Rights included</div>
                <div class="cr-checkboxes">
                  <label v-for="r in rightsList" :key="r.value" class="cr-checkbox-inline">
                    <input type="checkbox" :value="r.value" v-model="form.rights_included" />
                    <span class="cr-checkbox__box"></span>
                    <span>{{ r.label }}</span>
                  </label>
                </div>
              </div>
            </template>

            <!-- ── Step 2: Documents & Notes ── -->
            <template v-if="currentStep === 2">
              <div class="cr-fieldset">
                <div class="cr-fieldset__legend">Supporting documents & notes</div>

                <div class="cr-field">
                  <label class="cr-label">Upload documents</label>
                  <div
                    class="cr-upload"
                    @click="triggerUpload"
                    @dragover.prevent
                    @drop.prevent="handleDrop"
                  >
                    <input ref="fileInput" type="file" class="cr-upload__input" multiple @change="handleFileChange" />
                    <div class="cr-upload__icon">
                      <svg width="32" height="32" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 16.5V9.75m0 0l3 3m-3-3l-3 3M6.75 19.5a4.5 4.5 0 01-1.41-8.775 5.25 5.25 0 0110.338-2.32 5.75 5.75 0 011.153 11.095H6.75z"/></svg>
                    </div>
                    <p class="cr-upload__text">Drag & drop or <span class="cr-upload__link">browse files</span></p>
                    <p class="cr-upload__hint">Contracts, studio receipts, project files — any proof of ownership</p>
                    <div v-if="form.files.length" class="cr-upload__files" @click.stop>
                      <div v-for="(file, i) in form.files" :key="i" class="cr-upload__file">
                        <svg width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                        {{ file.name }}
                        <button type="button" class="cr-upload__remove" @click="removeFile(i)">✕</button>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="cr-field">
                  <label class="cr-label">Notes</label>
                  <textarea v-model="form.notes" class="cr-input cr-textarea" rows="4" placeholder="Additional info about the creative process, contracts, or notes for admin..."></textarea>
                </div>
              </div>
            </template>

            <!-- ── Step 3: Review & Submit ── -->
            <template v-if="currentStep === 3">
              <div class="cr-review">
                <div class="cr-review__section">
                  <div class="cr-review__label">Song</div>
                  <div class="cr-review__value">{{ form.selectedSong?.title ?? '—' }} <span class="cr-review__meta">by {{ form.selectedSong?.artist?.name ?? form.artistName }}</span></div>
                </div>
                <div class="cr-review__section">
                  <div class="cr-review__label">Owner</div>
                  <div class="cr-review__value">{{ form.owner_name || '—' }} <span class="cr-review__meta">({{ form.copyright_type }})</span></div>
                </div>
                <div class="cr-review__section">
                  <div class="cr-review__label">Official registration</div>
                  <div class="cr-review__value">{{ form.registration_number || 'Not provided' }} <span v-if="form.registration_country" class="cr-review__meta">· {{ form.registration_country }}</span></div>
                </div>
                <div class="cr-review__section">
                  <div class="cr-review__label">Validity</div>
                  <div class="cr-review__value">{{ form.valid_from || '—' }} → {{ form.valid_until || 'Forever' }}</div>
                </div>
                <div class="cr-review__section">
                  <div class="cr-review__label">Territory</div>
                  <div class="cr-review__value">{{ form.territory === 'Custom' ? form.territory_custom : form.territory }}</div>
                </div>
                <div class="cr-review__section">
                  <div class="cr-review__label">Rights</div>
                  <div class="cr-review__value">{{ form.rights_included.length ? form.rights_included.join(', ') : 'None selected' }}</div>
                </div>
                <div class="cr-review__section">
                  <div class="cr-review__label">Documents</div>
                  <div class="cr-review__value">{{ form.files.length ? `${form.files.length} file(s) attached` : 'No files' }}</div>
                </div>
                <div v-if="form.notes" class="cr-review__section">
                  <div class="cr-review__label">Notes</div>
                  <div class="cr-review__value cr-review__value--notes">{{ form.notes }}</div>
                </div>
              </div>

              <div class="cr-field cr-field--check">
                <label class="cr-checkbox">
                  <input v-model="form.agreed" type="checkbox" />
                  <span class="cr-checkbox__box"></span>
                  <span class="cr-checkbox__label">I confirm that I am the original creator of this work and all information provided is accurate.</span>
                </label>
              </div>
            </template>

            <!-- Navigation -->
            <div class="cr-form__nav">
              <button v-if="currentStep > 0" type="button" class="cr-btn cr-btn--ghost" @click="prevStep">
                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>
                Back
              </button>
              <div v-else></div>

              <button
                v-if="currentStep < formSteps.length - 1"
                type="button"
                class="cr-btn cr-btn--primary"
                :disabled="!canProceed"
                @click="nextStep"
              >
                Next
                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><polyline points="9 18 15 12 9 6"/></svg>
              </button>

              <button
                v-else
                type="submit"
                class="cr-btn cr-btn--primary"
                :disabled="submitting || !form.agreed"
              >
                <span v-if="submitting" class="cr-spinner"></span>
                <svg v-else width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                {{ submitting ? 'Submitting...' : 'Submit Registration' }}
              </button>
            </div>

            <p class="cr-form__note">Your request will be reviewed within 24 hours.</p>
          </form>
        </div>
      </div>
    </section>

    <!-- FAQ -->
    <section class="cr-section">
      <div class="cr-container cr-container--narrow">
        <div class="cr-section__header">
          <h2 class="cr-section__title">Frequently Asked Questions</h2>
        </div>
        <div class="cr-faq">
          <div v-for="(faq, i) in faqs" :key="i" class="cr-faq__item" :class="{ 'cr-faq__item--open': openFaq === i }">
            <button class="cr-faq__q" @click="openFaq = openFaq === i ? null : i">
              {{ faq.q }}
              <svg class="cr-faq__chevron" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7"/>
              </svg>
            </button>
            <div v-show="openFaq === i" class="cr-faq__a">{{ faq.a }}</div>
          </div>
        </div>
      </div>
    </section>

    <!-- Success Toast -->
    <Transition name="toast">
      <div v-if="showSuccess" class="cr-toast cr-toast--success">
        Registration submitted! We will review within 24 hours.
      </div>
    </Transition>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { useSongStore } from '@/modules/client/stores/songs/songsStore'
import { usePartnerStore } from '@/modules/client/stores/partners/partnersStore'
import { useCopyrightStore } from '@/modules/client/stores/copyrights/copyrightsStore'
import type { Song, SongFilterParams } from '@/interfaces/songs.interface'

// ── Step config ──
const formSteps = [
  { title: 'Song information',     short: 'Song' },
  { title: 'Owner & rights',       short: 'Owner' },
  { title: 'Documents & notes',    short: 'Docs' },
  { title: 'Review & submit',      short: 'Review' },
]
const currentStep = ref(0)

const canProceed = computed(() => {
  if (currentStep.value === 0) return !!form.selectedSong && !!form.artistName.trim()
  if (currentStep.value === 1) return !!form.owner_name.trim() && !!form.copyright_type && !!form.valid_from
  return true
})

const nextStep = () => {
  if (currentStep.value < formSteps.length - 1 && canProceed.value) currentStep.value++
}
const prevStep = () => {
  if (currentStep.value > 0) currentStep.value--
}

// ── UI state ──
const openFaq    = ref<number | null>(null)
const submitting = ref(false)
const showSuccess = ref(false)
const fileInput  = ref<HTMLInputElement | null>(null)

// ── Stores ──
const partnerStore    = usePartnerStore()
const songStoreData   = useSongStore()
const copyrightStore  = useCopyrightStore()

// ── Static data ──
const copyrightTypes = [
  { value: 'author',    label: 'Author' },
  { value: 'performer', label: 'Performer' },
  { value: 'producer',  label: 'Producer' },
  { value: 'publisher', label: 'Publisher' },
]

const territories = ['Vietnam', 'Global', 'Southeast Asia', 'Custom']

const rightsList = [
  { value: 'reproduction',  label: 'Reproduction' },
  { value: 'distribution',  label: 'Distribution' },
  { value: 'performance',   label: 'Public performance' },
  { value: 'broadcast',     label: 'Broadcasting' },
  { value: 'sync',          label: 'Sync / film use' },
  { value: 'digital',       label: 'Digital / streaming' },
]

const copyrightTypeHint = computed(() => {
  const hints: Record<string, string> = {
    author:    'You are the original composer or lyricist of the song.',
    performer: 'You performed or recorded the song.',
    producer:  'You produced or financed the sound recording.',
    publisher: 'You manage and license the song on behalf of the author.',
  }
  return hints[form.copyright_type] ?? ''
})

const faqs = [
  { q: 'Is copyright registration free?',    a: 'Yes, registering your copyright on MelodyHub is completely free. There are no hidden fees.' },
  { q: 'How long does the review take?',     a: 'Our team typically reviews submissions within 24 hours on business days.' },
  { q: 'What documents should I upload?',    a: 'You can upload recording session files, studio contracts, original project files, or any document that proves you created the work.' },
  { q: 'Can I register multiple songs at once?', a: 'Currently each submission covers one song. You can submit multiple registrations for different songs.' },
  { q: 'What happens after approval?',       a: 'Your song will display a verified badge on its detail page, letting listeners know it is officially registered.' },
]

// ── Form state ──
const form = reactive({
  selectedSong:        null as Song | null,
  artistName:          '',
  owner_name:          '',
  copyright_type:      'author',
  registration_number: '',
  registration_date:   '',
  registration_country:'',
  valid_from:          '',
  valid_until:         '',
  territory:           'Vietnam',
  territory_custom:    '',
  rights_included:     [] as string[],
  notes:               '',
  files:               [] as File[],
  agreed:              false,
})

// ── Song select-search ──
const songDropdownOpen  = ref(false)
const songSearchQuery   = ref('')
const songSearchLoading = ref(false)
const songOptions       = ref<Song[]>([])
const songMeta          = ref<{ total: number; last_page: number; current_page: number } | null>(null)
const songCurrentPage   = ref(1)
const songSearchInput   = ref<HTMLInputElement | null>(null)

const coverGradients = [
  'linear-gradient(135deg,#1a1a2e,#16213e,#0f3460)',
  'linear-gradient(135deg,#2d1b69,#11998e)',
  'linear-gradient(135deg,#1a1a1a,#c94b4b)',
  'linear-gradient(135deg,#0f2027,#203a43,#2c5364)',
  'linear-gradient(135deg,#4a1942,#c94b4b)',
  'linear-gradient(135deg,#134e5e,#71b280)',
]

const getSongCoverStyle = (song: Song) => {
  if (song.cover_url) return { backgroundImage: `url(${song.cover_url})`, backgroundSize: 'cover', backgroundPosition: 'center' }
  return { background: coverGradients[song.id % coverGradients.length] }
}
const getSelectedCoverStyle = () => form.selectedSong ? getSongCoverStyle(form.selectedSong) : {}

const buildSongParams = (page = 1): SongFilterParams => ({
  page,
  per_page:                 20,
  search:                   songSearchQuery.value || undefined,
  sort_by:                  'created_at',
  sort_dir:                 'desc',
  partner_id:               partnerStore.partner?.id,
  exclude_copyright_status: 'verified',
} as SongFilterParams)

const loadSongOptions = async (page = 1, append = false) => {
  songSearchLoading.value = true
  try {
    await songStoreData.fetchSongs(buildSongParams(page))
    const data = songStoreData.songs
    const meta = songStoreData.meta
    songOptions.value = append ? [...songOptions.value, ...data] : [...data]
    if (meta) {
      songMeta.value        = { total: meta.total, last_page: meta.last_page, current_page: meta.current_page }
      songCurrentPage.value = meta.current_page
    }
  } finally {
    songSearchLoading.value = false
  }
}

const loadMoreSongs = async () => {
  if (songCurrentPage.value < (songMeta.value?.last_page ?? 1)) {
    await loadSongOptions(songCurrentPage.value + 1, true)
  }
}

let songSearchTimer: ReturnType<typeof setTimeout>
const onSongSearchInput = () => {
  clearTimeout(songSearchTimer)
  songSearchTimer = setTimeout(() => loadSongOptions(1, false), 350)
}

const toggleSongDropdown = async () => {
  songDropdownOpen.value = !songDropdownOpen.value
  if (songDropdownOpen.value) {
    if (songOptions.value.length === 0) await loadSongOptions()
    await nextTick()
    songSearchInput.value?.focus()
  }
}

const selectSong = (song: Song) => {
  form.selectedSong = song
  if (!form.artistName && song.artist?.name) form.artistName = song.artist.name
  songDropdownOpen.value = false
  songSearchQuery.value  = ''
}

const clearSelectedSong = () => { form.selectedSong = null }

const handleOutsideClick = (e: MouseEvent) => {
  if (!(e.target as HTMLElement).closest('.cr-select-search')) {
    songDropdownOpen.value = false
  }
}

// ── File upload ──
const triggerUpload = () => fileInput.value?.click()

const handleFileChange = (e: Event) => {
  const files = (e.target as HTMLInputElement).files
  if (files) form.files.push(...Array.from(files))
}

const handleDrop = (e: DragEvent) => {
  const files = e.dataTransfer?.files
  if (files) form.files.push(...Array.from(files))
}

const removeFile = (i: number) => form.files.splice(i, 1)

// ── Submit ──
const submitError = ref<string | null>(null)
const submitErrors = ref<Record<string, string[]>>({})

const handleSubmit = async () => {
  if (!form.selectedSong) return
  submitting.value = true
  submitError.value = null
  submitErrors.value = {}

  try {
    const fd = new FormData()

    // Required fields
    fd.append('song_id',        String(form.selectedSong.id))
    fd.append('copyright_type', form.copyright_type)
    fd.append('owner_name',     form.owner_name)
    fd.append('valid_from',     form.valid_from)

    // Optional fields
    if (form.registration_number)  fd.append('registration_number',  form.registration_number)
    if (form.registration_date)    fd.append('registration_date',    form.registration_date)
    if (form.registration_country) fd.append('registration_country', form.registration_country)
    if (form.valid_until)          fd.append('valid_until',          form.valid_until)
    if (form.notes)                fd.append('notes',                form.notes)

    // Territory
    const territory = form.territory === 'Custom' ? form.territory_custom : form.territory
    if (territory) fd.append('territory', territory)

    // Rights included — gửi dưới dạng JSON string
    if (form.rights_included.length > 0) {
      fd.append('rights_included', JSON.stringify(form.rights_included))
    }

    // File đầu tiên (backend nhận 1 file)
    if (form.files.length > 0) {
      fd.append('contract_file', form.files[0])
    }

    const result = await copyrightStore.addCopyright(fd)

    if (result?.success) {
      showSuccess.value = true
      currentStep.value = 0
      setTimeout(() => (showSuccess.value = false), 4000)

      Object.assign(form, {
        selectedSong: null, artistName: '', owner_name: '', copyright_type: 'author',
        registration_number: '', registration_date: '', registration_country: '',
        valid_from: '', valid_until: '', territory: 'Vietnam', territory_custom: '',
        rights_included: [], notes: '', files: [], agreed: false,
      })
    } else {
      submitError.value = result?.message ?? 'Đã xảy ra lỗi, vui lòng thử lại.'
      if (result?.errors) {
        submitErrors.value = result.errors as Record<string, string[]>
      }
    }
  } catch {
    submitError.value = 'Không thể kết nối đến server. Vui lòng thử lại.'
  } finally {
    submitting.value = false
  }
}

onMounted(async () => {
  await partnerStore.fetchPartnerInfo()
  document.addEventListener('click', handleOutsideClick)
})

onUnmounted(() => {
  document.removeEventListener('click', handleOutsideClick)
})
</script>

<style scoped>
.cr-page { min-height: 100vh; color: #fff; font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; }
.cr-container { max-width: 1100px; margin: 0 auto; padding: 0 24px; }
.cr-container--narrow { max-width: 720px; }

/* Hero */
.cr-hero { position: relative; padding: 72px 0 60px; overflow: hidden; }
.cr-hero__bg { position: absolute; inset: 0; background: radial-gradient(ellipse 80% 60% at 50% 0%, rgba(59,130,246,0.18) 0%, transparent 70%); pointer-events: none; }
.cr-hero__inner { position: relative; text-align: center; max-width: 680px; margin: 0 auto; }
.cr-hero__badge { display: inline-flex; align-items: center; gap: 6px; background: rgba(59,130,246,0.15); border: 1px solid rgba(59,130,246,0.35); color: #60a5fa; font-size: 12px; font-weight: 600; padding: 5px 14px; border-radius: 20px; margin-bottom: 20px; }
.cr-hero__title { font-size: clamp(2rem, 5vw, 3rem); font-weight: 800; background: linear-gradient(135deg, #fff 30%, #60a5fa); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; margin-bottom: 16px; line-height: 1.15; }
.cr-hero__subtitle { font-size: 1.05rem; color: rgba(255,255,255,0.6); line-height: 1.7; margin-bottom: 36px; }
.cr-hero__subtitle strong { color: #60a5fa; }
.cr-hero__stats { display: inline-flex; align-items: center; gap: 24px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 16px; padding: 16px 32px; }
.cr-stat { text-align: center; }
.cr-stat__num { display: block; font-size: 1.5rem; font-weight: 700; color: #60a5fa; }
.cr-stat__label { font-size: 11px; color: rgba(255,255,255,0.45); text-transform: uppercase; letter-spacing: 0.05em; }
.cr-stat__divider { width: 1px; height: 36px; background: rgba(255,255,255,0.1); }

/* Section */
.cr-section { padding: 60px 0; }
.cr-section--form { padding-top: 0; }
.cr-section__header { text-align: center; margin-bottom: 40px; }
.cr-section__title { font-size: 1.75rem; font-weight: 700; margin-bottom: 8px; }
.cr-section__sub { color: rgba(255,255,255,0.5); font-size: 0.95rem; }

/* Card */
.cr-card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.1); border-radius: 20px; padding: 36px; }
.cr-card__header { display: flex; align-items: center; gap: 16px; margin-bottom: 28px; padding-bottom: 20px; border-bottom: 1px solid rgba(255,255,255,0.08); }
.cr-card__icon { width: 52px; height: 52px; border-radius: 14px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.cr-card__icon--blue { background: rgba(59,130,246,0.15); color: #3b82f6; }
.cr-card__title { font-size: 1.25rem; font-weight: 700; margin-bottom: 4px; }
.cr-card__sub { font-size: 0.85rem; color: rgba(255,255,255,0.45); }

/* Stepper */
.cr-stepper { display: flex; align-items: flex-start; margin-bottom: 32px; gap: 0; }
.cr-stepper__item { display: flex; flex-direction: column; align-items: center; gap: 6px; flex: 1; position: relative; }
.cr-stepper__dot {
  width: 32px; height: 32px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-size: 12px; font-weight: 600; border: 2px solid rgba(255,255,255,0.15);
  background: rgba(255,255,255,0.05); color: rgba(255,255,255,0.35);
  position: relative; z-index: 1; transition: all 0.25s;
}
.cr-stepper__item--active .cr-stepper__dot { border-color: #3b82f6; background: #3b82f6; color: #fff; }
.cr-stepper__item--done .cr-stepper__dot { border-color: #22c55e; background: rgba(34,197,94,0.15); color: #22c55e; }
.cr-stepper__label { font-size: 11px; color: rgba(255,255,255,0.35); font-weight: 500; white-space: nowrap; }
.cr-stepper__item--active .cr-stepper__label { color: #60a5fa; }
.cr-stepper__item--done .cr-stepper__label { color: #4ade80; }
.cr-stepper__line {
  position: absolute; top: 16px; left: calc(50% + 18px);
  width: calc(100% - 36px); height: 2px;
  background: rgba(255,255,255,0.08);
}
.cr-stepper__item--done .cr-stepper__line { background: rgba(34,197,94,0.4); }

/* Form */
.cr-form { display: flex; flex-direction: column; gap: 20px; }
.cr-field { display: flex; flex-direction: column; gap: 8px; }
.cr-field-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.cr-label { font-size: 13px; font-weight: 600; color: rgba(255,255,255,0.8); }
.cr-required { color: #f87171; }
.cr-hint { color: rgba(255,255,255,0.35); font-weight: 400; }
.cr-input { background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.12); border-radius: 10px; padding: 11px 14px; font-size: 14px; color: #fff; outline: none; transition: border-color 0.2s, box-shadow 0.2s; font-family: inherit; width: 100%; box-sizing: border-box; }
.cr-input:focus { border-color: rgba(59,130,246,0.6); box-shadow: 0 0 0 3px rgba(59,130,246,0.12); }
.cr-input::placeholder { color: rgba(255,255,255,0.25); }
.cr-input--mt { margin-top: 8px; }
.cr-textarea { resize: vertical; min-height: 100px; }

/* Fieldset */
.cr-fieldset { display: flex; flex-direction: column; gap: 16px; border: 1px solid rgba(255,255,255,0.07); border-radius: 12px; padding: 20px; }
.cr-fieldset__legend { font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.06em; color: rgba(255,255,255,0.4); }
.cr-fieldset__optional { font-weight: 400; text-transform: none; letter-spacing: 0; color: rgba(255,255,255,0.25); }

/* Tags */
.cr-tags { display: flex; flex-wrap: wrap; gap: 8px; }
.cr-tag { padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: 500; border: 1px solid rgba(255,255,255,0.12); background: rgba(255,255,255,0.05); color: rgba(255,255,255,0.55); cursor: pointer; transition: all 0.15s; font-family: inherit; }
.cr-tag:hover { border-color: rgba(255,255,255,0.25); color: rgba(255,255,255,0.8); }
.cr-tag--active { background: rgba(59,130,246,0.15); border-color: rgba(59,130,246,0.5); color: #60a5fa; }
.cr-field__hint { font-size: 12px; color: rgba(255,255,255,0.35); margin-top: 2px; min-height: 16px; }

/* Checkboxes */
.cr-checkboxes { display: flex; flex-direction: column; gap: 10px; }
.cr-checkbox-inline { display: flex; align-items: center; gap: 10px; cursor: pointer; font-size: 14px; color: rgba(255,255,255,0.7); }
.cr-checkbox-inline input { display: none; }
.cr-checkbox__box { width: 18px; height: 18px; flex-shrink: 0; border: 2px solid rgba(255,255,255,0.2); border-radius: 5px; background: rgba(255,255,255,0.05); display: flex; align-items: center; justify-content: center; transition: all 0.15s; }
.cr-checkbox-inline input:checked ~ .cr-checkbox__box,
.cr-checkbox input:checked + .cr-checkbox__box { background: #3b82f6; border-color: #3b82f6; }
.cr-checkbox-inline input:checked ~ .cr-checkbox__box::after,
.cr-checkbox input:checked + .cr-checkbox__box::after { content: '✓'; font-size: 11px; color: #fff; font-weight: 700; }

/* Upload */
.cr-upload { border: 2px dashed rgba(255,255,255,0.15); border-radius: 12px; padding: 28px 20px; text-align: center; cursor: pointer; transition: border-color 0.2s, background 0.2s; }
.cr-upload:hover { border-color: rgba(59,130,246,0.5); background: rgba(59,130,246,0.04); }
.cr-upload__input { display: none; }
.cr-upload__icon { color: rgba(255,255,255,0.25); margin-bottom: 10px; display: flex; justify-content: center; }
.cr-upload__text { font-size: 13px; color: rgba(255,255,255,0.5); margin-bottom: 4px; }
.cr-upload__link { color: #60a5fa; text-decoration: underline; }
.cr-upload__hint { font-size: 11px; color: rgba(255,255,255,0.3); }
.cr-upload__files { margin-top: 14px; display: flex; flex-direction: column; gap: 6px; text-align: left; }
.cr-upload__file { display: flex; align-items: center; gap: 8px; background: rgba(255,255,255,0.06); border-radius: 8px; padding: 7px 12px; font-size: 12px; color: rgba(255,255,255,0.7); }
.cr-upload__remove { margin-left: auto; background: none; border: none; color: rgba(255,255,255,0.3); cursor: pointer; font-size: 12px; transition: color 0.15s; }
.cr-upload__remove:hover { color: #f87171; }

/* Review */
.cr-review { display: flex; flex-direction: column; gap: 0; border: 1px solid rgba(255,255,255,0.08); border-radius: 12px; overflow: hidden; }
.cr-review__section { display: flex; gap: 16px; padding: 13px 16px; border-bottom: 1px solid rgba(255,255,255,0.05); }
.cr-review__section:last-child { border-bottom: none; }
.cr-review__label { font-size: 12px; font-weight: 600; color: rgba(255,255,255,0.35); text-transform: uppercase; letter-spacing: 0.05em; flex: 0 0 130px; padding-top: 1px; }
.cr-review__value { font-size: 14px; color: rgba(255,255,255,0.8); flex: 1; }
.cr-review__value--notes { white-space: pre-wrap; font-size: 13px; }
.cr-review__meta { color: rgba(255,255,255,0.35); font-size: 13px; }

/* Agree checkbox */
.cr-field--check { flex-direction: row; align-items: flex-start; }
.cr-checkbox { display: flex; align-items: flex-start; gap: 10px; cursor: pointer; }
.cr-checkbox input { display: none; }
.cr-checkbox__label { font-size: 13px; color: rgba(255,255,255,0.6); line-height: 1.5; }

/* Navigation */
.cr-form__nav { display: flex; align-items: center; justify-content: space-between; padding-top: 8px; margin-top: 4px; }
.cr-form__note { font-size: 12px; color: rgba(255,255,255,0.3); text-align: center; }
.cr-btn { display: inline-flex; align-items: center; gap: 8px; padding: 11px 24px; border-radius: 10px; font-size: 14px; font-weight: 600; border: none; cursor: pointer; transition: all 0.2s; font-family: inherit; }
.cr-btn--primary { background: linear-gradient(135deg, #3b82f6, #2563eb); color: #fff; box-shadow: 0 4px 20px rgba(59,130,246,0.35); }
.cr-btn--primary:hover:not(:disabled) { transform: translateY(-1px); box-shadow: 0 6px 28px rgba(59,130,246,0.5); }
.cr-btn--primary:disabled { opacity: 0.45; cursor: not-allowed; }
.cr-btn--ghost { background: rgba(255,255,255,0.05); color: rgba(255,255,255,0.6); border: 1px solid rgba(255,255,255,0.1); }
.cr-btn--ghost:hover { background: rgba(255,255,255,0.09); color: #fff; }

.cr-spinner { width: 16px; height: 16px; border: 2px solid rgba(255,255,255,0.3); border-top-color: #fff; border-radius: 50%; animation: spin 0.7s linear infinite; }
.cr-spinner--sm { width: 12px; height: 12px; border-width: 1.5px; }
@keyframes spin { to { transform: rotate(360deg); } }

/* FAQ */
.cr-faq { display: flex; flex-direction: column; gap: 8px; }
.cr-faq__item { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 12px; overflow: hidden; transition: border-color 0.2s; }
.cr-faq__item--open { border-color: rgba(59,130,246,0.35); }
.cr-faq__q { width: 100%; display: flex; align-items: center; justify-content: space-between; padding: 16px 20px; background: none; border: none; color: rgba(255,255,255,0.85); font-size: 14px; font-weight: 600; cursor: pointer; text-align: left; font-family: inherit; gap: 12px; }
.cr-faq__q:hover { color: #fff; }
.cr-faq__chevron { flex-shrink: 0; transition: transform 0.2s; color: rgba(255,255,255,0.35); }
.cr-faq__item--open .cr-faq__chevron { transform: rotate(180deg); color: #60a5fa; }
.cr-faq__a { padding: 0 20px 16px; font-size: 13px; color: rgba(255,255,255,0.5); line-height: 1.6; }

/* Toast */
.cr-toast { position: fixed; bottom: 32px; left: 50%; transform: translateX(-50%); display: flex; align-items: center; gap: 10px; padding: 14px 24px; border-radius: 12px; font-size: 14px; font-weight: 500; z-index: 9999; box-shadow: 0 8px 32px rgba(0,0,0,0.4); }
.cr-toast--success { background: rgba(16,185,129,0.15); border: 1px solid rgba(16,185,129,0.4); color: #34d399; }
.toast-enter-active { transition: all 0.3s ease; }
.toast-leave-active { transition: all 0.25s ease; }
.toast-enter-from { opacity: 0; transform: translateX(-50%) translateY(16px); }
.toast-leave-to { opacity: 0; transform: translateX(-50%) translateY(8px); }

/* Select Search */
.cr-select-search { position: relative; width: 100%; }
.cr-select-search__control { display: flex; align-items: center; gap: 8px; background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.12); border-radius: 10px; padding: 10px 14px; cursor: pointer; transition: border-color 0.2s, box-shadow 0.2s; min-height: 44px; }
.cr-select-search--open .cr-select-search__control { border-color: rgba(59,130,246,0.6); box-shadow: 0 0 0 3px rgba(59,130,246,0.12); }
.cr-select-search__control:hover { border-color: rgba(255,255,255,0.25); }
.cr-select-search__value { display: flex; align-items: center; gap: 8px; flex: 1; font-size: 14px; color: #fff; min-width: 0; }
.cr-select-search__song-cover { width: 26px; height: 26px; border-radius: 5px; flex-shrink: 0; display: flex; align-items: center; justify-content: center; }
.cr-select-search__song-meta { font-size: 12px; color: rgba(255,255,255,0.4); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.cr-select-search__placeholder { flex: 1; font-size: 14px; color: rgba(255,255,255,0.25); }
.cr-select-search__clear { background: none; border: none; color: rgba(255,255,255,0.3); cursor: pointer; display: flex; align-items: center; padding: 2px; border-radius: 4px; transition: color 0.15s; flex-shrink: 0; }
.cr-select-search__clear:hover { color: #f87171; }
.cr-select-search__arrow { color: rgba(255,255,255,0.3); flex-shrink: 0; transition: transform 0.2s; }
.cr-select-search--open .cr-select-search__arrow { transform: rotate(180deg); }
.cr-select-search__dropdown { position: absolute; top: calc(100% + 6px); left: 0; right: 0; background: #1e2530; border: 1px solid rgba(255,255,255,0.12); border-radius: 12px; box-shadow: 0 12px 40px rgba(0,0,0,0.5); z-index: 100; overflow: hidden; }
.cr-select-search__search-wrap { display: flex; align-items: center; gap: 8px; padding: 10px 12px; border-bottom: 1px solid rgba(255,255,255,0.08); }
.cr-select-search__search-icon { color: rgba(255,255,255,0.3); flex-shrink: 0; }
.cr-select-search__search-input { flex: 1; background: none; border: none; outline: none; font-size: 13px; color: #fff; font-family: inherit; }
.cr-select-search__search-input::placeholder { color: rgba(255,255,255,0.25); }
.cr-select-search__search-clear { background: none; border: none; color: rgba(255,255,255,0.3); cursor: pointer; display: flex; align-items: center; padding: 2px; transition: color 0.15s; }
.cr-select-search__search-clear:hover { color: rgba(255,255,255,0.7); }
.cr-select-search__list { max-height: 260px; overflow-y: auto; padding: 6px; }
.cr-select-search__list::-webkit-scrollbar { width: 4px; }
.cr-select-search__list::-webkit-scrollbar-track { background: transparent; }
.cr-select-search__list::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.1); border-radius: 2px; }
.cr-select-search__loading, .cr-select-search__empty { display: flex; align-items: center; justify-content: center; gap: 8px; padding: 20px; font-size: 13px; color: rgba(255,255,255,0.35); }
.cr-select-search__option { display: flex; align-items: center; gap: 10px; width: 100%; padding: 8px 10px; background: none; border: none; border-radius: 8px; cursor: pointer; text-align: left; transition: background 0.15s; font-family: inherit; }
.cr-select-search__option:hover { background: rgba(255,255,255,0.06); }
.cr-select-search__option--selected { background: rgba(59,130,246,0.12); }
.cr-select-search__option--selected:hover { background: rgba(59,130,246,0.18); }
.cr-select-search__opt-cover { width: 34px; height: 34px; border-radius: 7px; flex-shrink: 0; display: flex; align-items: center; justify-content: center; overflow: hidden; }
.cr-select-search__opt-info { display: flex; flex-direction: column; gap: 2px; flex: 1; min-width: 0; }
.cr-select-search__opt-title { font-size: 13px; font-weight: 600; color: #f0f4f8; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.cr-select-search__opt-meta { font-size: 11px; color: rgba(255,255,255,0.4); }
.cr-select-search__opt-genre { color: rgba(255,255,255,0.3); }
.cr-select-search__opt-status { font-size: 10.5px; font-weight: 600; padding: 2px 8px; border-radius: 20px; text-transform: capitalize; flex-shrink: 0; }
.cr-status--published  { background: rgba(34,197,94,.1);   color: #4ade80; }
.cr-status--draft      { background: rgba(100,116,139,.12); color: #64748b; }
.cr-status--blocked    { background: rgba(239,68,68,.1);    color: #f87171; }
.cr-status--processing { background: rgba(245,158,11,.1);   color: #fbbf24; }
.cr-select-search__footer { display: flex; align-items: center; justify-content: space-between; padding: 8px 12px; border-top: 1px solid rgba(255,255,255,0.07); }
.cr-select-search__load-more { background: none; border: none; color: #60a5fa; font-size: 12px; cursor: pointer; padding: 0; font-family: inherit; transition: color 0.15s; }
.cr-select-search__load-more:hover:not(:disabled) { color: #93c5fd; }
.cr-select-search__load-more:disabled { color: rgba(255,255,255,0.2); cursor: not-allowed; }
.cr-select-search__count { font-size: 11px; color: rgba(255,255,255,0.25); }

@media (max-width: 600px) {
  .cr-field-row { grid-template-columns: 1fr; }
  .cr-card { padding: 20px 16px; }
  .cr-hero__stats { flex-direction: column; gap: 12px; padding: 16px 20px; }
  .cr-stat__divider { width: 40px; height: 1px; }
  .cr-stepper__label { display: none; }
  .cr-review__label { flex: 0 0 90px; }
}
</style>
<template>
  <div class="cvr-page">

    <!-- Hero -->
    <section class="cvr-hero">
      <div class="cvr-hero__bg"></div>
      <div class="cvr-container">
        <div class="cvr-hero__inner">
          <div class="cvr-hero__badge cvr-hero__badge--new">
            <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
            New - AI-powered detection
          </div>
          <h1 class="cvr-hero__title">Copyright Violation Report</h1>
          <p class="cvr-hero__subtitle">Detected a duplicate song? Our AI automatically compares audio fingerprints and submits a report to MelodyHub for review.</p>
          <div class="cvr-hero__stats">
            <div class="cvr-stat"><span class="cvr-stat__num">AI</span><span class="cvr-stat__label">Auto detection</span></div>
            <div class="cvr-stat__divider"></div>
            <div class="cvr-stat"><span class="cvr-stat__num">48h</span><span class="cvr-stat__label">Response time</span></div>
            <div class="cvr-stat__divider"></div>
            <div class="cvr-stat"><span class="cvr-stat__num">100%</span><span class="cvr-stat__label">Confidential</span></div>
          </div>
        </div>
      </div>
    </section>

    <!-- How it works -->
    <section class="cvr-section">
      <div class="cvr-container">
        <div class="cvr-section__header">
          <h2 class="cvr-section__title">How the AI detection works</h2>
          <p class="cvr-section__sub">Our system uses audio fingerprinting to identify duplicate content</p>
        </div>
        <div class="cvr-steps">
          <div v-for="(step, i) in steps" :key="i" class="cvr-step">
            <div class="cvr-step__icon">
              <!-- Step 1: submit -->
              <svg v-if="i === 0" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
              </svg>
              <!-- Step 2: AI analysis -->
              <svg v-else-if="i === 1" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M13 10V3L4 14h7v7l9-11h-7z"/>
              </svg>
              <!-- Step 3: human review -->
              <svg v-else-if="i === 2" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0"/>
              </svg>
              <!-- Step 4: action taken -->
              <svg v-else width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
            </div>
            <h3 class="cvr-step__title">{{ step.title }}</h3>
            <p class="cvr-step__desc">{{ step.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Report Form -->
    <section class="cvr-section cvr-section--form">
      <div class="cvr-container cvr-container--narrow">
        <div class="cvr-card">
          <div class="cvr-card__header">
            <div class="cvr-card__icon cvr-card__icon--red">
              <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                <circle cx="12" cy="12" r="9"/>
                <line x1="4.93" y1="4.93" x2="19.07" y2="19.07"/>
              </svg>
            </div>
            <div>
              <h2 class="cvr-card__title">Submit Violation Report</h2>
              <p class="cvr-card__sub">Provide details about the suspected copyright violation</p>
            </div>
          </div>

          <form class="cvr-form" @submit.prevent="handleSubmit">

            <!-- Your Song -->
            <div class="cvr-fieldset">
              <div class="cvr-fieldset__legend">
                <span class="cvr-fieldset__num">1</span>
                Your Original Song
              </div>
              <div class="cvr-field">
                <label class="cvr-label">Your Song Title <span class="cvr-required">*</span></label>
                <input v-model="form.originalTitle" type="text" class="cvr-input" placeholder="Title of your original song" required />
              </div>
              <div class="cvr-field-row">
                <div class="cvr-field">
                  <label class="cvr-label">Your Artist Name <span class="cvr-required">*</span></label>
                  <input v-model="form.originalArtist" type="text" class="cvr-input" placeholder="Your artist name" required />
                </div>
                <div class="cvr-field">
                  <label class="cvr-label">Original Release Date <span class="cvr-required">*</span></label>
                  <input v-model="form.originalDate" type="date" class="cvr-input" required />
                </div>
              </div>
              <div class="cvr-field">
                <label class="cvr-label">Link to your song on MelodyHub</label>
                <input v-model="form.originalLink" type="url" class="cvr-input" placeholder="https://melodyhub.vn/songs/..." />
              </div>
            </div>

            <!-- Infringing Song -->
            <div class="cvr-fieldset cvr-fieldset--red">
              <div class="cvr-fieldset__legend">
                <span class="cvr-fieldset__num cvr-fieldset__num--red">2</span>
                Suspected Infringing Song
              </div>
              <div class="cvr-field">
                <label class="cvr-label">Infringing Song Title <span class="cvr-required">*</span></label>
                <input v-model="form.infringingTitle" type="text" class="cvr-input" placeholder="Title of the suspected infringing song" required />
              </div>
              <div class="cvr-field">
                <label class="cvr-label">Infringing Artist Name</label>
                <input v-model="form.infringingArtist" type="text" class="cvr-input" placeholder="Artist name of the infringing song" />
              </div>
              <div class="cvr-field">
                <label class="cvr-label">Link to infringing song <span class="cvr-required">*</span></label>
                <input v-model="form.infringingLink" type="url" class="cvr-input" placeholder="https://melodyhub.vn/songs/..." required />
              </div>
            </div>

            <!-- Violation Type -->
            <div class="cvr-field">
              <label class="cvr-label">Type of Violation <span class="cvr-required">*</span></label>
              <div class="cvr-tags">
                <button
                  v-for="t in violationTypes" :key="t"
                  type="button"
                  class="cvr-tag"
                  :class="{ 'cvr-tag--active': form.violationType === t }"
                  @click="form.violationType = t"
                >{{ t }}</button>
              </div>
            </div>

            <!-- Description -->
            <div class="cvr-field">
              <label class="cvr-label">Detailed Description <span class="cvr-required">*</span></label>
              <textarea v-model="form.description" class="cvr-input cvr-textarea" rows="4"
                placeholder="Describe the specific parts that are copied (e.g. melody, lyrics, beat, intro), timestamps, and any other relevant details..." required></textarea>
            </div>

            <!-- Evidence Upload -->
            <div class="cvr-field">
              <label class="cvr-label">Evidence Files <span class="cvr-hint">(optional but recommended)</span></label>
              <div class="cvr-upload" @click="triggerUpload" @dragover.prevent @drop.prevent="handleDrop">
                <input ref="fileInput" type="file" multiple accept=".pdf,.jpg,.png,.mp3,.wav,.mp4" class="cvr-upload__input" @change="handleFileChange" />
                <div class="cvr-upload__icon">
                  <svg width="32" height="32" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5m-13.5-9L12 3m0 0l4.5 4.5M12 3v13.5"/>
                  </svg>
                </div>
                <p class="cvr-upload__text">Drag and drop files here or <span class="cvr-upload__link">browse</span></p>
                <p class="cvr-upload__hint">PDF, JPG, PNG, MP3, WAV, MP4 - max 50MB each</p>
                <div v-if="form.files.length" class="cvr-upload__files">
                  <div v-for="(f, i) in form.files" :key="i" class="cvr-upload__file">
                    {{ f.name }}
                    <button type="button" class="cvr-upload__remove" @click.stop="removeFile(i)">x</button>
                  </div>
                </div>
              </div>
            </div>

            <!-- AI Analysis Notice -->
            <div class="cvr-notice">
              <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M13 10V3L4 14h7v7l9-11h-7z"/>
              </svg>
              <div>
                <strong>AI Analysis</strong>
                <p>After submission, our AI will automatically compare the audio fingerprints of both songs and generate a similarity report to support your claim.</p>
              </div>
            </div>

            <!-- Agreement -->
            <div class="cvr-field cvr-field--check">
              <label class="cvr-checkbox">
                <input v-model="form.agreed" type="checkbox" required />
                <span class="cvr-checkbox__box"></span>
                <span class="cvr-checkbox__label">I confirm that the information provided is accurate and I am the rightful owner or authorized representative of the original work. False reports may result in account suspension.</span>
              </label>
            </div>

            <!-- Submit -->
            <div class="cvr-form__footer">
              <button type="submit" class="cvr-btn cvr-btn--danger" :disabled="submitting || !form.agreed || !form.violationType">
                <span v-if="submitting" class="cvr-spinner"></span>
                <svg v-else width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                {{ submitting ? 'Submitting report...' : 'Submit Violation Report' }}
              </button>
              <p class="cvr-form__note">Reports are reviewed within 48 hours. Your identity remains confidential.</p>
            </div>
          </form>
        </div>
      </div>
    </section>

    <!-- What happens next -->
    <section class="cvr-section">
      <div class="cvr-container cvr-container--narrow">
        <div class="cvr-section__header">
          <h2 class="cvr-section__title">What happens after you report?</h2>
        </div>
        <div class="cvr-timeline">
          <div v-for="(item, i) in timeline" :key="i" class="cvr-timeline__item">
            <div class="cvr-timeline__dot"></div>
            <div class="cvr-timeline__content">
              <div class="cvr-timeline__time">{{ item.time }}</div>
              <h4 class="cvr-timeline__title">{{ item.title }}</h4>
              <p class="cvr-timeline__desc">{{ item.desc }}</p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Success Toast -->
    <Transition name="toast">
      <div v-if="showSuccess" class="cvr-toast cvr-toast--success">
        Report submitted successfully! We will investigate within 48 hours.
      </div>
    </Transition>

  </div>
</template>
<script setup lang="ts">
import { ref, reactive } from 'vue'

const submitting = ref(false)
const showSuccess = ref(false)
const fileInput = ref<HTMLInputElement | null>(null)

const steps = [
  { title: 'Submit your report', desc: 'Provide details about your original song and the suspected infringing content.' },
  { title: 'AI fingerprint analysis', desc: 'Our AI compares audio fingerprints and generates a similarity score between both songs.' },
  { title: 'Human review', desc: 'Our moderation team reviews the AI report and your evidence within 48 hours.' },
  { title: 'Action taken', desc: 'If confirmed, the infringing content is removed and you receive a notification.' },
]

const violationTypes = [
  'Melody copy',
  'Lyrics copy',
  'Beat / Instrumental copy',
  'Full song copy',
  'Unauthorized remix',
  'Other',
]

const timeline = [
  { time: 'Immediately', title: 'Report received', desc: 'Your report is logged and assigned a case ID. You will receive a confirmation.' },
  { time: 'Within 2 hours', title: 'AI analysis starts', desc: 'Our AI system begins comparing audio fingerprints and analyzing similarity patterns.' },
  { time: 'Within 24 hours', title: 'AI report generated', desc: 'A detailed similarity report is generated and forwarded to our moderation team.' },
  { time: 'Within 48 hours', title: 'Decision made', desc: 'Our team reviews the evidence and takes appropriate action. Both parties are notified.' },
]

const form = reactive({
  originalTitle: '',
  originalArtist: '',
  originalDate: '',
  originalLink: '',
  infringingTitle: '',
  infringingArtist: '',
  infringingLink: '',
  violationType: '',
  description: '',
  files: [] as File[],
  agreed: false,
})

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

const handleSubmit = async () => {
  submitting.value = true
  // TODO: call API when backend is ready
  await new Promise(r => setTimeout(r, 1800))
  submitting.value = false
  showSuccess.value = true
  setTimeout(() => (showSuccess.value = false), 5000)
  Object.assign(form, {
    originalTitle: '', originalArtist: '', originalDate: '', originalLink: '',
    infringingTitle: '', infringingArtist: '', infringingLink: '',
    violationType: '', description: '', files: [], agreed: false,
  })
}
</script>

<style scoped>
.cvr-page { min-height: 100vh; color: #fff; font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; }
.cvr-container { max-width: 1100px; margin: 0 auto; padding: 0 24px; }
.cvr-container--narrow { max-width: 760px; }

/* Hero */
.cvr-hero { position: relative; padding: 72px 0 60px; overflow: hidden; }
.cvr-hero__bg { position: absolute; inset: 0; background: radial-gradient(ellipse 80% 60% at 50% 0%, rgba(239,68,68,0.15) 0%, transparent 70%); pointer-events: none; }
.cvr-hero__inner { position: relative; text-align: center; max-width: 680px; margin: 0 auto; }
.cvr-hero__badge { display: inline-flex; align-items: center; gap: 6px; font-size: 12px; font-weight: 600; padding: 5px 14px; border-radius: 20px; margin-bottom: 20px; }
.cvr-hero__badge--new { background: rgba(249,115,22,0.15); border: 1px solid rgba(249,115,22,0.35); color: #fb923c; }
.cvr-hero__title { font-size: clamp(2rem, 5vw, 3rem); font-weight: 800; background: linear-gradient(135deg, #fff 30%, #f87171); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; margin-bottom: 16px; line-height: 1.15; }
.cvr-hero__subtitle { font-size: 1.05rem; color: rgba(255,255,255,0.6); line-height: 1.7; margin-bottom: 36px; }
.cvr-hero__stats { display: inline-flex; align-items: center; gap: 24px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 16px; padding: 16px 32px; }
.cvr-stat { text-align: center; }
.cvr-stat__num { display: block; font-size: 1.5rem; font-weight: 700; color: #f87171; }
.cvr-stat__label { font-size: 11px; color: rgba(255,255,255,0.45); text-transform: uppercase; letter-spacing: 0.05em; }
.cvr-stat__divider { width: 1px; height: 36px; background: rgba(255,255,255,0.1); }

/* Section */
.cvr-section { padding: 60px 0; }
.cvr-section--form { padding-top: 0; }
.cvr-section__header { text-align: center; margin-bottom: 40px; }
.cvr-section__title { font-size: 1.75rem; font-weight: 700; margin-bottom: 8px; }
.cvr-section__sub { color: rgba(255,255,255,0.5); font-size: 0.95rem; }

/* Steps */
.cvr-steps { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; }
.cvr-step { background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.07); border-radius: 16px; padding: 24px 20px; }
.cvr-step__icon { width: 44px; height: 44px; border-radius: 12px; background: rgba(239,68,68,0.12); color: #f87171; display: flex; align-items: center; justify-content: center; margin-bottom: 14px; }
.cvr-step__title { font-size: 0.95rem; font-weight: 600; margin-bottom: 6px; }
.cvr-step__desc { font-size: 0.82rem; color: rgba(255,255,255,0.45); line-height: 1.5; }

/* Card */
.cvr-card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.1); border-radius: 20px; padding: 36px; }
.cvr-card__header { display: flex; align-items: center; gap: 16px; margin-bottom: 32px; padding-bottom: 24px; border-bottom: 1px solid rgba(255,255,255,0.08); }
.cvr-card__icon { width: 52px; height: 52px; border-radius: 14px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.cvr-card__icon--red { background: rgba(239,68,68,0.15); color: #ef4444; }
.cvr-card__title { font-size: 1.25rem; font-weight: 700; margin-bottom: 4px; }
.cvr-card__sub { font-size: 0.85rem; color: rgba(255,255,255,0.45); }

/* Form */
.cvr-form { display: flex; flex-direction: column; gap: 24px; }
.cvr-field { display: flex; flex-direction: column; gap: 8px; }
.cvr-field-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.cvr-label { font-size: 13px; font-weight: 600; color: rgba(255,255,255,0.8); }
.cvr-required { color: #f87171; }
.cvr-hint { color: rgba(255,255,255,0.35); font-weight: 400; }
.cvr-input { background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.12); border-radius: 10px; padding: 11px 14px; font-size: 14px; color: #fff; outline: none; transition: border-color 0.2s, box-shadow 0.2s; font-family: inherit; width: 100%; box-sizing: border-box; }
.cvr-input:focus { border-color: rgba(239,68,68,0.5); box-shadow: 0 0 0 3px rgba(239,68,68,0.1); }
.cvr-input::placeholder { color: rgba(255,255,255,0.25); }
.cvr-textarea { resize: vertical; min-height: 110px; }

/* Fieldset */
.cvr-fieldset { background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; padding: 20px; display: flex; flex-direction: column; gap: 16px; }
.cvr-fieldset--red { border-color: rgba(239,68,68,0.2); background: rgba(239,68,68,0.03); }
.cvr-fieldset__legend { display: flex; align-items: center; gap: 10px; font-size: 13px; font-weight: 700; color: rgba(255,255,255,0.7); margin-bottom: 4px; }
.cvr-fieldset__num { width: 24px; height: 24px; border-radius: 50%; background: rgba(59,130,246,0.2); color: #60a5fa; font-size: 12px; font-weight: 700; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.cvr-fieldset__num--red { background: rgba(239,68,68,0.2); color: #f87171; }

/* Violation type tags */
.cvr-tags { display: flex; flex-wrap: wrap; gap: 8px; }
.cvr-tag { padding: 7px 14px; border-radius: 20px; font-size: 13px; font-weight: 500; border: 1px solid rgba(255,255,255,0.15); background: rgba(255,255,255,0.04); color: rgba(255,255,255,0.6); cursor: pointer; transition: all 0.15s; font-family: inherit; }
.cvr-tag:hover { border-color: rgba(239,68,68,0.4); color: #f87171; }
.cvr-tag--active { background: rgba(239,68,68,0.15); border-color: rgba(239,68,68,0.5); color: #f87171; }

/* Upload */
.cvr-upload { border: 2px dashed rgba(255,255,255,0.15); border-radius: 12px; padding: 28px 20px; text-align: center; cursor: pointer; transition: border-color 0.2s, background 0.2s; }
.cvr-upload:hover { border-color: rgba(239,68,68,0.4); background: rgba(239,68,68,0.03); }
.cvr-upload__input { display: none; }
.cvr-upload__icon { color: rgba(255,255,255,0.25); margin-bottom: 10px; display: flex; justify-content: center; }
.cvr-upload__text { font-size: 13px; color: rgba(255,255,255,0.5); margin-bottom: 4px; }
.cvr-upload__link { color: #f87171; text-decoration: underline; }
.cvr-upload__hint { font-size: 11px; color: rgba(255,255,255,0.3); }
.cvr-upload__files { margin-top: 14px; display: flex; flex-direction: column; gap: 6px; text-align: left; }
.cvr-upload__file { display: flex; align-items: center; gap: 8px; background: rgba(255,255,255,0.06); border-radius: 8px; padding: 7px 12px; font-size: 12px; color: rgba(255,255,255,0.7); }
.cvr-upload__remove { margin-left: auto; background: none; border: none; color: rgba(255,255,255,0.3); cursor: pointer; font-size: 12px; transition: color 0.15s; }
.cvr-upload__remove:hover { color: #f87171; }

/* AI Notice */
.cvr-notice { display: flex; gap: 14px; background: rgba(249,115,22,0.08); border: 1px solid rgba(249,115,22,0.25); border-radius: 12px; padding: 16px 18px; }
.cvr-notice svg { color: #fb923c; flex-shrink: 0; margin-top: 2px; }
.cvr-notice strong { display: block; font-size: 13px; color: #fb923c; margin-bottom: 4px; }
.cvr-notice p { font-size: 12px; color: rgba(255,255,255,0.5); line-height: 1.5; margin: 0; }

/* Checkbox */
.cvr-field--check { flex-direction: row; align-items: flex-start; }
.cvr-checkbox { display: flex; align-items: flex-start; gap: 10px; cursor: pointer; }
.cvr-checkbox input { display: none; }
.cvr-checkbox__box { width: 18px; height: 18px; flex-shrink: 0; border: 2px solid rgba(255,255,255,0.25); border-radius: 5px; background: rgba(255,255,255,0.05); margin-top: 1px; transition: all 0.15s; display: flex; align-items: center; justify-content: center; }
.cvr-checkbox input:checked + .cvr-checkbox__box { background: #ef4444; border-color: #ef4444; }
.cvr-checkbox input:checked + .cvr-checkbox__box::after { content: 'v'; font-size: 11px; color: #fff; font-weight: 700; }
.cvr-checkbox__label { font-size: 13px; color: rgba(255,255,255,0.6); line-height: 1.5; }

/* Submit */
.cvr-form__footer { display: flex; flex-direction: column; align-items: center; gap: 10px; padding-top: 8px; }
.cvr-btn { display: inline-flex; align-items: center; gap: 8px; padding: 13px 32px; border-radius: 12px; font-size: 15px; font-weight: 600; border: none; cursor: pointer; transition: all 0.2s; font-family: inherit; }
.cvr-btn--danger { background: linear-gradient(135deg, #ef4444, #dc2626); color: #fff; box-shadow: 0 4px 20px rgba(239,68,68,0.35); }
.cvr-btn--danger:hover:not(:disabled) { transform: translateY(-1px); box-shadow: 0 6px 28px rgba(239,68,68,0.5); }
.cvr-btn--danger:disabled { opacity: 0.5; cursor: not-allowed; }
.cvr-form__note { font-size: 12px; color: rgba(255,255,255,0.35); text-align: center; }
.cvr-spinner { width: 16px; height: 16px; border: 2px solid rgba(255,255,255,0.3); border-top-color: #fff; border-radius: 50%; animation: spin 0.7s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

/* Timeline */
.cvr-timeline { display: flex; flex-direction: column; gap: 0; position: relative; padding-left: 28px; }
.cvr-timeline::before { content: ''; position: absolute; left: 7px; top: 8px; bottom: 8px; width: 2px; background: rgba(255,255,255,0.08); }
.cvr-timeline__item { display: flex; gap: 20px; padding-bottom: 28px; position: relative; }
.cvr-timeline__item:last-child { padding-bottom: 0; }
.cvr-timeline__dot { width: 16px; height: 16px; border-radius: 50%; background: rgba(239,68,68,0.3); border: 2px solid #ef4444; flex-shrink: 0; margin-top: 2px; position: absolute; left: -28px; }
.cvr-timeline__time { font-size: 11px; font-weight: 600; color: #f87171; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 4px; }
.cvr-timeline__title { font-size: 14px; font-weight: 600; margin-bottom: 4px; }
.cvr-timeline__desc { font-size: 13px; color: rgba(255,255,255,0.45); line-height: 1.5; }

/* Toast */
.cvr-toast { position: fixed; bottom: 32px; left: 50%; transform: translateX(-50%); display: flex; align-items: center; gap: 10px; padding: 14px 24px; border-radius: 12px; font-size: 14px; font-weight: 500; z-index: 9999; box-shadow: 0 8px 32px rgba(0,0,0,0.4); white-space: nowrap; }
.cvr-toast--success { background: rgba(16,185,129,0.15); border: 1px solid rgba(16,185,129,0.4); color: #34d399; }
.toast-enter-active { transition: all 0.3s ease; }
.toast-leave-active { transition: all 0.25s ease; }
.toast-enter-from { opacity: 0; transform: translateX(-50%) translateY(16px); }
.toast-leave-to { opacity: 0; transform: translateX(-50%) translateY(8px); }

@media (max-width: 600px) {
  .cvr-field-row { grid-template-columns: 1fr; }
  .cvr-card { padding: 24px 18px; }
  .cvr-hero__stats { flex-direction: column; gap: 12px; padding: 16px 20px; }
  .cvr-stat__divider { width: 40px; height: 1px; }
}
</style>

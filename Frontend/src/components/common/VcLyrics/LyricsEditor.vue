<template>
  <div class="lyrics-editor">

    <!-- Player bar -->
    <div class="le-player">
      <button class="le-play-btn" type="button" @click="togglePlay" :disabled="!src">
        <svg v-if="!playing" width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><polygon points="5 3 19 12 5 21 5 3"/></svg>
        <svg v-else width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><rect x="6" y="4" width="4" height="16"/><rect x="14" y="4" width="4" height="16"/></svg>
      </button>
      <div class="le-progress-wrap" @click="seek">
        <div class="le-progress-fill" :style="{ width: pct + '%' }"/>
        <div class="le-progress-thumb" :style="{ left: pct + '%' }"/>
      </div>
      <span class="le-time">{{ fmtTime(cur) }} / {{ fmtTime(dur) }}</span>
    </div>

    <audio ref="audioEl" :src="src" @timeupdate="onTick" @loadedmetadata="dur = audioEl!.duration" @ended="playing = false"/>

    <!-- Toolbar -->
    <div class="le-toolbar">
      <button type="button" class="le-btn" @click="addLine">+ Thêm dòng</button>
      <button type="button" class="le-btn" @click="stampLine" :disabled="focusedIdx < 0">
        ⏱ Gán <span class="le-time-chip">{{ fmtTime(cur) }}</span>
      </button>
      <div class="le-sep"/>
      <button type="button" class="le-btn" @click="openPaste">Dán lyrics thô</button>
      <div class="le-sep"/>
      <label class="le-btn le-btn--lrc">
        📄 Import .lrc
        <input type="file" accept=".lrc" hidden @change="onLrcImport" />
      </label>
      <div class="le-sep"/>
      <button type="button" class="le-btn le-btn--danger" @click="clearAll" v-if="lines.length > 0">🗑 Xoá tất cả</button>
      <div class="le-sep"/>
      <span class="le-count">{{ lines.length }} dòng</span>
    </div>

    <!-- Column headers -->
    <div class="le-col-head">
      <span>#</span>
      <span>Start (s)</span>
      <span>End (s)</span>
      <span>Lời bài hát</span>
      <span/>
    </div>

    <!-- Lines -->
    <div class="le-list" ref="listEl">
      <div v-if="lines.length === 0" class="le-empty">
        Chưa có lyrics — nhấn "Dán lyrics thô", "+ Thêm dòng" hoặc "Import .lrc"
      </div>

      <div
        v-for="(line, i) in lines"
        :key="line._id"
        class="le-row"
        :class="{ 'le-row--active': activeIdx === i }"
        @click="jumpTo(line.start)"
      >
        <span class="le-num">{{ i + 1 }}</span>
        <input
          class="le-time-input"
          :value="line.start.toFixed(2)"
          @change="updateField(i, 'start', ($event.target as HTMLInputElement).value)"
          @click.stop
          title="Start (giây)"
        />
        <input
          class="le-time-input"
          :value="line.end.toFixed(2)"
          @change="updateField(i, 'end', ($event.target as HTMLInputElement).value)"
          @click.stop
          title="End (giây)"
        />
        <input
          class="le-text-input"
          :value="line.text"
          @input="updateText(i, ($event.target as HTMLInputElement).value)"
          @focus="focusedIdx = i"
          @blur="focusedIdx = -1"
          @click.stop
          placeholder="Nhập lời..."
        />
        <button type="button" class="le-del" @click.stop="deleteLine(i)" title="Xóa">×</button>
      </div>
    </div>

    <!-- Paste modal -->
    <div v-if="showPaste" class="le-modal-backdrop" @click.self="showPaste = false">
      <div class="le-modal">
        <p class="le-modal-title">Dán lyrics thô</p>
        <p class="le-modal-sub">Mỗi dòng = 1 câu. Timestamps sẽ được gán sau.</p>
        <textarea
          v-model="rawPaste"
          class="le-paste-area"
          placeholder="Nhập lyrics vào đây..."
          rows="12"
          autofocus
        />
        <div class="le-modal-footer">
          <button type="button" class="le-btn" @click="showPaste = false">Huỷ</button>
          <button type="button" class="le-btn le-btn--primary" @click="confirmPaste">Xác nhận</button>
        </div>
      </div>
    </div>

    <!-- LRC preview modal -->
    <div v-if="showLrcPreview" class="le-modal-backdrop" @click.self="showLrcPreview = false">
      <div class="le-modal le-modal--wide">
        <p class="le-modal-title">📄 Preview LRC — {{ lrcParsed.length }} dòng</p>
        <p class="le-modal-sub">Kiểm tra trước khi import. Timestamps đã được parse từ file .lrc.</p>
        <div class="le-lrc-preview">
          <div v-for="(line, i) in lrcParsed" :key="i" class="le-lrc-row">
            <span class="le-lrc-time">{{ fmtTime(line.start) }}</span>
            <span class="le-lrc-text">{{ line.text }}</span>
          </div>
        </div>
        <div class="le-modal-footer">
          <button type="button" class="le-btn" @click="showLrcPreview = false">Huỷ</button>
          <button type="button" class="le-btn le-btn--primary" @click="confirmLrcImport">Import {{ lrcParsed.length }} dòng</button>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, nextTick } from 'vue'

export interface LyricLine {
  start: number
  end: number
  text: string
}

interface InternalLine extends LyricLine {
  _id: number
}

const props = defineProps<{
  modelValue: LyricLine[]
  src?: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', val: LyricLine[]): void
}>()

let _uid = 0
function mkId() { return ++_uid }

const lines = ref<InternalLine[]>(
  props.modelValue.map(l => ({ ...l, _id: mkId() }))
)

watch(() => props.modelValue, (val) => {
  if (val.length !== lines.value.length) {
    lines.value = val.map(l => ({ ...l, _id: mkId() }))
  }
}, { deep: true })

function emitOut() {
  emit('update:modelValue', lines.value.map(({ start, end, text }) => ({ start, end, text })))
}

// ── Audio ──
const audioEl = ref<HTMLAudioElement | null>(null)
const playing = ref(false)
const cur     = ref(0)
const dur     = ref(0)
const pct     = computed(() => dur.value ? (cur.value / dur.value) * 100 : 0)

function togglePlay() {
  if (!audioEl.value || !props.src) return
  if (playing.value) { audioEl.value.pause(); playing.value = false }
  else               { audioEl.value.play();  playing.value = true  }
}

function onTick() {
  if (audioEl.value) cur.value = audioEl.value.currentTime
}

function seek(e: MouseEvent) {
  if (!audioEl.value || !dur.value) return
  const rect  = (e.currentTarget as HTMLElement).getBoundingClientRect()
  const ratio = (e.clientX - rect.left) / rect.width
  audioEl.value.currentTime = ratio * dur.value
}

function jumpTo(start: number) {
  if (!audioEl.value || start <= 0) return
  audioEl.value.currentTime = start
}

function fmtTime(s: number) {
  const m   = Math.floor(s / 60)
  const sec = Math.floor(s % 60)
  return `${m}:${String(sec).padStart(2, '0')}`
}

// ── Active highlight ──
const activeIdx = computed(() => {
  const t = cur.value
  for (let i = lines.value.length - 1; i >= 0; i--) {
    if (t >= lines.value[i].start) return i
  }
  return -1
})

// ── Editing ──
const focusedIdx = ref(-1)
const listEl     = ref<HTMLElement | null>(null)

function addLine() {
  const lastEnd = lines.value.length > 0 ? lines.value[lines.value.length - 1].end : 0
  lines.value.push({ start: lastEnd, end: 0, text: '', _id: mkId() })
  emitOut()
  nextTick(() => {
    const inputs = listEl.value?.querySelectorAll<HTMLInputElement>('.le-text-input')
    inputs?.[inputs.length - 1]?.focus()
  })
}

function deleteLine(i: number) {
  lines.value.splice(i, 1)
  emitOut()
}

function updateField(i: number, key: 'start' | 'end', val: string) {
  lines.value[i][key] = parseFloat(val) || 0
  emitOut()
}

function updateText(i: number, val: string) {
  lines.value[i].text = val
  emitOut()
}

function clearAll() {
  lines.value = []
  emitOut()
}

// ── Stamp current time ──
function stampLine() {
  const i = focusedIdx.value
  if (i < 0) return
  const t = parseFloat(cur.value.toFixed(2))
  lines.value[i].start = t
  if (i > 0 && lines.value[i - 1].end === 0) {
    lines.value[i - 1].end = t
  }
  emitOut()
}

// ── Paste modal ──
const showPaste = ref(false)
const rawPaste  = ref('')

function openPaste() {
  rawPaste.value = ''
  showPaste.value = true
}

function confirmPaste() {
  const newLines: InternalLine[] = rawPaste.value
    .split('\n')
    .map(l => l.trim())
    .filter(l => l !== '')
    .map(text => ({ start: 0, end: 0, text, _id: mkId() }))

  lines.value = lines.value.length > 0 ? lines.value.concat(newLines) : newLines
  showPaste.value = false
  emitOut()
}

// ── LRC Import ──
const showLrcPreview = ref(false)
const lrcParsed      = ref<LyricLine[]>([])

function parseLrc(content: string): LyricLine[] {
  const result: LyricLine[] = []
  const timeRegex = /\[(\d{2}):(\d{2})\.(\d{2,3})\]/g

  for (const rawLine of content.split('\n')) {
    const trimmed = rawLine.trim()
    if (!trimmed) continue

    // Bỏ qua metadata tags
    if (/^\[(ti|ar|al|by|offset|re|ve|length):/i.test(trimmed)) continue

    const times: number[] = []
    let match
    timeRegex.lastIndex = 0

    while ((match = timeRegex.exec(trimmed)) !== null) {
      const min = parseInt(match[1])
      const sec = parseInt(match[2])
      const ms  = parseInt(match[3].padEnd(3, '0'))
      times.push(parseFloat((min * 60 + sec + ms / 1000).toFixed(2)))
    }

    // Bỏ hết timestamp tags để lấy text
    const text = trimmed.replace(/\[\d{2}:\d{2}\.\d{2,3}\]/g, '').trim()
    if (!text) continue

    for (const start of times) {
      result.push({ start, end: 0, text })
    }
  }

  // Sort theo start
  result.sort((a, b) => a.start - b.start)

  // Gán end = start của dòng kế tiếp
  for (let i = 0; i < result.length - 1; i++) {
    result[i].end = result[i + 1].start
  }

  return result
}

function onLrcImport(e: Event) {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (!file) return

  // Reset input để có thể import lại cùng file
  ;(e.target as HTMLInputElement).value = ''

  const reader = new FileReader()
  reader.onload = (ev) => {
    const content = ev.target?.result as string
    const parsed  = parseLrc(content)
    if (parsed.length === 0) return
    lrcParsed.value      = parsed
    showLrcPreview.value = true
  }
  reader.readAsText(file, 'UTF-8')
}

function confirmLrcImport() {
  lines.value          = lrcParsed.value.map(l => ({ ...l, _id: mkId() }))
  showLrcPreview.value = false
  lrcParsed.value      = []
  emitOut()
}
</script>

<style scoped>
.lyrics-editor {
  display: flex;
  flex-direction: column;
  gap: 8px;
  position: relative;
}

/* Player */
.le-player {
  display: flex;
  align-items: center;
  gap: 10px;
  background: #0f1117;
  border: 1px solid #2d3748;
  border-radius: 8px;
  padding: 8px 12px;
}
.le-play-btn {
  width: 30px; height: 30px; border-radius: 50%;
  border: 1px solid #2d3748; background: #1e2535;
  color: #94a3b8; cursor: pointer; display: flex;
  align-items: center; justify-content: center; flex-shrink: 0;
}
.le-play-btn:hover:not(:disabled) { border-color: #00c6ff; color: #00c6ff; }
.le-play-btn:disabled { opacity: 0.4; cursor: not-allowed; }
.le-progress-wrap {
  flex: 1; height: 4px; background: #2d3748; border-radius: 2px;
  cursor: pointer; position: relative;
}
.le-progress-fill { height: 100%; background: #00c6ff; border-radius: 2px; pointer-events: none; }
.le-progress-thumb {
  position: absolute; top: 50%; width: 10px; height: 10px;
  background: #00c6ff; border-radius: 50%;
  transform: translate(-50%, -50%); pointer-events: none;
}
.le-time { font-size: 11px; color: #4a5568; font-family: monospace; white-space: nowrap; }

/* Toolbar */
.le-toolbar { display: flex; gap: 6px; align-items: center; flex-wrap: wrap; }
.le-btn {
  font-size: 12px; padding: 5px 12px; border-radius: 7px;
  border: 1px solid #2d3748; background: #0f1117;
  color: #94a3b8; cursor: pointer; transition: border-color .15s, color .15s;
  display: inline-flex; align-items: center; gap: 4px;
}
.le-btn:hover:not(:disabled) { border-color: #00c6ff; color: #00c6ff; }
.le-btn:disabled { opacity: 0.4; cursor: not-allowed; }
.le-btn--primary { background: #00c6ff; color: #000; border-color: #00c6ff; font-weight: 600; }
.le-btn--primary:hover { opacity: 0.85; color: #000; }
.le-btn--lrc { border-color: #4a3f6b; color: #a78bfa; }
.le-btn--lrc:hover { border-color: #a78bfa; color: #c4b5fd; }
.le-btn--danger { border-color: #4a2020; color: #f87171; }
.le-btn--danger:hover { border-color: #f87171; color: #fca5a5; }
.le-time-chip {
  background: #1e2535; padding: 1px 6px; border-radius: 4px;
  font-family: monospace; font-size: 11px; color: #00c6ff;
}
.le-sep { width: 1px; height: 18px; background: #2d3748; }
.le-count { font-size: 11px; color: #334155; margin-left: auto; }

/* Column header */
.le-col-head {
  display: grid;
  grid-template-columns: 32px 76px 76px 1fr 24px;
  gap: 6px; padding: 0 8px;
  font-size: 10px; font-weight: 700;
  text-transform: uppercase; letter-spacing: .05em;
  color: #334155;
}

/* List */
.le-list {
  display: flex; flex-direction: column; gap: 3px;
  max-height: 340px; overflow-y: auto; padding-right: 2px;
}
.le-empty { text-align: center; padding: 24px; font-size: 12.5px; color: #334155; }

/* Row */
.le-row {
  display: grid;
  grid-template-columns: 32px 76px 76px 1fr 24px;
  gap: 6px; align-items: center;
  padding: 5px 8px; border-radius: 7px;
  border: 1px solid transparent;
  cursor: pointer; transition: background .12s, border-color .12s;
}
.le-row:hover { background: rgba(255,255,255,.03); border-color: #1e2535; }
.le-row--active { background: rgba(0,198,255,.06); border-color: rgba(0,198,255,.3); }
.le-num { font-size: 10px; color: #334155; text-align: right; font-family: monospace; }
.le-time-input {
  width: 100%; font-size: 11px; font-family: monospace;
  background: #1e2535; border: 1px solid #2d3748;
  border-radius: 5px; padding: 4px 6px; color: #64748b; outline: none;
}
.le-time-input:focus { border-color: #0072ff; color: #e2e8f0; }
.le-text-input {
  width: 100%; font-size: 13px; background: transparent;
  border: none; color: #e2e8f0; outline: none; font-family: inherit;
}
.le-row--active .le-text-input { font-weight: 600; color: #f1f5f9; }
.le-del {
  width: 20px; height: 20px; border-radius: 50%; border: 1px solid transparent;
  background: transparent; color: #334155; cursor: pointer;
  font-size: 15px; line-height: 1; display: flex; align-items: center; justify-content: center;
}
.le-del:hover { border-color: #f87171; color: #f87171; background: rgba(248,113,113,.1); }

/* Modal */
.le-modal-backdrop {
  position: fixed; inset: 0; background: rgba(0,0,0,.6);
  display: flex; align-items: center; justify-content: center;
  z-index: 9999;
}
.le-modal {
  background: #1a1f2e; border: 1px solid #2d3748; border-radius: 12px;
  padding: 20px 24px; width: 480px; max-width: 90vw;
  display: flex; flex-direction: column; gap: 10px;
}
.le-modal--wide { width: 600px; }
.le-modal-title { font-size: 15px; font-weight: 700; color: #f1f5f9; }
.le-modal-sub { font-size: 12px; color: #4a5568; }
.le-paste-area {
  width: 100%; background: #0f1117; border: 1px solid #2d3748;
  border-radius: 8px; padding: 10px 12px; color: #e2e8f0;
  font-size: 13px; font-family: inherit; resize: vertical; outline: none;
  line-height: 1.6;
}
.le-paste-area:focus { border-color: #0072ff; }
.le-modal-footer { display: flex; justify-content: flex-end; gap: 8px; }

/* LRC preview */
.le-lrc-preview {
  max-height: 320px; overflow-y: auto;
  display: flex; flex-direction: column; gap: 2px;
  background: #0f1117; border: 1px solid #2d3748;
  border-radius: 8px; padding: 8px;
}
.le-lrc-row {
  display: flex; gap: 12px; align-items: baseline;
  padding: 3px 6px; border-radius: 4px;
}
.le-lrc-row:hover { background: rgba(255,255,255,.03); }
.le-lrc-time {
  font-size: 11px; font-family: monospace; color: #00c6ff;
  white-space: nowrap; flex-shrink: 0; min-width: 40px;
}
.le-lrc-text { font-size: 13px; color: #e2e8f0; }
</style>
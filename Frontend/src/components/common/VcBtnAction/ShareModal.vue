<!-- components/ShareModal.vue -->
<template>
  <Transition name="share-modal">
    <div v-if="store.isOpen" class="share-overlay" @click.self="store.close()">
      <div class="share-modal">

        <div class="share-modal__header">
          <span class="share-modal__title">Chia sẻ</span>
          <button class="share-modal__close" @click="store.close()">✕</button>
        </div>

        <div class="share-modal__qr">
          <canvas ref="qrCanvas" />
          <p class="share-modal__qr-hint">Scan để mở</p>
        </div>

        <div class="share-modal__link-row">
          <input :value="store.shareUrl" readonly class="share-modal__input" />
          <button
            class="share-modal__copy-btn"
            :class="{ 'share-modal__copy-btn--copied': copied }"
            @click="copyLink"
          >
            {{ copied ? 'Đã copy!' : 'Copy' }}
          </button>
        </div>

        <div class="share-modal__socials">
          <a :href="fbUrl" target="_blank" rel="noopener" class="share-social share-social--fb">Facebook</a>
          <a :href="twUrl" target="_blank" rel="noopener" class="share-social share-social--tw">X / Twitter</a>
        </div>

      </div>
    </div>
  </Transition>
</template>

<script setup lang="ts">
import { ref, computed, watch, nextTick } from 'vue'
import QRCode from 'qrcode'
import { useShareModalStore } from '@/store/shareModal'

const store = useShareModalStore()
const copied = ref(false)
const qrCanvas = ref<HTMLCanvasElement | null>(null)

const fbUrl = computed(() =>
  `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(store.shareUrl)}`
)
const twUrl = computed(() =>
  `https://twitter.com/intent/tweet?url=${encodeURIComponent(store.shareUrl)}`
)

watch(() => store.isOpen, async (val) => {
  if (!val) { copied.value = false; return }
  await nextTick()
  if (qrCanvas.value) {
    await QRCode.toCanvas(qrCanvas.value, store.shareUrl, {
      width: 180,
      margin: 2,
      color: { dark: '#ffffff', light: '#18182a' },
    })
  }
})

const copyLink = async () => {
  await navigator.clipboard.writeText(store.shareUrl)
  copied.value = true
  setTimeout(() => (copied.value = false), 2000)
}
</script>

<style scoped>
.share-overlay {
  position: fixed; inset: 0; z-index: 9999;
  background: rgba(0,0,0,0.55);
  backdrop-filter: blur(6px);
  display: flex; align-items: center; justify-content: center;
}
.share-modal {
  width: 340px; border-radius: 16px;
  background: #18182a;
  border: 1px solid rgba(255,255,255,0.1);
  padding: 20px; display: flex; flex-direction: column; gap: 16px;
  z-index: 9999;
}
.share-modal__header {
  display: flex; justify-content: space-between; align-items: center;
}
.share-modal__title { color: #fff; font-size: 15px; font-weight: 500; }
.share-modal__close {
  background: none; border: none; color: rgba(255,255,255,0.4);
  cursor: pointer; padding: 4px; border-radius: 6px; transition: color 0.15s;
}
.share-modal__close:hover { color: #fff; }
.share-modal__qr { display: flex; flex-direction: column; align-items: center; gap: 8px; }
.share-modal__qr canvas { border-radius: 10px; }
.share-modal__qr-hint { color: rgba(255,255,255,0.35); font-size: 12px; margin: 0; }
.share-modal__link-row { display: flex; gap: 8px; }
.share-modal__input {
  flex: 1; min-width: 0;
  background: rgba(255,255,255,0.06);
  border: 1px solid rgba(255,255,255,0.1); border-radius: 8px;
  padding: 8px 10px; color: rgba(255,255,255,0.6);
  font-size: 12px; outline: none;
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.share-modal__copy-btn {
  padding: 8px 14px; background: #6366f1; border: none;
  border-radius: 8px; color: #fff; font-size: 13px; font-weight: 500;
  cursor: pointer; white-space: nowrap; transition: background 0.2s;
}
.share-modal__copy-btn:hover { background: #4f46e5; }
.share-modal__copy-btn--copied { background: #10b981 !important; }
.share-modal__socials { display: flex; gap: 8px; }
.share-social {
  flex: 1; text-align: center; padding: 9px; border-radius: 8px;
  font-size: 13px; font-weight: 500; text-decoration: none; transition: opacity 0.2s;
}
.share-social:hover { opacity: 0.85; }
.share-social--fb { background: #1877f2; color: #fff; }
.share-social--tw { background: #000; color: #fff; border: 1px solid rgba(255,255,255,0.15); }

.share-modal-enter-active, .share-modal-leave-active { transition: all 0.2s ease; }
.share-modal-enter-from, .share-modal-leave-to { opacity: 0; transform: scale(0.94); }
</style>
// stores/shareModal.ts
import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useShareModalStore = defineStore('shareModal', () => {
  const isOpen = ref(false)
  const shareUrl = ref('')
  const open = (url: string) => { shareUrl.value = url; isOpen.value = true }
  const close = () => { isOpen.value = false }
  return { isOpen, shareUrl, open, close }
})
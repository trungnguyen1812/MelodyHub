import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { Song } from '@/interfaces/songs.interface'

export const usePlayerStore = defineStore('player', () => {
    const audio = ref<HTMLAudioElement | null>(null)
    const currentSong = ref<Song | null>(null)
    const isPlaying = ref(false)
    const currentTime = ref(0)
    const duration = ref(0)
    const volume = ref(0.8)
    const isMuted = ref(false)
    const queue = ref<Song[]>([])

    const currentIndex = computed(() =>
        queue.value.findIndex(s => s.id === currentSong.value?.id)
    )
    const hasPrev = computed(() => currentIndex.value > 0)
    const hasNext = computed(() => currentIndex.value < queue.value.length - 1)

    function getBestUrl(song: Song): string | null {
        return song.urls.standard ?? song.urls.low ?? song.urls.lossless ?? null
    }

    function play(song: Song, songQueue?: Song[]) {
        if (songQueue) queue.value = songQueue

        if (currentSong.value?.id === song.id) {
            toggle()
            return
        }

        _destroy()
        currentSong.value = song
        const url = getBestUrl(song)
        if (!url) return

        audio.value = new Audio(url)
        audio.value.volume = isMuted.value ? 0 : volume.value
        audio.value.ontimeupdate = () => { currentTime.value = audio.value?.currentTime ?? 0 }
        audio.value.onloadedmetadata = () => { duration.value = audio.value?.duration ?? 0 }
        audio.value.onended = () => { isPlaying.value = false; playNext() }
        audio.value.onerror = () => { isPlaying.value = false }
        audio.value.play().catch(() => { isPlaying.value = false })
        isPlaying.value = true
    }

    function toggle() {
    
        if (!audio.value) return
        if (isPlaying.value) { audio.value.pause(); isPlaying.value = false }
        else { audio.value.play(); isPlaying.value = true }
    }

    function stop() { _destroy() }

    function playPrev() {
        
        if (hasPrev.value) play(queue.value[currentIndex.value - 1])
    }

    function playNext() {
        if (hasNext.value) play(queue.value[currentIndex.value + 1])
    }

    
    function seek(val: number) {
        if (audio.value) audio.value.currentTime = val
        currentTime.value = val
    }

    function setVolume(val: number) {
        volume.value = val
        isMuted.value = val === 0
        if (audio.value) audio.value.volume = val
    }

    function toggleMute() {
        isMuted.value = !isMuted.value
        if (audio.value) audio.value.volume = isMuted.value ? 0 : volume.value
    }

    function _destroy() {
        audio.value?.pause()
        audio.value = null
        currentSong.value = null
        isPlaying.value = false
        currentTime.value = 0
        duration.value = 0
    }

    return {
        currentSong, isPlaying, currentTime, duration, volume, isMuted,
        hasPrev, hasNext, play, toggle, stop, playPrev, playNext,
        seek, setVolume, toggleMute
    }
})
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { Song } from '@/interfaces/songs.interface'
import songsService from '@/modules/client/services/songs/songs.service'

export const usePlayerStore = defineStore('player', () => {
    const audio = ref<HTMLAudioElement | null>(null)
    const currentSong = ref<Song | null>(null)
    const isPlaying = ref(false)
    const currentTime = ref(0)
    const duration = ref(0)
    const volume = ref(0.8)
    const isMuted = ref(false)
    const queue = ref<Song[]>([])
    const currentPlaylistId = ref<number | null>(null)

    // ─── Play tracking state ───────────────────────────────────────────────
    const _playTracked = ref(false)
    const _playStartTime = ref(0)
    const _totalListenedSec = ref(0)

    const PLAY_THRESHOLD_SEC = 30
    const PLAY_THRESHOLD_PERCENT = 0.4

    // ─── Computed ─────────────────────────────────────────────────────────
    const currentIndex = computed(() =>
        queue.value.findIndex(s => s.id === currentSong.value?.id)
    )
    const hasPrev = computed(() => currentIndex.value > 0)
    const hasNext = computed(() => currentIndex.value < queue.value.length - 1)

    // ─── Helpers ──────────────────────────────────────────────────────────
    function getBestUrl(song: Song): string | null {
        return song.urls.standard ?? song.urls.low ?? song.urls.lossless ?? null
    }

    // Gọi API ghi nhận play — chỉ được gọi 1 lần mỗi bài
    async function _recordPlay(song: Song) {
        if (_playTracked.value) return
        _playTracked.value = true

        try {
            await songsService.recordPlay(song.id, {
                played_duration: Math.floor(_totalListenedSec.value),
                play_percentage: duration.value > 0
                    ? parseFloat((_totalListenedSec.value / duration.value * 100).toFixed(2))
                    : 0,
                is_completed: duration.value > 0 && _totalListenedSec.value / duration.value >= 0.8,
                playlist_id: currentPlaylistId.value ?? undefined,
            })
        } catch (err) {
            _playTracked.value = false
            console.warn('[PlayerStore] recordPlay failed:', err)
        }
    }

    // Gọi mỗi khi audio timeupdate — kiểm tra đã đủ ngưỡng chưa
    function _checkPlayThreshold() {
        if (_playTracked.value || !currentSong.value) return

        const dur = duration.value
        const listened = _totalListenedSec.value

        const passedTimeSec = listened >= PLAY_THRESHOLD_SEC
        const passedPercent = dur > 0 && listened / dur >= PLAY_THRESHOLD_PERCENT

        if (passedTimeSec || passedPercent) {
            _recordPlay(currentSong.value)
        }
    }

    // Reset tracking khi chuyển bài
    function _resetTracking() {
        _playTracked.value = false
        _playStartTime.value = 0
        _totalListenedSec.value = 0
    }

    // ─── Core actions ──────────────────────────────────────────────────────

    // ← FIX: thêm playlistId vào param
    function play(song: Song, songQueue?: Song[], playlistId?: number | null) {
        if (songQueue) queue.value = songQueue

        // ← FIX: playlistId lấy từ param, không bị undefined nữa
        currentPlaylistId.value = playlistId ?? null

        if (currentSong.value?.id === song.id) {
            toggle()
            return
        }

        _destroy()
        _resetTracking()

        currentSong.value = song
        const url = getBestUrl(song)
        if (!url) return

        audio.value = new Audio(url)
        audio.value.volume = isMuted.value ? 0 : volume.value

        _playStartTime.value = Date.now()

        audio.value.ontimeupdate = () => {
            currentTime.value = audio.value?.currentTime ?? 0

            if (isPlaying.value && _playStartTime.value > 0) {
                const now = Date.now()
                const delta = (now - _playStartTime.value) / 1000
                if (delta > 0 && delta < 2) {
                    _totalListenedSec.value += delta
                }
                _playStartTime.value = now
            }

            _checkPlayThreshold()
        }

        audio.value.onloadedmetadata = () => {
            duration.value = audio.value?.duration ?? 0
        }

        audio.value.onended = () => {
            if (currentSong.value && !_playTracked.value) {
                _recordPlay(currentSong.value)
            }
            isPlaying.value = false
            playNext()
        }

        audio.value.onerror = () => { isPlaying.value = false }
        audio.value.play().catch(() => { isPlaying.value = false })
        isPlaying.value = true
    }

    function toggle() {
        if (!audio.value) return

        if (isPlaying.value) {
            audio.value.pause()
            isPlaying.value = false
            _playStartTime.value = 0
        } else {
            audio.value.play()
            isPlaying.value = true
            _playStartTime.value = Date.now()
        }
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
        if (isPlaying.value) _playStartTime.value = Date.now()
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
        _resetTracking()
    }

    return {
        currentSong, isPlaying, currentTime, duration, volume, isMuted,
        hasPrev, hasNext, currentPlaylistId,  // ← FIX: expose currentPlaylistId
        play, toggle, stop, playPrev, playNext,
        seek, setVolume, toggleMute
    }
})
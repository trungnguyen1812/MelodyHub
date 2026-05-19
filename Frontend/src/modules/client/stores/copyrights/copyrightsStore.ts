import { defineStore } from 'pinia'
import CopyrightService from '@/modules/client/services/copyrights/copyrights.service'
import type { Copyright } from '@/interfaces/copyrights.interface'

interface CopyrightPagination {
    current_page: number
    last_page: number
    per_page: number
    total: number
}

interface CopyrightState {
    copyrights: Copyright[]
    currentCopyright: Copyright | null
    loading: boolean
    error: string | null
    uploadProgress: number
    pagination: CopyrightPagination
}

function extractError(error: unknown): string {
    if (error && typeof error === 'object' && 'response' in error) {
        const axiosError = error as { response?: { data?: { message?: string; errors?: unknown } } }
        return axiosError.response?.data?.message ?? 'Có lỗi xảy ra'
    }
    if (error instanceof Error) return error.message
    return 'Có lỗi xảy ra'
}

function extractErrors(error: unknown): unknown {
    if (error && typeof error === 'object' && 'response' in error) {
        const axiosError = error as { response?: { data?: { errors?: unknown } } }
        return axiosError.response?.data?.errors ?? null
    }
    return null
}

function isNetworkError(error: unknown): boolean {
    if (error && typeof error === 'object' && 'request' in error && !('response' in error)) {
        return true
    }
    return false
}

export const useCopyrightStore = defineStore('copyrightClient', {
    state: (): CopyrightState => ({
        copyrights: [],
        currentCopyright: null,
        loading: false,
        error: null,
        uploadProgress: 0,
        pagination: {
            current_page: 1,
            last_page: 1,
            per_page: 15,
            total: 0
        }
    }),

    getters: {
        activeCopyrights: (state) => state.copyrights.filter(c => c.status === 'active'),
        expiredCopyrights: (state) => state.copyrights.filter(c => c.status === 'expired'),
        getCopyrightsBySong: (state) => (songId: number) =>
            state.copyrights.filter(c => c.song_id === songId),
        getCopyrightsByPartner: (state) => (partnerId: number) =>
            state.copyrights.filter(c => c.partner_id === partnerId),
    },

    actions: {
        // Thêm bản quyền mới
        async addCopyright(formData: FormData) {
            this.loading = true
            this.error = null
            this.uploadProgress = 0

            try {
                const response = await CopyrightService.addCopyright(formData)

                if (response.data.success) {
                    this.copyrights.unshift(response.data.data as Copyright)
                    this.uploadProgress = 100
                    return {
                        success: true,
                        data: response.data.data as Copyright,
                        message: (response.data.message as string) || 'Thêm bản quyền thành công'
                    }
                }

                return { success: false, message: 'Thêm bản quyền thất bại' }
            } catch (error: unknown) {
                if (isNetworkError(error)) {
                    this.error = 'Không thể kết nối đến server'
                    return { success: false, message: this.error }
                }
                this.error = extractError(error)
                return {
                    success: false,
                    errors: extractErrors(error),
                    message: this.error
                }
            } finally {
                this.loading = false
                setTimeout(() => { this.uploadProgress = 0 }, 1000)
            }
        },

        // Lấy danh sách bản quyền (có phân trang)
        async fetchCopyrights(params: Record<string, unknown> = {}) {
            this.loading = true
            this.error = null

            try {
                const response = await CopyrightService.getCopyrights(params)

                if (response.data.success) {
                    this.copyrights = response.data.data as Copyright[]

                    const d = response.data as Record<string, unknown>
                    if (d.current_page) {
                        this.pagination = {
                            current_page: d.current_page as number,
                            last_page:    d.last_page as number,
                            per_page:     d.per_page as number,
                            total:        d.total as number,
                        }
                    }

                    return response.data
                }
            } catch (error: unknown) {
                this.error = extractError(error)
                throw error
            } finally {
                this.loading = false
            }
        },

        // Lấy chi tiết bản quyền
        async fetchCopyright(id: number) {
            this.loading = true
            this.error = null

            try {
                const response = await CopyrightService.getCopyright(id)

                if (response.data.success) {
                    this.currentCopyright = response.data.data as Copyright
                    return response.data
                }
            } catch (error: unknown) {
                this.error = extractError(error)
                throw error
            } finally {
                this.loading = false
            }
        },

        // Cập nhật bản quyền
        async updateCopyright(id: number, formData: FormData) {
            this.loading = true
            this.error = null
            this.uploadProgress = 0

            try {
                const response = await CopyrightService.updateCopyright(id, formData)

                if (response.data.success) {
                    const updated = response.data.data as Copyright
                    const index = this.copyrights.findIndex(c => c.id === id)
                    if (index !== -1) this.copyrights[index] = updated
                    if (this.currentCopyright?.id === id) this.currentCopyright = updated
                    this.uploadProgress = 100

                    return {
                        success: true,
                        data: updated,
                        message: (response.data.message as string) || 'Cập nhật thành công'
                    }
                }

                return { success: false, message: 'Cập nhật thất bại' }
            } catch (error: unknown) {
                this.error = extractError(error)
                return {
                    success: false,
                    errors: extractErrors(error),
                    message: this.error
                }
            } finally {
                this.loading = false
                setTimeout(() => { this.uploadProgress = 0 }, 1000)
            }
        },

        // Xóa bản quyền
        async deleteCopyright(id: number) {
            this.loading = true
            this.error = null

            try {
                const response = await CopyrightService.deleteCopyright(id)

                if (response.data.success) {
                    this.copyrights = this.copyrights.filter(c => c.id !== id)
                    if (this.currentCopyright?.id === id) this.currentCopyright = null
                    return { success: true, message: (response.data.message as string) || 'Xóa thành công' }
                }

                return { success: false, message: 'Xóa thất bại' }
            } catch (error: unknown) {
                this.error = extractError(error)
                return { success: false, message: this.error }
            } finally {
                this.loading = false
            }
        },

        // Upload file contract riêng lẻ
        async uploadContract(id: number, file: File, onProgress?: (pct: number) => void) {
            this.loading = true
            this.error = null
            this.uploadProgress = 0

            try {
                const formData = new FormData()
                formData.append('contract_file', file)

                const response = await CopyrightService.uploadContract(id, formData, (event: ProgressEvent) => {
                    if (event.lengthComputable) {
                        const pct = Math.round((event.loaded * 100) / event.total)
                        this.uploadProgress = pct
                        if (onProgress) onProgress(pct)
                    }
                })

                if (response.data.success) {
                    const docUrl = response.data.document_url as string
                    const index = this.copyrights.findIndex(c => c.id === id)
                    if (index !== -1) this.copyrights[index].document_url = docUrl
                    if (this.currentCopyright?.id === id) this.currentCopyright.document_url = docUrl

                    return { success: true, document_url: docUrl, message: 'Upload file thành công' }
                }

                return { success: false, message: 'Upload file thất bại' }
            } catch (error: unknown) {
                this.error = extractError(error)
                return { success: false, message: this.error }
            } finally {
                this.loading = false
            }
        },

        // Reset state
        resetState() {
            this.copyrights = []
            this.currentCopyright = null
            this.loading = false
            this.error = null
            this.uploadProgress = 0
            this.pagination = { current_page: 1, last_page: 1, per_page: 15, total: 0 }
        },

        clearError() {
            this.error = null
        },

        setUploadProgress(progress: number) {
            this.uploadProgress = progress
        }
    }
})

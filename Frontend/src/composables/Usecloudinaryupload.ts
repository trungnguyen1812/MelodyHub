import { ref } from 'vue'

const CLOUD_NAME  = import.meta.env.VITE_CLOUDINARY_CLOUD_NAME
const UPLOAD_PRESET = import.meta.env.VITE_CLOUDINARY_COVER_PRESET

export function useCloudinaryUpload() {
  const isUploading  = ref(false)
  const uploadProgress = ref(0)
  const error        = ref<string | null>(null)

  /**
   * Upload file ảnh lên Cloudinary bằng Unsigned preset.
   * Trả về secure_url để gắn vào form.cover_url
   */
  async function uploadCover(file: File): Promise<string> {
    isUploading.value    = true
    uploadProgress.value = 0
    error.value          = null
   
    const formData = new FormData()
    formData.append('file',           file)
    formData.append('upload_preset',  UPLOAD_PRESET)
    formData.append('folder',         'songs/covers')

    return new Promise((resolve, reject) => {
      const xhr = new XMLHttpRequest()

      // Theo dõi tiến trình upload
      xhr.upload.onprogress = (e) => {
        if (e.lengthComputable) {
          uploadProgress.value = Math.round((e.loaded / e.total) * 100)
        }
      }

      xhr.onload = () => {
        isUploading.value = false
        if (xhr.status === 200) {
          const res = JSON.parse(xhr.responseText)
          uploadProgress.value = 100
          resolve(res.secure_url)
        } else {
          const msg = 'Cloudinary upload failed: ' + xhr.statusText
          error.value = msg
          reject(new Error(msg))
        }
      }

      xhr.onerror = () => {
        isUploading.value = false
        error.value = 'Network error during upload'
        reject(new Error('Network error'))
      }

      xhr.open('POST', `https://api.cloudinary.com/v1_1/${CLOUD_NAME}/image/upload`)
      xhr.send(formData)
    })
  }

  return { uploadCover, isUploading, uploadProgress, error }
}
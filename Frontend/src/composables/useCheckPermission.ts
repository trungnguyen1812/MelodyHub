import { useRouter } from 'vue-router'
import { useAuthStore } from '@/store/authStore'
import clientApi from '@/plugins/axios'
import { useNotificationStore } from '@/store/notificationStore'


export function useCheckPermission() {
  const router    = useRouter()
  const authStore = useAuthStore()
  const notificationStore = useNotificationStore()


  const goToCollaborations = async () => {
    try {
      const res  = await clientApi.get('/check-permission')
      const data = res.data
    
      if (!data.is_partner) {
        router.push({ name: 'client.partner.index' })
      } else if (data.is_music_distribution) {
        router.push({ name: 'client.partner.dashboard' })
      } else if (data.is_advertising) {
        router.push({ name: 'client.partner.Advertisingd' })
      } else {
        router.push({ name: 'client.partner.index' })
      }
    } catch (err: any ) {
        notificationStore.notify(err.response?.data?.message || 'Failed to  Collaborations view', 'error')
    }
  }

  return { goToCollaborations }
}
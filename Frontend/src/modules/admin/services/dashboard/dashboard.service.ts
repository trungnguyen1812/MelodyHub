import adminApi from '@/plugins/axios_admin'

class DashboardService {
  async getDashboard() {
    const res = await adminApi.get('/dashboard')
    return res.data
  }
}

export default new DashboardService()

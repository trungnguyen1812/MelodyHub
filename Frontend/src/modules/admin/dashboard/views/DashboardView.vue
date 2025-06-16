<template>
  <div class="min-h-screen">
    <Sidebar @sidebar-toggle="handleSidebarToggle" />
    <Header :sidebar-collapsed="sidebarCollapsed" :page-title="currentPageTitle" />

    <main :class="[
      'pt-16 pb-20 transition-all duration-300 ease-in-out',
      sidebarCollapsed ? 'ml-16' : 'ml-64'
    ]">
      <div class="p-6">
        <!-- Dashboard Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <div 
            v-for="stat in dashboardStats" 
            :key="stat.id"
            class="bg-gray-800 border border-gray-700 rounded-xl p-6 hover:bg-gray-750 transition-colors duration-200"
          >
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-400 text-sm font-medium">{{ stat.title }}</p>
                <p class="text-2xl font-bold text-white mt-2">{{ stat.value }}</p>
                <div class="flex items-center mt-2">
                  <span :class="[
                    'text-sm font-medium',
                    stat.trend > 0 ? 'text-green-400' : 'text-red-400'
                  ]">
                    {{ stat.trend > 0 ? '+' : '' }}{{ stat.trend }}%
                  </span>
                  <span class="text-gray-400 text-sm ml-2">vs last month</span>
                </div>
              </div>
              <div :class="[
                'w-12 h-12 rounded-lg flex items-center justify-center',
                stat.bgColor
              ]">
                <i :class="stat.icon" class="text-xl text-white"></i>
              </div>
            </div>
          </div>
        </div>

        <!-- Charts Section -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
          <div class="bg-gray-800 border border-gray-700 rounded-xl p-6">
            <h3 class="text-xl font-semibold text-white mb-4">Music Uploads</h3>
            <div class="h-64 bg-gray-700 rounded-lg flex items-center justify-center">
              <div class="text-center">
                <i class="bx bx-bar-chart-alt-2 text-4xl text-gray-500 mb-2"></i>
                <p class="text-gray-400">Chart placeholder</p>
              </div>
            </div>
          </div>

          <div class="bg-gray-800 border border-gray-700 rounded-xl p-6">
            <h3 class="text-xl font-semibold text-white mb-4">User Activity</h3>
            <div class="h-64 bg-gray-700 rounded-lg flex items-center justify-center">
              <div class="text-center">
                <i class="bx bx-line-chart text-4xl text-gray-500 mb-2"></i>
                <p class="text-gray-400">Chart placeholder</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Recent Activities -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div class="bg-gray-800 border border-gray-700 rounded-xl p-6">
            <h3 class="text-xl font-semibold text-white mb-4">Recent Songs</h3>
            <div class="space-y-4">
              <div 
                v-for="song in recentSongs" 
                :key="song.id"
                class="flex items-center space-x-3 p-3 bg-gray-700 rounded-lg hover:bg-gray-600 transition-colors duration-200"
              >
                <div class="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center">
                  <i class="bx bx-music text-white"></i>
                </div>
                <div class="flex-1">
                  <p class="text-white font-medium text-sm">{{ song.title }}</p>
                  <p class="text-gray-400 text-xs">{{ song.artist }}</p>
                </div>
                <span class="text-gray-400 text-xs">{{ song.time }}</span>
              </div>
            </div>
          </div>

          <div class="bg-gray-800 border border-gray-700 rounded-xl p-6">
            <h3 class="text-xl font-semibold text-white mb-4">Top Artists</h3>
            <div class="space-y-4">
              <div 
                v-for="artist in topArtists" 
                :key="artist.id"
                class="flex items-center space-x-3 p-3 bg-gray-700 rounded-lg hover:bg-gray-600 transition-colors duration-200"
              >
                <div class="w-10 h-10 bg-purple-600 rounded-lg flex items-center justify-center">
                  <i class="bx bx-user-voice text-white"></i>
                </div>
                <div class="flex-1">
                  <p class="text-white font-medium text-sm">{{ artist.name }}</p>
                  <p class="text-gray-400 text-xs">{{ artist.plays }} plays</p>
                </div>
                <div class="text-right">
                  <p class="text-green-400 text-xs font-medium">+{{ artist.growth }}%</p>
                </div>
              </div>
            </div>
          </div>

          <div class="bg-gray-800 border border-gray-700 rounded-xl p-6">
            <h3 class="text-xl font-semibold text-white mb-4">System Alerts</h3>
            <div class="space-y-4">
              <div 
                v-for="alert in systemAlerts" 
                :key="alert.id"
                class="flex items-start space-x-3 p-3 bg-gray-700 rounded-lg"
              >
                <div :class="[
                  'w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5',
                  alert.type === 'warning' ? 'bg-yellow-600' : 
                  alert.type === 'error' ? 'bg-red-600' : 'bg-blue-600'
                ]">
                  <i :class="[
                    'text-white text-xs',
                    alert.type === 'warning' ? 'bx bx-error' : 
                    alert.type === 'error' ? 'bx bx-x' : 'bx bx-info-circle'
                  ]"></i>
                </div>
                <div class="flex-1">
                  <p class="text-white text-sm">{{ alert.message }}</p>
                  <p class="text-gray-400 text-xs mt-1">{{ alert.time }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <Footer :sidebar-collapsed="sidebarCollapsed" />
  </div>
</template>

<script setup>
import { ref } from 'vue'

const sidebarCollapsed = ref(false)
const currentPageTitle = ref('Dashboard')

const dashboardStats = ref([
  { id: 1, title: 'Total Songs', value: '12,450', trend: 12.5, icon: 'bx bx-music', bgColor: 'bg-blue-600' },
  { id: 2, title: 'Active Users', value: '8,230', trend: 8.2, icon: 'bx bx-group', bgColor: 'bg-green-600' },
  { id: 3, title: 'Revenue', value: '$45,230', trend: 15.3, icon: 'bx bx-dollar-circle', bgColor: 'bg-purple-600' },
  { id: 4, title: 'Downloads', value: '156,890', trend: -2.4, icon: 'bx bx-download', bgColor: 'bg-orange-600' }
])

const recentSongs = ref([
  { id: 1, title: 'Summer Nights', artist: 'John Doe', time: '2 mins ago' },
  { id: 2, title: 'Electric Dreams', artist: 'Jane Smith', time: '15 mins ago' },
  { id: 3, title: 'Ocean Waves', artist: 'Mike Johnson', time: '1 hour ago' },
  { id: 4, title: 'City Lights', artist: 'Sarah Wilson', time: '2 hours ago' }
])

const topArtists = ref([
  { id: 1, name: 'Taylor Swift', plays: '2.5M', growth: 15 },
  { id: 2, name: 'The Weeknd', plays: '1.8M', growth: 12 },
  { id: 3, name: 'Billie Eilish', plays: '1.3M', growth: 8 },
  { id: 4, name: 'Drake', plays: '950K', growth: 5 }
])

const systemAlerts = ref([
  { id: 1, message: 'Server maintenance scheduled', time: '10 mins ago', type: 'info' },
  { id: 2, message: 'High CPU usage detected', time: '1 hour ago', type: 'warning' },
  { id: 3, message: 'Database backup completed', time: '2 hours ago', type: 'info' }
])

function handleSidebarToggle(collapsed) {
  sidebarCollapsed.value = collapsed
}
</script>

<style scoped>

</style>
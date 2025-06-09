<template>
  <section class="px-6 py-8">
    <!-- Header -->
    <div class="flex items-center justify-between mb-8">
      <h2 class="text-3xl font-bold text-white">Music Charts</h2>
      <div class="flex items-center gap-4">
        <button
          class="see-all-btn text-gray-400 hover:text-white transition-colors duration-200 text-sm font-medium border-none outline-none focus:outline-none"
        >
          SEE ALL
        </button>
      </div>
    </div>

    <!-- Debug info -->
    <div v-if="!songs || songs.length === 0" class="text-red-400 mb-4">
      No songs data available. Songs: {{ JSON.stringify(songs) }}
    </div>

    <!-- Chart Container -->
    <div v-else class="chart-container">
      <div class="bg-gray-900 rounded-lg p-4">
        <div class="chart-wrapper">
          <apexchart
            type="line"
            height="350"
            :options="chartOptions"
            :series="chartSeries"
          ></apexchart>
        </div>
      </div>

      <!-- Table with Images -->
      <div class="mt-8 overflow-x-auto bg-black rounded-lg shadow-xl">
        <table class="w-full text-sm text-white">
          <thead class="bg-gray-900">
            <tr>
              <th class="py-3 px-4 text-left rounded-tl-lg">#</th>
              <th class="py-3 px-4 text-left">Song</th>
              <th class="py-3 px-4 text-left">Artist</th>
              <th class="py-3 px-4 text-center">Popularity</th>
              <th class="py-3 px-4 text-center">Total Plays</th>
              <th class="py-3 px-4 text-right rounded-tr-lg">Duration</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="(song, index) in songs"
              :key="song.id || index"
              class="border-b border-gray-800 hover:bg-gray-900/50 transition-colors"
            >
              <td class="py-4 px-4 text-purple-400 font-bold">
                {{ index + 1 }}
              </td>
              <td class="py-4 px-4">
                <div class="flex items-center gap-3">
                  <img
                    :src="
                      song.cover ||
                      song.image ||
                      'https://via.placeholder.com/50'
                    "
                    :alt="song.title || 'Song Cover'"
                    class="w-10 h-10 rounded-md object-cover"
                    @error="handleImageError"
                  />
                  <span class="font-medium">{{
                    song.title || "Unknown Title"
                  }}</span>
                </div>
              </td>
              <td class="py-4 px-4 text-blue-400">
                {{ song.artist || "Unknown Artist" }}
              </td>
              <td class="py-4 px-4 text-center">
                <div class="flex items-center justify-center">
                  <span class="w-8">{{ song.popularity || 0 }}</span>
                  <span class="text-gray-400 ml-1">%</span>
                </div>
              </td>
              <td class="py-4 px-4 text-center text-green-400">
                {{ song.totalPlays || "0" }}
              </td>
              <td class="py-4 px-4 text-right text-gray-400">
                {{ song.duration || "--:--" }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { toRefs, ref, watch } from "vue";
import VueApexCharts from "vue3-apexcharts";

interface Song {
  id?: number;
  title: string;
  artist: string;
  popularity: number;
  cover?: string;
  image?: string;
  duration?: string;
  plays?: number[];
  totalPlays?: string;
  album?: string;
  releaseDate?: string;
  genre?: string[];
  isExplicit?: boolean;
  lyrics?: boolean;
}

const props = defineProps<{
  songs: Song[];
}>();

const { songs } = toRefs(props);

// Get top 3 songs by totalPlays
const topSongs = ref<Song[]>([]);
const getTopSongs = (songs: Song[]) => {
  if (!songs || !Array.isArray(songs)) return [];

  // Convert totalPlays to numbers and sort
  return [...songs]
    .map((song) => ({
      ...song,
      totalPlaysNum:
        parseFloat(song.totalPlays?.replace("M", "") || "0") * 1_000_000,
    }))
    .sort((a, b) => b.totalPlaysNum - a.totalPlaysNum)
    .slice(0, 3); // Take top 3
};

// Simulate popularity trends for each song (January to July), constrained by initial popularity
const generateTrends = (
  basePopularity: number,
  maxPopularity: number = 100
) => {
  // Simulate a smoother trend with a smaller range, not exceeding maxPopularity or basePopularity
  const fluctuation = 10; // Limit fluctuation to ±10%
  return [
    basePopularity - fluctuation, // January
    basePopularity - fluctuation / 2, // February
    basePopularity + fluctuation / 2, // March
    basePopularity + fluctuation, // April (peak)
    basePopularity, // May
    basePopularity - fluctuation / 2, // June
    basePopularity - fluctuation, // July
  ].map((val) => Math.max(0, Math.min(maxPopularity, val))); // Constrain between 0 and maxPopularity
};

// Chart configuration
const chartOptions = ref({
  chart: {
    id: "song-popularity",
    height: 350,
    type: "line",
    animations: {
      enabled: true,
      easing: "linear",
      dynamicAnimation: {
        speed: 1000,
      },
    },
    toolbar: { show: false },
    zoom: { enabled: false },
    background: "#1E293B",
    foreColor: "#FFFFFF",
  },
  dataLabels: { enabled: false },
  stroke: {
    curve: "smooth",
    width: 2,
  },
  colors: ["#3B82F6", "#10B981", "#F59E0B"], // Blue, Green, Yellow
  xaxis: {
    categories: [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
    ],
    labels: { style: { colors: "#9CA3AF" } },
    axisBorder: { show: true, color: "#374151" },
    axisTicks: { show: true, color: "#374151" },
  },
  yaxis: {
    labels: {
      style: { colors: "#9CA3AF" },
      formatter: (val: number) => `${val.toFixed(0)}%`,
    },
    min: 50, // Adjusted to fit the data range
    max: 100, // Maximum popularity
  },
  grid: { borderColor: "#374151", strokeDashArray: 4 },
  tooltip: { theme: "dark" },
  legend: {
    position: "top",
    horizontalAlign: "right",
    labels: { colors: "#FFFFFF" },
  },
});

const chartSeries = ref([]);

// Update chart data for top 3 songs
const updateChartData = (songs: Song[]) => {
  if (!songs || !Array.isArray(songs)) {
    console.warn("Invalid songs data for chart update:", songs);
    return;
  }

  // Get top 3 songs
  topSongs.value = getTopSongs(songs);

  // Generate trends for each song, using initial popularity as the base
  chartSeries.value = topSongs.value.map((song, index) => ({
    name: song.title,
    data: generateTrends(song.popularity || 0),
  }));
};

// Watch for songs changes
watch(
  () => songs.value,
  (newSongs) => {
    if (newSongs && Array.isArray(newSongs)) updateChartData(newSongs);
    else console.warn("Songs data is invalid or empty:", newSongs);
  },
  { immediate: true }
);

const refreshChart = () => {
  if (songs.value && Array.isArray(songs.value)) updateChartData(songs.value);
  else console.warn("Cannot refresh chart: No valid songs data");
};

const handleImageError = (event: Event) => {
  (event.target as HTMLImageElement).src = "https://via.placeholder.com/50";
};
</script>

<style scoped>
.chart-container {
  margin-top: 1rem;
}
.chart-wrapper {
  position: relative;
  min-height: 350px;
}
.see-all-btn {
  background: rgba(255, 255, 255, 0.1);
  padding: 0.5rem 1rem;
  border-radius: 6px;
  transition: all 0.3s ease;
}
.see-all-btn:hover {
  background: rgba(255, 255, 255, 0.2);
}
table {
  border-collapse: separate;
  border-spacing: 0;
  width: 100%;
}
th {
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  font-size: 0.75rem;
  color: #9ca3af;
}
td {
  padding: 12px 16px;
}
tr:last-child {
  border-bottom: none;
}
@media (max-width: 768px) {
  .chart-wrapper {
    min-width: 100%;
    overflow-x: auto;
  }
  td,
  th {
    padding: 8px 12px;
  }
}
</style>

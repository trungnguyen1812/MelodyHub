<template>
  <div class="main">
      <div class="fixed-section">
          <div class="headerContent"></div>
          <section class="mainContent">
              <div class="cards-container">
                  <div class="card">
                      <p class="time-text"><span>1001</span><span class="time-sub-text">PARTNER</span></p>
                      <p class="day-text">Wednesday, June 15th</p>
                      <img src="@/assets/images/icon/deal.png" alt="Partner" width="30" height="30" class="moon">
                  </div>
                  <div class="card1">
                      <p class="time-text"><span>1201</span><span class="time-sub-text">USER</span></p>
                      <p class="day-text">Wednesday, June 15th</p>
                      <img src="@/assets/images/icon/customer.svg" alt="Customer" width="30" height="30" class="moon">
                  </div>
                  <div class="card2">
                      <p class="time-text"><span>1.5M</span><span class="time-sub-text">DOLLAR</span></p>
                      <p class="day-text">Wednesday, June 15th</p>
                      <img src="@/assets/images/icon/dolla.svg" alt="Dollar" width="30" height="30" class="moon">
                  </div>
              </div> 
          </section>
          <section class="chart-section">
              <div class="chart-container">
                  <div class="chart">
                      <VueApexCharts 
                          type="line" 
                          height="350" 
                          :options="chartOptions" 
                          :series="series"
                      />
                  </div> 
                  <div class="listCustomer">
                      <div class="customer-fixed-container">
                          <h3>Recent Partners</h3>
                          <div class="customer-list">
                              <div v-for="item in 5" :key="item" class="customer-item">
                                  <div class="customer-avatar">
                                      <span>C{{ item }}</span>
                                  </div>
                                  <div class="customer-details">
                                      <div class="customer-info">
                                          <span class="customer-name">Customer {{ item }}</span>
                                          <span class="customer-amount">${{ (item * 100).toLocaleString() }}</span>
                                      </div>
                                      <div class="customer-date">Today, 10:3{item} AM</div>
                                  </div>
                              </div>
                          </div>
                      </div>
                  </div>
              </div> 
          </section>
      </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import type { ApexOptions } from 'apexcharts';


const series = ref([
  {
    name: 'TEAM A',
    type: 'column' as const,
    data: [23, 11, 22, 27, 13, 22, 37, 21, 44, 22, 30]
  }, 
  {
    name: 'TEAM B',
    type: 'area' as const,
    data: [44, 55, 41, 67, 22, 43, 21, 41, 56, 27, 43]
  }, 
  {
    name: 'TEAM C',
    type: 'line' as const,
    data: [30, 25, 36, 30, 45, 35, 64, 52, 59, 36, 39]
  }
])

const chartOptions = ref<ApexOptions>({
  chart: {
    height: 350,
    type: 'line',
    stacked: false,
    toolbar: {
      show: false
    }
  },
  colors: ['#4CAF50', '#2196F3', '#FF9800'],
  stroke: {
    width: [0, 2, 5],
    curve: 'smooth'
  },
  plotOptions: {
    bar: {
      columnWidth: '50%',
      borderRadius: 5
    }
  },
  fill: {
    opacity: [0.85, 0.25, 1],
    gradient: {
      inverseColors: false,
      shade: 'light',
      type: "vertical",
      opacityFrom: 0.85,
      opacityTo: 0.55,
      stops: [0, 100, 100, 100]
    }
  },
  labels: [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'
  ],
  markers: {
    size: 0
  },
  xaxis: {
    labels: {
      style: {
        colors: '#fff'
      }
    }
  },
  yaxis: {
    title: {
      text: 'Points',
      style: {
        color: '#fff'
      }
    },
    labels: {
      style: {
        colors: '#fff'
      }
    }
  },
  tooltip: {
    theme: 'dark',
    shared: true,
    intersect: false,
    y: {
      formatter: function(val: number) {
        if (val !== undefined) {
          return val.toFixed(0) + " points";
        }
        return val;
      }
    }
  },
  legend: {
    labels: {
      colors: '#fff'
    }
  },
  grid: {
    borderColor: 'rgba(255, 255, 255, 0.1)'
  }
})

onMounted(() => {
  const token = localStorage.getItem("admin_token");
  console.log("admin_token (dashboard):", token);
});
</script>

<style scoped>
.main {
    height: 82vh;
    width: 100%;
    border-radius: 14px;
    margin: 12px 0px;
    background: rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(10px);
    display: flex;
    flex-direction: column;
    padding: 20px;
    position: relative;
    overflow: hidden;
    font-family: 'Afacad', sans-serif;
    color: white;
}

.fixed-section {
    height: 100%;
    display: flex;
    flex-direction: column;
    gap: 30px;
    overflow-y: auto;
    padding-right: 10px;
}

/* Custom scrollbar cho toàn bộ section */
.fixed-section::-webkit-scrollbar {
    width: 8px;
}

.fixed-section::-webkit-scrollbar-track {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 4px;
}

.fixed-section::-webkit-scrollbar-thumb {
    background: rgba(255, 255, 255, 0.2);
    border-radius: 4px;
}

.fixed-section::-webkit-scrollbar-thumb:hover {
    background: rgba(255, 255, 255, 0.3);
}

/* Cards container */
.cards-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 20px;
    margin-bottom: 10px;
}

/* Common card styles */
.card, .card1, .card2 {
    width: 100%;
    min-height: 150px;
    border-radius: 15px;
    display: flex;
    color: white;
    justify-content: center;
    position: relative;
    flex-direction: column;
    cursor: pointer;
    transition: all 0.3s ease-in-out;
    overflow: hidden;
    padding: 20px;
    box-sizing: border-box;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
}

.card {
    background: linear-gradient(135deg, #1a237e, #283593);
}

.card1 {
    background: linear-gradient(135deg, #880e4f, #ad1457);
}

.card2 {
    background: linear-gradient(135deg, #ff6f00, #ff9800);
}

.card:hover, .card1:hover, .card2:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
}

.time-text {
    font-size: 42px;
    margin: 0;
    font-weight: 700;
    font-family: 'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif;
    display: flex;
    align-items: baseline;
    gap: 8px;
}

.time-sub-text {
    font-size: 14px;
    font-weight: 500;
    opacity: 0.9;
}

.day-text {
    font-size: 14px;
    margin: 8px 0 0 0;
    font-weight: 400;
    opacity: 0.8;
}

.moon {
    position: absolute;
    right: 20px;
    top: 20px;
    width: 30px;
    height: 30px;
    filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
    transition: transform 0.3s ease-in-out;
}

.card:hover .moon,
.card1:hover .moon,
.card2:hover .moon {
    transform: scale(1.1) rotate(5deg);
}

/* Chart section */
.chart-section {
    flex: 1;
    display: flex;
    flex-direction: column;
}

.chart-container {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 20px;
    height: 100%;
    min-height: 400px;
}

.chart {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    padding: 20px;
    display: flex;
    flex-direction: column;
}

/* Customer list - FIXED with scroll */
.listCustomer {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    padding: 0;
    display: flex;
    flex-direction: column;
    overflow: hidden;
    position: relative;
}

.customer-fixed-container {
    display: flex;
    flex-direction: column;
    height: 100%;
    max-height: 100%;
    overflow: hidden;
}

.customer-fixed-container h3 {
    margin: 0;
    padding: 20px 20px 15px 20px;
    font-size: 18px;
    font-weight: 600;
    color: white;
    background: rgba(255, 255, 255, 0.05);
    position: sticky;
    top: 0;
    z-index: 10;
}

.customer-list {
    flex: 1;
    overflow-y: auto;
    padding: 0 20px 20px 20px;
    height: calc(100% - 60px); /* Trừ chiều cao của header */
}

/* Custom scrollbar cho customer list */
.customer-list::-webkit-scrollbar {
    width: 6px;
}

.customer-list::-webkit-scrollbar-track {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 3px;
    margin: 5px 0;
}

.customer-list::-webkit-scrollbar-thumb {
    background: rgba(255, 255, 255, 0.15);
    border-radius: 3px;
}

.customer-list::-webkit-scrollbar-thumb:hover {
    background: rgba(255, 255, 255, 0.25);
}

/* Customer item styles */
.customer-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px;
    border-radius: 10px;
    margin-bottom: 8px;
    background: rgba(255, 255, 255, 0.03);
    transition: all 0.3s ease;
    border: 1px solid transparent;
}

.customer-item:hover {
    background: rgba(255, 255, 255, 0.08);
    border-color: rgba(255, 255, 255, 0.1);
    transform: translateX(5px);
}

.customer-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: linear-gradient(135deg, #667eea, #764ba2);
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    font-size: 14px;
    color: white;
    flex-shrink: 0;
}

.customer-details {
    flex: 1;
    min-width: 0; /* Để text không bị tràn */
}

.customer-info {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 4px;
}

.customer-name {
    font-weight: 500;
    font-size: 14px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.customer-amount {
    font-weight: 600;
    color: #4CAF50;
    font-size: 14px;
}

.customer-date {
    font-size: 12px;
    opacity: 0.7;
}

/* Responsive */
@media (max-width: 1024px) {
    .chart-container {
        grid-template-columns: 1fr;
        grid-template-rows: 400px auto;
        gap: 15px;
    }
    
    .chart {
        height: 400px;
    }
    
    .listCustomer {
        height: 350px;
    }
    
    .customer-list {
        height: calc(100% - 55px);
    }
}

@media (max-width: 768px) {
    .cards-container {
        grid-template-columns: 1fr;
    }
    
    .time-text {
        font-size: 36px;
    }
    
    .chart-container {
        grid-template-rows: 350px auto;
    }
    
    .chart {
        height: 350px;
    }
}

@media (max-width: 480px) {
    .main {
        padding: 15px;
    }
    
    .card, .card1, .card2 {
        padding: 15px;
    }
    
    .time-text {
        font-size: 32px;
    }
    
    .customer-item {
        padding: 10px;
    }
    
    .customer-avatar {
        width: 35px;
        height: 35px;
        font-size: 13px;
    }
}
</style>
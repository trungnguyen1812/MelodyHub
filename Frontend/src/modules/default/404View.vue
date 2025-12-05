<template>
  <div 
    ref="container"
    class="error-404"
  >
    <!-- Animated background particles -->
    <div class="particles">
      <div 
        v-for="i in 50" 
        :key="i"
        class="particle"
        :style="getParticleStyle(i)"
      />
    </div>

    <div class="content" :style="get3DTransform">
      <!-- 3D Number 404 -->
      <div class="number-container">
        <h1 class="number-main">404</h1>
        <h1 class="number-shadow shadow-1">404</h1>
        <h1 class="number-shadow shadow-2">404</h1>
      </div>

      <!-- Content -->
      <div class="text-content">
        <h2 class="title">
          <svg class="icon bounce" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="11" cy="11" r="8"/>
            <path d="m21 21-4.35-4.35"/>
          </svg>
          Page not found
        </h2>
        <p class="description">
          Sorry, the page you are looking for does not exist or has been moved.
        </p>
      </div>

      <!-- Buttons -->
      <div class="buttons">
        <button @click="goBack" class="btn btn-primary">
          <svg class="icon-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M19 12H5M12 19l-7-7 7-7"/>
          </svg>
          Quay lại
        </button>
        <button @click="goHome" class="btn btn-secondary">
          <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
            <polyline points="9 22 9 12 15 12 15 22"/>
          </svg>
          Trang chủ
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Error404',
  data() {
    return {
      mouseX: 0,
      mouseY: 0,
      rotationX: 0,
      rotationY: 0
    }
  },
  computed: {
    get3DTransform() {
      return {
        transform: `perspective(1000px) rotateX(${this.rotationX}deg) rotateY(${this.rotationY}deg)`,
        transition: 'transform 0.1s ease-out'
      }
    }
  },
  mounted() {
    window.addEventListener('mousemove', this.handleMouseMove)
  },
  beforeUnmount() {
    window.removeEventListener('mousemove', this.handleMouseMove)
  },
  methods: {
    handleMouseMove(e) {
      if (this.$refs.container) {
        const rect = this.$refs.container.getBoundingClientRect()
        const centerX = rect.left + rect.width / 2
        const centerY = rect.top + rect.height / 2
        
        this.mouseX = (e.clientX - centerX) / 20
        this.mouseY = (e.clientY - centerY) / 20
        
        this.rotationX = -this.mouseY
        this.rotationY = this.mouseX
      }
    },
    getParticleStyle(i) {
      return {
        width: Math.random() * 4 + 1 + 'px',
        height: Math.random() * 4 + 1 + 'px',
        left: Math.random() * 100 + '%',
        top: Math.random() * 100 + '%',
        animationDuration: Math.random() * 10 + 10 + 's',
        animationDelay: Math.random() * 5 + 's'
      }
    },
    goBack() {
      this.$router ? this.$router.go(-1) : window.history.back()
    },
    goHome() {
      this.$router ? this.$router.push('/') : window.location.href = '/'
    }
  }
}
</script>

<style scoped>
.error-404 {
  min-height: 100vh;
  background: linear-gradient(135deg, #4a148c 0%, #1a237e 50%, #311b92 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
  overflow: hidden;
  position: relative;
}

.particles {
  position: absolute;
  inset: 0;
  overflow: hidden;
  pointer-events: none;
}

.particle {
  position: absolute;
  border-radius: 50%;
  background: white;
  opacity: 0.2;
  animation: float ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0) translateX(0); }
  25% { transform: translateY(-20px) translateX(10px); }
  50% { transform: translateY(-40px) translateX(-10px); }
  75% { transform: translateY(-20px) translateX(5px); }
}

@keyframes pulse-glow {
  0%, 100% { box-shadow: 0 0 20px rgba(139, 92, 246, 0.5); }
  50% { box-shadow: 0 0 40px rgba(139, 92, 246, 0.8), 0 0 60px rgba(139, 92, 246, 0.4); }
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

.content {
  position: relative;
  z-index: 10;
  text-align: center;
}

.number-container {
  position: relative;
  margin-bottom: 2rem;
  user-select: none;
}

.number-main {
  font-size: 12rem;
  font-weight: bold;
  background: linear-gradient(135deg, #a78bfa 0%, #ec4899 50%, #60a5fa 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: 0 0 30px rgba(168, 85, 247, 0.5), 0 10px 40px rgba(0,0,0,0.5);
  margin: 0;
  line-height: 1;
}

.number-shadow {
  position: absolute;
  top: 0;
  left: 0;
  font-size: 12rem;
  font-weight: bold;
  margin: 0;
  line-height: 1;
}

.shadow-1 {
  color: #7c3aed;
  opacity: 0.3;
  transform: translate(8px, 8px);
  filter: blur(3px);
  z-index: -1;
}

.shadow-2 {
  color: #2563eb;
  opacity: 0.2;
  transform: translate(16px, 16px);
  filter: blur(6px);
  z-index: -2;
}

.text-content {
  margin-bottom: 2rem;
}

.title {
  font-size: 2.5rem;
  font-weight: bold;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  margin: 0 0 1rem 0;
}

.icon {
  width: 2rem;
  height: 2rem;
}

.bounce {
  animation: bounce 2s ease-in-out infinite;
}

.description {
  color: #d1d5db;
  font-size: 1.125rem;
  max-width: 28rem;
  margin: 0 auto;
  line-height: 1.6;
}

.buttons {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  align-items: center;
}

.btn {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 1rem 2rem;
  border: none;
  border-radius: 9999px;
  font-weight: 600;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3);
}

.btn-primary {
  background: linear-gradient(135deg, #9333ea 0%, #ec4899 100%);
  color: white;
  animation: pulse-glow 2s ease-in-out infinite;
}

.btn-primary:hover {
  transform: scale(1.05);
}

.btn-primary .icon-arrow {
  width: 1.25rem;
  height: 1.25rem;
  transition: transform 0.3s ease;
}

.btn-primary:hover .icon-arrow {
  transform: translateX(-4px);
}

.btn-secondary {
  background: white;
  color: #4a148c;
}

.btn-secondary:hover {
  transform: scale(1.05);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
}

.btn .icon {
  width: 1.25rem;
  height: 1.25rem;
}

@media (min-width: 768px) {
  .number-main, .shadow-1, .shadow-2 {
    font-size: 15rem;
  }
  
  .title {
    font-size: 3rem;
  }
  
  .buttons {
    flex-direction: row;
  }
}

@media (max-width: 640px) {
  .number-main, .shadow-1, .shadow-2 {
    font-size: 8rem;
  }
  
  .title {
    font-size: 2rem;
  }
}
</style>
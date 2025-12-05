<template>
  <div 
    ref="container"
    class="error-403"
  >
    <!-- Animated background -->
    <div class="bg-orbs">
      <div class="orb orb-1"></div>
      <div class="orb orb-2"></div>
      <div class="orb orb-3"></div>
    </div>

    <div class="content">
      <!-- 3D Lock Icon -->
      <div 
        class="lock-container"
        :style="get3DTransform"
      >
        <div class="lock-box">
          <svg class="lock-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
          </svg>
        </div>
        <div class="lock-shadow shadow-1"></div>
        <div class="lock-shadow shadow-2"></div>
      </div>

      <!-- 3D Number 403 -->
      <div 
        class="number-container"
        :style="get3DTransformHalf"
      >
        <h1 class="number-main">403</h1>
      </div>

      <!-- Content -->
      <div class="text-content">
        <h2 class="title">Access denied</h2>
        <p class="description">
          You do not have permission to access this page. Please contact the administrator if you believe this is an error.
        </p>
      </div>

      <!-- Buttons -->
      <div class="buttons">
        <button @click="goBack" class="btn btn-primary">
          <svg class="icon-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M19 12H5M12 19l-7-7 7-7"/>
          </svg>
          Come back
        </button>
        <button @click="goHome" class="btn btn-secondary">
          <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
            <polyline points="9 22 9 12 15 12 15 22"/>
          </svg>
          Home
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Error403',
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
    },
    get3DTransformHalf() {
      return {
        transform: `perspective(1000px) rotateX(${this.rotationX * 0.5}deg) rotateY(${this.rotationY * 0.5}deg)`,
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
.error-403 {
  min-height: 100vh;
  background: linear-gradient(135deg, #7f1d1d 0%, #9a3412 50%, #a16207 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
  overflow: hidden;
  position: relative;
}

.bg-orbs {
  position: absolute;
  inset: 0;
  opacity: 0.2;
}

.orb {
  position: absolute;
  border-radius: 50%;
  mix-blend-mode: multiply;
  filter: blur(80px);
  animation: pulse 4s ease-in-out infinite;
}

.orb-1 {
  top: 5rem;
  left: 5rem;
  width: 18rem;
  height: 18rem;
  background: #ef4444;
  animation-delay: 0s;
}

.orb-2 {
  bottom: 5rem;
  right: 5rem;
  width: 18rem;
  height: 18rem;
  background: #f97316;
  animation-delay: 1s;
}

.orb-3 {
  top: 10rem;
  right: 10rem;
  width: 18rem;
  height: 18rem;
  background: #eab308;
  animation-delay: 2s;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); opacity: 0.2; }
  50% { transform: scale(1.1); opacity: 0.3; }
}

@keyframes lock-shake {
  0%, 100% { transform: rotate(0deg); }
  25% { transform: rotate(-10deg); }
  75% { transform: rotate(10deg); }
}

@keyframes border-glow {
  0%, 100% { box-shadow: 0 0 20px rgba(239, 68, 68, 0.5); }
  50% { box-shadow: 0 0 40px rgba(239, 68, 68, 0.8), 0 0 60px rgba(239, 68, 68, 0.4); }
}

.content {
  position: relative;
  z-index: 10;
  text-align: center;
}

.lock-container {
  margin-bottom: 2rem;
  display: flex;
  justify-content: center;
  position: relative;
}

.lock-box {
  width: 12rem;
  height: 12rem;
  background: linear-gradient(135deg, #ef4444 0%, #f97316 100%);
  border-radius: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5);
  animation: border-glow 2s ease-in-out infinite;
  position: relative;
  z-index: 3;
}

.lock-icon {
  width: 6rem;
  height: 6rem;
  color: white;
  animation: lock-shake 0.5s ease-in-out infinite;
}

.lock-shadow {
  position: absolute;
  width: 12rem;
  height: 12rem;
  border-radius: 1.5rem;
}

.shadow-1 {
  background: #b91c1c;
  opacity: 0.5;
  transform: translate(12px, 12px);
  filter: blur(8px);
  z-index: 2;
}

.shadow-2 {
  background: #c2410c;
  opacity: 0.3;
  transform: translate(24px, 24px);
  filter: blur(16px);
  z-index: 1;
}

.number-container {
  margin-bottom: 1.5rem;
}

.number-main {
  font-size: 8rem;
  font-weight: bold;
  background: linear-gradient(135deg, #f87171 0%, #fb923c 50%, #fbbf24 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-shadow: 0 0 30px rgba(239, 68, 68, 0.5);
  margin: 0;
  line-height: 1;
}

.text-content {
  margin-bottom: 2rem;
}

.title {
  font-size: 2.5rem;
  font-weight: bold;
  color: white;
  margin: 0 0 1rem 0;
}

.description {
  color: #fecaca;
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
  background: linear-gradient(135deg, #dc2626 0%, #f97316 100%);
  color: white;
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
  color: #7f1d1d;
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
  .number-main {
    font-size: 10rem;
  }
  
  .title {
    font-size: 3rem;
  }
  
  .buttons {
    flex-direction: row;
  }
}

@media (max-width: 640px) {
  .lock-box, .shadow-1, .shadow-2 {
    width: 10rem;
    height: 10rem;
  }
  
  .lock-icon {
    width: 5rem;
    height: 5rem;
  }
  
  .number-main {
    font-size: 6rem;
  }
  
  .title {
    font-size: 2rem;
  }
}
</style>
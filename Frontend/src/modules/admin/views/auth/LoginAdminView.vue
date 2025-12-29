<template>
    <!-- Animated background particles -->
    <div class="particles">
      <div class="particle" v-for="i in 50" :key="i" :style="particleStyle(i)"></div>
    </div>

    <!-- Floating music notes -->
    <div class="music-notes">
      <span class="note" v-for="i in 5" :key="i">♪</span>
    </div>

    <div class="vinyl-form-wrapper">
      <!-- Animated vinyl record -->
      <div class="vinyl-container">
        <div class="vinyl">
          <div class="vinyl-groove" v-for="i in 8" :key="i"></div>
          <div class="vinyl-label">
            <span class="label-text">MELODY</span>
          </div>
        </div>
        <div class="vinyl-shadow"></div>
      </div>

      <!-- OTP form with glass morphism -->
      <form class="form" @submit.prevent="handleVerification">
        <div class="form-glow"></div>
        
        <!-- Success overlay -->
        <div v-if="isSuccess" class="success-overlay">
          <div class="success-content">
            <svg class="success-icon" viewBox="0 0 24 24" fill="none">
              <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
              <path d="M8 12l2 2 4-4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            </svg>
            <p class="success-text">Verification successful!</p>
          </div>
        </div>
        
        <img
          class="logo"
          src="@/assets/images/logo/melody-high-resolution-logo-white.png"
          alt="Logo"
        />
        
        <h2 class="title">OTP Verification</h2>
        
        <p class="subtitle">
          Enter the 6-digit code that was sent to you.<br />
          <span class="email-highlight">{{ email || 'email@example.com' }}</span>
        </p>

        <!-- OTP Input -->
        <div class="otp-container">
          <input
            v-for="(digit, index) in otp"
            :key="index"
            :ref="el => inputRefs[index] = el"
            type="text"
            inputmode="numeric"
            maxlength="1"
            :value="digit"
            @input="handleInput(index, $event)"
            @keydown="handleKeyDown(index, $event)"
            @paste="handlePaste"
            :class="['otp-input', { 
              'otp-filled': digit, 
              'otp-error': errors.otp,
              'otp-success': isSuccess
            }]"
          />
        </div>

        <span v-if="errors.otp" class="error-message otp-error-msg">
          <svg viewBox="0 0 24 24" fill="none" class="error-icon">
            <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
            <line x1="12" y1="8" x2="12" y2="12" stroke="currentColor" stroke-width="2"/>
            <circle cx="12" cy="16" r="1" fill="currentColor"/>
          </svg>
          {{ errors.otp }}
        </span>

        <span v-if="errors.general" class="error-message general-error">
          <svg viewBox="0 0 24 24" fill="none" class="error-icon">
            <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2"/>
            <line x1="12" y1="8" x2="12" y2="12" stroke="currentColor" stroke-width="2"/>
            <circle cx="12" cy="16" r="1" fill="currentColor"/>
          </svg>
          {{ errors.general }}
        </span>

        <button class="submit btn" type="submit" :disabled="isLoading || otp.join('').length !== 6">
          <span class="btn-content">
            <template v-if="isLoading">
              <span class="spinner"></span>
              <span>Verification in progress...</span>
            </template>
            <template v-else>
              <span>Authentication</span>
              <svg class="arrow" viewBox="0 0 24 24" fill="none">
                <path d="M5 12h14M12 5l7 7-7 7" stroke="currentColor" stroke-width="2"/>
              </svg>
            </template>
          </span>
        </button>

        <div class="form-footer">
          <p class="resend-text">Did not receive the code.?</p>
          <button 
            type="button" 
            class="resend-link" 
            @click="handleResend"
            :disabled="isLoading"
          >
            Resend OTP code
          </button>
        </div>

        <p class="expire-text">The OTP code will expire in 5 minutes.</p>
      </form>
    </div>
</template>

<script setup lang="ts">
import { ref, onMounted, nextTick , computed} from "vue";
import { useRouter } from "vue-router";
import {useAuthStore} from '@/store/authStore';

const router = useRouter();
const email  = ref("");

const otp = ref(['', '', '', '', '', '']);


const inputRefs = ref<(HTMLInputElement | null)[]>([]);
const errors = ref({
  otp: "",
  general: "",
});
const isLoading = ref(false);
const isSuccess = ref(false);

onMounted(() => {
  const rawUser = localStorage.getItem('auth_user')
  if (rawUser) {
    email.value = JSON.parse(rawUser).email
  }
  // Focus first input
  nextTick(() => {
    inputRefs.value[0]?.focus();
  });
});

const particleStyle = (i: number) => {
  const randomX = Math.random() * 100;
  const randomY = Math.random() * 100;
  const randomDelay = Math.random() * 5;
  const randomDuration = 3 + Math.random() * 4;
  
  return {
    left: `${randomX}%`,
    top: `${randomY}%`,
    animationDelay: `${randomDelay}s`,
    animationDuration: `${randomDuration}s`,
  };
};

const handleInput = (index: number, event: Event) => {
  const target = event.target as HTMLInputElement;
  const value = target.value;
  
  // Only allow digits
  if (!/^\d*$/.test(value)) {
    target.value = otp.value[index];
    return;
  }

  const newOtp = [...otp.value];
  newOtp[index] = value.slice(-1);
  otp.value = newOtp;
  
  errors.value.otp = "";
  errors.value.general = "";

  // Move to next input
  if (value && index < 5) {
    inputRefs.value[index + 1]?.focus();
  }
};

const handleKeyDown = (index: number, event: KeyboardEvent) => {
  if (event.key === 'Backspace' && !otp.value[index] && index > 0) {
    inputRefs.value[index - 1]?.focus();
  } else if (event.key === 'ArrowLeft' && index > 0) {
    inputRefs.value[index - 1]?.focus();
  } else if (event.key === 'ArrowRight' && index < 5) {
    inputRefs.value[index + 1]?.focus();
  }
};

const handlePaste = (event: ClipboardEvent) => {
  event.preventDefault();
  const pastedData = event.clipboardData?.getData('text').slice(0, 6) || '';
  
  if (!/^\d+$/.test(pastedData)) return;

  const newOtp = [...otp.value];
  pastedData.split('').forEach((char, index) => {
    if (index < 6) newOtp[index] = char;
  });
  otp.value = newOtp;
  
  const nextEmptyIndex = newOtp.findIndex(val => !val);
  if (nextEmptyIndex !== -1) {
    inputRefs.value[nextEmptyIndex]?.focus();
  } else {
    inputRefs.value[5]?.focus();
  }
};

const handleVerification = async () => {
  const auth = useAuthStore();
  const otpCode = otp.value.join('');

  if (otpCode.length !== 6) {
    errors.value.otp = 'Please enter all 6 numbers.';
    return;
  }

  isLoading.value = true;

  const result = await auth.verificationOTP(email.value, otpCode);

  if (!result.success) {
    errors.value.general = result.message || 'Invalid OTP';
    isLoading.value = false;
    return;
  }
  isSuccess.value = true;

  setTimeout(() => {
    router.push({ name: 'admin.dashboard' });
  }, 500);
};


const handleResend = async () => {
  try {
    otp.value = ['', '', '', '', '', ''];
    errors.value.otp = "";
    errors.value.general = "";
    inputRefs.value[0]?.focus();
    
    // Call your resend API here
    // Example: await api.post('/resend-otp', { email: email.value });
    
    console.log('Resending OTP...');
  } catch (error: any) {
    errors.value.general = error.response?.data?.message || "Unable to resend the code. Please try again.";
  }
};
</script>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

::selection {
  background-color: #00bfff55;
  color: #fff;
}

/* Animated particles */
.particles {
  position: absolute;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 1;
}

.particle {
  position: absolute;
  width: 3px;
  height: 3px;
  background: #00ffff;
  border-radius: 50%;
  opacity: 0;
  animation: float 7s infinite ease-in-out;
  box-shadow: 0 0 10px #00ffff;
}

@keyframes float {
  0%, 100% {
    opacity: 0;
    transform: translateY(0) scale(0);
  }
  50% {
    opacity: 0.8;
    transform: translateY(-100px) scale(1);
  }
}

/* Floating music notes */
.music-notes {
  position: absolute;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 1;
}

.note {
  position: absolute;
  font-size: 2rem;
  color: #00ffff;
  opacity: 0;
  animation: noteFloat 8s infinite ease-in-out;
}

.note:nth-child(1) { left: 10%; animation-delay: 0s; }
.note:nth-child(2) { left: 30%; animation-delay: 1.5s; }
.note:nth-child(3) { left: 50%; animation-delay: 3s; }
.note:nth-child(4) { left: 70%; animation-delay: 4.5s; }
.note:nth-child(5) { left: 90%; animation-delay: 6s; }

@keyframes noteFloat {
  0% {
    bottom: -50px;
    opacity: 0;
    transform: translateX(0) rotate(0deg);
  }
  50% {
    opacity: 0.6;
  }
  100% {
    bottom: 110%;
    opacity: 0;
    transform: translateX(100px) rotate(360deg);
  }
}

.vinyl-form-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0;
  position: relative;
  z-index: 10;
}

/* Vinyl container with animation */
.vinyl-container {
  position: relative;
  margin-right: -180px;
  z-index: 5;
}

.vinyl {
  width: 320px;
  height: 320px;
  background: radial-gradient(circle at 30% 30%, #1a1a1a, #000000);
  border-radius: 50%;
  position: relative;
  animation: spin 8s linear infinite;
  box-shadow: 
    0 0 30px rgba(0, 191, 255, 0.3),
    inset 0 0 50px rgba(0, 0, 0, 0.8);
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.vinyl-groove {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  border-radius: 50%;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.vinyl-groove:nth-child(1) { width: 90%; height: 90%; }
.vinyl-groove:nth-child(2) { width: 80%; height: 80%; }
.vinyl-groove:nth-child(3) { width: 70%; height: 70%; }
.vinyl-groove:nth-child(4) { width: 60%; height: 60%; }
.vinyl-groove:nth-child(5) { width: 50%; height: 50%; }
.vinyl-groove:nth-child(6) { width: 40%; height: 40%; }
.vinyl-groove:nth-child(7) { width: 30%; height: 30%; }
.vinyl-groove:nth-child(8) { width: 20%; height: 20%; }

.vinyl-label {
  position: absolute;
  top: 50%;
  left: 50%;
  width: 100px;
  height: 100px;
  background: linear-gradient(135deg, #00bfff, #00ffff);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 0 20px rgba(0, 255, 255, 0.5);
}

.label-text {
  font-weight: bold;
  font-size: 0.9rem;
  color: #000;
  letter-spacing: 2px;
}

.vinyl-shadow {
  position: absolute;
  bottom: -20px;
  left: 50%;
  transform: translateX(-50%);
  width: 280px;
  height: 40px;
  background: radial-gradient(ellipse, rgba(0, 191, 255, 0.3), transparent);
  border-radius: 50%;
  filter: blur(20px);
}

/* Form with glass morphism */
.form {
  margin-top: 8%;
  width: 450px;
  padding: 3rem 2.5rem;
  background: rgba(10, 15, 30, 0.6);
  backdrop-filter: blur(20px) saturate(180%);
  box-shadow: 
    0 8px 32px rgba(0, 191, 255, 0.2),
    inset 0 0 80px rgba(0, 255, 255, 0.05);
  display: flex;
  flex-direction: column;
  align-items: center;
  border-radius: 24px;
  border: 1px solid rgba(0, 255, 255, 0.2);
  position: relative;
  overflow: hidden;
  z-index: 10;
}

/* Success overlay */
.success-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, #00bfff, #00ffff);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 50;
  animation: fadeIn 0.3s ease-in-out;
}

.success-content {
  text-align: center;
}

.success-icon {
  width: 80px;
  height: 80px;
  color: #000;
  stroke-width: 2;
  margin-bottom: 1rem;
  animation: scaleIn 0.5s ease-out;
}

.success-text {
  color: #000;
  font-size: 1.5rem;
  font-weight: 700;
  letter-spacing: 1px;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes scaleIn {
  from {
    transform: scale(0);
    opacity: 0;
  }
  to {
    transform: scale(1);
    opacity: 1;
  }
}

.form-glow {
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(0, 191, 255, 0.1) 0%, transparent 70%);
  animation: rotate 10s linear infinite;
  pointer-events: none;
}

@keyframes rotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.logo {
  height: 80px;
  margin-bottom: 1rem;
  filter: drop-shadow(0 0 20px rgba(0, 255, 255, 0.5));
  animation: pulse 3s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.05); }
}

.title {
  color: #ffffff;
  font-size: 1.5rem;
  font-weight: 600;
  margin-bottom: 1rem;
  text-transform: uppercase;
  letter-spacing: 3px;
  background: linear-gradient(90deg, #00bfff, #00ffff, #00bfff);
  background-size: 200% auto;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  animation: shimmer 3s linear infinite;
}

@keyframes shimmer {
  to { background-position: 200% center; }
}

.subtitle {
  color: rgba(255, 255, 255, 0.7);
  text-align: center;
  margin-bottom: 2rem;
  font-size: 0.9rem;
  line-height: 1.6;
}

.email-highlight {
  color: #00ffff;
  font-weight: 600;
}

/* OTP Input Container */
.otp-container {
  display: flex;
  gap: 0.75rem;
  justify-content: center;
  margin-bottom: 1.5rem;
  width: 100%;
}

.otp-input {
  width: 3rem;
  height: 3.5rem;
  text-align: center;
  font-size: 1.5rem;
  font-weight: 700;
  color: #ffffff;
  background: rgba(30, 30, 30, 0.6);
  border: 2px solid rgba(0, 255, 255, 0.2);
  border-radius: 12px;
  transition: all 0.3s ease;
  outline: none;
}

.otp-input:focus {
  border-color: #00ffff;
  background: rgba(30, 30, 30, 0.8);
  box-shadow: 
    0 0 20px rgba(0, 255, 255, 0.4),
    inset 0 0 20px rgba(0, 255, 255, 0.05);
  transform: scale(1.05);
}

.otp-filled {
  border-color: #00ffff;
  background: rgba(0, 255, 255, 0.1);
}

.otp-error {
  border-color: #ff4444 !important;
  animation: shake 0.5s;
}

.otp-success {
  border-color: #00ff00;
  background: rgba(0, 255, 0, 0.1);
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
  20%, 40%, 60%, 80% { transform: translateX(5px); }
}

.error-message {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #ff6b6b;
  font-size: 0.85rem;
  animation: slideIn 0.3s;
}

.otp-error-msg {
  margin-bottom: 1rem;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.general-error {
  padding: 0.75rem;
  background: rgba(255, 68, 68, 0.1);
  border: 1px solid rgba(255, 68, 68, 0.3);
  border-radius: 8px;
  margin-bottom: 1rem;
  width: 100%;
}

.error-icon {
  width: 18px;
  height: 18px;
  flex-shrink: 0;
}

.btn {
  margin-top: 0.5rem;
  width: 100%;
  height: 3.5rem;
  background: linear-gradient(135deg, #00bfff 0%, #00ffff 100%);
  color: #000;
  font-weight: 700;
  font-size: 1rem;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: all 0.3s;
  box-shadow: 
    0 4px 15px rgba(0, 191, 255, 0.4),
    0 0 20px rgba(0, 255, 255, 0.2);
}

.btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
  transition: left 0.5s;
}

.btn:hover::before {
  left: 100%;
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: 
    0 6px 25px rgba(0, 191, 255, 0.6),
    0 0 30px rgba(0, 255, 255, 0.3);
}

.btn:active {
  transform: translateY(0);
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
}

.btn-content {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.arrow {
  width: 20px;
  height: 20px;
  transition: transform 0.3s;
}

.btn:hover .arrow {
  transform: translateX(5px);
}

.spinner {
  display: inline-block;
  width: 18px;
  height: 18px;
  border: 2px solid rgba(0, 0, 0, 0.3);
  border-top: 2px solid #000;
  border-radius: 50%;
  animation: spin-loader 0.8s linear infinite;
}

@keyframes spin-loader {
  to { transform: rotate(360deg); }
}

.form-footer {
  margin-top: 1.5rem;
  width: 100%;
  text-align: center;
}

.resend-text {
  color: rgba(255, 255, 255, 0.6);
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
}

.resend-link {
  color: #00ffff;
  background: none;
  border: none;
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  position: relative;
  padding: 0;
}

.resend-link::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 0;
  height: 2px;
  background: #00ffff;
  transition: width 0.3s;
}

.resend-link:hover::after {
  width: 100%;
}

.resend-link:hover {
  text-shadow: 0 0 10px rgba(0, 255, 255, 0.5);
}

.resend-link:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.expire-text {
  color: rgba(255, 255, 255, 0.4);
  font-size: 0.8rem;
  margin-top: 1rem;
  text-align: center;
}

/* Responsive */
@media (max-width: 768px) {
  .vinyl-container {
    display: none;
  }

  .form {
    width: 90%;
    max-width: 400px;
    padding: 2rem 1.5rem;
  }

  .logo {
    height: 60px;
  }

  .title {
    font-size: 1.2rem;
  }

  .otp-input {
    width: 2.5rem;
    height: 3rem;
    font-size: 1.2rem;
  }

  .otp-container {
    gap: 0.5rem;
  }
}

@media (min-width: 769px) and (max-width: 1024px) {
  .vinyl {
    width: 260px;
    height: 260px;
  }

  .vinyl-container {
    margin-right: -140px;
  }

  .form {
    width: 380px;
  }
}
</style>
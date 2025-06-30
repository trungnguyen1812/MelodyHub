<template>
  <div class="container">
    <div class="vinyl-form-wrapper">
      <div class="vinyl"></div>
      <form class="form" @submit.prevent="handleLogin">
        <img
          class="logo"
          src="@/assets/images/logo/melody-high-resolution-logo-white.png"
          alt="Logo"
        />
        <input
          placeholder="Email"
          class="input"
          type="email"
          v-model="form.email"
          :class="{ 'error-border': errors.email }"
        />
        <span v-if="errors.email" class="error-message">{{
          errors.email
        }}</span>

        <input
          placeholder="Password"
          class="input"
          type="password"
          v-model="form.password"
          :class="{ 'error-border': errors.password }"
        />
        <span v-if="errors.password" class="error-message">{{
          errors.password
        }}</span>

        <span v-if="errors.general" class="error-message general-error">
          {{ errors.general }}
        </span>

        <button class="submit btn" type="submit" :disabled="isLoading">
          <template v-if="isLoading">
            <span class="spinner"></span> currently logged in...
          </template>
          <template v-else> Login </template>
        </button>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import { useAuthStore } from "@admin/auth/stores/auth.store";
import { useRouter } from "vue-router";

const router = useRouter();
const authStore = useAuthStore();

const form = ref({
  email: "",
  password: "",
});

const errors = ref({
  email: "",
  password: "",
  general: "",
});

const isLoading = ref(false);

const handleLogin = async () => {
  try {
    isLoading.value = true;
    errors.value = {
      email: "",
      password: "",
      general: "",
    };

    await authStore.login({
      email: form.value.email,
      password: form.value.password,
    });

    // Redirect sau khi login thành công
    router.push({ name: "admin" });
  } catch (error: any) {
    if (error.response?.status === 422) {
      // Xử lý validation errors từ Laravel
      errors.value.email = error.response.data.errors?.email?.[0] || "";
      errors.value.password = error.response.data.errors?.password?.[0] || "";
    } else {
      errors.value.general =
        error.response?.data.message || "Login failed. Please try again.";
    }
  } finally {
    isLoading.value = false;
  }
};
</script>

<style scoped>
.logo {
  height: 100px;
}

::selection {
  background-color: #00bfff55;
}

.container {
  margin: 0 auto;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  overflow: hidden;
  position: relative;
}

.vinyl-form-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0;
  position: relative;
}

.vinyl {
  width: 300px;
  aspect-ratio: 1;
  background: black;
  border-radius: 50%;
  position: absolute;
  left: -190px;
  /* Half of vinyl width to shift it left */
  z-index: 5;
  box-shadow: 0 0 10px rgb(0, 0, 0);
}

.vinyl::before {
  content: "";
  position: absolute;
  top: 50%;
  left: 50%;
  width: 40px;
  height: 40px;
  background: #fff;
  border-radius: 50%;
  transform: translate(-50%, -50%);
}

/* Form login */
.form {
  width: 400px;
  padding: 2rem;
  background: rgba(7, 13, 20, 0.3);
  backdrop-filter: blur(10px);
  box-shadow: 8px 8px 25px #07abe273;
  display: flex;
  flex-direction: column;
  align-items: center;
  border-radius: 0.75rem;
  border: 1px solid #1f1f1f;
  z-index: 10;
  position: relative;
}

.title {
  color: #ffffff;
  font-size: 2rem;
  font-weight: bold;
  margin-bottom: 2rem;
  text-shadow: 0 0 8px #00ffffaa;
}

.input {
  margin: 0.75rem 0;
  padding: 0.75rem;
  width: 100%;
  background-color: #1e1e1e;
  color: #ffffff;
  border: 1px solid #2c2c2c;
  border-radius: 0.5rem;
  transition: border-color 0.3s, box-shadow 0.3s;
}

.input:focus {
  border-color: #00ffff;
  box-shadow: 0 0 10px #00ffff66;
  outline: none;
}

.btn {
  margin-top: 2rem;
  width: 100%;
  height: 3rem;
  background: linear-gradient(to right, #00bfff, #00ffff);
  color: black;
  font-weight: bold;
  border: none;
  border-radius: 0.5rem;
  cursor: pointer;
  box-shadow: 0 0 10px #00ffffaa;
  transition: all 0.3s ease-in-out;
}

.btn:hover {
  filter: brightness(1.2);
  box-shadow: 0 0 20px #00ffff;
}

@media (max-width: 768px) {
  .vinyl {
    width: 200px;
    left: -100px;
    /* Adjusted for smaller vinyl */
  }

  .form {
    width: 250px;
  }

  .vinyl-form-wrapper {
    flex-direction: column;
    gap: 1.5rem;
  }
}

.spinner {
  display: inline-block;
  width: 16px;
  height: 16px;
  margin-right: 8px;
  border: 2px solid #fff;
  border-top: 2px solid transparent;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  vertical-align: middle;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

</style>

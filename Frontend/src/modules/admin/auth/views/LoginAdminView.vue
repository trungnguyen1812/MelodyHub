<template>
  <div class="container">
    <div class="vinyl-form-wrapper">
      <div class="vinyl"></div>
      <form class="form">
        <img class="logo" src="@/assets/images/logo/melody-high-resolution-logo-white.png" alt="">
        <input placeholder="Username" class="input" type="text" />
        <input placeholder="Password" class="input" type="password" />
        <button class="submit btn" type="submit">Login</button>
      </form>
    </div>
  </div>
</template>

<style scoped>
.logo{
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
  left: -190px; /* Half of vinyl width to shift it left */
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
    left: -100px; /* Adjusted for smaller vinyl */
  }

  .form {
    width: 250px;
  }

  .vinyl-form-wrapper {
    flex-direction: column;
    gap: 1.5rem;
  }
}
</style>
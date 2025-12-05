<template>
  <div class="main">
    <div class="disc"></div>
    <div class="topSidebar">
      <img class="logo" src="@/assets/images/logo/melody-high-resolution-logo-white.png" alt="logoMelodyHub">
    </div>
    <div class="mainSidebar">
      <ul>
        <li><img src="@/assets/images/icon/dashboard.svg" alt="">Dashboard</li>
        <li><img src="@/assets/images/icon/customer.svg" alt=""> User Management</li>
        
        <!-- Fixed dropdown structure -->
        <li class="dropdown">
          <div class="menu-title">
            <img src="@/assets/images/icon/content.svg" alt=""> <span style="color: white;">Content Management</span>
            <span class="arrow">▼</span>
          </div>
          <ul class="submenu">
            <li><img src="@/assets/images/icon/songs.svg" alt=""> Songs</li>
            <li><img src="@/assets/images/icon/artist.svg" alt=""> Artists</li>
            <li><img src="@/assets/images/icon/album.svg" alt=""> Albums</li>
            <li><img src="@/assets/images/icon/Genres.png" alt=""> Genres</li>
          </ul>
        </li>
        
        <li><img src="@/assets/images/icon/heart.png" alt=""> Social interaction</li>
        <li><img src="@/assets/images/icon/playlist.svg" alt=""> Playlists manager</li>
        <li><img src="@/assets/images/icon/payment.svg" alt=""> Payment</li>
        <li><img src="@/assets/images/icon/deal.png" alt=""> Partner Management</li>
        <li><img src="@/assets/images/icon/ad.png" alt=""> Advertising</li>
      </ul>
    </div>
    <div class="bottomSidebar">
      <ul>
        <li class="setting">
          <img src="@/assets/images/icon/setting.svg" alt=""> 
          <span>Setting</span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>

</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Afacad&display=swap');
.main {
  width: 20%;
  height: 93%;
  margin: 2%;
  border-radius: 14px;
  background: rgba(255,255,255,0.08);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid rgba(0,170,255,0.65);
  font-family: 'Afacad', sans-serif;
  box-shadow:
    0 0 8px rgba(0,170,255,0.7),
    0 0 16px rgba(0,170,255,0.55),
    0 0 24px rgba(0,170,255,0.35),
    0 8px 25px rgba(0,0,0,0.45);
  animation: neonPulse 1.8s infinite ease-in-out;
  position: relative;
  overflow: hidden;

  display: flex;
  flex-direction: column;
}

/* ===============================
      BACKGROUND DISC
================================ */

.disc{
  position: absolute;
  width: 220px;
  height: 220px;
  border-radius: 50%;
  right: -60px;             
  bottom: -60px;
  background: radial-gradient(
    circle,
    #222 0%,
    #000 50%,
    #050505 100%
  );
  opacity: 0.65;             
  z-index: 1; 
  animation: spin 12s linear infinite;
}

.disc::after{
  content:'';
  position:absolute;
  top:50%;
  left:50%;
  transform:translate(-50%,-50%);
  width:20px;
  height:20px;
  border-radius:50%;
  background: white;
  border: 2px solid rgba(0,170,255,0.7);
  box-shadow: 0 0 8px rgba(0,170,255,0.6);
}

/* ===============================
      CONTENT SIDE BAR
================================ */

.topSidebar,
.mainSidebar,
.bottomSidebar{
  position: relative;
  z-index: 2;
  font-size:13pt;
}

.mainSidebar {
  top: 40px;
  height: calc(100% - 40px);
  overflow-y: auto;
  padding-right: 8px;
  flex: 1; /* Chiếm không gian còn lại */
}

.mainSidebar::-webkit-scrollbar {
  width: 6px;
}

.mainSidebar::-webkit-scrollbar-thumb {
  background-color: rgba(0, 170, 255, 0.6);
  border-radius: 3px;
}

.mainSidebar::-webkit-scrollbar-track {
  background: transparent;
}

.mainSidebar > ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.mainSidebar li {
  margin: 8px 20px;
  padding: 8px 15px;
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.mainSidebar li:hover {
  background: rgba(0, 170, 255, 0.15);
}


/* ===============================
      BOTTOM SIDEBAR - FIXED
================================ */

.bottomSidebar {
  width: 100%; /* Chiếm toàn bộ chiều rộng */
  padding: 10px 0;
  margin-top: auto; /* Đẩy xuống dưới cùng */
}

.bottomSidebar ul {
  list-style: none;
  padding: 0;
  margin: 0;
  width: 100%;
}

.bottomSidebar .setting {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 20px;
  margin: 20px ;
  width: 85%;
  cursor: pointer;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.bottomSidebar .setting:hover {
  background: rgba(0, 170, 255, 0.15);
}

.bottomSidebar .setting img {
  width: 20px;
  height: 20px;
}

/* Size logo */
.logo{
  width: 70%;
  max-width: 160px;
  margin: 1rem auto;
  display:block;
}

/* ===============================
        EFFECT
================================ */

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* ===============================
        Dropdown - FIXED
================================ */

.dropdown {
  position: relative;
  display: flex;
  flex-direction: column;
}

.menu-title {
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
  padding: 8px 15px;
}

.menu-title .arrow {
  margin-left: auto;
  font-size: 0.7rem;
  transition: transform 0.3s ease;
}

.dropdown:hover .menu-title .arrow {
  transform: rotate(180deg);
}

.submenu {
  list-style: none;
  padding: 0;
  margin: 0;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 8px;
  margin-top: 4px;
  margin-left: 40px;
  overflow: hidden;
  max-height: 0;
  opacity: 0;
  transform: translateY(-10px);
  transition: all 0.3s ease;
}

.dropdown:hover .submenu {
  max-height: 500px;
  opacity: 1;
  transform: translateY(0);
  display: block;
}

.submenu li {
  margin: 0;
  padding: 8px 15px;
  border-radius: 6px;
  transition: all 0.2s ease;
}

.submenu li:hover {
  background: rgba(0, 170, 255, 0.25);
  padding-left: 20px;
}

/* Neon animation for the sidebar */
@keyframes neonPulse {
  0%, 100% {
    box-shadow:
      0 0 8px rgba(0,170,255,0.7),
      0 0 16px rgba(0,170,255,0.55),
      0 0 24px rgba(0,170,255,0.35),
      0 8px 25px rgba(0,0,0,0.45);
  }
  50% {
    box-shadow:
      0 0 12px rgba(0,170,255,0.8),
      0 0 20px rgba(0,170,255,0.65),
      0 0 30px rgba(0,170,255,0.45),
      0 8px 30px rgba(0,0,0,0.5);
  }
}
</style>
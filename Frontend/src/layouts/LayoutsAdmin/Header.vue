<template>
    <header class="header">
        <!-- Left section: Menu button and logo -->
        <div class="header-left">
            <button class="menu-btn">
                <img src="@/assets/images/icon/menu.png" alt="Menu">
            </button>
            <div class="logo-section">
                <img class="logo-icon" src="@/assets/images/logo/melody-high-resolution-logo-white.png" alt="MelodyHub">
                <span class="logo-text">MELODYHUB</span>
            </div>
        </div>

        <!-- Center section: Search bar -->
        <div class="header-center">
            <div class="search-container">
                <img src="@/assets/images/icon/search.png" alt="Search" class="search-icon">
                <input 
                    type="text" 
                    class="search-input" 
                    placeholder="Search songs, artists, albums..."
                >
            </div>
        </div>

        <!-- Right section: User actions -->
        <div class="header-right">
            <button class="notification-btn">
                <img src="@/assets/images/icon/bell.png" alt="Notifications">
                <span class="notification-badge">3</span>
            </button>
            
            <button class="user-btn">
                <img src="@/assets/images/icon/user.png" alt="User" class="user-avatar">
                <div class="user-info">
                    <span class="user-name">Admin</span>
                    <span class="user-role">Administrator</span>
                </div>
                <img src="@/assets/images/icon/down.png" alt="Dropdown" class="dropdown-icon">
            </button>
        </div>
    </header>
</template>

<script setup lang="ts">

</script>

<style scoped>
.header {
    height: 70px;
    width: 98%;
    top: 20px;
    margin: 1%;
    border-radius: 14px;
    background: rgba(255,255,255,0.08);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    border: 1px solid rgba(0,170,255,0.65);
    box-shadow:
        0 0 8px rgba(0,170,255,0.7),
        0 0 16px rgba(0,170,255,0.55),
        0 0 24px rgba(0,170,255,0.35),
        0 8px 25px rgba(0,0,0,0.45);
    animation: neonPulse 1.8s infinite ease-in-out;
    
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 20px;
    position: relative;
    z-index: 10;
    font-family: 'Afacad', sans-serif;
}

/* Left section */
.header-left {
    display: flex;
    align-items: center;
    gap: 15px;
    flex: 1;
}

.menu-btn {
    background: transparent;
    border: 1px solid rgba(0,170,255,0.4);
    border-radius: 10px;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s ease;
}

.menu-btn:hover {
    background: rgba(0,170,255,0.15);
    border-color: rgba(0,170,255,0.8);
    box-shadow: 0 0 10px rgba(0,170,255,0.4);
}

.menu-btn img {
    width: 20px;
    height: 20px;
    filter: brightness(0) invert(1);
}

.logo-section {
    display: flex;
    align-items: center;
    gap: 10px;
}

.logo-icon {
    height: 32px;
    width: auto;
}

.logo-text {
    font-size: 1.5rem;
    font-weight: 700;
    background: white;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    text-shadow: 0 0 10px rgba(0,170,255,0.3);
}

/* Center section - Search */
.header-center {
    flex: 2;
    display: flex;
    justify-content: center;
}

.search-container {
    position: relative;
    width: 100%;
    max-width: 500px;
}

.search-icon {
    position: absolute;
    left: 15px;
    top: 50%;
    transform: translateY(-50%);
    width: 18px;
    height: 18px;
    filter: brightness(0) invert(0.7);
}

.search-input {
    width: 100%;
    height: 42px;
    padding: 0 20px 0 45px;
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(0,170,255,0.4);
    border-radius: 12px;
    color: white;
    font-size: 14px;
    font-family: 'Afacad', sans-serif;
    transition: all 0.3s ease;
}

.search-input:focus {
    outline: none;
    border-color: rgba(0,170,255,0.8);
    background: rgba(255,255,255,0.1);
    box-shadow: 0 0 15px rgba(0,170,255,0.3);
}

.search-input::placeholder {
    color: rgba(255,255,255,0.5);
}

/* Right section */
.header-right {
    display: flex;
    align-items: center;
    gap: 20px;
    flex: 1;
    justify-content: flex-end;
}

.notification-btn {
    position: relative;
    background: transparent;
    border: 1px solid rgba(0,170,255,0.4);
    border-radius: 10px;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s ease;
}

.notification-btn:hover {
    background: rgba(0,170,255,0.15);
    border-color: rgba(0,170,255,0.8);
    box-shadow: 0 0 10px rgba(0,170,255,0.4);
}

.notification-btn img {
    width: 20px;
    height: 20px;
    filter: brightness(0) invert(1);
}

.notification-badge {
    position: absolute;
    top: -5px;
    right: -5px;
    background: #ff4757;
    color: white;
    font-size: 10px;
    font-weight: bold;
    width: 18px;
    height: 18px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 2px solid rgba(0,170,255,0.65);
}

.user-btn {
    display: flex;
    align-items: center;
    gap: 12px;
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(0,170,255,0.4);
    border-radius: 12px;
    padding: 6px 15px;
    cursor: pointer;
    transition: all 0.3s ease;
}

.user-btn:hover {
    background: rgba(0,170,255,0.15);
    border-color: rgba(0,170,255,0.8);
    box-shadow: 0 0 15px rgba(0,170,255,0.3);
}

.user-avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    border: 2px solid rgba(0,170,255,0.6);
}

.user-info {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}

.user-name {
    color: white;
    font-weight: 600;
    font-size: 14px;
}

.user-role {
    color: rgba(255,255,255,0.6);
    font-size: 11px;
    margin-top: 2px;
}

.dropdown-icon {
    width: 16px;
    height: 16px;
    filter: brightness(0) invert(0.6);
    transition: transform 0.3s ease;
}

.user-btn:hover .dropdown-icon {
    transform: rotate(180deg);
}

/* Neon pulse animation */

/* Responsive adjustments */
@media (max-width: 1200px) {
    .header-center {
        flex: 1.5;
    }
    
    .search-container {
        max-width: 400px;
    }
}

@media (max-width: 768px) {
    .header {
        padding: 0 15px;
    }
    
    .logo-text {
        display: none;
    }
    
    .search-container {
        max-width: 300px;
    }
    
    .user-info {
        display: none;
    }
    
    .user-btn {
        padding: 6px 10px;
    }
}
</style>
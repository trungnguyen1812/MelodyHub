<template>
  <section class="px-6 py-8">
    <!-- Header -->
    <div class="flex items-center justify-between mb-8">
      <div>
        <h2 class="text-3xl font-bold text-white mb-1 bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent">
          Music Categories
        </h2>
        <p class="text-gray-400 text-sm">A collection of music genres you might like</p>
      </div>
    </div>

    <!-- Asymmetric Grid Layout -->
    <div class="grid-container">
      <!-- Classic - Large focal point -->
      <div class="music-card classic" @click="selectCategory('classic')">
        <div class="music-label">Classic</div>
        <div class="overlay"></div>
      </div>

      <!-- Hip Hop - Medium vertical -->
      <div class="music-card hiphop" @click="selectCategory('hiphop')">
        <div class="music-label">Hip Hop</div>
        <div class="overlay"></div>
      </div>

      <!-- Jazz - Tall and narrow -->
      <div class="music-card jazz" @click="selectCategory('jazz')">
        <div class="music-label">Jazz</div>
        <div class="overlay"></div>
      </div>

      <!-- Rock - Square -->
      <div class="music-card rock" @click="selectCategory('rock')">
        <div class="music-label">Rock</div>
        <div class="overlay"></div>
      </div>

      <!-- Electronic - Wide -->
      <div class="music-card electronic" @click="selectCategory('electronic')">
        <div class="music-label">Electronic</div>
        <div class="overlay"></div>
      </div>

      <!-- Pop - Medium -->
      <div class="music-card pop" @click="selectCategory('pop')">
        <div class="music-label">Pop</div>
        <div class="overlay"></div>
      </div>

      <!-- R&B - Small square -->
      <div class="music-card rnb" @click="selectCategory('rnb')">
        <div class="music-label">R&B</div>
        <div class="overlay"></div>
      </div>

      <!-- Country - Rectangle -->
      <div class="music-card country" @click="selectCategory('country')">
        <div class="music-label">Country</div>
        <div class="overlay"></div>
      </div>

      <!-- Reggae - Unusual shape -->
      <div class="music-card reggae" @click="selectCategory('reggae')">
        <div class="music-label">Reggae</div>
        <div class="overlay"></div>
      </div>

      <!-- All Types - Gradient button -->
      <div class="gradient-card all-types" @click="selectCategory('all')">
        <span class="text-lg font-bold">All Types</span>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: "Vclist_Categories",
  methods: {
    selectCategory(category) {
      // Emit event hoặc handle category selection
      this.$emit("category-selected", category);
      console.log("Selected category:", category);
    },
  },
};
</script>

<style scoped>
.grid-container {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  grid-template-rows: repeat(10, 50px);
  gap: 16px;
  max-width: 1400px;
  margin: 0 auto;
}

.music-card {
  position: relative;
  border-radius: 20px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}

.music-card:hover {
  transform: scale(1.05) rotate(1deg);
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5);
  z-index: 10;
}

.overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    135deg,
    rgba(0, 0, 0, 0.3) 0%,
    rgba(0, 0, 0, 0.7) 100%
  );
  transition: opacity 0.3s ease;
}

.music-card:hover .overlay {
  opacity: 0.9;
  background: linear-gradient(
    135deg,
    rgba(139, 69, 19, 0.4) 0%,
    rgba(0, 0, 0, 0.8) 100%
  );
}

.music-label {
  position: absolute;
  bottom: 16px;
  left: 16px;
  color: white;
  font-weight: 700;
  font-size: 16px;
  z-index: 20;
  text-shadow: 0 4px 8px rgba(0, 0, 0, 0.8);
  text-transform: uppercase;
  letter-spacing: 1px;
}

/* Grid positions - Asymmetric layout */
.classic {
  grid-column: 1 / 6;
  grid-row: 1 / 5;
  background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.6)),
    url("@/assets/images/music_type/classicjpg.jpg");
}

.hiphop {
  grid-column: 6 / 9;
  grid-row: 1 / 3;
  background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.6)),
    url("@/assets/images/music_type/hiphop.jpg");
}

.jazz {
  grid-column: 9 / 11;
  grid-row: 1 / 6;
  background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.6)),
    url("@/assets/images/music_type/jazz(1).jpg");
}

.rock {
  grid-column: 11 / 13;
  grid-row: 1 / 4;
  background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.6)),
    url("@/assets/images/music_type/rock.jpg");
}

.electronic {
  grid-column: 1 / 4;
  grid-row: 5 / 7;
  background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.6)),
    url("@/assets/images/music_type/ELECTRONIC.jpg");
}

.pop {
  grid-column: 4 / 7;
  grid-row: 5 / 8;
  background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.6)),
    url("@/assets/images/music_type/poster-am-nhac-an-tuong.jpg");
}

.rnb {
  grid-column: 7 / 9;
  grid-row: 6 / 8;
  background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.6)),
    url("@/assets/images/music_type/r&b.jpg");
}

.country {
  grid-column: 11 / 13;
  grid-row: 4 / 6;
  background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.6)),
    url("@/assets/images/music_type/COUNTRY.jpg");
}

.reggae {
  grid-column: 1 / 5;
  grid-row: 7 / 9;
  background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.6)),
    url("@/assets/images/music_type/Reggae.jpg");
}

.gradient-card {
  grid-column: 9 / 12;
  grid-row: 7 / 9;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.4s ease;
  position: relative;
  overflow: hidden;
}

.gradient-card::before {
  content: "";
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(
    45deg,
    transparent,
    rgba(255, 255, 255, 0.1),
    transparent
  );
  transform: rotate(45deg);
  transition: all 0.6s;
  opacity: 0;
}

.gradient-card:hover::before {
  animation: shimmer 1.5s ease-in-out infinite;
  opacity: 1;
}

.gradient-card:hover {
  transform: scale(1.08) rotate(-3deg);
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 50%, #4facfe 100%);
}

@keyframes shimmer {
  0% {
    transform: translateX(-100%) translateY(-100%) rotate(45deg);
  }
  100% {
    transform: translateX(100%) translateY(100%) rotate(45deg);
  }
}

/* Responsive design */
@media (max-width: 1024px) {
  .grid-container {
    grid-template-columns: repeat(8, 1fr);
    grid-template-rows: repeat(12, 45px);
  }

  .classic {
    grid-column: 1 / 5;
    grid-row: 1 / 4;
  }
  .hiphop {
    grid-column: 5 / 7;
    grid-row: 1 / 3;
  }
  .jazz {
    grid-column: 7 / 9;
    grid-row: 1 / 5;
  }
  .rock {
    grid-column: 1 / 3;
    grid-row: 4 / 6;
  }
  .electronic {
    grid-column: 3 / 6;
    grid-row: 4 / 6;
  }
  .pop {
    grid-column: 6 / 9;
    grid-row: 5 / 7;
  }
  .rnb {
    grid-column: 1 / 3;
    grid-row: 6 / 8;
  }
  .country {
    grid-column: 3 / 5;
    grid-row: 6 / 8;
  }
  .reggae {
    grid-column: 5 / 8;
    grid-row: 7 / 9;
  }
  .gradient-card {
    grid-column: 1 / 4;
    grid-row: 8 / 10;
  }
}

@media (max-width: 768px) {
  .grid-container {
    grid-template-columns: repeat(4, 1fr);
    grid-template-rows: repeat(20, 40px);
    gap: 12px;
  }

  .classic {
    grid-column: 1 / 5;
    grid-row: 1 / 5;
  }
  .hiphop {
    grid-column: 1 / 3;
    grid-row: 5 / 7;
  }
  .jazz {
    grid-column: 3 / 5;
    grid-row: 5 / 8;
  }
  .rock {
    grid-column: 1 / 3;
    grid-row: 7 / 9;
  }
  .electronic {
    grid-column: 3 / 5;
    grid-row: 8 / 10;
  }
  .pop {
    grid-column: 1 / 3;
    grid-row: 9 / 11;
  }
  .rnb {
    grid-column: 3 / 5;
    grid-row: 10 / 12;
  }
  .country {
    grid-column: 1 / 3;
    grid-row: 11 / 13;
  }
  .reggae {
    grid-column: 3 / 5;
    grid-row: 12 / 14;
  }
  .gradient-card {
    grid-column: 1 / 5;
    grid-row: 14 / 16;
  }
}
</style>

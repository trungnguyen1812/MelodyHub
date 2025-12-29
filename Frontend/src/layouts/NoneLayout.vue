<template >
     <div class="">
          <router-view />
     </div>
     
</template>
<script setup lang="ts">

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


.container {
  width: 120%;
  margin: 0 auto;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  overflow: hidden;
  position: relative;
  background: linear-gradient(135deg, #0a0e1a 0%, #1a0a1f 50%, #0a1a1f 100%);
}
</style>
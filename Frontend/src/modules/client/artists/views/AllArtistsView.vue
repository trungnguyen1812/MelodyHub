<template>
    <Vclist_Artists :artists="dataArtist" />
</template>

<script setup>
    //import components
    import Vclist_Artists from '@/components/common/VcList/Vclist_Artists.vue';

    //import data
    import dataArtist  from '@/common/data/artists';
</script>

<style scoped>
/* CSS giữ nguyên như bạn có */
</style>

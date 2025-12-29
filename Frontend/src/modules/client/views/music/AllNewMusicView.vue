<template>
    <Vclist_Music :newMusics ="dataSong" />
</template>

<script setup>
    //import components
    import Vclist_Music from '@/components/common/VcList/Vclist_new_music.vue';

    //import data
    import dataSong  from '@/common/data/songs';
</script>

<style scoped>
/* CSS giữ nguyên như bạn có */
</style>

<template>
    <Vclist_popular :populars="dataPopular"/>
</template>

<script setup>
    //import components
    import Vclist_popular from '@/components/common/VcList/Vclist_popular.vue';

    //import data
    import dataPopular from '@/common/data/popular';
</script>

<style scoped>
/* CSS giữ nguyên như bạn có */
</style>

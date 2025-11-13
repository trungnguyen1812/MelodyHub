# vue-project

This template should help get you started developing with Vue 3 in Vite.

## Recommended IDE Setup

[VSCode](https://code.visualstudio.com/) + [Volar](https://marketplace.visualstudio.com/items?itemName=Vue.volar) (and disable Vetur).

## Customize configuration

See [Vite Configuration Reference](https://vite.dev/config/).

## Project Setup

```sh
npm install
```

### Compile and Hot-Reload for Development

```sh
npm run dev
```

### Compile and Minify for Production

```sh
npm run build
```

<!-- cấu trúc của frontend  -->
src/
 ├─ store/
 │   └─ authStore.js
 ├─ services/
 │   └─ api.js
 ├─ plugins/
 │   └─ axios.js
 └─ views / components ...

<!-- cấu trúc của gọi dữ liệu từ backend sang frontend -->

<script setup lang="ts">
import { ref, onMounted } from "vue";
import { getHello, getUsers } from "@/services/api";

const messageHello = ref<string>("");
const messageUser = ref<string>("");
onMounted(async () => {
  try {
    const hello = await getHello();
    messageHello.value = hello.data.message;
    const user = await getUsers();
    messageUser.value = user.data.message;
  } catch (error) {
    console.error("API Error:", error);
  }
});
</script>

<template>
  <h1>Test API Hello:</h1>
  <h1>{{ messageHello }}</h1>
  <hr>
  <h1>Test API user:</h1>
  <h1>{{ messageUser }}</h1>
</template>
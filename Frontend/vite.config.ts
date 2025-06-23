import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
      '@client': path.resolve(__dirname, './src/modules/client'),
      '@admin': path.resolve(__dirname, './src/modules/admin'),
    }
  },
  server: {
    proxy: {
      "/api": {
        target: "http://localhost:8000",
        changeOrigin: true,
        secure: false,
      },
      "/sanctum": {
        target: "http://localhost:8000",
        changeOrigin: true,
        secure: false,
      },
    },
  },
})
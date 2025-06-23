// src/types/http.type.ts
import type { AxiosInstance, InternalAxiosRequestConfig } from 'axios'

declare module 'axios' {
  interface AxiosRequestConfig {
    // Thêm custom config nếu cần
    silent?: boolean // Ví dụ: không hiển thị lỗi
  }
}

export type HttpClient = AxiosInstance
export type HttpRequestConfig = InternalAxiosRequestConfig
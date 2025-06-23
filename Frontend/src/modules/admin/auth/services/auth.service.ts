// src/modules/admin/auth/services/auth.service.ts
import http from '@/utils/http'
import type { 
  LoginCredentials,
  LoginResponse,
  User
} from '../interfaces/auth.interface'

export const AuthService = {
  async login(credentials: LoginCredentials): Promise<LoginResponse> {
    await http.get('/sanctum/csrf-cookie')
    const response = await http.post<LoginResponse>('/api/admin/login', credentials)
    return response.data
  },

  async getCurrentUser(): Promise<User> {
    const response = await http.get<User>('/api/admin/user')
    return response.data
  },

  async logout(): Promise<void> {
    await http.post('/api/admin/logout')
  }
}
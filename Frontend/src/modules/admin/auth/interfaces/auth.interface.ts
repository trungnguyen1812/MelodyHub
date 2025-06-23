export interface AuthState {
    user: User | null;
    isAuthenticated: boolean;
    token: string | null; // Không được là optional (?)
}

export interface User {
    id: number;
    name: string;
    email: string;
    role: string;
}

export interface LoginCredentials {
    email: string;
    password: string;
}

export interface LoginResponse {
    token: string;
    user: User;
}
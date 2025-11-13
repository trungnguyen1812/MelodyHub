import api from "@/plugins/axios";

export const getHello = () => api.get<{ message: string }>("/hello");
export const getUsers = () => api.get("/users");

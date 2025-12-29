import { defineStore } from "pinia";
import UserService from "@/modules/admin/services/user/user.service";
import userService from "@/modules/admin/services/user/user.service";
import {UserInterface} from '@/modules/admin/interfaces/users/user.interface';



export const useUserStore = defineStore("user", {
    state: () => ({
        profile: null as UserInterface | null,
        users: [] as UserInterface[],
        loading: false,
    }),

    getters: {
        isProfileLoaded: (state) => !!state.profile,
    },

    actions: {
        async fetchUsers() {
            this.loading = true;
            const data = await userService.getAllUser();
            this.users = data.users.map((u: any) => ({
                ...u,
                role: u.roles?.[0] ?? null 
            }));
            this.loading = false;
        },
    },
});

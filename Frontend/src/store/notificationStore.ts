import { defineStore } from "pinia";

interface NotificationState {
  message: string;
  type: "success" | "error" | "";
}

export const useNotificationStore = defineStore("notification", {
  state: (): NotificationState => ({
    message: "",
    type: "",
  }),
  actions: {
    notify(msg: string, type: "success" | "error" = "success") {
      this.message = msg;
      this.type = type;
    },
    clear() {
      this.message = "";
      this.type = "";
    },
  },
});
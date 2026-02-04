import { defineStore } from "pinia";

type NotificationType = "success" | "error" | "cancel" | "info" | "";

interface NotificationState {
  message: string;
  type: NotificationType;
}

export const useNotificationStore = defineStore("notification", {
  state: (): NotificationState => ({
    message: "",
    type: "",
  }),

  actions: {
    notify(
      msg: string,
      type: NotificationType = "success"
    ) {
      this.message = msg;
      this.type = type;
    },

    success(msg: string) {
      this.notify(msg, "success");
    },

    error(msg: string) {
      this.notify(msg, "error");
    },

    cancel(msg: string) {
      this.notify(msg, "cancel");
    },

    info(msg: string) {
      this.notify(msg, "info");
    },

    clear() {
      this.message = "";
      this.type = "";
    },
  },
});
